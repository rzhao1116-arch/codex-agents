# codex-agents Homebrew-Core Submission Draft

## Goal

Capture the minimum path from the current `v0.1.0` release and formula draft to a real `homebrew-core` submission attempt.

## Current Inputs

- Release tag: `v0.1.0`
- Release URL: `https://github.com/rzhao1116-arch/codex-agents/archive/refs/tags/v0.1.0.tar.gz`
- Release SHA256: `338fec4c56d93ea39b0c14bdf86769287562c348a0f52b5f8c7f6eeb57059bbc`
- Draft formula: `Formula/codex-agents.rb`

## Local Validation Path

Because current Homebrew releases reject `brew install ./Formula/...` for non-tap local formulae, the practical local validation path is:

1. `bash tests/homebrew_formula_release_alignment.sh`
2. `bash tests/homebrew_formula_temp_tap_roundtrip.sh`
3. `bash tests/homebrew_formula_audit_in_temp_tap.sh`

These checks verify:

- the formula URL and checksum match the tagged GitHub release
- the formula can install and pass `brew test` inside a temporary tap
- the formula survives `brew audit --strict --new` in a tap-shaped environment

## Submission Checklist

Before opening a real `homebrew-core` PR:

1. Cut the release tag and GitHub Release first
2. Update the formula tarball URL and `sha256`
3. Re-run the three Homebrew validation scripts
4. Confirm the formula still installs the repository bundle into `libexec`
5. Confirm `brew test` still uses a temporary target instead of the developer's existing `~/.codex`
6. Copy the formula into a Homebrew fork branch and open the `homebrew-core` PR

## Known Constraints

- `version` still reports the repo short SHA rather than a semantic version string
- current validation is designed around source install, not bottles
- the formula draft is intentionally minimal and should stay focused on stable install/test behavior before adding polish
