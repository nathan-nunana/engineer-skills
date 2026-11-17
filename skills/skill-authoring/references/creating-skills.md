# Creating a skill

A skill is a folder with a `SKILL.md` file. Claude reads every skill's `name` and `description` at the start of a
session, and loads the rest of the file only when a request matches the description. Anything else in the folder
(references, templates, scripts) is read only when `SKILL.md` points to it.

That loading order drives every rule below: the description decides whether the skill is used at all, `SKILL.md`
decides what Claude does next, and the extra files hold detail that would waste context if it loaded every time.

## When a skill is worth writing

Write one when at least one of these holds:

- You've explained the same procedure to Claude more than twice.
- There's a house style or standard Claude can't guess (your ADR format, your team's definition of done).
- The task needs a checklist that's easy to skip under pressure (a security review, a release).
- There's a template you'd otherwise paste in by hand.

Don't write one for something Claude already does well with no help, or for a fact that belongs in a project's
`CLAUDE.md` (a build command, a repo layout). Skills are for procedures and judgement that apply across projects.

## Layout

```
skills/<name>/
├── SKILL.md          required: frontmatter, then the procedure
├── references/       optional: detail read on demand (checklists, syntax guides, long examples)
├── templates/        optional: files to copy and fill in (an ADR, a postmortem)
└── scripts/          optional: code the skill runs, rather than code Claude retypes each time
```

- `<name>` is lowercase kebab-case, at most 64 characters, and matches the `name` field exactly.
- Keep `SKILL.md` under about 250 lines. Past that, move detail into `references/` and link to it by relative path
  with a line that says when to read it: "For the full OWASP checklist, read `references/owasp.md`."
- One level of references. A reference that sends Claude to another reference gets skipped.
- Paths inside a skill are relative to the skill's folder (`references/x.md`). Write a path in the repo root with
  a leading `./` (`./scripts/validate.sh`) so the validator doesn't look for it inside the skill.

## Frontmatter

```yaml
---
name: incident-response
description: Run or support a production incident and write its postmortem: severity, roles, a timeline, comms
  updates, mitigation before root cause, then a blameless postmortem with action items. Use when something is down
  or degraded, when someone says "incident", "outage", "sev1", "on call" or "postmortem", or asks how to handle a
  page.
---
```

Only `name` and `description` are required. Optional fields:

- `allowed-tools`: tools the skill may use without asking, such as `Read, Grep, Bash(git log:*)`.
- `disable-model-invocation: true`: the skill runs only when you type `/name`, never by itself. Use it for
  anything with side effects you want to start by hand.

## The description is the trigger

Claude picks skills by the description alone, so most broken skills have a weak one. A good description:

1. **Says what the skill produces**, in concrete nouns: "a design doc with options, trade-offs and a decision", not
   "helps with design".
2. **Lists the triggers**: the words people actually type ("diagram", "C4", "sequence diagram", "draw the
   architecture"), the situations ("before a sprint", "after an outage") and the file types.
3. **Says what it isn't for** when a neighbouring skill is close: "Not for writing the code; for reviewing it, use
   code-review."
4. Stays under about 1,000 characters. Every skill's description loads every session.

Write it in the third person ("Run…", "Use when…"), never "I can help you…".

## The body

Write it for a capable engineer who has never seen your team: the steps, the decisions, the standard.

- **Lead with the procedure.** A numbered list of what to do, in order, with the decision points written out
  ("If the change touches auth, also do X").
- **Give the standard, not the theory.** "Every action item has an owner and a date" beats a paragraph on why
  postmortems matter.
- **Show one good example** of the output: a filled-in story, a short diagram, a sample status update. One example
  teaches more than a page of rules.
- **Name the failure modes** you've seen: what a weak version looks like and how to fix it.
- **Say what to ask the user** and when to just pick a sensible default and say so.
- **End with a check**: a short list Claude runs through before calling the work done.

Avoid long background sections, motivational intros, and rules Claude already follows (write clearly, be accurate).

## Templates and scripts

- A template is a file to copy, with `<placeholders>` and a one-line comment for each section on what goes there.
- Prefer a script over prose for anything mechanical and exact (a validator, a scaffold generator). Say in
  `SKILL.md` how to run it and what it prints.

## Testing a skill

1. Run `./scripts/validate.sh` from the repo root. It checks names, frontmatter, description length and broken reference links.
2. Install the plugin locally (see the README) and start a new session. Skills load at session start.
3. **Trigger tests.** Try three prompts that should load it, worded the way you'd really type them, and two that
   shouldn't (a near neighbour's request). If it misfires, fix the description, not the body.
4. **Output test.** Run one real task through it and compare the result to what a strong engineer would hand in.
   Fix the body where it falls short. Add the missing rule or a better example.
5. Ask Claude, in the session where the skill ran, which parts of the skill it followed and which were unclear.

## Changing a skill

- Bump `version` in `.claude-plugin/plugin.json` when skills change, so installs pick up the update.
- Keep a skill's `name` stable. Renaming it breaks anyone who calls it with `/name`.
- When two skills start to overlap, merge them or sharpen both descriptions so each says what the other covers.

## Checklist

- [ ] Folder name equals `name`, kebab-case.
- [ ] Description says what it produces, when to use it, and what it isn't for.
- [ ] `SKILL.md` starts with the procedure and ends with a done check.
- [ ] At least one concrete example of good output.
- [ ] Detail over ~250 lines moved to `references/`, each linked with when to read it.
- [ ] `./scripts/validate.sh` passes.
- [ ] Three should-trigger and two shouldn't-trigger prompts behave.
