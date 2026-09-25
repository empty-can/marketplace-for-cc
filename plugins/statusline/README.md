# statusline

Claude Code のプロンプト下部に、複数行のステータスラインを表示する Plugin です。

表示例:

```text
v2.1.282 | Opus 5.5 [1M] | effort:H | Ctx:12% [1m] | limits:20%/5h(rst@18:00),35%/7d
prj: C:/cc-workspace/my-repo | branch:main | remote https://github.com/owner/my-repo
```

- 1 行目: バージョン・モデル・effort・コンテキスト使用率・レート制限などの実行状況
  - effort は `L`（low）/ `M`（medium）/ `H`（high）/ `xH`（xhigh）/ `Max`（max）/ `Ult`（ultracode）と短縮表示します
  - レート制限の情報が取得できない環境では `limits: -` と表示します
- 2 行目: プロジェクト・カレントディレクトリ・ブランチ・リモート・PR などの作業場所
- 3 行目: `/add-dir` で追加したディレクトリ（ある場合のみ）

どのリポジトリで Claude Code を起動しても同じレイアウトで表示できるよう、**ユーザースコープでのインストール**を前提にしています。

## 前提

| 必要なもの | 備考 |
|---|---|
| bash | Windows は Git Bash（Claude Code が statusline とフックの実行に使用）。WSL / macOS / Linux は標準の bash |
| Python 3.7 以上 | `python3` → `python` の順に、起動できるものを使います |
| git | ブランチ名の表示に使います（無くても他の項目は表示されます） |

## インストールと有効化

1. Marketplace を追加し、Plugin をユーザースコープでインストールします。

   ```text
   /plugin marketplace add empty-can/marketplace-for-cc
   /plugin install statusline@empty-can
   ```

   インストール時にスコープを聞かれたら **user** を選びます。

2. ユーザー設定 `~/.claude/settings.json` に次を追記します（既に `statusLine` がある場合は置き換えます）。

   ```json
   "statusLine": {
     "type": "command",
     "command": "bash ~/.claude/plugins/data/statusline-empty-can/statusline.sh"
   }
   ```

3. Claude Code を再起動します。

   Plugin は、セッション開始時にスクリプトを上記のパスへコピーします。インストール直後は、起動してから最初に表示されるまで少し遅れることがあります。何か操作しても表示されない場合は、もう一度 Claude Code を起動し直してください。

## 更新

```text
/plugin marketplace update empty-can
/plugin update statusline@empty-can
```

更新後に Claude Code を起動し直すと、新しいスクリプトで表示されます。`settings.json` の変更は不要です。

## 表示されないとき

まず、`~/.claude/plugins/data/statusline-empty-can/statusline.sh` が存在するか確認してください。

存在しない場合は、Plugin 内のスクリプトを手動でコピーし、`statusLine` をそのコピー先に向けることで表示できます。

1. インストール先の `scripts/statusline.sh` を `~/.claude/statusline.sh` にコピーします。インストール先は `~/.claude/plugins/cache/empty-can/statusline/<バージョン>/` です。
2. `~/.claude/settings.json` の `statusLine.command` を `bash ~/.claude/statusline.sh` に変更します。

この方法では Plugin を更新しても表示は変わらないため、更新のたびにコピーし直してください。

> hooks の仕組みが無効化されている場合は動作しない可能性があります。

## アンインストール

```text
/plugin uninstall statusline@empty-can
```

アンインストールするとコピー先のスクリプトも削除されるので、`~/.claude/settings.json` の `statusLine` も削除してください。
