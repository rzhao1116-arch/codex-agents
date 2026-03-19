#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PYTHON_BIN="${PYTHON_BIN:-python3}"

if command -v python3.13 >/dev/null 2>&1; then
  PYTHON_BIN="python3.13"
fi

ROOT_DIR="$ROOT_DIR" "$PYTHON_BIN" - <<'PY'
import os
from pathlib import Path
import tomllib

root = Path(os.environ["ROOT_DIR"])
agents_dir = root / "agents"
agent_files = sorted(agents_dir.glob("*.toml"))

assert agent_files, "Expected bundled .toml agents"

required = {
    "name": str,
    "description": str,
    "model": str,
    "model_reasoning_effort": str,
    "sandbox_mode": str,
    "developer_instructions": str,
}

for path in agent_files:
    data = tomllib.loads(path.read_text())
    for key, expected_type in required.items():
        assert key in data, f"{path.name} missing {key}"
        assert isinstance(data[key], expected_type), f"{path.name} field {key} has wrong type"
        assert data[key].strip(), f"{path.name} field {key} is empty"

    assert data["name"] == path.stem, f"{path.name} name should match filename"
    assert data["sandbox_mode"] in {"read-only", "workspace-write"}, f"{path.name} invalid sandbox_mode"
    assert data["model_reasoning_effort"] in {"low", "medium", "high"}, f"{path.name} invalid reasoning effort"
PY

echo "Bundled agents are valid Codex TOML files."
