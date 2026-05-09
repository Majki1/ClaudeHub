#!/usr/bin/env bash
# install.sh — install ClaudeHub config into ~/.claude/
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Majki1/ClaudeHub/main/install.sh | bash
#   ./install.sh [--copy] [--force] [--dry-run] [--uninstall] [-v]
#
# Default behaviour: clone the hub to ~/.claude-hub, symlink skills/agents/rules
# into ~/.claude/, register plugin marketplaces in ~/.claude/settings.json, and
# add a managed block to ~/.claude/CLAUDE.md.

set -euo pipefail

HUB_REPO="${HUB_REPO:-https://github.com/Majki1/ClaudeHub.git}"
HUB_DIR="${HUB_DIR:-$HOME/.claude-hub}"
CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
MODE="symlink"
FORCE=false
DRY_RUN=false
UNINSTALL=false
VERBOSE=false

usage() {
  cat <<EOF
ClaudeHub installer.

Usage: $(basename "$0") [options]

Options:
  --copy        Copy files instead of symlinking (loses git pull updates).
  --force       Overwrite existing skills/agents/rules at the destination.
  --dry-run     Print what would happen, do nothing.
  --uninstall   Remove symlinks pointing at \$HUB_DIR and the CLAUDE.md block.
  -v, --verbose Show every link/skip decision.
  -h, --help    Show this help.

Environment:
  HUB_REPO    Source repo (default: $HUB_REPO)
  HUB_DIR     Where the hub lives (default: $HUB_DIR)
  CLAUDE_DIR  Claude config root (default: $CLAUDE_DIR)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --copy) MODE="copy" ;;
    --symlink) MODE="symlink" ;;
    --force) FORCE=true ;;
    --dry-run) DRY_RUN=true ;;
    --uninstall) UNINSTALL=true ;;
    -v|--verbose) VERBOSE=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

# ---------- helpers ----------

say()     { printf '==> %s\n' "$*"; }
verbose() { [[ "$VERBOSE" == true ]] && printf '    %s\n' "$*" || true; }
warn()    { printf '!! %s\n' "$*" >&2; }
die()     { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

# Run a command, or print it under --dry-run.
run() {
  if [[ "$DRY_RUN" == true ]]; then
    printf '[dry-run] %s\n' "$*"
  else
    eval "$@"
  fi
}

# ---------- pre-flight ----------

preflight() {
  command -v git >/dev/null 2>&1 || die "git is required"
  if ! command -v jq >/dev/null 2>&1; then
    warn "jq not found — settings.json merge will be skipped"
    warn "  install with: brew install jq  (macOS) or apt install jq (debian)"
  fi
  if [[ ! -d "$CLAUDE_DIR" ]]; then
    say "Creating $CLAUDE_DIR"
    run "mkdir -p '$CLAUDE_DIR'"
  fi
}

# ---------- bootstrap repo ----------

bootstrap_repo() {
  if [[ -d "$HUB_DIR/.git" ]]; then
    say "Updating hub at $HUB_DIR"
    run "git -C '$HUB_DIR' pull --ff-only"
  elif [[ -d "$HUB_DIR" && ! -d "$HUB_DIR/.git" ]]; then
    die "$HUB_DIR exists but is not a git repo — refusing to clobber"
  else
    say "Cloning hub to $HUB_DIR"
    run "git clone --depth 1 '$HUB_REPO' '$HUB_DIR'"
  fi
}

# ---------- link directory contents ----------
#
# For each immediate child of $1 (file or dir), create a corresponding entry
# under $2. Existing entries are skipped unless --force is set.

link_into() {
  local src="$1"
  local dst="$2"
  [[ ! -d "$src" ]] && { verbose "src missing: $src"; return 0; }
  run "mkdir -p '$dst'"

  local linked=0 skipped=0
  for entry in "$src"/*; do
    [[ ! -e "$entry" ]] && continue
    local name target
    name=$(basename "$entry")
    target="$dst/$name"

    if [[ -e "$target" || -L "$target" ]]; then
      if [[ "$FORCE" == true ]]; then
        run "rm -rf '$target'"
      else
        verbose "skip $target (exists; use --force to replace)"
        skipped=$((skipped + 1))
        continue
      fi
    fi

    if [[ "$MODE" == "symlink" ]]; then
      run "ln -s '$entry' '$target'"
    else
      run "cp -R '$entry' '$target'"
    fi
    verbose "$MODE $name -> $target"
    linked=$((linked + 1))
  done

  say "$(basename "$dst"): $linked added, $skipped skipped"
}

# ---------- merge plugin marketplaces ----------

merge_marketplaces() {
  local src="$HUB_DIR/plugins/marketplaces.json"
  local dst="$CLAUDE_DIR/settings.json"

  [[ ! -f "$src" ]] && { warn "plugins/marketplaces.json missing — skipping"; return; }
  command -v jq >/dev/null 2>&1 || { warn "jq missing — skipping marketplace merge"; return; }

  if [[ ! -f "$dst" ]]; then
    say "Creating $dst with marketplaces"
    run "jq -n --slurpfile mp '$src' '{extraKnownMarketplaces: \$mp[0]}' > '$dst'"
    return
  fi

  say "Merging marketplaces into $dst"
  local backup="$dst.backup-$(date +%Y%m%d-%H%M%S)"
  run "cp '$dst' '$backup'"
  verbose "backup at $backup"
  run "jq --slurpfile mp '$src' '.extraKnownMarketplaces = ((.extraKnownMarketplaces // {}) * \$mp[0])' '$dst' > '$dst.tmp' && mv '$dst.tmp' '$dst'"
}

# ---------- update CLAUDE.md ----------

update_claude_md() {
  local md="$CLAUDE_DIR/CLAUDE.md"
  local marker_start="<!-- claude-hub:start -->"
  local marker_end="<!-- claude-hub:end -->"
  local rules_dir="$CLAUDE_DIR/rules/common"

  # Build the block dynamically from whatever rule files are linked.
  if [[ ! -d "$rules_dir" ]]; then
    verbose "no rules linked — skipping CLAUDE.md update"
    return
  fi

  local block
  block="$marker_start
## Hub-managed rules

The following rule files are managed by [ClaudeHub]($HUB_REPO) and live at \`$HUB_DIR\`. Edit there, not here.
"
  local f
  for f in "$rules_dir"/*.md; do
    [[ -e "$f" ]] || continue
    block+="
- @rules/common/$(basename "$f")"
  done
  block+="

$marker_end"

  if [[ ! -f "$md" ]]; then
    say "Creating $md"
    if [[ "$DRY_RUN" == true ]]; then
      printf '[dry-run] write %s with claude-hub block\n' "$md"
    else
      printf '%s\n' "$block" > "$md"
    fi
    return
  fi

  # Strip any existing block first, then append fresh — uniform handling for
  # both "first run on existing CLAUDE.md" and "re-run" cases. Avoids awk's
  # inability to accept multi-line values via -v.
  if grep -qF "$marker_start" "$md"; then
    say "Refreshing claude-hub block in $md"
    if [[ "$DRY_RUN" == true ]]; then
      printf '[dry-run] replace claude-hub block in %s\n' "$md"
      return
    fi
    awk '
      index($0, "<!-- claude-hub:start -->") { skip = 1; next }
      index($0, "<!-- claude-hub:end -->")   { skip = 0; next }
      skip == 0 { print }
    ' "$md" > "$md.tmp" && mv "$md.tmp" "$md"
  else
    say "Appending claude-hub block to $md"
    if [[ "$DRY_RUN" == true ]]; then
      printf '[dry-run] append claude-hub block to %s\n' "$md"
      return
    fi
  fi

  printf '\n%s\n' "$block" >> "$md"
}

# ---------- uninstall ----------

uninstall() {
  say "Uninstalling claude-hub..."

  local removed=0
  for dir in skills agents rules/common; do
    local target="$CLAUDE_DIR/$dir"
    [[ ! -d "$target" ]] && continue
    for entry in "$target"/*; do
      if [[ -L "$entry" ]]; then
        local link_target
        link_target=$(readlink "$entry")
        case "$link_target" in
          "$HUB_DIR"/*)
            run "rm '$entry'"
            verbose "unlinked $entry"
            removed=$((removed + 1))
            ;;
        esac
      fi
    done
  done
  say "Removed $removed symlinks."

  local md="$CLAUDE_DIR/CLAUDE.md"
  if [[ -f "$md" ]] && grep -qF "<!-- claude-hub:start -->" "$md"; then
    say "Removing claude-hub block from $md"
    if [[ "$DRY_RUN" == true ]]; then
      printf '[dry-run] strip block from %s\n' "$md"
    else
      awk '
        index($0, "<!-- claude-hub:start -->") { skip = 1; next }
        index($0, "<!-- claude-hub:end -->")   { skip = 0; next }
        skip == 0 { print }
      ' "$md" > "$md.tmp" && mv "$md.tmp" "$md"
    fi
  fi

  say "Done. Hub repo at $HUB_DIR was preserved (rm -rf to remove)."
  say "Marketplace entries in settings.json were left in place — remove via /plugin marketplace remove if desired."
}

# ---------- main ----------

if [[ "$UNINSTALL" == true ]]; then
  uninstall
  exit 0
fi

preflight
bootstrap_repo

say "Linking content (mode: $MODE, force: $FORCE)..."
link_into "$HUB_DIR/skills" "$CLAUDE_DIR/skills"
link_into "$HUB_DIR/agents" "$CLAUDE_DIR/agents"
link_into "$HUB_DIR/rules/common" "$CLAUDE_DIR/rules/common"

merge_marketplaces
update_claude_md

say ""
say "Done."
say "  Hub:    $HUB_DIR"
say "  Mode:   $MODE"
if [[ -d "$CLAUDE_DIR/skills" ]]; then
  say "  Skills: $(ls -1 "$CLAUDE_DIR/skills" 2>/dev/null | wc -l | tr -d ' ')"
fi
say ""
say "Restart Claude Code to pick up new skills/agents."
say "Run '/plugin' inside Claude Code to install plugins from the registered marketplaces."
