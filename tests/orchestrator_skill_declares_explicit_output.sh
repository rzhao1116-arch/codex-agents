#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_FILE="$ROOT_DIR/skills/orchestrator-routing/SKILL.md"

grep -q '## Required Output Shape' "$SKILL_FILE"
grep -q '`complexity`' "$SKILL_FILE"
grep -q '`role-chain`' "$SKILL_FILE"
grep -q '`next-step`' "$SKILL_FILE"
grep -q '`reason`' "$SKILL_FILE"
