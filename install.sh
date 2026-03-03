#!/usr/bin/env bash
# =============================================================================
# Spec-Scout Installer — Framework Version v3.0.0
# https://github.com/specscout27/spec-scout
#
# Copies the Spec-Scout SDD framework files into your repository so you can
# start using GitHub Copilot Chat with the full governed workflow immediately.
#
# Usage (local clone — recommended):
#   git clone https://github.com/specscout27/spec-scout.git /tmp/spec-scout
#   cd /path/to/your-repo
#   bash /tmp/spec-scout/install.sh           # skip files that already exist
#   bash /tmp/spec-scout/install.sh --force   # overwrite existing files
#
# Usage (curl pipe):
#   curl -fsSL https://raw.githubusercontent.com/specscout27/spec-scout/main/install.sh | bash
# =============================================================================

set -euo pipefail

SPEC_SCOUT_REPO="https://github.com/specscout27/spec-scout.git"
FRAMEWORK_VERSION="v3.0.0"
CLEANUP_TMP=false
TMP_CLONE_DIR=""

# ── Argument parsing ──────────────────────────────────────────────────────────
FORCE=false
for arg in "$@"; do
  [[ "$arg" == "--force" ]] && FORCE=true
done

# ── Resolve SPEC_SCOUT_ROOT ───────────────────────────────────────────────────
# When run as `bash /path/to/install.sh`, BASH_SOURCE[0] is the script file.
# When piped via `curl | bash`, BASH_SOURCE[0] is empty or "/dev/stdin" —
# in that case we clone the repo to a temp directory and use that as the source.

SCRIPT_PATH="${BASH_SOURCE[0]:-}"

if [[ -n "$SCRIPT_PATH" && "$SCRIPT_PATH" != "/dev/stdin" && -f "$SCRIPT_PATH" ]]; then
  # Local invocation: source is the directory the script lives in
  SPEC_SCOUT_ROOT="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
else
  # curl-pipe invocation: clone spec-scout to a temp dir
  echo ""
  echo "  📥  Detected curl-pipe install. Cloning Spec-Scout source..."
  TMP_CLONE_DIR="$(mktemp -d)"
  CLEANUP_TMP=true
  git clone --depth 1 --quiet "$SPEC_SCOUT_REPO" "$TMP_CLONE_DIR"
  SPEC_SCOUT_ROOT="$TMP_CLONE_DIR"
  echo "  ✅  Cloned to: $TMP_CLONE_DIR"
fi

# ── Resolve TARGET_ROOT ───────────────────────────────────────────────────────
# Always the git root of wherever the USER is calling from (their repo).
# We resolve from $PWD, NOT from $SPEC_SCOUT_ROOT, so the two are always distinct.
TARGET_ROOT="$(git -C "$PWD" rev-parse --show-toplevel 2>/dev/null || echo "$PWD")"

TARGET_GITHUB="$TARGET_ROOT/.github"
TARGET_SDD="$TARGET_GITHUB/spec-scout"

# ── Banner ────────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🏗️  Spec-Scout Installer   Framework $FRAMEWORK_VERSION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Source : $SPEC_SCOUT_ROOT"
echo "  Target : $TARGET_ROOT"
[[ "$FORCE" == true ]] && echo "  Mode   : --force (existing files will be overwritten)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Guard: same-repo warning (only valid during spec-scout development) ───────
if [[ "$TARGET_ROOT" == "$SPEC_SCOUT_ROOT" ]]; then
  echo "⚠️  Warning: Target repo is the same as the Spec-Scout source repo."
  echo "   This is only valid during development. Proceeding anyway."
  echo ""
fi

# ── Guard: target must be a real directory ────────────────────────────────────
if [[ ! -d "$TARGET_ROOT" ]]; then
  echo "❌  Cannot determine target repository root."
  echo "   Run this script from inside a git repository."
  exit 1
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
echo "  ☐  Type this prompt into Copilot Chat:"
echo ""
echo "       Please read the file .github/spec-scout/code-to-spec.md and"
echo "       follow all the instructions in it to generate the SDD context"
echo "       for this repository."
echo ""
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

# ── Cleanup temp clone (curl-pipe installs only) ──────────────────────────────
if [[ "$CLEANUP_TMP" == true && -n "$TMP_CLONE_DIR" && -d "$TMP_CLONE_DIR" ]]; then
  rm -rf "$TMP_CLONE_DIR"
fi
