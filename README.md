# Engineer skills

Claude Code skills for the parts of software engineering that aren't writing code: documentation, architecture
diagrams, system design, security review, code review, testing strategy, incidents, Scrum and communication.

The repo is a Claude Code plugin and its own marketplace, so one install gives you every skill, and Claude loads each
one only when a request calls for it.

## Install

From GitHub:

```sh
claude plugin marketplace add nathan-nunana/engineer-skills
claude plugin install engineer@engineer-skills
```

From a local clone, to try changes before pushing:

```sh
claude plugin marketplace add ~/Projects/engineer-skills
claude plugin install engineer@engineer-skills
```

Skills load at session start, so restart Claude Code after installing or updating. To update later, run
`claude plugin marketplace update engineer-skills`, then restart.

## Skills

| Skill | Use it for |
|---|---|
| `technical-docs` | READMEs, ADRs, runbooks, API docs, changelogs and how-to guides. |
| `architecture-diagrams` | C4, sequence, deployment, data-flow, ER and state diagrams as Mermaid code. |
| `system-design` | Design docs and RFCs: requirements, estimates, options and trade-offs, rollout. |
| `security-review` | Threat models (STRIDE) and security reviews of designs and code changes. |
| `code-review` | Reviewing pull requests, and preparing your own for review. |
| `testing-strategy` | Test plans, choosing test levels, test doubles and fixing flaky tests. |
| `incident-response` | Running an incident, status updates and blameless postmortems. |
| `scrum-master` | Sprint planning, daily scrum, refinement, reviews, retros and Scrum metrics. |
| `engineering-communication` | Status updates, escalations, estimates, 1:1s, feedback and a brag document. |
| `skill-authoring` | Writing a new skill for this repo, or fixing one that misfires. |

Each skill triggers from what you ask ("draw the architecture", "run a retro", "review this PR"). You can also
call one directly with `/engineer:<skill>`, for example `/engineer:scrum-master`.

## Adding skills

- `skills/skill-authoring/references/creating-skills.md`: how skills work and the standard every skill here follows.
- `docs/skill-backlog.md`: skills worth adding later, each with a short brief.
- `skills/skill-authoring/templates/SKILL.md`: the skeleton for a new skill.
- `scripts/validate.sh`: checks every skill's frontmatter, size and links. Run it before committing.

The quickest way to add one is to ask Claude: "make a `<name>` skill that …". The `skill-authoring` skill walks
through it.

## License

MIT. See `LICENSE`.
