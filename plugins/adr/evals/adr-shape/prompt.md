---
max_turns: 15
---

Our team just made a decision I need recorded before we lose the reasoning.

We chose PostgreSQL over SQLite for the ingestion service. The driver was concurrent writers: the collector fleet writes in parallel and SQLite's writer lock serialized them; we also weighed operational cost (we now need a managed instance) and migration effort (two weeks, acceptable). One thing is still open: whether we pin Postgres 16 or track the latest major — I want my tech lead to make that call, with your recommendation attached.

Please create the decision record in `docs/adr/` of the current directory.
