#!/usr/bin/env bash
# SessionStart hook: statusline.sh を ${CLAUDE_PLUGIN_DATA} へコピーする。
#
# Plugin のキャッシュパスは更新のたびに変わるため、settings.json からは
# 更新後も変わらないデータディレクトリを参照させる。
#
# 何も出力せず、常に exit 0 で終えること。SessionStart の標準出力は Claude の
# コンテキストに追加され、ここでの失敗でセッションを妨げてはならないため。
# 失敗しても前回コピーしたスクリプトで表示は続く。

src="${CLAUDE_PLUGIN_ROOT:-}/scripts/statusline.sh"
dst_dir="${CLAUDE_PLUGIN_DATA:-}"

if [ -z "${CLAUDE_PLUGIN_ROOT:-}" ] || [ -z "$dst_dir" ] || [ ! -f "$src" ]; then
    exit 0
fi

dst="$dst_dir/statusline.sh"

# 内容が同じなら書き込まない（cmp が無い環境ではコピーに進む）
if cmp -s "$src" "$dst" 2>/dev/null; then
    exit 0
fi

# 一時ファイルに書いてから置き換える。同時に走るステータスラインの更新が
# 書きかけのスクリプトを読まないようにするため
mkdir -p "$dst_dir" 2>/dev/null \
    && cp "$src" "$dst.tmp.$$" 2>/dev/null \
    && mv -f "$dst.tmp.$$" "$dst" 2>/dev/null
rm -f "$dst.tmp.$$" 2>/dev/null

exit 0
