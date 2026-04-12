<!-- Framework Version: v3.2.0 -->
<!-- Compatible with: copilot-instructions.md v3.1.0 -->
# Session-Resilient Temporary File Protocol

**File Location & Naming:**
- Created under `.github/`
- Filename: story/problem title with spaces replaced by underscores, special
  characters removed, `.tmp.md` extension.
- Example: `.github/Update_Contact_Validation_Rules.tmp.md`

**When to Create/Update:**
- The temporary file must be **created at the end of P0** (after the drift check decision), or at the end of Phase 1 if P0 was skipped — whichever comes first.
- It must be **updated at the end of every subsequent phase** (1, 2, 3, after each task in 4, and 5).

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
**This is the most important section for session continuity. It must capture all critical context, decisions, constraints, and user clarifications that will inform the rest of the workflow. Be as detailed and specific as possible, as this is what a resuming agent will rely on to pick up where we left off.**

## Phase 1 — Analysis Context
Write a detailed summary of the analysis phase here, with the given title below

### 1A. Scope & System State

### 1B & 1C . Risks & Constraints from Analysis and User Clarification

### 1D. Governance & Conflict Status

---

## Phase 2 — Selected Solution Context
Write a detailed summary of the analysis phase here, with the given title below

### 2A. Options Presented

### 2B. Selected Approach — Full Detail

---

## Phase 3 — Approved Task Breakdown
Write a detailed summary of the analysis phase here, with the given title below

### 3A. Final Approved Task List

### 3B. Scope Boundaries

---

## Phase 4 — Execution Progress
Write a detailed summary of the analysis phase here, with the given title below

### 4A. Task Status

### 4B. Phase 4 Completion Gate


---

## Phase 5 — Review & Close
Write a detailed summary of the analysis phase here, with the given title below

### 5A. Test Suite Results

### 5D. Deliverables
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