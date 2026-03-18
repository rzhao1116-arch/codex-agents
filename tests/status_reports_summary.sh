#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TMP_HOME="$(mktemp -d)"
trap 'rm -rf "${TMP_HOME}"' EXIT

HOME="${TMP_HOME}" "${REPO_ROOT}/bin/codex-agents" install >/dev/null

OUTPUT="$(HOME="${TMP_HOME}" "${REPO_ROOT}/bin/codex-agents" status)"

echo "${OUTPUT}" | grep -q "^codex-agents status$" || {
  echo "Expected status header"
  exit 1
}

echo "${OUTPUT}" | grep -q "^agents_dir=present$" || {
  echo "Expected agents_dir to be present"
  exit 1
}

echo "${OUTPUT}" | grep -q "^orchestrator_routing_skill=present$" || {
  echo "Expected orchestrator-routing skill to be present"
  exit 1
}

echo "${OUTPUT}" | grep -q "^managed_entrypoint=present$" || {
  echo "Expected managed entrypoint to be present"
  exit 1
}

echo "Status summary reports installed bundle successfully."
