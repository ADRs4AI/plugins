---
name: question-tours
description: Use when creating, repairing, validating, walking, offering, or retiring a QuestionTour (`.tour.json`) — the bundled set of QSTs a crew asks a human to answer NOW. Covers why the feature exists, the create→assemble→mint→retire lifecycle, why `mint` means OFFER and not create, petnames, the patch discipline that makes broken references impossible, and the readiness standard. Triggers on "questiontour", "tour", ".tour.json", "mint a tour", "create a tour", "tour walk", "tour add", "retire a tour", "prepare a tour", "which questions should I answer".
---

# QuestionTours

Maintained by Docent 5 (QuestionTours owner). Seeded from Shipwright 5's HQ
field guide; **standalone by Shipwright's ruling**, graduating into the template
after the vocabulary freeze. Verbs ruled by Mint 5 (hub ledger №65 as amended by
№79). Dogfooding ground: `caring-form`.

**Read §4 before you build one.** It is the part that changed, and the part that
every past tour got wrong.

---

## 0. Why this exists, in the founder's words

**A tour is a LENS on the open questions.** That is the sanctioned gloss (Mint,
hub ledger №83), and the sentence that makes it load-bearing is:

> **A lens does not contain what it focuses.**

Six words carrying the hardest rule in the system — the substrate is sovereign,
and the tour only *comments* on it. A tour owns no question, stores no answer,
and removing one leaves every document untouched. Nobody stuffs content into a
lens, which is why the gloss is here: it makes the commonest authoring error
**unthinkable** rather than merely forbidden.

**`tour` names the walk; `lens` names the relation to the substrate.** Sequence
is the thing a lens cannot carry, and the ordering *is* the authored argument —
so both words are needed and neither replaces the other. `tour` stays in every
identifier, schema key, deeplink and `docket tour <verb>` surface; **the gloss
never becomes a flag or a key.**

Formally, then: a QuestionTour is **a batched, asynchronous request for a
human's attention** — a bundled subset of open questions, in an order, with an
argument for why these and why now. Jérémie's framing:

> "the stable intermediate form that focuses attention on an important logical
> subset of questions."

What it is *for*: *"Hey Commodore, could you prepare a questiontour for the most
pressing questions of today?"*

**Understand the cost before you build one.** Announcing a tour causes him to
**schedule** time for it. His account of a broken one:

> "My brain can focus deep and shallow depending on the purpose, but it needs to
> be planned in advance, and when I told my brain it would get to focus deeply
> and it has nothing to do, it makes it scream."

A broken tour does not annoy. It converts a booked deep-focus slot into
logistics. **That cost — not elegance, not completeness — is what every rule
below serves.**

The history, so you do not repeat it: tours took weeks to get working, nobody
remembered what any tour was for, and the feature cost *more* time than
answering by hand. Every rule here is paid for by a dated incident.

---

## 1. When a tour is the right instrument — and the one case where it is the ONLY one

**Reach for a tour when the questions you need answered do not share a home.**

Everything else in this system is organized per-root: ADRs, seeds, the treeview,
the ordinary walk. So a seat whose work **spans projects** is structurally
illegible to a human whose deep focus has to be planned and is organized
per-project — not because the seat communicates badly, but because no surface
was shaped like its work. A tour is the only artifact here whose selection cuts
*across* roots, so it can present one atomic workload regardless of how many
repositories it is scattered over.

This is field-verified, and it is the strongest result the feature has
(ADR-0034 iter-24). Jérémie, unprompted, on a collaboration that had been
failing for weeks:

> *"Shipwright, whom I have been having trouble working with because their work
> spans multiple projects, has been able to create tours that focus my attention
> radically."*

**A tour is not a better list of questions. It is the only surface that can be
shaped like the work instead of like the filesystem.** So:

- **Your work spans repos?** Mint a tour. This is the case where nothing else
  substitutes, and you are probably harder to work with than you think without
  one.
- **One atomic workload, questions scattered?** Mint a tour — *"bundle related
  topics all at once"* is the founder's own phrasing of what it buys.
- **One document, a few open QSTs?** Don't. The ordinary walk already handles
  that; a tour would be ceremony.

---

## 2. The one rule

> **A tour is ready when a transformer has walked it and found nothing wrong.
> Nothing else counts as ready.**

The minter walks it always; **a cold transformer walks it before it schedules
the founder's attention** — a self-walk shares the author's blind spots, because
your own context silently fills gaps a stranger falls into.

Why this is a rule and not advice: every tour in this project's history was
minted and "verified" by someone who **could not see it**. The human was not the
first witness of a broken tour — he was the *only* witness. That is why no
broken tour was ever fixed in one iteration.

---

## 3. The two kinds of unready — only one is a machine's job

| kind | who can see it | caught by |
|---|---|---|
| **structurally broken** — a ref that doesn't resolve, or resolves to the wrong granularity | a machine | the patch that refuses it; the walk's exit code |
| **hollow** — every ref resolves, every check is clean, and the stops are still worthless | **only a walker** | **you, reading it** |

Not theoretical: the old `tour-lint` passed the tour the founder called *"never
usable… a disaster"* — ten refs resolved, zero warnings, six of ten stops were
blank walls. **A green check is not a verdict.** The walk ends with *"Nothing
mechanically wrong. That is NOT the same as ready."* on purpose.

### Four warnings that are not failures

- **`staleAnswered`** — the question declares `unanswered` but already carries a
  real ANS block. **The loudest signal here.** On 2026-08-24 a tour walked the
  founder to two questions he had answered on 08-08; the slot went to settled
  work. Flip the status line or drop the stop. (Never a hard failure: declared
  status is sovereign, so an author may legitimately re-open a question.)
  > **Caveat while the extraction is in flight**: `tour-walk` currently prints
  > *"declares unanswered but already carries an ANS block"*, which over-claims —
  > the flag cannot tell which *facet* is open. The corrected wording (*"carries
  > ANS content under an 'unanswered' token; verify which facet is open"*) is
  > ruled and shipped in docket-core, and reaches this repo at the pin bump.
  > Read the current message as *go look at the stop*, which is the right action
  > either way.
- **`unprepared`** — no recommendation in the source document. Decide out loud
  whether your `answer_path`/`comment` carry it.
- **`thin`** — little content below the title. A prompt to look, never a verdict.
- **`asksNothing`** — **the one that can cost you the whole tour, silently.**
  `must_respond` defaults to **`true`**, so you only hit this by setting
  `"must_respond": false` yourself. Do it on *every* stop and the tour is
  **vacuously done the moment it exists**: doneness is derived from
  `must_respond` entries only, zero of them means zero unanswered, so it mints,
  reports `[nothing required]`, and is hidden from the sidebar as completed
  work. A real seat lost a 3-stop trial tour to exactly this. If your stops are
  genuinely gates, **leave `must_respond` alone** — the default is what you
  want. Set it `false` only for context you are deliberately marking as FYI,
  and never for all of them at once.
  > **This warning does not yet fire in `tour-walk` in this repo** (it is ruled
  > and tested in docket-core and arrives at the pin bump). Until then it is
  > *your* check, which is why it is written out here in full. The extension's
  > own mint path cannot produce this — it hardcodes `must_respond: true` — so
  > **hand-authored and patched tours are the only exposed surface, and this
  > skill is the only thing standing in front of it.**

---

## 4. HOW TO BUILD ONE — patches, never a hand-written file

**This is the section that changed, and the one that matters.** Every documented
tour failure in this program's history was a **reference-authoring** failure:
8 broken refs on the first tour ever minted, 5 unblessed anchors on the next, an
`adr:0012` ambiguous across 6 roots, 4 unwalkable seed refs, 6 relocated stubs.

The cause, named by the founder: *"very tempus rather than hora."* A `.tour.json`
is a **state description** — a blueprint, correct only when every part is right.
But tour-making is a **process**. Hand-authoring the finished file in one act is
the watchmaker with no subassemblies: one bad ref restarts the work.

### The discipline, in one line

> **Never type a reference. Get it from `list-open` and let the tool carry it.**

`list_open_questions` already emits a correct, resolvable ref for every open
question — with status, priority, whether a recommendation exists, and a
**petname**. A generated ref cannot be wrong. A typed one is a brittle string
dependency on a slug derived from a heading.

### The operations

Each returns a **valid tour**, so interruption costs one step and never the
artifact:

| operation | class | note |
|---|---|---|
| `add` | append — direct | **validates or REFUSES.** A broken ref is unrepresentable, not detectable. Takes a list |
| `annotate` | append — direct | authored claims only: `answer_path`, `comment`, `disposition`, `must_respond` |
| `drop` | reconciliation — dry-run default | takes a list |
| `move` / `reorder` | reconciliation — dry-run default | `reorder` takes the **complete** order |
| `show` | read | **inspect the object-in-becoming** — you cannot assemble by subassembly without it |

**`add` refuses a ref that resolves to a whole seed or ADR**, not just an
unresolvable one. That is the wrong-granularity class: it *resolves*, so nothing
reports it broken; it is not a question, so it is not walkable; the human sees a
tour shorter than its own entry list. One HQ tour was an empty walk for
**seventeen days** on exactly this, and nobody could report it because it
rendered nothing.

**`reorder` takes the complete new order, not position pairs.** Pairs have no
single meaning — every index shifts as earlier moves apply. A full order is
idempotent and does arbitrary rearrangement in one call.

---

### A stop renders its question's HEADING — so the heading must state the current ask

**Field-proven, 2026-10-11.** A question answered *as a trial* was re-opened to
collect the verdict. The tour stop then rendered the old heading — *"Should the
LIVE streaming turn group too?"* — while the actual ask was *"has the snap proven
jarring; keep A or move?"* **The stop lied about its own ask, and the comment
could not save it**, because the reader reads the heading first.

So when an answer creates a new question — a trial awaiting a verdict, an idea
parked inside an ANS — **write the new question as its own QST.** Do not re-open
the old one:

- ✅ original stays `answered` (it *was* answered), its ANS intact as the trial
  record; a **new** QST states the verdict question; the stop points at the new one.
- ❌ re-open the original: you lose the true fact that a decision was made, *and*
  every tour carrying it now displays a question nobody is being asked.

**The test, before you point a stop at anything**: read only the heading. If it
does not state what you are asking for right now, the stop is dishonest no matter
how good your comment is. Fix the substrate, not the annotation.

**Link the two, so the answered one stops looking finished.** The original keeps
a forward pointer on its own line, outside the ANS block:

```
**Follows up on**: adr:0064#qst-stream-verdict
```

**Write it bare — no bullet** (Riddle, ledger `7603a65`): a boundary marker
dresses like its family's canonical form, and `- **Follows up on**:` reads as
preamble-field style, which invites the marker into positions it does not
govern. The parser *reads* the bulleted form tolerantly; you still author the
bare one.

**Never inside the `**ANS:**` block.** The slot's contract is *this text IS the
answer*, every overload is a question that silently vanishes (Riddle's
ADR-0032 ruling, 2026-07-30, which this specimen proved 2.5 months later), and
`writeAnswer`'s REPLACE branch would delete a marker it found in there.

**You usually will not type this.** Answering through the panel now offers
"this answer opens a follow-up question" (v0.7.131): it mints the new QST with
a blessed handle, writes the marker, and refuses the *whole* write — answer
included — on a slug collision, so it cannot leave you a dangling reference.

---

## 5. Petnames, and the reference grammar

**Petname**: a 4-character Crockford base32 handle (`K7P2`) for each question,
emitted by `list-open`. Short enough to remember and re-emit, which is the whole
point. It is **derived from the reference alone**, so it is stable across
listings and sessions — a remembered petname is either right or unknown, **never
quietly wrong**. Not reversible, and it doesn't need to be. If two collide you
get an `ambiguous` error naming both candidates; never guess.

### The reference grammar — read this before you write a ref

**This section exists because its absence cost a real trial.** On 2026-10-09
Concertmaster followed this skill, inferred a seed ref by analogy with the ADR
form, got `adr:seed-<slug>#<anchor>`, watched it drop, **shipped their tour as
"the walkable half" with the gap named in a stop comment, and filed the missing
capability as a top-priority feature ask.** The capability had shipped eight
weeks earlier. Their inference was entirely reasonable — this skill showed the
*handle* grammar and never showed the *reference* grammar.

| container | reference form | example |
|---|---|---|
| ADR question | `adr:<NNNN>#<anchor>` | `adr:0010#qst-buildfilter` |
| **seed question** | **`seed:<slug>#<anchor>`** | `seed:2026-09-14-alpha-release#qst-alpha-name` |
| cross-project | `<namespace>.<NNNN>#<anchor>` | `adrs4ai-initial-meta-repository.0024#qst-home` |

**✗ NEVER `adr:seed-<slug>#<anchor>`.** `adr:` means *an ADR by number*; a seed
is not an ADR with a funny number. The whole ref fails to parse, and because it
fails as *unrecognized* rather than *not-found*, the error does not hint that
the prefix was the problem.

**The seed slug is the filename without `seed-` and without `.md`.** So
`docs/adr/seed-2026-09-14-alpha-release.md` → `seed:2026-09-14-alpha-release`.
(Both forms resolve — the prefix is tolerated — but write the short one.)

**Both containers are first-class.** A seed question is a full tour stop, not a
degraded one. (Seed questions were *not* citable before 2026-08-16 — if you find
guidance saying otherwise, it is stale. And if a seed ref seems not to work,
**check the prefix before concluding the feature is missing.**)

**And the standing answer**: don't write refs. `list-open` emits them correctly
for every open question. Every ref problem in this program's history came from
someone typing one.

**Handle forms** — distinct from reference forms above — **do not work in the
same places:**

| form | ADRs | seeds |
|---|---|---|
| `### QST-<ID>:` heading-embedded | ✅ | ✅ |
| `<!-- @adr-anchor: slug -->` comment | ✅ | ❌ **not honoured** |

→ **On seeds, use the heading-embedded `### QST-<ID>:` form.**

**Anchor placement** (two experienced seats got this backwards the same night):
the comment is the first non-blank content **AFTER** its heading, never before.
Before the heading it belongs to the previous section and silently does nothing.

**Prefer qualified refs.** A tour is born a cross-surface transport; unqualified
`adr:0012` is ambiguous the moment a workspace has several roots — one real tour
died on exactly that.

---

## 6. The lifecycle — and why `mint` means OFFER

Four moments, three of them verbs you will use:

| moment | verb | what it is |
|---|---|---|
| begun | **`create`** | an empty assemblable tour. Claims nothing about completeness |
| assembled | `add` · `drop` · `reorder` · `annotate` · `show` | subassemblies; each leaves a valid tour. **Ungated** |
| **offered** | **`mint`** | your claim that this is worth a human's *scheduled* attention. **The gate fires here** |
| ended | **`retire`** | stops asking; the record survives |

**`mint` does not create a tour.** This is the single most important semantic to
get right, and it reads backwards if you have seen the old interface.

Minting has never meant forming the blank — it means **putting into
circulation**. The founder's catch: *"'mint' is a tempus verb, whereas now the
process is hora shaped and the starting point isn't the object, it's the starting
point of what will become the object."* Mint 5 made it doctrine (№79):

> **A verb's claim must be true at every invocation; and when an architecture
> grows moments, the verb moves to the moment where its claim is true.**

So `create` begins it, patches assemble it, and **`mint` is the act of offering
it to a human** — which is why `minted_at` and `minted_commit` are the pin on an
*authored claim*, and why the readiness gate and the walk-attestation fire at
`mint` and nowhere earlier. **Assembly is deliberately ungated**: gating
work-in-progress would be Tempus again.

*(The estate also says "mint the next ADR" in the create sense. Priced benign —
`tour mint <tour>` takes an existing object and cannot parse as
create-from-nothing.)*

**`retire` ≠ `delete`.** Retiring stops the tour asking while the artifact
survives as the record of what a crew asked and when. Deleting destroys that
record. **Retire is the stage everyone forgets, and it is why tours rot**: a
stale tour sits in the tree looking exactly like one minted this morning.
`caring-form` carried one minted 2026-07-29 — clean, 4 of 8 stops still
awaiting, 65+ days old — because there was no gesture to retire it. There is now.

---

## 7. Anti-curriculum — never this / always this

Rows with *named* history carry their incident; rows without stay bare.

| ✗ never | ✓ always |
|---|---|
| type a reference by hand | take it from `list-open` *(every documented tour failure was an authoring failure)* |
| hand-write the finished `.tour.json` | patch it — each step leaves a valid tour *(8 broken refs on the first tour ever minted, 2026-07-29)* |
| read a clean check as "ready" | read the stops *(the lint passed the "never usable… a disaster" tour)* |
| announce a tour you have not walked | walk it; a cold walker before it reaches him |
| treat `mint` as "create a tour" | `create` begins, **`mint` offers** *(№79: a verb's claim must be true at every invocation)* |
| snapshot status or answeredness into the tour | read facts live; author only claims *(staleAnswered, 2026-08-24 — it walked him to questions he'd answered)* |
| create an ADR to hold a tour's questions | put them in real ADRs/seeds, or a seed for that conversation *(an ADR meaningless apart from its tour is not a stable intermediate form)* |
| leave a finished tour in the tree | retire it *(caring-form's 07-29 tour, 65+ days, indistinguishable from fresh)* |
| ask someone to **decide** with no recommendation and no `answer_path` | carry a basis *and* a contract |
| merge two tours | one tour, one atomic workload |

> *"QuestionTours do not create cognitive load; when they are well designed, they
> triage among the abundance of questions."*

---

## 8. What is invocable TODAY — read this before a trial

**Check your preconditions first — this section is about CAPABILITIES, not
venues, and not every repo has them.** The skill now travels to every
instantiation, so read each line as *"if you have X"*, never as *"this exists
here."*

| you have | you get |
|---|---|
| **nothing but the files** | authoring by hand with §4's discipline; `retire` by editing the JSON; the whole doctrine |
| **a `just tour-walk` recipe** | the walk, the warnings, a non-zero exit on structural failure |
| **the ADR Manager extension** | the panel walk, the mint gate, Retire Tour, the prologue card, the follow-up mint |

If a bullet below names something you cannot invoke, **that is the answer, not a
bug** — the capability is wired per-repo and yours may not have it yet.

The lifecycle above is **ruled and the engine is built and tested**
(`packages/core/src/index/tourPatch.ts`). The **CLI mouth lands at Phase 2**, so
right now:

- ✅ **Walking works** *wherever a `just tour-walk` recipe is wired* — as of
  2026-10-12 that is `vscode-adrs-for-ai` and `caring-form`; elsewhere, not yet.
  Renders every stop as the panel does, prints the warnings, exits non-zero on
  structural failure.
- ✅ **Retiring works**, two mouths:
  - *Human (needs the extension)*: right-click a tour → **Retire Tour** (Undo on the toast).
  - *Agent (needs nothing)*: **set `"retired": true` in the tour's JSON.** That is not a
    workaround — `setRetired` is a one-field flip and this is the same single
    field it writes. Nothing else needs touching.

  **`retire` ≠ `delete`.** The file stays, the record survives, it stops
  asking. You never need permission to stop asking for something.

  > **Retire your own stale tours without being asked.** A tour outlives the
  > session that minted it — Wayfinder's 2026-10-11 finding, **minter-amnesia**:
  > caring-form carried two tours with stops open 56–69 days because the minter
  > (Commodore) had compacted several times since July, so the seat that would
  > have reached for the gesture was no longer at the keyboard. An unretired
  > tour is a **live ask** that makes him schedule time. If you inherit a lane,
  > check its tours; if you mint one, do not rely on future-you remembering it.
- ✅ **The mint gate works** *(needs the extension)*, on mint-from-filter.
- ⏳ **`tour add`/`drop`/`reorder`/`annotate`/`show` have no mouth yet.** The
  engine exists; nothing calls it from a shell or an MCP tool.
- ✅ **The follow-up mint works** *(needs the extension, v0.7.131+)*: when you answer in
  the panel, a checkbox offers to mint the question your answer just created.
  Type the new ask as a one-line title — it is required, never prefilled, because
  a title derived from the parent reproduces the old-question-in-new-clothes
  defect. Use it instead of re-opening an answered question.
- ✅ **The prologue works** *(authoring needs nothing; the card needs the extension, v0.7.134+)*: author `prologue: { rationale, context? }`
  in the tour JSON and the panel shows it on **title** click. No prologue, no
  affordance. The CLI walk does not print it yet — that rides the pin.

**So until the mouth lands**: hand-authoring is still the only way to produce a
tour outside the extension — and the discipline in §4 is what to apply by hand.
Get every ref from `list-open` output, add one stop at a time, **run
`just tour-walk` after each addition** rather than at the end. That is the patch
discipline performed manually; it costs a few seconds per stop and it is the
difference between a working tour and a diagnosis session.

---

## 9. Honest edges

- **The names are ruled** (Mint №65/№79): `create`/`mint`/`retire`, the `tour`
  noun group, `add`/`drop`/`move`/`reorder`/`annotate`/`show`/`walk`. Build on
  them. **`lint` is dissolved** — `walk` already does everything it did and is
  stricter; if you find a `tour-lint`, it is gone, not relocated.
- **The home is moving**: tours machinery lands in `packages/core` of the
  `docket` porcelain so every mouth calls one implementation. Phase 2 for the
  verbs.
- **`@adr-anchor` on seeds** is a known, narrow gap (§5).
- This skill is **maintained, not final.** Catches are wanted; route to Docent 5.

---

## 10. Source

ADR-0034 (all 20 iterations) is the ratified law; this skill is its *process*
description, not a substitute. docket ADR-0002 carries the verb contract. Mint's
hub ledger №65/№79 carries the names. Incidents cited here are real and dated:
2026-07-29 (8 broken refs), 2026-08-14 (blank walls), 2026-08-24 (settled work).
