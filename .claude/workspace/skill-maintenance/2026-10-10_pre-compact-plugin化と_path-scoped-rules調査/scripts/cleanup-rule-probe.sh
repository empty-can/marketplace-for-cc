#!/usr/bin/env bash
# setup-rule-probe.sh が作った fixture をすべて消す。
# 使い方: リポジトリルートで  bash <このファイル> [prefix]
set -euo pipefail
P="${1:-zz-probe}"
rm -f .claude/rules/"$P"-rule-*.md
rm -rf ".claude/skills/$P-skill-paths" ".claude/skills/$P-skill-plain" .tmp-probe
git status --short
echo "(cleanup done: prefix=$P)"
