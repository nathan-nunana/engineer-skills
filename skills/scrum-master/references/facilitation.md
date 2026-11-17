# Facilitation: agendas and scripts

Read this when preparing or running a specific event, or when a meeting is going badly. Timeboxes are maximums for a
one-month Sprint; for shorter sprints scale them down (Planning 2 h per week, Review 1 h per week, Retro 45 min per
week). The Daily Scrum is 15 minutes whatever the sprint length.

## Facilitation basics

- Start on time and state the purpose, the timebox and the expected output in one breath.
- Use a visible timer. When time is up, ask the group to extend by a fixed amount (5 minutes) or park the topic.
- Quiet voices: ask people to write first (silent, 2–3 minutes), then share round-robin. Ask directly but kindly:
  "Sam, anything to add before we move on?". Cut off interrupters with "hold that thought, Priya is finishing".
- Parking lot: a visible list for off-topic items. Each one gets an owner or is dropped at the end of the meeting.
  Review it before closing, never skip that step.
- Stay neutral on content. Ask questions, summarise, check for agreement. If you have an opinion, say so as a
  participant and say you're stepping out of the facilitator role.
- Disagreement: restate each position, ask what evidence would change either mind, and decide with a fist-of-five
  vote or a named decision maker. Write the decision down.

## Sprint Planning (max 8 h for a month)

Agenda:
1. (5 min) Purpose and last sprint outcome. State capacity, with leave and holidays.
2. (15 min) Why: Product Owner proposes the Sprint Goal. Developers ask questions and adjust it to something they
   can commit to.
3. (40–60% of time) What: pull refined items top-down. For each: read the story, confirm acceptance criteria,
   check the size, and ask "does this serve the goal?". Stop when the forecast reaches capacity.
4. (remaining) How: break the first items into tasks, name dependencies and risks, confirm the Definition of Done.
5. (5 min) Read the goal and the forecast back. Fist-of-five confidence: below 3 means reduce scope now.

Script: "Capacity is 28 person-days, which at our recent pace is about 22 points. Product Owner, what outcome do you
want from this sprint?" Never say "I've assigned..." or "you take this one".

## Daily Scrum (15 min, Developers)

Agenda (pick one, keep it for a few sprints):
- **Goal-walk:** read the Sprint Goal, then go through the board right to left (closest to Done first). For each
  item: what is the next step, who is on it, is anything blocking it?
- **Three questions:** what helped progress toward the goal since the last daily, what will we do next, what is in
  the way. Phrase them as "we", not "I".

Close by naming impediments and the "after the daily" conversations (who, about what). The Scrum Master attends
only to keep the timebox if the team asks, and otherwise listens for impediments.

Signals it's off track: people look at the Scrum Master while talking, items are repeated without progress, the
meeting regularly runs over, or half the team is absent mentally. Ask the team in the retro how to change the format.

## Backlog refinement (ongoing, up to 10% of capacity)

Agenda (60 minutes):
1. (5 min) Pick the next 3–5 items by order in the Product Backlog.
2. (10 min per item) Product Owner explains the user need. Team asks questions and writes acceptance criteria in
   Given/When/Then. Look for splits using the patterns in SKILL.md.
3. (2 min per item) Size with planning poker. A 13 or a wide disagreement means split or run a spike.
4. (5 min) Record open questions with an owner and a date to answer them before planning.

## Sprint Review (max 4 h for a month)

Agenda:
1. (5 min) Product Owner states the Sprint Goal and whether it was met.
2. (15–30 min) Demo: the people who built it show working software in a real environment, item by item against the
   goal. Not Done items are named, not demoed.
3. (15 min) Feedback: ask each stakeholder "what would you change?" and "what is missing?". Write each point down.
4. (10 min) Product Backlog: Product Owner updates the order and adds items live. Discuss timeline, budget and the
   market with stakeholders.
5. (5 min) Agree what the next Sprint Planning will focus on.

Script for the facilitator: "Show it the way a user would use it. We will not look at code or slides."

## Sprint Retrospective (max 3 h for a month)

Run it with Developers and the Scrum Master only, unless the team agrees otherwise. Safe space: what's said stays in
the room, and the topic is the process, never a person.

Agenda:
1. (5 min) Check-in: one word on how the sprint felt.
2. (5 min) Review last retro's actions: done, not done, and why. Close or carry each one explicitly.
3. (5 min) Data: show the trends (cycle time, goal hit rate, carry-over) and any notable incidents.
4. (15–20 min) Generate observations with a format below. Silent writing first.
5. (10 min) Group similar notes, then dot-vote (3 votes each).
6. (10 min) Take the top 1–2 themes: ask "what is the smallest change we can try next sprint?".
7. (5 min) Write 1–3 actions, each with an owner and a date, and put them on the Sprint Backlog.
8. (2 min) Close: one thing someone appreciated about a teammate.

Formats (rotate every few sprints so they stay fresh):
- **Start / Stop / Continue:** three columns, a simple default.
- **4Ls:** Liked, Learned, Lacked, Longed for. Good after a milestone or a project.
- **Sailboat:** wind (what pushes us forward), anchors (what slows us), rocks (risks ahead), island (our goal).
  Good when the team needs to talk about risks.
- **Mad / Sad / Glad:** emotions first, then causes. Good after a hard sprint, and useful when morale is a concern.

Failure handling: if the retro produces only complaints about things the team can't change, ask "what is in our
control?". If the same issue returns three sprints in a row, treat it as an impediment for the Scrum Master to
escalate, and say so to the team.

## Impediment removal

1. Capture it in the daily or when raised, with who is blocked and since when.
2. Ask if the team can fix it in a day. If yes, fix it.
3. If not, the Scrum Master takes the escalation: state the impact in days or scope, the specific ask, and the
   person who can say yes. Follow up every day until closed.
4. Report closed impediments in the review or retro, so the team sees that raising them works.
