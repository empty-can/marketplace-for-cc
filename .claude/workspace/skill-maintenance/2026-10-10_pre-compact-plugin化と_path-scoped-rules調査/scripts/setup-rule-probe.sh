#!/usr/bin/env bash
# path-scoped rule / paths: 付き skill / 入れ子 CLAUDE.md の発火テスト用 fixture を作る。
#
# 使い方: リポジトリルートで  bash <このファイル> [prefix]
#   prefix 省略時は "zz-probe"。同名が既にあれば上書きする。
#
# 作られるもの（すべて一時物。cleanup-rule-probe.sh で消す）:
#   .claude/rules/<prefix>-rule-{A..F}.md   paths: "**/*.pA" … "**/*.pF" の rule 6 本（テスト 1 件に 1 本割り当てる）
#   .claude/skills/<prefix>-skill-paths/    paths: "**/*.sP" 付き skill
#   .claude/skills/<prefix>-skill-plain/    paths 無しの対照 skill
#   .tmp-probe/                              対象ファイル群と入れ子 CLAUDE.md（2 階層）
#
# 重要: rule は「1 セッションに 1 rule 1 回」しか注入されない（検証済み）。
#       1 つの rule で 2 つのアクセス方法を試すと 2 つ目が必ず陰性に見えるので、
#       テストごとに別の rule（別の拡張子）を使うこと。
set -euo pipefail
P="${1:-zz-probe}"

mkdir -p .claude/rules ".claude/skills/$P-skill-paths" ".claude/skills/$P-skill-plain" .tmp-probe/nested/sub/deep

for x in A B C D E F; do
  printf -- '---\npaths:\n  - "**/*.p%s"\n---\n\nSENTINEL-RULE-%s-%s: path-scoped rule %s loaded.\n' "$x" "$P" "$x" "$x" > ".claude/rules/$P-rule-$x.md"
  printf 'target %s\n' "$x" > ".tmp-probe/t.p$x"
  printf 'target %s second\n' "$x" > ".tmp-probe/u.p$x"
done

printf -- '---\nname: %s-skill-paths\ndescription: probe skill with paths frontmatter\npaths:\n  - "**/*.sP"\n---\n\nSENTINEL-SKILL-PATHS-%s\n' "$P" "$P" > ".claude/skills/$P-skill-paths/SKILL.md"
printf -- '---\nname: %s-skill-plain\ndescription: probe skill without paths (control)\n---\n\nSENTINEL-SKILL-PLAIN-%s\n' "$P" "$P" > ".claude/skills/$P-skill-plain/SKILL.md"
printf 'skill target\n' > .tmp-probe/s1.sP
printf 'skill target 2\n' > .tmp-probe/s2.sP

printf '# nested L1\n\nSENTINEL-NESTED-L1-%s\n' "$P" > .tmp-probe/nested/CLAUDE.md
printf '# nested L2\n\nSENTINEL-NESTED-L2-%s\n' "$P" > .tmp-probe/nested/sub/CLAUDE.md
printf 'deep file\n' > .tmp-probe/nested/sub/deep/f.txt

echo "fixture ready (prefix=$P). 手順は 検証/発火テスト手順書.md を参照。"
find .tmp-probe -type f | sort
ls ".claude/rules" | grep "^$P-" || true
