# codex-agents

Claude-style role baselines and a lightweight orchestrator installer for Codex.

## What This Repo Provides

- A set of Codex agent baseline files in [`agents/`](/Users/ryan/Projects/Ai/other/codex-agents/agents)
- A top-level [`orchestrator.md`](/Users/ryan/Projects/Ai/other/codex-agents/agents/orchestrator.md) that routes work to the most relevant specialist
- A simple installer CLI in [`bin/codex-agents`](/Users/ryan/Projects/Ai/other/codex-agents/bin/codex-agents)

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

## Update

```bash
bin/codex-agents update
```

## List Bundled Agents

```bash
bin/codex-agents list
```

## How To Use

- Treat these agent files as broad baseline role guidance for Codex subagent-style workflows.
- Use the orchestrator to decide which specialist best fits the current phase of work.
- Keep local global rules and repository-local rules stronger than these generic baselines.
- After specialist output returns, the main line should still integrate the result, verify it, and decide whether the work actually meets the acceptance bar.

## Design Notes

- This repo intentionally installs directly into `~/.codex/agents/`, similar to the way Claude-style agent directories are commonly organized.
- The first version does not modify user `AGENTS.md` files or `config.toml`.
- The first version does not try to auto-route every task. Instead, it provides a clean role set plus an orchestrator baseline.
