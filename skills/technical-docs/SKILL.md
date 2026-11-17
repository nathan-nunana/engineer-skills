---
name: technical-docs
description: Write or review engineering documentation: READMEs, ADRs (architecture decision records), runbooks, API reference, changelogs in Keep a Changelog format, how-to guides, tutorials and onboarding docs. Decides what kind of doc is needed with the Diataxis split, then produces it from a template. Use when someone says "write docs", "README", "ADR", "runbook", "changelog", "onboarding doc", "document this", or asks to review or tidy a doc. Not for design docs or RFCs; use system-design. Not for diagrams; use architecture-diagrams.
---

# Technical docs

Produce docs that a reader can act on without asking the author. Decide what kind of doc it is first, then write only
what that kind needs.

## Procedure

1. **Find the reader and the moment.** Who opens this doc, what are they trying to do, and what do they already know?
   If the user hasn't said, pick the most likely reader (a new teammate, an on-call engineer at 3am, an API consumer)
   and state the assumption at the top of your reply.
2. **Classify the doc (Diataxis).** Pick exactly one. If the request mixes kinds, split it into separate docs or
   separate sections that link to each other.

   | Kind | Reader's need | Shape | Example |
   |---|---|---|---|
   | Tutorial | Learn by doing | A guided path with one safe outcome | "Build your first plugin" |
   | How-to | Get a task done | Numbered steps, assumes basic knowledge | "Rotate the API key" |
   | Reference | Look up a fact | Dry, complete, structured like the code | CLI flags, config keys, endpoints |
   | Explanation | Understand why | Prose with context, trade-offs, history | "Why we use event sourcing" |

3. **Pick the format.**
   - Project entry point: README, `templates/README.md`.
   - A decision that is hard to reverse or will be questioned later: ADR, `templates/adr.md`.
   - Something that breaks, with a person under stress: runbook, `templates/runbook.md`.
   - What changed between releases: changelog, `templates/changelog.md`.
   - Endpoints, functions, config: reference. Generate it from code (OpenAPI, rustdoc, docstrings) when possible and
     hand-write only the parts that need judgement: auth, errors, pagination, examples.
   - Getting a new person productive: onboarding doc. This is a how-to sequence (accounts, clone, run, first change)
     plus a short explanation of the system and a list of who to ask.
4. **Gather facts from the source.** Read the code, config and CI. Run the commands you are about to document. Never
   document a command you haven't seen work or that you can't verify; mark it `<unverified>` and say so.
5. **Write from the template.** Copy it, fill every section, delete sections that don't apply instead of leaving
   them empty.
6. **Review against the Standard and the Done check** below. When reviewing someone else's doc, list findings by
   severity: wrong (reader will fail), missing (reader must guess), noisy (reader must skip).

## Standard

Style:
- Plain words. Short sentences. One idea per paragraph. Prefer "use" to "utilize", "start" to "initiate".
- Task-first headings: "Rotate the API key", not "Key rotation overview". Put the answer or the first step under the
  heading, not a preamble.
- Every command is copy-pasteable: no `$` prompt prefix, no unexplained placeholders (write `<project-id>` and say
  where to find it), one command per code block unless they run together.
- After each step, say what the reader should see: expected output, a status code, a UI state. Say what to do if they
  don't see it.
- State versions, OS and prerequisites up front. Pin them where it matters.
- Use the same term for the same thing everywhere. Define a term once at first use.
- Links: relative paths inside the repo, descriptive link text ("the deploy runbook", not "here").
- Dates are absolute (2026-03-04), never "last month". Say "as of <version>" for facts that rot.

By kind:
- README: what it is in one sentence, how to run it in under five minutes, where to go next. No history, no
  badges wall, no full API.
- ADR: one decision per file, numbered, never edited after acceptance except status. Supersede with a new ADR. Record
  the options rejected and why, since that is the part people lose.
- Runbook: starts from a symptom or alert name. Check, then fix, then verify, then escalate. Includes how to roll
  back. Written so someone who has never seen the system can follow it.
- Changelog: Keep a Changelog. Sections Added, Changed, Deprecated, Removed, Fixed, Security. Written for users, not
  from commit messages. Newest first, `Unreleased` on top, version links at the bottom.
- API reference: every field has type, required or optional, default, constraints. Every endpoint has a request and
  a response example that was actually run, plus the error shapes.

## Example

Weak:

> ## Database
> The database can be set up in several ways. You may want to configure it depending on your needs.

Good:

> ## Run the database locally
>
> Requires Docker 24 or later.
>
> 1. Start Postgres:
>    ```bash
>    docker compose up -d db
>    ```
>    `docker compose ps` should show `db` as `healthy` within 10 seconds.
> 2. Apply migrations:
>    ```bash
>    make migrate
>    ```
>    The last line reads `applied 14 migrations`. If it reads `connection refused`, the container is still starting;
>    wait and rerun.

## Common failures

- **README that is an essay:** move background to an explanation doc, keep the README to what, run, next.
- **Mixed kinds:** a how-to that stops to explain architecture. Link to the explanation instead.
- **Commands that only work on the author's machine:** hidden env vars, absolute paths, tools not listed in
  prerequisites. Run them in a clean checkout or container.
- **ADR with no alternatives:** reads as a justification. Add the options considered and why each lost.
- **Runbook that says "investigate":** replace with the exact query, dashboard link or command and what a bad result
  looks like.
- **Changelog that is a commit dump:** group by user-visible effect and drop internal refactors.
- **Stale docs:** put the doc next to the code it describes and name the file or command that would change it.

## Done check

- [ ] The doc is one Diataxis kind, or clearly split into linked parts.
- [ ] The first screen tells the reader what this is and whether it is for them.
- [ ] Every command was run or is marked `<unverified>`.
- [ ] Each step says what the reader sees afterwards.
- [ ] No unexplained placeholders, jargon or "simply" and "just".
- [ ] Headings are tasks or questions the reader has.
- [ ] Links resolve; dates are absolute; versions are stated.
- [ ] Owner or review trigger is noted for runbooks and READMEs.

Templates: `templates/README.md`, `templates/adr.md`, `templates/runbook.md`, `templates/changelog.md`. For a
diagram inside a doc, use the architecture-diagrams skill. For a larger design proposal that ends in an ADR, use
system-design.
