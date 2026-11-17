---
name: testing-strategy
description: Decide what to test and at which level, and produce a risk-based test plan for a feature or change, plus guidance on test doubles, flaky tests, coverage, property-based and snapshot tests, and test data builders. Use when asked to "write a test plan", "what should I test", "how do I test this", "unit vs integration vs e2e", "mock or fake", "fix flaky tests", "improve coverage" or "test pyramid". Not for reviewing a PR in general; use code-review. Not for security testing; use security-review.
---

# Testing strategy

Tests exist to catch the regressions that would hurt, cheaply and quickly, and to let people change code without fear. Choose each test's level by the risk it covers and the cost of running it.

## Procedure: write a test plan for feature X

1. **Understand the feature.** Read the spec or ticket and the code it touches. Write the behaviour as 3 to 8 plain statements ("a user can redeem a coupon once"). Ask the user for missing rules; where you must assume, list the assumption.
2. **List risks.** For each behaviour ask what breaks, how likely it is, and how bad it is. Consider money, data loss, security, external integrations, concurrency, migrations, time and timezones, and anything that is hard to undo. Rank high, medium, low.
3. **Map each risk to the cheapest level that catches it** using the table below. A rule in a pure function gets a unit test. A query gets an integration test against a real database. A wiring or contract issue between services gets a contract test. Reserve end-to-end for a few critical user journeys.
4. **List cases per risk:** the happy path, boundaries (0, 1, max, max+1), invalid input, empty and duplicate, failure of each dependency (timeout, 5xx, partial write), idempotency and retries, concurrency, permissions.
5. **Choose doubles and data.** For each dependency say real, fake, stub or mock, and how test data is built (builders). Name the fixtures and environments needed.
6. **State what is not tested and why** (low risk, covered elsewhere, manual only), plus non-functional checks (performance, accessibility, security) with how they will be covered.
7. **Write the plan** by copying `templates/test-plan.md`. Order the work by risk so the highest risks are covered first.
8. **If a legacy area has no tests,** add characterisation tests that pin current behaviour before changing it.

## Choosing the level

| Level | Covers | Speed | Use for |
| --- | --- | --- | --- |
| Unit | One function or class, no I/O | ms | Business rules, parsing, calculations, state machines, edge cases |
| Integration | Your code with a real dependency (database, queue, filesystem, HTTP server in-process) | 10 ms to s | Queries and migrations, repositories, serialization, middleware, framework wiring |
| Contract | The agreed request and response shape between a consumer and a provider | s | Service-to-service and third-party APIs; catches drift without running both systems |
| End-to-end | The deployed system through its real interface | s to min | A handful of critical journeys (sign up, pay, core workflow); smoke tests after deploy |

Pyramid versus trophy: the pyramid puts many unit tests under fewer integration and e2e tests. The trophy puts most weight on integration tests because they check real wiring with few mocks, with static analysis below and a thin e2e layer above. Pick by where your bugs live. Logic-heavy code (pricing, parsers) leans pyramid. Glue-heavy services (CRUD over a database and queues) lean trophy. Either way, keep e2e small, because it is slow and flaky, and avoid testing the same rule at every level.

## Test doubles

- **Fake:** a working lightweight implementation (in-memory repository, local fake of a queue). Prefer fakes at your own boundaries. They keep tests about behaviour and survive refactoring.
- **Stub:** returns canned answers. Use to set up a scenario (the payment API returns a decline).
- **Mock:** records calls and verifies them. Use sparingly, only when the interaction itself is the behaviour (an email was sent once, an audit event was emitted).
- **Spy:** wraps the real thing and records calls.
- Don't mock what you don't own: wrap third-party clients in a thin adapter you own, fake that adapter, and cover the adapter itself with an integration or contract test.
- Don't mock the thing under test or value types. Use the real object.
- Prefer a real database (container or in-process) over mocking the data layer. Mocked SQL proves nothing about the SQL.

## Test behaviour, not implementation

- Assert on outputs, state and observable side effects, through the public interface.
- A refactor that keeps behaviour must not break tests. If it does, the tests were coupled to internals (private methods, call order, exact SQL strings).
- Name tests as specs: `rejects_expired_coupon`, `charges_customer_once_when_retried`, `returns_404_for_other_tenants_invoice`. A failing test name should say what broke.
- Structure: arrange, act, assert, one behaviour per test. A few related asserts are fine; a test with ten unrelated asserts is not.
- A test you never saw fail may not test anything. Break the code once to see it go red.

## Flaky tests

A flaky test is a bug: quarantine it with a ticket and a deadline, then fix the cause. Do not retry-until-green.

| Cause | Fix |
| --- | --- |
| Time (`now()`, timezones, DST, month ends) | Inject a clock; set the time in the test; test across boundaries on purpose |
| Order dependence, shared state (globals, database rows, files, env vars) | Isolate per test: fresh fixtures, transactions rolled back, unique names or ports, no reliance on run order; run in random order in CI |
| Network and third parties | Fake or record; no real network in unit or integration tests |
| Concurrency and async | Wait on a condition or event, never a fixed sleep; make the code expose completion (a promise, a channel) |
| Timeouts too tight under load | Use generous deadlines for tests that are not about timing (seconds, not milliseconds); only tests of timing behaviour use tight, injected-clock checks |
| Randomness | Seed it and print the seed on failure |
| Resource leaks, port clashes | Bind to port 0, clean up in teardown |
| Slow CI machines | Don't assert on wall-clock duration; measure performance in a dedicated benchmark |

When you can't reproduce, run the test in a loop (hundreds of times) in parallel and under CPU stress, and look at what differs between a pass and a failure.

## Coverage

Treat coverage as a smell detector. Uncovered code shows where nothing checks behaviour; high coverage does not show that behaviour is checked. Don't set a target that people will game with assertion-free tests. Review uncovered branches in changed code instead, and look at the risky ones. Mutation testing is a better measure of test strength where you can afford it.

## When to use other techniques

- **Property-based tests** (Hypothesis, fast-check, proptest, QuickCheck): when there is an invariant over many inputs. Round-trips (`decode(encode(x)) == x`), idempotence, ordering and sorting properties, comparisons with a slow oracle, parsers that must not crash. Keep example tests for the known edge cases. Save and commit failing seeds as regular tests.
- **Snapshot tests:** for stable, reviewable output such as rendered components, CLI help, generated code, API payloads. Keep snapshots small and deliberate, review every snapshot diff, and avoid them for large or volatile output where people just press "update".
- **Test data builders:** a function or class with sensible defaults and overrides (`anOrder().withStatus("paid").build()`). Tests show only the fields that matter to them, and a schema change is fixed in one place. Avoid shared global fixtures that every test mutates.
- **Golden files and approval tests:** for complex outputs where a hand-written expected value is impractical.

## Example (excerpt of a test plan)

Feature: coupon redemption at checkout.

```
Behaviours: B1 a valid coupon reduces the total. B2 a coupon can be redeemed once per customer.
B3 expired or unknown coupons are rejected with a clear error.

Risks: R1 double redemption under concurrent requests (high: revenue loss).
R2 discount math rounding (medium). R3 coupon service timeout blocks checkout (medium).

| Risk | Level | Cases | Doubles |
| R1 | integration | two parallel redeem calls: one succeeds, one gets "already used" | real Postgres |
| R2 | unit | 10% of 0.05, 33.33% of 100.00, discount larger than total | none |
| R3 | integration | coupon API times out: checkout continues at full price, event logged | fake coupon client with delay |
| B3 | unit + 1 e2e | expired, unknown, wrong currency; e2e: UI shows the error | none |

Not tested: coupon admin UI (separate plan). Manual: email template rendering.
```

## Common failures

- **Testing the mock:** the test only checks that stubbed calls return stubbed values. Use a fake or the real dependency.
- **Ice-cream cone:** most tests are slow e2e or manual. Push checks down to the lowest level that can catch them.
- **Coverage chasing:** assertion-free tests to hit a number. Delete them and test behaviour.
- **Asserting on implementation:** call counts, private methods, internal state. Assert on outcomes.
- **Sleep-based waits:** replace with waiting on a condition.
- **Shared fixtures:** one big dataset every test depends on. Use builders per test.
- **One happy-path test per feature:** no boundary, error or concurrency cases where the risk is.
- **Plan with no ranking:** a list of every possible test. Rank by risk and say what is skipped.

## Done check

- [ ] Behaviours are listed and each has at least one test or an explicit "not tested because".
- [ ] Risks are ranked and the highest ones have tests at a level that can catch them.
- [ ] Each test level choice is justified; e2e is limited to critical journeys.
- [ ] Doubles are fakes at boundaries; mocks only where the interaction is the behaviour.
- [ ] Time, randomness and network are controlled in tests.
- [ ] Tests are named as specs and pass when run in random order and in parallel.
- [ ] Assumptions and open questions are written down.
