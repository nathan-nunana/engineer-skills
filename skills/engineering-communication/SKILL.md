---
name: engineering-communication
description: Write and run the conversations around engineering work: status updates that lead with the bottom line, early risk escalation with options, saying no and trading scope, time and quality, estimates as ranges with confidence, messages to non-technical stakeholders, good questions, manager 1:1s, a brag document for performance reviews, SBI feedback, and meeting notes with decisions and owners. Use when drafting or reviewing a status update, standup note, escalation, estimate, stakeholder email, help request or feedback, preparing a 1:1 or review, or when someone says "status update", "push back", "estimate", "brag doc", "1:1", "feedback" or "meeting notes". Not for incident updates (use incident-response) or sprint events (use scrum-master).
---

# Engineering Communication

Make engineering work legible to the people who depend on it. Each message should let the reader decide or act
without a follow-up question. Lead with what the reader most needs, then give support.

## Procedure

1. **Identify the reader and the action.** Who reads this, what do they know, what do you need from them (decide,
   unblock, nothing)? If you can't answer, you don't know what to write yet.
2. **Pick the form** from the sections below and copy the matching template from `templates/` when there is one.
3. **Draft the bottom line first**: one sentence with the conclusion, the status, or the ask. Put detail below it.
4. **Cut to what the reader uses.** Remove history, tool names and effort narrative unless they change a decision.
5. **Check the ask.** A request names who, what and by when. A risk names the impact and at least two options.
6. **Re-read as the recipient**, cold, on a phone. If the first two lines don't tell them the situation, rewrite.

## Status updates

Structure: bottom line, progress, risks, asks. Use `templates/status-update.md`.

- Bottom line: on track, at risk or blocked, plus the date that matters.
- Progress: what finished since the last update, in outcomes ("checkout works in staging"), not activity ("worked on
  checkout").
- Risks: each with impact, likelihood and what you're doing. Dates and numbers, not adjectives.
- Asks: who needs to do what by when. If none, say "no asks".

**Weak:**
> Hi all, been working on the payments migration this week. Did a bunch of work on the webhook handler and fixed
> some bugs. Had some issues with the sandbox but making progress. Will keep going next week. Let me know if
> questions!

**Strong:**
> **Payments migration: at risk. Cutover may slip from Dec 3 to Dec 10.**
> Done: webhook handler passes all 14 contract tests; refund flow live in staging.
> Risk: the provider's sandbox drops 1 in 20 webhooks, which blocks our retry testing. Impact: about 4 days if
> unresolved. Mitigation: building a local replay harness (2 days).
> Ask: Priya, can you escalate ticket #8812 with the provider by Thursday? If it's fixed by then, Dec 3 holds.
> Next update: Friday.

## Escalating risk early

- Raise a risk when you first believe it is more likely than not, or when impact would be large even if unlikely.
  Bad news doesn't improve with age.
- Format: what is happening, impact if nothing changes, options (at least two, with cost of each), your
  recommendation, and the decision deadline.
- Escalate to the person who can decide, and tell your manager at the same time. Don't surprise anyone.

> Risk: the auth rewrite will finish about 2 weeks after the Jan 15 launch. Options: (A) cut SSO from launch, ship
> on time; (B) hold launch to Jan 29; (C) add one engineer, likely recovering 4–5 days. I recommend A. I need a
> decision by Dec 12 to keep either option open.

## Saying no and negotiating scope

Scope, time and quality are the levers. Resources can move too but slowly. State which lever moves and the price.

1. Restate the goal behind the request, to be sure you're solving the right problem.
2. Say what's possible, not only what isn't: "Not by Friday. By Friday I can ship the read-only version."
3. Offer a trade explicitly: "To add X, we drop Y or move the date to Z."
4. Never trade quality silently (skipped tests, no monitoring). If quality is the price, name it and get the
   decision recorded.
5. Confirm the outcome in writing.

## Estimates

- Give a range and a confidence: "3 to 5 weeks, 80% confident." A single number is read as a promise.
- State the assumptions and the unknowns that would move it ("assumes the vendor API is stable; a spike on auth
  would narrow it").
- Estimate separately for: build, test and release, and the review or dependency delays you don't control.
- Update the estimate when the facts change and say so promptly. The range should narrow as the work proceeds.
- When pressed for a single date, give the date at the confidence being asked for: "Dec 20 at 90%, Dec 12 at 50%."

## Writing to non-technical stakeholders

- Start with the impact on users, money, risk or dates. Put mechanism after, or leave it out.
- Replace jargon: "the database ran out of connections" becomes "the site couldn't handle the number of
  simultaneous users". Define a term once if it must stay.
- Give a recommendation and the decision needed. Offer detail on request.
- Use numbers with units and dates with the year or day of week. Short paragraphs, one idea each.

## Asking good questions

Format: context, what you tried, the specific ask.

> I'm adding retries to the export job (context: nightly job, 2M rows, fails on provider 429s). I tried exponential
> backoff with jitter, but the job still hits the limit because 8 workers back off in step. Do we have a shared
> rate limiter, or should I add a token bucket in the job? I'm blocked on this for the Wednesday release.

Search first. Put the question in the first line, include the error text and versions, say how urgent it is, and
post in the channel the owning team reads. Close the loop afterwards with the answer, for the next person.

## 1:1s with a manager

Use `templates/one-on-one.md`. The meeting is yours; bring the agenda.

- Cover, in order: what you need from your manager, blockers, feedback (both ways), then career growth.
- Every month, spend time on growth: the skills you want, the scope you want next, what the next level requires,
  and what evidence you'd need. Ask "what would make my case for promotion stronger?".
- End with actions and owners. Start the next one by reviewing them.

## Brag document

Keep a running log, weekly, using `templates/brag-doc.md`. Write each entry as outcome, your contribution, and
evidence (a link, a number). Include work that doesn't show up in tickets: mentoring, unblocking others,
incident response, docs, hiring, design reviews. Before a review, group by theme and pick the strongest.

## Feedback (SBI)

Situation, Behaviour, Impact. Describe a specific moment, what you saw or heard, and what happened as a result.

> In Tuesday's design review (situation), you interrupted Sam twice before he finished the data-model proposal
> (behaviour). He stopped presenting and we never heard the migration plan (impact). Could you let the presenter
> finish before asking questions?

- Give it soon, privately for critical feedback, and in public for specific praise.
- Describe observable behaviour, not character ("rude", "careless").
- End with a question or a request. Listen to their account.
- Receiving feedback: ask for an example, summarise it back, thank them, and decide later what to do. Don't defend
  in the moment.

## Meeting notes

Capture: date, attendees, decisions, actions (owner + date), open questions. Send within a day. Put decisions
first.

> **Decisions:** (1) Ship SSO in 1.1, not 1.0. (2) Use the vendor's hosted login.
> **Actions:** Priya: confirm vendor pricing, Dec 4. Alex: update the launch plan, Dec 5.
> **Open:** who owns the migration of legacy accounts?

## Common failures

- **Activity report:** "worked on X". Replace with outcomes and what changed.
- **Burying the lede:** the risk is in paragraph four. Move the conclusion to line one.
- **Risk with no options:** you hand your manager a problem. Add options and a recommendation.
- **Single-date estimates:** they become commitments. Give a range and confidence.
- **A "no" with no alternative:** offer what is possible and what the trade is.
- **Question without context:** "Is the API down?" Include what you tried and the exact ask.
- **Feedback as a verdict:** "You're disorganised." Use SBI and name the behaviour.
- **Notes without owners:** every action has a name and a date, or it's not an action.
- **Brag doc written once a year:** you'll forget most of it. Log weekly, five minutes.

## Done check

- [ ] The first two lines hold the conclusion, status or ask.
- [ ] Each ask names a person, an action and a date.
- [ ] Each risk has impact and options; each estimate has a range and confidence.
- [ ] No jargon the reader doesn't use.
- [ ] Feedback follows SBI and describes behaviour, not character.
- [ ] Notes list decisions and actions with owners.
