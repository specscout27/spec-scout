# Changelog

All notable changes to Spec-Scout are documented here.
Versioning follows [Semantic Versioning](https://semver.org/):

- **MAJOR** — breaking changes to phases, commands, or file paths
- **MINOR** — new commands, phases, or framework files added
- **PATCH** — documentation, copy, or non-breaking instruction fixes

---

## [Unreleased]

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
- MIT License
- `CONSTITUTION.md` mandates enforced across all phases
- Agent hard constraint: no git write commands ever

---

*Spec-Scout is a Markdown-only framework — no build tools, no runtime dependencies.*

