#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TARGET_DIR"
}
trap cleanup EXIT

"$ROOT_DIR/bin/codex-agents" install --target "$TARGET_DIR" >/tmp/codex-agents-json-install.out

STATUS_JSON="$("$ROOT_DIR/bin/codex-agents" status --target "$TARGET_DIR" --json)"
DOCTOR_JSON="$("$ROOT_DIR/bin/codex-agents" doctor --target "$TARGET_DIR" --json)"
VERSION_OUTPUT="$("$ROOT_DIR/bin/codex-agents" version)"

STATUS_JSON="$STATUS_JSON" DOCTOR_JSON="$DOCTOR_JSON" VERSION_OUTPUT="$VERSION_OUTPUT" python3 - <<'PY'
import json
import os
import re

status = json.loads(os.environ["STATUS_JSON"])
doctor = json.loads(os.environ["DOCTOR_JSON"])
version = os.environ["VERSION_OUTPUT"].strip()

assert status["agents_dir"] == "present"
assert status["orchestrator_routing_skill"] == "present"
assert status["managed_entrypoint"] == "present"

assert doctor["checks"]["orchestrator_routing_skill"]["present"] is True
assert doctor["checks"]["managed_entrypoint"]["present"] is True
assert doctor["failures"] == 0
assert isinstance(doctor["findings"], list) and doctor["findings"]
assert isinstance(doctor["next_actions"], list) and doctor["next_actions"]

assert re.fullmatch(r"[0-9a-f]{7,}", version), version
PY
