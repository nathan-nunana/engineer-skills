# Threat model: <system or feature name>

<!-- Date, author, version or commit reviewed, and links to the design doc or PR. -->
Date: <YYYY-MM-DD>   Author: <name>   Reviewed: <commit, tag or doc link>

## 1. Scope

<!-- What is under review and what is explicitly out of scope. One short paragraph. -->
In scope: <components, endpoints, repos>
Out of scope: <what and why>

## 2. Assets

<!-- What an attacker would want. One line each, with sensitivity. -->
| Asset | Where it lives | Why it matters |
| --- | --- | --- |
| <user PII> | <db.users> | <regulated, reputational> |

## 3. Attackers

<!-- Who might attack and with what starting access. -->
- <Anonymous internet user: no credentials>
- <Authenticated user of tenant A>
- <Compromised dependency or CI token>

## 4. Data flow and trust boundaries

<!-- A list or ASCII/mermaid diagram of components and flows. Mark each boundary with [TB1], [TB2]. -->
```
<client> --[TB1: internet, TLS, session cookie]--> <API> --[TB2: service creds]--> <database>
```

| Boundary | Crossed by | Authn | Authz | Notes |
| --- | --- | --- | --- | --- |
| TB1 | <browser to API> | <session cookie> | <per-route check> | <rate limit?> |

## 5. Threats (STRIDE)

<!-- One row per plausible threat. Skip categories with no path, but say so. Control: existing mitigation or "none". -->
| # | Element or flow | STRIDE | Threat | Existing control | Gap? |
| --- | --- | --- | --- | --- | --- |
| T1 | <API /orders> | E | <user reads another tenant's order by id> | <none> | <yes> |

## 6. Findings

<!-- Only items tied to a real attack path. Ordered by severity. Use the finding format from SKILL.md. -->
### [<SEVERITY>] <Title>
Location: <file:line or endpoint>
Scenario: <attacker, input, effect, impact>
Fix: <specific change>
Verify: <test or check that fails before and passes after>

## 7. Hardening suggestions

<!-- Not tied to a demonstrated attack path. One line each. -->
- <Change, and the class of risk it reduces>

## 8. Assumptions and open questions

<!-- What you could not confirm and what you need from the team. -->
- <Unconfirmed: needs to be checked by X>

## 9. Residual risk and follow-ups

<!-- Risks accepted, with owner and date to revisit. -->
| Risk | Decision | Owner | Revisit |
| --- | --- | --- | --- |
| <risk> | <accept / fix by date> | <name> | <date> |
