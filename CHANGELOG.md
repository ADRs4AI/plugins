# Changelog

All notable changes to the `adrs4ai` marketplace and its plugins are recorded here. This file doubles as the user-facing release notes (ADR-0041 update posture A: versions are always pinned; releases are deliberate). The template lineage this repo was born from keeps its own history in [the canonical repo](https://github.com/ADRs4AI/human-ai-collaboration-template-A/blob/main/CHANGELOG.md).

## [Unreleased] — assembling as adr@0.1.0 (first release rides the founder's word)

- **License: Apache 2.0** (the founder's word, 2026-10-18 — template and plugin together; manifests + LICENSE swapped).
- **Repo born** 2026-10-13 from `ADRs4AI/human-ai-collaboration-template-A` (template generation; instantiated same day — placeholders filled, birth fixtures removed per the three-class taxonomy, `kintsugi` lock = bill of materials).
- **Marketplace manifest** (`adrs4ai`) + **flagship plugin `adr`** per HQ ADR-0041 (Accepted) and Mint №77/№78 (repo `ADRs4AI/plugins`; flagship named by its artifact; marketplace by the house).
- **Skills (cargo, interim)**: `adr-authoring`, `adrs4ai-tooling`, `question-tours` — byte-identical copies of the canonical template's skills at the lock's pinned version; they swap to `kintsugi adopt --profile plugin-operator` delivery when kintsugi v0.13 ships profiles (declared in `kintsugi.yaml`). Adaptations never happen here — they travel upstream to canonical and return by release.
- **Commands**: `/adr:new <title> [madr]`, `/adr:unanswered`, `/adr:qst-lint`.
- **Eval suite**: `adr-shape` founding case — **signature measured 2026-10-19: with 1.00 / without 0.00 / Δ +1.00 over 6 runs** (every with-arm run writes a fully parseable ADR, judge unanimous, the `adr-authoring` skill confirmed firing; zero without-arm runs do — the wild baseline, where 76% of ~1,100 specimens skip the TL;DR alone). Proof: `proof/2026-10-19-adr-shape-ablation.txt`. Case form lesson staked in `evals/README.md`: an llm grader judging created files needs `focus: trace` (the default judges only the final message — the first run's 0.00×6 was grader blindness, caught and rebuilt).
- **Deliberately absent, by ruling**: hooks (dormant-by-default is a requirement, not a courtesy — none ship in v1); the `.mcp.json` stanza (lands the day `@adrs4ai/mcp` publishes, HQ ADR-0039 — the plugin hosts, never mints: its MCP config will declare no corpus roots); pneumatic bundling (teach, don't bundle — tools with their own front door stay taught).
