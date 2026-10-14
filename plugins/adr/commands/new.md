---
description: Mint the next-numbered ADR (deliberation mold by default; pass "madr" after the title for the simple-decisions form)
argument-hint: <title> [madr]
---

Create the next sequentially numbered ADR in this repository.

1. **Load the `adr-authoring` skill first** (Skill tool) — available is not loaded; the skill IS the read-the-template step, and a skeleton filled without it ships unstructured questions.
2. Determine the next number: list `docs/adr/`, find the highest `NNNN-` prefix, increment (zero-padded to four digits). Create `docs/adr/` if the repo has none.
3. Slug the title: lowercase, non-alphanumerics to hyphens, collapse repeats, drop apostrophes entirely.
4. If the repo has a `justfile` with an `adr` recipe, prefer `just adr "<title>" [mold]` — it does steps 2–3 and copies the right mold. Otherwise copy the mold yourself: `docs/adr/templates/adr.md` (deliberation, default) or `docs/adr/templates/adr-madr.md` (simple already-made decision — the user saying "madr", "simple", or describing a decision that needs recording rather than discussion picks this). No local molds? Use the skill's §2 minimal shape directly.
5. Fill the frontmatter (Date, Iteration 1, Status Draft, Deciders) and the mandatory one-line **TL;DR**. Mold slots in square brackets are per-mint fills; the literal `[Fill this in]` under an ANS marker is parser-significant — leave it exactly as written until a real answer exists.
6. Every question gets the full block: `### QST:` (or `### QST-<ID>:` when anything will cite it), `- Status: unanswered`, `- Why asking:` (self-contained — the answerer may read only this block), `- Need:`, an Options block (one option per bullet, letter + bold petname + evaluable description), and a **Recommendation** with rationale, confidence-with-because, and *If wrong*. No enumerable options → `Options: none (elicitation)`.

$ARGUMENTS
