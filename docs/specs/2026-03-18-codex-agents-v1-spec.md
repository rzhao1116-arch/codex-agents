# codex-agents v1 Spec

## Status

Prototype already implemented; this spec defines the intended v1 scope, boundaries, and acceptance criteria so the project can continue under an explicit development flow.

## Product Goal

Provide a simple public CLI tool that installs a Claude-style set of role baselines plus an orchestrator into `~/.codex/agents/`, so Codex users can adopt a role-driven workflow where `orchestrator` acts as the default entrypoint and automatically composes the smallest useful role chain for a task.

## Problem

Codex supports subagents, but users do not get a ready-made role set, a clear Claude-style `agents/` installation workflow, or a default orchestration entrypoint. That makes role-driven delegation harder to adopt consistently, harder to share, and too dependent on users manually remembering how to route tasks.

## Target User

- Codex users who want a Claude-style `agents/` directory
- users who want a reusable role baseline without building their own role library from scratch
- users who prefer simple install/update mechanics over complex framework setup
- users who want `orchestrator` to behave like the default starting lens for multi-phase work instead of acting as a passive reference document

## v1 Scope

### Included

- a repository-local `agents/` directory with bundled role files
- a bundled `orchestrator.md` that acts as the default orchestration entrypoint
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
- a tool-managed entrypoint block in:
  - `~/.codex/AGENTS.md`
- public GitHub repository distribution
- automatic task classification inside `orchestrator`:
  - `simple`
  - `multi-step`
  - `complex`
- automatic role-chain pruning based on task shape instead of defaulting to a full role sequence
- automatic continuous orchestration behavior inside `orchestrator`, where it can move through a pruned role chain until it has a final result
- explicit stop, downgrade, upgrade, and reroute rules when the initial chain proves wrong

### Not Included

- automatic modification of user `config.toml`
- dynamic agent generation
- complex multi-source vendor syncing
- role permission sandboxing beyond what Codex already provides
- guaranteed perfect routing for every task
- direct integration with Codex internal routing hooks beyond the installed agent files themselves

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
- `bin/codex-agents` also creates or updates a clearly marked managed block in `~/.codex/AGENTS.md`
- `orchestrator.md` is the default entrypoint for complex or ambiguous work
- `orchestrator.md` first classifies task complexity, then prunes the smallest necessary role chain, then drives continuous orchestration to a final result
- `orchestrator.md` may stop early, downgrade, upgrade, or reroute when new information invalidates the original chain
- local user rules and project rules remain stronger than the bundled baselines

## CLI Behavior

### `install`

- create `~/.codex/agents/` if missing
- copy all bundled `.md` files into the target directory
- create or update the managed `~/.codex/AGENTS.md` entrypoint block
- print the installed role list

### `update`

- overwrite previously installed role files from the current repo contents
- replace the managed `~/.codex/AGENTS.md` entrypoint block with the current repo version
- print the bundled role list

### `list`

- print the bundled role filenames without installing

## User Flows

### First-Time Install Flow

1. User clones the repository.
2. User runs `bin/codex-agents install`.
3. Tool creates `~/.codex/agents/` if needed.
4. Tool copies bundled role files into that directory.
5. Tool creates or updates a clearly marked managed block in `~/.codex/AGENTS.md`.
6. User can inspect the installed role files and gets orchestrator-first routing behavior without manually editing rules.

### Update Flow

1. User pulls the latest repository changes.
2. User runs `bin/codex-agents update`.
3. Tool overwrites installed role files with the current repository versions.
4. Tool replaces the managed entrypoint block with the current version.
5. User continues with the updated role set and managed routing behavior.

### Typical Usage Flow

1. User presents the task normally.
2. `orchestrator` classifies the task as `simple`, `multi-step`, or `complex`.
3. `orchestrator` selects the smallest useful role chain.
4. `orchestrator` automatically moves through that chain until it reaches a final result or a stop condition.
5. Final output still respects stronger local verification, review, and acceptance rules.

## Orchestrator Responsibilities

- act as the default entrypoint for installed role-driven workflows
- classify task complexity as `simple`, `multi-step`, or `complex`
- identify which uncertainty is most important to resolve first
- route to the smallest useful specialist or specialist chain
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
- pre-delivery realism and acceptance check -> `reality-checker`
- structured documentation or handoff output -> `technical-writer`

## Role Priority Rules

When multiple roles appear relevant, prefer this ordering:

1. resolve ambiguity first
   - `product-manager`
   - `ux-architect`
   - `ui-designer`
2. resolve external truth or architectural uncertainty next
   - `docs-researcher`
   - `software-architect`
3. implement with the smallest suitable implementation role set
   - `frontend-developer`
   - `backend-architect`
4. close quality and delivery
   - `code-reviewer`
   - `reality-checker`
   - `technical-writer` when needed

## Routing Examples

### Example: ambiguous new feature

- initial classification: `complex`
- start with `product-manager`
- move to `ux-architect` if the main challenge is user flow
- move to `ui-designer` if visual structure is central
- implement with `frontend-developer` or `backend-architect`
- review with `code-reviewer`
- validate delivery with `reality-checker`

### Example: SDK or MCP integration question

- initial classification: usually `simple` or `multi-step`
- start with `docs-researcher`
- move to `software-architect` or `backend-architect` if the answer affects system design
- if the answer fully resolves the task, stop early
- otherwise implement, then review and reality-check before delivery

### Example: architecture-heavy backend change

- initial classification: `complex`
- start with `software-architect`
- refine implementation shape with `backend-architect`
- implement
- review with `code-reviewer`
- check deliverability with `reality-checker`

### Example: realtime Codex quota monitoring page

- initial classification: `complex`
- start with `product-manager` if metrics, target users, or success criteria are not yet clear
- use `docs-researcher` if the quota data source or platform truth is uncertain
- use `software-architect` or `backend-architect` if data flow, persistence, or backend integration shape is still undecided
- use `ux-architect` and `ui-designer` only when the page structure or visual presentation is a real uncertainty
- implement through `frontend-developer` and `backend-architect`
- close with `code-reviewer` and `reality-checker`

## Project Integration

- Installed agents are baseline role files, not stronger authority than local project rules.
- If a repository has its own `AGENTS.md`, `.codex/model-instructions.md`, or `.codex/skills-guidelines.md`, those local rules remain stronger.
- `orchestrator` should route work in a way that respects local verification, review, and acceptance requirements rather than bypassing them.
- Automatic orchestration should still treat local project rules as stronger than the generic role bundle.
- The managed global entrypoint block is a convenience layer for default behavior, not stronger authority than repository-local rules.
- This tool is intended to complement project-local workflows, not replace them.

## Failure Cases

- If `~/.codex/agents/` does not exist, `install` should create it.
- If `~/.codex/AGENTS.md` does not exist, `install` should create it.
- If target role files already exist, `install` and `update` may overwrite them in v1; this is acceptable for the first version and should be documented clearly.
- If `~/.codex/AGENTS.md` already exists, `install` and `update` should replace only the managed block instead of clobbering the whole file.
- If the source `agents/` directory is incomplete or missing, CLI commands should fail fast instead of silently installing a partial set.
- If the initial complexity classification is wrong, `orchestrator` should downgrade, upgrade, or reroute instead of mechanically continuing the original chain.
- If a role fully resolves the task, orchestration should stop early instead of forcing the rest of the chain.
- If external documentation invalidates the plan, orchestration should return to an earlier reasoning role instead of continuing to implement.
- If `code-reviewer` finds a major upstream issue, the chain should return to the implementation or architecture role instead of continuing to delivery.
- If `reality-checker` determines the work does not meet the acceptance bar, orchestration should stop with a clear failure state rather than pretending the task is complete.

## Acceptance Criteria

v1 is acceptable when all of the following are true:

1. `bin/codex-agents list` prints the bundled role set.
2. `bin/codex-agents install` creates or updates `~/.codex/agents/` with the bundled role files.
3. `bin/codex-agents install` creates or updates a clearly marked managed entrypoint block in `~/.codex/AGENTS.md`.
4. `bin/codex-agents update` overwrites installed role files from the repo bundle and refreshes the managed entrypoint block.
5. `agents/orchestrator.md` clearly explains complexity classification, role selection heuristics, priority rules, automatic chaining behavior, and stop/reroute rules.
6. `README.md` clearly explains installation, update, list, the managed entrypoint behavior, and the high-level usage model.
7. The repository can be cloned from GitHub and installed with the documented commands.
8. The spec clearly explains install flow, update flow, complexity handling, routing examples, project integration boundaries, and expected failure cases.

## Current Prototype Mapping

Already implemented in prototype form:

- repository skeleton
- role files
- `orchestrator.md`
- CLI commands
- installation into `~/.codex/agents/`
- public GitHub repository
- managed `~/.codex/AGENTS.md` entrypoint integration

Not yet implemented in the current prototype:

- README positioning that treats `orchestrator` as the default entrypoint rather than only a routing reference

## Next Likely Improvements After v1

- target override support such as `install --target`
- install diagnostics such as `doctor` or `status`
- clearer project-local integration guidance
- optional future work on deeper runtime automation only after the default-entrypoint orchestration model is stable
