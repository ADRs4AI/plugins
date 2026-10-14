---
description: List every open question (QST) in this repo that is waiting on a human answer, anchored to real QST headings — never bare status greps
---

Report what is blocked on the human right now, across this repository's deliberation record.

1. If `mcp__adrs-for-ai__*` tools are in this session, use `list_open_questions` — the typed verb parses the grammar instead of reconstructing it. Otherwise:
2. Find real questions by their headings (both canonical forms — a bare `### QST:` grep silently misses every handled question):
   ```
   grep -rnE '^### QST(-[A-Za-z0-9-]{1,24})?:' docs/adr/ --exclude-dir=templates
   ```
3. For each heading, read ITS OWN following `- Status:` line (the next `- Status:` after the heading, before any next `###`). Count as open: `unanswered` (human's ball), `unresolved` (a model's ball — report separately), `deferred` (note, don't surface as urgent). A `Status:` line with no QST heading above it is a malformation, not a question — flag it, don't count it.
4. Never report a bare `grep -c 'Status: unanswered'` count: it overcounts template examples, seeds discussing the pattern, and prose mentions (a real repo reported 61 where 12 were real).
5. Present the open set grouped by file, each with: the question title, its handle (explicit `QST-<ID>` or the auto-derived slug), status, and whether a Recommendation block exists (an open question with no recommendation costs the answerer re-derivation — flag those).
6. If two or more open questions would share one answering sitting, say so and point at the `question-tours` skill — bundling is its job, not this command's.
