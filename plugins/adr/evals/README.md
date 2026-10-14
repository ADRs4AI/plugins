# Eval suite — the quality signature

Run with `claude plugin eval plugins/adr` (from the repo root) — the with/without ablation is the default, and it is the point: each case measures whether the plugin's teaching *changes model behavior*, which is the methodology's own falsifiable claim (ADR-0041 QST-PLUGIN-V1-SCOPE = B, "the eval suite from day one").

- `adr-shape/` — the founding case: a realistic record-this-decision prompt; the grader scores the five structural properties the `adr-authoring` skill exists to teach (numbered artifact, mandatory TL;DR, frontmatter enum, parseable QST block, catch-the-author Recommendation). The wild baseline it tests against: 76% of ~1,100 real specimens skip the TL;DR.
- The suite grows one case per taught behavior (question-tours readiness, qst-lint classes). Release gate: the suite runs green before any `plugin.json` version bump (update posture A — pinned, deliberate).
