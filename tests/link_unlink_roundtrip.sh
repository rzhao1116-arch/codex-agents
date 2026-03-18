#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$BIN_DIR"
}
trap cleanup EXIT

"$ROOT_DIR/bin/codex-agents" link --bin-dir "$BIN_DIR" >/tmp/codex-agents-link.out

test -L "$BIN_DIR/codex-agents"
TARGET="$(readlink "$BIN_DIR/codex-agents")"
test "$TARGET" = "$ROOT_DIR/bin/codex-agents"

"$ROOT_DIR/bin/codex-agents" unlink --bin-dir "$BIN_DIR" >/tmp/codex-agents-unlink.out

test ! -e "$BIN_DIR/codex-agents"
