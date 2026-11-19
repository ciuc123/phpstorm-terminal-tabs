#!/usr/bin/env bash
# One command to publish a version:  ./release.sh 1.0.1
# First run also creates the public GitHub repo ciuc123/phpstorm-terminal-tabs (needs `gh auth login`).
# GitHub Actions then builds dist/terminal-tab-switch.zip and attaches it to release v<version>.
set -euo pipefail
cd "$(dirname "$0")"
VERSION="${1:?usage: ./release.sh <version>, e.g. ./release.sh 1.0.1}"
REPO=ciuc123/phpstorm-terminal-tabs
TAG="v$VERSION"

[[ -z "$(git status --porcelain)" ]] || { echo "Commit or stash your changes first." >&2; exit 1; }
git rev-parse -q --verify "refs/tags/$TAG" >/dev/null && { echo "Tag $TAG already exists." >&2; exit 1; }

if ! git remote get-url origin >/dev/null 2>&1; then
  gh repo create "$REPO" --public \
    --description "Alt+Left/Right tab switching back in the PhpStorm 2026.3+ terminal (Windows/Linux)" \
    --homepage "https://ciuculescu.com/posts/2026-11-19-phpstorm-terminal-alt-left-right-plugin/"
  # SSH host alias for the ciuc123 account (see ~/.ssh/config)
  git remote add origin "git@github.com-ciuc123:$REPO.git"
fi

git push -u origin HEAD
git tag -a "$TAG" -m "$TAG"
git push origin "$TAG"
echo "Pushed $TAG. Release builds at https://github.com/$REPO/actions"
echo "Download link: https://github.com/$REPO/releases/latest/download/terminal-tab-switch.zip"
