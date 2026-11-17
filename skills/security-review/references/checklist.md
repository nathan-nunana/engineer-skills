# Security review checklist

Work through the categories that match the scope. Each item is a question to answer by reading code or config. Report an item only when you can tie it to an attack path. Category names in brackets refer to the OWASP Top 10 (web) and the OWASP API Security Top 10.

## Authentication and sessions
[OWASP Top 10: Identification and Authentication Failures. API Top 10: Broken Authentication]

- Are passwords hashed with argon2id, scrypt or bcrypt, with per-user salts? Is there a lockout or rate limit on login, reset and MFA endpoints?
- Do password reset and email-change flows use single-use, short-lived, unguessable tokens, and do they invalidate old sessions?
- Are session ids random, rotated on login and privilege change, and invalidated on logout and password change?
- Cookies: `HttpOnly`, `Secure`, `SameSite` set. JWTs: signature and `alg` pinned, `exp`, `aud` and `iss` checked, no `none`, no secrets in the payload, revocation story for long-lived tokens.
- Does every non-public route require authentication by default (deny by default), or does each route opt in?
- Is account enumeration possible through different responses or timing for "user exists"?
- OAuth/OIDC: `state` and PKCE used, redirect URIs matched exactly, tokens not passed in URLs.

## Authorization
[OWASP Top 10: Broken Access Control. API Top 10: Broken Object Level Authorization, Broken Function Level Authorization, Broken Object Property Level Authorization]

- Is there an ownership or tenant check on every handler that takes an object id (IDOR)? List all routes for the resource, including bulk, export, search, GraphQL, websockets and background jobs.
- Are tenant ids taken from the session, never from the request body, path or header the client controls?
- Are tenant filters applied at the data layer (row-level security, scoped repositories) rather than remembered per query?
- Are admin and internal endpoints separated and checked by role, not by obscurity of the URL?
- Mass assignment: can a client set `role`, `org_id`, `is_admin`, `price` by adding fields? Is there an allowlist of writable properties, and of returned properties (excessive data exposure)?
- Do authz decisions happen server-side after the object is loaded, and fail closed on errors?
- Service-to-service calls: does the callee check the caller's identity and the end user's permissions, or trust the network?

## Input handling
[OWASP Top 10: Injection, Insecure Design, Software and Data Integrity Failures. API Top 10: Server Side Request Forgery, Unrestricted Resource Consumption]

- **SQL:** parameterised queries everywhere. Dynamic identifiers (column, sort order, table) come from an allowlist.
- **Command:** no shell string built from input. Use argument arrays, no `shell=True`/`exec` with concatenation. Check filenames and flags that start with `-`.
- **Path traversal:** user-supplied file names are normalised and confined to a base directory after resolution; zip extraction checks entry paths (zip slip); symlinks are handled.
- **SSRF:** server-side fetches of user-supplied URLs (webhooks, imports, image proxies, link previews) resolve DNS and block private, loopback, link-local and cloud metadata ranges after redirects; allowlist hosts where possible.
- **XSS:** output encoding by context; no raw HTML sinks (`innerHTML`, `dangerouslySetInnerHTML`, `v-html`) fed with user data; Content-Security-Policy as a backstop; user-uploaded HTML/SVG served from a separate origin or with `Content-Disposition: attachment`.
- **Deserialization:** no pickle, Java native serialization, unsafe YAML load or `eval` on untrusted data. Prefer JSON with schema validation.
- **Template injection:** user input is never part of the template source; sandboxed engines for user-authored templates.
- Other: XXE (disable external entities), open redirects, header injection (CRLF), regex denial of service, unbounded request size, pagination and upload limits, file type checks by content not extension.
- Validation happens on the server, at the boundary, against an allowlist of shape, type and length.

## Secrets
[OWASP Top 10: Security Misconfiguration, Cryptographic Failures]

- No secrets in source, images, client bundles, CI logs, error messages, analytics events or URLs (query strings end up in logs and referrers). Run a secret scan over the repo and its history.
- Secrets come from a secret manager or injected environment, scoped per service and environment.
- A rotation process exists and has been exercised; a leaked secret can be revoked without a deploy freeze.
- Least privilege on every key and token: read-only where possible, one purpose each.
- `.env` files and credentials are gitignored; example files hold placeholders only.

## Cryptography
[OWASP Top 10: Cryptographic Failures]

- No homemade crypto or protocol design. Use the platform's vetted library and high-level APIs.
- Current algorithms: AES-GCM or ChaCha20-Poly1305 for encryption, SHA-256 or better for hashing, Ed25519 or ECDSA P-256 or RSA 2048+ for signatures, argon2id/scrypt/bcrypt for passwords. No MD5, SHA-1, DES, RC4, ECB mode, or unsalted password hashes.
- Randomness for tokens and keys comes from a CSPRNG, not `Math.random` or `rand()`.
- Nonces and IVs are never reused with the same key. Comparisons of secrets and MACs are constant-time.
- TLS 1.2+ everywhere, including internal hops; certificate validation is not disabled. Sensitive data is encrypted at rest with managed keys.

## Dependencies and supply chain
[OWASP Top 10: Vulnerable and Outdated Components, Software and Data Integrity Failures. API Top 10: Unsafe Consumption of APIs]

- Lockfiles are committed and used in CI (`npm ci`, `--frozen-lockfile`, `cargo --locked`); versions pinned.
- Known-vulnerable dependencies are checked in CI (audit, Dependabot, osv-scanner) and reachable ones are triaged.
- New dependencies are reviewed: maintainer activity, typosquatting, install scripts, transitive size.
- Build provenance: artifacts built in CI from tagged commits, signed or attested where the ecosystem supports it; container base images pinned by digest.
- CI: workflow tokens use least-privilege `permissions`; third-party actions pinned by full commit SHA, not tag; no secrets exposed to workflows triggered by forks or untrusted PR code (`pull_request_target` with checkout of PR head is a red flag); no untrusted input interpolated into `run:` steps.
- Deploy credentials are short-lived (OIDC) rather than long-lived keys, and scoped to the environment.

## Logging, monitoring and PII
[OWASP Top 10: Security Logging and Monitoring Failures. API Top 10: Improper Inventory Management]

- Auth events, authz failures, admin actions and data exports are logged with who, what, when and source.
- Logs hold no passwords, tokens, full card numbers, session ids or unneeded PII. Request and error logging redacts bodies and headers like `Authorization` and `Cookie`.
- Log injection is prevented (newlines in user input are encoded).
- Alerts exist for spikes in failed logins, 403s and 5xx; logs are tamper-resistant and retained for a defined period.
- PII inventory: what is collected, why, where it is stored, retention and deletion path. Error responses do not leak stack traces or internals.
- Old API versions, debug endpoints and unused routes are listed and either protected or removed.

## Cloud and infrastructure as code
[OWASP Top 10: Security Misconfiguration]

- Storage buckets and blobs are private by default; public access blocks are on; no public snapshots or AMIs.
- IAM is least privilege: no `*` actions or resources without a stated reason, no long-lived user keys where roles work, no admin policy on a workload role. Check trust policies for who can assume a role.
- Security groups and firewalls: no `0.0.0.0/0` on SSH, RDP, databases or admin ports. Databases are not publicly reachable.
- Encryption at rest and in transit enabled; backups encrypted and access-controlled.
- Metadata service uses IMDSv2 or equivalent; containers do not run as root or privileged, and have read-only filesystems where possible.
- Audit logging (CloudTrail or equivalent) is on and centralised. IaC state files are access-controlled and hold no plaintext secrets.
- Kubernetes: network policies, no default service account tokens mounted unnecessarily, no `hostPath` or `privileged` without justification, secrets not in plain ConfigMaps.

## Web: headers, CORS, CSRF
[OWASP Top 10: Security Misconfiguration, Broken Access Control. API Top 10: Security Misconfiguration]

- CSRF: state-changing requests need a token or rely on `SameSite` cookies plus a custom header or `Origin` check. GET never changes state.
- CORS: no `Access-Control-Allow-Origin: *` together with credentials; no reflecting the request `Origin` without an allowlist; `null` origin not allowed.
- Headers: `Strict-Transport-Security`, `Content-Security-Policy` (no blanket `unsafe-inline`), `X-Content-Type-Options: nosniff`, `Referrer-Policy`, `frame-ancestors` or `X-Frame-Options`. Cache-Control prevents caching of authenticated responses.
- Rate limiting and resource limits on expensive or sensitive endpoints (login, reset, search, export, GraphQL depth and complexity).
- Debug modes, default credentials, directory listings and verbose errors are off in production.
- Sensitive business flows (checkout, coupon redemption, signup) are protected against automated abuse.

## LLM and agent applications
[OWASP Top 10 for LLM Applications: Prompt Injection, Sensitive Information Disclosure, Excessive Agency, Insecure Output Handling]

- Treat all retrieved or user-supplied content (web pages, emails, documents, tool results, issue text) as untrusted instructions-in-waiting. Anything the model reads can try to steer it.
- Identify the "lethal trifecta": access to private data, exposure to untrusted content, and a way to send data out (HTTP, email, rendered image or link URLs). If all three are present in one session, break one of them.
- Tool permissions: least privilege per tool; read-only by default; destructive or external-effect actions (send, delete, pay, deploy, shell) require human approval or a policy check outside the model. Enforce limits in code, not in the system prompt.
- The agent runs with its own scoped credentials, not the developer's or the user's full identity. Tenant and user context comes from the session, never from model output.
- Model output is untrusted: do not pass it to a shell, SQL, `eval` or HTML without the same validation as user input. Render markdown links and images with care (exfiltration through URLs).
- Sandboxing: filesystem and network egress limits for code-execution tools; no ambient access to secrets or metadata endpoints.
- MCP servers and plugins are third-party code: review, pin and limit what they can reach.
- Logs and traces of prompts may contain PII and secrets; apply the same retention and redaction rules.
