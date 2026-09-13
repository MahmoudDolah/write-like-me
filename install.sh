#!/usr/bin/env bash
# Installs (or uninstalls) this plugin as a Claude Code "skills-dir" plugin,
# so it auto-loads every session as write-like-me@skills-dir with no
# marketplace registration required.
#
# Default mode symlinks this repo into ~/.claude/skills/write-like-me, so
# edits you make here take effect on the next `/reload-plugins` or session
# restart -- no reinstall/version-bump step needed. Use --copy instead if you
# don't want a symlink (e.g. syncing a repo you don't want live-linked).
set -euo pipefail

PLUGIN_NAME="write-like-me"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.claude/skills/$PLUGIN_NAME"

MODE="symlink"
ACTION="install"
FORCE=0

usage() {
  cat <<EOF
Usage: $(basename "$0") [--uninstall] [--copy] [--force]

  (default)     Symlink this plugin into ~/.claude/skills/$PLUGIN_NAME
  --copy        Copy instead of symlinking (edits won't take effect until
                you re-run this script)
  --uninstall   Remove the installed plugin (symlink or prior copy)
  --force       Replace whatever is currently at the target path
  -h, --help    Show this help
EOF
}

for arg in "$@"; do
  case "$arg" in
    --uninstall) ACTION="uninstall" ;;
    --copy) MODE="copy" ;;
    --force) FORCE=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; usage >&2; exit 1 ;;
  esac
done

if ! command -v claude >/dev/null 2>&1; then
  echo "error: 'claude' CLI not found on PATH. Install Claude Code first." >&2
  exit 1
fi

if [[ "$ACTION" == "uninstall" ]]; then
  if [[ -L "$TARGET_DIR" ]]; then
    link_target="$(readlink "$TARGET_DIR")"
    if [[ "$link_target" == "$SCRIPT_DIR" ]]; then
      rm "$TARGET_DIR"
      echo "Removed symlink $TARGET_DIR"
    else
      echo "error: $TARGET_DIR is a symlink to '$link_target', not this repo ($SCRIPT_DIR)." >&2
      echo "Not touching it automatically -- remove it yourself if that's intended." >&2
      exit 1
    fi
  elif [[ -d "$TARGET_DIR" ]]; then
    if [[ -f "$TARGET_DIR/.claude-plugin/plugin.json" ]] && grep -q "\"name\": *\"$PLUGIN_NAME\"" "$TARGET_DIR/.claude-plugin/plugin.json"; then
      rm -rf "$TARGET_DIR"
      echo "Removed copied plugin directory $TARGET_DIR"
    else
      echo "error: $TARGET_DIR exists but doesn't look like a copy of this plugin. Not removing it." >&2
      exit 1
    fi
  else
    echo "Nothing installed at $TARGET_DIR."
  fi
  exit 0
fi

echo "Validating plugin at $SCRIPT_DIR ..."
if ! claude plugin validate "$SCRIPT_DIR"; then
  echo "error: plugin validation failed -- fix the issues above before installing." >&2
  exit 1
fi

if [[ -e "$TARGET_DIR" || -L "$TARGET_DIR" ]]; then
  if [[ -L "$TARGET_DIR" && "$(readlink "$TARGET_DIR")" == "$SCRIPT_DIR" ]]; then
    echo "Already symlinked: $TARGET_DIR -> $SCRIPT_DIR. Nothing to do."
    exit 0
  fi
  if [[ "$FORCE" -eq 1 ]]; then
    rm -rf "$TARGET_DIR"
  else
    echo "error: $TARGET_DIR already exists and isn't a symlink to this repo." >&2
    echo "Re-run with --force to replace it, or remove it yourself first." >&2
    exit 1
  fi
fi

mkdir -p "$HOME/.claude/skills"

if [[ "$MODE" == "symlink" ]]; then
  ln -s "$SCRIPT_DIR" "$TARGET_DIR"
  echo "Symlinked $TARGET_DIR -> $SCRIPT_DIR"
else
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --exclude='.git' "$SCRIPT_DIR"/ "$TARGET_DIR"/
  else
    cp -r "$SCRIPT_DIR" "$TARGET_DIR"
    rm -rf "$TARGET_DIR/.git"
  fi
  echo "Copied plugin to $TARGET_DIR (edits here won't apply until you re-run this script)"
fi

cat <<EOF

Installed as ${PLUGIN_NAME}@skills-dir.

Next steps:
  - In an already-running Claude Code session: run /reload-plugins
  - Or just start a new session -- it auto-loads.
  - Try: /voice-profile, /voice-calibrate, or ask Claude to draft a Slack
    message and see whether the compose-in-voice skill kicks in.

Troubleshooting:
  - claude plugin list                      # confirm it shows up, enabled
  - claude plugin disable ${PLUGIN_NAME}@skills-dir   # turn it off without removing
  - ./install.sh --uninstall                # remove it
EOF
