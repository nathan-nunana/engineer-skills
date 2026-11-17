---
name: incident-response
description: Run a production incident and write its blameless postmortem: a severity call, named roles, a first-15-minutes checklist, mitigation before root cause, timed status updates, a running timeline, closing criteria, then a postmortem with impact, contributing factors, and action items that have an owner, a due date and a ticket. Also covers on-call hygiene (runbooks, actionable alerts). Use when something is down or degraded, a customer reports an outage, or someone says "incident", "outage", "sev1", "page", "on call", "rollback" or "postmortem". Not for routine bugs (use the normal bug process) or sprint events (use scrum-master).
---

# Incident Response

Restore service first, understand it second, and learn from it afterwards. During an incident the goal is to reduce
customer impact as fast as is safe. After it, the goal is to change the system so the same class of failure is
harder to cause, easier to see and cheaper to survive.

## Procedure: during the incident

1. **Declare it.** If you are asking "is this an incident?", treat it as one. Open a dedicated channel
   (`#inc-<date>-<short-name>`) and post a one-line summary. Declaring early and downgrading later costs little.
2. **Set severity** from impact, not cause (rubric below). Revisit it whenever impact changes.
3. **Assign roles** (below). One person says "I am incident commander". If you are alone, hold all roles but still
   write the timeline.
4. **Run the first 15 minutes** (checklist below).
5. **Mitigate before root-causing.** Pick the fastest safe action that reduces impact: roll back the last
   deploy, turn off a feature flag, fail over, scale up, shed load, block a bad client. Do this even if the cause is
   unknown. Investigate in parallel, never instead of mitigating.
6. **Post updates on a schedule** using `templates/status-update.md`: SEV1 every 15–30 min, SEV2 every 30–60 min,
   and always when something changes. Say "no change, next update at HH:MM" if there is nothing new.
7. **Keep a timeline as you go**: timestamp (UTC), what was observed or done, who did it. The scribe owns it.
8. **Hand off** when anyone has been on for more than 2–3 hours or a shift ends: the outgoing commander gives
   the new one the state, hypotheses, actions in flight and the next update time, in writing, and says "you are
   incident commander" aloud.
9. **Close** only when the closing criteria below are met. Post a final update and schedule the postmortem.

## Severity rubric

| Level | Impact | Response |
|-------|--------|----------|
| SEV1 | Core service down or data loss/security breach affecting most customers | Page everyone needed now, exec and customer comms, all hands |
| SEV2 | Major feature broken or a significant minority of customers affected, no workaround | Page the owning team, comms lead engaged, updates every 30–60 min |
| SEV3 | Partial degradation or one customer affected, a workaround exists | Handle in business hours or by on-call, internal ticket |
| SEV4 | Minor or cosmetic, no customer impact now | Normal backlog |

Adapt thresholds to the product (for example, "most customers" as a percentage or a revenue figure). When torn
between two levels, choose the higher one.

## Roles

- **Incident commander (IC):** owns the response and the decisions. Coordinates, does not debug. Assigns tasks,
  sets the update cadence, decides on rollbacks, calls severity and closure.
- **Communications lead:** writes internal and customer updates, watches support channels, shields responders from
  questions. May be the IC in a small SEV3.
- **Ops / subject-matter experts:** investigate and make changes. Report findings to the IC in one or two sentences.
- **Scribe:** keeps the timeline and records decisions, hypotheses and actions. Records, doesn't interpret.

Anyone can escalate. Responders say what they are about to change before they change it ("rolling back to
v412 now"), so the IC and scribe have it on record.

## First 15 minutes checklist

- [ ] Acknowledge the page and post "I am on it" in the incident channel.
- [ ] Confirm the impact: who is affected, since when, how bad. Check dashboards, error rates and a real request.
- [ ] Declare the incident, set severity, name the IC, comms lead and scribe.
- [ ] Check what changed recently: deploys, config, flags, migrations, traffic, dependencies, certificates.
- [ ] Choose a mitigation and try it. Prefer reversible actions.
- [ ] Post the first status update, with the next update time.
- [ ] Pull in the people who own the affected systems. Don't wait to be sure.
- [ ] Start the timeline.

## Standard

- Mitigation comes before diagnosis. A rollback that works without explaining the bug is a good outcome.
- Every status update has the same fields: status, impact, what we know, what we're doing, next update time.
- Only the IC makes calls on severity, comms and closure. One voice, one channel.
- Speculation is labelled as such ("hypothesis: connection pool exhaustion"). Facts have a source.
- The timeline is written during the incident, in UTC, not reconstructed from memory later.
- Closing criteria: impact has ended and metrics are normal for a set period (30–60 min for SEV1/2); customers have
  been told; the on-call has a clear owner for follow-up; temporary mitigations are noted; the postmortem is
  scheduled within 5 working days.

## Procedure: the postmortem

1. **Decide whether to write one.** Always for SEV1 and SEV2, any data loss or security event, and any incident
   that surprised the team. Optional for SEV3.
2. **Draft within 3 working days** from the timeline, using `templates/postmortem.md`. The IC or a person close
   to the incident owns the draft, and responders add their view.
3. **Write facts first**: impact (numbers, duration, customers), then the timeline in UTC.
4. **Find contributing factors, plural.** Complex systems fail from several conditions together. Ask "what made
   this possible, what made it hard to notice, what made it hard to fix?" instead of looking for the one root cause.
   Describe how the system and process allowed each action, never who made a mistake.
5. **Record what went well and where we got lucky.** Luck (a person happened to be online, the bad batch was
   small) is a risk you did not control, so it produces action items.
6. **Write action items** classified as prevent, detect or mitigate. Each has an owner, a due date and a tracking
   ticket. Prefer a few that will be done over a long list that won't. Cap at about 5–7.
7. **Review in a meeting** (30–60 min) with responders and affected teams. Read it, correct the facts, agree the
   actions. Publish internally. Follow up on action items weekly until they are closed.

## Example

A weak and a strong contributing-factor entry for the same event.

Weak: "Root cause: engineer deployed a bad migration."

Strong:
> - The migration added an index on a 400M-row table without `CONCURRENTLY`; it locked writes for 11 minutes.
>   Staging has 2M rows, so the migration looked instant there. (prevent)
> - Write-error alerts fire after 5 minutes at a 5% threshold, so the first page came at 14:12, 9 minutes after the
>   lock started. (detect)
> - The rollback runbook covers application deploys but not migrations, so 4 minutes went to finding who could
>   cancel the query. (mitigate)

Action: "Add a pre-deploy check that flags non-concurrent index creation on tables over 1M rows. Owner: Dana,
due 2026-12-05, ticket PLAT-2214."

## On-call hygiene

- Every alert that pages a person must be actionable, urgent and linked to a runbook. If an alert needs no action,
  delete it or lower it to a ticket. Review pages weekly: for each, did it need a human, and was the runbook right?
- A runbook has: what the alert means, how to confirm impact, first mitigation steps, who to escalate to, and the
  date last verified. Update it during or right after the incident that used it.
- Alert on symptoms customers see (error rate, latency, failed checkouts) more than on causes (CPU).
- Handoffs between shifts list open issues, flaky alerts and risky deploys planned.
- Keep the page load sustainable. Past about 2 pages per shift, treat noise as a bug and fix it.

## Common failures

- **Debugging before mitigating:** an hour on the cause while customers stay down. The IC asks "what is the fastest
  way to stop the pain?" every 10 minutes.
- **IC debugging:** nobody is steering. Hand the keyboard to someone else and keep the overview.
- **Silent channel:** stakeholders interrupt responders. Post updates on time, even with no change.
- **Single root cause and a name:** the postmortem blames one person or one line of code. Rewrite as contributing
  factors and system conditions.
- **Action items without owners:** "improve monitoring" is not an action. Make it specific, owned, dated, ticketed.
- **Timeline from memory:** times drift and details are lost. Scribe live, in UTC.
- **Closing too early:** the graph recovered but customers haven't been told, or a temporary fix has no owner.

## Done check

Incident:
- [ ] Severity, IC, comms lead and scribe are named in the channel.
- [ ] Mitigation attempted before or alongside diagnosis.
- [ ] Updates went out on cadence and a final one says it's resolved.
- [ ] Timeline is complete, in UTC.
- [ ] Closing criteria are met and the postmortem is scheduled.

Postmortem:
- [ ] Impact is quantified and the timeline is factual.
- [ ] Contributing factors, what went well and where we got lucky are listed, with no blame.
- [ ] Each action item has an owner, due date, ticket and a prevent/detect/mitigate label.
- [ ] Reviewed in a meeting and published.
