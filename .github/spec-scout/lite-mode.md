# 🚀 Lite Mode: @lite
<!-- Framework Version: v1.0.0 — Companion to copilot-instructions.md -->

---

## Purpose

A compressed workflow for small changes, bug fixes, and low-risk tasks.
All phases execute but with reduced output verbosity and fewer approval gates.
Test writing, build verification, and mid-task interruption handling are
**non-negotiable** — they apply identically to full mode.

---

## Trigger

Include `@lite` anywhere in your prompt to activate this mode.

`@lite` is **mutually exclusive** with `@noscout`, `@analysis`, `@solution`, `@update-context`.
If combined with any of these, state the conflict and ask the user which mode to apply.

---

## ⛔ Hard Constraints (Inherited — Always Active)

All [HARD-1] through [HARD-5] rules from `copilot-instructions.md` remain **fully active**.
`@lite` does not relax any hard constraint.

If a user instruction contradicts any [HARD-X] rule, state the constraint by name,
refuse the instruction, and explain why — identical to full mode behaviour.

---

## 📋 Global Lite Mode Rules

| Rule | Behaviour |
|------|-----------|
| **LITE-1: MID-TASK INTERRUPTION** | If the user asks a question, suggests a change, or raises a concern at any point — **stop immediately**, answer or assess it, update the affected plan steps, display the updated plan to the user, and wait for explicit confirmation (`"CONFIRMED"`, `"PROCEED"`, or `"APPROVED"`) before resuming. This rule is identical to full mode and **cannot be relaxed**. |
| **LITE-2: TEST GATE** | For every task — write tests for new logic, update impacted tests, verify build passes, run impacted tests. All must pass before the task is internally complete. This rule is identical to full mode and **cannot be relaxed**. |
| **LITE-3: HARD CONSTRAINTS** | All [HARD-1] through [HARD-5] rules remain fully active. `@lite` does not relax any hard constraint. |
| **LITE-4: VERBOSITY** | All phase outputs must be concise. No lengthy prose. Use short bullets and inline summaries only. |
| **LITE-5: GOVERNANCE FLAGS** | If any [C1][C2][C3] violation is detected at any phase — escalate immediately, treat as blocking, and do not compress or skip the governance response. |

---

## @lite Command Routing Summary

| Phase | Full Mode | @lite Mode |
|-------|-----------|------------|
| P0 | Offered — YES/NO gate | Skipped — one-line warning printed |
| Phase 1 | Deep scan, boundary check, drift report | Affected files only, no boundary check, 10-line summary |
| Phase 2 | 2+ options, full pros/cons | Single approach, 5-line confirmation |
| Phase 3 | Full T1–T6 slot breakdown | Flat numbered list with test gate notes |
| Phase 4 | Hard stop after every task | Internal test gate per task, single approval at end |
| Phase 5 | Full suite, 3-axis review, summary file | Impacted tests only, brief review, no summary file |
| Mid-task changes | Stop, update, surface, wait | **Identical — LITE-1 cannot be relaxed** |
| Test writing | Mandatory per task | **Identical — LITE-2 cannot be relaxed** |
| Build check | Mandatory per task | **Identical — LITE-2 cannot be relaxed** |
| [HARD-1] to [HARD-5] | Fully active | **Identical — LITE-3 cannot be relaxed** |

---

## Phase Execution

---

### P0 — Drift Check

**Action:** Skip entirely. No question asked.

Print one line verbatim and proceed directly to Phase 1:

> `"⚡ @lite mode active — P0 drift check skipped. Context may have drifted from main."`

---

### Phase 1 — Lightweight Scan

**Goal:** Identify only what is directly affected by this change. No deep analysis.

#### Do:
- Load only the module context files directly relevant to this change.
- Scan only the files likely touched by this change.
- Note any obvious [C1][C2][C3] violations in scope.
- List any critical clarifying questions ([HARD-3] still applies in full).

#### Do NOT:
- Run boundary checks or conflict detection.
- Produce a drift classification report.
- Run a baseline test suite.
- Analyse modules not directly in scope.

#### Output format — one structured block, maximum 10 lines:

```
📋 Lite Phase 1 Summary
- Change scope:       [one line description]
- Files in scope:     [list]
- Modules loaded:     [list]
- Governance flags:   [NONE or specific flag]
- Clarifying questions: [NONE or list]
```

**→ NO WAIT GATE after Phase 1 in @lite mode.**

Proceed directly to Phase 2 **unless**:
- A critical [HARD-3] question is open → stop and wait for user response before continuing.
- A [C1][C2][C3] flag was raised → stop and wait for user response before continuing.

---

### Phase 2 — Approach Confirmation

**Goal:** State the single most appropriate approach and get a fast confirmation.
Do not generate multiple options unless the user explicitly asks.

#### Output format — maximum 5 lines:

```
🔧 Lite Phase 2 — Proposed Approach
- Approach:              [one line description]
- Why:                   [one line rationale]
- Risk:                  [NONE or one line]
- Context files impacted: [list]
```

**→ WAIT GATE.** Print verbatim:
> `"⚡ Confirm approach? Reply CONFIRMED to proceed, or suggest a change."`

**Branch handling:**
- User replies `CONFIRMED` → proceed to Phase 3.
- User suggests a change → update the approach, re-display the updated Phase 2 block, wait for confirmation again.
- Do NOT proceed until explicitly confirmed.

---

### Phase 3 — Simplified Task List

**Goal:** Flat numbered list of tasks. No T1–T6 slot breakdown.
No governance sub-tasks unless a [C1][C2][C3] flag was raised in Phase 1.

#### Output format:

```
📝 Lite Phase 3 — Task List
1. [Task description] — Test gate: [what will be tested]
2. [Task description] — Test gate: [what will be tested]
...
N. Build verification — confirm full build passes after all tasks.
```

**Rules:**
- Every task that touches code must include a one-line `Test gate` note.
- Order tasks by dependency — least dependent first.
- If a [C1][C2][C3] flag was raised in Phase 1 → add a dedicated compliance task explicitly.

**→ WAIT GATE.** Print verbatim:
> `"⚡ Task list ready. Reply EXECUTE to begin, or suggest changes."`

**Branch handling:**
- User replies `EXECUTE` → proceed to Phase 4.
- User suggests changes → update the task list, re-display the full updated list, wait for confirmation again.
- Do NOT proceed until explicitly confirmed.

---

### Phase 4 — Execution (Same Rigour, Batched Approval)

**Goal:** Implement all tasks. Tests and build checks run per task internally.
Single approval gate at the end — not after every individual task.

#### Execution Rules:

Implement tasks in order. After each task, run the full internal Per-Task Test Gate:

1. **Write tests for any new logic introduced** in this task.
2. **Update any existing tests** whose covered code was modified.
3. **Verify the build passes** before running any tests.
4. **Run impacted tests.** All must pass.
5. If any test fails → fix within the same task. After 2 failed fix attempts → surface
   to the user immediately, stop, do not continue to the next task.

**Do NOT pause for user approval between tasks unless:**
- A test gate fails after 2 fix attempts.
- A [HARD-3] ambiguity is encountered mid-implementation.
- The user sends any message (LITE-1 applies immediately — see below).

#### Mid-Task Interruption (LITE-1) — identical to full mode:

If the user sends any message during execution:
1. **Stop immediately.** Do not finish the current task first.
2. Answer the question or fully assess the requested change.
3. If the change impacts the **current task** → apply it, re-run the current task's full test gate before continuing.
4. If the change impacts **future tasks** → update the remaining task list, display the updated list in full, and wait for `"CONFIRMED"` / `"PROCEED"` / `"APPROVED"` before resuming.
5. **Never silently absorb a change and continue.** Every mid-task change must be surfaced and confirmed.

#### After ALL tasks complete — single approval gate:

Print this summary block:

```
✅ Lite Phase 4 Complete
Tasks executed:  [N]
Tests written:   [list of new test files/cases]
Tests updated:   [list]
Build status:    PASS ✅ / FAIL ❌
Test gate:       ALL PASS ✅ / FAIL ❌ [detail if fail]
```

Then print verbatim:
> `"⚡ All tasks complete. Reply APPROVED to proceed to final review, or raise any changes."`

**Branch handling:**
- User replies `APPROVED` → proceed to Phase 5.
- User raises changes → apply them, re-run affected test gates, update the summary block, wait for approval again.
- Do NOT proceed until explicitly approved.

---

### Phase 5 — Lightweight Review & Close

**Goal:** Verify build and impacted tests pass at the system level. Brief one-pass review.
No full test suite. No summary file unless explicitly requested.

#### Do:
- Run build + all tests impacted by this change (not the full suite).
- Perform a brief one-pass review across security, efficiency, and maintainability —
  flag only genuine issues. No advisory padding.
- Generate a Git commit message.
- Remind the user to run `@update-context`.

#### Do NOT:
- Run the full system test suite.
- Generate a summary `.md` file (unless the user explicitly asks).
- Perform a full three-axis deep review.
- Update context module files directly — this is handled by `@update-context`.

#### Output format:

```
🏁 Lite Phase 5 — Final Review
- Build:                  PASS ✅ / FAIL ❌
- Impacted tests:         ALL PASS ✅ / FAIL ❌ [detail if fail]
- Review flags:           [NONE or specific issue with snippet]
- Governance [C1][C2][C3]: COMPLIANT ✅ / FLAG ⚠️ [detail]
- Files modified:         [list]
```

Then print the commit message as a code block:

```
feat/fix/chore: [concise description]
```

Then print verbatim:
> `"📋 Context Update Reminder: Run @update-context (or it will be offered at P0 next session) to sync module context files with these changes."`

---

## Failure Mode Catalogue (@lite)

| Situation | Agent Action |
|-----------|-------------|
| Test gate fails after 2 fix attempts | Stop immediately. Surface full failure detail to user. Do not continue to next task. Do not ask to advance. |
| Build fails | Fix before running any tests. If unfixable after 2 attempts → surface to user, stop. |
| [HARD-3] triggered mid-implementation | Stop. Ask one targeted clarifying question. Do not write code until answered. |
| [C1][C2][C3] flag detected at any phase | Escalate immediately. Treat as blocking. Do not compress or skip governance response. |
| User message received mid-execution | Apply LITE-1 in full. Stop, assess, update plan, surface, wait for confirmation. |
| `@lite` combined with incompatible command | State the conflict by name. Ask user which mode to apply. Do not proceed until resolved. |

---