# Building blocks

Each entry: use when, costs, gotcha. Reach for these only when the estimate shows a need.

## Caching
- Use when: reads dominate, the same data is read repeatedly, and some staleness is acceptable.
- Costs: invalidation logic, a new failure mode, extra memory, harder debugging of stale data.
- Gotcha: a cold or flushed cache sends full load to the database (stampede). Use request coalescing, TTL jitter and
  load-test a cold start. Decide the invalidation rule (TTL, write-through, event) before choosing the cache.

## Queues and streams
- Use when: work can happen later, producers and consumers run at different speeds, or you need to fan out events.
  Queue for task distribution; log or stream (Kafka-style) when you need replay and many independent consumers.
- Costs: eventual consistency, ordering and duplicate handling, operating the broker, harder end-to-end tracing.
- Gotcha: delivery is at-least-once, so consumers must be idempotent. Ordering holds only within a partition or key.
  Plan the dead-letter queue and who looks at it.

## Sharding and partitioning
- Use when: data or write volume exceeds one node after vertical scaling, replicas and archiving are exhausted.
- Costs: cross-shard queries and transactions, rebalancing, operational complexity, hot-key risk.
- Gotcha: the shard key is hard to change later. Pick one that matches the dominant access pattern and spreads load
  evenly; check for hot keys (a celebrity user, a single tenant). Hash for balance, range for scans.

## Replication
- Use when: you need availability after a node loss, read scaling, or a copy in another region.
- Costs: replication lag, failover complexity, storage multiplied by the replica count.
- Gotcha: reading from a replica can return stale data right after a write ("read your writes" breaks). Test
  failover; an untested failover is not a feature. Synchronous replication trades write latency for no data loss.

## Consistency models
- Use when: choosing what readers may see. Strong (linearizable) for money, inventory, uniqueness. Eventual for feeds,
  counters, caches. Read-your-writes or causal in between.
- Costs: strong consistency costs latency and availability across regions (CAP, PACELC); weak consistency costs
  application complexity.
- Gotcha: decide per operation, not per system. Say in the doc which reads may be stale and for how long, and what
  the user sees when they are.

## Idempotency
- Use when: any operation can be retried by a client, a queue or a timeout: payments, order creation, webhooks.
- Costs: storing keys and results, defining the key's scope and lifetime.
- Gotcha: the key must come from the caller and be stored atomically with the effect (unique constraint, same
  transaction). Return the original result on a repeat, and reject the same key with a different payload.

## Rate limiting
- Use when: protecting a service from abuse or a noisy tenant, enforcing quotas, or shielding a downstream.
- Costs: shared counter state, a decision on what to key on (user, IP, API key, tenant), false rejections.
- Gotcha: token bucket allows bursts, fixed window allows double bursts at window edges. Return 429 with
  `Retry-After`. In a distributed limiter, accept approximate counts rather than a central bottleneck.

## Backpressure
- Use when: a producer can outrun a consumer. Prefer slowing or rejecting at the edge to buffering without limit.
- Costs: callers must handle rejection or slowness; lower peak throughput than an unbounded buffer promises.
- Gotcha: unbounded queues hide overload until memory runs out, then fail all at once. Bound every queue, decide
  what to shed (oldest, newest, lowest priority), and expose queue depth as a metric.

## Retries with jitter
- Use when: failures are transient (timeouts, 503, connection reset) and the operation is idempotent.
- Costs: more load on a struggling dependency, longer tail latency.
- Gotcha: retry with exponential backoff and random jitter, a cap on attempts and a total deadline. Retry at one
  layer only; nested retries multiply (3 x 3 x 3 = 27 calls). Never retry non-idempotent calls without a key.
  Don't retry on 4xx errors that won't change.

## Circuit breakers
- Use when: a dependency is failing or slow and callers waste threads or time waiting on it.
- Costs: tuning thresholds, a fallback path to build and test, one more state to observe.
- Gotcha: pair with timeouts (a breaker without a timeout never trips on slowness). Use half-open probing to
  recover. Define the fallback (cached value, degraded response, clear error) before wiring the breaker, and alert
  when a breaker opens.

## Timeouts and deadlines
- Use when: always, on every network call.
- Costs: choosing values, handling timeout errors.
- Gotcha: set the client timeout below the caller's own deadline and propagate remaining time downstream. A call
  with no timeout can hold a thread forever.
