---
description: Find malformed or dialect QST blocks that parsers silently miss — the four real-world malformation classes, loudly
---

Lint this repository's `docs/adr/` for question blocks that LOOK like questions to a human but are invisible or wrong to every parser. The four classes, each from a real uncorrected corpus (counts from ~1,100 specimens):

1. **Bolded pseudo-headings** (33 instances — the largest class): `**QST-1 (…)**` as prose instead of `### QST-1: …`. Find candidates: `grep -rnE '^\*\*QST' docs/adr/ --exclude-dir=templates`.
2. **Number without hyphen** (24): `### QST 1:` where the grammar wants `### QST-1:`. Find: `grep -rnE '^### QST [0-9]' docs/adr/ --exclude-dir=templates`.
3. **Floating status** (14): a `- Status:` line with no `### QST` heading directly above it — the answer surface lies in both directions. Check each `- Status:` hit's preceding heading.
4. **Wrong heading depth** (4): `## QST` or `#### QST` — parsers warn and the section tree reshapes. Find: `grep -rnE '^(##|####) QST' docs/adr/ --exclude-dir=templates`.

Plus two completeness checks:
- **The loud twin**: a `### QST: none open`-style heading *mints* a live question asserting the opposite of itself — zero-questions is said with `NOT: no open questions — <why>` under `## Questions`, never a heading.
- **The dangling letter**: a `**Recommendation**` opening with a letter (`**A — …**`) above a QST with zero Options bullets — the letter points at a space the answerer was never given.

Report each finding as `file:line`, the class, and the one-line fix (show the corrected heading). If the repo has `just qst-lint`, run it too and reconcile. Fix only on request — this command reports.
