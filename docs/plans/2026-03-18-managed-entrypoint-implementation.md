# Managed Entrypoint Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `codex-agents install/update` manage a small tool-owned entrypoint block in `~/.codex/AGENTS.md` so installed users automatically get the orchestrator-first behavior without manually editing rules.

**Architecture:** Keep the runtime simple and file-based. The shell installer will continue copying agent files into `~/.codex/agents/`, and will additionally upsert a clearly marked block in `~/.codex/AGENTS.md`. A minimal shell test will validate install behavior using a temporary `HOME`.

**Tech Stack:** Bash, Markdown

---

### Task 1: Add a failing install test

**Files:**
- Create: `tests/install_managed_entrypoint.sh`

- [ ] **Step 1: Write the failing test**
- [ ] **Step 2: Run it and verify it fails because no managed entrypoint block is written yet**

### Task 2: Implement managed AGENTS upsert

**Files:**
- Modify: `bin/codex-agents`

- [ ] **Step 1: Add marker constants and managed block content**
- [ ] **Step 2: Add helper to create or replace the managed block in `~/.codex/AGENTS.md`**
- [ ] **Step 3: Call that helper from `install` and `update`**
- [ ] **Step 4: Keep behavior idempotent so repeated installs do not duplicate the block**

### Task 3: Update docs and tool ledger

**Files:**
- Modify: `README.md`
- Modify: `docs/specs/2026-03-18-codex-agents-v1-spec.md`
- Modify: `/Users/ryan/Projects/Ai/other/docs/global-command-conventions.md`

- [ ] **Step 1: Document the managed entrypoint behavior**
- [ ] **Step 2: Update the spec to reflect managed `AGENTS.md` integration**
- [ ] **Step 3: Add `codex-agents` to the global command ledger**

### Task 4: Verify and commit

**Files:**
- Modify: `tests/install_managed_entrypoint.sh`
- Modify: `bin/codex-agents`
- Modify: `README.md`
- Modify: `docs/specs/2026-03-18-codex-agents-v1-spec.md`
- Modify: `/Users/ryan/Projects/Ai/other/docs/global-command-conventions.md`

- [ ] **Step 1: Run the install test and ensure it passes**
- [ ] **Step 2: Run `bin/codex-agents list`**
- [ ] **Step 3: Run `git diff --check`**
- [ ] **Step 4: Commit**
