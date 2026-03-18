#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TMP_HOME="$(mktemp -d)"
trap 'rm -rf "${TMP_HOME}"' EXIT

HOME="${TMP_HOME}" "${REPO_ROOT}/bin/codex-agents" install >/dev/null

OUTPUT="$(HOME="${TMP_HOME}" "${REPO_ROOT}/bin/codex-agents" doctor)"

echo "${OUTPUT}" | grep -q "^Checks$" || {
  echo "Expected doctor output to include Checks section"
  exit 1
}

echo "${OUTPUT}" | grep -q "OK    orchestrator-routing skill" || {
  echo "Expected doctor output to confirm orchestrator-routing skill is installed"
  exit 1
}

echo "${OUTPUT}" | grep -q "The orchestrator-routing skill is installed on disk." || {
  echo "Expected doctor findings to explain installed skill state"
  exit 1
}

echo "${OUTPUT}" | grep -q "Open a new Codex conversation after install/update" || {
  echo "Expected doctor next actions to mention opening a new conversation"
  exit 1
}

echo "Doctor reports installed state successfully."
