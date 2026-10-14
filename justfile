# Justfile — coordination recipes for multi-participant human-AI projects.
#
# This is a **seed** justfile. It contains only the recipes needed to use
# the inbox protocol, the per-message-attribution discipline, the crew
# coordination layer (named seats, groups, wait-for-brief, safe commits,
# crew health), and ADR creation (the latter coupled to the
# `docs/adr/templates/` files this template ships); it does NOT contain
# project-specific recipes (build, test, deploy, etc.) — those are yours
# to add per project. Keeping this file focused on the *coordination*
# layer lets it drop into any project without conflicting with the
# project's own justfile structure.
#
# Two design choices worth knowing as you extend this:
#
# 1. Filenames are stamped UTC; prose to humans is rendered ET (or local).
#    The `stamp` recipe shows both; the `brief` and `completion` recipes use
#    UTC for the filename. This prevents the cross-timezone ordering bug
#    described in docs/inbox/INBOX-PROTOCOL.md.
#
# 2. The `last`, `aliases`, and `discover-sessions` recipes surface
#    per-message `model` attribution from session JSONLs — the load-bearing
#    drift-detection signal described in docs/inbox/CONVENTIONS.md (principle
#    1). Keep this surface in any extensions you add.
#
# Contributed by Statesman 4.7 (Claude Opus 4.7), 2026-06-15, via System3
# Conversations. See docs/inbox/CONVENTIONS.md for origin and the principles
# this file operationalizes.
#
# Crew coordination layer (broadcast, inbox-archive, groups, crew, pulse,
# wait-for-brief, safe-commit; reservation-only brief semantics) backported
# 2026-07-06 by Shipwright 5 (Claude Fable 5) per meta-repo ADR-0003, from the layer's
# operational proving grounds (caring-feedback crews → ADRs4AI meta repo, with
# fixes by Naturalist 5 and the vscode-adrs-for-ai crew). Attributions stack.

# Default: list available recipes when `just` is run with no args.
default:
    @just --list

# ─── inbox protocol — file naming + listing ──────────────────────────────────

# List the most recent inbox messages. Useful at the start of a session to
# get oriented on what other participants have been doing.
[group('inbox')]
[doc("List recent docs/inbox/ messages (see docs/inbox/INBOX-PROTOCOL.md).")]
inbox:
    @echo "📬  docs/inbox/ — recent messages:"
    @ls -t docs/inbox/*.md 2>/dev/null | head -8 | sed 's|^|    |' || echo "    (no inbox files yet)"

# Print current timestamp in both UTC (for filenames) and ET (for prose).
# UTC ensures filenames sort correctly across participants in different
# timezones. ET (or your local zone) is what you say to the human.
[group('inbox')]
[doc("Print current timestamp in UTC (for filenames) and ET (for prose).")]
stamp:
    @echo "UTC: $(date -u +%Y-%m-%d-%H%M)"
    @echo "ET:  $(TZ=America/New_York date +'%Y-%m-%d %I:%M %p %Z')"

# Create a new outgoing brief. Args: from to slug.
#
# Filename: docs/inbox/<UTC-ts>-<from>-to-<to>-<sluggified-slug>.md
# Slug is sanitized: lowercase, non-alphanumeric → "-", repeated dashes collapsed.
# Refuses to overwrite an existing file.
#
# Example: just brief planner reviewer schema-question
[group('inbox')]
[doc("Create new outgoing brief file: just brief <from> <to> <slug>")]
brief from to slug:
    #!/usr/bin/env bash
    set -euo pipefail
    ts=$(date -u +"%Y-%m-%d-%H%M")
    # quote(): every recipe parameter is DATA — interpolated bare inside shell
    # quotes, `backticks`/$(…) inside it EXECUTE (field incident, porthole
    # 2026-10-12: a commit message naming `just gate` ran the gate; fix by
    # Jérémie + Opus 5.5, ported fleet-wide same day; class audited across
    # this file — every user-string now passes through quote()).
    FROM={{quote(from)}}; TO={{quote(to)}}
    slug=$(echo {{quote(slug)}} | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g; s/--*/-/g; s/^-//; s/-$//')
    file="docs/inbox/${ts}-${FROM}-to-${TO}-${slug}.md"
    if [[ -e "$file" ]]; then echo "Error: $file already exists" >&2; exit 1; fi
    mkdir -p docs/inbox
    # Deliberately do NOT touch the file — this recipe only RESERVES the
    # filename; the author creates the content (e.g. via an AI Write tool).
    # An empty stub traps Write-tool flows into read-before-write errors and
    # causes false wait-for-brief wakes (dogfooded 4+ times, caring-feedback
    # 2026-06-27/28).
    echo "$file"

# Create a new completion brief (response to an earlier dispatch).
# Args: from slug.
#
# Filename: docs/inbox/<UTC-ts>-<from>-completion-<sluggified-slug>.md
#
# Example: just completion implementer schema-question
[group('inbox')]
[doc("Create new completion brief file: just completion <from> <slug>")]
completion from slug:
    #!/usr/bin/env bash
    set -euo pipefail
    ts=$(date -u +"%Y-%m-%d-%H%M")
    FROM={{quote(from)}}
    slug=$(echo {{quote(slug)}} | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g; s/--*/-/g; s/^-//; s/-$//')
    file="docs/inbox/${ts}-${FROM}-completion-${slug}.md"
    if [[ -e "$file" ]]; then echo "Error: $file already exists" >&2; exit 1; fi
    mkdir -p docs/inbox
    # Reservation only — see `brief` recipe note.
    echo "$file"

# Create a new broadcast brief (1:many, group-addressed). Groups are defined
# in docs/inbox/agent-sessions.json ("groups" key); wait-for-brief wakes every
# member of an addressed group. Group defaults to "crew".
#
# Example: just broadcast planner all-hands-schema-change
[group('inbox')]
[doc("Create new broadcast brief: just broadcast <from> <slug> [group=crew]")]
broadcast from slug group='crew':
    #!/usr/bin/env bash
    set -euo pipefail
    ts=$(date -u +"%Y-%m-%d-%H%M")
    FROM={{quote(from)}}; GROUP={{quote(group)}}
    slug=$(echo {{quote(slug)}} | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g; s/--*/-/g; s/^-//; s/-$//')
    file="docs/inbox/${ts}-${FROM}-to-${GROUP}-${slug}.md"
    if [[ -e "$file" ]]; then echo "Error: $file already exists" >&2; exit 1; fi
    mkdir -p docs/inbox
    # Reservation only — see `brief` recipe note.
    echo "$file"

# Archive an acted-upon brief: git mv to docs/inbox/archive/ and commit.
# Closes lifecycle step 4 of INBOX-PROTOCOL.md (write → read → act → archive).
# Opinionated: auto-commits with a `chore(inbox):` message — adapt if your
# project batches archive commits differently.
[group('inbox')]
[doc("Archive an acted-upon brief: just inbox-archive <filename>")]
inbox-archive filename:
    #!/usr/bin/env bash
    set -euo pipefail
    file="docs/inbox/{{filename}}"
    if [[ ! -f "$file" ]]; then echo "❌ Not found: $file" >&2; exit 1; fi
    git restore --staged . 2>/dev/null || true
    mkdir -p docs/inbox/archive
    git mv "$file" "docs/inbox/archive/{{filename}}"
    echo "📦 Archived: {{filename}}"
    git diff --cached --stat
    git commit -m "chore(inbox): archive {{filename}}"

# ─── inbox protocol — cross-session awareness via session JSONLs ─────────────
#
# These recipes give each participant the ability to *see* what other
# participants have recently said, without going through the human as message
# bus. Critically, they surface per-message `model` attribution by default —
# making silent model substitutions (classifier reroutes, harness swaps,
# deprecations) visible the moment they happen.
#
# See docs/inbox/CONVENTIONS.md § 1 for why per-message model attribution is
# load-bearing.

# Read the last K messages from an agent's session JSONL (default K=1).
# Resolves <alias> via docs/inbox/agent-sessions.json. Renders per-message
# `model` attribution on every entry.
[group('inbox')]
[doc("Read last K messages from agent's session: just last <alias> [k]")]
last alias k='1':
    @python3 scripts/last-message.py {{alias}} -k {{k}}

# Same as `last`, but no body truncation (full message contents).
[group('inbox')]
[doc("Read last K messages from agent (full, no truncation): just last-full <alias> [k]")]
last-full alias k='1':
    @python3 scripts/last-message.py {{alias}} -k {{k}} --full

# List configured agent → session-UUID aliases. Edit
# docs/inbox/agent-sessions.json to add or update.
[group('inbox')]
[doc("List configured agent session aliases (docs/inbox/agent-sessions.json)")]
aliases:
    @python3 scripts/last-message.py --list

# Print a seat's read_order — its onboarding packet as data, not prose.
# Invented by Notary Opus 4.7 (crossfoot, 2026-07-09); backported by
# Grafter 5, 2026-07-13 (meta-repo ADR-0004 Iteration 8). Marks each file
# found/missing on disk.
[group('inbox')]
[doc("Print a seat's onboarding read_order, with found/missing markers: just onboard <alias>")]
onboard alias:
    @python3 scripts/last-message.py {{alias}} --onboard

# List recent session JSONLs in the storage dir. Use this to find UUIDs for
# new agents and populate docs/inbox/agent-sessions.json.
[group('inbox')]
[doc("Discover recent session JSONLs in this project (find UUIDs for new aliases)")]
discover-sessions:
    @python3 scripts/last-message.py --discover

# ─── crew — named seats, groups, health, wait discipline ─────────────────────
#
# The crew layer treats each participant as a persistent, named, colored,
# model-attributed SEAT (docs/inbox/agent-sessions.json). The seat outlives
# the occupant: when a model is deprecated, rerouted, or suspended, the
# seat's name and mission persist; the registry records occupant reality
# (`model`, `model_note`) separately from seat identity (`display_name`).
# See docs/inbox/ONBOARDING.md for the crew model.
#
# Backported per meta-repo ADR-0003 from operational crews (caring-feedback → ADRs4AI
# meta repo); attributions in each recipe where they are load-bearing.

# List configured groups for group addressing (validates membership).
[group('crew')]
[doc("List configured groups (docs/inbox/agent-sessions.json)")]
groups:
    @python3 scripts/groups-lookup.py --list

# Quick crew status dashboard: aliases + colors + last-active + recent briefs.
[group('crew')]
[doc("Crew status dashboard")]
crew:
    #!/usr/bin/env bash
    set -euo pipefail
    if [[ ! -f docs/inbox/agent-sessions.json ]]; then
        echo "❌ No docs/inbox/agent-sessions.json found"; exit 1
    fi
    python3 - <<'EOF'
    import json, os, re, glob
    from pathlib import Path
    from time import time

    with open("docs/inbox/agent-sessions.json") as f:
        data = json.load(f)
    base_dir = os.path.expanduser(data.get("_storage", {}).get("base_dir", "~/.claude/projects"))
    project_slug = os.getcwd().replace("/", "-")
    aliases = {k: v for k, v in data.get("aliases", {}).items() if not k.startswith("_")}

    def fmt_age(sec):
        if sec < 60: return f"{int(sec)}s ago"
        if sec < 3600: return f"{int(sec/60)}m ago"
        if sec < 86400: return f"{int(sec/3600)}h ago"
        return f"{int(sec/86400)}d ago"

    TS = r"\d{4}-\d{2}-\d{2}-\d{4}"
    all_briefs = [Path(f).name for f in glob.glob("docs/inbox/*.md")]
    # Regex anchors at alias boundaries so "wayfinder-to-scribe-completion-..."
    # is NOT credited as sent by scribe.

    print(f"👥 Crew status — {len(aliases)} registered\n")
    for alias, info in sorted(aliases.items()):
        uuid = info.get("uuid", "")
        display = info.get("display_name", alias)
        color = info.get("color", "?")
        model = info.get("model", "?")
        jsonl = Path(base_dir) / project_slug / f"{uuid}.jsonl"
        age = fmt_age(time() - jsonl.stat().st_mtime) if jsonl.exists() else "no JSONL"
        a = re.escape(alias)
        sent_re = re.compile(rf"^{TS}-{a}-(to|completion)-")
        recv_re = re.compile(rf"^{TS}-[a-z0-9]+(?:-[a-z0-9]+)*-to-{a}-")
        sent = sorted([n for n in all_briefs if sent_re.match(n)], reverse=True)
        recv = sorted([n for n in all_briefs if recv_re.match(n)], reverse=True)
        last_sent = sent[0] if sent else "—"
        last_recv = recv[0] if recv else "—"
        print(f"  {display} ({color})")
        print(f"    model: {model}    last-active: {age}")
        print(f"    last sent:     {last_sent}")
        print(f"    last received: {last_recv}\n")
    EOF

# Health check: one line per seat, detect stalls/errors. Returns non-zero if
# any seat is in ERROR state. Detects: 🔴 ERROR (synthetic model / API error),
# 🟡 WAITING (ends in question, >1h old), 🟡 STALE (no append in >Nh),
# 🟢 OK. (Refined in caring-feedback per Commodore's review, 2026-07-03.)
[group('crew')]
[doc("Health check all seats: detect stalls, errors, blocked states")]
pulse stale_threshold='6':
    @python3 scripts/last-message.py --pulse --stale-threshold {{stale_threshold}}

# ─── wake infrastructure (ported from caring-feedback, ADR-0050 lineage) ─────
#
# Turns the crew's wait-for-brief PULL model into an active PUSH: seats live
# in detached tmux sessions (survive closing the terminal tab) and can be
# woken from anywhere with a literal keystroke injection, hardened against
# mid-turn injection, composition-flushing a human's draft, message-length
# fragility, and ping-pong spam. See scripts/last-message.py's wake-
# infrastructure header comment for full attribution and known-open items;
# maintainers' meta-repo ADR-0006 records this port. Requires `tmux`
# (brew install tmux / apt install tmux) — without it, everything else in
# this justfile keeps working; these four recipes fail with an install hint.

[group('crew')]
[doc("Launch (or attach to) a seat's tmux session. `just launch --next-inactive` spins up the next seat with no running session")]
launch seat='' *flags='':
    #!/usr/bin/env bash
    # Delegated to pneumatic (HQ ADR-0044): the bundled last-message.py is
    # harness-UNAWARE — it builds `claude --resume` for every seat, which
    # exits instantly for codex/other-vendor seats (field: Lector 6 of
    # moreover, Sounder 6 of porthole — correct harness blocks, never read).
    # pneumatic launch reads the registry's harness.launch_cmd.
    if ! command -v pneumatic >/dev/null 2>&1; then
        echo "❌ just launch delegates to pneumatic (harness-aware launches: claude AND codex seats)."
        echo "   Install once:  pip install adrs4ai-pneumatic    — docs: https://adrs.systems/pneumatic"
        echo "   (every other recipe in this justfile keeps working without it)"
        exit 1
    fi
    pneumatic launch {{seat}} {{flags}}

# Backported from ADRs4AI HQ meta-repo, 2026-07-10 (Herald 5) — see its
# docs/adr/0008-rapid-relaunch-via-vscode-terminals-manager.md for the full
# design record. Generates .vscode/terminals.json for the VS Code Terminals
# Manager extension: one "Terminals: Run" click relaunches the whole crew.
[group('crew')]
[doc("Regenerate .vscode/terminals.json — default: top-up (only seats not already open); --all: every seat (recovery, duplicates by design)")]
refresh-terminals *args:
    @python3 scripts/refresh-terminals.py {{args}}

[group('crew')]
[doc("Who touched a file, when, per seat (from session tool records): just blame <pattern> [--reads] [-n 50]")]
blame pattern *flags:
    @python3 scripts/blame.py {{pattern}} {{flags}}

[group('crew')]
[doc("List all seat-* tmux sessions with state (attached/detached)")]
seats:
    @python3 scripts/last-message.py --seats

[group('crew')]
[doc("Update terminal titles for all running seat sessions")]
update-seat-titles:
    @python3 scripts/last-message.py --update-titles

[group('crew')]
[doc("Wake a seat by sending a message to its tmux session (--force to override guards)")]
wake seat message *flags='':
    @python3 scripts/last-message.py --wake {{quote(seat)}} --message {{quote(message)}} {{flags}}

# Block until a new brief addressed to <recipient> lands in docs/inbox/.
# v4 semantics (caring-feedback dogfooding): wake condition = mtime > start AND
# non-empty AND size-stable; surfaces existing pending briefs at startup.
# Wakes on direct briefs, group-addressed briefs (via groups-lookup.py), and
# completion briefs answering the recipient's own dispatches.
#
# ⚠️ ANTI-PATTERN, documented (Hanlon's razor): the timeout is ARBITRARY
# housekeeping — a default number, not a signal. Every model that has hit
# the timeout (or had the wait killed) has read intent into it ("I was cut
# off, the human must want X"). There is none. A killed or expired wait
# carries zero information beyond "no brief landed in the window." Re-arm
# as many times as you like, or end the turn — the recipe's own output
# repeats this at the moment of timeout, where the misreading actually
# happens. (Named by Jérémie Lumbroso, 2026-07-05; messaging contributed
# by the vscode-adrs-for-ai crew.)
[group('crew')]
[doc("Wait for a new brief: just wait-for-brief <recipient> [timeout-mins=60] [poll-secs=15] [surface=5]")]
wait-for-brief recipient timeout_mins='60' poll_secs='15' surface='5':
    #!/usr/bin/env bash
    set -euo pipefail
    recipient="{{recipient}}"
    timeout_secs=$(( {{timeout_mins}} * 60 ))
    poll_secs={{poll_secs}}
    surface_n={{surface}}
    inbox="docs/inbox"
    start_time=$(date +%s)
    pattern_direct="*-to-${recipient}-*.md"
    recipient_groups=$(python3 scripts/groups-lookup.py --recipient "${recipient}" 2>&1 || echo "")

    find_briefs() {
        {
            find "$inbox" -maxdepth 1 -name "$pattern_direct" -type f 2>/dev/null
            grep -l "${recipient}-to-" "$inbox"/*-completion-*.md 2>/dev/null \
                | grep -v "/[0-9-]*-${recipient}-" || true
            for group in $recipient_groups; do
                find "$inbox" -maxdepth 1 -name "*-to-${group}-*.md" -type f 2>/dev/null
            done
        } | LC_ALL=C sort -u
    }
    get_mtime() { stat -f %m "$1" 2>/dev/null || stat -c %Y "$1" 2>/dev/null || echo 0; }
    get_size()  { wc -c < "$1" 2>/dev/null | tr -d ' '; }

    # grep -c prints "0" AND exits 1 on no match, so `|| echo 0` emitted a
    # second line ("0"$'\n'"0") and crashed the arithmetic below on empty
    # inboxes (caught live in the ADRs4AI meta repo: Naturalist 5's first
    # wait died on it, 2026-07-04; the same latent bug was later found and
    # fixed in a second downstream copy). `|| true` keeps grep's own "0";
    # ${var:-0} guards the empty-string case.
    initial_count=$(find_briefs | grep -c . 2>/dev/null || true)
    initial_count=${initial_count:-0}
    echo "🛏️  $recipient waiting for new brief"
    echo "    Snapshot: $initial_count brief(s) addressed to you (will not wake on these unless modified)"
    echo "    Timeout: {{timeout_mins}} min (polling every ${poll_secs}s)"
    echo "    Wake condition: file mtime > start AND non-empty AND size-stable"
    echo "    Note: the timeout is arbitrary housekeeping, not a signal — if this wait"
    echo "    expires or is killed, no meaning is intended; re-arm freely."
    if (( surface_n > 0 )) && (( initial_count > 0 )); then
        echo ""
        echo "    📋 Most recent ${surface_n} brief(s) already addressed to you:"
        find_briefs | LC_ALL=C sort -r | head -"${surface_n}" | sed 's|^|       |'
    fi
    echo ""

    while true; do
        candidates=$(find_briefs | while IFS= read -r f; do
            [[ -z "$f" ]] && continue
            mtime=$(get_mtime "$f")
            if (( mtime > start_time )); then echo "$f"; fi
        done)
        ready=""
        if [[ -n "$candidates" ]]; then
            while IFS= read -r f; do
                [[ -z "$f" ]] && continue
                size1=$(get_size "$f")
                if (( size1 == 0 )); then continue; fi
                sleep 2
                size2=$(get_size "$f")
                if [[ "$size1" == "$size2" ]]; then ready+="$f"$'\n'; fi
            done <<< "$candidates"
        fi
        if [[ -n "$ready" ]]; then
            echo "📬 New brief(s) for $recipient:"
            echo -n "$ready" | sed 's|^|    |'
            exit 0
        fi
        now=$(date +%s)
        if (( now - start_time >= timeout_secs )); then
            echo ""
            echo "⏰ Timeout after {{timeout_mins}} min; no brief landed."
            echo "    This timeout is ARBITRARY (Hanlon's razor: no intent, no hidden message)."
            echo "    It carries zero information beyond 'no brief in the window.'"
            echo "    Re-arm freely — as many times as you like:  just wait-for-brief $recipient"
            echo "    Or end the turn. The choice is operational, not interpretive."
            exit 1
        fi
        sleep "$poll_secs"
    done

# ─── git — safe commit discipline ────────────────────────────────────────────

# Safely commit specific files: clear staging first, add only named files
# (literal pathspecs, globbing off), show the diff stat, then commit.
# Defends against cross-session staging pollution (a parallel seat's
# `git add` bleeding into your commit) and bracket-glob hazards in paths.
[group('git')]
[doc("Safely commit specific files: just safe-commit \"msg\" file1 [file2 ...]")]
safe-commit message +files:
    #!/usr/bin/env bash
    set -euo pipefail
    set -f
    git restore --staged . 2>/dev/null || true
    for f in {{files}}; do
        if [[ ! -e "$f" ]] && ! git ls-files --deleted --error-unmatch "$f" >/dev/null 2>&1 && ! git diff --cached --name-only --diff-filter=D | grep -qxF "$f"; then echo "❌ File not found (and not a git-known deletion): $f" >&2; exit 1; fi
    done
    GIT_LITERAL_PATHSPECS=1 git add -- {{files}}
    # Deletions are committable too (porthole item 31): a path absent on disk
    # but known-deleted to git passes the existence check.
    echo "📝 Staged for commit:"
    git diff --cached --stat
    echo ""
    # quote(): the message is data. Interpolated bare inside "…", a message
    # containing `backticks` or $(…) was EXECUTED by the shell and its output
    # pasted into the commit (field incident, porthole 2026-10-12: a message
    # naming `just gate` ran the gate and committed its output as prose;
    # fix by Jérémie + Claude Opus 5.5, ported to canonical same day).
    git commit -m {{quote(message)}}

# One-time repo setup: pull-rebase + autostash, so origin-side commits
# (a mobile ANS, any API-writing mouth) replay cleanly under local seat work
# instead of refusing to pull or forcing merge forests. .git/config doesn't
# travel with clones — this recipe IS the delivery. Trade, named: rebasing
# rewrites UNPUSHED local SHAs; house practice (push promptly, cite pins)
# makes that near-zero. (Portolan 5's divergence class, 2026-10-06.)
[group('git')]
[doc("One-time: set pull.rebase + rebase.autoStash for this repo")]
git-defaults:
    git config --local pull.rebase true
    git config --local rebase.autoStash true
    @echo "✓ pull.rebase + rebase.autoStash set (local). Origin-side commits now rebase cleanly under unpushed work."

# ─── ADRs — Architecture Decision Records ────────────────────────────────────
#
# ADRs are part of the coordination layer: they record decisions a future
# participant (human or AI) needs to reconstruct the project's reasoning. The
# template already ships `docs/adr/` and `docs/adr/templates/adr.md`,
# so this recipe just completes the workflow: pick the next index, sluggify a
# title, copy the lean template into place.
#
# Two non-obvious correctness notes baked into the recipe (each from a bug
# observed in operational use):
#
# 1. Next index = MAX(existing) + 1, not COUNT(existing) + 1. The naive
#    count-based approach collides as soon as any number is skipped (e.g. an
#    ADR is superseded and the file removed; a number was reserved and never
#    written). One repo's ADR list went 0001..0016, 0018..0030 and the naive
#    recipe produced 0030 — colliding with an existing file — at attempt 31.
#
# 2. Force base-10 via `$(( 10#$LAST + 1 ))`. Bash interprets leading-zero
#    integer literals as **octal**: `$((0031 + 1))` is 26, not 32. With 4-digit
#    zero-padded indices this bites once you pass 0010, and silently corrupts
#    once you pass 0008 (which is not a valid octal digit and errors out).

# Create a new ADR with the next sequential number, copying the lean template.
# Args: TITLE (free text; will be slug-sanitized).
#
# Filename: docs/adr/<NNNN>-<sluggified-title>.md
# Slug sanitization matches `brief`/`completion`: lowercase, non-alphanumerics
# → "-", repeated dashes collapsed, no leading/trailing dash.
#
# Example: just adr "URL routing and shareable deep links"
# Mint a dated seed for a brain dump (named-but-unshipped until porthole item 23).
[group('adr')]
[doc("Create a dated seed from the template: just seed <topic-slug>")]
seed SLUG:
    #!/usr/bin/env bash
    set -euo pipefail
    SLUG=$(echo {{quote(SLUG)}} | tr -d "'" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g; s/--*/-/g; s/^-//; s/-$//')
    FILE="docs/adr/seed-$(date +%Y-%m-%d)-${SLUG}.md"
    if [[ -e "$FILE" ]]; then echo "Error: $FILE already exists" >&2; exit 1; fi
    cp docs/adr/templates/seed.md "$FILE" && echo "$FILE"

# What needs the human's answers (named in README since forever; shipped at porthole item 23).
[group('adr')]
[doc("Open questions awaiting answers, template skeletons excluded")]
unanswered:
    @grep -rn 'Status: unanswered' docs/adr/ --exclude-dir=templates || echo "No open questions."

# The day-one verification gate (porthole item 16): real checks that exist at
# birth, plus a marked slot for the project's own gate once it has one.
[group('status')]
[doc("Day-one gate: instantiate-check + registry validation (+ your project gate — edit me)")]
gate:
    #!/usr/bin/env bash
    set -euo pipefail
    just instantiate-check
    python3 scripts/groups-lookup.py --validate
    # ADD YOUR PROJECT'S OWN GATE HERE when it exists (test suite, build, linter)
    echo "✅ gate green (day-one checks; project gate slot above)"

# Is this instance fully instantiated? Greps for remaining ⟦SIGIL⟧ placeholders
# (the closed registry: docs/adr/templates/placeholders.yaml) and warns on
# adopted-but-unlocked kintsugi state. Exits nonzero while anything remains —
# completeness is computable, not re-read-and-hope. (QST-INSTANTIATION-SIGIL, 2026-10-11)
[group('adr')]
[doc("Report remaining ⟦SIGIL⟧ instantiation placeholders; nonzero until none remain")]
instantiate-check:
    #!/usr/bin/env bash
    set -uo pipefail
    REG="docs/adr/templates/placeholders.yaml"
    if [[ ! -f "$REG" ]]; then echo "⚠️  no placeholder registry at $REG — nothing to check"; exit 0; fi
    TOKENS=$(grep -E '^  [A-Z][A-Z-]*:' "$REG" | sed 's/^  //; s/://' | paste -sd'|' -)
    if [[ -z "$TOKENS" ]]; then echo "⚠️  registry has no tokens"; exit 0; fi
    # Scope the scan to the files the registry itself names (field catch,
    # porthole item 15: scanning every *.md made any document that DISCUSSES
    # the tokens fail the check — the registry's files: lists were always the
    # intended scope). Files listed but absent are skipped silently.
    FILES=$(grep -oE '^\s+files: \[.*\]' "$REG" | tr -d '[]' | sed 's/.*files: //; s/,/ /g' | tr ' ' '\n' | sort -u | tr '\n' ' ')
    HITS=""
    for f in $FILES; do
        [[ -f "$f" ]] || continue
        H=$(grep -noE "⟦($TOKENS)⟧" "$f" 2>/dev/null | sed "s|^|$f:|") || true
        [[ -n "$H" ]] && HITS="${HITS}${HITS:+$'\n'}${H}"
    done
    LOCKWARN=""
    # The lock-warn exempts the canonical template itself — detected by
    # comparing THIS repo's origin to the manifest's own canonical remote
    # (field catch, porthole item 17: instances copy the manifest verbatim,
    # `canonical:` key included, so a key-presence test could never fire).
    if [[ -f kintsugi.yaml && ! -f kintsugi.lock ]]; then
        CANON=$(grep -m1 '^  remote:' kintsugi.yaml | sed 's/^  remote: *//')
        # Normalize the pre-transfer org spelling (jlumbroso/ -> ADRs4AI/) so
        # canonical clones with stale remotes don't false-warn; instances have
        # entirely different repo names either way.
        ORIGIN=$(git config --get remote.origin.url 2>/dev/null | sed 's/\.git$//; s|github.com/jlumbroso/human-ai-collaboration-template-A|github.com/ADRs4AI/human-ai-collaboration-template-A|')
        if [[ -z "$ORIGIN" || "$ORIGIN" != "$CANON" ]]; then
            LOCKWARN="⚠️  kintsugi.yaml present with NO kintsugi.lock — this instance is adopted-but-never-wired: no template fix will ever reach it. Run: kintsugi adopt"
        fi
    fi
    if [[ -z "$HITS" ]]; then
        echo "✅ instantiation complete — no ⟦SIGIL⟧ placeholders remain"
        [[ -n "$LOCKWARN" ]] && echo "$LOCKWARN" && exit 2
        exit 0
    fi
    echo "⟦SIGILS⟧ remaining — fill-and-delete each (file:line:⟦TOKEN⟧):"
    echo "$HITS"
    echo "— $(echo "$HITS" | wc -l | tr -d ' ') occurrence(s). The registry explains each token: $REG"
    [[ -n "$LOCKWARN" ]] && echo "$LOCKWARN"
    exit 1

[group('adr')]
[doc("Create new ADR with next sequential number: just adr <TITLE> [MOLD] — MOLD: adr (default, deliberation) | madr (simple already-made decision) | any docs/adr/templates/<MOLD>.md")]
adr TITLE MOLD='adr':
    #!/usr/bin/env bash
    set -euo pipefail
    # `(grep || true)` so an empty docs/adr/ doesn't abort under pipefail
    # (grep exits 1 on no-match → first invocation of an empty project would die).
    LAST=$(ls docs/adr/ 2>/dev/null | { grep -E '^[0-9]{4}-' || true; } | sed 's/-.*//' | sort -n | tail -1)
    NEXT=$(printf "%04d" $(( 10#${LAST:-0} + 1 )))
    SLUG=$(echo {{quote(TITLE)}} | tr -d "'" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g; s/--*/-/g; s/^-//; s/-$//')
    FILE="docs/adr/${NEXT}-${SLUG}.md"
    if [[ -e "$FILE" ]]; then echo "Error: $FILE already exists" >&2; exit 1; fi
    # MOLD selects the template: 'adr' (deliberation), 'madr' → adr-madr (simple
    # decisions), or any mold shipped in docs/adr/templates/. Field-asked by a
    # founding seat that minted six deliberation skeletons only to overwrite each
    # with the simple form by hand (porthole TEMPLATE-FEEDBACK item 46).
    MOLD=$(echo {{quote(MOLD)}} | tr '[:upper:]' '[:lower:]')
    [[ "$MOLD" == "madr" ]] && MOLD="adr-madr"
    SRC="docs/adr/templates/${MOLD}.md"
    if [[ ! -f "$SRC" ]]; then
        echo "Error: $SRC not found — molds available:" >&2
        ls docs/adr/templates/*.md 2>/dev/null | sed 's|.*/|  |; s|\.md$||' >&2
        exit 1
    fi
    mkdir -p docs/adr
    cp "$SRC" "$FILE"
    echo "$FILE"
    echo "↪ BEFORE writing: load the adr-authoring skill (Skill tool) — it IS the read-the-template step." >&2
    echo "  Available is not loaded: a skeleton filled without the skill is how QSTs ship unstructured." >&2
