# Changelog

All notable changes to the `adrs4ai` marketplace and its plugins are recorded here. This file doubles as the user-facing release notes (ADR-0041 update posture A: versions are always pinned; releases are deliberate). The template lineage this repo was born from keeps its own history in [the canonical repo](https://github.com/ADRs4AI/human-ai-collaboration-template-A/blob/main/CHANGELOG.md).

## [Unreleased] — assembling as adr@0.1.0 (first release rides the founder's word)

- **Repo born** 2026-10-13 from `ADRs4AI/human-ai-collaboration-template-A` (template generation; instantiated same day — placeholders filled, birth fixtures removed per the three-class taxonomy, `kintsugi` lock = bill of materials).
- **Marketplace manifest** (`adrs4ai`) + **flagship plugin `adr`** per HQ ADR-0041 (Accepted) and Mint №77/№78 (repo `ADRs4AI/plugins`; flagship named by its artifact; marketplace by the house).
- **Skills (cargo, interim)**: `adr-authoring`, `adrs4ai-tooling`, `question-tours` — byte-identical copies of the canonical template's skills at the lock's pinned version; they swap to `kintsugi adopt --profile plugin-operator` delivery when kintsugi v0.13 ships profiles (declared in `kintsugi.yaml`). Adaptations never happen here — they travel upstream to canonical and return by release.
- **Commands**: `/adr:new <title> [madr]`, `/adr:unanswered`, `/adr:qst-lint`.
- **Eval suite**: `adr-shape` founding case (with/without ablation on the five structural properties; wild baseline: 76% of ~1,100 specimens skip the mandatory TL;DR).
- **Deliberately absent, by ruling**: hooks (dormant-by-default is a requirement, not a courtesy — none ship in v1); the `.mcp.json` stanza (lands the day `@adrs4ai/mcp` publishes, HQ ADR-0039 — the plugin hosts, never mints: its MCP config will declare no corpus roots); pneumatic bundling (teach, don't bundle — tools with their own front door stay taught).
