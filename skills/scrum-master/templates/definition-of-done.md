# Definition of Done: <team or product>

<!-- The shared standard every Increment meets. Agree it as a team, keep it short, and review it in a retro each
quarter. An item that doesn't meet every line is not Done and gets no credit in the sprint. -->

## Code

- [ ] Reviewed and approved by <number> teammate(s)
- [ ] Merged to <main branch> with CI green
- [ ] No new lint or static analysis warnings
- [ ] <team-specific check>

## Tests

- [ ] Unit tests for new logic; tests for each acceptance criterion
- [ ] Regression tests pass
- [ ] <integration, contract or end-to-end checks that apply>

## Quality

- [ ] Acceptance criteria demonstrated to the Product Owner
- [ ] Accessibility, security and performance checks done where the change touches them
- [ ] No known defects of severity <level> or higher open against the item

## Operations

- [ ] Deployed to <environment>, behind a feature flag if not yet released
- [ ] Monitoring, logs and alerts cover the new behaviour
- [ ] Runbook or on-call notes updated if behaviour changes

## Documentation

- [ ] User-facing docs or release notes updated
- [ ] ADR or design note written for any significant decision

## Not part of Done

<!-- List what is deliberately excluded, so there are no surprises. -->
- <item>: <where it is tracked>
