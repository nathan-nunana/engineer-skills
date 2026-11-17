# <Title: the problem or feature, as a noun phrase>

<!-- Keep it as short as the decision allows. Delete sections that don't apply. -->

- Author: <name>
- Reviewers: <names>
- Status: <Draft | In review | Accepted | Rejected>
- Date: <YYYY-MM-DD>
- Decision deadline: <YYYY-MM-DD>

## Summary

<!-- Three sentences: the problem, the proposed approach, the main trade-off. A busy reader stops here. -->

<summary>

## Problem

<!-- Who is affected, what hurts today, evidence (metric, incident, customer request). -->

<problem>

## Goals and non-goals

<!-- Goals: outcomes with a measure. Non-goals: things a reader might expect that this does not do. -->

Goals:
- <goal and how it is measured>

Non-goals:
- <non-goal>

## Requirements

<!-- Functional first. Non-functional with numbers; mark assumptions as "assumed". -->

Functional:
- <behavior>

Non-functional:
- Latency: <p50 and p99 per operation>
- Throughput: <peak QPS>
- Availability: <SLO and what counts as down>
- Consistency and durability: <what may be stale, RPO, RTO>
- Cost: <ceiling>
- Compliance and security: <PII, residency, audit, access model>

## Estimates

<!-- Inputs, arithmetic and conclusion. Show peak and growth. -->

```
<input> x <input> = <result>
```

Conclusion: <what the numbers imply>.

## Options

<!-- Two or three credible options, including the simplest. Add a diagram per option if it helps. -->

### Option A: <name>

<description, what it's good at, what breaks first>

### Option B: <name>

<description>

### Comparison

| | A: <name> | B: <name> | C: <name> |
|---|---|---|---|
| <requirement that matters> | <result> | <result> | <result> |
| Build effort | <estimate> | <estimate> | <estimate> |
| Run cost and load | <estimate> | <estimate> | <estimate> |
| Main risk | <risk> | <risk> | <risk> |

## Decision

<!-- The chosen option and the two or three reasons that decided it. What we give up. What would make us revisit. -->

We choose <option> because <reasons>. We give up <trade-off>. We revisit if <trigger>.

## Design

<!-- Components and data flow (diagram), data model, API shape, failure modes per dependency, scaling path, security
and privacy. -->

### Architecture

<diagram or description>

### Data model

<tables or entities>

### API

<endpoints or interfaces>

### Failure modes

| Failure | What the user sees | Handling |
|---|---|---|
| <dependency down or slow> | <behavior> | <timeout, retry, fallback> |

## Rollout and migration

<!-- Phases, flags, data migration steps, rollback at each step, success check per phase. -->

1. <phase, gate, rollback>

## Observability

<!-- SLIs, dashboards, alerts with thresholds, logs and traces, capacity alarms. -->

- <metric>: alert when <threshold>

## Risks

| Risk | Likelihood | Impact | Mitigation or owner |
|---|---|---|---|
| <risk> | <low/med/high> | <low/med/high> | <action> |

## Open questions

<!-- Each with an owner and a date. -->

- <question>: <owner>, by <YYYY-MM-DD>

## Follow-ups

- Record the accepted decision as an ADR.
