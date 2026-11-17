---
name: security-review
description: Review a design, a change or an existing service for security and produce a threat model and a list of findings, each with severity, location, exploit scenario, fix and verification. Use when asked for a "security review", "threat model", "is this safe", "pen-test prep" or "STRIDE", before shipping anything that handles auth, user data, payments, file uploads, webhooks, cloud infrastructure or LLM tool use, or when reviewing a diff that touches those. Defensive review only. Not for general code quality; use code-review for that.
---

# Security review

Deliver a short threat model and a findings list where every finding ties to a real attack path. A finding without an attacker, an entry point and an impact is a hardening suggestion and goes in its own section.

## Procedure

1. **Scope and assets.** Ask for or infer what is under review (a design doc, a diff, a repo, a deployed service). List what an attacker would want: user data, credentials, money, compute, the ability to act as another user, the build pipeline. List who the attackers are: anonymous internet, authenticated user, tenant admin, malicious dependency, insider. State what is out of scope.
2. **Data flow and trust boundaries.** Draw or list the components (client, API, workers, datastores, third parties, CI) and each flow between them. Mark every trust boundary: internet to edge, user to service, service to service, service to cloud account, your code to a third-party package, and in LLM apps, untrusted content to model context. Note what is authenticated at each crossing and how.
3. **STRIDE per element.** For each component and each flow that crosses a boundary, ask which of these apply: Spoofing, Tampering, Repudiation, Information disclosure, Denial of service, Elevation of privilege. Write down only the threats that have a plausible path. Record the existing control for each, or "none".
4. **Code and config pass.** Work through `references/checklist.md`, limited to the categories that match the scope. Start from entry points (routes, handlers, queue consumers, webhooks, CLI args, file parsers) and follow untrusted data to sinks (queries, shell, filesystem, HTTP clients, templates, deserializers, HTML output). Then read config: IaC, CI workflows, Dockerfiles, headers, CORS, secrets handling.
5. **Verify each candidate.** Before writing a finding, confirm the path: is the input really attacker-controlled, does a control upstream already stop it, is the code reachable. Read the callers. If you cannot confirm, mark it "unconfirmed" with what you would need to check, or demote it to hardening.
6. **Write up.** Copy `templates/threat-model.md` for a design or service review. For a diff review, the findings section alone is enough. Order findings by severity.
7. **If the change touches auth, authorization or tenant boundaries,** read every endpoint the change adds or modifies for the authz check, not just the one the author mentioned.

## Severity rubric

- **Critical:** remote, unauthenticated or low-privilege attacker gets code execution, takeover of accounts or admin, or bulk data access. Fix before release.
- **High:** an authenticated attacker reads or changes another user's or tenant's data, or an exposed secret grants real access. Fix before release.
- **Medium:** exploitable with extra conditions (a specific role, user interaction, a race) or with limited impact. Fix this sprint.
- **Low:** minor leak or defense gap with little impact on its own. Fix when convenient.

## Finding format

```
### [HIGH] Short title
Location: path/to/file.ts:88, POST /v1/orgs/{id}/export
Scenario: <who>, <what they send or do>, <what happens>, <impact>.
Fix: <specific change>.
Verify: <test, request or scan that fails before the fix and passes after>.
```

Rules for the scenario: name the attacker and their starting access, the exact input or request, and the resulting impact. Describe it in words; do not write working exploit code.

Hardening suggestions go in a separate list with no severity: one line each, what to change and what class of risk it reduces.

## Example

```
### [HIGH] Any logged-in user can download another org's invoices
Location: src/api/invoices.ts:41, GET /v1/invoices/{invoiceId}/pdf
Scenario: User A in org 1 requests the PDF with an invoice id from org 2. The handler checks
the session is valid but loads the invoice by id only, so org 2's invoice is returned. Ids are
sequential, so User A can enumerate them. Impact: cross-tenant disclosure of billing data.
Fix: load with `WHERE id = $1 AND org_id = $2` using the session's org, return 404 on miss.
Verify: add a test where a user from org 1 requests an org 2 invoice and expects 404; add the
same case to the shared authz test table for every route under /v1/invoices.

Hardening: set `Cache-Control: private, no-store` on the PDF response.
```

## Common failures

- **Scanner dump:** pasting tool output or a generic list ("enable HSTS") as findings. Keep only what you tied to this system's attack path.
- **Severity inflation:** calling every issue high. Use the rubric and say what conditions an attacker needs.
- **Checking one endpoint:** the reported route is guarded but its siblings, the GraphQL equivalent, or the admin variant are not. Enumerate all routes touching the same resource.
- **Trusting the client:** hidden fields, front-end role checks and "the UI never sends that" are not controls.
- **No verification step:** a fix with no way to prove it works gets regressed. Every finding says how to check.
- **Reviewing only the diff:** a safe-looking change can be exploitable because of code it calls. Read the callee and the callers.
- **Exploit code:** describe the scenario. Do not produce payloads or tooling beyond what is needed to explain the risk.

## Done check

- [ ] Assets, attackers and out-of-scope items are stated.
- [ ] Trust boundaries are listed and each crossing has a stated authn/authz mechanism or "none".
- [ ] STRIDE was applied to every boundary-crossing flow.
- [ ] Every finding has severity, location, scenario, fix and verification.
- [ ] Every finding was traced to an attacker-controlled input or reachable misconfiguration.
- [ ] Hardening suggestions are separated from findings.
- [ ] No secrets or live credentials were copied into the report; redact them.

For the category checklist (OWASP Top 10 and API Security Top 10 mapping, authn, authz, injection, secrets, crypto, supply chain, cloud, web, LLM apps), read `references/checklist.md` during step 4.
