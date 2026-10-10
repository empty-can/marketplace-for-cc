# pre-compact

`/compact` または `/clear` を実行する前に、次のセッションで作業を再開できる状態を整える skill です。メインセッションの会話コンテキストを踏まえて Claude 自身が準備を行うため、hook ではなく skill として実装しています。

実行すると、次の順で処理します。

1. 終了方式の判定（silent）: 会話の状況から `/clear`（ファイルだけで再開できる）か `/compact`（会話要約が必要）かを決めます
2. 未コミット変更の確認: 変更があればコミットメッセージ案と対象ファイルを提示します
3. 方式別の準備（silent）: `/compact` なら長期事実だけを auto memory に反映し、`/clear` なら進行中タスクの状態と次アクションを memory ファイルと `MEMORY.md` の索引行に外部化します
4. 終了方式の提示: 推奨方式と、`/compact` の場合は `/compact <指示>` にそのまま渡せる英語の指示文を提示します

出力するのは未コミット変更と最終提案だけで、途中経過は表示しません。

## 前提

- auto memory が有効なこと（既定で有効。`/memory` で確認できます）。memory ファイルの保存先は `~/.claude/projects/<project>/memory/` です
- git。未コミット変更の確認に使います

## インストール

```text
/plugin marketplace add empty-can/marketplace-for-cc
/plugin install pre-compact@empty-can
```

どのリポジトリでも使えるよう、スコープを聞かれたら **user** を選びます。

## 使い方

呼び出し名は `/pre-compact:pre-compact` です。同じ名前の skill が他に無ければ、短い `/pre-compact` でも起動できます。

この skill は memory ファイルを書き換えるため、Claude が自分の判断で起動することはありません（`disable-model-invocation: true`）。起動の形は 2 つです。

| 書き方 | 動作 |
|---|---|
| メッセージ先頭に `/pre-compact:pre-compact` | すぐに実行されます |
| 指示文の途中に `/pre-compact:pre-compact`（例: 「ここまでをコミットしたら /pre-compact:pre-compact を実行して」） | そのターンの中で Claude が実行できます |

スラッシュ無しで「pre-compact」と書いても起動の許可にはなりません。

提示された方式に従って `/compact <指示文>` または `/clear` を実行してください。

## 更新

```text
/plugin marketplace update empty-can
/plugin update pre-compact@empty-can
```

## アンインストール

```text
/plugin uninstall pre-compact@empty-can
```
