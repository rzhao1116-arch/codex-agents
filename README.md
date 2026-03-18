# codex-agents

Claude-style Codex agents plus a default-entrypoint orchestrator that automatically prunes the smallest useful role chain for a task.

## What This Repo Provides

- A set of Codex agent baseline files in [`agents/`](/Users/ryan/Projects/Ai/other/codex-agents/agents)
- A top-level [`orchestrator.md`](/Users/ryan/Projects/Ai/other/codex-agents/agents/orchestrator.md) that acts as the default entrypoint for non-trivial work
- A simple installer CLI in [`bin/codex-agents`](/Users/ryan/Projects/Ai/other/codex-agents/bin/codex-agents)
- A tool-managed entrypoint block in `~/.codex/AGENTS.md` so installed users automatically get orchestrator-first routing behavior
- A Claude-style `~/.codex/agents/` installation model that keeps the first version easy to understand and easy to update

## Included Agents

- `orchestrator`
- `product-manager`
- `ux-architect`
- `ui-designer`
- `frontend-developer`
- `backend-architect`
- `software-architect`
- `docs-researcher`
- `code-reviewer`
- `reality-checker`
- `technical-writer`

## Install

From this repository:

```bash
bin/codex-agents install
```

This copies all bundled agent files into:

```bash
~/.codex/agents/
```

It also writes or updates a tool-managed block in:

```bash
~/.codex/AGENTS.md
```

That block tells Codex to prefer `orchestrator` as the default entrypoint for non-trivial multi-phase work.

The first install creates these files:

- `orchestrator.md`
- `product-manager.md`
- `ux-architect.md`
- `ui-designer.md`
- `frontend-developer.md`
- `backend-architect.md`
- `software-architect.md`
- `docs-researcher.md`
- `code-reviewer.md`
- `reality-checker.md`
- `technical-writer.md`

## Update

```bash
bin/codex-agents update
```

## List Bundled Agents

```bash
bin/codex-agents list
```

## How To Use

- Treat these agent files as a lightweight role system for Codex.
- After install, the managed `AGENTS.md` block makes non-trivial multi-phase work prefer `orchestrator` first.
- Let `orchestrator` classify the task as `simple`, `multi-step`, or `complex`.
- Let `orchestrator` prune the smallest useful role chain instead of defaulting to the full role set.
- Allow `orchestrator` to stop early, downgrade, upgrade, or reroute when the initial chain is wrong.
- Keep stronger local global rules and repository-local rules above these generic baselines.

## Practical Usage Pattern

Use the installed role files as a lightweight default-entrypoint orchestration system:

1. Present the task normally.
2. Let the managed entrypoint rule route non-trivial work into `orchestrator`.
3. Let `orchestrator` classify it as `simple`, `multi-step`, or `complex`.
4. Let `orchestrator` choose the smallest useful role chain.
5. Let that chain continue only while each next role is still justified.
6. End early when the task is already resolved, or reroute when the current path breaks.

Typical routes:

- ambiguous request -> `product-manager -> ...`
- flow/interaction problem -> `ux-architect -> frontend-developer -> reality-checker`
- architecture-heavy backend change -> `software-architect -> backend-architect -> code-reviewer -> reality-checker`
- official docs / SDK / MCP / platform question -> `docs-researcher`, then stop early if that already resolves the task
- delivery-bound implementation -> implementer role -> `code-reviewer -> reality-checker`

## Release Model

- `install` is for first-time setup into `~/.codex/agents/`
- `update` is for overwriting installed agent files with the current repo version
- `list` is for checking the bundled role set before install or update

## Publishing / Sharing

This repository is designed to be cloned and then installed locally:

```bash
git clone https://github.com/rzhao1116-arch/codex-agents.git
cd codex-agents
bin/codex-agents install
```

## Design Notes

- This repo intentionally installs directly into `~/.codex/agents/`, similar to the way Claude-style agent directories are commonly organized.
- The first version does not modify user `config.toml`.
- The first version does manage a clearly marked entrypoint block in `~/.codex/AGENTS.md` because current Codex behavior does not expose a built-in default-agent hook through `agents/` alone.
- The main feature is the default-entrypoint behavior of `orchestrator`, not just the presence of many role files.
- The first version aims for automatic chain pruning and automatic continuation through the smallest useful role sequence.
- The first version still does not promise perfect routing, hidden Codex hooks, or a flawless autonomous execution engine.
