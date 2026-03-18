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

## User Flows

### First-Time Install Flow

1. User clones the repository.
2. User runs `bin/codex-agents install`.
3. Tool creates `~/.codex/agents/` if needed.
4. Tool copies bundled role files into that directory.
5. User can inspect the installed role files and start using them with Codex.

### Update Flow

1. User pulls the latest repository changes.
2. User runs `bin/codex-agents update`.
3. Tool overwrites installed role files with the current repository versions.
4. User continues with the updated role set.

### Typical Usage Flow

1. User starts from `orchestrator`.
2. User identifies the current task phase.
3. User routes to the smallest useful specialist.
4. Main line integrates the specialist output.
5. Main line still performs final verification and acceptance.

## Orchestrator Responsibilities

- detect the current task phase
- route to the smallest useful specialist
- avoid overlapping delegation
- keep final integration, verification, and acceptance on the main line

## Routing Examples

### Example: ambiguous new feature

- start with `product-manager`
- move to `ux-architect` if the main challenge is user flow
- move to `ui-designer` if visual structure is central
- implement with `frontend-developer` or `backend-architect`
- review with `code-reviewer`
- validate delivery with `reality-checker`

### Example: SDK or MCP integration question

- start with `docs-researcher`
- move to `software-architect` or `backend-architect` if the answer affects system design
- implement
- review and reality-check before delivery

### Example: architecture-heavy backend change

- start with `software-architect`
- refine implementation shape with `backend-architect`
- implement
- review with `code-reviewer`
- check deliverability with `reality-checker`

## Project Integration

- Installed agents are baseline role files, not stronger authority than local project rules.
- If a repository has its own `AGENTS.md`, `.codex/model-instructions.md`, or `.codex/skills-guidelines.md`, those local rules remain stronger.
- `orchestrator` should route work in a way that respects local verification, review, and acceptance requirements rather than bypassing them.
- This tool is intended to complement project-local workflows, not replace them.

## Failure Cases

- If `~/.codex/agents/` does not exist, `install` should create it.
- If target role files already exist, `install` and `update` may overwrite them in v1; this is acceptable for the first version and should be documented clearly.
- If the source `agents/` directory is incomplete or missing, CLI commands should fail fast instead of silently installing a partial set.
- If the user expects automatic end-to-end orchestration, the docs should clearly state that v1 provides role baselines and routing guidance, not a full autonomous workflow engine.

## Acceptance Criteria

v1 is acceptable when all of the following are true:

1. `bin/codex-agents list` prints the bundled role set.
2. `bin/codex-agents install` creates or updates `~/.codex/agents/` with the bundled role files.
3. `bin/codex-agents update` overwrites installed role files from the repo bundle.
4. `agents/orchestrator.md` clearly explains phase detection, routing rules, operating rules, and anti-patterns.
5. `README.md` clearly explains installation, update, list, usage model, and repository-sharing flow.
6. The repository can be cloned from GitHub and installed with the documented commands.
7. The spec clearly explains install flow, update flow, routing examples, project integration boundaries, and expected failure cases.

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
