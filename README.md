# Dino Homebrew tap

Install [Dino](https://usedino.dev), the deterministic verification layer for APIs:

```bash
brew install dino-hq/tap/dino
```

macOS and Linux, Apple Silicon/arm64 and Intel/x64. The formula installs the standalone `dino` binary from the [Dino-HQ/dino releases](https://github.com/Dino-HQ/dino/releases), checked against each release's `SHA256SUMS`. No Node.js needed. On x64 Linux without AVX2 it picks the baseline build.

Upgrade with `brew upgrade dino`. Other ways to install: [usedino.dev/docs/install](https://usedino.dev/docs/install).

## Maintenance

`.github/workflows/update.yml` checks for a new release every 6 hours (or run it by hand with a version). It runs `scripts/update-formula.sh`, proves the formula with `brew audit --strict`, `brew install` and `brew test`, and commits it. `tests.yml` installs and tests the formula on macOS (Apple Silicon and Intel) and Linux x64 for every push and PR. Both use only GitHub-owned actions and the Homebrew preinstalled on GitHub's runners.
