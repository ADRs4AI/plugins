# adr — the ADRs4AI methodology, as a plugin

Durable human-AI collaboration via **Architectural Deliberation Records**: decisions, questions, and answers kept as parseable, git-tracked artifacts instead of vanishing conversation. This plugin is the methodology's **operator layer** — it follows you across every repository, whether or not that repo adopted the [ADRs4AI template](https://github.com/ADRs4AI/human-ai-collaboration-template-A).

**Install** (one step, Claude Code 2.1.275+):

```
/plugin install adr --marketplace ADRs4AI/plugins
```

(or in two: `/plugin marketplace add ADRs4AI/plugins` → `/plugin install adr@adrs4ai`)

**What it carries:**

- **`adr-authoring`** — writing parseable ADRs, seeds, and question blocks: the minimal shape, the question grammar, the catch-the-author Recommendation form, and the real-world malformations that silently break parsing (drawn from a corpus of ~1,100 real specimens).
- **`adrs4ai-tooling`** — the surrounding toolchain, taught as *detect → explain → offer → verify*, including a spore mode for repos that never had the methodology.
- **`question-tours`** — bundling many open questions into one scheduled human sitting: create → assemble → cold-walk → offer → retire.
- **Commands**: `/adr:new <title> [madr]` (mint the next-numbered record), `/adr:unanswered` (what awaits a human, anchored to real question headings), `/adr:qst-lint` (the four malformation classes, loudly).

**Measured, not claimed**: the bundled eval suite's with/without ablation scores Δ +1.00 on the founding case — with the plugin, every run produced a fully parseable decision record; without it, none did. Re-run it yourself: `claude plugin eval plugins/adr --allow-tools Write`.

**Support & docs**: questions and issues → [ADRs4AI/community](https://github.com/ADRs4AI/community) (the project's public front desk) or this repo's issues. The methodology's reference corpus: [schemas.adrs.systems](https://schemas.adrs.systems). License: Apache 2.0.
