Grade the ADR file the agent created under `docs/adr/` (fail if none exists). Score each criterion pass/fail; the case passes when all five pass:

1. **Numbered artifact**: the file is named `NNNN-<slug>.md` (four-digit zero-padded sequence) inside `docs/adr/`.
2. **Mandatory TL;DR**: a one-line `**TL;DR**:` near the top that states the decision (PostgreSQL over SQLite) and the driving reason (concurrent writers). This is the methodology's one non-negotiable field — 76% of wild specimens skip it; the plugin exists to change that.
3. **Frontmatter**: Date, Iteration, Status, and Deciders lines are present; Status is one of Draft / Accepted / Partially Implemented / Implemented / Superseded.
4. **The open question is a parseable block, not prose**: the pin-vs-track-latest question appears under a heading matching `### QST:` or `### QST-<ID>:` (exactly three hashes), with its own `- Status: unanswered` line directly under it, a `- Why asking:` that restates the context so the block stands alone, and an Options block with one option per bullet (letter + bold name + description evaluable in place).
5. **A Recommendation that could catch its author**: a `**Recommendation**:` block attributed in parentheses, leading with a bold pick that names an option letter from criterion 4's block, carrying a rationale, a confidence with a *because*, and an *If wrong:* clause stating what would change the pick.

Do NOT award partial credit for the decision being merely described in prose: the claim under test is that the record is *parseable* — a correct decision in an unparseable shape is this eval's failure mode, not its pass.
