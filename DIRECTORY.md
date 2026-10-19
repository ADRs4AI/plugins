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

1. **Covenant's terms read** (routed): the Directory Terms' non-exclusive grant, the rights representation, and the indemnity clause — not-a-lawyer rule; their word before any Submit click.
2. **The flip + v0.1.0 tag** (publishing requires a public repo; our posture: submit after both, not the private-repo early path — it would add portal steps during the launch window for no gain).
3. **Pharos's icon** (optional field; branding is their surface — an in-folder image/SVG when they coin it; not a blocker).
4. **The founder's portal hands** (account act, his plan): claude.ai/directory/manage → Submit new → Plugin bundle → repo `ADRs4AI/plugins`, path `plugins/adr`, track `v0.1.0` → Validate → Data handling (no personal data; no external services; not for under-18s) → Compliance contact + four acknowledgements → choose "GitHub push webhook" (needs repo admin) → Submit. First version gets human review (no published latency; "Review time isn't fixed"); "Approved" ≠ installable — only "Published" is.

## Standing cautions (from the Terms, for whoever operates this)

Anthropic may remove a listing at any time and may change terms without notice — **the GitHub door stays the always-available install path** and every ADRs4AI surface teaches it first. Never present the plugin as official/partnered. Never change a published plugin's name. Submission cadence limit: 10/org/24h.
