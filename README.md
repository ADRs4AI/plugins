# ADRs4AI Plugins

The plugins of [ADRs4AI](https://github.com/ADRs4AI) — durable human-AI collaboration via **Architectural Deliberation Records**. This repo is both the marketplace (`adrs4ai`) and the home of its flagship plugin (`adr`).

```
/plugin marketplace add ADRs4AI/plugins
/plugin install adr@adrs4ai
```

## What `adr` carries (v0.1.0)

| Component | What it does |
|---|---|
| `adr-authoring` skill | Writing parseable ADRs, seeds, and QST/ANS blocks — the template's minimal shape, the question grammar, the catch-the-author Recommendation form, and the real-world malformations that break parsing |
| `adrs4ai-tooling` skill | The toolchain, taught as detect → explain → offer → verify (VS Code extension, MCP, terminals, pneumatic, kintsugi) — including spore mode for repos that never had the methodology |
| `question-tours` skill | Bundling many open questions into one scheduled human sitting — create → assemble → cold-walk → mint → retire |
| `/adr:new <title> [madr]` | Mint the next-numbered ADR (deliberation mold, or the MADR simple-decisions form) |
| `/adr:unanswered` | What is blocked on the human right now — anchored to real QST headings, never bare status greps |
| `/adr:qst-lint` | The four malformation classes that make questions invisible to parsers, reported loudly |
| `evals/` | The quality signature: `claude plugin eval plugins/adr` runs a with/without ablation measuring whether the teaching changes model behavior |

**Coming**: the `@adrs4ai/mcp` server config joins the moment the package publishes (typed verbs over the deliberation record — `list_open_questions`, `answer_question`, `apply_batch`); an LSP exploration is on the roadmap.

## Where the method itself lives

The plugin is the **operator layer** — it follows the person. The **record layer** (templates, molds, the repo-resident teaching) ships with the [canonical template](https://github.com/ADRs4AI/human-ai-collaboration-template-A) and stays self-contained in every adopted repo: a cloned repo must teach from one URL with no install step. This repo is itself a kintsugi-adopted instance of that template; `kintsugi.lock` is each release's bill of materials, mapping every bundled artifact to the canonical version it derives from.

- Design record: HQ ADR-0041 (the four ruled questions: one repo both roles · scope B with the eval suite · pinned versions with deliberate releases · reach C-as-architecture, B-as-v1). Names: hub ledger №77/№78.
- Updates: versions are **always pinned** — releases are deliberate, the CHANGELOG is the user-facing notes, and third-party marketplaces have auto-update off by default: enable it for this marketplace with one toggle, or run `/plugin marketplace update adrs4ai` on your own rhythm.
- Hooks policy: none ship active. Anything that acts *on* your session rather than *for* it arrives dormant-by-default, opt-in per seat — install-is-consent only where installer and affected party are the same mind.

## License

MIT — see [LICENSE](LICENSE).
