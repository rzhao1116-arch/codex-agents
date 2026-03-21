#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FORMULA_FILE="$ROOT_DIR/Formula/codex-agents.rb"
TARBALL_URL="https://github.com/rzhao1116-arch/codex-agents/archive/refs/tags/v0.1.3.tar.gz"
TMP_TARBALL="$(mktemp)"

cleanup() {
  rm -f "$TMP_TARBALL"
}
trap cleanup EXIT

grep -q 'class CodexAgents < Formula' "$FORMULA_FILE"
grep -q 'url "https://github.com/rzhao1116-arch/codex-agents/archive/refs/tags/v0.1.3.tar.gz"' "$FORMULA_FILE"
grep -q 'license "MIT"' "$FORMULA_FILE"
grep -q 'depends_on "python@3.13"' "$FORMULA_FILE"
grep -q 'bin.write_exec_script libexec/"bin/codex-agents"' "$FORMULA_FILE"

curl -L "$TARBALL_URL" -o "$TMP_TARBALL" >/dev/null 2>&1
EXPECTED_SHA="$(shasum -a 256 "$TMP_TARBALL" | awk '{print $1}')"
ACTUAL_SHA="$(ruby -e 'puts File.read(ARGV[0])[/sha256 \"([0-9a-f]+)\"/, 1]' "$FORMULA_FILE")"

test "$EXPECTED_SHA" = "$ACTUAL_SHA"
