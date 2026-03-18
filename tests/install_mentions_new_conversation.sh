#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TMP_HOME="$(mktemp -d)"
trap 'rm -rf "${TMP_HOME}"' EXIT

OUTPUT="$(HOME="${TMP_HOME}" "${REPO_ROOT}/bin/codex-agents" install)"

echo "${OUTPUT}" | grep -q "Open a new Codex conversation" || {
  echo "Expected install output to mention opening a new conversation"
  exit 1
}

echo "${OUTPUT}" | grep -q "restart the Codex app" || {
  echo "Expected install output to mention restarting the app as fallback"
  exit 1
}

echo "Install output includes conversation refresh guidance."
