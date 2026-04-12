# Changelog

All notable changes to Spec-Scout are documented here.
Versioning follows [Semantic Versioning](https://semver.org/):

- **MAJOR** — breaking changes to phases, commands, or file paths
- **MINOR** — new commands, phases, or framework files added
- **PATCH** — documentation, copy, or non-breaking instruction fixes

---

## [Unreleased]

---

## [v3.1.0] — 2026-03-07

### Improvements — Prompt Reliability & Model Clarity

#### `copilot-instructions.md`
- **Added `⛔ HARD CONSTRAINTS` header** at the top of the file — 5 named, anchored rules (`[HARD-1]` through `[HARD-5]`) in a decision table. Rules are now re-citable by ID throughout the file instead of re-stated in prose.
- **Added `📁 File Access Manifest`** — explicit READ-ONLY vs WRITE-ALLOWED file list to prevent agent from accidentally modifying framework files.
- **Consolidated `needContextReload` check** into a single `[RELOAD-CHECK]` anchor referenced by every phase, eliminating 6 copies of the same prose instruction.
- **Added `⚠️ Failure Mode Catalogue`** — decision table for 9 failure scenarios (missing module files, test gate loops, context pressure, malformed `@continue` files, etc.) with deterministic recovery actions.
- **Added `🔀 Command Routing Table`** — replaces prose mutual-exclusion description with a single 6-row decision table covering all commands and their stop conditions.
- **Added Phase Entry Condition checklists** to every phase (P0, 1, 2, 3, 4, 5) — explicit `[ ]` preconditions the agent must verify before executing any phase action.
- **Fixed orphaned execution mode reference** in Phase 3 Auto-Task Generator (removed stale `"and execution mode"` wording left over from the mode system removal).
- **Inlined Drift Classification table** into Phase 1B with concrete examples for each level (D0–D3) — agent no longer needs to cross-reference `update-context.md` for the definition during analysis.
- **Added 2-attempt cap to Test Gate loop** with explicit Failure Mode Catalogue escalation path.
- **Moved `@noscout` escape hatch to the bottom** of the file — removes it from highest-salience position.
- **Version bumped to v3.1.0.**

#### `CONSTITUTION.md`
- **Added `<!-- Compatible with: copilot-instructions.md v3.1.0 -->`** version compatibility header.
- **Aligned Article labels to `[C1]`, `[C2]`, `[C3]`** — matches the exact reference format used in `copilot-instructions.md`.
- **Added coverage scope qualifier to Article II [C2]** — coverage mandate now explicitly excludes configuration files, infrastructure-as-code, generated code, and test helpers.
- Version bumped to 1.1.0.

#### `update-context.md`
- **Added `<!-- Compatible with: ... -->` version header.**
- **Added mutual exclusion note** at the top of the file — users reading only `update-context.md` now know which commands it cannot be combined with.
- **Replaced `[HARD-1]` label alignment** — constraint reference now matches `copilot-instructions.md` naming.
- **Made Step 4 file categorisation patterns tech-stack conditional** — separate pattern sets for Java/Spring Boot, Node.js/TypeScript, Python, and Go. Patterns are selected based on the `## 🛠️ Repo Tech Specification` block in `index.md` rather than hardcoded to Java paths.
- **Added language-agnostic fallback** for Step 4 — directory name heuristics for projects that don't match any named stack pattern.
- **Removed hardcoded tool names** (`replace_string_in_file`, `semantic_search`, `grep_search`, `run_in_terminal`) from Tools to Use section — replaced with intent descriptions so the instructions work across any agent context.
- Version updated to 3.1.0.

#### `code-to-spec.md`
- **Added `<!-- Compatible with: ... -->` version header.**
- **Added terminal unavailability fallback** to Pre-Flight Guard — if terminal access is unavailable, the agent asks the user to paste `git rev-parse` and `git status` output manually.
- **Removed `python3 -m json.tool` dependency** from Node.js tech stack detection — replaced with plain `cat package.json | head -40`.
- **Fixed "propose exactly two" contradiction** in Step 2D Conflict Handling Protocol — now says "the most relevant two from the three listed resolution models" (aligned with the fact that three models are listed).
- **Added pre-deletion verification note** to Step 4C — agent must cross-check `checkpoint.md` against `index.md` before deletion to ensure nothing is lost.

#### `session-tmp-file-protocol.md`
- **Full rewrite.**
- **Added mandatory temp file schema** — all required sections defined with exact field names and allowed values. Agent no longer invents its own format.
- **Fixed creation trigger** — temp file is now created at end of P0 (not Phase 1) so P0 decisions are captured before any phase can fail.
- **Added structured `@continue` recovery path** — if the temp file is invalid, agent now offers two explicit options: (A) start fresh, (B) manual restore via pasted phase summary.
- **Added version compatibility header.**

#### `summary-template.md`
- **Added `<!-- Compatible with: ... -->` version header.**
- **Added `Session Temp File` field** to metadata header — links summary back to the session that produced it.
- **Added `## ⚠️ Risk & Rollback` section** — rollback steps and blast radius fields for team-facing use.
- **Replaced freeform `## Notes & Decisions`** with three structured prompts: Alternatives considered, Why this approach was chosen, Known limitations.
- **Added `[C1]` and `[C3]` labels** to Quality Gate table rows for traceability.

---

## [v3.0.0] — 2026-03-04

### Initial Public Release

#### Framework Files
- `copilot-instructions.md` — Full SDD agent workflow: Phases P0 → 5 with strict WAIT gates between every phase
- `CONSTITUTION.md` — Three non-negotiable governance articles: Data Sanctity (PII/Secrets), Resilience Threshold (90% coverage floor), Scope Preservation
- `code-to-spec.md` — Interactive first-time context generator; detects tech stack, maps modules, generates `index.md` and per-module files
- `update-context.md` — Drives the `@update-context` command with Drift Classification System (D0–D3) and Conflict Escalation Model
- `session-tmp-file-protocol.md` — Session-resilient `.tmp.md` file protocol with `@continue` restore command
- `summary-template.md` — Structured per-story summary artefact generated at end of Phase 5

#### Commands
- `@update-context` — Sync module context files with committed changes on `main`; interactive Before → After review
- `@analysis` — Run Phase 1 only (analysis report, no solution)
- `@solution` — Run Phases 1–2 (analysis + solution options, then stop)
- `@continue` — Restore a previous session from its `.tmp.md` file
- `@noscout` — Bypass SDD entirely for a single message


#### Governance
- Non-Commercial Attribution License v1.0 (commercial use prohibited; attribution required)
- `CONSTITUTION.md` mandates enforced across all phases
- Agent hard constraint: no git write commands ever

---

*Spec-Scout is a Markdown-only framework — no build tools, no runtime dependencies.*

