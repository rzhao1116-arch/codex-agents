# codex-agents v0.1.0 Release Checklist

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship the first versioned public release, `v0.1.0`, with enough metadata and release notes to support a credible Homebrew formula draft.

**Architecture:** Treat the repository as the source of truth, publish a Git tag and GitHub Release from `main`, and make sure the release notes and verification artifacts clearly describe what users get and how to validate the CLI after install.

**Tech Stack:** git tags, GitHub Releases, bash CLI, Homebrew formula preparation

---

## Chunk 1: Release Gate

### Task 1: Confirm the repository is ready to tag

**Files:**
- Modify: `README.md`
- Reference: `docs/releases/v0.1.0.md`

- [ ] **Step 1: Verify the release docs exist and are current**

Run:

```bash
test -f docs/releases/v0.1.0.md
test -f docs/plans/2026-03-18-homebrew-core-prep.md
```

Expected: both files exist.

- [ ] **Step 2: Verify the current CLI surface matches the release notes**

Run:

```bash
codex-agents version
codex-agents list
codex-agents status --json
codex-agents doctor --json --target /tmp/codex-agents-release-check || true
```

Expected:
- `version` prints a short SHA
- `list` prints bundled agents and `orchestrator-routing`
- `status --json` prints valid JSON
- `doctor --json` prints valid JSON, even if it exits non-zero for a missing target

- [ ] **Step 3: Verify the release branch is clean and based on `main`**

Run:

```bash
git status --short --branch
```

Expected: no unexpected working tree changes remain before tagging.

## Chunk 2: Tag and Release

### Task 2: Publish `v0.1.0`

**Files:**
- Reference: `docs/releases/v0.1.0.md`

- [ ] **Step 1: Create the tag**

Run:

```bash
git tag v0.1.0
git push origin v0.1.0
```

Expected: the remote now contains `v0.1.0`.

- [ ] **Step 2: Create the GitHub Release**

Use the release notes draft from `docs/releases/v0.1.0.md` as the release body.

Expected:
- GitHub Release `v0.1.0` exists
- the release points at the `v0.1.0` tag

- [ ] **Step 3: Record the release asset URL and checksum input**

Capture the release tarball URL that Homebrew should consume and note that the next step is to compute the stable `sha256` from that release artifact.

## Chunk 3: Formula Follow-Up

### Task 3: Prepare the Homebrew formula draft

**Files:**
- Create: `Formula/codex-agents.rb` or equivalent draft location, depending on release workflow choice
- Reference: `docs/releases/v0.1.0.md`

- [ ] **Step 1: Define the minimal formula behavior**

The formula should:
- install the `codex-agents` executable into Homebrew's bin
- expose `codex-agents version`
- expose `codex-agents list`

- [ ] **Step 2: Define the first `test do`**

Use the smallest reliable test:

```ruby
test do
  assert_match version.to_s, shell_output("#{bin}/codex-agents version")
end
```

or an equivalent `list`-based assertion if version matching needs a different strategy.

- [ ] **Step 3: Open the formula work as the next implementation step**

Do not mix the release tagging work and the formula draft into one unreviewed step. Once `v0.1.0` exists, start the formula work on its own branch.
