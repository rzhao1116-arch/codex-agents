#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TARGET_DIR"
}
trap cleanup EXIT

"$ROOT_DIR/bin/codex-agents" install --target "$TARGET_DIR" >/tmp/codex-agents-target-install.out

test -f "$TARGET_DIR/agents/orchestrator.md"
test -f "$TARGET_DIR/skills/orchestrator-routing/SKILL.md"
grep -q 'BEGIN CODEX-AGENTS MANAGED ENTRYPOINT' "$TARGET_DIR/AGENTS.md"

STATUS_OUTPUT="$("$ROOT_DIR/bin/codex-agents" status --target "$TARGET_DIR")"
echo "$STATUS_OUTPUT" | grep -q 'agents_dir=present'
echo "$STATUS_OUTPUT" | grep -q 'orchestrator_routing_skill=present'
echo "$STATUS_OUTPUT" | grep -q 'managed_entrypoint=present'

"$ROOT_DIR/bin/codex-agents" uninstall --target "$TARGET_DIR" >/tmp/codex-agents-target-uninstall.out

test ! -e "$TARGET_DIR/agents/orchestrator.md"
test ! -e "$TARGET_DIR/skills/orchestrator-routing"
if grep -q 'BEGIN CODEX-AGENTS MANAGED ENTRYPOINT' "$TARGET_DIR/AGENTS.md"; then
  exit 1
fi
