#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TMP_HOME="$(mktemp -d)"
trap 'rm -rf "${TMP_HOME}"' EXIT

HOME="${TMP_HOME}" "${REPO_ROOT}/bin/codex-agents" install >/dev/null
HOME="${TMP_HOME}" "${REPO_ROOT}/bin/codex-agents" install >/dev/null

SKILL_FILE="${TMP_HOME}/.codex/skills/orchestrator-routing/SKILL.md"
AGENTS_FILE="${TMP_HOME}/.codex/AGENTS.md"

if [[ ! -f "${SKILL_FILE}" ]]; then
  echo "Expected orchestrator-routing skill to be installed at ${SKILL_FILE}"
  exit 1
fi

if ! grep -q "^name: orchestrator-routing$" "${SKILL_FILE}"; then
  echo "Expected installed skill metadata to include orchestrator-routing"
  exit 1
fi

if ! grep -q "orchestrator-routing" "${AGENTS_FILE}"; then
  echo "Expected managed AGENTS block to reference orchestrator-routing"
  exit 1
fi

if [[ "$(grep -c "BEGIN CODEX-AGENTS MANAGED ENTRYPOINT" "${AGENTS_FILE}")" -ne 1 ]]; then
  echo "Expected managed entrypoint block to remain idempotent"
  exit 1
fi

echo "Orchestrator routing skill installed successfully."
