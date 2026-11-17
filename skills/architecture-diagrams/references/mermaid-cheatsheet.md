# Mermaid cheatsheet

Conservative syntax that works in Mermaid v10 and v11. Quote any label containing parentheses, brackets, commas,
colons or `#` with double quotes. Avoid the words `end` (lowercase) as a bare node label; write `End` or quote it.
Not verified with a renderer in the authoring environment; run `npx -y @mermaid-js/mermaid-cli -i x.mmd -o x.svg`
when you can.

## Flowchart

```mermaid
flowchart LR
  a[Rectangle] --> b(Rounded)
  b --> c{Decision}
  c -->|yes| d[(Database)]
  c -->|no| e((Circle))
  d --- f{{Hexagon}}
  e -.->|optional, async| f
  f ==>|main path| g[/Input or output/]
```

- Direction: `TD` (top down), `LR`, `RL`, `BT`.
- Shapes: `[ ]` box, `( )` rounded, `{ }` decision, `[( )]` cylinder, `(( ))` circle, `{{ }}` hexagon,
  `[/ /]` parallelogram.
- Arrows: `-->` solid, `-.->` dotted, `==>` thick, `---` no arrowhead. Label with `-->|text|` or `-- text -->`.
- Comments: a line starting with `%%`.

### Subgraphs as boundaries

```mermaid
flowchart LR
  user[User]
  subgraph vpc [VPC - trusted]
    direction TB
    api[API] --> db[(Database)]
  end
  subgraph ext [Third party]
    pay[Payment provider]
  end
  user -->|HTTPS| api
  api -->|charges card, HTTPS| pay
```

- `subgraph id [Title]` ... `end`. Subgraphs nest. Keep edges node to node; edges to a subgraph id work but behave
  oddly with `direction`.
- `direction` inside a subgraph is ignored if any node in it links outside the subgraph.

### Styling and legend

```mermaid
flowchart LR
  a[Internal service]:::internal --> b[External API]:::external
  classDef internal fill:#e8f0fe,stroke:#1a73e8,color:#000
  classDef external fill:#eeeeee,stroke:#666666,stroke-dasharray:4 3,color:#000
```

Mermaid has no legend element. Write the legend as a sentence or table under the diagram.

## sequenceDiagram

```mermaid
sequenceDiagram
  autonumber
  actor U as User
  participant W as Web app
  participant A as Orders API
  participant P as Payments
  U->>W: Submit order
  W->>+A: POST /orders
  A->>+P: Charge card
  P-->>-A: 200 charge id
  alt payment approved
    A-->>W: 201 order id
    W-->>U: Show confirmation
  else payment declined
    A-->>W: 402 declined
    W-->>U: Show error
  end
  opt user opted in to email
    A-)U: Send receipt email
  end
  loop every 5s until paid, max 3 times
    W->>A: GET /orders/id
  end
  deactivate A
  Note over W,A: Retries use the same idempotency key
```

- Arrows: `->>` solid with head (request), `-->>` dashed (response), `-)` async, `-x` lost message.
- `activate X` / `deactivate X`, or shorthand `+` after the arrow on the call and `-` on the reply. Every `+` needs a
  matching `-`.
- Blocks: `alt`/`else`/`end`, `opt`/`end`, `loop`/`end`, `par`/`and`/`end`, `critical`/`option`/`end`,
  `rect rgb(240,240,240)`/`end`.
- Notes: `Note right of A: text`, `Note over A,B: text`.
- `participant X as Label` for readable names; `actor` draws a person.

## C4 (experimental in Mermaid)

C4 diagrams in Mermaid are marked experimental. Layout is automatic and can be awkward; tune it with
`UpdateLayoutConfig`. If the renderer is old or the layout is poor, draw the same content as a `flowchart`.

### C4Context

```mermaid
C4Context
  title System context for Orders
  Person(customer, "Customer", "Places orders on the web")
  Enterprise_Boundary(co, "Our company") {
    System(orders, "Orders platform", "Takes and fulfils orders")
  }
  System_Ext(pay, "Payment provider", "Charges cards")
  System_Ext(wms, "Warehouse system", "Picks and ships")
  Rel(customer, orders, "Places orders", "HTTPS")
  Rel(orders, pay, "Charges card", "HTTPS")
  Rel(orders, wms, "Sends pick requests", "Kafka")
  UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")
```

### C4Container

```mermaid
C4Container
  title Containers in the Orders platform
  Person(customer, "Customer", "Places orders")
  System_Boundary(orders, "Orders platform") {
    Container(web, "Web app", "React", "Order UI")
    Container(api, "Orders API", "Go", "Validates and stores orders")
    ContainerDb(db, "Orders DB", "PostgreSQL", "Orders and line items")
    ContainerQueue(bus, "Event bus", "Kafka", "order.created events")
  }
  System_Ext(pay, "Payment provider", "Charges cards")
  Rel(customer, web, "Uses", "HTTPS")
  Rel(web, api, "Calls", "JSON/HTTPS")
  Rel(api, db, "Reads and writes", "SQL/TLS")
  Rel(api, bus, "Publishes order.created", "Kafka")
  Rel(api, pay, "Charges card", "HTTPS")
```

Elements: `Person`, `Person_Ext`, `System`, `System_Ext`, `SystemDb`, `Container`, `ContainerDb`, `ContainerQueue`,
`Component`, `Container_Boundary`, `System_Boundary`, `Enterprise_Boundary`, `Boundary`. All take
`(id, "label", "technology", "description")` where technology is omitted for `Person` and `System`.
Relations: `Rel(from, to, "label", "technology")`, `BiRel`, `Rel_D`, `Rel_U`, `Rel_L`, `Rel_R` to bias direction.
`C4Component` works the same way with `Component(id, "name", "tech", "desc")` inside a `Container_Boundary`.
Strings must be double-quoted; do not put double quotes inside them.

## erDiagram

```mermaid
erDiagram
  CUSTOMER ||--o{ ORDER : places
  ORDER ||--|{ ORDER_LINE : contains
  PRODUCT ||--o{ ORDER_LINE : "appears in"
  CUSTOMER {
    uuid id PK
    string email UK
    string name
  }
  ORDER {
    uuid id PK
    uuid customer_id FK
    string status
    timestamp created_at
  }
  ORDER_LINE {
    uuid order_id FK
    uuid product_id FK
    int quantity
  }
  PRODUCT {
    uuid id PK
    string sku UK
    numeric price
  }
```

- Cardinality, left side then right: `|o` zero or one, `||` exactly one, `}o` zero or more, `}|` one or more.
  Combine with `--` (identifying) or `..` (non-identifying): `A ||--o{ B : label`.
- The label after the colon is required; quote it if it has spaces.
- Attribute format: `type name [PK|FK|UK] ["comment"]`. Entity names without spaces, or quoted.

## stateDiagram-v2

```mermaid
stateDiagram-v2
  [*] --> Pending
  Pending --> Paid : payment captured
  Pending --> Cancelled : user cancels
  Paid --> Shipped : warehouse confirms
  Paid --> Refunded : refund issued
  Shipped --> Delivered : carrier confirms
  Delivered --> [*]
  Cancelled --> [*]
  state Paid {
    [*] --> Authorised
    Authorised --> Captured : capture succeeds
  }
  state if_stock <<choice>>
  Shipped --> if_stock
  if_stock --> Delivered : on time
  if_stock --> Refunded : lost
  note right of Pending
    Expires after 30 minutes
  end note
```

- Transition: `A --> B : trigger [guard] / action` as plain label text.
- `[*]` is start or end. `state X { ... }` nests. `<<choice>>`, `<<fork>>`, `<<join>>` for branching.
- Use `state "Long name" as id` when the label has spaces.
- Keep a state's composite block and its outer transitions consistent; a transition to a nested state needs the
  nested id to be unique.

## Pitfalls

- A label with `(`, `)`, `[`, `]`, `{`, `}` or `:` inside a flowchart node needs quotes: `a["Orders (v2)"]`.
- Node ids can't contain spaces; use `snake_case` ids and put the display text in the brackets.
- Don't name a node `end`, `graph` or `subgraph`. An id starting with `o` or `x` right after an edge, as in
  `A --- orders`, is read as a circle or cross edge end; capitalise the id or put a space after the arrow.
- Long labels: use `<br/>` for line breaks in flowchart labels.
- GitHub renders Mermaid in Markdown; some older GitLab and docs tools pin an old Mermaid, which can lack C4 or
  newer shapes.
