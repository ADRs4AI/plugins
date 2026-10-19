# DIRECTORY.md — the claude.ai directory submission runbook (staged; submit AFTER the flip + v0.1.0 tag)

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
2. **The flip + v0.1.0 tag** (publishing requires a public repo; our posture: submit after both, not the private-repo early path — it would add portal steps during the launch window for no gain).
3. **The support address (Mint №103, wake-delivered 2026-10-19)**: `support@adrs.systems` is the struck public contact (`github@` killed — a routing hint is not a contact); `author.email` stays `hello@lumbroso.computer`. **Rider, binding: the alias is WIRED before it PRINTS** — a published address is a promise. Wiring routed to Operator (forward → founder channel proposed); until deliverability is confirmed, the address appears on NO user-facing surface (README, manifest, listing) — this runbook row is its only home. On confirmation: plugin README support line + the directory's contact field (v0.1.1-class, non-gating).
4. **Pharos's icon** (optional field; branding is their surface — an in-folder image/SVG when they coin it; not a blocker).
5. **The founder's portal hands** (account act, his plan): claude.ai/directory/manage → Submit new → Plugin bundle → repo `ADRs4AI/plugins`, path `plugins/adr`, track `v0.1.0` → Validate → Data handling (no personal data; no external services; not for under-18s) → Compliance contact + four acknowledgements → choose "GitHub push webhook" (needs repo admin) → Submit. First version gets human review (no published latency; "Review time isn't fixed"); "Approved" ≠ installable — only "Published" is.

## Gate 1 record — the terms read (Covenant 5 / Claude Fable 5, 2026-10-19; analysis, never legal advice)

Verified at source (two live reads of support article 13145338 + the Policy 13145358, 2026-10-19 ~16:20 UTC; fetched through a converting reader — **the binding text is the live page at submit time: re-read it then, and save a dated copy as the acceptance receipt**).

1. **The grant is narrower than the lay read and conflict-free**: the licenses cover *"descriptions of the Software and its documentation"* plus display of *"your name, trademarks, logos, and other branding"*, review/testing, and functional-metadata use — **not the Software's code**. The code travels under its own Apache-2.0, which already lets anyone (Anthropic included) reproduce and distribute it. No exclusivity, no sublicense, no modification language. Branding displayed is all ours to grant.
2. **The rights representation (four limbs) is true as staked**: (i) rights held and maintained — house-authored, rights-holder's sole-author statement, vendor outputs assigned (`adr:0033#qst-vendor-terms`), Apache root; (ii) lawful + Policy-compliant (§2D verified at source: it bars *intentionally* making Claude call external software "unless a user requested it" — the tooling skill teaches installation on the user's own ask, transparently, human-readable; the staked defense is the right shape); (iii) accuracy — portal answers must match `plugin.json`, mechanical; (iv) privacy policy only IF personal data is collected/shared — it is not, so the deliberately-absent `privacyPolicyUrl` is the *correct* posture, and the Data-handling answers must say exactly that.
3. **The indemnity is the one real personal obligation**: *"indemnify and hold Anthropic harmless from any claims, damages, or liabilities arising from or related to your Software,"* users' interactions included. Standard shape for software directories (the VS Code Marketplace agreement the extension already ships under carries the same family) — but it is **uncapped, contractual, and personal to the submitting account**, and Apache-2.0's warranty disclaimer does not shield against it (the disclaimer runs to the code's licensees; the indemnity runs to Anthropic by contract). Under the house counsel posture (`adr:0033#qst-counsel`, rec B: counsel for custom text, standard terms on the founder's go), this requires no counsel pass to submit — but gate 4's click is where the founder personally accepts it, and this paragraph exists so that click is informed. If counsel ever reviews platform terms, start here.
4. **The no-partnership bar is a terms obligation, not just prudence**: no statement suggesting partnership, sponsorship, or endorsement without prior written approval. "Available in the Anthropic directory" (factual) is fine; "official/partnered/endorsed" never — binding on launch copy, README, and docsite.
5. **Revocable and drifting by design**: removal "at any time for any reason"; terms modifiable "without prior notice." Consequences already in the cautions below, plus the receipt step added above: snapshot the terms at every submit and tracked-ref update.

## Standing cautions (from the Terms, for whoever operates this)

Anthropic may remove a listing at any time and may change terms without notice — **the GitHub door stays the always-available install path** and every ADRs4AI surface teaches it first. Never present the plugin as official/partnered. Never change a published plugin's name. Submission cadence limit: 10/org/24h.
