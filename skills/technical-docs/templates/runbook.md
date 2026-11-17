# Runbook: <alert name or symptom>

<!-- Written for someone who has never seen this system and is under stress. Start from what they see. -->

- Owner: <team>
- Last verified: <YYYY-MM-DD> by <name>
- Service: <service name and link to dashboard>
- Severity guide: <when this is a page versus a ticket>

## Symptom

<!-- What the alert says or what users report. Include the alert name verbatim. -->

<symptom>

## Impact

<!-- Who and what is affected, so the responder can judge urgency. -->

<impact>

## Check

<!-- Steps to confirm the diagnosis. Each: command or link, then what a good and a bad result look like. -->

1. <Check one>:
   ```bash
   <command>
   ```
   Healthy: <result>. Problem: <result>, go to "Fix A".

## Fix

<!-- One subsection per cause. Exact commands. Say what the reader sees after each step. -->

### Fix A: <cause>

1. <Step>:
   ```bash
   <command>
   ```
   Expected: <output>.

## Verify

<!-- How to know it is resolved: metric back in range, health check passing, a test request succeeding. -->

- <Metric or check> is <value> for <duration>.

## Roll back

<!-- How to undo the fix or the change that caused the problem. -->

```bash
<rollback-command>
```

## Escalate

<!-- When to stop and who to call. Include a time limit: "if not resolved in 30 minutes". -->

- If <condition>, page <team or person> via <channel>.

## Afterwards

<!-- Cleanup, ticket or postmortem to file, runbook updates to make. -->

- <follow-up>
