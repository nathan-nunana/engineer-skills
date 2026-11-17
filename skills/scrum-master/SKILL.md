---
name: scrum-master
description: Run Scrum events and backlog work well, using Scrum Guide 2020 terms: a sprint plan with one Sprint Goal, a focused Daily Scrum, refined INVEST stories with Given/When/Then criteria, sized and split work, a Sprint Review, and a retrospective that ends in owned actions. Use when planning or running a sprint, refining or splitting stories, estimating, preparing a demo or retro, removing impediments, picking team metrics, or when someone says "scrum", "standup", "sprint planning", "backlog refinement", "retro", "velocity" or "definition of done". Not for production incidents (use incident-response) or stakeholder writing (use engineering-communication).
---

# Scrum Master

Help a team run Scrum so that each Sprint produces a usable Increment and the team gets better at it. The Scrum Master
serves the team and the organisation. They do not assign work, report status for the team, or own the backlog.

## Procedure

1. **Establish the context.** Ask for sprint length, team size, current Sprint Goal (if any), the last retro's
   actions, and whether the team is on sprints or Kanban. If the team doesn't use sprints, read "Teams not on
   sprints" below and skip the sprint events.
2. **Refine the backlog before planning.** Take the top 1–2 sprints of Product Backlog items and make each ready:
   a story that meets INVEST, Given/When/Then acceptance criteria, a size, and no unanswered blocking question. Use
   `templates/user-story.md`. Split anything larger than about half a sprint (patterns below).
3. **Run Sprint Planning** (timebox: up to 2 hours per week of sprint length).
   - Product Owner proposes a Sprint Goal: one sentence describing the outcome, not a list of tickets.
   - Compute capacity: people x working days minus holidays, leave, and known interruptions, then apply focus
     factor (0.6–0.8). Compare with the last 3 sprints' completed work, not with the plan.
   - The team pulls items until the forecast fills capacity and supports the goal. Nobody is assigned work.
   - Break the first few items into tasks. Check each item against the Definition of Done
     (`templates/definition-of-done.md`). Record the plan with `templates/sprint-planning.md`.
4. **Run the Daily Scrum** (15 minutes, same time and place, Developers only speak). Walk the Sprint Goal, not the
   people: what moves us toward the goal today, what is blocked, who needs to pair. Anything that needs more than
   two minutes goes to a follow-up between the people involved. Capture impediments for the Scrum Master.
5. **Remove impediments** the same day where possible. Log each with an owner and a date. Escalate when the team
   can't fix it within a day: say what is blocked, since when, what it costs, and the specific ask.
6. **Run the Sprint Review** (up to 1 hour per week of sprint length). Demo working software against the Sprint
   Goal, not slides. Show only Done items. Ask stakeholders for reactions, then update the Product Backlog and the
   forecast live.
7. **Run the Sprint Retrospective** (up to 45 minutes per week of sprint length) after the Review. Check last
   retro's actions first, pick a format, generate observations, group, vote, and finish with 1–3 actions that each
   have an owner and a date. Use `templates/retro.md`. Add the actions to the next Sprint Backlog.
8. **Look at the numbers for learning** once per sprint (see Metrics). Bring a trend and a question to the retro,
   not a verdict.

For agendas, facilitation scripts and wording for each event, read `references/facilitation.md`.

## Standard

- One Sprint Goal per Sprint. The team can say it without looking.
- Work is pulled by Developers. The Scrum Master never assigns tasks.
- Every item in the Sprint Backlog meets the Definition of Done before it counts as Done. Partly done is not
  Done, and gets no points.
- Timeboxes are real. Events end on time even if the topic isn't finished.
- Every retro ends with 1–3 actions, each with an owner and a date, and the next retro starts by reviewing them.
- Metrics describe the team's own system and are never compared across teams or used as targets.

## Refinement

**INVEST.** A story is Independent (can be ordered freely), Negotiable (details are open), Valuable (to a user or
the business), Estimable, Small (fits in a sprint, ideally 1–3 days of work for the team), Testable.

**Acceptance criteria** use Given/When/Then, one behaviour each:

> Given a cart with an expired promo code, When the customer applies it, Then the total is unchanged and the message
> "This code has expired" is shown.

**Splitting patterns.** Split vertically (each piece works end to end for a user), never by layer ("build the API",
then "build the UI").

- Workflow steps: ship the thinnest path first (search, then filter, then save).
- Business rules: one rule per story (standard shipping, then express, then international).
- Data variations: one data type or source per story (CSV import, then Excel).
- Happy path / unhappy path: success flow first, then validation and error handling.
- Spike: a timeboxed question (1–2 days) with a written answer, used when the team can't estimate because of an
  unknown. A spike produces a decision and a follow-up story, not code to ship.

## Estimation

- Story points measure relative size (effort, complexity and uncertainty together), not hours. Pick a reference
  story, call it 3, and size others against it. Use a Fibonacci-like scale (1, 2, 3, 5, 8, 13). Treat 13 as "split it".
- Planning poker: each person picks a card privately, all reveal together, the highest and lowest explain their
  reasoning, then re-vote once or twice. Converge on one number; don't average.
- If estimates stall at a number, take the larger and move on. Estimation that takes more than a few minutes per
  story is a sign the story isn't understood. Refine it instead.
- No-estimates alternative: slice stories to roughly the same size, count items per sprint, and forecast from
  throughput. This works well when the team already splits consistently. Offer it when points debates are eating
  time or points are being used as a target.
- Forecast from history: use the median of the last 3–6 sprints' completed points or items, and give a range.

## Metrics (for learning, not judging)

- **Velocity trend:** a stable range matters, the number doesn't. Use it to forecast, never to compare teams.
- **Cycle time:** days from started to Done per item. Watch the median and the 85th percentile. A long tail points
  at blocked or oversized work.
- **Sprint Goal hit rate:** share of the last 6+ sprints that met the goal. Better than "% of tickets completed".
- **Escaped defects:** bugs found after release. Review each in the retro for where the process let it through.
- **Carry-over:** items rolled to the next sprint. Persistent carry-over means overcommitment or oversized items.

Rules: show trends over 6+ sprints, pair every number with a question, and drop any metric that starts to be gamed.

## Teams not on sprints (Kanban)

Use flow metrics instead of velocity: **throughput** (items finished per week), **cycle time** (with percentiles),
**WIP** (work in progress, with explicit limits per column) and **age of work in progress** (oldest first). Forecast
with "85% of items finish within N days". Keep a regular cadence for replenishment, a review of the board and a
retrospective, even without sprints.

## Example

A 5-person team, 2-week sprints, 8 working days each after leave. Capacity: 5 x 8 x 0.7 = 28 person-days. Last
three sprints completed 21, 24 and 22 points.

> **Sprint Goal:** Customers can reset their own password without contacting support.
> **Forecast:** 22 points: reset request (3), email token (5), reset form with validation (5), expired-token
> handling (3), rate limiting (3), support dashboard link removal (3).
> **Left out on purpose:** audit log export (8), pulled in only if the goal is met early.

At the daily on day 4, the team says "token email is done, rate limiting is blocked on the gateway config", not a
round of "yesterday I worked on...". The Scrum Master asks the platform team for the config the same afternoon.

## Common failures

- **Status-report standup:** each person reports to the Scrum Master. Turn the group to face the board and the
  goal, and ask "what will get the goal done today?".
- **Carry-over every sprint:** the team forecasts from hope. Plan from the median of past completed work, and split
  items until they finish in a few days.
- **Scrum Master as task assigner or manager:** hand work selection back to Developers and coach on asking for it.
- **Velocity as a target:** points inflate and quality drops. Remove the target, use velocity only to forecast.
- **Retro without follow-through:** actions with no owner vanish. Cap actions at 3, name an owner, and review them
  first next time.
- **Sprint Goal that is a ticket list:** rewrite as the outcome a user or the business sees.
- **Demo of slides or mockups:** show running software in the real environment, or the item is not Done.
- **Refinement during planning:** unrefined items burn planning time. Refine in the sprint before.
- **Same three people talk:** use silent writing first, round-robin, or pairs. See `references/facilitation.md`.

## Done check

- [ ] A single Sprint Goal is written and the forecast fits capacity from past sprints.
- [ ] Every planned item has acceptance criteria and a size, and none is larger than half a sprint.
- [ ] Each event has a timebox and an agenda; each retro ends with 1–3 actions with owner and date.
- [ ] Impediments are logged with an owner and a date.
- [ ] Metrics shown are trends with a question attached, not targets.
- [ ] Nobody was assigned work by the Scrum Master.
