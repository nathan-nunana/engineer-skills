---
name: system-design
description: Design a system or feature and write the design doc or RFC: problem, goals and non-goals, functional and non-functional requirements, back-of-envelope estimates (QPS, storage, bandwidth), two or three options with a trade-off table, the decision, risks, rollout and migration, observability and open questions. Use when someone says "design", "design doc", "RFC", "architecture for", "how should we build", "scale", "capacity", "trade-offs" or "which approach", or before building anything that spans services or data stores. Not for diagrams alone; use architecture-diagrams. Not for recording the final decision; use an ADR from technical-docs.
---

# System design

Turn a vague "we need X" into a design a team can review: what problem, what constraints, what choices, what
decision, and what could go wrong. Numbers before opinions.

## Procedure

1. **Pin the problem.** Write two to four sentences: who is affected, what hurts today, what evidence shows it
   (metric, incident, customer ask). Ask the user for anything missing that changes the design (scale, deadline,
   existing stack, team size). If you can't ask, state assumptions explicitly and mark each one.
2. **Goals and non-goals.** Goals are outcomes with a measure. Non-goals are things a reader might reasonably expect
   but that this design will not do. Both lists are short.
3. **Requirements.** Functional: what it does, as user-visible behaviours. Non-functional, each with a number and a
   scope:
   - Latency (p50, p99, per operation), throughput (peak QPS), availability (SLO, and what counts as down).
   - Consistency (what may a reader see stale, for how long), durability (what loss is acceptable, RPO and RTO).
   - Cost ceiling, data volume and retention, compliance (PII, residency, audit, retention law), security model.
   - Operability: who runs it, on-call load, deploy frequency.
   If a number is unknown, pick one, label it an assumption, and note what changes if it's off by 10x.
4. **Estimate.** Back-of-envelope with stated inputs: QPS (average and peak), storage per day and over retention,
   bandwidth, memory for caches, number of machines. Show arithmetic. Round hard. Use the estimate to rule options
   in or out ("5k writes/s fits one Postgres primary; 500k does not").
5. **Generate options.** Two or three real alternatives, including the simplest thing that could work and, when
   relevant, "do nothing" or "buy". For each: sketch, what it's good at, what it costs (build, run, complexity), what
   breaks first. Draw the leading options with the architecture-diagrams skill.
6. **Compare in a table** against the requirements that matter, not every attribute. Then decide: name the option,
   and give the two or three reasons that tipped it. Say what would make you revisit.
7. **Detail the chosen design.** Components and data flow, data model, API shape, failure modes (what happens when each
   dependency is slow, down, or wrong), scaling path, security and privacy. Pull building blocks from
   `references/building-blocks.md` and use their "gotcha" notes as a checklist.
8. **Plan the rollout.** Phases, feature flags, migration of existing data (dual write, backfill, verify, cut over,
   delete old), rollback at each step, and the success check that gates each phase.
9. **Observability.** The SLIs that prove the requirements hold, dashboards, alerts with thresholds, logs and traces
   that let on-call debug it, and a capacity alarm.
10. **Risks and open questions.** Each risk: likelihood, impact, mitigation or owner. Each open question: who decides
    and by when.
11. **Write it up** from `templates/design-doc.md`. Keep it as short as the decision allows; a small change gets
    one page. When the decision is accepted, record it as an ADR using the technical-docs skill.

## Standard

- Every non-functional requirement has a number or is explicitly "unknown, assumed N".
- The estimate shows its inputs and arithmetic. Peak, not just average.
- At least two options are credible; a straw man doesn't count.
- The decision follows from the requirements and the estimate, and says what is given up.
- Failure modes are explicit: for each dependency, what the user sees when it fails.
- The migration path from today's state is part of the design, not an afterthought.
- Prefer boring technology the team already runs. Novelty needs a stated reason and a budget.
- Design for roughly 10x current load, not 1000x.

## Example

Problem: "Short links for marketing emails. 20M links created per month, 10:1 read to write at peak."

Estimate:

```
Writes: 20M / month / 2.6M s ≈ 8 writes/s average; peak 10x ≈ 80 writes/s
Reads:  10x writes ≈ 80 reads/s average; peak 10x ≈ 800 reads/s
Row:    short code 8 B + URL 200 B + metadata 100 B ≈ 300 B
Storage: 20M x 300 B = 6 GB/month; 5 years ≈ 360 GB, plus index ≈ 500 GB
Read bandwidth: 800/s x 1 KB redirect response ≈ 0.8 MB/s, trivial
Cache: top 1% of links take most reads: 1% x (20M x 60) = 12M rows x 300 B ≈ 3.6 GB, fits one Redis node
```

Conclusion: one Postgres primary with a read replica handles this; sharding and a custom ID service are not needed.
Options table:

| | A: Postgres + Redis cache | B: DynamoDB | C: Custom KV store |
|---|---|---|---|
| Meets 800 reads/s p99 < 50 ms | Yes | Yes | Yes |
| Operational load | Low, team knows it | Low, new to team | High |
| Cost at 500 GB | Low | Medium | Low plus engineer time |
| Verdict | Chosen | Fallback if volume grows 50x | Rejected |

## Common failures

- **Solution first:** the doc describes one design and calls it the proposal. Write the problem and requirements
  before naming technology.
- **Adjectives instead of numbers:** "highly available", "low latency". Replace with an SLO.
- **Estimates that skip peak and growth:** average QPS hides the load that causes the outage.
- **Straw-man options:** the alternatives are obviously worse. Include the simplest thing and argue it fairly.
- **Resume-driven choices:** Kafka and Kubernetes for 80 writes per second. Let the estimate decide.
- **Happy path only:** no timeouts, retries, backpressure or partial-failure story.
- **No rollout:** "we'll migrate later". Write the steps and the rollback.
- **Everything is an open question:** decide what you can; assign an owner and date to the rest.

## Done check

- [ ] Problem, goals and non-goals fit on the first page.
- [ ] Non-functional requirements have numbers or labelled assumptions.
- [ ] The estimate is shown and used in the decision.
- [ ] Two or more real options, with a trade-off table and a stated decision.
- [ ] Failure modes, security and data model are covered.
- [ ] Rollout, rollback and migration are written down.
- [ ] Metrics, alerts and open questions have owners.
- [ ] Diagrams follow the architecture-diagrams rules; the decision is queued as an ADR (technical-docs).

For the catalogue of caching, queues, sharding, replication, consistency, idempotency, rate limiting, backpressure,
retries and circuit breakers, read `references/building-blocks.md`. Fill in `templates/design-doc.md` for the
document itself.
