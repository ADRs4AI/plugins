# DIRECTORY.md — the claude.ai directory submission runbook — **SUBMITTED 2026-10-20** (v0.1.2 @ 968d7aa, the founder's hands; in Anthropic's review queue)

**Live state**: scan → held items → human reviewer → approval → publish (first version published by founder or reviewer; pressing Publish early = recorded as a request). Watch surface: the portal's **Submissions** page + the plugin's page (account-side — the founder relays; seats cannot see it). Data handling answered No · No · Not retained · No; 4/4 acknowledgements; compliance contact `compliance@adrs.systems`; listed on all three surfaces. **Remaining founder minute**: the GitHub push webhook (URL + secret from the plugin's page → repo Settings → Webhooks; the secret goes browser→GitHub only, never through a model). Auto-publish-on-passing is posture-A-compatible either way: the tracked TAG is the throttle.

The GitHub door (`/plugin install adr --marketplace ADRs4AI/plugins`) needs no submission and works the moment this repo is public. THIS file is the runbook for the second door: Anthropic's plugin directory (claude.ai + Cowork reach, account-sync). Facts verified 2026-10-19 against claude.com/docs/directory/publish, /plugins/submit, /plugins/pre-submission-checklist, and the Software Directory Policy/Terms.

## Decisions that are FIXED FOREVER at first submit (pre-made here, deliberately)

- **Submitting org**: the one that should hold the listing forever (first-submitter owns it). Submit as the org behind `ADRs4AI`.
- **Repository + folder** (unchangeable after submit): `ADRs4AI/plugins`, folder `plugins/adr`.
- **Tracked ref**: a TAG (update posture A — pinned, deliberate releases). First: `v0.1.0`. Each release = edit the Tracked field to the new tag in the portal (triggers the scan).

## Readiness state (what already passes)

- `claude plugin validate --strict plugins/adr` ✔ and `--strict .` ✔ (CLI ≥ 2.1.281 required for the listing fields; we run 2.1.303).
- Plugin-folder README ≥ 40 words ✔ with the one-step install line the strict validator asks for ✔.
- `plugin.json`: `license: Apache-2.0` (SPDX) ✔, `homepage` ✔, `supportUrl` → ADRs4AI/community discussions ✔ (Policy 3B wants a support channel unconditionally), `documentationUrl` → schemas.adrs.systems ✔. `privacyPolicyUrl` deliberately absent: this plugin reads no personal data and calls no remote service (Policy 3A not triggered) — the portal's Data-handling answers must say exactly that.
- Repo hygiene: no symlinks/submodules/LFS in the plugin folder ✔; no .DS_Store (gitignored) ✔; file sizes/counts far under limits ✔; dedicated repo (never submit from a meta-repo with submodules) ✔.
- Name checks: `adr` is not reserved; it IS a generic word, so expect "held for review" on the name — a hold, not a rejection. Marketplace name `adrs4ai`: allowed charset, not reserved.
- Policy §2 (Instructional Software, covers Skills): descriptions narrow + say-when-to-invoke ✔; nothing fetched-at-runtime (2F) ✔; everything human-readable (2G) ✔. Note for review: `adrs4ai-tooling` TEACHES installing other tools (its purpose, user-invoked) — defensible under 2D's "unless the user asked," stated here so the answer is ready.

## Gates still open, in order

1. **Covenant's terms read** — ✅ DONE 2026-10-19 (see "Gate 1 record" below): no blocker; grant narrow and Apache-compatible; reps true as staked; the indemnity is the one clause the founder accepts personally at gate 4 — read it there before clicking.
2. **The flip + v0.1.0 tag** — ✅ DONE 2026-10-20: the founder flipped the repo PUBLIC ~16:20Z; tag `v0.1.0` pushed at `5524e7c` (MCP wired in).
3. **The support address** — ✅ CLOSED 2026-10-20 by the founder's own word: *"this email already exists, it's already public"* — deliverability confirmed by the account holder, which is exactly what №103's wire-before-print rider waited for (the rider was insurance against printing a dead address, struck 10-19 before wiring was known; nothing was ever wrong with the address). `support@adrs.systems` may now print: README support line (rides the next tag) + the portal's compliance-contact field. `author.email` stays `hello@lumbroso.computer`.
4. **The icon — DONE** (founder's pick on the pharoscan dir card: "has to be the scales with the cog"; Pharos confirmed it IS the shipped extension icon): `plugins/adr/icon.png` (the 256px scales-with-cog, provenance vscode `media/adr-icon-scale-256.png`), wired as `icon` in plugin.json.
5. **The founder's portal hands** (account act — THE ONLY OPEN GATE as of 2026-10-20): claude.ai/directory/manage → Submit new → Plugin bundle → repo `ADRs4AI/plugins`, path `plugins/adr`, track `v0.1.0` → Validate → Data handling (no personal data; no external services; not for under-18s) → Compliance contact `support@adrs.systems` + four acknowledgements (read the indemnity first — Gate-1 record ¶3 below) → choose "GitHub push webhook" (needs repo admin) → Submit, then save the terms page as a dated acceptance receipt. First version gets human review (no published latency; "Review time isn't fixed"); "Approved" ≠ installable — only "Published" is. His click-by-click walkthrough: `lumbroso-hq/docs/walkthroughs/directory-submission-walkthrough.html` (served to his browser 2026-10-20).

## Gate 1 record — the terms read (Covenant 5 / Claude Fable 5, 2026-10-19; analysis, never legal advice)

Verified at source (two live reads of support article 13145338 + the Policy 13145358, 2026-10-19 ~16:20 UTC; fetched through a converting reader — **the binding text is the live page at submit time: re-read it then, and save a dated copy as the acceptance receipt**).

1. **The grant is narrower than the lay read and conflict-free**: the licenses cover *"descriptions of the Software and its documentation"* plus display of *"your name, trademarks, logos, and other branding"*, review/testing, and functional-metadata use — **not the Software's code**. The code travels under its own Apache-2.0, which already lets anyone (Anthropic included) reproduce and distribute it. No exclusivity, no sublicense, no modification language. Branding displayed is all ours to grant.
2. **The rights representation (four limbs) is true as staked**: (i) rights held and maintained — house-authored, rights-holder's sole-author statement, vendor outputs assigned (`adr:0033#qst-vendor-terms`), Apache root; (ii) lawful + Policy-compliant (§2D verified at source: it bars *intentionally* making Claude call external software "unless a user requested it" — the tooling skill teaches installation on the user's own ask, transparently, human-readable; the staked defense is the right shape); (iii) accuracy — portal answers must match `plugin.json`, mechanical; (iv) privacy policy only IF personal data is collected/shared — it is not, so the deliberately-absent `privacyPolicyUrl` is the *correct* posture, and the Data-handling answers must say exactly that.
3. **The indemnity is the one real personal obligation**: *"indemnify and hold Anthropic harmless from any claims, damages, or liabilities arising from or related to your Software,"* users' interactions included. Standard shape for software directories (the VS Code Marketplace agreement the extension already ships under carries the same family) — but it is **uncapped, contractual, and personal to the submitting account**, and Apache-2.0's warranty disclaimer does not shield against it (the disclaimer runs to the code's licensees; the indemnity runs to Anthropic by contract). Under the house counsel posture (`adr:0033#qst-counsel`, rec B: counsel for custom text, standard terms on the founder's go), this requires no counsel pass to submit — but gate 4's click is where the founder personally accepts it, and this paragraph exists so that click is informed. If counsel ever reviews platform terms, start here.
4. **The no-partnership bar is a terms obligation, not just prudence**: no statement suggesting partnership, sponsorship, or endorsement without prior written approval. "Available in the Anthropic directory" (factual) is fine; "official/partnered/endorsed" never — binding on launch copy, README, and docsite.
5. **Revocable and drifting by design**: removal "at any time for any reason"; terms modifiable "without prior notice." Consequences already in the cautions below, plus the receipt step added above: snapshot the terms at every submit and tracked-ref update.

## Portal validation №1 record (2026-10-20, on v0.1.0 @ 5524e7c — the founder's paste)

**1 blocking (FIXED → v0.1.1)**: `UNPINNED_NPX` — `npx @adrs4ai/mcp` without an exact pin. Legitimate, and house posture A agrees: now `@adrs4ai/mcp@0.1.0` in plugin.json (+ template stanza + skill example). Each MCP release = bump the pin here deliberately; the tracked tag moves with it.

**Holds — reviewer-confirm territory, defenses (all teaching-text, no runtime)**:
- `MCP_FORWARDS_CREDENTIAL_ENV` ×2 (`SERVICE_TOKEN` + adrs.systems in the tooling skill): the `${SERVICE_TOKEN}` string is a TEACHING EXAMPLE inside entry 4's credentials pattern (it teaches where secrets go — reference in `.mcp.json`, value in never-committed settings); no credential exists, nothing is read, the plugin's own server declares `"env"`-free stdio over local files. The finding's own text sanctions leaving it for the reviewer.
- `RUNTIME_FETCH_EXEC` (curl|bash in skill body): entry 8's Homebrew install line, quoted as documentation of an offer the HUMAN approves — the skill's whole genre is detect → explain → OFFER → verify; nothing executes at plugin load. Per the finding: documentation needs no change.
- `COMMAND_SCRIPT_NOT_FOLLOWED`: the `/adr:*` commands teach `just` recipes that live in the USER'S repo (the record layer), definitionally outside the plugin tree — the reviewer reads them in the canonical template, public at ADRs4AI/human-ai-collaboration-template-A.
- `NAME_CONFUSABLE` ×2: "adr" held against "AI事業変革シミュレーター" and "Бахтин" — validator false-positives of the confusable-normalization kind (nothing in `adr` resembles either); anticipated hold on the generic name, leave for review.
- `UNKNOWN_KEY`/`STDIO_WEB_UNSUPPORTED`/`ASSETS_PASSED_UNREAD`/github.com/adr note: informational, no action.

## Portal validation №2 record (2026-10-20, on v0.1.1 @ 7429f63 — **PASSED**, 5 warnings · 6 holds)

The pin fix cleared the blocking class. Two findings acted on toward the **Verified badge** (v0.1.2): `LAUNCHER_LOCK_MISSING`/`LAUNCHER_PACKAGE_REVIEW` — the pinned package's *transitive* ranges still resolve at install, so v0.1.2 ships `plugins/adr/package.json` (+`package-lock.json`, 98 packages, integrity hashes, `--ignore-scripts`, 0 vulnerabilities) anchoring `@adrs4ai/mcp@0.1.0`'s whole tree — "exact versions, registry sources and hashes are required for the Verified badge." Lock regenerates at each MCP pin bump (release ritual line).

**New name finding, the one real one** — `NAME_EQUALS_GITHUB_OWNER`: `adr` is also the GitHub account `github.com/adr` (the Architectural Decision Records org, adr.github.io — the field's well-known elder). Defense, honest and ready: `adr` is the field's generic initialism; our expansion is distinct and documented in-product (*Architectural Deliberation Records*, with the ADR-as-elder homage stated in `adr-madr.md`'s own header); no affiliation claimed anywhere, and the Terms' no-partnership bar is already house law. If the reviewer still wants distance, `displayName` (not `name`) is the lever — founder's call, never unilateral.

## Portal validation №3 record (2026-10-20, on v0.1.2 @ 968d7aa — **PASSED**, 4 warnings · 7 holds; the submit state)

The lockfile landed as designed — **`LAUNCHER_LOCKED`** (the Verified-badge evidence, verbatim): *"runs npx @adrs4ai/mcp@0.1.0 from package-lock.json: every dependency is pinned to an exact registry version with a strong hash (97 lock entries), so Claude Code's locked launch installs exactly this set (digest bd504893a25a9b3fdb223476332a6ce5608df105b90bc119493667dfbd6204a3)."* The one new hold, `LOCKFILE_AUTO_INSTALL`, is the expected pin-tax per its own text ("No action needed… expected for any plugin that pins… If the lockfile pins an npx-launched server, keep it"). All other findings unchanged from №2; all defenses above stand. **Terminal state: the founder submits.** After submit: name-hold review expected (generic `adr` + the github.com/adr adjacency); only "Published" = installable; the tracked-tag field moves per release (next: regenerate the lock at each MCP pin bump BEFORE tagging, so LAUNCHER_LOCKED holds its digest).

## Submit-day record (2026-10-20, the founder's hands)

- **Compliance contact**: `compliance@adrs.systems` — the founder's own pick at the portal, deliberately separated from the public `support@` ("to separate from the public address"). **Wiring confirmed, domain-wide and standing** (the founder, 2026-10-20): *all* `*@adrs.systems` forwards to `hello@lumbroso.computer` (catch-all) — №103's wire-before-print rider is satisfied for every present and future alias on the domain; no seat re-asks this, ever. (If the catch-all is ever retired, printed aliases need explicit forwards — that reversal is the only event that reopens this row.)
- **Acceptance receipts saved** (Covenant's gate-5 step, done): `docs/reference/2026-10-20-anthropic-software-directory-policy.md` + `-terms.md` (lumbroso-hq). The founder read both and endorsed them on the record — his gloss of the indemnity: accountability as a feature, "presumed innocent until shown guilty," a platform refusing to be unaccountable. The informed-acceptance click the Gate-1 record ¶3 asked for: achieved, enthusiastically.
- **Pre-submit hold roll-up seen and expected**: pinned-npx · credential ×2 (teaching text) · lockfile-install · unfollowed scripts · name ×2 — all defended in the validation records above; submitted through them by design.

## Step-2 (Listing details) decisions — recorded at first submit, 2026-10-20

- **Surfaces**: all three ticked (Claude Code, Cowork, Claude apps) — the teaching skills serve web chat too; the portal itself notes the stdio MCP runs only in Code/Cowork (expected physics, the `STDIO_WEB_UNSUPPORTED` informational), and commands load as skills on web.
- **privacyPolicyUrl absent = deliberate and correct** (no personal data, no external service; Covenant gate-1 limb iv) — the listing's "Not set" is the intended state, matching the Data-handling answers.
- **termsOfServiceUrl absent = deliberate**: software under Apache-2.0, not a service under terms; adding one later is Covenant's lane, never a mid-submit improvisation.
- **Classification**: auto-fill accepted at first submit; a `classification` block in plugin.json is the lever if auto reads wrong (future release, not a resubmit).

## Standing cautions (from the Terms, for whoever operates this)

Anthropic may remove a listing at any time and may change terms without notice — **the GitHub door stays the always-available install path** and every ADRs4AI surface teaches it first. Never present the plugin as official/partnered. Never change a published plugin's name. Submission cadence limit: 10/org/24h.
