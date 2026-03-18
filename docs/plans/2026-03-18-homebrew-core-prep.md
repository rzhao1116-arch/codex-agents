# codex-agents Homebrew-Core Prep Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Prepare `codex-agents` for a credible `homebrew-core` submission path by adding release foundations before writing a formula PR.

**Architecture:** Keep the existing repo as the source of truth, release versioned GitHub tarballs, and use a small `test do` that verifies the installed CLI can report its version and basic bundle metadata without depending on the developer's existing `~/.codex`.

**Tech Stack:** bash CLI, GitHub releases, Homebrew formula packaging

---

## Current Draft Status

- `v0.1.0` has been tagged and released on GitHub.
- The current formula draft should live at `Formula/codex-agents.rb`.
- The draft should install the bundled repository layout into `libexec` and expose `codex-agents` via `bin.write_exec_script`.
- Current Homebrew releases reject non-tap local formula installs, so local validation should use a temporary tap roundtrip instead of `brew install ./Formula/...`.
- The first local validation path should be:
  - `bash tests/homebrew_formula_temp_tap_roundtrip.sh`

## Chunk 1: Release Foundations

### Task 1: Lock the legal and versioning baseline

**Files:**
- Create: `LICENSE`
- Modify: `README.md`

- [ ] **Step 1: Add the MIT license**

Add a standard MIT `LICENSE` file at the repository root.

- [ ] **Step 2: Mention the license and initial release target in the README**

Document that the repo is MIT licensed and that the first packaged release target is `v0.1.0`.

- [ ] **Step 3: Verify the repo now exposes the legal baseline**

Run: `test -f LICENSE && rg -n "MIT|v0.1.0" README.md`
Expected: `LICENSE` exists and the README mentions both the MIT license and `v0.1.0`.

- [ ] **Step 4: Commit**

```bash
git add LICENSE README.md
git commit -m "docs: add license and v0.1.0 release baseline"
```

## Chunk 2: Release Workflow Definition

### Task 2: Define the minimum release sequence

**Files:**
- Create: `docs/plans/2026-03-18-homebrew-core-prep.md`
- Modify: `README.md`

- [ ] **Step 1: Write the release sequence**

Capture this minimum path:

1. Prepare `main`
2. Tag `v0.1.0`
3. Publish a GitHub Release
4. Use the release tarball as the Homebrew download source
5. Write a formula with a stable `sha256`
6. Submit or test the formula against Homebrew expectations

- [ ] **Step 2: Define the first `test do` direction**

Document that the initial Homebrew test should be lightweight, for example:

- `codex-agents version`
- `codex-agents list`

and should not require the developer's existing `~/.codex`.

- [ ] **Step 3: Verify the document is present and readable**

Run: `test -f docs/plans/2026-03-18-homebrew-core-prep.md && sed -n '1,200p' docs/plans/2026-03-18-homebrew-core-prep.md`
Expected: the plan file exists and includes the release sequence plus test guidance.

- [ ] **Step 4: Commit**

```bash
git add docs/plans/2026-03-18-homebrew-core-prep.md README.md
git commit -m "docs: add homebrew-core preparation plan"
```

## Chunk 3: Next Execution Handoff

### Task 3: Prepare the first release implementation follow-up

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Add a short release roadmap note**

Explain that the next operational milestones are:

- create the first tag
- publish the first GitHub Release
- draft the Homebrew formula

- [ ] **Step 2: Verify the roadmap note is visible**

Run: `rg -n "Homebrew|v0.1.0|Release" README.md`
Expected: the release and Homebrew preparation note appears in the README.

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: note release and homebrew follow-up"
```
