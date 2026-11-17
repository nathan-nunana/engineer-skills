# Postmortem: <short incident name>

<!-- Blameless: describe what the system and process allowed, never who erred. Names appear only as owners of actions
or as people who did something helpful. -->
- Date: <date of incident>
- Severity: <SEV1-SEV4>
- Authors: <names>
- Status: <draft | in review | published>
- Incident channel / ticket: <link>

## Summary

<!-- Three or four sentences: what broke, who was affected, how long, how it was fixed. -->
<summary>

## Impact

<!-- Numbers: customers or requests affected, duration, error rate, revenue or SLA effect, support tickets. -->
- Duration: <start UTC> to <end UTC> (<minutes>)
- Customers affected: <number or share>
- Other impact: <data loss, SLA breach, support volume>

## Timeline

<!-- UTC, from the incident timeline. Include detection, escalation, each mitigation attempt, and resolution. -->
| Time (UTC) | Event |
|------------|-------|
| <HH:MM> | <what happened or was done> |

## Contributing factors

<!-- Several conditions together, not one root cause. For each: what made it possible, hard to notice, or hard to fix. -->
- <factor>
- <factor>

## What went well

<!-- Things that worked and should be kept. -->
- <item>

## What went poorly

<!-- Gaps in process, tooling, documentation or communication. -->
- <item>

## Where we got lucky

<!-- Things that limited the damage by chance. Each one is a risk to address. -->
- <item>

## Action items

<!-- Owner, due date and ticket are mandatory. Type is prevent (stops it happening), detect (notices sooner) or mitigate
(limits the damage or speeds recovery). -->
| Action | Type | Owner | Due | Ticket |
|--------|------|-------|-----|--------|
| <specific action> | <prevent / detect / mitigate> | <name> | <date> | <link> |

## Lessons and open questions

<!-- Anything learned that is not an action, and questions still unanswered with who will answer them. -->
- <item>
