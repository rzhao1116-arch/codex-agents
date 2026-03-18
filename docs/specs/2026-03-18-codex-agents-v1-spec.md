# codex-agents v1 Spec

## Status

Prototype already implemented; this spec defines the intended v1 scope, boundaries, and acceptance criteria so the project can continue under an explicit development flow.

## Product Goal

Provide a simple public CLI tool that installs a Claude-style set of role baselines plus an `orchestrator-routing` skill into `~/.codex`, so Codex users can adopt a role-driven workflow where routing participates in skill-first behavior instead of relying only on passive agent docs.

## Problem

Codex supports subagents, but users do not get:

- a ready-made role set
- a clear Claude-style `agents/` installation workflow
- a skill-level orchestration entrypoint that can compete with existing skill-first workflows

That makes role-driven delegation harder to adopt consistently, harder to share, and too dependent on users manually remembering how to route tasks.

## Target User

- Codex users who want a Claude-style `agents/` directory
- users who want a reusable role baseline without building their own role library from scratch
- users who prefer simple install/update mechanics over framework setup
- users who want orchestration to participate in skill-first routing instead of acting as a passive reference document

## v1 Scope

### Included

- a repository-local `agents/` directory with bundled role files
- a repository-local `skills/` directory with bundled skill files
- a bundled `orchestrator.md` that acts as the baseline orchestration role definition
- a bundled `orchestrator-routing` skill that acts as the default orchestration entrypoint
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
  - `doctor`
  - `uninstall`
  - `list`
- installation targets:
  - `~/.codex/agents/`
  - `~/.codex/skills/`
- a tool-managed entrypoint block in:
  - `~/.codex/AGENTS.md`
- automatic task classification inside `orchestrator-routing`:
  - `simple`
  - `multi-step`
  - `complex`
- automatic downstream skill selection inside `orchestrator-routing`
- automatic role-chain pruning based on task shape instead of defaulting to a full role sequence
- automatic continuous orchestration behavior inside `orchestrator-routing`, where it can move through a pruned role chain until it has a final result
- explicit stop, downgrade, upgrade, and reroute rules when the initial chain proves wrong

### Not Included

- automatic modification of user `config.toml`
- dynamic agent generation
- complex multi-source vendor syncing
- role permission sandboxing beyond what Codex already provides
- guaranteed perfect routing for every task
- direct integration with undocumented Codex internal routing hooks

## Architecture

### Repository Layout

```text
codex-agents/
  agents/
  skills/
  bin/
  docs/specs/
  README.md
```

### Runtime Model

- `agents/` is the source-of-truth role bundle
- `skills/` is the source-of-truth skill bundle
- `bin/codex-agents` copies agent files into `~/.codex/agents/`
- `bin/codex-agents` copies skill directories into `~/.codex/skills/`
- `bin/codex-agents` creates or updates a clearly marked managed block in `~/.codex/AGENTS.md`
- `orchestrator-routing` is the default entrypoint for complex or ambiguous work
- `orchestrator-routing` first classifies task complexity, then prunes the smallest necessary role chain, then chooses downstream skills and roles toward a final result
- `orchestrator.md` remains the baseline orchestration role definition that the routing skill aligns to and references
- local user rules and project rules remain stronger than the bundled baselines

## CLI Behavior

### `install`

- create `~/.codex/agents/` if missing
- create `~/.codex/skills/` if missing
- copy all bundled agent `.md` files into the target directory
- copy bundled skill directories into the target directory
- create or update the managed `~/.codex/AGENTS.md` entrypoint block
- print the installed role and skill list

### `update`

- overwrite previously installed role files from the current repo contents
- overwrite previously installed skills from the current repo contents
- replace the managed `~/.codex/AGENTS.md` entrypoint block with the current repo version
- print the bundled role and skill list

### `list`

- print the bundled role filenames and skill directory names without installing

### `doctor`

- check whether `~/.codex/agents/` exists
- check whether `~/.codex/skills/orchestrator-routing/SKILL.md` exists
- check whether the managed `~/.codex/AGENTS.md` block exists and mentions `orchestrator-routing`
- print three sections:
  - `Checks`
  - `Findings`
  - `Next actions`
- explain the common case where the skill is installed on disk but an already-open conversation still has a stale skill list

### `uninstall`

- remove bundled agent files previously installed by this repo
- remove bundled skill directories previously installed by this repo
- remove the managed `~/.codex/AGENTS.md` block
- leave unrelated global skills and unrelated `AGENTS.md` content intact

## User Flows

### First-Time Install Flow

1. User clones the repository.
2. User runs `bin/codex-agents install`.
3. Tool creates `~/.codex/agents/` if needed.
4. Tool creates `~/.codex/skills/` if needed.
5. Tool copies bundled role files and skill directories into those targets.
6. Tool creates or updates a clearly marked managed block in `~/.codex/AGENTS.md`.
7. User can inspect the installed role files and skills and gets orchestrator-first routing behavior without manually editing rules.

### Update Flow

1. User pulls the latest repository changes.
2. User runs `bin/codex-agents update`.
3. Tool overwrites installed role files and skills with the current repository versions.
4. Tool replaces the managed entrypoint block with the current version.
5. User continues with the updated role set, skill bundle, and managed routing behavior.

### Uninstall Flow

1. User runs `bin/codex-agents uninstall`.
2. Tool removes the bundled agent files from `~/.codex/agents/`.
3. Tool removes bundled skills from `~/.codex/skills/`.
4. Tool removes the managed `AGENTS.md` entrypoint block.
5. Tool keeps unrelated global files intact.

### Doctor Flow

1. User runs `bin/codex-agents doctor`.
2. Tool checks the installed agent directory, skill directory, and managed `AGENTS.md` block.
3. Tool reports pass/fail status for each check.
4. Tool explains likely causes of “installed but unavailable in current conversation.”
5. Tool recommends next actions, usually:
   - reinstall if files are missing
   - open a new conversation if the skill exists on disk
   - restart the app only if a fresh conversation still does not see the skill

### Typical Usage Flow

1. User presents the task normally.
2. `orchestrator-routing` classifies the task as `simple`, `multi-step`, or `complex`.
3. `orchestrator-routing` selects the smallest useful role chain and downstream skills.
4. `orchestrator-routing` automatically moves through that chain until it reaches a final result or a stop condition.
5. Final output still respects stronger local verification, review, and acceptance rules.

## Orchestrator-Routing Responsibilities

- act as the default entrypoint for installed role-driven workflows
- classify task complexity as `simple`, `multi-step`, or `complex`
- identify which uncertainty is most important to resolve first
- route to the smallest useful specialist or specialist chain
- choose the next downstream skill or role before implementation begins
- continue through the pruned chain automatically when the next step is still clearly justified
- stop, downgrade, upgrade, or reroute when the current chain no longer fits the task
- avoid overlapping delegation and unnecessary full-role fan-out
- preserve stronger local verification, review, and acceptance requirements

## Complexity Model

### `simple`

Use when the task is already clear, primarily needs one specialist lens, and does not require a broad delivery chain.

Typical handling:

- select one primary role
- optionally end with `code-reviewer` or `reality-checker` when the result is deliverable

### `multi-step`

Use when the task needs a small but meaningful chain across two or more phases, while the scope is still reasonably bounded.

Typical handling:

- select a compact `2-4` role chain
- keep the chain closed and avoid bringing in unnecessary roles

### `complex`

Use when the task has meaningful ambiguity, spans multiple lifecycle phases, touches architecture or shared state, or has a significant acceptance chain.

Typical handling:

- build a pruned `3-7` role chain
- do not default to the full role set
- keep `code-reviewer` and `reality-checker` as likely tail roles unless the task ends earlier

## Role Selection Heuristics

Use these signals to decide which role should appear in the chain:

- unclear scope, success criteria, or priorities -> `product-manager`
- unclear user flow, information architecture, or interaction structure -> `ux-architect`
- unclear visual hierarchy or interface expression -> `ui-designer`
- browser UI, interaction, accessibility, responsiveness, or frontend state implementation -> `frontend-developer`
- APIs, service boundaries, persistence, backend implementation shape, or data flow -> `backend-architect`
- module boundaries, broader technical trade-offs, or system evolution framing -> `software-architect`
- official documentation, SDK behavior, MCP/platform behavior, auth quirks, or external technical truth -> `docs-researcher`
- post-implementation technical risk review -> `code-reviewer`
- pre-delivery realism and acceptance bar check -> `reality-checker`
- structured documentation or handoff output -> `technical-writer`

## Downstream Skill Routing

After routing, the orchestrator skill decides what should happen next:

- new functionality or new tool with unresolved design questions -> `brainstorming`
- approved spec and implementation planning phase -> `writing-plans`
- implementation of a feature or bugfix -> `test-driven-development`
- debugging or failure investigation -> `systematic-debugging`
- mostly external evidence gathering -> `docs-researcher` or `deep-research`
- implementation-complete risk review -> `requesting-code-review`

The routing skill should choose whether those downstream skills run next. It should come before them for clearly multi-phase tasks.

## Project Integration

- Installed agents and skills are baseline files, not stronger authority than local project rules.
- If a repository has its own `AGENTS.md`, `.codex/model-instructions.md`, or `.codex/skills-guidelines.md`, those local rules remain stronger.
- `orchestrator-routing` should route work in a way that respects local verification, review, acceptance requirements, and skill priorities rather than bypassing them.
- Automatic orchestration should still treat local project rules as stronger than the generic role bundle.
- The managed global entrypoint block is a convenience layer for default behavior, not stronger authority than repository-local rules.

## Failure Cases

- If `~/.codex/agents/` does not exist, `install` should create it.
- If `~/.codex/skills/` does not exist, `install` should create it.
- If `~/.codex/AGENTS.md` does not exist, `install` should create it.
- If target role files already exist, `install` and `update` may overwrite them in v1; this is acceptable for the first version and should be documented clearly.
- If target skill directories already exist, `install` and `update` may overwrite them in v1; this is acceptable for the first version and should be documented clearly.

## Acceptance Criteria

- `install` creates `~/.codex/agents/` when missing.
- `install` creates `~/.codex/skills/` when missing.
- `install` copies all bundled role files into `~/.codex/agents/`.
- `install` copies all bundled skill directories into `~/.codex/skills/`.
- `install` creates or updates the managed `~/.codex/AGENTS.md` block.
- `install` and `update` remind the user to open a new conversation so the refreshed skill list is visible.
- `update` overwrites the installed files with current repository contents.
- `doctor` reports installed state and common stale-session guidance.
- `uninstall` removes only the bundle managed by this repo and leaves unrelated files intact.
- `list` prints the bundled role and skill set.
- README explains install, update, list, skill-first routing behavior, and scope boundaries.
- The repository remains easy to clone and use without additional packaging or config mutation beyond the managed `AGENTS.md` block.
