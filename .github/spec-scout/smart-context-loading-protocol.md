### 1A. Smart Context Loading Protocol 

* **ACTION:** Execute the Smart Context Loading Protocol

The SDD context is stored under `.github/spec-scout/context/`:

```
.github/spec-scout/context/
  index.md          ← Global Responsibility Index (ALWAYS read first)
  modules/
    [module_name].md  ← Individual Module Flow Analysis
```

**Execute at the start of Phase 1 (Step 1A), before any other analysis.**

1. **Read `index.md` first (MANDATORY):** Load `.github/spec-scout/context/index.md` to get the full module map, responsibilities, and entry points.
2. **Identify Relevant Modules:** Parse the user's story for domain keywords, feature names, entity names, API paths, and event names. Cross-reference against `index.md`. Select ALL modules whose responsibilities overlap with the story.
3. **Load Relevant Module Files:** For each identified module, load `.github/spec-scout/context/modules/[module_name].md`. If missing or empty → see Failure Mode Catalogue above. Do NOT load clearly unrelated modules.
4. **Deep-Dive to Code (When Needed):** If any flow or implementation detail is still ambiguous after loading module files, refer to source code files listed in the module's `Impacted Areas`. Code is the secondary source of truth; module context files are the primary.
5. **Multi-Module Loading Example:**
    - Story about "subscriber notification preferences" → load `subscriber_management.md` + `topic_and_subscription.md` + `email_delivery.md`
    - Story about "partner reporting" → load `partner_management.md` + `reporting.md`
6. **Document Loaded Modules:** In Phase 1C report, list all module context files loaded and why each was selected.

> **MODULE OWNERSHIP:** Every module file MUST contain a `## Module Ownership` block. If missing → see Failure Mode Catalogue. Do not proceed with boundary checks until it is present.