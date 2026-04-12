# Contributing to Spec-Scout

Thank you for wanting to improve Spec-Scout! This is a Markdown-only framework — there's no build system, no package manager, no CI to pass. But the files are deeply interconnected, so please read these rules before opening a PR.

---

## What you can contribute

- **Bug fixes** — incorrect logic in workflow instructions, broken command behaviour, or wrong cross-file references
- **Documentation improvements** — clearer wording, better examples, typo fixes
- **New commands or phase extensions** — open a Discussion first so the community can align before you write anything
- **Translations** of the root `README.md` (keep the original English file unchanged)

---

## Rules for framework file changes

These rules exist because the AI agent resolves every file reference at runtime. A broken path or a renamed section silently breaks every user's workflow.

### 1. Do not break internal cross-file path references
Every file that references another by path (e.g. `.github/spec-scout/code-to-spec.md`, `.github/spec-scout/update-context.md`) must still resolve after your change. Before submitting, search for every reference to the file you renamed or moved and update them all.

### 2. Bump the version tag
Every framework file contains a version comment on line 1:
```
<!-- Framework Version: v3.0.0 -->
```
If you modify a framework file, increment the version in that file's header following the semver policy in `CHANGELOG.md`:
- **Patch** (e.g. `v3.0.0` → `v3.0.1`): doc/copy fixes
- **Minor** (e.g. `v3.0.0` → `v3.1.0`): new command or phase added
- **Major** (e.g. `v3.0.0` → `v4.0.0`): breaking change to phases, file paths, or commands

### 3. Update `CHANGELOG.md`
Every PR must add a bullet under the `## [Unreleased]` heading describing what changed. Use the existing entries as a style guide.

### 4. Test manually in a real repo
Copy the changed files into a test repository and run through at least one full SDD session (P0 → Phase 5) before submitting. There are no automated tests for Markdown instruction files — human verification is the only gate.

### 5. No git-write commands
The hard constraint in the framework is that the agent must never write to git. Do not add `git commit`, `git push`, `git stash`, `git checkout`, `git reset`, or `git clean` to any framework file under any condition.

---

## Opening a PR

1. Fork the repo and create a feature branch off `main`
2. Make your changes following the rules above
3. Fill in the PR template completely — incomplete PRs will be closed
4. A maintainer will review within a reasonable timeframe

## Opening an Issue

Use the issue templates:
- **Bug report** — something in the SDD workflow isn't behaving as documented
- **Feature request** — propose a new command, phase, or behaviour

## Questions

Open a [Discussion](../../discussions) rather than an issue for general questions about using Spec-Scout in your own repo.

---

*By contributing, you agree that your contributions will be licensed under the [Non-Commercial Attribution License v1.0](../LICENSE). Commercial use of contributions is prohibited without a separate written agreement.*

