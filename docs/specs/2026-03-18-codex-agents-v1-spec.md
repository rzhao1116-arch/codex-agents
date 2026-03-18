# codex-agents v1 Spec

## Status

Prototype already implemented; this spec defines the intended v1 scope, boundaries, and acceptance criteria so the project can continue under an explicit development flow.

## Product Goal

Provide a simple public CLI tool that installs a Claude-style set of role baselines plus an orchestrator into `~/.codex/agents/`, so Codex users can adopt a lightweight role-driven workflow without hand-copying agent files.

## Problem

Codex supports subagents, but users do not get a ready-made role set or a clear Claude-style `agents/` installation workflow by default. That makes role-driven delegation harder to adopt consistently and share with others.

## Target User

- Codex users who want a Claude-style `agents/` directory
- users who want a reusable role baseline without building their own role library from scratch
- users who prefer simple install/update mechanics over complex framework setup

## v1 Scope

### Included

- a repository-local `agents/` directory with bundled role files
- a bundled `orchestrator.md` that routes work by task phase
- bundled specialist role files:
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
- a CLI with:
  - `install`
  - `update`
  - `list`
- installation target:
  - `~/.codex/agents/`
- public GitHub repository distribution

### Not Included

- automatic modification of user `AGENTS.md`
- automatic modification of user `config.toml`
- dynamic agent generation
- automatic task execution or full autonomous workflow control
- complex multi-source vendor syncing
- role permission sandboxing beyond what Codex already provides

## Architecture

### Repository Layout

```text
codex-agents/
  agents/
  bin/
  docs/specs/
  README.md
```

### Runtime Model

- `agents/` is the source-of-truth role bundle
- `bin/codex-agents` copies those files into `~/.codex/agents/`
- `orchestrator.md` provides routing guidance but does not replace main-line judgment
- local user rules and project rules remain stronger than the bundled baselines

## CLI Behavior

### `install`

- create `~/.codex/agents/` if missing
- copy all bundled `.md` files into the target directory
- print the installed role list

### `update`

- overwrite previously installed role files from the current repo contents
- print the bundled role list

### `list`

- print the bundled role filenames without installing

## Orchestrator Responsibilities

- detect the current task phase
- route to the smallest useful specialist
- avoid overlapping delegation
- keep final integration, verification, and acceptance on the main line

## Acceptance Criteria

v1 is acceptable when all of the following are true:

1. `bin/codex-agents list` prints the bundled role set.
2. `bin/codex-agents install` creates or updates `~/.codex/agents/` with the bundled role files.
3. `bin/codex-agents update` overwrites installed role files from the repo bundle.
4. `agents/orchestrator.md` clearly explains phase detection, routing rules, operating rules, and anti-patterns.
5. `README.md` clearly explains installation, update, list, usage model, and repository-sharing flow.
6. The repository can be cloned from GitHub and installed with the documented commands.

## Current Prototype Mapping

Already implemented in prototype form:

- repository skeleton
- role files
- `orchestrator.md`
- CLI commands
- installation into `~/.codex/agents/`
- public GitHub repository

## Next Likely Improvements After v1

- target override support such as `install --target`
- install diagnostics such as `doctor` or `status`
- clearer project-local integration guidance
- optional richer orchestration behavior once the baseline install flow is stable
