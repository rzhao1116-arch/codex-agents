#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TMP_HOME="$(mktemp -d)"
trap 'rm -rf "${TMP_HOME}"' EXIT

AGENTS_FILE="${TMP_HOME}/.codex/AGENTS.md"
mkdir -p "${TMP_HOME}/.codex"
cat > "${AGENTS_FILE}" <<'EOF'
# Existing Global Rules

- keep this content
EOF

HOME="${TMP_HOME}" "${REPO_ROOT}/bin/codex-agents" install >/dev/null
HOME="${TMP_HOME}" "${REPO_ROOT}/bin/codex-agents" install >/dev/null

if [[ ! -f "${AGENTS_FILE}" ]]; then
  echo "Expected managed AGENTS file to be created at ${AGENTS_FILE}"
  exit 1
fi

if ! grep -q "keep this content" "${AGENTS_FILE}"; then
  echo "Expected existing AGENTS content to be preserved"
  exit 1
fi

if ! grep -q "BEGIN CODEX-AGENTS MANAGED ENTRYPOINT" "${AGENTS_FILE}"; then
  echo "Expected managed entrypoint block to be written into ${AGENTS_FILE}"
  exit 1
fi

if [[ "$(grep -c "BEGIN CODEX-AGENTS MANAGED ENTRYPOINT" "${AGENTS_FILE}")" -ne 1 ]]; then
  echo "Expected managed entrypoint block to be idempotent"
  exit 1
fi

echo "Managed entrypoint block installed successfully."
