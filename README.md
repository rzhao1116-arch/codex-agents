# codex-agents

Codex-native `.toml` agents plus an installed `orchestrator-routing` skill that makes `orchestrator` the default routing lens for non-trivial work.

This repository is released under the MIT license. The current source-tree release target is `v0.1.2`.

中文说明见 [README.zh-CN.md](README.zh-CN.md)。

## Command Usage Model

- Default install path: Homebrew.
- After Homebrew install, use `codex-agents` as the normal global command.
- Source checkout remains available for contributors and local development.

## What This Repo Provides

- A set of Codex-native agent baseline files in [`agents/`](/Users/ryan/Projects/Ai/other/codex-agents/agents)
- A baseline orchestration role in [`orchestrator.toml`](/Users/ryan/Projects/Ai/other/codex-agents/agents/orchestrator.toml)
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

Preferred Homebrew install:

```bash
brew install rzhao1116-arch/homebrew-tap/codex-agents
```

Or install into a custom Codex home:

```bash
codex-agents install --target /tmp/test-codex-home
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

- `orchestrator.toml`
- `product-manager.toml`
- `ux-architect.toml`
- `ui-designer.toml`
- `frontend-developer.toml`
- `backend-architect.toml`
- `software-architect.toml`
- `docs-researcher.toml`
- `code-reviewer.toml`
- `reality-checker.toml`
- `technical-writer.toml`

And these skills:

- `orchestrator-routing`

## Update

Homebrew-managed install:

```bash
brew upgrade rzhao1116-arch/homebrew-tap/codex-agents
```

Source-managed install:

```bash
codex-agents update
```

Custom target:

```bash
codex-agents update --target /tmp/test-codex-home
```

Both `install` and `update` now remind the user to open a new Codex conversation so the refreshed skill list is picked up.

## Doctor

```bash
codex-agents doctor
```

Custom target:

```bash
codex-agents doctor --target /tmp/test-codex-home
```

Use `doctor` to check:

- whether bundled agents were installed
- whether `orchestrator-routing` is installed in `~/.codex/skills/`
- whether the managed `AGENTS.md` block is present and up to date
- whether the most likely issue is simply that the current conversation needs a fresh skill index

Machine-readable output:

```bash
codex-agents doctor --json
```

## Status

```bash
codex-agents status
```

Custom target:

```bash
codex-agents status --target /tmp/test-codex-home
```

Use `status` for a quick summary when you do not need the longer `doctor` guidance. It reports whether:

- the managed agents directory exists
- `orchestrator-routing` is installed
- the managed `AGENTS.md` block is present

Machine-readable output:

```bash
codex-agents status --json
```

## Uninstall

```bash
codex-agents uninstall
```

Custom target:

```bash
codex-agents uninstall --target /tmp/test-codex-home
```

`uninstall` removes only the bundle managed by this repo:

- bundled agent files from `~/.codex/agents/`
- bundled skill directories from `~/.codex/skills/`
- the managed entrypoint block in `~/.codex/AGENTS.md`

It does **not** remove unrelated global skills or unrelated content from `AGENTS.md`.

## Version

```bash
codex-agents version
```

`version` prints the current bundled git commit short SHA. This is intended as a lightweight support identifier until the repo grows a fuller release/versioning model.

## List Bundled Files

```bash
codex-agents list
```

Each bundled agent is a Codex-native `.toml` file with explicit model, reasoning, sandbox, and `developer_instructions` fields rather than a Claude-style Markdown persona file.

## How To Use

- Treat the installed files as a lightweight role-and-routing system for Codex.
- After install, the managed `AGENTS.md` block makes non-trivial multi-phase work prefer the `orchestrator-routing` skill first.
- Let `orchestrator-routing` classify the task as `simple`, `multi-step`, or `complex`.
- Let `orchestrator-routing` prune the smallest useful role chain instead of defaulting to the full role set.
- Let `orchestrator-routing` make that routing explicit with:
  - `complexity`
  - `role-chain`
  - `next-step`
  - `reason`
- Let `orchestrator-routing` decide whether the next phase should enter `brainstorming`, `writing-plans`, implementation skills, or stop early.
- Keep `orchestrator.toml` as the baseline role definition behind that routing behavior.
- Keep stronger local global rules and repository-local rules above these generic baselines.

## Practical Usage Pattern

Use the installed bundle as a lightweight default-entrypoint orchestration system:

1. Present the task normally.
2. Let the managed entrypoint rule route non-trivial work into `orchestrator-routing`.
3. Let `orchestrator-routing` classify it as `simple`, `multi-step`, or `complex`.
4. Let `orchestrator-routing` explicitly show:
   - `complexity`
   - `role-chain`
   - `next-step`
   - `reason`
5. Let `orchestrator-routing` choose the smallest useful role chain and next downstream skill.
6. Let that chain continue only while each next role is still justified.
7. End early when the task is already resolved, or reroute when the current path breaks.

Typical routes:

- ambiguous request -> `orchestrator-routing -> product-manager -> ...`
- flow/interaction problem -> `orchestrator-routing -> ux-architect -> frontend-developer -> reality-checker`
- architecture-heavy backend change -> `orchestrator-routing -> software-architect -> backend-architect -> code-reviewer -> reality-checker`
- official docs / SDK / MCP / platform question -> `orchestrator-routing -> docs-researcher`, then stop early if that already resolves the task
- new feature requiring design -> `orchestrator-routing -> brainstorming -> implementation chain`

## Release Model

- `install` is for first-time setup into `~/.codex`
- `install` and `update` also accept `--target <path>` to install into a different Codex home root
- `update` overwrites installed agent files, skills, and the managed entrypoint block with the current repo version
- `status` gives a lightweight installed-state summary
- `status --json` gives the same summary in machine-readable form
- `uninstall` removes only the bundle managed by this repository
- `doctor` checks installed state and explains common “installed but not visible in current conversation” situations
- `doctor --json` returns the same diagnostic model in machine-readable form
- `version` prints the current bundled git short SHA
- `list` shows the bundled agents and skills before install or update

## Release Notes

Published release notes:

- [v0.1.0](/Users/ryan/Projects/Ai/other/codex-agents/docs/releases/v0.1.0.md)
- [v0.1.1](/Users/ryan/Projects/Ai/other/codex-agents/docs/releases/v0.1.1.md)
- [v0.1.2](/Users/ryan/Projects/Ai/other/codex-agents/docs/releases/v0.1.2.md)

## Homebrew Draft

The repository now includes a Homebrew formula draft aimed at a future `homebrew-core` submission path:

```bash
bash tests/homebrew_formula_temp_tap_roundtrip.sh
```

The draft currently uses the latest tagged release tarball and checksum. It installs the bundled repository layout into Homebrew `libexec` and exposes the CLI with `bin.write_exec_script`.

Because the formula tracks the latest tagged release tarball, source-tree changes to agent layout should be released and re-tagged before expecting the Homebrew draft to reflect them.

Current Homebrew releases reject non-tap local formula installs, so this repo validates the draft by copying it into a temporary tap, installing from that tap, running `brew test`, and cleaning up afterwards.

For stricter formula validation, also run:

```bash
bash tests/homebrew_formula_release_alignment.sh
bash tests/homebrew_formula_audit_in_temp_tap.sh
```

## Publishing / Sharing

Recommended public install path:

```bash
brew install rzhao1116-arch/homebrew-tap/codex-agents
```

Source bootstrap remains available for contributors and local development:

```bash
git clone https://github.com/rzhao1116-arch/codex-agents.git
cd codex-agents
bin/codex-agents install
bin/codex-agents link
codex-agents status
```

If you do not want to link the repo-local CLI into `PATH`, you can keep using `bin/codex-agents` directly from the checkout.

## Design Notes

- This repo intentionally installs directly into `~/.codex/agents/` and `~/.codex/skills/`, following Codex's custom-agent directory model.
- The first version does not modify user `config.toml`.
- The first version does manage a clearly marked entrypoint block in `~/.codex/AGENTS.md` because current Codex behavior does not expose a built-in default-agent hook through `agents/` alone.
- The first version also installs an explicit `orchestrator-routing` skill so the routing behavior participates in skill-first workflows instead of losing priority to existing skills.
- The main feature is the default-entrypoint behavior of `orchestrator-routing` plus `orchestrator`, not just the presence of many role files.
- Starting with `v0.1.1`, the agent bundle is authored directly as `.toml`, so install/update no longer converts or depends on Markdown agent baselines at runtime.
- The first version aims for automatic chain pruning and automatic continuation through the smallest useful role sequence.
- The first version still does not promise perfect routing, hidden Codex hooks, or a flawless autonomous execution engine.
