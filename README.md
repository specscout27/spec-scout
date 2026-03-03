# 🏗️ Spec-Scout

> **Spec-Driven Development (SDD) for GitHub Copilot.**
> A governed, AI-assisted workflow that forces Copilot to read your codebase spec _before_ writing a single line — and waits for your approval at every step.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Framework Version](https://img.shields.io/badge/Framework-v3.0.0-blue)](CHANGELOG.md)
[![Works With](https://img.shields.io/badge/Works%20With-GitHub%20Copilot%20Chat-8957e5)](https://github.com/features/copilot)

---

## Why Spec-Scout?

| Without SDD | With SDD |
|-------------|----------|
| Copilot guesses at intent each session | Copilot reads verified, structured context first |
| Scope creep — AI changes things it shouldn't | Strict scope boundary enforced automatically |
| Test coverage is undefined | 90% coverage floor enforced by the Constitution |
| Context lost between sessions | Session temp files let you resume exactly where you left off |
| No record of module responsibilities | Ownership, flows, and boundaries committed to the repo |

---

## Prerequisites

- **GitHub Copilot Chat** — Individual, Business, or Enterprise plan
- A git repository on `main` with a clean working tree
- No build tools, no packages, no runtime dependencies — Spec-Scout is just Markdown files

---

## Install

### Option A — Use this template _(new repos)_

Click the **"Use this template"** button at the top of this page to create a new repository with all framework files already in place.

Then jump straight to [Generating Your Context](.github/spec-scout/README.md#generating-your-context-first-time).

---

### Option B — Install into an existing repo

Run this from the **root of your existing repository**:

```bash
curl -fsSL https://raw.githubusercontent.com/specscout27/spec-scout/main/install.sh | bash
```

Or clone and run locally (recommended if you want to inspect the script first):

```bash
# 1. Clone spec-scout somewhere outside your repo
git clone https://github.com/specscout27/spec-scout.git /tmp/spec-scout

# 2. cd into YOUR repo root first
cd /path/to/your-repo

# 3. Run the installer — it installs into whichever repo you're currently in
bash /tmp/spec-scout/install.sh
```

Use `--force` to overwrite any previously installed framework files:

```bash
bash /tmp/spec-scout/install.sh --force
```

The installer copies all framework files to the correct `.github/` paths, creates the `context/` directory scaffold, and prints the full setup checklist when done.

---

## Quick Start (after install)

1. Make sure you are on the `main` branch with a clean working tree
2. Open **GitHub Copilot Chat** in your IDE
3. Type the following prompt:

   > `Please read the file .github/spec-scout/code-to-spec.md and follow all the instructions in it to generate the SDD context for this repository.`

4. Follow the interactive prompts — Copilot will map your codebase into structured module context files
5. Commit the generated files:

```bash
git add .github/spec-scout/context/
git commit -m "docs: generate SDD context"
git push origin main
```

6. Start your first story — Copilot will guide you through Phases P0 → 5

📖 **Full documentation:** [`.github/spec-scout/README.md`](.github/spec-scout/README.md)

---

## The Workflow at a Glance

Every story follows the same governed sequence. Copilot **always waits for your approval** before advancing.

| Phase | What happens | Your response |
|-------|-------------|---------------|
| **P0** | Optional context drift check against `main` | `YES` / `NO` |
| **1 — Analysis** | Copilot reads module context + codebase, produces a tech analysis report | `PROCEED` |
| **2 — Solution** | Copilot proposes one or more approaches with trade-offs | `SELECT 1` / `SELECT 2` |
| **3 — Task Plan** | Copilot breaks the chosen solution into ordered, dependency-aware tasks | `EXECUTE PLAN` |
| **4 — Execution** | Copilot implements one task at a time, runs tests after each | `CONFIRM` per task |
| **5 — Quality Gate** | Full test suite, code review, summary file generated, commit message provided | Review & commit |

---

## What's Inside

| File | Purpose |
|------|---------|
| `.github/copilot-instructions.md` | The agent brain — phases, commands, and governance rules |
| `.github/spec-scout/CONSTITUTION.md` | Non-negotiable quality laws (PII/Secrets, 90% coverage, scope isolation) |
| `.github/spec-scout/code-to-spec.md` | Instruction file read by Copilot once to generate all context from your codebase |
| `.github/spec-scout/update-context.md` | Drives `@update-context` to keep context in sync with `main` |
| `.github/spec-scout/session-tmp-file-protocol.md` | Session temp file format and `@continue` restore logic |
| `.github/spec-scout/summary-template.md` | Per-story summary artefact generated at end of Phase 5 |
| `.github/spec-scout/context/index.md` | Global module map — generated once, always read first _(generated, not in this repo)_ |
| `.github/spec-scout/context/modules/` | Per-module flow docs _(generated, not in this repo)_ |

---

## Commands

| Command | What it does |
|---------|-------------|
| `@update-context` | Sync module context files with committed changes on `main`; interactive Before → After review |
| `@analysis` | Run Phase 1 only — get a full analysis report without committing to a solution |
| `@solution` | Run Phases 1–2 — analysis + solution options, then stop |
| `@continue` | Resume a previous session from its `.tmp.md` file |
| `@noscout` | Bypass SDD entirely for this one message — standard Copilot behaviour |

---

## Governance

Spec-Scout ships with a [Constitution](.github/spec-scout/CONSTITUTION.md) — three hard rules the AI enforces on every story:

1. **Data Sanctity** — zero-tolerance for plaintext PII or secrets in logs, storage, or telemetry
2. **Resilience Threshold** — all new code must target 90% test coverage (positive, negative, and edge cases)
3. **Scope Preservation** — the AI is forbidden from refactoring code outside the current story's scope

The AI will also **never** run `git commit`, `git push`, or any other git-write command. All git operations are always your responsibility.

---

## Contributing

See [CONTRIBUTING.md](.github/CONTRIBUTING.md). All contributions are welcome — please read the rules for framework file changes before opening a PR.

---

## License

[MIT](LICENSE) · Framework Version v3.0.0 · © 2026 specscout27

