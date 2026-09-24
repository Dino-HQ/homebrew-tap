#!/bin/bash
# Points Formula/dino.rb at a Dino-HQ/dino release: rewrites each download URL's version
# and the sha256 under it, from that release's SHA256SUMS.
# Usage: scripts/update-formula.sh [version]   (default: the latest release)
set -euo pipefail

REPO="Dino-HQ/dino"
FORMULA="Formula/dino.rb"
cd "$(dirname "$0")/.."

VERSION="${1:-}"
if [[ -z "${VERSION}" ]]
then
  VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | sed -n 's/.*"tag_name": *"v\{0,1\}\([^"]*\)".*/\1/p' | head -1)
fi
if [[ ! "${VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
then
  echo "not a release version: '${VERSION}'" >&2
  exit 1
fi

export SUMS
SUMS=$(curl -fsSL "https://github.com/${REPO}/releases/download/v${VERSION}/SHA256SUMS")

awk -v version="${VERSION}" -f scripts/update-formula.awk "${FORMULA}" >"${FORMULA}.new" || {
  rm -f "${FORMULA}.new"
  exit 1
}
mv "${FORMULA}.new" "${FORMULA}"
echo "${FORMULA} -> v${VERSION}"
