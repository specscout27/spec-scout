# Spec-Scout Template & Install Guide

This file documents how to configure this repository as a GitHub Template and how the two install paths work for end users.

---

## Enabling the GitHub Template Repository flag

1. Go to your repository on GitHub
2. Click **Settings** → **General**
3. Scroll to the **Template repository** checkbox under the repository name section
4. Check the box and save

Once enabled, a **"Use this template"** button will appear on the repository's main page. Users can click it to create a new repository pre-loaded with all Spec-Scout framework files.

---

## Recommended GitHub repository topics

Add these topics to the repository to improve discoverability (Settings → General → Topics):

```
github-copilot
ai-workflow
spec-driven-development
developer-productivity
copilot-instructions
sdd
markdown
ai-coding
```

---

## The two install paths

### Path 1 — "Use this template" (recommended for new repos)

**Who it's for:** Anyone starting a brand-new repository.

**How it works:**
1. User clicks "Use this template" on the Spec-Scout GitHub page
2. GitHub creates a new repository in the user's account, pre-populated with all framework files
3. User clones their new repo, switches to `main`, opens Copilot Chat, and pastes `code-to-spec.md`

**What the user gets immediately:**
- `.github/copilot-instructions.md` ready to use
- All `.github/spec-scout/` framework files in place
- Empty `context/` scaffold ready for first-time context generation

**What the user still needs to do:**
- Run the `code-to-spec.md` interactive session to generate their module context files
- Commit and push the generated context

---

### Path 2 — `install.sh` (for existing repos)

**Who it's for:** Anyone who already has a repository and wants to add Spec-Scout to it.

**How it works:**
```bash
# Option 1: curl direct (run from your repo root)
curl -fsSL https://raw.githubusercontent.com/specscout27/spec-scout/main/install.sh | bash

# Option 2: clone and run (inspect first)
git clone https://github.com/specscout27/spec-scout.git /tmp/spec-scout
cd /path/to/your-repo          # ← must be in YOUR repo root before calling the script
bash /tmp/spec-scout/install.sh

# Option 3: overwrite existing files
bash /tmp/spec-scout/install.sh --force
```

**What the script does:**
1. Detects the target repository root via `git rev-parse --show-toplevel`
2. Copies all framework files to `.github/` and `.github/spec-scout/`
3. Creates the `context/modules/` directory scaffold
4. Prints the full setup checklist on completion

**What the script never does:**
- Runs `git commit`, `git push`, or any git-write command
- Modifies any existing application code
- Creates or modifies anything outside `.github/`

---

## Upgrading an existing installation

When a new version of Spec-Scout is released:

1. Clone or pull the latest spec-scout repo
2. Run `install.sh --force` in your target repo to overwrite framework files with the new version
3. Check the [CHANGELOG](../CHANGELOG.md) for breaking changes
4. Commit the updated files:
   ```bash
   git add .github/
   git commit -m "chore: upgrade spec-scout to vX.Y.Z"
   git push origin main
   ```

---

## What is NOT included in the template / install

The following files are **user-generated** and are intentionally excluded from the framework repo (they are in `.gitignore`):

| File | Why excluded |
|------|-------------|
| `.github/spec-scout/context/index.md` | Generated from your specific codebase — unique to each repo |
| `.github/spec-scout/context/modules/*.md` | Generated per-module — unique to each repo |
| `.github/spec-scout/context/checkpoint.md` | Temporary state file during `code-to-spec` run |
| `.github/*.tmp.md` | Session temp files — should never be committed |

Users generate these by running the `code-to-spec.md` interactive session after install.

