# Test plan: <feature or change>

<!-- Author, date, links to the spec or ticket. -->
Author: <name>   Date: <YYYY-MM-DD>   Spec: <link>

## 1. Scope

<!-- What is covered and what is not. -->
In scope: <behaviours, components>
Out of scope: <items and where they are covered instead>

## 2. Behaviours

<!-- 3 to 8 plain statements of what the feature must do. -->
- B1: <a user can ...>
- B2: <...>

## 3. Assumptions and open questions

<!-- Rules you assumed and questions for the product owner or team. -->
- <assumption or question>

## 4. Risks (ranked)

<!-- What could go wrong, with likelihood and impact. Highest first. -->
| ID | Risk | Likelihood | Impact | Rank |
| --- | --- | --- | --- | --- |
| R1 | <double charge under concurrent requests> | <med> | <high> | <high> |

## 5. Test cases by risk

<!-- One row per group of cases. Pick the cheapest level that can catch the risk: unit, integration, contract, e2e. -->
| Risk or behaviour | Level | Cases (happy, boundary, invalid, failure, concurrency, permissions) | Doubles and data |
| --- | --- | --- | --- |
| <R1> | <integration> | <two parallel requests, one succeeds; retry after timeout> | <real DB; builder: anOrder()> |

## 6. Test doubles and data

<!-- For each dependency: real, fake, stub or mock, and why. Builders and fixtures needed. -->
| Dependency | Double | Reason |
| --- | --- | --- |
| <payments API> | <fake adapter + contract test> | <we don't own it; adapter is covered separately> |

Builders: <anOrder(), aCustomer()>
Environment: <local DB container, seeded flags>

## 7. Non-functional checks

<!-- Performance, accessibility, security, compatibility: how each is covered, or "none" with a reason. -->
- Performance: <benchmark or load test, target>
- Security: <link to security review>
- Accessibility: <checks>

## 8. Flakiness controls

<!-- Clocks, randomness, network, ordering, deadlines used in this feature's tests. -->
- Time: <injected clock>
- Isolation: <per-test transaction, unique ids>
- Timeouts: <generous deadlines for non-timing tests>

## 9. Not tested

<!-- Explicit gaps, with the reason and who accepted it. -->
- <area>: <reason>

## 10. Exit criteria

<!-- What must be true to ship. -->
- [ ] All high-risk cases pass in CI, including random order and parallel runs.
- [ ] No quarantined or skipped tests added without a ticket.
- [ ] Critical e2e journeys pass against a deployed environment.
- [ ] Manual checks completed: <list>
