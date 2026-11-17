# Skill backlog

Skills worth adding later, roughly in the order they tend to pay off. Each has enough of a brief to start from: ask
Claude to "make the <name> skill from the backlog" and the `skill-authoring` skill takes it from there.

| Skill | What it would do | Write it when |
|---|---|---|
| `git-workflow` | Branch naming, commit messages (Conventional Commits), rebasing vs merging, recovering from mistakes (reflog, revert, cherry-pick), release tagging. | You keep looking up the same git recovery steps. |
| `api-design` | REST and gRPC conventions, resource naming, pagination, errors (RFC 9457 problem details), versioning, idempotency keys, OpenAPI review. | You start designing APIs others consume. |
| `database-design` | Schema design, normalisation vs denormalisation, indexes from query patterns, safe migrations (expand/contract), zero-downtime changes. | A schema change or slow query bites you. |
| `observability` | Logs, metrics and traces; RED/USE metrics; SLIs, SLOs and error budgets; alert design; dashboards that answer a question. | You own a service in production. |
| `performance-profiling` | Measuring before optimising: profilers per language, flame graphs, load testing, latency percentiles, common wins. | Something is slow and you're guessing why. |
| `ci-cd` | Pipeline design, caching, test splitting, deploy strategies (blue/green, canary), rollback, secrets in CI. | You set up or fix a pipeline. |
| `refactoring` | Safe refactoring in small steps with tests, legacy code techniques (seams, characterisation tests), when not to refactor. | You inherit a messy codebase. |
| `debugging` | A systematic method: reproduce, bisect, form one hypothesis at a time, read the error properly, minimise the case. | You lose hours to a bug. |
| `estimation-and-planning` | Breaking work down, ranges with confidence, tracking the cone of uncertainty, roadmaps and milestones. | You're asked for dates on bigger projects. |
| `tech-lead` | Running technical direction for a team: design reviews, delegating, unblocking, tech debt budgets, writing strategy. | You become the lead on a project. |
| `mentoring` | Pairing, giving code review as teaching, growth plans, onboarding a new engineer. | Someone junior joins your team. |
| `interviewing` | Running and scoring technical interviews fairly, and preparing for your own (system design, behavioural STAR answers). | Interview season, on either side. |
| `cloud-cost` | Reading a cloud bill, tagging, right-sizing, reserved capacity, spotting waste. | The bill surprises someone. |
| `accessibility` | WCAG 2.2 AA checks for web and mobile, testing with screen readers, common fixes. | You ship user-facing UI. |
| `product-thinking` | Problem framing, user research basics, writing a PRD, measuring outcomes. | You want a say in what gets built. |

When you write one, move its row out of this table and into the README's skill list.
