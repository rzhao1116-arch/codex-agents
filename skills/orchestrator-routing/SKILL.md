---
name: orchestrator-routing
description: Use when a request may span multiple phases or roles, has meaningful ambiguity, or needs routing to the smallest useful role chain before choosing downstream skills or implementation.
---

# Orchestrator Routing

Use this skill as the first routing layer for non-trivial work. Its job is to decide how much process the task actually needs before downstream skills or specialist roles take over.

## When to Use

- The request may cross product, UX, UI, frontend, backend, review, or acceptance stages
- The task shape is unclear and you need to decide whether it is `simple`, `multi-step`, or `complex`
- The task could trigger multiple skills and you need to determine which one should come next
- The work sounds substantial enough that routing mistakes would create rework

Do not use this skill for obviously trivial single-step questions that already map cleanly to one specialist or one existing skill.

## Core Responsibilities

1. Classify the task as `simple`, `multi-step`, or `complex`
2. Identify the most important unresolved uncertainty
3. Choose the smallest useful role chain
4. Decide which downstream skill or specialist should go next
5. Stop early, downgrade, upgrade, or reroute when the current chain is no longer justified

## Required Output Shape

For non-trivial routed work, make the routing visible before continuing. Start with a short routing block that includes:

- `complexity`: `simple`, `multi-step`, or `complex`
- `role-chain`: the smallest useful role chain
- `next-step`: the next downstream skill or specialist
- `reason`: the main reason this chain was chosen

Keep this block concise and put it before deeper design or implementation guidance. The goal is that a user can tell at a glance whether `orchestrator-routing` actually took control.

## Complexity Model

### `simple`

Use when:

- the task is already clear
- one specialist lens is dominant
- no broad delivery chain is needed

Default shape:

- one primary specialist
- optional final `code-reviewer` or `reality-checker`

### `multi-step`

Use when:

- the task needs a small but real chain across two or more phases
- the scope is reasonably bounded
- implementation will likely need one meaningful follow-up check

Default shape:

- `2-4` roles
- one small closed loop

### `complex`

Use when:

- the task has meaningful ambiguity
- it spans multiple lifecycle phases
- it touches architecture, shared state, or a significant acceptance path

Default shape:

- `3-7` roles
- pruned chain, not the full role bundle

## Role Selection Heuristics

- unclear scope, success criteria, or priorities -> `product-manager`
- unclear user flow, information architecture, or interaction structure -> `ux-architect`
- unclear visual hierarchy or interface clarity -> `ui-designer`
- browser UI, interaction, accessibility, responsiveness, or frontend state -> `frontend-developer`
- API shape, service boundaries, persistence, backend implementation structure, or data flow -> `backend-architect`
- broader module boundaries, architecture trade-offs, or system evolution -> `software-architect`
- official docs, SDK behavior, MCP/platform behavior, auth quirks, or external technical truth -> `docs-researcher`
- implementation risk review -> `code-reviewer`
- delivery realism and acceptance-bar check -> `reality-checker`
- structured handoff or explanatory docs -> `technical-writer`

## Priority Rules

When multiple roles seem relevant, prefer:

1. Resolve ambiguity first
   - `product-manager`
   - `ux-architect`
   - `ui-designer`
2. Resolve external truth or architectural uncertainty next
   - `docs-researcher`
   - `software-architect`
3. Implement with the smallest useful role set
   - `frontend-developer`
   - `backend-architect`
4. Close quality and delivery
   - `code-reviewer`
   - `reality-checker`
   - `technical-writer` when needed

## Downstream Skill Routing

After routing, choose the next skill or role instead of jumping straight into implementation:

- If the task is new functionality, product behavior, or a new tool and still needs design work -> run `brainstorming`
- If a spec exists and the work is now implementation planning -> run `writing-plans`
- If the next phase is implementation of a feature or bugfix -> use `test-driven-development`
- If the next phase is investigation of a bug or failure -> use `systematic-debugging`
- If the task is mostly external evidence gathering -> go to `docs-researcher` or `deep-research`
- If the task is already implementation-complete and needs risk checking -> use `requesting-code-review`

This skill decides whether those downstream skills should run next. It should come before them for complex routing decisions.

## Response Pattern

For routed work, follow this order:

1. Emit the short routing block:
   - `complexity`
   - `role-chain`
   - `next-step`
   - `reason`
2. Call out the most important uncertainty or gating fact.
3. Continue into the chosen downstream skill or specialist only after the route is explicit.

Example shape:

```text
complexity: complex
role-chain: product-manager -> docs-researcher -> brainstorming -> implementation -> code-reviewer -> reality-checker
next-step: brainstorming
reason: the task crosses product, data-source, implementation, and acceptance phases, but the data source is still unresolved
```

## Stop, Downgrade, Upgrade, and Reroute

- Stop early when one role has already resolved the task
- Downgrade when the task becomes simpler than first expected
- Upgrade when ambiguity, system impact, or acceptance depth turns out larger than expected
- Reroute when external truth, architecture findings, or review results invalidate the current chain
- Do not continue to delivery after a failed `reality-checker` result

## Anti-Patterns

- Do not default to the full role bundle
- Do not send ambiguous work straight to implementation roles
- Do not let downstream skills start before routing is settled for clearly multi-phase tasks
- Do not keep executing a chain mechanically after a role has invalidated the current path
- Do not route around stronger repository-local rules
