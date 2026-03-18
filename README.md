# codex-agents

Claude-style role baselines and a lightweight orchestrator installer for Codex.

## What This Repo Provides

- A set of Codex agent baseline files in [`agents/`](/Users/ryan/Projects/Ai/other/codex-agents/agents)
- A top-level [`orchestrator.md`](/Users/ryan/Projects/Ai/other/codex-agents/agents/orchestrator.md) that routes work to the most relevant specialist
- A simple installer CLI in [`bin/codex-agents`](/Users/ryan/Projects/Ai/other/codex-agents/bin/codex-agents)
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

- Treat these agent files as broad baseline role guidance for Codex subagent-style workflows.
- Use the orchestrator to decide which specialist best fits the current phase of work.
- Keep local global rules and repository-local rules stronger than these generic baselines.
- After specialist output returns, the main line should still integrate the result, verify it, and decide whether the work actually meets the acceptance bar.

## Practical Usage Pattern

Use the installed role files as a lightweight multi-agent system:

1. Start with `orchestrator` to decide the current phase.
2. Route to the smallest useful specialist.
3. Bring the result back to the main line.
4. Review and verify before calling the work complete.

Typical routes:

- ambiguous request -> `product-manager`
- flow/interaction problem -> `ux-architect`
- visual/UI clarity problem -> `ui-designer`
- frontend implementation -> `frontend-developer`
- backend/API/data problem -> `backend-architect`
- architecture trade-off -> `software-architect`
- official docs / SDK / MCP / platform question -> `docs-researcher`
- post-implementation risk review -> `code-reviewer`
- pre-delivery reality check -> `reality-checker`
- docs / handoff / release notes -> `technical-writer`

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
- The first version does not modify user `AGENTS.md` files or `config.toml`.
- The first version does not try to auto-route every task. Instead, it provides a clean role set plus an orchestrator baseline.
