#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TAP_NAME="codexagentslocal/codex-agents-audit-$$"
TAP_DIR="$(brew --repository)/Library/Taps/codexagentslocal/homebrew-codex-agents-audit-$$"

cleanup() {
  brew untap "$TAP_NAME" >/dev/null 2>&1 || true
  rm -rf "$TAP_DIR"
}
trap cleanup EXIT

brew tap-new --no-git "$TAP_NAME" >/dev/null
mkdir -p "$TAP_DIR/Formula"
cp "$ROOT_DIR/Formula/codex-agents.rb" "$TAP_DIR/Formula/codex-agents.rb"

brew audit --strict --new "$TAP_NAME/codex-agents"
