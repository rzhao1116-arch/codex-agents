# Auto Orchestrator Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Upgrade `codex-agents` so `orchestrator` is positioned as the default entrypoint and describes automatic complexity-based orchestration instead of only static routing guidance.

**Architecture:** Keep the implementation lightweight and file-driven. The main behavior lives in `agents/orchestrator.md`, while `README.md` explains the default-entrypoint model and how users should rely on it after installation.

**Tech Stack:** Markdown documentation, shell installer

---

## Chunk 1: Plan the content shift

### Task 1: Update the orchestrator role contract

**Files:**
- Modify: `agents/orchestrator.md`

- [ ] **Step 1: Rewrite the role description**

Update the frontmatter description so it frames `orchestrator` as the default orchestration entrypoint, not only a top-level router.

- [ ] **Step 2: Replace phase-only routing with complexity-first logic**

Add sections for:
- complexity classification (`simple`, `multi-step`, `complex`)
- role selection heuristics
- priority ordering
- automatic chaining behavior
- downgrade / upgrade / reroute / stop rules

- [ ] **Step 3: Add concrete examples**

Document representative flows, including:
- an ambiguous feature
- an SDK or MCP integration question
- an architecture-heavy backend change
- a realtime Codex quota monitoring page

- [ ] **Step 4: Verify the file reads as a default entrypoint**

Read the full file and ensure a new user would understand:
- start from `orchestrator`
- `orchestrator` decides complexity
- `orchestrator` prunes the chain
- `orchestrator` can continue automatically but still respects stronger local rules

### Task 2: Reposition the README around the new default behavior

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Update repo positioning**

Change the README intro and feature bullets so the repo is described as installing a default-entrypoint orchestrator, not only a role bundle.

- [ ] **Step 2: Rewrite usage guidance**

Replace the manual “start with orchestrator to decide the phase” framing with the new model:
- `orchestrator` is the default entrypoint
- it classifies complexity
- it chooses the smallest useful role chain
- it may stop early or reroute

- [ ] **Step 3: Align practical examples with the new model**

Update examples so they show automatic chain pruning instead of a static phase list.

- [ ] **Step 4: Update design notes**

Make the version boundary explicit:
- v1 installs a role bundle
- the main feature is the default-entrypoint orchestrator behavior
- this is still not a guaranteed perfect autonomous engine

## Chunk 2: Validate and prepare for review

### Task 3: Sanity check the docs

**Files:**
- Modify: `agents/orchestrator.md`
- Modify: `README.md`

- [ ] **Step 1: Read both files together**

Confirm they are consistent on:
- what the orchestrator does
- whether it is default
- whether it is automatic
- what remains under local rule control

- [ ] **Step 2: Check for scope drift**

Ensure the docs do not promise:
- guaranteed perfect routing
- hidden Codex hooks
- automatic modification of user config

- [ ] **Step 3: Commit the implementation branch**

Run:

```bash
git add agents/orchestrator.md README.md docs/plans/2026-03-18-auto-orchestrator-implementation.md
git commit -m "Implement automatic orchestrator entrypoint docs"
```
