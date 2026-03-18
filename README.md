# codex-agents

Claude-style Codex agents plus an installed orchestrator-routing skill that makes `orchestrator` the default routing lens for non-trivial work.

## What This Repo Provides

- A set of Codex agent baseline files in [`agents/`](/Users/ryan/Projects/Ai/other/codex-agents/agents)
- A baseline orchestration role in [`agents/orchestrator.md`](/Users/ryan/Projects/Ai/other/codex-agents/agents/orchestrator.md)
- An installable routing skill in [`skills/orchestrator-routing/SKILL.md`](/Users/ryan/Projects/Ai/other/codex-agents/skills/orchestrator-routing/SKILL.md)
- A simple installer CLI in [`bin/codex-agents`](/Users/ryan/Projects/Ai/other/codex-agents/bin/codex-agents)
- A tool-managed entrypoint block in `~/.codex/AGENTS.md` so installed users automatically get orchestrator-first routing behavior
- A `doctor` command that explains whether the bundle is installed correctly and why a current conversation may still not see the skill

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

## Included Skills

- `orchestrator-routing`

## Install

From this repository:

```bash
bin/codex-agents install
```

This installs bundled files into:

```bash
~/.codex/agents/
~/.codex/skills/
```

It also writes or updates a tool-managed block in:

```bash
~/.codex/AGENTS.md
```

That block tells Codex to prefer the installed `orchestrator-routing` skill for non-trivial multi-phase work. The skill then routes into `orchestrator` and downstream skills.

The first install creates these agent files:

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

And these skills:

- `orchestrator-routing`

## Update

```bash
bin/codex-agents update
```

Both `install` and `update` now remind the user to open a new Codex conversation so the refreshed skill list is picked up.

## Doctor

```bash
bin/codex-agents doctor
```

Use `doctor` to check:

- whether bundled agents were installed
- whether `orchestrator-routing` is installed in `~/.codex/skills/`
- whether the managed `AGENTS.md` block is present and up to date
- whether the most likely issue is simply that the current conversation needs a fresh skill index

## Uninstall

```bash
bin/codex-agents uninstall
```

`uninstall` removes only the bundle managed by this repo:

- bundled agent files from `~/.codex/agents/`
- bundled skill directories from `~/.codex/skills/`
- the managed entrypoint block in `~/.codex/AGENTS.md`

It does **not** remove unrelated global skills or unrelated content from `AGENTS.md`.

## List Bundled Files

```bash
bin/codex-agents list
```

## How To Use

- Treat the installed files as a lightweight role-and-routing system for Codex.
- After install, the managed `AGENTS.md` block makes non-trivial multi-phase work prefer the `orchestrator-routing` skill first.
- Let `orchestrator-routing` classify the task as `simple`, `multi-step`, or `complex`.
- Let `orchestrator-routing` prune the smallest useful role chain instead of defaulting to the full role set.
- Let `orchestrator-routing` decide whether the next phase should enter `brainstorming`, `writing-plans`, implementation skills, or stop early.
- Keep `orchestrator.md` as the baseline role definition behind that routing behavior.
- Keep stronger local global rules and repository-local rules above these generic baselines.

## Practical Usage Pattern

Use the installed bundle as a lightweight default-entrypoint orchestration system:

1. Present the task normally.
2. Let the managed entrypoint rule route non-trivial work into `orchestrator-routing`.
3. Let `orchestrator-routing` classify it as `simple`, `multi-step`, or `complex`.
4. Let `orchestrator-routing` choose the smallest useful role chain and next downstream skill.
5. Let that chain continue only while each next role is still justified.
6. End early when the task is already resolved, or reroute when the current path breaks.

Typical routes:

- ambiguous request -> `orchestrator-routing -> product-manager -> ...`
- flow/interaction problem -> `orchestrator-routing -> ux-architect -> frontend-developer -> reality-checker`
- architecture-heavy backend change -> `orchestrator-routing -> software-architect -> backend-architect -> code-reviewer -> reality-checker`
- official docs / SDK / MCP / platform question -> `orchestrator-routing -> docs-researcher`, then stop early if that already resolves the task
- new feature requiring design -> `orchestrator-routing -> brainstorming -> implementation chain`

## Release Model

- `install` is for first-time setup into `~/.codex`
- `update` overwrites installed agent files, skills, and the managed entrypoint block with the current repo version
- `uninstall` removes only the bundle managed by this repository
- `doctor` checks installed state and explains common “installed but not visible in current conversation” situations
- `list` shows the bundled agents and skills before install or update

## Publishing / Sharing

This repository is designed to be cloned and then installed locally:

```bash
git clone https://github.com/rzhao1116-arch/codex-agents.git
cd codex-agents
bin/codex-agents install
```

## Design Notes

- This repo intentionally installs directly into `~/.codex/agents/` and `~/.codex/skills/`, similar to the way Claude-style agent directories are commonly organized.
- The first version does not modify user `config.toml`.
- The first version does manage a clearly marked entrypoint block in `~/.codex/AGENTS.md` because current Codex behavior does not expose a built-in default-agent hook through `agents/` alone.
- The first version also installs an explicit `orchestrator-routing` skill so the routing behavior participates in skill-first workflows instead of losing priority to existing skills.
- The main feature is the default-entrypoint behavior of `orchestrator-routing` plus `orchestrator`, not just the presence of many role files.
- The first version aims for automatic chain pruning and automatic continuation through the smallest useful role sequence.
- The first version still does not promise perfect routing, hidden Codex hooks, or a flawless autonomous execution engine.
