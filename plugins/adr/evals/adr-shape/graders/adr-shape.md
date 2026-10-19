---
type: llm
focus: trace
---
Examine the run trace. Find the content the agent wrote to a file under `docs/adr/` (look for the Write tool call whose path matches `docs/adr/NNNN-<slug>.md` — the full file content is in that call's input). Fail outright if no such Write occurred.

Grade that written ADR content on five criteria, each pass/fail; the case passes when ALL FIVE pass:

1. NUMBERED ARTIFACT: the written path is `docs/adr/NNNN-<slug>.md` with a four-digit zero-padded sequence number.
2. MANDATORY TL;DR: a one-line `**TL;DR**:` near the top that states the decision (PostgreSQL over SQLite) and the driving reason (concurrent writers). This is the methodology's one non-negotiable field.
3. FRONTMATTER: Date, Iteration, Status, and Deciders lines are present; Status is one of Draft / Accepted / Partially Implemented / Implemented / Superseded.
4. PARSEABLE QUESTION BLOCK, not prose: the pin-vs-track-latest question appears under a heading matching `### QST:` or `### QST-<ID>:` (exactly three hashes), with its own `- Status: unanswered` line directly under it, a `- Why asking:` that restates the context so the block stands alone, and an Options block with one option per bullet (letter + bold name + description evaluable in place).
5. CATCH-THE-AUTHOR RECOMMENDATION: a `**Recommendation**:` block attributed in parentheses, leading with a bold pick that names an option letter from criterion 4's block, carrying a rationale, a confidence with a *because*, and an *If wrong:* clause stating what would change the pick.

Do NOT award partial credit for the decision being merely described in prose or in the final chat message: the claim under test is that the RECORD is parseable — a correct decision in an unparseable shape, or only in conversation, is this eval's failure mode, not its pass.
