---
name: code-review
description: Review someone else's pull request, or prepare your own PR for review, with severity-prefixed comments, a size check and a PR description (what, why, how to test, risk). Use when asked to "review this PR", "look at this diff", "give feedback on this change", "write a PR description", "self-review", "is this ready to merge" or "how do I split this PR". Not for a dedicated security or threat-model review; use security-review for that. Not for deciding what tests to write; use testing-strategy.
---

# Code review

Reviews find the defects that matter and leave the author clear on what to change. Your own PRs are small, described and self-reviewed before anyone else sees them.

## Reviewing a PR

1. **Understand intent first.** Read the ticket and PR description before the diff. State in one sentence what the change is supposed to do. If the description is missing or unclear, ask for it; a review without intent only checks syntax.
2. **Check size.** Count changed lines, excluding generated files, lockfiles and pure moves. Over about 400, say so and suggest a split (see below) before spending time on detail, unless the author has a reason it can't be split.
3. **Read the tests first.** They show what the author thinks the behaviour is. Note what is untested: error paths, boundaries, the bug being fixed.
4. **Read the diff top-down** (public interfaces and data model first, then logic, then call sites). Pass in this order, and keep a note of each:
   - **Correctness:** does it do what the intent says? Off-by-one, null/empty, wrong condition, ordering, concurrency, partial failure, idempotency, migrations that lock tables.
   - **Edge cases and error handling:** empty input, large input, duplicates, timeouts, retries. Errors are handled or propagated deliberately, never swallowed. Messages help someone debug.
   - **Tests:** the new behaviour and the failure cases are covered, tests assert behaviour not implementation, no sleeps or real network.
   - **Security:** new inputs validated, authz on every new route, no secrets or PII in logs. If it touches auth, tenancy, file handling, shell or SQL, apply `security-review`.
   - **Performance, only where it matters:** queries in loops (N+1), unbounded result sets, work on hot paths, missing indexes for new queries. Do not micro-optimise cold code.
   - **Readability:** names say what things are, functions do one thing, comments explain why. Flag clever code that needs a comment to be understood.
   - **Fit with the codebase:** uses existing helpers and patterns, lives in the right module, follows the style the repo already has. Check for a duplicate of something that already exists.
5. **Run it when the risk justifies.** For UI, migrations or tricky logic, check out the branch, run the tests and exercise the change.
6. **Write comments** using the conventions below. Open with a short summary: what you understood, what is good, how many blocking items.
7. **Decide.** Approve when there are no blocking items. Request changes when there is any blocking item. Do not block on nits or preferences. On re-review, check only what you asked for plus anything newly changed.

## Comment conventions

Prefix every comment with its weight so the author can triage.

- **blocking:** must change before merge (bug, security hole, data loss, missing test for risky behaviour, breaks an interface).
- **suggestion:** would improve the change; author decides.
- **nit:** trivial style or naming; never blocks. Skip it if a linter could catch it, and batch several into one comment.
- **question:** you need to understand something; may turn into a change.
- **praise:** something done well. Say it when it's true; it tells the author what to repeat.

For each comment: say what you see, why it matters, and offer a concrete alternative or a specific question. Ask instead of accuse. Talk about the code, not the person ("this returns early" rather than "you forgot").

## Example comments

Weak:

> This is wrong. Why would you do it this way? Use a map.

Good:

> **blocking:** `retry()` re-sends the charge request on timeout, but the first attempt may have succeeded, so a customer can be charged twice. Could we pass the `order_id` as an idempotency key (the payments API supports `Idempotency-Key`)? A test that fails the first call after it succeeds on the server would pin this down.

Weak:

> Needs more tests.

Good:

> **suggestion:** `parseDuration` has tests for "5m" and "1h" but nothing for "" or "5x". Both currently reach `Number(undefined)` and return `NaN`. A table test with those inputs would show whether we want an error or a default.

Weak:

> Rename this.

Good:

> **nit:** `data2` holds the filtered users; `activeUsers` would read better at the call sites below.

Good question and praise:

> **question:** Is it intended that `archive()` skips orders with a pending refund? I couldn't find that in the ticket.
>
> **praise:** Moving the pricing rules into a pure function made the test table easy to read.

## Splitting large PRs

Suggest a split along seams that each merge and deploy safely:

- Refactor or rename first (no behaviour change), then the feature on top.
- Schema migration first (backward compatible), then code that uses it.
- Behind a feature flag: land the plumbing dark, then the behaviour.
- Vertical slices: one endpoint or one screen per PR.
- Tests for existing behaviour (characterisation) before changing it.
- Mechanical changes (formatting, moves, codemods) in their own PR so the logic PR is readable.

## Preparing your own PR

1. **Keep it small and single-purpose.** One reason to exist, under about 400 changed lines. Unrelated fixes you notice go in a separate PR.
2. **Self-review the diff** in the review UI before requesting anyone. Look for debug output, commented-out code, stray files, TODOs without tickets, accidental formatting churn, secrets, and missing tests. Comment on your own PR where a choice needs context.
3. **Run the checks** locally: tests, linter, type check, build. CI should not be the first place they run.
4. **Write the description** using `templates/pr-description.md`: what changed, why, how it was tested and how a reviewer can test it, risk and rollback, screenshots for UI, and a link to the ticket.
5. **Choose reviewers** who own the area. Say what you want feedback on if it is a draft or you are unsure about a design choice.
6. **Respond to every comment:** change it, or reply with the reason. Resolve only what you addressed. Push fixes as new commits during review so the reviewer can see what changed; squash on merge if the repo does that.

## Common failures

- **Reviewing style over substance:** pages of nits and no look at correctness. Let the formatter and linter handle style.
- **Vague comments:** "this is confusing" with no suggestion. Name what is confusing and propose a fix.
- **Blocking on preference:** use "suggestion" or "nit" and approve.
- **Rubber stamp:** approving a large diff after a skim. Say what you did not review.
- **Rewriting in comments:** if you would structure it entirely differently, discuss on a call or in the design doc, not line by line.
- **Mega-PR from the author:** mixed refactor, feature and formatting. Split it.
- **Empty description:** "fix bug". Fill in the template.
- **Defensive replies:** treat comments as information about the code, not a verdict on you.

## Done check

Reviewing:

- [ ] Intent is stated in a sentence and matches the diff.
- [ ] Size was checked, and a split proposed if over about 400 lines.
- [ ] Each pass (correctness, errors, tests, security, performance, readability, fit) was done or consciously skipped.
- [ ] Every comment has a severity prefix, a reason and an alternative or question.
- [ ] The decision follows from the blocking items, and the summary says what was not reviewed.

Authoring:

- [ ] Single purpose, small, self-reviewed.
- [ ] Tests, lint and build pass locally.
- [ ] Description covers what, why, how to test, risk and ticket; screenshots included for UI.
