#!/usr/bin/env bash
# Checks every skill under skills/: frontmatter, name, description length, body size and relative links.
# Usage: scripts/validate.sh   (exits non-zero on any error; warnings don't fail)
set -euo pipefail
cd "$(dirname "$0")/.."

errors=0
warnings=0
err() { echo "error: $*"; errors=$((errors + 1)); }
warn() { echo "warning: $*"; warnings=$((warnings + 1)); }

for dir in skills/*/; do
  dir="${dir%/}"
  folder="$(basename "$dir")"
  file="$dir/SKILL.md"
  [ -f "$file" ] || { err "$dir has no SKILL.md"; continue; }

  [ "$(head -n1 "$file")" = "---" ] || { err "$file doesn't start with frontmatter (---)"; continue; }
  frontmatter="$(awk 'NR == 1 { next } /^---$/ { exit } { print }' "$file")"

  name="$(sed -n 's/^name: *//p' <<<"$frontmatter" | head -n1)"
  [ -n "$name" ] || err "$file has no name"
  [ "$name" = "$folder" ] || err "$file: name '$name' doesn't match its folder '$folder'"
  [[ "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || err "$file: name '$name' isn't lowercase kebab-case"
  [ "${#name}" -le 64 ] || err "$file: name is longer than 64 characters"

  # The description may wrap onto indented continuation lines.
  description="$(awk '/^description:/ { sub(/^description: */, ""); d = $0; on = 1; next }
    on && /^[ \t]+/ { sub(/^[ \t]+/, " "); d = d $0; next } { on = 0 } END { print d }' <<<"$frontmatter")"
  [ -n "$description" ] || err "$file has no description"
  [ "${#description}" -le 1024 ] || err "$file: description is ${#description} characters (max 1024)"
  grep -qi "use when\|use it when\|use for" <<<"$description" || warn "$file: description doesn't say when to use it"

  lines="$(wc -l <"$file" | tr -d ' ')"
  [ "$lines" -le 300 ] || warn "$file is $lines lines; move detail into references/"

  # Every relative path in backticks or a markdown link that looks like a file in the skill must exist.
  while IFS= read -r ref; do
    [ -e "$dir/$ref" ] || err "$file links to $ref, which doesn't exist"
  done < <(grep -oE '(`|\()(references|templates|scripts)/[A-Za-z0-9._/-]+' "$file" | cut -c2- | sort -u)
done

echo "$(ls -d skills/*/ 2>/dev/null | wc -l | tr -d ' ') skills, $errors errors, $warnings warnings"
[ "$errors" -eq 0 ]
