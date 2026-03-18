#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TMP_HOME="$(mktemp -d)"
trap 'rm -rf "${TMP_HOME}"' EXIT

HOME="${TMP_HOME}" "${REPO_ROOT}/bin/codex-agents" install >/dev/null
HOME="${TMP_HOME}" "${REPO_ROOT}/bin/codex-agents" uninstall >/dev/null

if [[ -f "${TMP_HOME}/.codex/agents/orchestrator.md" ]]; then
  echo "Expected orchestrator agent to be removed during uninstall"
  exit 1
fi

if [[ -f "${TMP_HOME}/.codex/skills/orchestrator-routing/SKILL.md" ]]; then
  echo "Expected orchestrator-routing skill to be removed during uninstall"
  exit 1
fi

if grep -q "BEGIN CODEX-AGENTS MANAGED ENTRYPOINT" "${TMP_HOME}/.codex/AGENTS.md"; then
  echo "Expected managed entrypoint block to be removed during uninstall"
  exit 1
fi

echo "Uninstall removed managed bundle successfully."

