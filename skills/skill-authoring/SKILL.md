---
name: skill-authoring
description: Create, improve or review a Claude Code skill in this repo, from the idea to a tested SKILL.md with its
  references and templates. Use when someone says "make a skill", "new skill", "turn this into a skill", "this
  skill doesn't trigger" or "improve the X skill", or picks an item from the repo's skill backlog. Not for writing
  project instructions that belong in a repo's CLAUDE.md.
---

# Skill authoring

Turns a repeated procedure into a skill that loads when it should, stays quiet when it shouldn't, and produces work
a strong engineer would sign off on. The full standard is in `references/creating-skills.md`. Read it before writing
the first skill in a session.

Work in the skills repo (the folder with `.claude-plugin/plugin.json` and `skills/`). If the current directory isn't
it, ask where the clone is.

## Procedure

1. **Pin down the job.** Ask, unless the request already says: what the skill should produce, two or three real
   prompts that should trigger it, and one that shouldn't. If the user is vague, draft these yourself and confirm.
2. **Check for overlap.** List `skills/` and read the descriptions of any neighbours. If one already covers most of
   it, extend that skill instead of adding another.
3. **Scaffold.** Copy this skill's `templates/SKILL.md` to `skills/<name>/SKILL.md` in the repo. The name is lowercase
   kebab-case and matches the folder.
4. **Write the description first.** What it produces, the trigger words and situations, and what it isn't for. Under
   about 1,000 characters.
5. **Write the body.** Procedure with decision points, the standard as short checkable rules, one realistic example
   of the output, the common failures, and a done check. Keep it under about 250 lines. Move long checklists,
   syntax guides and big examples to `references/`, each linked with a line that says when to read it.
6. **Add templates** for any document the skill produces, with `<placeholders>` and a comment per section.
7. **Validate.** Run `./scripts/validate.sh` from the repo root and fix every error.
8. **Test triggering.** Tell the user to reinstall or reload the plugin (`/plugin` → update, or restart the session
   when installed from a local path) and try the should and shouldn't prompts. If it misfires, change the
   description.
9. **Bump the version** in `.claude-plugin/plugin.json` (patch for fixes, minor for a new skill) and add a line to
   the README's skill table.

## Improving an existing skill

- **It doesn't trigger:** the description is missing the words people use. Add them, plus the situation ("after an
  outage").
- **It triggers for the wrong thing:** add a "Not for …; use … instead" clause and remove broad words.
- **The output is weak:** find the step where it went wrong and add the missing rule or a better example there.
  Don't add general advice.
- **It's too long:** move detail to `references/`. The procedure and standard stay in `SKILL.md`.

## Example description

Weak:

```yaml
description: Helps with diagrams.
```

Strong:

```yaml
description: Draw architecture and flow diagrams as Mermaid code: C4 context and container views, sequence
  diagrams, data flows, ERDs and state machines, each answering one question with labelled arrows and trust
  boundaries. Use when someone asks to diagram, draw or visualise a system, a request flow or a schema, or says
  "C4", "sequence diagram" or "ERD". Not for UI mockups.
```

## Done check

- [ ] `./scripts/validate.sh` passes.
- [ ] The description names what it produces, its triggers and what it isn't for.
- [ ] The body has a procedure, a standard, an example, common failures and a done check.
- [ ] Every file in `references/` and `templates/` is linked from `SKILL.md`.
- [ ] Version bumped and the README table updated.
