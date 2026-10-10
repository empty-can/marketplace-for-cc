# 01. pre-compact skill の Plugin 化 — 作業整理と実装記録

- 日付: 2026-10-10
- 環境: Claude Code 2.1.296 / Windows 11 / Git Bash / auto モード / モデル Fable 5.1
- 根拠にした公式 docs: ローカルミラー `C:\cc-workspace\LLMs\official-llms-txts\code.claude.com\docs\llms-full.txt`
  - **注意**: 本セッション中の 15:00 にミラーが更新され（119,210 行 → 120,369 行）、行番号がずれた。本文中の行番号は「旧ミラー」のもの。原文は `sources/official-docs-excerpts.md` に見出し起点で再抽出してあるので、そちらを正とする
- 成果物: ブランチ `feat/pre-compact`、commit `4733d90`（push 済み）。PR 作成・main マージ・タグ付けは作業指示者が行う

## 1. 前提として判明したこと

### 1.1 移植元は 3 版が併存していた

| 所在 | 内容 | 判断 |
|---|---|---|
| `cc-relative-info` リポジトリ `feature/LLMs` ブランチ `.claude/skills/pre-compact/SKILL.md`（commit `000b3f4`） | 122 行版。`/compact` と `/clear` の二分岐対応 | **採用**。作業指示者が「ローカルに散在する版のうち最新」と確認済み。`develop` には入っていない（`git branch --contains 000b3f4` → `feature/LLMs` のみ） |
| 同リポ `develop` | 1 世代前（`bcd3547`） | 不採用 |
| 本リポ `.claude/skills/pre-compact/SKILL.md` | 旧 96 行版 | 本リポジトリで実行するための実行用としてそのまま残す（§4 の運用ルール） |

統制ドキュメント（`claude-dir-sharing-governance/reports/04.資産インベントリ・統合/02.配布計画/配布計画_Plugin可否とリポジトリ割当.md` §判断 5）も「C-CRI 122 版を採用」と決めている。

### 1.2 統制ドキュメントの古い記述

配布計画は「`references/decision-flow.md` 同梱」と書いているが、122 行版はその参照を削除済みで、移植元ディレクトリにも `SKILL.md` しか無い。同梱物は `SKILL.md` 1 本。正本側の修正候補。

### 1.3 skill 本文が引用する公式情報は現行 docs と一致

- `/compact <instructions>`, like `/compact Focus on the API changes`（旧 2441 行、新 2450 行）
- `"When compacting, always preserve the full list of modified files and any test commands"`（旧 2443 行、新 2452 行）

## 2. 公式ドキュメントから導いた必要作業

根拠: Create a Claude Code plugin（旧 33207 行〜）、Plugin manifest reference（旧 79342 行〜）、Publish and distribute a plugin（旧 39762 行〜）、Skills の Frontmatter reference（旧 44188 行〜）、Create a marketplace（旧 33588 行〜）、Host and maintain a marketplace（旧 34028 行〜）。

1. **ディレクトリ**: `plugins/pre-compact/.claude-plugin/plugin.json` と `plugins/pre-compact/skills/pre-compact/SKILL.md` が最小構成。`.claude-plugin/` には `plugin.json` だけを置く。Plugin ルート直下に `SKILL.md` を置く単一 skill 形式もあるが、`claude plugin validate` はルートの `SKILL.md` を検査しない（cli-reference「plugin validate」）ため `skills/` 配下を採用
2. **`plugin.json`**: `name` 必須・kebab-case、`author` はオブジェクト型、`version` / `description` / `author` が欠けると `--strict` で失敗。`statusline` の `plugin.json` と同じ項目構成にした
3. **`marketplace.json` エントリ**: エントリ `name` は `plugin.json` の `name` と一致させる（「Keep the entry name and the manifest name the same」）。`source` は `"./plugins/pre-compact"`。`version` はエントリに書かない（両方に書くと `plugin.json` が優先され validate が警告）
4. **呼び出し名**: Plugin 経由は `/pre-compact:pre-compact`。同名の他コマンドが無ければ bare の `/pre-compact` でも起動できる（「How a skill gets its command name」表: `my-plugin/skills/review/SKILL.md` → `/my-plugin:review`、`name: fancy` なら `/my-plugin:fancy`、bare `/fancy` も衝突が無ければ可）。本リポ内では project skill の `pre-compact` が bare 名を取るため、`--plugin-dir` テストでは名前空間付きで呼ぶ
5. **Plugin ルートに `CLAUDE.md` を置かない**: 読み込まれず validate が警告する（components「Skills」節: `CLAUDE.md at the plugin root is not loaded as project context`）。利用者向け説明は `README.md`
6. **検証**: `claude plugin validate --strict ./plugins/pre-compact` と `claude plugin validate .` の両方。Marketplace 側の validate は Plugin 内部を検査しない
7. **ローカル Marketplace 経由のインストール**: 公式手順「Prepare your plugin for release」が必須ステップにしている
8. **バージョン**: 変えないと利用者に更新が届かない（「Release a new version」）

## 3. 本リポジトリの規約から追加される作業

- `plugins/pre-compact/CHANGELOG.md` を作り、移植元 commit `000b3f4` を出所として記録
- 作業ブランチ `feat/pre-compact` で commit と push まで行う
- PR 作成は `/commit-and-pr` の手動呼び出しのみ → push 後に止めて引き継ぐ
- main マージ後、main 上で `claude plugin tag --push` → タグ `pre-compact--v0.9.0`。公式 docs は「他 Plugin が依存する場合だけタグが要る」（「Tag a release」）が、本リポの規約はタグ付け必須なので規約に従う
- 本リポの `.claude/skills/pre-compact/`（旧版）と `.claude/CLAUDE.md` の Skills 表の更新は Plugin 変更ではないため、本来は別ブランチ扱い → 作業指示者の決定（§4）により更新不要となった

## 4. 作業指示者の決定事項

1. **`disable-model-invocation: true` を付ける**（§5 参照）。要件は「メインセッションへの指示文の中で実行を言及することが多いので、メインセッションのモデルが実行できる skill であって欲しい」＋「副作用の回避」
2. **初版は 0.9.0**（statusline と同じく実運用確認前は 0.x）
3. **`feature/LLMs` の 122 行版が最新であることは確認済み**
4. **運用ルール（本リポの基本運用として採用）**: 「Plugin 側と `.claude` 配下の skill 等の同期は作業指示者が行う前提とし、Claude Code 側は気にしなくて良い」。ルート `CLAUDE.md` と `.claude/CLAUDE.md` に追記した（commit `4733d90` に含む）

## 5. 「Claude が実行できる」と「副作用の回避」の両立方法（確定）

`disable-model-invocation: true` を付けた上で、作業指示者が**指示文の中に `/pre-compact:pre-compact` と書く**。

根拠（skills ページ「Where you write the skill's name」）:

| 書く場所 | 例 | 挙動 |
|---|---|---|
| メッセージ先頭 | `/deploy staging` | Claude Code が skill を直接実行する |
| 平文の後、独立した単語として、句読点が直結していない形 | `go ahead and /deploy to staging` | 直接は実行しない。**そのメッセージに限った実行許可**になり、Claude が文面から実行を求められているか判断して実行できる |

- この挙動は `disable-model-invocation: true` の skill にも適用される。changelog: 2.1.110「Fixed skills with `disable-model-invocation: true` failing when invoked via `/<skill>` mid-message」、2.1.287「Improved `/skill` names typed mid-message: Claude is now told they are skills, including `disable-model-invocation` ones」。職場環境が 2.1.110 未満ならメッセージ先頭に書く形が代替
- 「Control who invokes a skill」表: `disable-model-invocation: true` → ユーザー起動可 / Claude は自発的には不可 / 説明文はコンテキストに載らず、本文は起動時のみ
- Claude が勝手に起動しようとした場合は Claude Code がブロックし、「手順を自分で再現せずユーザーに起動を依頼せよ」と指示する（2.1.x changelog「Improved the refusal when Claude tries to invoke a skill with `disable-model-invocation`」）

### 5.1 利用上の注意（作業指示者との Q&A で確定した内容）

- **スラッシュの前後に空白を入れる**: `〇〇した後に /pre-compact を実行してください`。`/pre-compactを実行` のように助詞が直結すると「独立した単語」の条件を満たさない可能性がある
- **メッセージ先頭に書くと、残りの文は skill の引数になる**（commands ページ: 「A command is only recognized at the start of your message. Text that follows the command name becomes its arguments」）。他の指示と併記するときは文中に置く。文中に置けば、併記した他の指示も通常どおり実行される
- **許可であって強制ではない**: Claude は文面から実行を求められているか判断する。「〇〇した後に実行してください」は明確な指示なので通常は実行される
- **名前空間**: 衝突が無い環境では `/pre-compact` の短い形で Plugin 側が動く。`/pre-compact:pre-compact` は衝突時の明示用。名前空間自体を外す設定は無い（Plugin 名を前置しない形は、Marketplace 配布ではなく `~/.claude/skills/<名前>/` に `plugin.json` ごと置く skills-dir 形式のルート skill のみ）。frontmatter `name` を短くすれば `/pre-compact:pc` と `/pc` になる。作業指示者は「名前空間は対応不要」と決定
- 省略形が文中の言及でも同様に解決されるかは docs に明記が無く、実機未確認

## 6. 実装内容（commit `4733d90`）

```text
plugins/pre-compact/
├── .claude-plugin/plugin.json   name=pre-compact, version=0.9.0, author={name: empty-can}, repository, license=MIT
├── CHANGELOG.md                 0.9.0 初版。移植元 000b3f4、変更点 3 つ
├── README.md                    前提（auto memory 有効・git）、インストール、使い方（2 つの起動形）、更新、アンインストール
└── skills/pre-compact/SKILL.md  122 行版 + 下記の変更
```

SKILL.md の移植元からの変更点:

1. frontmatter に `disable-model-invocation: true` を追加
2. 「起動方法」節を追加（2 つの起動形、スラッシュ無しは許可にならない、Claude は手順を自分で再現せず起動を依頼する）
3. 4B（`/clear` 提示）に補足: `/clear <名前>` で直前の会話に名前が付き `/resume` から戻れる（commands ページ `/clear [name]` 行。エイリアス `/reset` `/new`）

`.claude-plugin/marketplace.json` にエントリ追加。ルート `CLAUDE.md`・`.claude/CLAUDE.md` に運用ルール追記（§4-4、および「同名 skill は bare 名がプロジェクト側を指すので Plugin 側は名前空間付きで呼ぶ」）。

### 6.1 検証結果

| 検証 | 結果 |
|---|---|
| `claude plugin validate --strict ./plugins/pre-compact` | `✔ Validation passed`, exit 0 |
| `claude plugin validate --strict .` | `✔ Validation passed`, exit 0 |
| BOM 検査（`head -c 3 \| xxd`） | 全ファイル BOM 無し UTF-8。JSON は `json.load` で構文 OK |
| `claude --plugin-dir ./plugins/pre-compact plugin list` | `pre-compact@inline  Version: 0.9.0  Status: ✔ loaded` |
| ローカル Marketplace からのインストール | `claude plugin marketplace add ./` → `claude plugin install pre-compact@empty-can --scope user` → `plugin list` に `pre-compact@empty-can 0.9.0 enabled`。その後 `claude plugin marketplace remove empty-can` で登録解除し、`~/.claude/settings.json` / `installed_plugins.json` / `known_marketplaces.json` に残骸が無いことを確認 |
| `claude --plugin-dir ./plugins/pre-compact plugin details pre-compact` | 常時 ~131 tok（`disable-model-invocation` なので実際には載らない）、起動時 ~3.4k tok |

注意: このマシンには Marketplace `empty-can` が未登録だったのでローカル登録テストができた。登録済みの環境で同じ名前のローカル Marketplace を add すると衝突する（1 ユーザー 1 名前）。

## 7. 残作業（作業指示者）

1. `/commit-and-pr` で PR 作成 → main マージ
2. main 上で `cd plugins/pre-compact && claude plugin tag --push` → `pre-compact--v0.9.0`
3. 職場環境での確認。self-hosted 環境のセッションは auto memory が既定で無効（memory ページ「Enable or disable auto memory」）なので、本 skill の memory 退避ステップが機能しない可能性に注意

## 8. 任意の本文更新候補（公式 docs の新情報）

- 圧縮後に invoked skill 本文が再注入される（1 skill 5,000 トークン上限、合計 25,000、古いものから落とす。「What survives compaction」）。pre-compact は `/compact` 直前に起動するため必ず再注入対象になり、約 3,400 トークンの本文が役目を終えた後も新コンテキストに残る。除外設定は無い。対策は本文を短くし詳細を補助ファイルに逃がすこと（→ `02` の品質レビュー節）
- `/rewind` の「Summarize up to here」（部分要約）が第 3 の選択肢になり得る（checkpointing「Rewind and summarize」）
