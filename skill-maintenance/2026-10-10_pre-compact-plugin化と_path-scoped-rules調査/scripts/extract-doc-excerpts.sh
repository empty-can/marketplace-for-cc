#!/usr/bin/env bash
# 公式 docs ミラー（llms-full.txt）から、本調査で根拠にした箇所を原文のまま抜き出して
# sources/official-docs-excerpts.md に書き出す。
#
# 行番号ではなく「見出し（行頭文字列）の n 番目の出現」を起点に N 行を取るので、
# ミラーが更新されて行番号がずれても同じ節を取り出せる。見出し自体が変わった場合は
# 「ANCHOR NOT FOUND」と出力されるので、その節は人が探し直す。
#
# 使い方: bash scripts/extract-doc-excerpts.sh [llms-full.txt のパス]
set -euo pipefail

DOC="${1:-/c/cc-workspace/LLMs/official-llms-txts/code.claude.com/docs/llms-full.txt}"
OUT="$(cd "$(dirname "$0")/.." && pwd)/sources/official-docs-excerpts.md"

{
  echo "# 公式 docs 抜粋（根拠箇所の原文）"
  echo
  echo "- 取得元: \`$DOC\`"
  echo "- ミラーの更新日時: $(stat -c '%y' "$DOC")"
  echo "- ミラーの行数: $(wc -l < "$DOC")"
  echo "- 抽出日時: $(date '+%Y-%m-%d %H:%M:%S %z')"
  echo "- 抽出スクリプト: \`scripts/extract-doc-excerpts.sh\`（見出しを起点に抽出。行番号はミラー更新でずれる）"
  echo
  echo "各ブロックの行頭の数字は、抽出時点の llms-full.txt の行番号。"
  echo
} > "$OUT"

# block "<見出し>" "<出現順 1 始まり>" "<行数>" "<ラベル>"
block() {
  local anchor="$1" nth="$2" count="$3" label="$4"
  local from
  from=$(grep -n -F -- "$anchor" "$DOC" | awk -F: -v n="$nth" 'NR==n{print $1}')
  {
    echo "---"
    echo
    if [ -z "$from" ]; then
      echo "## $label — ANCHOR NOT FOUND: \`$anchor\` (#$nth)"
      echo
      return
    fi
    local to=$((from + count - 1))
    echo "## $label（$from-$to 行、起点: \`$anchor\` #$nth）"
    echo
    echo '```text'
    sed -n "${from},${to}p" "$DOC" | nl -ba -v "$from" -w 6 -s ': '
    echo '```'
    echo
  } >> "$OUT"
}

# --- /compact・/clear・圧縮まわり ---
block 'For more control, run `/compact <instructions>`' 1 3 "best-practices: /compact の指示例と CLAUDE.md の圧縮指示（pre-compact skill が引用する公式情報）"
block "## What survives compaction" 1 46 "context-window: What survives compaction"
block '| `/clear [name]`' 1 5 "commands: /clear と /compact の行"
block '| `/reload-plugins [--force]`' 1 3 "commands: /reload-plugins /reload-skills"
block '### Instructions seem lost after `/compact`' 1 8 "memory: Instructions seem lost after /compact"
block "### Rewind and summarize" 1 30 "checkpointing: Rewind and summarize"
block "### Compact history with \`/compact\`" 1 6 "agent-sdk: /compact（SDK からの実行）"
block "### Reset context with \`/clear\`" 1 6 "agent-sdk: /clear"

# --- memory / rules / nested CLAUDE.md ---
block "## CLAUDE.md vs auto memory" 1 16 "memory: CLAUDE.md vs auto memory"
block 'Claude also discovers `CLAUDE.md` and `CLAUDE.local.md` files in subdirectories' 1 6 "memory: nested CLAUDE.md の読み込み条件"
block "#### Path-specific rules" 1 60 "memory: Path-specific rules と Rule frontmatter reference"
block "## Auto memory" 1 90 "memory: Auto memory（保存先・MEMORY.md の制限）"
block "## Edit tool behavior" 1 16 "tools-reference: Edit tool の read-before-edit と Bash で読み取り扱いになるコマンド"
block "## Glob tool behavior" 1 12 "tools-reference: Glob / Grep ツールの既定の有無"
block "### InstructionsLoaded" 1 50 "hooks: InstructionsLoaded"
block "Keep these constraints in mind when designing hooks" 1 6 "hooks: hook の制約（/ コマンドやツール呼び出しは起動できない）"
block "### PreCompact" 1 30 "hooks: PreCompact"

# --- skills（skills ページは '# Extend Claude with skills' 以降。Frontmatter reference は 1 番目の出現がそれ） ---
block "### Frontmatter reference" 1 60 "skills: Frontmatter reference（paths / disable-model-invocation / user-invocable 等）"
block "#### How a skill gets its command name" 1 25 "skills: How a skill gets its command name（Plugin 名前空間と bare 名）"
block "### Control who invokes a skill" 1 50 "skills: Control who invokes a skill / Where you write the skill's name"
block "### Skill content lifecycle" 1 12 "skills: Skill content lifecycle（圧縮後の再注入上限）"
block "### Resolve skills that share a name" 1 18 "skills: Resolve skills that share a name"
block "### Edit a skill during a session" 1 10 "skills: Edit a skill during a session（ライブ変更検知）"
block "## Evaluate and iterate on a skill" 1 30 "skills: Evaluate and iterate on a skill / Run evals with skill-creator"
block "### Skill not triggering" 1 38 "skills: Skill not triggering / too often / stops following / descriptions cut short"
block "You can't preload skills that set" 1 4 "sub-agents: preload skills と disable-model-invocation"

# --- plugins（create ページの見出しは 2 回出現する。1 番目が本文） ---
block "# Create a Claude Code plugin" 1 100 "plugins/create: 冒頭〜Create your first plugin（名前空間・disable-model-invocation）"
block "### Plugin layout" 1 22 "plugins/create: Plugin layout の注意（.claude-plugin には plugin.json だけ）"
block "### Make a plugin load in every session" 1 28 "plugins/create: skills-dir plugin とルート SKILL.md の呼び名"
block "## Test and debug" 1 18 "plugins/create: Test and debug"
block "### Skills" 1 42 "plugins/components: Skills（ルート SKILL.md・CLAUDE.md は読まれない）"
block "### Keep the entry name and the manifest name the same" 1 72 "plugins/create-marketplace: entry 名と manifest 名 / Validate and test"
block "## Prepare your plugin for release" 1 40 "plugins/publish: Prepare your plugin for release"
block "## Ship updates, renames, and removals" 1 22 "plugins/publish: Ship updates, renames, and removals"
block "### Release a new version" 1 36 "plugins/host-marketplace: Release a new version / Hold users on one version"
block "## Versions and updates" 1 36 "plugins/loading: Versions and updates"
block "## Name conflicts" 1 22 "plugins/loading: Name conflicts"
block 'The table lists the top-level keys in `plugin.json`' 1 60 "plugins/manifest-reference: Fields 表（name / displayName / version 等）"
block "### \`version\`" 1 6 "plugins/manifest-reference: version"
block "## Standard layout" 1 22 "plugins/manifest-reference: Standard layout（rules というコンポーネントは無い）"
block "## Plugin entries" 1 30 "plugins/marketplace-reference: Plugin entries"
block "### plugin eval" 2 80 "plugins/cli-reference: plugin eval（2 番目の出現が cli-reference）"
block "### plugin tag" 1 44 "plugins/cli-reference: plugin tag"
block "### plugin validate" 1 60 "plugins/cli-reference: plugin validate"
block "### Skill loads but Claude never invokes the skill" 1 12 "plugins/troubleshooting: Skill loads but Claude never invokes the skill"
block "# Test plugins with evals" 1 50 "plugin-evals: 冒頭〜Requirements〜How an eval run works"
block "### Seed the workspace or conversation" 1 24 "plugin-evals: Seed the workspace or conversation"
block "### How runs are isolated" 1 11 "plugin-evals: How runs are isolated"
block "## Measure what a plugin costs" 1 30 "plugins/measure: Measure what a plugin costs"

# --- changelog（grep 結果。バージョンは直上の <Update label> から取得） ---
{
  echo "---"
  echo
  echo "## changelog 抜粋（grep 結果）"
  echo
  echo "### path-scoped rules / nested CLAUDE.md / paths: 関連"
  echo
  echo '```text'
  awk '/<Update label="/{match($0,/label="[0-9.]+"/);v=substr($0,RSTART+7,RLENGTH-8)} NR<14000 && /paths?:|path-scoped|path-specific|scoped rule|rules\// {print v": "substr($0,1,300)}' "$DOC"
  echo '```'
  echo
  echo "### disable-model-invocation と文中 /skill 言及"
  echo
  echo '```text'
  awk '/<Update label="/{match($0,/label="[0-9.]+"/);v=substr($0,RSTART+7,RLENGTH-8)} NR<14000 && /disable-model-invocation|mid-message/ {print v": "substr($0,1,300)}' "$DOC"
  echo '```'
  echo
  echo "### compact / clear 関連（2.1.285 以降。上限行はミラーにより調整）"
  echo
  echo '```text'
  awk '/<Update label="/{match($0,/label="[0-9.]+"/);v=substr($0,RSTART+7,RLENGTH-8)} /<Update label="2\.1\.284"/{exit} tolower($0) ~ /compact|\/clear|autocompact/ && !/compact JSON/ && v!="" {print v": "substr($0,1,300)}' "$DOC"
  echo '```'
  echo
  echo "### 各 Update のリリース日（本調査で参照した版）"
  echo
  echo '```text'
  grep -n -o -E '<Update label="2\.1\.(110|176|198|269|287|288|293|294|295|296)" description="[^"]+"' "$DOC"
  echo '```'
  echo
} >> "$OUT"

echo "wrote $OUT ($(wc -l < "$OUT") lines)"
grep -c "ANCHOR NOT FOUND" "$OUT" || true
