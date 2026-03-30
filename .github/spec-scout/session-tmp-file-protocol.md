<!-- Framework Version: v3.2.0 -->
<!-- Compatible with: copilot-instructions.md v3.1.0 -->
# Session-Resilient Temporary File Protocol

**Purpose:**
To ensure session continuity and prevent data loss, a temporary file is maintained
throughout the SDD workflow. This file records a phase-by-phase structured log of
the current session's progress, decisions, user answers, and approved outputs —
enabling full session recovery by a completely new agent or in a new session
without repeating completed phases.

**Design Principle:**
Each phase section must contain enough context for a brand-new agent to pick up
from that point and continue correctly — without re-running the phase or asking
the user to repeat information they have already provided.

**File Location & Naming:**
- Created under `.github/`
- Filename: story/problem title with spaces replaced by underscores, special
  characters removed, `.tmp.md` extension.
- Example: `.github/Update_Contact_Validation_Rules.tmp.md`

**When to Create/Update:**
- **Created** at the end of P0, or at the end of Phase 1 if P0 was skipped —
  whichever comes first.
- **Updated** at the end of every subsequent phase (1, 2, 3, after each task
  in Phase 4, and at the end of Phase 5).

---

## 📋 Mandatory Temp File Schema

Every session temp file MUST contain all sections below.
Sections for phases not yet reached must be present but marked `NOT REACHED`.

---

```markdown
# Session: [Story Title]
**Created:** [ISO 8601 datetime]
**Last Updated:** [ISO 8601 datetime]
**Current Phase:** [P0 / 1 / 2 / 3 / 4-TN / 5]
**needContextReload:** [true / false]

---

## Session Meta
- **Story / Prompt:** [Full original user request — do not paraphrase or truncate]
- **Loaded Modules:** [Comma-separated list of module context files loaded]
- **Execution Mode:** [Full workflow / @lite / @analysis only / @solution only]

---

## P0 Outcome
<!-- Status only — no detailed context required for P0 -->
- **Drift Check Run:** [YES / NO / SKIPPED]
- **Modules Updated:** [List of updated module files, or NONE]
- **Warning Issued:** [YES — context may have drifted / NO]

---

## Phase 1 — Analysis Context

<!-- PURPOSE: A new agent reading this section must be able to proceed
     directly to Phase 2 with full understanding of the system state and
     all constraints that must be respected in the solution.
     No phase re-run required. -->

### 1A. Scope & System State
- **Change scope:** [One paragraph describing exactly what the story requires
  and which parts of the system are affected]
- **Files in scope:** [List of all files identified as relevant]
- **Modules loaded:** [List with one-line reason each was selected]
- **Key flows identified:** [List of named flows or entry points relevant to
  this change, with a one-line description of each]

### 1B. Risks & Constraints from Analysis
<!-- List every risk, constraint, or complexity flag surfaced during the
     technical analysis. These directly inform solution design in Phase 2. -->
- [Risk or constraint — one line each, or NONE]

### 1C. Key Decisions & Constraints from User Clarification
<!-- Store only the decisions and constraints extracted from user answers.
     Do NOT store verbatim Q&A pairs.
     Each entry must be actionable — a new agent must read this list and
     know exactly what is and is not permitted in the solution. -->
- [Decision or constraint — one line each]
- Example: "Must not change the public-facing API contract"
- Example: "Retry logic must use the existing RetryPolicy class, not a new one"
- Example: "No new database tables — must work within the current schema"
- **Unanswered / deferred questions:** [List any that remain open, or NONE]

### 1D. Governance & Conflict Status
- **Governance flags [C1/C2/C3]:** [Blocking: [list] / Advisory: [list] / NONE]
- **Conflict detected:** [YES — [type and modules involved] / NO]
- **Baseline test status:** [PASS / FAIL — [summary of pre-existing failures]]

### 1E. User Approval
- **Status:** [APPROVED / PENDING]
- **User modifications requested before approval:** [List, or NONE]

---

## Phase 2 — Selected Solution Context

<!-- PURPOSE: A new agent reading this section must be able to proceed
     directly to Phase 3 with complete understanding of the approved
     solution, why it was chosen, and any constraints the user placed
     on its implementation. No phase re-run required. -->

### 2A. Options Presented
<!-- Brief record of all options shown — enough to understand what was
     considered and why the selected option won. -->

| Option | Title | One-line Summary | Key Trade-off |
|--------|-------|-----------------|---------------|
| 1 | [title] | [summary] | [trade-off] |
| 2 | [title] | [summary] | [trade-off] |

### 2B. Selected Approach — Full Detail
<!-- Must be detailed enough that a new agent can implement the solution
     correctly without revisiting Phase 2. Do not summarise. -->

- **Selected option:** [Option number and title]
- **Approach description:** [Full description — what changes, how it works,
  which components are involved, and how it integrates with existing flows
  identified in Phase 1]
- **Why this option was selected:** [User's stated reason or the key
  trade-offs that drove the decision]
- **Implementation constraints from user:** [Any specific instructions,
  preferences, or restrictions the user stated during Phase 2 — e.g.
  "must not change the public API", "use existing pattern from X module".
  If none stated: NONE]
- **Context files that will need updating post-implementation:** [List]

### 2C. User Modifications Before Confirmation
- [Any changes the user requested to the approach before confirming, or NONE]

### 2D. User Approval
- **Status:** [CONFIRMED / PENDING]

---

## Phase 3 — Approved Task Breakdown

<!-- PURPOSE: A new agent reading this section must be able to begin
     Phase 4 execution immediately using this task list as the authoritative
     plan — no ambiguity about scope, order, or test expectations. -->

### 3A. Final Approved Task List

<!-- Include the full task list exactly as approved by the user.
     Do not summarise or truncate. -->

| Task | Description | Depends On | Test Gate |
|------|-------------|------------|-----------|
| T1 | [Full task description] | [None] | [What tests will be written and/or run] |
| T2 | [Full task description] | [T1] | [What tests will be written and/or run] |
| TN | Build verification | [All prior tasks] | Full build passes |

### 3B. Scope Boundaries
- **Explicitly in scope:** [List]
- **Explicitly out of scope:** [List — captures anything the user said should
  NOT be changed or included. Equally important as what is in scope.]

### 3C. User Modifications Before Approval
- [Any reordering, additions, or removals the user requested, or NONE]

### 3D. User Approval
- **Status:** [EXECUTE PLAN received / PENDING]

---

## Phase 4 — Execution Progress

<!-- PURPOSE: Tracks task-by-task completion, test results, and any
     user-driven changes. All changes are recorded against the specific
     task they affected — not in a separate log.
     A resuming agent must be able to identify which tasks are done,
     which is next, and what constraints were applied during execution. -->

### 4A. Task Status

<!-- One entry per task. Update each entry at the end of that task only.
     NOTES FIELD: If the user raised a change, question, or instruction
     that affected this task — record the resulting constraint or decision
     in the Notes field of that specific task. If a single change affected
     multiple tasks, add a note to each affected task entry individually.
     If no changes affected this task: leave Notes as — -->

| Task | Status | Test Gate | Build | Notes |
|------|--------|-----------|-------|-------|
| T1 | [COMPLETE / IN PROGRESS / PENDING] | [PASS ✅ / FAIL ❌ / PENDING] | [PASS ✅ / FAIL ❌ / PENDING] | [Constraint or decision from user input that affected this task, or —] |
| T2 | [COMPLETE / IN PROGRESS / PENDING] | [PASS ✅ / FAIL ❌ / PENDING] | [PASS ✅ / FAIL ❌ / PENDING] | [Constraint or decision from user input that affected this task, or —] |

### 4B. Phase 4 Completion Gate
- **All tasks complete:** [YES / NO]
- **All test gates passed:** [YES / NO — list any failures]
- **Final build status:** [PASS ✅ / FAIL ❌]
- **User approval to proceed to Phase 5:** [APPROVED / PENDING]

---

## Phase 5 — Review & Close

<!-- PURPOSE: Records what was checked and the outcome at a level sufficient
     for audit and handoff. Pass/fail plus one-line note per area. -->

### 5A. Test Suite Results
- **Scope run:** [Impacted tests only (@lite) / Full suite (full mode)]
- **Result:** [PASS ✅ / FAIL ❌]
- **New tests written this session:** [List of test file/case names]
- **Pre-existing failures (not caused by this story):** [List, or NONE]
- **Regressions introduced by this story:** [List, or NONE]
- **Coverage on new/changed logic:** [N% — MEETS ✅ / BELOW ⚠️ 90% threshold [C2]]

### 5B. Technical Review
<!-- Pass/fail per area plus one-line note on what was reviewed.
     If flagged: add a one-line resolution note directly below the table. -->

| Area | Result | What Was Reviewed |
|------|--------|------------------|
| Security | [PASS ✅ / FLAG ⚠️] | [One line — e.g. "Input validation and auth checks on new endpoint"] |
| Efficiency | [PASS ✅ / FLAG ⚠️] | [One line — e.g. "Query count per request, no N+1 issues found"] |
| Maintainability | [PASS ✅ / FLAG ⚠️] | [One line — e.g. "Naming and complexity reviewed, no issues"] |

<!-- Flags only — add one line per flagged item: what was found and how resolved -->

### 5C. Governance Compliance
- **Data / PII [C1]:** [COMPLIANT ✅ / FLAG ⚠️ — one-line detail]
- **Coverage threshold [C2]:** [MEETS ✅ / BELOW ⚠️ — one-line detail]
- **Scope preservation [C3]:** [CLEAN ✅ / FLAG ⚠️ — one-line detail]

### 5D. Deliverables
- **Files modified:** [List]
- **Summary file generated:** [filename.md / NOT GENERATED — @lite or not requested]
- **Commit message:**
  ```
  [feat/fix/chore: full commit message]
  ```

### 5E. Context Update
- **@update-context run this session:** [YES / NO — deferred to next session P0]

---

## Open Items
<!-- Any unresolved questions, deferred decisions, known gaps, or
     follow-up actions the next session or agent should be aware of. -->
- [Item — or NONE]
```

---

## Update Protocol

- At the end of each phase, **overwrite the relevant section** with that
  phase's outcomes. Do not append duplicate sections.
- The `Last Updated` and `Current Phase` header fields must be accurate
  at all times.
- **Phase 1C** stores decisions and constraints extracted from user answers
  only — not verbatim Q&A pairs. Each entry must be actionable by a
  resuming agent without additional context.
- **Phase 4A Notes** is the only place mid-execution changes are recorded.
  Record the resulting constraint or decision against each task it affected.
  If one change affected multiple tasks, add a note to each task individually.
- **Phase 5B** requires a one-line note per review area describing what was
  checked — pass/fail alone is not sufficient. Flagged items must include
  a one-line resolution note.

---

## Session Continuity and the @continue Command

**Command:** `@continue`

If a user references a session temp file in a new session and uses `@continue`:

1. The agent MUST read the referenced temp file in full.
2. The agent MUST validate that the file:
   - Follows the mandatory schema above (all section headers present).
   - Contains a non-empty `## Session Meta` section with a real story prompt.
   - Contains at least one completed phase section (not `NOT REACHED`).
   - `Current Phase` indicates a real phase, not a placeholder.
3. **If valid:**
   - Reload all modules listed in `Session Meta → Loaded Modules`.
   - Restore `needContextReload` from the file header.
   - Identify the next uncompleted phase or task from Phase 4A or phase
     status fields.
   - Announce: `"♻️ Session restored from [filename]. Resuming from [phase/task]."`
   - Resume immediately — do not re-run completed phases.
4. **If invalid (missing, malformed, or lacks completed phase summaries):**
   - Output: `"❌ Session temp file is invalid or incomplete. Cannot restore session."`
   - Offer two recovery options:
     - **(A) Start fresh** — begin the full SDD workflow from P0.
     - **(B) Manual restore** — user pastes the last completed phase section
       content directly into chat and the agent reconstructs from that point.

---

*Framework Version: v3.2.0 · Updated to support full handoff context per phase.*
