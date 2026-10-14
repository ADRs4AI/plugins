# Quick Start Card

**Streamlined Human-AI Collaboration System A** — version: see [CHANGELOG.md](CHANGELOG.md). (No number here on purpose: hardcoded versions rotted in this card twice — header and footer disagreed for months — and in README through five releases.)

---

## 30-Second Overview

This system preserves valuable conversations by turning them into persistent artifacts.

**You**: Dump thoughts naturally → **Claude**: Adds structure → **Together**: Make decisions that persist

---

## Essential Files (3)

1. **CLAUDE.md** - Claude reads this at session start
2. **seed.md** - For brain dumps
3. **adr.md** - For decisions

(No line counts — they rot. A real instantiator met "87 lines" against an actual 395.)

---

## The Workflow (5 steps)

```
1. Dump → Create seed-[topic].md with all your thoughts
2. Tell → "Claude, chunk this into ADRs"
3. Answer → Fill in ANS: blocks naturally
4. Decide → Claude documents with rationale
5. Persist → Decisions in version control
```

---

## Navigation Codes (6 codes)

Find anything instantly — if the `adrs-for-ai` MCP is in your session, its typed verbs come first (`list_open_questions`, `lookup`); the greps below are the floor that works with nothing installed:
```bash
QST:  # Questions     → grep -E '^### QST(-[A-Za-z0-9-]{1,24})?:' -r docs/adr/   # both forms; bare '^### QST:' misses every handled question
ANS:  # Answers       → grep 'ANS:' docs/adr/ -r
COD:  # Code examples → grep '^### COD:' docs/adr/ -r
API:  # API calls     → grep '^### API:' docs/adr/ -r
FIL:  # Files         → grep '^### FIL:' docs/adr/ -r
DOC:  # Documentation → grep '^### DOC:' docs/adr/ -r
NOT:  # Notes, remarks, comments, observations → grep 'NOT:' docs/adr/ -r
```

---

## File Structure

```
project/
├── CLAUDE.md              # Customize this per project
├── docs/adr/
│   ├── seed-*.md          # Brain dumps
│   ├── 0001-*.md          # ADRs (numbered)
│   └── templates/         # Templates
├── docs/inbox/            # Crew layer: registry, briefs, ONBOARDING (multi-participant projects)
├── justfile               # Coordination recipes (just adr / brief / safe-commit / ...)
└── [your code]
```

---

## When to Use What

| Have... | Use... |
|---------|--------|
| Messy thoughts | seed.md |
| Complex decision | adr.md |
| Simple decision | adr-madr.md (MADR) |
| Quick question | Just ask (escalate if needed) |

---

## Customize CLAUDE.md

Replace these sections:
```markdown
### What we're building:
[Your project description]

### Current focus:
[What you're working on now]

### Key decisions made:
- [Decision 1] - See docs/adr/0001-*.md
```

---

## Success Check

✅ Important decisions don't disappear
✅ New AI instances continue seamlessly  
✅ Find past decisions in <10 seconds
✅ Process feels helpful, not burdensome

---

## First Session

1. Tell Claude: "I've dumped thoughts in seed-[topic].md"
2. Claude creates ADRs
3. You answer questions
4. Decisions documented
5. Done

---

## Core Principle

**Conversations have value. Preserve them without ceremony.**

---

## Learn More

- **README.md** - Full documentation
- **METHODOLOGY.md** - The "why"
- **docs/inbox/ONBOARDING.md** - The crew layer (seats, briefs, recipes), when more than one participant works the repo
- **QuestionTours** - when many questions await one human sitting, bundle them (the `question-tours` skill is the authority) — O(N) open questions become O(1) focused attention

---

## Version

See [CHANGELOG.md](CHANGELOG.md) — every release is tagged and dated there. (Card originally streamlined by Claude Sonnet 4.5, Nov 2025; de-versioned 2026-10-07 after a cold instantiator met a header saying v3.2 and a footer saying v3.0 in the same read.)

---

**Ready? Start with Claude Code.** 🚀

---

*Print this card. Keep it handy. Start preserving conversations.*
