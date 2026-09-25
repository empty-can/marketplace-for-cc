# CLAUDE.md（共通指示）

本リポジトリにおける共通的作業の Claude Code 指示。

## plugin開発規約

根拠は公式 docs の `plugin-marketplaces` / `plugins` / `plugins-reference`（参照方法は末尾の節）。

### リポジトリ構成

```text
<repo>/
├── .claude-plugin/marketplace.json   # Marketplace カタログ（リポジトリルート直下）
└── plugins/<plugin-name>/            # Plugin 本体（1 Plugin = 1 ディレクトリ）
```

- `marketplace.json` の必須項目は `name` / `owner`（`owner.name` 必須）/ `plugins`。`description` も書く（無いと validate が警告）
- **Marketplace の `name` と `owner.name` は、どちらも `empty-can` に固定する**（作業指示者のハンドルネーム）。したがってインストール時の指定は `/plugin install <plugin-name>@empty-can` になる
  - Marketplace 名の制約: kebab-case であること。公式予約名（`claude-plugins-official` 等）、公式を装う名前、`npm` / `github` 等は使えない
- 各エントリの `source` は `"./plugins/<plugin-name>"` と `./` 付きの相対パスで書く。`metadata.pluginRoot` による bare name 指定は claude.ai の Organization 配布で拒否されるため使わない
- `strict` は既定（`true`）のままにし、コンポーネント定義は各 Plugin の `plugin.json` 側に置く

### Plugin の中身

- `.claude-plugin/` に置くのは `plugin.json` だけ。`skills/` `agents/` `hooks/` 等はすべて Plugin ルート直下に置く（よくある誤り）
- スキルは `skills/<name>/SKILL.md` 形式で作る（`commands/` は旧形式）。呼び出し名は `/<plugin-name>:<skill-name>` と名前空間付きになる
- hook は `hooks/hooks.json` に書く（`settings.json` の `hooks` と同じ形式）
- Plugin の agent では `hooks` / `mcpServers` / `permissionMode` が無視される（セキュリティ上の制約）。それらが要る agent は Plugin にできない
- Plugin ルートの `CLAUDE.md` は読み込まれない。Claude に読ませたい指示は skill にする
- パスの書き方
  - コンポーネントのパスは `./` 始まりの相対パスで、区切りは `/`。バックスラッシュを含むパスは macOS / Linux で拒否される
  - `../` で Plugin の外を参照しない。インストール時に Plugin ディレクトリだけがキャッシュへコピーされるため、外のファイルは届かない。Marketplace 内で共有したいファイルはシンボリックリンクで扱う
  - 同梱するスクリプトは `${CLAUDE_PLUGIN_ROOT}`、更新をまたいで残す状態や依存物は `${CLAUDE_PLUGIN_DATA}` で参照する。`${CLAUDE_PLUGIN_ROOT}` は更新のたびに変わるので書き込み先にしない
  - 実行ファイルは `bin/` ではなく `scripts/` 等に置く。トップレベルの `bin/` があると claude.ai の Organization 配布で拒否される
- `plugin.json` などの JSON は UTF-8（BOM なし）で保存する（v2.1.246 未満は BOM 付き `plugin.json` を壊れたマニフェストとして扱う）。文字コード全般は下の「Windows 向けファイルの文字コード」節に従う
- Git LFS は使わない。Marketplace の clone では LFS の実体が取得されない

### ローカルでの開発・検証

| 目的 | コマンド |
|---|---|
| Plugin を単体で読み込んで試す | `claude --plugin-dir ./plugins/<plugin-name>`（`--plugin-dir ./plugins` で全 Plugin） |
| 変更をセッションに反映する | `/reload-plugins` |
| Plugin の構文・スキーマを検証する | `claude plugin validate ./plugins/<plugin-name>` |
| Marketplace 全体を検証する | `claude plugin validate .`（リポジトリルートで実行） |
| Marketplace 経由のインストールを試す | `/plugin marketplace add ./` → `/plugin install <plugin-name>@empty-can` |
| 実際のプロンプトで効果を測る | `claude plugin eval ./plugins/<plugin-name>`（ケースの雛形は `claude plugin eval init`） |

- ルートで `validate .` を実行しても skill / agent / hook の中身は検査されない。Plugin ごとの `validate` も必ず実行する
- 本リポジトリの `.claude/agents/` にある agent と同じ名前の agent を Plugin に入れると、このリポジトリ内でのテストではプロジェクト側の定義が優先される。Plugin 側の agent を確かめるときは名前の衝突に注意する

## pluginリリース時の規約

### バージョン管理

- バージョンは `plugin.json` の `version` に明示し、semver（`MAJOR.MINOR.PATCH`）で管理する。破壊的変更は MAJOR、機能追加は MINOR、修正は PATCH を上げる
  - 軽微な修正も PATCH を上げてリリースする。4 桁目（`0.9.0.1`）や `+` のビルドメタデータ（`0.9.0+1`）は付けない。4 桁は `claude plugin tag` に拒否され、`+` 以降は semver の順序比較で無視されるため
  - 検証中の版を区別したい場合はプレリリース表記（`0.9.1-rc.1`。通常版 `0.9.1` より古い扱い）を使う
- **リリースのたびに必ず `version` を上げる**。上げずに push すると、利用者側では「最新」と判定されて更新が届かない
- `version` は `plugin.json` だけに書き、`marketplace.json` のエントリには書かない。両方に書くと常に `plugin.json` が優先され、食い違っても警告が出ない
- 変更内容は Plugin ごとの `CHANGELOG.md` に記録する

### 名前の変更・削除

- Plugin の `name` は利用者の設定（`enabledPlugins` 等）から参照される固定の識別子。表示名だけ変えたいときは `displayName` を使う
- `name` を変えるときや Plugin を削除するときは、`marketplace.json` の `renames` に `旧名: 新名`（削除なら `null`）を追記する。`renames` は追記専用で、過去の行を書き換えない

### リリース手順

1. `plugin.json` の `version` を上げ、`CHANGELOG.md` を更新する
2. `claude plugin validate ./plugins/<plugin-name>` と `claude plugin validate .` を実行する（CI では `--strict` を付け、警告も失敗扱いにする）
3. 変更を main に取り込む（下の「Git ワークフロー」参照）
4. main 上で Plugin ディレクトリに移動し、`claude plugin tag --push` でリリースタグ `{plugin-name}--v{version}` を作成・push する
   - このコマンドは Plugin の検証、`plugin.json` と Marketplace エントリのバージョン一致、作業ツリーの clean を確認してからタグを作る
   - このタグ規約は、他の Plugin がバージョン範囲付きで依存するときの解決に使われる
5. 公開済みタグは付け替えない（force-move しない）

## Git ワークフロー

- **main は常にリリース可能な状態に保つ**。利用者が `/plugin marketplace add <owner>/<repo>` で追加するとデフォルトブランチ（main）を追跡し、バックグラウンドの自動更新でも取り込まれる。validate に通らない状態を main に置かない
- 作業は main から切ったブランチで行う。main への直接コミットはしない
- ブランチ名は `<種別>/<内容>` 形式にする（例: `feat/<plugin-name>-xxx`、`fix/...`、`chore/...`、`docs/...`）
- **PR を作るのは、Plugin を作成・変更するブランチを main へマージするときだけ**（`/commit-and-pr` skill を利用できる）
- それ以外のブランチ（`.claude/` の整備やドキュメント修正など）は PR を作らない。main へのマージは作業指示者が手動で行うので、Claude は勝手に main へマージしない
- Claude は作業ブランチへの commit と push まで行ってよい（誤って push しても作業指示者が revert 等で対処する）。main への push はしない
- 本リポジトリは GitHub で public だが、想定利用者は作業指示者本人である。広く一般に公開する水準の品質やユースケースは前提にしない（上記の PR 運用も private リポジトリ相当の扱い）
- リリースタグ（`{plugin-name}--v{version}`）は main 上のコミットにだけ付ける
- `stable` / `latest` のようなリリースチャネルが必要になったら、同じリポジトリの別 ref を指す Marketplace を 2 つ用意する方式を採る（公式 `plugin-marketplaces` の「release channels」）。チャネル同士は異なるバージョンに解決される必要がある

## マルチエージェント戦略

### Skills（メインセッションで実行）

| Skill | 用途 | 起動 |
|---|---|---|
| `check-model` | 現在の作業に対して今のモデルが適切かを評価し、合っていなければ切り替えを提案する | 自動 / 手動 |
| `pre-compact` | `/compact` の前に、メモリの更新・未コミット変更の確認・保留タスクの整理を行う | 自動 / 手動 |
| `win-file-encoding` | CP932 と UTF-8 の一括変換・検査。日常の `.bat` 編集では不要（hook が自動処理） | 自動 / 手動 |
| `commit-and-pr` | 変更をコミットして push し、PR を作成する | **手動のみ**（`/commit-and-pr`） |
| `orchestrate` | 複数の専門エージェントを協調させる（並列調査・段階的レビュー等） | **手動のみ**（`/orchestrate`） |

### Sub-agents（隔離コンテキストで実行）

| Agent | モデル | 用途 | 書き込み |
|---|---|---|---|
| `code-reviewer` | sonnet | 品質・セキュリティ・保守性・テストの観点でのコードレビュー。大きな変更の後に使う | 不可（Read / Grep / Glob / git diff 等のみ） |
| `cve-investigator` | sonnet | 既知 CVE のトリアージで、調査単位を 1 つだけ担当する | 調査対象のファイルは変更しない |
| `cve-cross-reviewer` | opus | CVE トリアージ報告書の草稿を、一次情報から独立に検証する | 不可（Edit / Write 禁止） |

- sub-agent / background Agent に作業を任せる前に、必要な権限を事前に洗い出して照合する（`.claude/rules/agent-permission-runtime.md`）


## Windows 向けファイルの文字コード

`.ps1` は **UTF-8 + BOM + CRLF**、`.bat` は **CP932 + CRLF**（BOM なし）で保存する。**`.bat` は Claude のファイルツールで直接扱えない**（UTF-8 前提のため、読むと文字化けし、書くと壊す）。

- **読む**: 普通に `Read` してよい。hook が UTF-8 の作業コピーへ差し替える
- **編集する**: 原本ではなく作業コピー（`.claude/.bat-shadow/…`）を `Edit` する。保存すると CP932 へ書き戻る
- **新規作成する**: `python .claude/hooks/bat_cp932_guard.py new <path>.bat`
- **`.bat` を Bash のリダイレクト・heredoc・`sed -i` で作成/編集してはならない**（hook が守れず、UTF-8 の
  壊れた `.bat` が生まれる。cmd.exe は 1 行目から誤動作する）

> このルールは**新規作成時にも効かせる必要がある**ためここに置いてある（`.claude/rules/win-file-encoding.md`は 
> path-scoped で、**既存ファイルを読んだ時にしかロードされない**）。詳細・根拠は同 rule を参照。
> hook には Python（3.10+）が要る。無い環境では `.bat` は読めないが、`permissions.deny` により編集は常に拒否されるので**原本が壊れることはない**。

## 重要な制約

- `.env` ファイルを直接編集しない。環境変数は実行環境から参照する
- API キー・パスワード等の機密情報をコードにハードコードしない
- 機密情報は `secrets/` 等へ隔離し、`.gitignore` で除外する（**除外されているかは各リポジトリで確認する**）
- DB マイグレーション等の破壊的操作は必ず確認を取ってから実行する

## Claude Code に関する公式ドキュメントのローカル参照先

1. `C:\cc-workspace\LLMs\official-llms-txts\code.claude.com\docs\llms.txt`
2. `C:\cc-workspace\LLMs\official-llms-txts\code.claude.com\docs\llms-full.txt`

なお、ファイル 2. は 1MB近くあるので、ファイル1.で関連見出し名を特定するか、Grepでキーワード検索し該当行番号を取得してから、offset付きのReadで読むこと。