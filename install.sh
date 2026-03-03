#!/usr/bin/env bash
# =============================================================================
# Spec-Scout Installer — Framework Version v3.0.0
# https://github.com/specscout27/spec-scout
#
# Copies the Spec-Scout SDD framework files into your repository so you can
# start using GitHub Copilot Chat with the full governed workflow immediately.
#
# Usage:
#   bash install.sh           # Install, skip files that already exist
#   bash install.sh --force   # Install, overwrite any existing framework files
# =============================================================================

set -euo pipefail

# ── Argument parsing ──────────────────────────────────────────────────────────
FORCE=false
for arg in "$@"; do
  [[ "$arg" == "--force" ]] && FORCE=true
done

# ── Resolve paths ─────────────────────────────────────────────────────────────
# SCRIPT_DIR = directory this script lives in (the spec-scout repo root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# TARGET_ROOT = root of the repo the user wants to install INTO
# If the user is running the script from inside the spec-scout clone, we default
# to that same directory. If they pipe via curl, we use the current directory.
if git -C "$SCRIPT_DIR" rev-parse --show-toplevel &>/dev/null; then
  SPEC_SCOUT_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
else
  SPEC_SCOUT_ROOT="$SCRIPT_DIR"
fi

# The target repo is where the user is RIGHT NOW (their repo, not spec-scout's)
TARGET_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

TARGET_GITHUB="$TARGET_ROOT/.github"
TARGET_SDD="$TARGET_GITHUB/spec-scout"

# ── Banner ────────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🏗️  Spec-Scout Installer   Framework v3.0.0"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Source : $SPEC_SCOUT_ROOT"
echo "  Target : $TARGET_ROOT"
[[ "$FORCE" == true ]] && echo "  Mode   : --force (existing files will be overwritten)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Guard: refuse to overwrite this repo's own files without --force ──────────
if [[ "$TARGET_ROOT" == "$SPEC_SCOUT_ROOT" ]]; then
  echo "⚠️  Warning: Target repo is the same as the Spec-Scout source repo."
  echo "   This is only valid during development. Proceeding anyway."
  echo ""
fi

# ── Helper: copy a single file ────────────────────────────────────────────────
copy_file() {
  local src="$1"
  local dst="$2"

  if [[ ! -f "$src" ]]; then
    echo "  ❌  Missing source file — skipped: $src"
    return
  fi

  mkdir -p "$(dirname "$dst")"

  if [[ -f "$dst" ]] && [[ "$FORCE" == false ]]; then
    echo "  ⏭️  Skipped (already exists): ${dst#$TARGET_ROOT/}"
    echo "      Run with --force to overwrite."
  else
    cp "$src" "$dst"
    echo "  ✅  Copied : ${dst#$TARGET_ROOT/}"
  fi
}

# ── Copy framework files ──────────────────────────────────────────────────────
echo "📂 Copying framework files..."
echo ""

copy_file \
  "$SPEC_SCOUT_ROOT/.github/copilot-instructions.md" \
  "$TARGET_GITHUB/copilot-instructions.md"

copy_file \
  "$SPEC_SCOUT_ROOT/.github/spec-scout/CONSTITUTION.md" \
  "$TARGET_SDD/CONSTITUTION.md"

copy_file \
  "$SPEC_SCOUT_ROOT/.github/spec-scout/code-to-spec.md" \
  "$TARGET_SDD/code-to-spec.md"

copy_file \
  "$SPEC_SCOUT_ROOT/.github/spec-scout/update-context.md" \
  "$TARGET_SDD/update-context.md"

copy_file \
  "$SPEC_SCOUT_ROOT/.github/spec-scout/session-tmp-file-protocol.md" \
  "$TARGET_SDD/session-tmp-file-protocol.md"

copy_file \
  "$SPEC_SCOUT_ROOT/.github/spec-scout/summary-template.md" \
  "$TARGET_SDD/summary-template.md"

copy_file \
  "$SPEC_SCOUT_ROOT/.github/spec-scout/README.md" \
  "$TARGET_SDD/README.md"

# ── Create context directory scaffold ────────────────────────────────────────
echo ""
echo "📂 Creating context directory scaffold..."
mkdir -p "$TARGET_SDD/context/modules"

# Only create .gitkeep files if the directories are empty
[[ ! -f "$TARGET_SDD/context/.gitkeep" ]]         && touch "$TARGET_SDD/context/.gitkeep"         && echo "  ✅  Created : .github/spec-scout/context/.gitkeep"
[[ ! -f "$TARGET_SDD/context/modules/.gitkeep" ]]  && touch "$TARGET_SDD/context/modules/.gitkeep" && echo "  ✅  Created : .github/spec-scout/context/modules/.gitkeep"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅  Spec-Scout v3.0.0 installed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋  Setup Checklist"
echo ""
echo "  Framework files"
echo "  ☐  .github/copilot-instructions.md          ← copied ✅"
echo "  ☐  .github/spec-scout/CONSTITUTION.md        ← copied ✅"
echo "  ☐  .github/spec-scout/code-to-spec.md        ← copied ✅"
echo "  ☐  .github/spec-scout/update-context.md      ← copied ✅"
echo "  ☐  .github/spec-scout/session-tmp-file-protocol.md  ← copied ✅"
echo "  ☐  .github/spec-scout/summary-template.md    ← copied ✅"
echo ""
echo "  Context generation (do this next)"
echo "  ☐  Switch to your 'main' branch with a clean working tree"
echo "  ☐  Open GitHub Copilot Chat in your IDE"
echo "  ☐  Paste the full contents of .github/spec-scout/code-to-spec.md"
echo "       as your first message and follow the interactive prompts"
echo "  ☐  Confirm each module with CONFIRM, then approve with PROCEED"
echo "  ☐  Commit the generated context:"
echo ""
echo "       git add .github/spec-scout/context/"
echo "       git commit -m 'docs: generate SDD context'"
echo "       git push origin main"
echo ""
echo "  Team awareness"
echo "  ☐  Everyone starts sessions with the YES/NO context check prompt"
echo "  ☐  Everyone knows to run @update-context after merges to main"
echo "  ☐  Everyone knows the AI will never run git commands — those are manual"
echo ""
echo "📖  Full documentation: .github/spec-scout/README.md"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

