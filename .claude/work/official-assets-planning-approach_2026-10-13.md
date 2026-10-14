# 公式資産の棚卸し — 計画立案の進め方の計画（2026-10-13）

作成: Claude（Fable 5.1、専任の計画立案エージェント）
状態: 0.4 版（**確定、実行中**。Phase 0 の P0-A（red team）の結果に対する Fable の決定を転記。再議論は無し。以後の修正は Fable が自分で編集する）

| 項目 | 内容 |
|---|---|
| 位置づけ | `official-assets-survey_2026-10-12.md`（以下「survey」）3 節の「計画立案の進め方の計画」。情報収集そのものではなく、収集の戦略・終了条件・分担・統合手順を設計する |
| 入力 | survey 全文（1 節・2 節は事実として信頼、3-3 は批判対象）、`.claude/skills/orchestrate/SKILL.md`、`.claude/rules/agent-permission-runtime.md` 1 節、`test-methods-organized_2026-10-12.md` の見出しと 1 節・2-6・2-7、`.claude/settings.json` / `settings.local.json` の allow、**Round 1 の回答と追補 1・2、Round 2 の回答（Fable、2026-10-13）** |
| 書き方 | survey の事実には「survey 2-x」、Round 1 で Fable が確認した事実には「Round 1」と出所を付ける。本エージェントの判断には「判断」と書く。Web 調査は行っていないので、存在が未確認の情報源・資産には「要確認」と付ける。各節末尾の「確定 / 未確定」印は対話の収束を見るためのもの |

## 0. 前提と範囲

### 0-1. 目的の確認

- 作業指示者が求める終着点は「あらかじめ把握しておくべき情報源・公開資産はもう他には無いと、ある程度の確信を持って言える状態」（survey 1 節）
- この命題は、無限集合に対する否定なので、そのままでは検証できない。本計画では次の 3 つで有限化する（判断）
  1. **定義**（1 節）: 何が「公式・権威」かを手続きで判定できる形にする
  2. **チャネル**（2 節）: 公式資産が公開されうる場所を列挙可能な集合として固定する
  3. **スナップショット命題**（3 節）: 「日付 T、Claude Code 版 V、チャネル集合 C を全走査した時点で、定義に該当し範囲に入るものは N 件で、反証の試み（リンク閉包・独立探索・公式索引との包含）が追加を出さなかった」という形の終了宣言に置き換え、以後は監視に委ねる
- 成果物（survey 3-1）: 棚卸し文書 1 本（資産ごとに「何を確かめられるか / 確かめられないか / 採用するか」をテスト手法の整理文書の軸に対応づける）、情報源の階層、監視対象の追加判断

### 0-2. 範囲

- 「Claude Code の Plugin を開発・テスト・配布するときに参照すべき」情報源と資産に限る（survey 3-3）
- 本 Marketplace の現状（Round 1）: Plugin は 2 つ。statusline（`hooks/hooks.json` と `scripts/*.sh`）、pre-compact（`skills/pre-compact/SKILL.md`）。設計中のテスト用リポジトリは `claude -p` のヘッドレス実行を PowerShell / Python で包むもので、Agent SDK は使わない（設計書 v3.3 に Agent SDK / MCP への依存は無い。唯一の言及は docs 引用 1 箇所）
- MCP サーバー実装と Claude Agent SDK を含む Plugin は**無く、予定も無い**（Round 1、Q3 の回答）。したがって
  - W-1 の `platform.claude.com/docs` は「skill と Claude Code に言及するページ」だけに限定する（Agent SDK のページは拾わない）
  - `modelcontextprotocol.io` は既に監視済みで列挙コストがゼロなので、L2「条件付き」のまま置き、走査はしない
  - 2-5 の mcp / agent sdk は除外語ではなく**境界語**（当たったら境界印を付けて Fable に回す）
  - E6 のマトリクスに MCP / SDK の行は設けない
- この Marketplace は Claude Code 向けで、Anthropic のディレクトリへ提出しない。`pre-submission-checklist` は「提出しない限り対象外」を明記したうえで、品質基準としての参照は可（Round 1、Q4 (c)。8 節）
- claude.ai / Cowork 側の Plugin・Skill の面は範囲外。claude.com/docs のうち「面をまたぐ仕様」のページだけ採用（survey 2-4）
- claude.ai の Organization 配布で拒否される条件（`metadata.pluginRoot` の bare name、トップレベルの `bin/` 等）は「配布活動の制約」として**範囲内**（M3。Fable 決定。本リポジトリの `.claude/CLAUDE.md` が開発規約の根拠にしている）。X-5 に但し書きを置き、W-1 で claude.com/docs の該当ページを採用候補にする

### 0-3. 用語

| 用語 | 意味 | 例 |
|---|---|---|
| 情報源 | 読んで参照するもの | docs、CHANGELOG、blog、support 記事、仕様 |
| 資産 | 使う・流用する・比較対象にするもの | Plugin、skill、同梱スクリプト、テンプレート、CLI の組み込み機能、npm / PyPI パッケージ、JSON Schema、GitHub Action |
| チャネル | 情報源・資産が公開されうる場所。列挙の単位 | docs サイトの `llms.txt`、GitHub org、レジストリのスコープ |
| 権威の対象 | その情報源が何について正本か | 形式 / 挙動 / ポリシー / 参照実装 / 変更履歴（1-3） |

### 0-4. survey 3-3（Fable の初期仮説）への批評

| 仮説の要素 | 判定 | 理由（判断） |
|---|---|---|
| 探索の単位を「話題」でなく「公開チャネル」にする | 採用 | 有限化の手段として正しい。ただし「チャネルごとの網羅の方法」はキーワード依存だと偽陰性が主な漏れ口になるので、**成果物の署名による列挙**（`.claude-plugin/marketplace.json` 等を org 横断で検索）を主、キーワードを従にする（2-6 G-6） |
| 候補: Anthropic の GitHub 組織 | 採用・拡張 | `anthropics` 以外に Anthropic 所有の org があるかは要確認。org の verified 表示で判定する手続きを 1-2 に置く。`anthropics/claude-plugins-public` の存在確認を追加（Round 1） |
| 候補: 3 つの docs の `llms.txt` | 採用・限定 | `platform.claude.com/docs` は API 全般を含むので、skill と Claude Code に言及するページだけをフィルタする（Round 1、Q3） |
| 候補: support.claude.com | 採用・優先低 | 消費者向けの help center で、Plugin 開発の資産が出る場所ではない（要確認）。列挙は安いので走査はするが優先は最低 |
| 候補: engineering blog | 採用・格上げ | 「列挙できない」と見なしがちだが、`anthropic.com` の sitemap があれば列挙可能チャネルに格上げできる。sitemap の有無の確認を P1-B の最初のタスクにする（Round 1） |
| 候補: 公式 Marketplace の Anthropic 所有 Plugin | 採用 | ローカルの clone 済みキャッシュで Web 権限ゼロで完了する（2-1 L-2） |
| 候補: Claude Code の changelog | 採用・重要 | docs より先に機能・資産が現れる場所。docs 側に無い項目の検出装置として位置づける。code.claude.com に changelog ページがあれば W-4 に統合（Round 1） |
| 候補: npm / PyPI の Anthropic 発パッケージ | 採用 | レジストリ API でスコープ単位に列挙できる。mods のテストキット `claude-code/testing` の存在は要確認 |
| 候補: agentskills.io の Client Showcase | 除外 | Claude Code 以外のクライアント一覧。本 Marketplace の範囲外（2-4 X-2） |
| 終了条件 (1) 列挙したチャネルをすべて走査した | 採用・条件付き | フィルタ基準と件数（列挙 / 採用 / 除外 / 未確認）を記録して初めて検証可能になる（3 節 E1） |
| 終了条件 (2) リンク集合の飽和 | 修正 | 終了条件ではなく「未知のチャネルを発見する装置」として E1 に組み込む。seed と深さを固定しないと飽和は定義できない（E2） |
| 終了条件 (3) 独立探索者 N 人の収束 | 修正 | LLM 同士は学習データを共有し独立ではない。統計的推定（捕獲再捕獲等）には使わず、「チャネルの穴の検出装置」に限定する。探索者には survey 2 節も既知のチャネル名も見せない（E3） |
| 仮説に無いもの | 追加 | ローカル層（保存済み `llms.txt`、Plugin キャッシュ、Plugin ディレクトリのキャッシュ、Claude Code 本体の同梱物）、公式の自己索引との包含（E4）、時間箱と監視への移行（E5）、用途ベースの充足（E6） |
| GitHub を API で構造的に列挙する（作業指示者の追補。Round 1） | 採用・詳細化 | GitHub は org 配下の全リポジトリ、fork 関係、スター数、wiki、メンテナーの issue といった WebFetch / WebSearch では現実的でない探索が API でできる唯一のチャネル。2-6 に探索単位ごとの採否・手順・上限を置き、W-2 / W-3 を吸収する |

（この節: **確定**（Round 1）。0-2 に Round 1 の事実を追記）

## 1. 「公式・権威」の定義

### 1-1. 権威レベル

| レベル | 定義 | 該当（survey 2 節・Round 1 で確認済み、または要確認） |
|---|---|---|
| **L1: Anthropic 一次** | Anthropic が管理するドメイン・組織・パッケージスコープの下で、Anthropic を著作者として公開されているもの、および Claude Code 本体に同梱されているもの | ドメイン: `anthropic.com`、`claude.com`（`support.claude.com` を含む）、`code.claude.com`、`platform.claude.com`（旧 `docs.anthropic.com` / `docs.claude.com` のリダイレクト先。要確認）。GitHub org: `anthropics`（他の org は要確認）。npm: `@anthropic-ai/*`。PyPI: `anthropic`、`claude-agent-sdk` 等（要確認）。同梱物: `@anthropic-ai/claude-code` の中身。公式 Marketplace の `./plugins/*`（例: claude-security。`author.name: Anthropic`。Round 1） |
| **L2: Anthropic 発の公開標準** | Anthropic が起草して公開標準として切り出したもの。L1 がその形式の参照先としてリンクしていることを条件にする | `agentskills.io` / GitHub `agentskills`（SKILL.md 形式の正本。survey 2-2）、`modelcontextprotocol.io` / GitHub `modelcontextprotocol`（MCP。現時点で範囲外。監視済みなので列挙しない。Round 1） |
| **L3: Anthropic が掲載を認めた第三者** | Anthropic の管理下の場所（org、Marketplace、ディレクトリ）に掲載されているが、著作者が Anthropic でないもの。**置き場所が `anthropics` org でも著作者が第三者なら L3**（Round 1） | `claude-plugins-official` の `./external_plugins/*`（`homepage` が `anthropics/claude-plugins-public/tree/main/external_plugins/...` を指し、著者は第三者。例: Clay。Round 1）、ディレクトリ掲載 Plugin、agentskills.io の Client Showcase、L1 からリンクされた社員個人のリポジトリ |
| **対象外** | 上記のいずれにも該当しないもの | コミュニティの awesome リスト、個人ブログ、Discord / X / YouTube の投稿、他クライアント（Cursor 等）の docs、L1 からリンクされていない社員個人の公開物 |

- 棚卸しに載せるのは L1 と L2。L3 は棚卸しに載せず、**別表に名称とリンク元だけ記録**する（Round 1、Q4 (a) (b) の Fable 仮判定。8 節）。挙動や形式の根拠には使わない
- 「準公式」という語は使わない。L2 と L3 を区別しないと「権威」の意味が曖昧になる（判断）

### 1-2. 判定の手続き（人の印象でなく手順で決める）

| 対象 | 手続き | 使うツール |
|---|---|---|
| ドメイン | (a) ページのフッターの著作権表示が Anthropic である、**または** (b) L1 の既知ページからの**リダイレクト**で到達できる（`llms.txt` には著作権表示が無いため。Round 1）。**(b) はリダイレクトに限る。L1 からのリンクは「候補にする」だけで、権威は (a) または置き場所・著作者で判定する**（M1。docs がリンクする第三者ドメイン（schemastore、semver.org 等）を L1 にしないため）。リダイレクトは最終 URL を正本とし、旧 URL は同一権威として別名欄に記録（二重計上しない） | WebFetch、`mcp__fetch__fetch` |
| GitHub org | `gh api orgs/<org>` の `is_verified` と `blog` / `company` 欄が Anthropic のドメインを指す。org の存在は `gh search repos` の owner で発見する | `gh api *`、`gh search *` |
| npm パッケージ | `registry.npmjs.org/-/v1/search?text=scope:anthropic-ai` でスコープ内を列挙し、各パッケージの `maintainers` を記録 | WebFetch(registry.npmjs.org) |
| PyPI パッケージ | `pypi.org/pypi/<pkg>/json` の `project_urls` が `anthropics` org を指す。発見は `anthropics` org の Python リポジトリからの逆引き（PyPI の検索は弱い） | WebFetch(pypi.org) |
| 同梱物 | Claude Code のインストール先（`command -v claude` で特定）パッケージの中にある | ローカルの `ls` / `find` |
| 著作者 | 置き場所で L1 の候補にし、**掲載元が宣言する著作者**（`marketplace.json` / `plugin.json` の `author`、`homepage`、リポジトリの owner）が Anthropic でなければ L3 に落とす（Round 1）。社員個人のアカウント下は、L1 からリンクされていれば L3 として記録しリンク元を残す。それ以外は対象外 | Read、`mcp__github__get_file_contents` |

### 1-3. 権威の対象（記録にタグとして持たせる）

| タグ | 意味 | 正本の例 |
|---|---|---|
| 形式 | ファイル形式・スキーマの仕様 | SKILL.md → agentskills.io。`plugin.json` / `marketplace.json` / `hooks.json` → code.claude.com |
| 挙動 | Claude Code がどう読み込み・validate・eval・mods するか | code.claude.com |
| ポリシー | 提出・ライセンス・命名の規則 | claude.com/docs（参照は限定的） |
| 参照実装 | 作り方の実例 | 公式 Marketplace の Anthropic 所有 Plugin、`anthropics/skills` |
| 変更履歴 | 挙動が変わった事実の先行情報 | `anthropics/claude-code` の CHANGELOG と Releases |

### 1-4. 境界事例の判定（Round 1 で確定）

| # | 事例 | 判定（Round 1） | 派生する作業 |
|---|---|---|---|
| B1 | `claude-plugins-official` の claude-security と `./external_plugins/*` | claude-security は `source: ./plugins/claude-security`、`author.name: Anthropic` → **L1**（survey 2-2 の「外部 URL 参照」は誤記。survey 側を Fable が訂正）。`./external_plugins/*` は `homepage` が `anthropics/claude-plugins-public/tree/main/external_plugins/...` を指し著者は第三者 → **L3**（別表） | `anthropics/claude-plugins-public`（`claude-plugins-official` と別名のリポジトリ）が rename か別リポジトリかを 2-6 G-1 / P1-G1 の確認項目に追加 |
| B2 | docs や blog からリンクされた Anthropic 社員の個人リポジトリ | **L3**。リンク元を記録（作業指示者の意向は未確認。8 節） | — |
| B3 | `skills-ref`（`agentskills` org。README が「デモ用途で本番向きではない」。survey 2-2） | **L2 の資産**。採用判断は「デモ」を根拠に不採用候補 | — |
| B4 | MCP 仕様（財団へ移管後。要確認） | **L2、現時点で範囲外**。監視済みなので列挙はしない（Q3） | — |
| B5 | `settings.json` 等の JSON Schema（`https://json.schemastore.org/claude-code-settings.json`） | 出所を確認してから判定。Anthropic 公開なら L1 の資産 | 出所確認を P1-G2 の項目に追加（SchemaStore/schemastore 上のファイルと投稿者）。docs 側の言及の有無は P1-D |
| B6 | Anthropic Academy / `anthropics/courses` | **L1 の情報源**。Claude Code の Plugin を扱う教材があれば範囲内、無ければ範囲外 | — |

（この節: **確定**（Round 1）。1-2 (b) を緩和、1-4 を判定済みに更新）

## 2. 情報が公開されうるチャネルの分類

列挙方法と関連性フィルタを分けて書く。フィルタの語は 2-5 に固定し、サブエージェントに同じ集合を渡す。

### 2-1. ローカル層（Web 権限ゼロで走る。最初に実施）

| ID | チャネル | 列挙方法 | 完了の判定 | 優先 |
|---|---|---|---|---|
| L-1 | `C:\cc-workspace\LLMs\official-llms-txts\` の 2 サイト（Round 1）: `code.claude.com/docs/`（`llms.txt`、`llms-full.txt`、`en/`、`ja/`、`en/claude_code_docs_map.md` = 全ページの見出しマップ）、`modelcontextprotocol.io/`（`llms.txt`、`llms-full.txt`。範囲外なので走査しない） | `llms.txt` の全行と `claude_code_docs_map.md` の全見出しを読む。`llms-full.txt` は Grep ツールで見出しとキーワードだけ。**追加確認**: code.claude.com に changelog ページがあるか（あれば W-4 に統合）。**C9**: `llms-full.txt` を Grep（reserved / impersonat / 予約）して公式の予約 Marketplace 名の一覧を取る（実体への対応づけは G-6） | `llms.txt` ∪ sitemap ∪ docs_map の全行に採用 / 除外の印（C5 / R5。code.claude.com の sitemap は P1-D が取得し、llms.txt / docs_map との差集合を P1-L の結果と突き合わせる）。予約名の全件 | 最高 |
| L-2 | `~/.claude/plugins/known_marketplaces.json`（claude-plugins-official = `anthropics/claude-plugins-official`、lastUpdated 2026-10-12T10:39Z。anthropic-agent-skills = `anthropics/skills`、2026-10-12T13:29Z）、`~/.claude/plugins/marketplaces/*`、`~/.claude/plugins/cache/*`（claude-security、hookify、playground、plugin-dev、security-guidance、skill-creator。Round 1） | 各 `marketplace.json` の全エントリを読み、**分類は 1-2 の著作者判定に一本化**する（M2）: `./plugins/` でも `author` を見る。`source` がオブジェクト（github / url / git-subdir / npm 等）のエントリも `author` と `homepage` で判定する。置き場所（`./plugins/` / `./external_plugins/`）は参考欄に残す | 全エントリに権威レベル（著作者判定）と範囲内 / 境界 / 外の印。L3 は別表 | 最高 |
| L-2b | Claude Code 組み込みの「Plugin ディレクトリ」機能のキャッシュと見られるもの（Round 1）: `~/.claude/plugins/marketplaces/anthropic-plugin-directory/`（2026-10-12 22:29 生成。git は空）、`~/.claude/plugins/plugin-directory-cache-v2.json`（2.4 MB）、`~/.claude/plugins/plugin-catalog-cache.json`（537 KB） | **2.4 MB の JSON は Grep ツールだけで扱う**（Bash の grep / cat 禁止、全文 Read 禁止）。`author` / `owner` 欄で Anthropic 所有エントリだけを抽出。中身は L3 が主なので棚卸しには載せない | (1) Anthropic 所有エントリの抽出が終わっている、(2) ディレクトリ機能の docs 上の説明の有無を L-1 / W-1 で確認している | 高 |
| L-3 | Claude Code 本体（2.1.296。Round 1）の同梱物: `claude --help`、`claude plugin --help`、`claude plugin eval --help`、`/help` の組み込みコマンド一覧、インストール先パッケージ内のテンプレート・スキーマ・組み込み skill。**C1**: 本体の JS バンドル / バイナリ中の `https://` 文字列（anthropic / claude を含むもの。製品自身が使う公式参照先の名簿）。**C2**: セッションに注入される組み込み agent / skill の一覧（`--help` では見えない。例: `claude-code-guide`、`statusline-setup`、`plugin-authoring`）。**C3**: `anthropic-skills:` 名前空間（claude.ai アカウント経由で供給される skill。境界）。**C4**: ローカルの manifest（`~/.claude/plugins/` 配下と本リポジトリの `*.json`）の `$schema` 値 | インストール先は `command -v claude` で特定。**`claude plugin eval init` は書き込みを伴うので実行しない**。雛形の確認は `llms-full.txt` で代替。C1 は Grep ツール（output_mode content、`-o`）で抽出し一意化。単一バイナリで Grep が読めなければ「未走査（バイナリ）」。C2 / C3 は P1-L 自身の system-reminder の一覧を転記し、Plugin 由来（L-2 のキャッシュ）とプロジェクト由来（`.claude/`）を差し引く。C3 は実体ファイルがあれば既知の skill-creator（L-2 の 2 複製）と内容を比較し `boundary` で回す。C4 は Grep で `"$schema"` 行を抽出し一意化 | help の全項目と同梱ディレクトリの一覧に範囲判定。C1 の一意 URL 全件に既知 / 未知 / 範囲外の印。C2 の一覧全件に出所（組み込み / Plugin / プロジェクト / アカウント）と範囲判定、docs の説明ページの有無。C3 の全件に供給元と同一性の記録。C4 の一意 URL 全件に出所 | 高 |

### 2-2. 列挙可能なチャネル（有限集合。全走査したと言える）

| ID | チャネル | 列挙方法 | 完了の判定 | 優先 |
|---|---|---|---|---|
| W-1 | docs サイトの `llms.txt`: `claude.com/docs`（266 ページ。survey 2-2）、`platform.claude.com/docs`（要確認。**skill と Claude Code に言及するページだけ**）、`agentskills.io`（9 ページ）、`code.claude.com/docs`（L-1 で済む） | 各 `llms.txt` と各サイトの `sitemap.xml`（無ければ robots.txt の Sitemap 行）を取得し、URL 集合の差集合を出して全行をフィルタ（C5 / R5。code.claude.com の sitemap も取り、L-1 の llms.txt / docs_map との差を出す）。**追加確認**: Plugin ディレクトリ機能（L-2b）の説明ページの有無、`$schema` / schemastore への言及の有無、**M3**: claude.ai の Organization 配布の受理条件（`metadata.pluginRoot`、`bin/` 等）のページを採用候補にする | `llms.txt` ∪ sitemap の全 URL に採用 / 除外の印。差集合の件数を記録（差が 0 なら「llms.txt を全集合と見なせる」根拠として記録） | 最高 |
| W-2 | GitHub org の全リポジトリ | **2-6 の G-1 に吸収**（メタデータ付きの全件列挙。fork 関係 G-2、スター数 G-3、topic G-7、他 org の発見 G-9 を伴う） | 2-6 | 最高 |
| W-3 | 成果物の署名による org 横断 code search | **2-6 の G-6 に吸収**（クエリ集合を確定。org 内は列挙、org 外は L3 発見用の補助） | 2-6 | 高 |
| W-4 | `anthropics/claude-code` の `CHANGELOG.md` と GitHub Releases。code.claude.com に changelog ページがあればここに統合（L-1 で確認） | 全エントリをキーワードで走査し、docs に無い機能・資産を抽出 | 全エントリ走査。抽出項目は docs のページと対応づけ | 高 |
| W-5 | パッケージレジストリ: npm `@anthropic-ai` スコープ、PyPI の Anthropic 発パッケージ | 1-2 の手続き | スコープ内の全パッケージに範囲判定 | 中 |
| W-6 | `anthropic.com` の sitemap（engineering / news）と、**`claude.com` の docs 以外のパス**（blog、resources 等。C6 / M4。X-1 の前提「告知はいずれ blog に現れる」と範囲を一致させる） | **最初のタスクとして各サイトの sitemap の有無を確認**（robots.txt の Sitemap 行も見る）。あれば全 URL をパス接頭辞ごとに集計し、`/docs/` 以外をキーワードでフィルタ。無ければ WebSearch の `site:anthropic.com` / `site:claude.com -inurl:/docs/` クエリで代替し、列挙可能チャネルから補助チャネルへ降格したことを記録 | 全 URL に印。記事は「背景の情報源」として扱い、資産の発見源としてだけ見る | 中 |
| W-7 | `support.claude.com` の Claude Code 関連カテゴリ | カテゴリ一覧または sitemap | カテゴリ内の全記事タイトルに印 | 低 |
| W-8 | リンク閉包（E2 の実装）: L1 の索引ページ（`claude.com/docs/build/overview`、code.claude.com の plugins / skills / eval / mods の各ページ、`anthropics/claude-code` README、`claude-plugins-official` README、**`anthropics/skills` の academy-guide 束**（C10））から外向きリンクを集め、未知を報告 | 深さ 2 まで。**未知の判定単位は「repo + path 接頭辞」**（R3）。既知 repo 内の path（deep link）も出力に残し、G-6 / G-11 の列挙との差を P2-V が取る。既知集合（1-1）との差分を報告 | 1 パスで未知ゼロ、または未知を 2-2 のチャネルに追加して再走査（最大 1 回） | 高 |

### 2-3. 列挙できない補助チャネル（飽和の確認にだけ使う）

| ID | チャネル | 使い方 | 位置づけ |
|---|---|---|---|
| S-1 | WebSearch の固定クエリ集合（10〜15 クエリ。2-5） | 各クエリの上位 N 件のうち L1 / L2 ドメインのものだけ拾い、2-2 の和集合に無いものを報告 | 標本抽出による反証の試み |
| S-2 | 独立探索者（blind。survey 2 節も既知のチャネル名も見せない） | 定義と範囲だけを渡し、知識と制限付き Web で列挙させる | チャネルの穴の検出装置（E3） |
| S-3 | コミュニティのリスト（awesome-claude-code 等。要確認） | 「公式」と注記された項目だけ抽出して 1-2 の手続きにかける | 権威は無い。見落とし検出のみ |
| S-4 | `anthropics/claude-code` 等の Issues / Discussions（全体） | 全体は列挙不能。ただし著者（メンテナー）・ラベル・期間・pinned・announcement カテゴリで有限化した部分集合は **2-6 の G-5 として W 層に格上げ**（Round 1 追補）。それ以外は個別の疑問を解く時にだけ参照し、棚卸しには載せない | 有限化した部分は G-5、残りは対象外に近い |
| S-5 | Anthropic Academy のコースカタログ（C10。補助。Fable 決定） | URL を推測せず、W-6 の結果・W-8 の seed（`anthropics/skills` の academy-guide 束）から辿って特定し、コース一覧の全タイトルを 2-5 でフィルタ。Plugin を扱うコースが 0 なら B6 の「範囲外」側を確定 | B6 の判定を閉じるための補助。担当 P1-B |

### 2-4. 除外するチャネル（理由付き）

| ID | チャネル | 理由（判断。X-6 は Round 1） |
|---|---|---|
| X-1 | Discord、X、YouTube | 恒久性と列挙性が無い。公式の告知はいずれ docs / CHANGELOG / blog に現れる前提を置く。この前提は終了宣言の「残存リスク」に定型文として入れる（3-3） |
| X-2 | agentskills.io の Client Showcase | Claude Code 以外のクライアント一覧。範囲外 |
| X-3 | claude.com のディレクトリ（提出先）と提出フロー | 提出しない前提。`pre-submission-checklist` だけは品質基準として参照可（0-2） |
| X-4 | `platform.claude.com/docs` の API 全般（Messages API、モデル一覧、Agent SDK） | Plugin が含まない限り範囲外。W-1 ではフィルタで切る |
| X-5 | claude.ai / Cowork 側の Plugin・Skill の面 | 面が違う。claude.com/docs の「面をまたぐ仕様」のページだけ W-1 で採用。**但し書き（M3）**: claude.ai の Organization 配布で拒否される条件（`metadata.pluginRoot` の bare name、トップレベルの `bin/` 等）は配布活動の制約として範囲内。**但し書き（C3）**: claude.ai アカウント経由で Claude Code に供給される `anthropic-skills:` 名前空間の skill は境界（L-3 で `boundary` として記録） |
| X-6 | VS Code / JetBrains の拡張ストア | Claude Code 本体の配布経路で、Plugin 開発資産は置かれない |

### 2-5. 関連性フィルタの語（サブエージェントに同じ集合を渡す）

- 署名（キーワード非依存。主）: `.claude-plugin/marketplace.json`、`.claude-plugin/plugin.json`、`SKILL.md`、`hooks/hooks.json`、`.mcp.json`、`.claude/agents/*.md`、`.claude/skills/*/SKILL.md`、`evals.json`、`CHANGELOG.md`
- キーワード（従）: claude code、plugin、marketplace、skill、agent skills、subagent、agent、hook、slash command、command、eval、evaluate、validate、test、testing、harness、headless、`-p`、`stream-json`、sandbox、mod、mods、statusline、settings、permission、`--plugin-dir`、skill-doctor、release、changelog、plugin directory
- 境界語（当たったら `scope_verdict: boundary` を付けて Fable に回す。Round 1）: mcp、agent sdk、claude-agent-sdk
- 除外語（当たっても範囲外に倒す）: messages api、pricing、model（単独）、cowork、directory submission、enterprise admin
- `platform.claude.com/docs` の追加条件: ページのタイトルか URL に skill / claude code を含むものだけ採用候補にする

### 2-6. GitHub の探索戦略（W-2 / W-3 を吸収。作業指示者の追補、Round 1）

GitHub は、org 配下の全リポジトリ、fork 関係、スター数、wiki、メンテナーの発言といった、WebFetch / WebSearch では現実的でない探索を API で構造的に行える唯一のチャネル。他のチャネルより一段詳しく、探索単位ごとに採否・手順・完了判定・制約を決める。担当は P1-G1（リポジトリの構造: G-1、G-2、G-3、G-7、G-8、G-9、G-10、G-12）と P1-G2（リポジトリの中身: G-4、G-5、G-6、G-11）。G-11 / G-12 は Phase 0 の反映で追加（C7 / C8。Fable 決定）。P1-G2 は G-4 / G-5 の対象を P1-G1 の結果（`scope_verdict` が in / boundary のリポジトリ）から取るので、**P1-G1 の完了後に起動**する（Round 2）。G-6 は G-1 に依存しないので、P1-G2 内の順序は G-6 → G-5 → G-4 のまま。

**共通の制約（上限設計の根拠）**

| 制約 | 値 | 対処 |
|---|---|---|
| REST API（`gh api`） | 認証済みで 5,000 回 / 時。`--paginate` で 100 件 / ページ | 開始時と 20 回ごとに `gh api rate_limit` を見る。残量 500 未満で停止し、未走査を記録 |
| GraphQL（`gh api graphql`） | 5,000 ポイント / 時。1 クエリで 100 リポジトリ分のメタデータを取れる | G-1 は GraphQL を主にし、REST の `repos/{owner}/{repo}` の個別呼び出しを避ける |
| code search（`mcp__github__search_code`、`gh search code`） | 10 回 / 分、1 クエリ 1,000 件上限、default branch のみ、384 KB 超のファイルは索引外、fork は親よりスターが多い場合だけ索引（要確認）、archived の扱いは要確認 | クエリは 1 分に 10 件以内（間に他の API 呼び出しを挟む）。1,000 件に達したクエリは `repo:` で分割。索引の制約は「走査の記録」に明記 |
| repo / issue search（`search_repositories`、`search_issues`、`gh search repos / issues`） | 30 回 / 分、1 クエリ 1,000 件上限 | 同上 |
| secondary rate limit（403 / 429） | 短時間の連続呼び出しで発生 | 発生したらその探索単位を「未走査（レート制限）」として記録し、次の単位へ進む。再走査で拾う |
| 認証 | gh の CLI 認証（許可済み）。MCP の GitHub サーバーも同じアカウント | — |

**探索単位**

#### G-1. org 配下の全リポジトリ列挙 — 採用（最高）

- 対象: `anthropics`、`agentskills`、G-9 で L1 と判定した org。archived と fork を含めて全件
- 方法: `gh api graphql` で `organization(login){ repositories(first:100, after:$cursor, privacy:PUBLIC){ totalCount nodes{ nameWithOwner description repositoryTopics(first:20){nodes{topic{name}}} isArchived isFork parent{nameWithOwner} stargazerCount forkCount pushedAt hasWikiEnabled hasDiscussionsEnabled homepageUrl licenseInfo{spdxId} } pageInfo{hasNextPage endCursor} } }` をカーソルで回す。REST で行うなら `gh api "orgs/{org}/repos?type=all&per_page=100" --paginate`（`parent` が含まれないので fork には個別に `repos/{owner}/{repo}`）
- 記録: 4-4 の `gh` オブジェクト（stars、forks、archived、is_fork、parent、pushed_at、has_wiki、has_discussions、topics、license、homepage）。全リポジトリに範囲判定（名前・description・topics・README 冒頭を 2-5 の語で）
- 追加確認: `anthropics/claude-plugins-public` の正体（B1。rename なら `gh api repos/anthropics/claude-plugins-public` が別名へリダイレクトする）
- 追加取得（R2。E4 の独立索引）: org の pinned リポジトリ（GraphQL `organization(login){ pinnedItems(first:6, types:REPOSITORY){ nodes{ ... on Repository { nameWithOwner } } } }`）と、org の profile README（`gh api repos/{org}/.github/contents/profile/README.md`。無ければその旨を記録）。これらは W-8 の seed にも G-1 のフィルタにも使わず、E4 の包含率の計算にだけ使う
- 完了: 取得件数が `totalCount` と一致し、全件に内 / 境界 / 外の印がある
- 上限: org あたり ⌈totalCount / 100⌉ 回。4 org でも 10 回程度

#### G-2. fork 関係 — (a) 採用、(b) 採用・限定

- (a) Anthropic 所有で `isFork == true` のもの: G-1 の `parent` で判定。親が Anthropic の org 外なら、権威を「L1（fork。親は外部）」と注記し、棚卸しの対象は **fork 側に Anthropic が加えた差分**に限る（fork 間の比較は `gh api repos/{parent_owner}/{parent_repo}/compare/{parent_branch}...{owner}:{branch}` の `ahead_by`。差分が無ければ `excluded`、理由「外部の fork で差分無し」）
- (b) Anthropic 所有の範囲内リポジトリを親に持つ fork のスター数上位: `gh api "repos/{owner}/{repo}/forks?sort=stargazers&per_page=10"`。対象は範囲内の L1 リポジトリ 10 件以内、各上位 10 fork。目的は「公式資産が fork 先へ移管・別名配布されているケース」の検出。結果は権威無しとして `status: "excluded"`、理由「fork（検出装置）」で記録し、棚卸しには載せない。fork 側のほうが活発（`pushed_at` が新しくスターが多い）なら、移管の可能性として `boundary` で Fable に回す
- 完了: (a) 全 fork リポジトリに親と差分の有無を記録。(b) 対象リポジトリ全件の上位 10 fork を記録
- 上限: (a) fork 数、(b) 10 回

#### G-3. スター数 — 採用（優先順位付けのみ。権威の根拠にしない）

- L1 内: スター数で並べ、P2-M が中身を読む順序と、E4 の索引との対比に使う（索引に無いのにスターが多い L1 リポジトリは「索引の更新遅れ」の候補）
- L3 候補（G-6 org 外、G-7 org 外）: しきい値 **100 スター以上**だけ別表に記録し、未満は `excluded`（理由「stars < 100」）。しきい値は Round 2 で確定
- 監視: スターが多く `pushed_at` が新しいものを監視候補の上位にする
- 方法: G-1 / G-6 / G-7 の結果に含まれる。追加の呼び出しは無い

#### G-4. Wiki — 採用（条件付き）

- 対象: G-1 で `hasWikiEnabled == true` かつ範囲判定が内 / 境界のリポジトリ（GitHub は既定で wiki が有効なので、有効＝内容ありではない）
- 方法: wiki の API は無いので `git clone --depth 1 https://github.com/{owner}/{repo}.wiki.git {scratchpad}/github-wiki/{owner}__{repo}/`。wiki が空なら clone が「repository not found」で失敗する（これが「内容無し」の判定）。成功したら `find {dir} -name '*.md' | wc -l` でページ数を取り、ページ名を記録
- 隔離: clone 先は作業用の一時ディレクトリで、ダウンロード物として扱う。中のファイルを実行しない、その中で interpreter やビルドを起動しない。読むのは Read / Grep だけ。作業後に削除しなくてよい（一時領域）
- 完了: 対象リポジトリ全件に `wiki_has_content` と `wiki_pages` を記録。内容のある wiki は情報源として JSONL に 1 項目追加（URL は `https://github.com/{owner}/{repo}/wiki`）
- 上限: 対象は 20 件以内と見込む（clone + find で 40 回）

#### G-5. Issues / Discussions — 採用（S-4 から格上げ。有限化の条件付き）

- 目的: docs に先行する告知と、資産へのリンク（`github.com/anthropics/*`、`claude.com`、`code.claude.com`）の発見源。issue 自体は資産ではなく、本文中のリンク先を候補として W-8 と同じ「未知」表に出す
- 対象リポジトリ: `anthropics/claude-code`、`anthropics/claude-plugins-official`、`anthropics/skills`（G-1 で範囲内かつ issue が有効なもの。Releases は W-4 で P1-C が扱う）
- 有限化の条件（1〜3 はすべて AND）:
  1. 期間: **本 Marketplace の Plugin が使う機能（hooks、statusline、skills、plugin）の CHANGELOG 上の初出のうち最古**（R10。Fable 決定。「Plugin 機能の導入」で切ると、それ以前の hook / statusline の告知が構造的に落ちるため）。初出は P1-C が W-4 で特定する。P1-G2 起動時に P1-C が終わっていればその値を渡し、終わっていなければ P1-G2 が自分で CHANGELOG を見る。暫定 2025-10-01 はどちらも特定できなかった場合の最後のフォールバック。issue 数が上限を超える期間は残存リスクに明記
  2. 著者: `author_association` が OWNER / MEMBER / COLLABORATOR（非公開メンバーは CONTRIBUTOR と表示される可能性があるので要確認。G-8 の公開メンバー一覧で補完）
  3. ラベル: リポジトリのラベル一覧（`gh api repos/{owner}/{repo}/labels --paginate`）のうち 2-5 の語に当たるもの（plugin、marketplace、skill、hook、eval、mods 等。実在するラベル名を記録）
  - 条件に関わらず全件: pinned issue（GraphQL `repository.pinnedIssues(first:3)`）
  - Discussions: `hasDiscussionsEnabled` が真なら、GraphQL `repository.discussionCategories` で announcement 系のカテゴリを特定し、そのカテゴリの全投稿（`discussions(categoryId, first:100)`）
- 方法: `gh search issues --repo {owner}/{repo} --label {label} --created ">={since}" --json ...`（または `mcp__github__search_issues` の `repo: label: created:>=` 修飾子）でラベルごとに取り、各 issue の `author_association` でフィルタ。該当 issue の本文からリンクを抽出
- 完了: 対象リポジトリ全件について、ラベル一覧・pinned・announcement の全件と、ラベル付き issue の全ページを走査したこと（1,000 件上限に当たったラベルは期間で分割）
- 上限: ラベル数 × ページ数 × リポジトリ数。10 ラベル × 2 ページ × 3 リポジトリで 60 回を見込む
- 除外の明記: これ以外の issue（ユーザー報告、質問）は列挙しない。個別の疑問を解くときにだけ参照する（S-4 の残り）

#### G-6. 署名による code search — 採用（org 内は列挙、org 外は補助）

- org 内（`anthropics`、`agentskills`、G-9 の org）のクエリ集合（Round 2 で最終化）:
  1. `org:{org} path:.claude-plugin filename:marketplace.json`
  2. `org:{org} path:.claude-plugin filename:plugin.json`
  3. `org:{org} filename:SKILL.md`
  4. `org:{org} path:hooks filename:hooks.json`
  5. `org:{org} filename:.mcp.json`（境界語。当たれば `boundary`）
  6. `org:{org} path:.claude/agents extension:md`
  7. `org:{org} path:.claude/skills filename:SKILL.md`
  8. `org:{org} filename:evals.json`、`org:{org} path:evals`
  9. `org:{org} "claude plugin validate"`（CI での検証の実例）
  10. `org:{org} path:.github/workflows claude`（Claude Code を使う workflow）
  11. `org:{org} filename:action.yml`（G-10）
  12. `org:{org} filename:CHANGELOG.md path:plugins`（Plugin ごとの CHANGELOG の実例）
- 疎通確認（最初に行う）: org 内クエリ 1 本（クエリ 1）と org 外クエリ 1 本を先に投げる。GitHub の code search API は、検索語を含まず修飾子だけのクエリや、user / org / repo で絞らないクエリを 422 で拒否することがある（要確認）。422 なら、org 内は検索語を足して再試行（例: `"name"` を加える）、org 外は「未走査（API 制約）」として記録し、G-7 の topic 検索で代替する
- org 外（L3 発見用。補助。1,000 件上限のため非網羅と明記）: `path:.claude-plugin filename:marketplace.json` と `path:.claude-plugin filename:plugin.json` の 2 クエリ。ヒットしたリポジトリを G-1 と同じメタデータで引き、G-3 のしきい値（100 スター以上）で L3 候補を別表に出す。code search は `stars:` 修飾子を持たないので、メタデータ取得は別呼び出し
- 追加確認（C4）: SchemaStore の `catalog.json`（`https://www.schemastore.org/api/json/catalog.json`。`mcp__fetch__fetch`）から name / description / url に claude か anthropic を含むエントリを抽出し、各 URL のホストと投稿者で 1-2 の判定（B5 と同じ担当。ローカルの `$schema` 値の収集は L-3 の C4）
- 追加確認（C9）: P1-L が取った公式の予約 Marketplace 名の全件を、`path:.claude-plugin filename:marketplace.json "<名前>"` と G-1 のリポジトリ名で実体に対応づけ、「実体あり（repo）/ 実体不明」を記録
- 制約の記録: 各クエリのヒット数、1,000 件上限に当たったか、fork / archived の索引除外の実際（既知の L1 リポジトリが結果に出るかで確認）。索引外の検出は G-11 が担う
- 完了: org 内の全クエリを実行し、各ヒットが G-1 のリポジトリに対応づいている。1,000 件に達したクエリは `repo:` で分割して再実行
- 上限: org 内 12 クエリ × org 数、org 外 2 クエリ + メタデータ取得。10 回 / 分の制約で 5 分以上かける

#### G-7. topic 検索 — 採用（org 内は列挙、org 外は L3 候補）

- topic 集合（Round 2 で確定）: `claude-code`、`claude-code-plugin`、`claude-code-plugins`、`claude-plugins`、`claude-plugin`、`agent-skills`、`claude-skills`、`claude-code-skills`、`claude-code-hooks`、`claude-code-marketplace`。関連 topic の発見に `gh api "search/topics?q=claude-code"` を 1 回
- org 内: `gh search repos --owner {org} --topic {topic}`（G-1 の topics 欄と突き合わせ。差があれば記録）
- org 外: `gh search repos --topic {topic} --sort stars --limit 50`。G-3 のしきい値で L3 候補を別表に。それ未満は `excluded`
- 完了: topic 集合の全件を org 内・org 外で実行
- 上限: topic 数 × 2 + 1

#### G-8. 組織の公開メンバー — 採用・限定（一覧の取得のみ。リポジトリの巡回はしない）

- 方法: `gh api orgs/anthropics/public_members --paginate` でログイン名の一覧だけ取る
- 用途: (1) G-5 の著者判定の補完（`author_association` が CONTRIBUTOR でも公開メンバーなら社員として扱う）、(2) W-8 / G-5 で見つかった「未知」のリポジトリの owner が公開メンバーなら L3（B2）として記録
- 除外: メンバー個人のリポジトリを巡回して列挙することはしない。定義（1-1）で L1 からリンクされていないものは対象外であり、巡回は範囲を広げすぎる
- 完了: 一覧を取得し、件数を記録
- 上限: 2〜3 回

#### G-9. 他の Anthropic 所有 org の発見 — 採用（1-2 の手続きと接続）

- 方法: `gh api "search/users?q=anthropic+type:org"` と `gh api "search/users?q=claude+type:org"`（`mcp__github__search_users` は allow に無いので `gh api` を使う）。加えて `gh search repos anthropic --match name --sort stars --limit 50` の owner を集める
- 判定: 候補 org ごとに `gh api orgs/{org}` で `is_verified`、`blog`、`company`、`html_url`、`public_repos` を取り、`is_verified` が真で `blog` / `company` が Anthropic のドメインを指せば L1。未検証でも L1 の既知ページからリンクされていれば L1（1-2 (b)）。どちらでもなければ対象外（成りすましの可能性も記録）
- 発見源の追加（R6。Fable 決定）: 名前に anthropic / claude を含まない org は検索で見つからない（`agentskills` が実例。survey は docs のリンクから到達した）。「他チャネルに現れた owner・スコープの集合」（W-8 のリンク先、L-2 の `source` / `homepage`、npm / PyPI の `repository`、CHANGELOG 本文の GitHub owner）を P2-V が全 P1 出力から作り、既知 org の外に 1-2 をかけ、未判定の org を再走査の対象にする。移管・買収で `blog` / `company` が別ドメインの org も同じ経路で拾う。npm は `maintainer:` 検索を P1-C に追加
- sanity test（R6）: P1-G1 は G-9 のクエリだけで `agentskills` が候補に出るかを記録する（出なければ手続きの欠陥の証拠として残す）
- 完了: 検索結果の全候補 org に判定を付ける。L1 と判定した org は G-1 の対象に追加。sanity test の結果を記録
- 上限: 検索 3 回 + 候補数（20 以内を見込む）

#### G-10. GitHub Actions / Marketplace の Action — 独立項目にしない（G-1 と G-6 で拾う）

- G-1 のリポジトリ名・description（例: `claude-code-action`）と G-6 のクエリ 11（`filename:action.yml`）で列挙できる。GitHub Marketplace（`github.com/marketplace`）には公開 API が無く、列挙はリポジトリ側で足りる
- 記録: 該当リポジトリは `activities: ["distribute"]`（CI での `claude plugin validate --strict` 等、配布前の検査に関わる）

#### G-11. 範囲内リポジトリのファイルツリー全列挙 — 採用（C7。G-6 の偽陰性の検出装置。Fable 決定）

- 目的: G-6 の code search は索引の制約（default branch のみ、384 KB 超・fork・archived の除外）があり、署名を持たない資産（`examples/` の hook 例や設定例、同梱スクリプト）を拾えない。ツリーは有限で全件取れる
- 対象: G-1 で `scope_verdict` が in / boundary の全リポジトリ。加えて **out の抜き取り検査**（R4）: G-1 の out から無作為 10 件とスター上位 10 件
- 方法: `gh api "repos/{owner}/{repo}/git/trees/{default_branch}?recursive=1"`。`truncated: true` ならサブツリー（`git/trees/{sha}`）に分割して取り直す。出力は大きいので標準出力に流さず `{scratchpad}/github-trees/{owner}__{repo}.json` に書き、Grep ツールで 2-5 の署名・語に当たるパスだけ抽出する
- 記録: 当たったパスを「repo + path」で JSONL に（G-6 のヒットとの差を「索引外」と注記）。out の抜き取りで 2-5 に当たるパスが 1 件でもあれば、G-1 の out 判定の基準を見直す（P2-V へ `boundary` で回す）
- 完了: 対象全件で truncated が false の全パスに印。抜き取り 20 件の結果を記録
- 上限: 対象リポジトリ数 + 分割分 + 抜き取り 20 回

#### G-12. tags / Releases / branches / org の Packages — 補助（C8。版履歴と配布物の確認。Fable 決定）

- 目的: `claude plugin tag` の規約（`{plugin}--v{version}`）が公式 Marketplace でも使われているなら、tags が Plugin ごとの版履歴の正本になる。CI やサンドボックス用の配布物はリポジトリでなく Packages（ghcr.io）に置かれうる。W-4 は claude-code の Releases しか見ない
- 対象: in の L1 リポジトリ
- 方法: `gh api repos/{owner}/{repo}/tags --paginate`、`.../releases --paginate`、`.../branches --paginate`。org の Packages は `gh api "orgs/{org}/packages?package_type=container"`（`read:packages` スコープが要る。拒否されたら権限拒否として記録し、回避しない）
- 記録: 件数と、tag 名が `{plugin}--v{version}` 規約に合うかの印。Packages の全件に印
- 完了: 対象全件の件数と、packages の全件に印（または権限拒否の記録）
- 上限: 対象リポジトリ数 × 3 + org 数

（この節: **確定**。Phase 0 の反映で C1〜C10 を L-1 / L-2 / L-3 / W-1 / W-6 / W-8 / S-5 / G-11 / G-12 に配置し、M1〜M4 を 1-2 / L-2 / 0-2 / X-5 / W-6 に反映（Fable 決定）。チャネルの採否は Round 1（L-2b、X-6、2-6 を追加）。2-5 のフィルタ語と、2-6 のクエリ集合 12 本・topic 集合・スターのしきい値 100・G-5 の `since`（暫定 2025-10-01。P1-G2 が CHANGELOG で確認）、探索単位の採否全件は Round 2 で確定）

## 3. 終了条件の候補

### 3-1. 候補

| ID | 終了条件 | 確信の根拠（何をもって「もう無い」と言えるか） | 取りこぼす可能性（この条件では見つからないもの） |
|---|---|---|---|
| E1 | チャネル全走査 | 2-1 / 2-2 / 2-6 の各チャネル・探索単位について「列挙の全件数、フィルタ基準、採用 / 除外 / 未確認の件数」が記録されている。加えて（R4。Fable 決定）**out 判定の抜き取り検査**: G-1 の out から無作為 10 件とスター上位 10 件に G-11 のツリー列挙を当て、2-5 の署名・語に当たるパスが無い（あれば out の判定基準を見直す）。**未確認 k は件数でなく個別に列挙**して残存リスクに載せる | 列挙したチャネルの外にあるもの（未知のドメイン・org、どこにも登録されない資産）。フィルタの偽陰性（名前から関連がわからないリポジトリやページ。抜き取りで測る） |
| E2 | リンク閉包の飽和 | 固定した seed（W-8）から深さ 2 までの外向きリンクに、1-1 に無い L1 / L2 のドメイン・org・**repo + path 接頭辞**が現れない（R3。Fable 決定。既知 repo 内の deep link も G-6 / G-11 の列挙と突き合わせ、差が 0） | どこからもリンクされない孤立資産。docs の更新遅れ。SNS でしか告知されないもの |
| E3 | **部分的独立**の探索の収束（R1。Fable 決定で格下げ） | blind 探索者 2 名（Sonnet / Opus）は本リポジトリを cwd として起動されたため、system 文脈（CLAUDE.md、auto-memory、skill / agent 一覧）経由で既知チャネルを受け取っており、完全な blind ではない。P0-B / C は止めず走り切らせ（文脈由来の混入量の実測データ）、Fable は読まない。**評価単位を「項目」から「走査したチャネルの種類」に変更**: blind の「走査の記録」に 2 節に無いチャネル種別があれば、それが E3 の本来の検出対象。項目の一致計算は P2-V が除外規則で行う: (a) 注入文脈にしか無い語（`cc-workspace`、`LLMs`、`official-llms-txts`、`empty-can`、`marketplace-for-cc`、`.claude/work`、`official-assets`、`test-repo-design`、`claude-code-guide`、`statusline`、`pre-compact`、`cc-relative-info`、インストール済み Plugin 名）に当たる項目は flag、(b) そのうち `verified` に取得 URL と方法が無いものだけを一致計算から除外（取得で裏付けられた項目は文脈語を含んでいても残す）。clean 環境での出し直しは 8 節 D11 | LLM 同士の共通の盲点（学習データの共有、カットオフ以降の公開物）。探索者の Web 権限の差。注入文脈由来の偽の収束（除外規則で減らすが無くならない） |
| E4 | 公式の自己索引との包含 | Anthropic 自身の索引の項目が全て棚卸しに含まれる。索引ごとに「seed / 入力に使ったか」の列を持たせ、**チャネル設計に使っていない索引を 2 つ以上**含め、使っていない索引だけで包含率を出す（R2。Fable 決定。survey の出発点や W-8 の seed と重なる索引では包含が自明に成立するため）。使っていない索引: (1) org の pinnedItems と profile README（G-1 で取得）、(2) C9 の予約 Marketplace 名の一覧、(3) C2 の `claude-code-guide` agent の説明が参照する項目。使った索引（参考値）: `claude.com/docs/build/overview` の 7 ツール（survey 2-1）、code.claude.com の plugins / skills / eval の関連リンク、`anthropics/claude-code` README | 索引の更新遅れ。索引に載らない資産（同梱スクリプト、テンプレート） |
| E5 | 収束の判定と監視への移行 | 主: 再走査 1 回で新規の L1 / L2 がゼロ（収束）。**再走査はクエリ・seed・モデル・チャネルの少なくとも 1 つを変え、変えた変数を記録する**（R7。Fable 決定。同じ入力の再走査は再現性の確認でしかなく収束判定に使わない）。新規は公開日で「T 以前（見落とし）」と「T 以後（新規公開）」に分け、収束判定は T 以前だけで行う。従: 有限化のための上限（エージェント数・呼び出し回数・再走査回数。**費用の上限ではない**。Round 1 追補 2）に達した。以後は監視（`llms.txt` 差分、org のリポジトリ一覧差分、CHANGELOG 差分、Marketplace キャッシュの更新）に委ねる | スナップショット時に見落とし、かつその後更新されない静的資産 |
| E6 | 用途ベースの充足 | テスト手法の整理文書 2-7 の 9 手法（C、B、A、probe、manual、発火テスト、スクリプト単体、環境の事実確認、利用実績の観測）× 3 活動（開発 / テスト / 配布）の **全セルに「資産あり（ID）」か「確認済みで無し」が入る**（Round 1）。**「確認済みで無し」のセルには照会したチャネル・クエリの ID を必須**にする（R8。Fable 決定。E1〜E4 の穴を「無し」で埋めないため）。**「どの手法・活動にも対応づかない資産」を独立の欄に出し**、0 でなければ行の追加を検討する（例: `/skill-doctor` の診断、CI の `validate --strict`、`claude plugin tag` の版管理）。MCP / SDK の行は設けない | マトリクスに無い用途（監視、保守、セキュリティ）。行を追加するか範囲外と明記する |

### 3-2. 推奨の組み合わせ

- **E1 を主**にし、E2 / E3 / E4 を「反証の試み」として重ねる。反証が出ないことが確信の根拠になる。どれか 1 つでは「もう無い」は言えない
- **E6 で「この目的にとって終わり」を判定**する。E1〜E4 は「世界に無い」側の条件、E6 は「必要なものは揃った」側の条件で、両方が要る
- **E5 で有限化**する。穴が見つかった場合の再走査は最大 1 回。それでも残るものは「残存リスク」として終了宣言に書き、監視に委ねる。上限は収束のためのもので、**費用を理由にチャネルや探索単位を落とさない**（Round 1 追補 2）
- 採らないもの: 統計的推定（捕獲再捕獲など）。LLM 探索者は独立でないため前提が成り立たない

（3-2: **確定**（Round 1））

### 3-3. 終了宣言の雛形（Fable が埋める）

```text
終了宣言（YYYY-MM-DD、Claude Code vX.Y.Z）
- 定義: 1 節の L1 / L2（L3 は別表、MCP は L2 だが範囲外）。範囲: 0-2 節
- 走査したチャネル: L-1〜L-3（L-2b を含む）、W-1〜W-8（W-2 / W-3 は 2-6 の G-1〜G-10）。各チャネル・探索単位の件数（列挙 N / 採用 n / 除外 m / 未確認 k / 境界 b）
- GitHub の制約に当たった探索単位（code search の 1,000 件上限、索引除外、レート制限）とその扱い: ...
- 反証の試み: E2 深さ 2 で未知 0 件。E3 blind 2 名の追加 0 件（X 件なら対応内容）。E4 索引の包含 100%
- E6: 9 手法 × 3 活動のセル埋め率 100%。「確認済みで無し」のセル: ...
- 残存リスク（定型文）: Discord / X / YouTube でしか告知されず docs / CHANGELOG / blog に現れていない資産は検出できない（X-1 の前提）。どこからもリンクされず、名前からも関連がわからない資産は E1 / E2 の対象外。LLM 探索者（E3）は学習データを共有するため、共通の盲点は検出できない。E3 の blind 探索者は本リポジトリの system 文脈を受けており部分的独立にとどまる（R1）。観測環境（Claude Code の版・アカウント・組織設定）に依存する資産（組み込み agent / skill、アカウント供給の skill、Plugin ディレクトリのカタログ、段階的に出し分けられる機能）は、この環境で見えたものに限る（R9。各出力冒頭の `claude --version` と取得時刻を参照）
- 残存リスク（個別）: ...（E1 の未確認 k は個別に列挙する。R4）
- 監視への移行: 追加する監視対象の案 ...（作業指示者の承認待ち。8 節）
```

（3-3: **確定**（Round 2））

## 4. サブエージェントへの分割表

### 4-1. 方針

- アイデア出し（Phase 0）とチャネル別の調査（Phase 1）は別物として扱う。アイデア出しは Web を使わず、データに引きずられない状態で計画を攻撃させる
- モデルの使い分けは**費用ではなく判断の質で決める**（Round 1 追補 2）: 列挙・取得・整形・検証は Sonnet（判断を求めない作業で、Sonnet で足りる）。定義や終了条件への批判、資産の中身を読んでの対応づけは Opus（質的判断が要る）
- 出力先は `.claude/work/official-assets/`（Round 1、Q5。Fable が作成済み）。全エージェントが 4-4 の記録様式で書く
- 上限（**有限化のためのもので、費用の上限ではない**。Round 1 追補 2: 費用は考慮指標として優先度が最低（作業指示者の指示））: Phase 0 は 3 体、Phase 1 は 6 体（P1-G を G1 / G2 に分割。P1-G2 だけ P1-G1 の完了後に起動）、Phase 2 は 2 体 + P2-R 1 体（0.2 版で新設。5-1）、再走査は 1 体まで。合計 13 体。ツール呼び出しの上限は列挙に必要な回数から逆算する（0.4 版で Phase 0 の追加作業に合わせて再計算。費用は優先度最低、有限化のためだけに決める）: P1-L は 60 回（C1〜C4、C9 の追加）、P1-D は 60 回（C5 の 4 サイトの sitemap、R3 の path 単位）、P1-G1 は 100 回（G-1 10 + G-2 15 + G-7 21 + G-8 3 + G-9 23 + G-12 20 + pinnedItems 5 + 予備）、P1-G2 は 140 回（G-6 12 × org 数 + org 外、G-11 対象数 + 抜き取り 20、G-5 60、G-4 40、C4 catalog と C9 対応づけ。超える場合は G-6 → G-11 → G-5 → G-4 の優先で後ろを期間で絞るか未走査にする）、P1-C は 50 回（R10 の初出特定、R6 の npm `maintainer:` 検索）、P1-B は 50 回（C6、C10）、P2-R は 60 回（M5 の identity の取得）、P2-V は 30 回（R1、R2、R3、R6 の再計算）、P2-M は 40 回、P0-A は 10 回、blind 探索者は 30 回。出力は 300 行まで
- **行数の上限と「上限に達したら未走査の範囲を明記して終える」規則は、Fable のコンテキスト保護のために残す**（Round 1 追補 2）。費用を理由にチャネル・探索単位・blind 探索者（P0-B / C の両方を採る）を削らない
- **Phase 0 と Phase 1 は同時に起動しない**。5-2 手順 1 のとおり P0-A の結果を 2 節に反映してから Phase 1 を起動する（Round 1 で確認）

### 4-2. 分割表

権限は 4-3 の決定（WebFetch ドメインと `claude` の `--help` を `.claude/settings.json` に追加済みの前提）に合わせた確定表記。`mcp__fetch__fetch` は WebFetch が失敗したときの代替。ただし blind 探索者（P0-B / C）だけは WebFetch を使わず `mcp__fetch__fetch` を主にする（Round 2。理由は 4-5）。

| ID | 役割 | モデル（理由） | 入力 | 出力ファイル | 必要権限 | 並列 / 順序 |
|---|---|---|---|---|---|---|
| P0-A | 探索アプローチのアイデア出し（red team）。本計画書を読み、チャネルの抜け（上限 10）と終了条件への反証（上限 10）を出す。Web 不可 | Opus（定義と終了条件の弱点を突くには判断の質が要る） | 本計画書（確定版）、survey 1〜2 節 | `p0-ideas.md` | Read、Write(.claude/work/**)。Web・MCP・Bash なし | Phase 0。P0-B / C と並列 |
| P0-B | blind 探索者。定義と範囲だけを渡し、survey 2 節も既知のチャネル名も見せない。知識と制限付き Web で L1 / L2 の情報源・資産を列挙 | Sonnet（列挙と取得が主で、判断を求めない） | ファイルは渡さない。プロンプトに埋め込む: 0-2 の範囲、1-1 の「定義」列（「該当」列は渡さない）、1-2 の手続き、1-3、4-4 の記録様式（付録 A-2） | `p0-blind-sonnet.md` / `.jsonl` | WebSearch、`mcp__fetch__fetch`（任意 URL。**WebFetch は使わせない**: 許可ドメイン一覧が既知チャネルそのもので、許可外の auto-deny が取得先を誘導するため。Round 2）、`mcp__github__search_repositories`、`mcp__github__search_code`、`mcp__github__get_file_contents`、`gh api *`、`gh search *`、Write | Phase 0。並列 |
| P0-C | 同上（モデルを変えて盲点をずらす） | Opus（学習データと探索の癖が Sonnet と異なる） | 同上 | `p0-blind-opus.md` / `.jsonl` | 同上 | Phase 0。並列 |
| P1-L | ローカル層 L-1、L-2、L-2b、L-3 の列挙。追加確認: code.claude.com の changelog ページの有無、Plugin ディレクトリ機能の docs 上の説明の有無。**Phase 0 追加**: C1（本体中の URL 列挙）、C2（組み込み agent / skill 一覧の転記と出所分類）、C3（`anthropic-skills:` 名前空間。境界）、C4（ローカルの `$schema` 値）、C9（予約 Marketplace 名の一覧）、M2（L-2 の分類を著作者判定に一本化） | Sonnet（機械的） | 2-1、2-5、4-4 | `p1-local.md` / `.jsonl` | Read、Glob、Grep（`llms-full.txt` と `plugin-directory-cache-v2.json` は Grep ツール必須）、Bash: `ls`、`find`、`head`、`wc`、`command -v claude`、`claude --help`、`claude plugin --help`、`claude plugin eval --help`（完全一致で追加済み） | Phase 1。並列 |
| P1-D | docs の `llms.txt`（W-1）とリンク閉包（W-8）。追加確認: Plugin ディレクトリ機能の説明ページ、`$schema` / schemastore への言及、M3 の Organization 配布の受理条件のページ。**Phase 0 追加**: C5 / R5（4 サイトの sitemap と llms.txt の差集合。code.claude.com の分は L-1 と突き合わせる）、R3（W-8 の未知の単位を repo + path 接頭辞にし、既知 repo 内の path を残す）、C10（seed に academy-guide） | Sonnet（取得とフィルタの機械作業） | 2-2 の W-1 / W-8、2-5、1-1 の既知集合、4-4 | `p1-docs.md` / `.jsonl` | WebFetch(domain:claude.com)、WebFetch(domain:platform.claude.com)、WebFetch(domain:agentskills.io)、WebFetch(domain:code.claude.com)、WebFetch(domain:github.com/anthropics)、`mcp__fetch__fetch`（代替）、Write | Phase 1。並列 |
| P1-G1 | GitHub の構造（2-6）: G-1 org 全リポジトリとメタデータ、G-2 fork 関係、G-3 スター数の記録、G-7 topic、G-8 公開メンバー一覧、G-9 他 org の発見、G-10 Action。追加確認: `anthropics/claude-plugins-public` の正体（B1）。**Phase 0 追加**: G-12（C8。tags / Releases / branches / Packages。補助）、R2（org の pinnedItems と profile README の取得）、R6（G-9 の sanity test: クエリだけで `agentskills` が出るか） | Sonnet（GraphQL / REST の列挙と欄の転記で判断を求めない。**2 体に分ける理由**: レート制限の系統が違う（REST / GraphQL と、code search の 10 回 / 分）、呼び出し回数が 1 体の上限を超える、wiki の clone という隔離の要る作業を 1 体に閉じ込める） | 1-2、2-5、2-6、4-4 | `p1-github-structure.md` / `.jsonl` | Bash: `gh api *`（REST、GraphQL、`search/users`、`rate_limit`）、`gh search *`。MCP: `mcp__github__search_repositories`、`get_file_contents`、`list_tags`。WebFetch(domain:github.com/anthropics)、Write | Phase 1。並列 |
| P1-G2 | GitHub の中身（2-6）: G-4 wiki、G-5 issues / discussions、G-6 署名 code search（org 内・org 外）。追加確認: `json.schemastore.org/claude-code-settings.json` の出所（B5。SchemaStore/schemastore 上のファイルと投稿者）。**Phase 0 追加**: G-11（C7。in / boundary のツリー全列挙と、R4 の out 抜き取り 20 件）、C4（SchemaStore catalog の Claude 関連エントリ）、C9（予約名の実体への対応づけ）、R10（`since` を P1-C の値か自分の CHANGELOG 確認で決める） | Sonnet（固定クエリの実行と抽出。issue 本文からのリンク抽出も基準が固定。判断が要る箇所は `boundary` で回す） | 1-2、2-5、2-6、4-4、`p1-github-structure.jsonl`（P1-G1 の出力。`scope_verdict` が in / boundary のリポジトリを G-4 / G-5 の対象にする。G-5 の既定 3 リポジトリは常に含める）。G-5 の `since` は P1-C が特定した値（R10）。P1-C が終わっていなければ自分で CHANGELOG を見る。暫定 2025-10-01 は最後のフォールバック。`p1-local.md`（C9 の予約名一覧） | `p1-github-content.md` / `.jsonl` | Bash: `gh api *`、`gh search *`、`git clone`（wiki。`{scratchpad}/github-wiki/` 配下へ）、`find`、`wc`。MCP: `mcp__github__search_code`、`search_issues`、`get_issue`、`get_issue_comments`、`get_file_contents`。WebFetch(domain:github.com/anthropics)、WebFetch(domain:raw.githubusercontent.com)、`mcp__fetch__fetch`（json.schemastore.org。WebFetch 対象外ドメイン）、Write | Phase 1。**P1-G1 の完了後**に起動（他の 5 体とは独立。Round 2） |
| P1-C | CHANGELOG / Releases（W-4）とレジストリ（W-5）。**Phase 0 追加**: R10（hooks / statusline / skills / plugin の CHANGELOG 上の初出の版と日付を特定し、最古を `since` として報告）、R6（npm の `maintainer:` 検索で `@anthropic-ai` 以外のスコープを拾う。PyPI は organization ページで列挙。CHANGELOG 本文の GitHub owner を集める） | Sonnet（キーワード走査と API 列挙の機械作業） | 2-2 の W-4 / W-5、2-5、1-2 の手続き、4-4 | `p1-changelog-registry.md` / `.jsonl` | `mcp__github__get_file_contents`、Bash `gh api repos/anthropics/claude-code/releases`、WebFetch(domain:raw.githubusercontent.com)、WebFetch(domain:registry.npmjs.org)、WebFetch(domain:pypi.org)、`mcp__fetch__fetch`（代替）、Write | Phase 1。並列 |
| P1-B | blog / support（W-6 / W-7）と補助 S-1 / S-3。最初のタスクは `anthropic.com` と `claude.com` の sitemap の有無。**Phase 0 追加**: C6 / M4（claude.com の docs 以外のパス）、C10 / S-5（Anthropic Academy のコースカタログ。URL は推測せず辿る） | Sonnet（sitemap と検索結果のフィルタ。判断を求めない） | 2-2 の W-6 / W-7、2-3 の S-1 / S-3、2-5 のクエリ集合、4-4 | `p1-blog-support.md` / `.jsonl` | WebFetch(domain:anthropic.com)、WebFetch(domain:support.claude.com)、WebSearch、`mcp__fetch__fetch`（コミュニティのリスト等、WebFetch 対象外ドメイン）、Write | Phase 1。並列 |
| **P2-R**（0.2 版で新設） | 結合と検証。P1 の全 JSONL を結合し、最終 URL で重複を除き、survey 2 節に無い新規の L1 / L2 項目を**全件**再取得して存在・リダイレクト先・権威の根拠を確かめる。既知の項目は再取得しない。確認できないものは `status: unverified` に落とす。**Phase 0 追加（M5）**: URL の重複除去に加えて `identity`（名前 + tree SHA か content_sha256 + origin）で「複製グループ」の表を作り、複製間の版のずれを記録する（例: skill-creator の 2〜3 複製） | Sonnet（URL の再取得と欄の照合は機械作業。5-1） | P1 の全出力、survey 2 節、1-2 の手続き | `p2-merged.md` / `.jsonl`、`p2-verify.md`（検証の記録） | Read、WebFetch（4-3 の全ドメイン）、`mcp__fetch__fetch`、`gh api *`、`mcp__github__get_file_contents`、Write | Phase 2。P1 の全完了後。**P2-V と並列** |
| P2-V | クロスチェック（red team）。P1 の生出力と P0-B / C を突き合わせ、E2 / E3 / E4 の照合を行い、穴・矛盾・定義の破れを指摘。E1〜E6 の達成度を判定し、再走査の要否と対象チャネルを提案。**Phase 0 追加**: R1（E3 の除外規則 (a) (b) の適用と、評価単位「走査したチャネルの種類」での判定。文脈由来の混入量の実測）、R2（E4 を「使っていない索引」だけで再計算）、R3（W-8 の path 単位の未知と G-6 / G-11 の差分）、R6（全 P1 出力から owner・スコープの集合を作り、既知 org の外に 1-2 をかける） | Opus（突き合わせと矛盾の指摘に判断の質が要る） | P0-A〜C と P1 の全出力、本計画書。Fable は P0-B / C を読まずにパスだけ渡す | `p2-coverage.md` | Read、WebFetch（4-3 の全ドメイン。抜き取りの再確認）、`mcp__github__get_file_contents`、Write | Phase 2。P1 の全完了後。P2-R と並列 |
| P2-M | 対応づけ。確定した資産ごとに「何を確かめられるか / 確かめられないか / 採用するか」をテスト手法の軸（5 観点 × 9 手法 × 3 活動）に対応づけ、E6 のマトリクスを埋める。棚卸し文書の草稿。**Phase 0 追加（R8）**: 「確認済みで無し」のセルに照会したチャネル・クエリの ID を必須にし、「どの手法・活動にも対応づかない資産」を独立の欄に出す | Opus（資産の中身を読んで質的に判断する） | `p2-merged.jsonl`（Fable の抜き取り検証後）、`test-methods-organized_2026-10-12.md`、資産の中身（ローカルキャッシュ、`get_file_contents`） | `p2-mapping.md` | Read、Grep、`mcp__github__get_file_contents`、WebFetch（4-3 の全ドメイン）、Write | Phase 2。P2-R と P2-V の後（穴があれば再走査 1 回を挟む） |

### 4-3. 権限（Round 1 で Fable が決定。Phase 1 の起動直前に追加し、作業指示者への報告に含める）

| 区分 | 内容 |
|---|---|
| 追加する WebFetch ドメイン（チーム共有 `.claude/settings.json`。`agent-permission-runtime.md` 2-2） | `claude.com`、`platform.claude.com`、`agentskills.io`、`anthropic.com`、`support.claude.com`、`raw.githubusercontent.com`、`registry.npmjs.org`、`pypi.org` |
| 追加する Bash（完全一致。同じ場所） | `claude --help`、`claude plugin --help`、`claude plugin eval --help`、`claude --version`（R9。全 P1 が出力冒頭に記録する） |
| 許可済みで足りる | WebSearch、`mcp__fetch__fetch`（任意 URL。代替手段として残す）、`mcp__github__*` 読み取り系（`search_repositories`、`search_code`、`search_issues`、`get_file_contents`、`list_issues`、`get_issue`、`get_issue_comments`、`list_commits`、`get_commit`、`list_branches`、`list_tags`、`get_tag`、`list_pull_requests`、`get_pull_request*`）、`gh api *`（REST、GraphQL、`search/users`、`rate_limit`、org members、discussions を含む）、`gh search *`、`git *`（wiki の `git clone` を含む）、`command -v`、`ls` / `head` / `wc` / `find` / `grep`、Write / Edit `.claude/**`、`WebFetch(domain:code.claude.com / docs.claude.com / github.com/anthropics)` |
| allow に無いが不要 | `mcp__github__search_users`（`gh api "search/users?q=..."` で代替。追加するなら 4-3 に書く） |
| 発行されない | Edit（既存ファイルの編集は Fable だけが行う）、PowerShell、Agent（サブエージェントは子を起動しない）、`claude plugin eval init`（書き込みを伴う）、`npm *`、Read deny 該当パス（`.env*` 等に触る理由が無い）、wiki clone 内のファイルの実行 |

- background 起動では起動前に事前 prompt が出て、以後は未承認が auto-deny になる（`agent-permission-runtime.md` 3-5）。Fable は各行の権限を起動直前に揃える
- WebFetch 対象外のドメイン（`json.schemastore.org`、`www.schemastore.org`、コミュニティのリスト等）は `mcp__fetch__fetch` で取る
- G-12 の `gh api orgs/{org}/packages` は `read:packages` スコープが要る。拒否されたら権限拒否として記録し、回避しない（C8）

### 4-4. 共通の記録様式（全エージェントの出力に強制。二本立て）

Markdown 表は人が読むためのもので 8 列に圧縮し、機械結合は JSON Lines で行う（Round 1 の指示。判断）。両方とも同じ basename で出す（`p1-docs.md` と `p1-docs.jsonl`）。

**(1) Markdown 表（8 列）**

```text
| ID | 名称 | URL（最終 URL） | 種別 / 権威（例: 資産 / L1） | 権威の対象 | 活動と範囲判定（例: テスト / 内） | 発見チャネル | 一次確認（取得日、SHA か version） |
```

- **Markdown 表に載せるのは `status` が `candidate` と `boundary` の行だけ**。除外（`excluded`）と未確認（`unverified`）は件数表（チャネル別の列挙 / 採用 / 除外 / 未確認 / 境界）にまとめ、全件は JSONL にだけ書く（300 行の上限と Fable のコンテキスト保護のため。Round 1 追補 2）。続けて「走査の記録」（フィルタ基準、未走査の範囲、GitHub の制約に当たった箇所）を書く

**(2) JSON Lines（1 行 1 項目。全フィールド）**

```text
id              文字列。"<エージェントID>-<連番>"（例: "P1-D-012"）
name            名称
url             最終 URL
aliases         配列。旧 URL・リダイレクト元
kind            "source" | "asset"
authority       "L1" | "L2" | "L3" | "out"
authority_basis 根拠（ドメイン / org / scope / author / リンク元）
authority_scope 配列。"format" | "behavior" | "policy" | "reference" | "changelog"
activities      配列。"develop" | "test" | "distribute"
scope_verdict   "in" | "boundary" | "out"
channel         配列。"L-1" 等
verified        {"date": "YYYY-MM-DD", "method": "WebFetch" 等, "ref": "commit SHA か version か空"}
known           true | false | null（survey 2 節との比較。blind 探索者は null）
watchable       配列。"llms_txt" | "sitemap" | "rss" | "git" | "none"
identity        資産の同一性（M5。URL が違っても同一の資産を 1 つに数え、複製間の版のずれを見るため）。
                {"name": 名称, "tree_sha": git tree SHA（ディレクトリの資産）または "content_sha256": 主ファイルの sha256（単一ファイル）, "origin": 出所（repo か URL）}。取れない場合は null
gh              GitHub のリポジトリ項目だけ（Round 1 追補。JSON Lines 側にだけ持ち、Markdown 表には出さない）。
                {"owner", "repo", "stars", "forks", "archived", "is_fork", "parent", "pushed_at",
                 "has_wiki", "wiki_has_content", "wiki_pages", "has_discussions", "topics": [], "license", "homepage"}
status          "candidate" | "excluded" | "unverified"
excluded_reason 除外理由（status が excluded のとき）
notes           備考
```

- 除外した項目も同じ JSONL に `status: "excluded"` で含める。「もう無い」の裏付けは、何を見て何を外したかの記録でしか示せない
- 範囲の判定で迷ったものは自分で決めず `scope_verdict: "boundary"` にして Fable に回す
- P2-R は全 JSONL を結合して `p2-merged.jsonl` を作る。URL の重複除去に加えて `identity` で複製グループの表を作る（M5）。Fable は 1 ファイルだけ読めばよい

### 4-5. 全エージェントに伝搬する指示（サブエージェントはこの会話を持たない。付録 A の共通前文に転記）

- 証拠: 取得 URL と取得日と取得方法を伴わない項目は `status: "unverified"`。存在を推測で書かない
- 1 MB を超えるファイル（`llms-full.txt`、`plugin-directory-cache-v2.json` 等）に Bash の `grep` / `cat` / `sed` を使わない。Grep ツールを使い、全文 Read しない
- 出力の上限（行数、ツール呼び出し回数）を守る。上限に達したら「未走査」の範囲を明記して終える
- Windows 11 の Git Bash。パスは絶対パス。`.bat` に触らない。git 操作をしない（例外: P1-G2 の wiki `git clone` だけ）。既存ファイルを編集しない
- `git clone` したもの（wiki）はダウンロード物として隔離する。`{scratchpad}/github-wiki/{owner}__{repo}/` に 1 リポジトリ 1 フォルダで置き、中のファイルを実行しない、その中で interpreter やビルドを起動しない。読むのは Read / Grep だけ
- blind 探索者（P0-B / C）にはファイルを渡さず、プロンプトに抽象的な定義と範囲だけを埋め込む。survey 2 節、1-1 の「該当」列、1-4、2 節、他エージェントの出力、1-2 の表（検索方法がチャネルのヒントになる）を渡さない。既知のチャネルを渡すと E3 が「チャネルの穴」を検出できなくなる。WebFetch も使わせない（許可ドメイン一覧が既知チャネルそのもので、許可外の auto-deny が取得先を誘導する）。取得は `mcp__fetch__fetch` と WebSearch で行わせ、URL は自分で決めさせる（Round 2）
- 範囲内 / 外の最終判定と「採用するか」は Fable と作業指示者が決める。エージェントは材料と仮判定を出す
- 最終報告は短く（付録 A-0 の定型）。内容はファイルに書く。P0-B / C は「完了、N 件」の 1 行だけ
- 各 P1 出力の冒頭に `claude --version` の出力と取得時刻を記録する（R9。Phase 1 の開始時と終了時で版がずれたら記録する）
- P0-B / C は本リポジトリを cwd に起動されたので system 文脈（CLAUDE.md、auto-memory、skill / agent 一覧）を受けており、完全な blind ではない（R1。Fable 決定）。走り切らせ、Fable は読まず、P2-V が E3 の除外規則で扱う

（この節: **確定**（Round 2）。P2-R の新設、P1-G の G1 / G2 分割、上限値、出力先、4-4 の二本立てを採用。4-3 の権限は Fable が Phase 1 の起動直前に追加し、作業指示者へ報告する）

## 5. メインセッション（Fable）の統合手順

### 5-1. 証拠ポリシー

- サブエージェントの報告は「モデルの出力」であり、事実の確認でも作業指示者の承認でもない
- 棚卸しに載せるのは、取得 URL と取得日を伴う記録だけ
- 新規の L1 / L2 項目の全件再取得は **Sonnet の検証役 P2-R を新設して委ねる**（Round 1 の選択肢のうち後者。判断）。理由: (a) 再取得は URL の存在・リダイレクト先・権威の根拠（org 欄、scope、author）を機械的に確かめる作業で、判断を要しない。(b) P2-V（Opus）に混ぜると取得結果でコンテキストが埋まり、批判の質が落ちる。(c) 「事実の検証」と「網羅の批判」を分けると証跡の責任が明確になる。(d) P2-R と P2-V は並列に走れるので、Phase 2 の段数が増えない
- Fable は、P2-R が「確認済み」とした項目の **1 割を抜き取りで自分で再取得**する（検証者の検証）。抜き取りで誤りが見つかったら、P2-R の出力全体を疑い、該当チャネルを再検証に回す
- 確認できないものは `unverified` に落とし、終了宣言の k に数える

### 5-2. 手順

1. **Phase 0 の起動と受け取り**: P0-A、P0-B、P0-C を並列起動。P0-A の提案チャネルを「列挙可能か、少なくとも有限か」で判定し、通ったものを 2-2 に追加する。通らないものは 2-3 / 2-4 に理由付きで置く。**P0-B / C の出力ファイルは読まない**（封印。Fable 自身のバイアス回避）
2. **権限の追加と Phase 1 の起動**: 4-3 のとおり `.claude/settings.json` に追加し、作業指示者へ報告。P1-L、P1-D、P1-G1、P1-C、P1-B の 5 体を 1 メッセージで並列起動し（orchestrate パターン A）、**P1-G2 は P1-G1 の完了後**に `p1-github-structure.jsonl` のパスを渡して起動する（Round 2）。P1-G1 / G2 は同じ GitHub アカウントのレート制限を共有するので、両者の報告に `rate_limit` の残量を含めさせる
3. **Phase 2 前半（並列）**: P2-R（結合・重複排除・新規 L1 / L2 の全件再取得）と P2-V（E2 / E3 / E4 の照合と達成度の判定）を並列起動。P2-V には P0-B / C のパスを渡すが、Fable は読まない
4. **Fable の照合**: `p2-merged.md`（1 ファイル）と `p2-coverage.md` を読む。P2-R の「確認済み」から 1 割を抜き取って再取得。P2-V が穴（和集合に無い L1 / L2、未知のドメイン・org・repo + path、索引の未包含、R6 の未判定 owner・スコープ）を報告したら、該当チャネルを追加して **再走査を 1 回だけ** 行う（対象の P1 エージェント 1 体を再起動）。**再走査はクエリ・seed・モデル・チャネルの少なくとも 1 つを変え、変えた変数を記録する**（R7）。再走査で出た新規は公開日で「T 以前（見落とし）」と「T 以後（新規公開）」に分け、収束判定は T 以前で行う。再走査の出力は件数が少なければ Fable が `p2-merged.jsonl` に追記し、多ければ P2-R を差分モードで再起動する（上限 +1 体。8 節）
5. **Phase 2 後半**: P2-M に `p2-merged.jsonl` とテスト手法の整理文書を渡し、棚卸し文書の草稿を得る
6. **Fable の成果物**: 棚卸し文書（P2-M の草稿を Fable が検証して仕上げる）、L3 の別表、情報源の階層（survey 2-4 の更新）、監視対象の追加案、終了宣言（3-3 の雛形を埋める）、作業指示者の判断事項（8 節の更新）
7. **survey の更新**: 3 節に終了宣言と判断事項へのリンクを書く（2-2 の claude-security の誤記の訂正は Round 1 で Fable が実施済み）

### 5-3. 誰が決めるか

| 事項 | Fable が決める | 作業指示者に回す |
|---|---|---|
| 重複排除、最終 URL の正規化 | P2-R に委ね、抜き取りで検証 | |
| 権威レベルの付与（1-2 の手続きに従う） | ○ | 手続きで決まらない新たな境界事例 |
| チャネルの網羅の判定（E1 の件数の記録） | ○ | |
| 範囲内 / 外の判定 | 2-5 の語で決まるもの | `boundary` の付いたもの |
| 再走査の実施（最大 1 回） | ○ | 2 回目が要ると判断したとき（収束判定の例外。8 節 D2） |
| 監視対象の追加 | 案を出す | 採否（監視のコストは作業指示者の負担。8 節） |
| 終了宣言の受理 | 草稿を書く | 受理、または残存リスクの受容 |
| 資産を設計で採用するか | P2-M の仮判定を検証する | 最終判断（設計書への反映は別作業） |

（この節: **確定**（Round 2））

## 6. 対話の計画（本エージェントと Fable の往復は最大 3 回）

| Round | 本エージェントの提出 | Fable に確定してもらう事項 | Fable から聞きたいこと |
|---|---|---|---|
| 1 | 0.1 版 | 0-2 の範囲。1 節の定義と 1-4 の境界事例の判定。2 節のチャネルの採否。3-2 の終了条件の組み合わせ | Q1〜Q5 の回答。構成の過不足 |
| 2 | 0.2 版（本書） | 4 節の分割表（P2-R の新設、P1-G の 2 分割、上限値、出力先）。4-4 の記録様式（二本立て、`gh` オブジェクト）。2-5 のフィルタ語。2-6 のクエリ集合・topic 集合・スターのしきい値（100）・G-5 の `since`。3-3 の終了宣言の雛形。5 節の統合手順と 5-3 の分担。8 節の一覧。付録 A のプロンプト雛形 | 付録 A の雛形がそのまま起動に使える形か。P2-R を採るか（採らないなら P2-V に全件再取得を含める）。2-6 の探索単位の採否に異論があるか（特に G-2 (b)、G-5、G-8） |
| 3 | 0.3 版（本書。Round 2 の回答を反映し「確定、実行へ」） | 無し（全節が確定。未確定事項は残っていない） | 無し（Fable の確認のみ。以後の修正は Fable が自分で編集する） |

- 各節末尾の「（確定 / 未確定）」印で収束を可視化する。Round 3 の時点で未確定のものは 8 節へ移して閉じ、本エージェントとの往復では再び扱わない
- **Round 4 は無い**。Round 3 以降に修正が要るなら Fable が本書を自分で編集する。本エージェントは Round 3 の提出で終了する
- Round 1 の実績: Fable の批評は「節の差し替え・追加」の形で来たので、1 Round で反映できた

（この節: **確定**（Round 1 で受け入れ））

## 7. メインセッションへの質問と回答（Round 1）

| # | 質問 | 回答（Round 1） | 反映先 |
|---|---|---|---|
| Q1 | LLMs リポジトリの日次ウォッチの仕組みと、監視対象を増やすコスト・判断基準 | `C:\cc-workspace\LLMs`（origin `empty-can/LLMs`）の日次無人パイプライン（取得 → サマリ生成 → 第三者レビュー → 人手レビュー → main へ merge）。対象は `official-llms-txts/` の 2 サイトだけ。1 つ増やすコストは、別リポジトリでの取得スクリプトとサマリ生成の設定変更に加え、日次の人手レビューの負荷増。判断基準と採否は作業指示者 | E5、4-4 の `watchable`（`llms.txt` / sitemap / RSS / git の有無で足りる）、8 節 |
| Q2 | 予算の上限 | 追補 2（作業指示者）: **費用（サブエージェントの数・呼び出し回数）は考慮指標として優先度が最低**。上限は「費用の上限」ではなく「有限化のための上限（E5）」として扱い、値は網羅性の観点から決め直してよい。行数上限と「未走査を明記して終える」規則は Fable のコンテキスト保護のために残す | 3-1 E5、3-2、4-1（13 体、P1-G 系は逆算）、8 節 D1 |
| Q3 | MCP / Agent SDK を含む Plugin の予定 | 無い。予定も無い | 0-2、1-1、2-5（境界語）、E6 |
| Q4 | 準公式の線引き | Fable の仮判定: (a) `external_plugins/` は棚卸しに載せず L3 の別表に名称とリンク元だけ、(b) 社員の個人リポジトリも L3 記録のみ、(c) `pre-submission-checklist` は「提出しない限り対象外」を明記したうえで品質基準として参照可 | 1-1、1-4、0-2、8 節 |
| Q5 | ローカルの実体、出力先、WebFetch か `mcp__fetch__fetch` か | L-1 は 2 サイト、L-2 は 2 Marketplace + 6 cache、L-2b を新規発見、Claude Code は 2.1.296。出力先は `.claude/work/official-assets/`。WebFetch のドメイン追加を採り、`mcp__fetch__fetch` は代替 | 2-1、4-1、4-3 |

## 8. 作業指示者の判断事項（Fable の仮決定と、作業指示者にしか決められないもの）

Round 3 で未確定のまま残った事項もここへ移す。

| # | 事項 | 種別 | 現在の扱い | 状態 |
|---|---|---|---|---|
| D1 | 上限値の確認（承認事項ではなく、作業指示者が把握しておく値。Round 1 追補 2）: 計 13 体（P0 3、P1 6、P2 3（P2-R を含む）、再走査 1）。ツール呼び出しは P1-G1 80 回、P1-G2 100 回、P0-A 10 回、P2-V 20 回、blind 30 回、他 40 回。出力 300 行。費用は考慮指標として優先度最低 | Fable の決定 → 作業指示者が把握 | 決定済み | 確認のみ |
| D2 | 再走査の 2 回目、または P2-R の差分モード再起動が要る場合 | 作業指示者（費用ではなく、終わらない探索を避けるための収束判定の例外として） | **可**（作業指示者、2026-10-13 02:25）。Fable は必要と判断すれば 2 回目まで実施してよい。3 回目以降は再び確認 | 決定済み |
| D3 | 監視対象の追加（`llms.txt` / sitemap / RSS / git の差分監視を LLMs リポジトリに増やすか） | 作業指示者（コストは人手レビューの負荷増。Q1） | **加える**（作業指示者、2026-10-13 02:25）。ただし LLMs リポジトリの監視に加える作業は、本活動中に実施すべき積極的な理由が無い限り LLMs リポジトリ側のバックログとする。Fable は終了時に追加対象の案（サイト、取得 URL、監視可能性）を出し、本活動では実装しない | 決定済み（実装はバックログ） |
| D4 | L3 の扱い (a): `external_plugins/` は棚卸しに載せず、別表に名称とリンク元だけ記録 | Fable の仮判定 → 作業指示者 | 仮判定で進める | 承認待ち |
| D5 | L3 の扱い (b): L1 からリンクされた社員個人のリポジトリは L3 として記録のみ | Fable の仮判定 → 作業指示者 | 仮判定で進める | 承認待ち |
| D6 | `pre-submission-checklist`: 提出しない限り対象外と明記したうえで、品質基準として参照可 | Fable の仮判定 → 作業指示者 | 仮判定で進める | 承認待ち |
| D7 | 終了宣言の受理、または残存リスクの受容 | 作業指示者のみ | Fable が草稿を書く | 終了時 |
| D8 | 出力先 `.claude/work/official-assets/` | Fable 決定 | 確定 | — |
| D9 | WebFetch ドメインと `claude --help` 系の allow をチーム共有 `.claude/settings.json` に追加 | Fable 決定。Phase 1 の起動直前に実施し、作業指示者へ報告 | 確定 | 実施待ち（Phase 1 起動直前） |
| D10 | P2-R（Sonnet の検証役）の新設 | Fable が Round 2 で採用 | 5-1 に理由 | 閉じた（採用） |
| D11 | blind 探索者（P0-B / C）を clean 環境（CLAUDE.md の無い作業ディレクトリ、auto-memory と Plugin を無効）で出し直すか（R1。可否は要確認） | 作業指示者 | 今回の P0-B / C は走り切らせ、E3 は部分的独立として扱う。Phase 2（P2-V の起動）までに決まればよく、Phase 1 は止めない | Phase 2 まで |

（この節: **確定**（Round 2 で Fable が一覧を確認）。D1 は確認のみ、D3〜D7 と D11 の判断は作業指示者。Round 3 で未確定として残った事項は無い。D11 は Phase 0 の反映で追加）

## 付録 A. サブエージェントのプロンプト雛形

Fable は `{ }` を埋めて起動するだけにする。各雛形は A-0 の共通前文の後に個別部分を続ける。

**Fable が起動時に埋める変数（埋め忘れ防止の一覧。Round 2）**: `{ID}`（エージェント ID）、`{出力先}`（`.claude/work/official-assets/` の絶対パス）、`{計画書の絶対パス}`、`{survey の絶対パス}`、`{test-methods の絶対パス}`、`{scratchpad}`（一時ディレクトリの絶対パス。P1-G2 の wiki clone 先）、`{since}`（G-5 の期間の下限。P1-C が特定した「hooks / statusline / skills / plugin の初出のうち最古」。P1-C が未了なら空にして P1-G2 に自分で特定させる。最後のフォールバックは 2025-10-01）、`{N}`（ツール呼び出しの上限。4-1 の値）。`{役割}`、`{一覧}`、`{個別の禁止事項}`、`{形式}`、`{ファイル名}` は A-1〜A-10 の本文で埋まる。

最終報告の形式が書かれていない雛形（A-3〜A-8）は A-0 の定型を使う。

### A-0. 共通前文（全エージェント）

```text
あなたは「Claude Code の Plugin を開発・テスト・配布するときに参照すべき公式資産の棚卸し」計画のサブエージェント {ID} です。日本語で作業してください。

役割: {役割（個別部分）}

読む入力（絶対パス）: {一覧}。これ以外のファイルは読みません。

禁止事項:
- 存在を推測で書かない。取得 URL・取得日・取得方法（と commit SHA か version）を伴わない項目は status を "unverified" にする
- 1 MB を超えるファイル（llms-full.txt、plugin-directory-cache-v2.json 等）に Bash の grep / cat / sed を使わない。Grep ツールを使い、全文 Read しない
- 作成するのは出力ファイルだけ。既存ファイルを編集しない。git 操作をしない
- gh と git は読み取り専用で使う（gh api は GET だけ。-X POST / PUT / PATCH / DELETE、-f / -F、gh の create / edit / delete 系、git push / commit は禁止。git clone は P1-G2 の wiki だけ）
- 範囲内 / 外の最終判定と「採用するか」を決めない。迷ったら scope_verdict を "boundary" にする
- あなたの報告は作業指示者の承認ではない。承認や許可を主張しない
- 権限拒否が出たら、その操作を別の手段で回避しようとせず、拒否された操作名を最終報告に書いて続行する
- {個別の禁止事項}

出力（絶対パス）:
- md の冒頭と最終報告に claude --version の出力と取得時刻（ISO 8601）を書く（R9。Phase 1 と Phase 2 の全エージェント）
- {出力先}/{ファイル名}.md: 8 列の Markdown 表（status が candidate と boundary の行だけ）、件数表（チャネルごとの列挙 / 採用 / 除外 / 未確認 / 境界）、走査の記録（フィルタ基準、未走査の範囲、GitHub の制約に当たった箇所）。除外した項目の一覧は md に書かない（JSONL だけ）
- {出力先}/{ファイル名}.jsonl: 1 行 1 項目、全フィールド（id, name, url, aliases, kind, authority, authority_basis, authority_scope, activities, scope_verdict, channel, verified{date, method, ref}, known, watchable, identity（name + tree_sha か content_sha256 + origin。取れなければ null）, gh（GitHub のリポジトリ項目だけ）, status, excluded_reason, notes）。除外した項目も status "excluded" で含める。id は "{ID}-連番"

上限: ツール呼び出し {N} 回、出力 300 行。上限に達したら「未走査」の範囲を明記して終える。

最終報告（これ以外を書かない）:
  完了 / 上限到達。出力: {パス}
  件数: 列挙 N / 採用 n / 除外 m / 未確認 k / 境界 b
  未走査: ...
  権限拒否: 無し / あり（ツール名）

環境: Windows 11 の Git Bash。パスは絶対パス。.bat に触らない。
```

### A-1. P0-A（アイデア出し、Opus、Web 不可）

```text
役割: 本計画書を読み、(1) 列挙可能（または有限）なのに 2 節に無い公開チャネルを最大 10 件、(2) 3 節の終了条件が「もう無い」を言えなくなる反証シナリオを最大 10 件、それぞれ「内容、理由、検証方法、採否の推奨」の 4 列で書く。Web・MCP・Bash は使わない。
読む入力: {計画書の絶対パス}、{survey の絶対パス}（1 節と 2 節だけ）
個別の禁止事項: 情報収集をしない。計画の実行をしない。
出力: {出力先}/p0-ideas.md（表のみ。JSONL は不要）
上限: ツール呼び出し 10 回
最終報告: 「完了。チャネル候補 N 件（採用推奨 n 件）、反証 M 件（対応推奨 m 件）」の 1 行
```

### A-2. P0-B / P0-C（blind 探索者、Sonnet / Opus）

```text
役割: 次の定義と範囲だけを手がかりに、あなたの知識と Web で、Claude Code の Plugin を開発・テスト・配布するときに参照すべき L1 / L2 の情報源と資産を列挙する。既知の一覧は渡さない。あなたが「公式はここに置くはずだ」と考える場所を自分で探す。
読む入力: 無し（ファイルを読まない。特に .claude/work/ 配下を読まない）
範囲: {0-2 の 1 項目目と「MCP / Agent SDK は範囲外」「ディレクトリへ提出しない」「claude.ai / Cowork の面は範囲外」}
権威レベルの定義: {1-1 の「定義」列の 4 行をそのまま転記。「該当」列は転記しない}
判定の手続き: 置き場所（ドメイン、GitHub の org、パッケージのスコープ）と、掲載元が宣言する著作者で判定する（1-2 の表は転記しない。検索方法がチャネルのヒントになるため。Round 2）
権威の対象: {1-3 の表を転記}
使えるツール: WebSearch、mcp__fetch__fetch（任意 URL）、mcp__github__search_repositories / search_code / get_file_contents、gh api、gh search
個別の禁止事項: 他エージェントの出力を読まない。WebFetch を使わない（取得は mcp__fetch__fetch を使う。URL は自分で決める）。
出力: {出力先}/p0-blind-{sonnet|opus}.md と .jsonl（known は null）
上限: ツール呼び出し 30 回
最終報告: 「完了、N 件」の 1 行だけ。内容はファイルにしか書かない。
```

### A-3. P1-L（ローカル層、Sonnet）

```text
役割: 2-1 のローカル層 L-1、L-2、L-2b、L-3 を列挙する。追加確認: (1) code.claude.com の docs に changelog ページがあるか（docs_map で確認）、(2) Plugin ディレクトリ機能の説明が docs にあるか、(3) claude_code_docs_map.md の全見出しを 2-5 の語でフィルタした結果。Phase 0 で追加された作業（2-1 の L-1 / L-2 / L-3 の記述に従う）: C1 = command -v claude で実体を特定し、JS バンドルなら Grep ツール（output_mode content、-o）で anthropic または claude を含む https:// 文字列を抽出して一意化する（単一バイナリで Grep が読めなければ「未走査（バイナリ）」と記録）。C2 = あなた自身の system-reminder にある skill 一覧・agent 一覧を転記し、出所（組み込み / Plugin / プロジェクト / アカウント）を分類する。Plugin 由来は L-2 のキャッシュ、プロジェクト由来は本リポジトリの .claude/ と突き合わせて差し引き、残りは L-1 の docs を Grep して説明ページの有無を記録する。C3 = anthropic-skills: 名前空間を分離し、ローカルに実体ファイルがあれば Glob で探して L-2 の skill-creator と内容を比較する。scope_verdict は boundary。C4 = ~/.claude/plugins/ 配下と本リポジトリの *.json から "$schema" 行を Grep で抽出し一意化する。C9 = llms-full.txt を Grep（reserved / impersonat / 予約）して公式の予約 Marketplace 名の一覧を取る（実体への対応づけは P1-G2）。M2 = L-2 の分類は置き場所でなく author / homepage で行う。
読む入力: {計画書の絶対パス}（2-1、2-5、4-4）、C:\cc-workspace\LLMs\official-llms-txts\code.claude.com\docs\（llms.txt、en\claude_code_docs_map.md、llms-full.txt は Grep のみ）、~\.claude\plugins\known_marketplaces.json、~\.claude\plugins\marketplaces\*\.claude-plugin\marketplace.json、~\.claude\plugins\cache\、~\.claude\plugins\plugin-directory-cache-v2.json と plugin-catalog-cache.json（Grep のみ）
使える Bash: ls、find、head、wc、command -v claude、claude --help、claude plugin --help、claude plugin eval --help
個別の禁止事項: claude plugin eval init を実行しない（書き込みを伴う）。claude の他のサブコマンドを実行しない。
出力: {出力先}/p1-local.md と .jsonl（C9 の予約名一覧と C2 の一覧は md の別表にも出す）
上限: ツール呼び出し 60 回
```

### A-4. P1-D（docs の llms.txt とリンク閉包、Sonnet）

```text
役割: W-1 の各 llms.txt を取得して全行を 2-5 でフィルタする。platform.claude.com/docs はタイトルか URL に skill / claude code を含む行だけ採用候補にする。C5 / R5: 4 サイト（code.claude.com、claude.com/docs、agentskills.io、platform.claude.com）の sitemap.xml（無ければ robots.txt の Sitemap 行）を取得し、URL 集合と llms.txt の URL 集合の差集合を出して、差集合の全件にも 2-5 の印を付ける（差が 0 なら「llms.txt を全集合と見なせる」根拠として記録。code.claude.com の分は L-1 の保存済み llms.txt / docs_map との差）。W-8 として、seed（claude.com/docs/build/overview、code.claude.com の plugins / skills / eval / mods の各ページ、anthropics/claude-code の README、claude-plugins-official の README、anthropics/skills の academy-guide 束）から外向きリンクを深さ 2 まで集め、既知集合（{1-1 の該当列}）に無いドメイン・org・repo を「未知」として別表に出す。R3: 未知の判定単位は「repo + path 接頭辞」とし、既知 repo 内の path（deep link）も出力に残す。追加確認: Plugin ディレクトリ機能の説明ページの有無、$schema / schemastore への言及の有無、M3: claude.com/docs にある Organization 配布の受理条件（metadata.pluginRoot、bin/ 等）のページ。
読む入力: {計画書の絶対パス}（1-1、2-2、2-5、4-4）
使えるツール: WebFetch（claude.com、platform.claude.com、agentskills.io、code.claude.com、github.com/anthropics）、mcp__fetch__fetch（WebFetch が失敗したとき）
出力: {出力先}/p1-docs.md と .jsonl（未知のドメイン・org・repo + path は md の別表にも書く。sitemap と llms.txt の差集合の件数を「走査の記録」に書く）
上限: ツール呼び出し 60 回
```

### A-5a. P1-G1（GitHub の構造、Sonnet）

```text
役割: 計画書 2-6 の探索単位のうち G-1、G-2、G-3、G-7、G-8、G-9、G-10、G-12 を、2-6 に書かれた方法・完了判定・上限のとおりに実行する。順序: G-9（他 org の発見。R6 の sanity test として、G-9 のクエリだけで agentskills が候補に出るかを記録する）→ G-1（全 org の全リポジトリ。GraphQL を主にする。R2: org の pinnedItems と profile README も取得し、E4 用として md の別表に出す）→ G-2（fork 関係）→ G-7（topic）→ G-8（公開メンバー一覧）→ G-12（in の L1 リポジトリの tags / Releases / branches と org の Packages。Packages が権限拒否なら記録して回避しない）。G-3 は追加呼び出し無しで記録し、G-10 は G-1 の結果に印を付ける。追加確認: anthropics/claude-plugins-public は claude-plugins-official の rename か別リポジトリか（gh api repos/anthropics/claude-plugins-public のリダイレクトで判定）。
レート制限: 開始時と 20 回ごとに gh api rate_limit を見る。残量 500 未満で停止し、未走査を記録する。最終報告に残量を含める。
読む入力: {計画書の絶対パス}（1-2、2-5、2-6、4-4）
使えるツール: gh api（REST、graphql、search/users、rate_limit）、gh search repos、mcp__github__search_repositories / get_file_contents / list_tags、WebFetch（github.com/anthropics）
個別の禁止事項: code search を使わない（P1-G2 の担当）。メンバー個人のリポジトリを巡回しない。
出力: {出力先}/p1-github-structure.md と .jsonl（リポジトリ項目には gh オブジェクトを必ず付ける。G-2 (b) の fork と G-7 org 外の L3 候補は status "excluded" で理由を書き、100 スター以上の L3 候補は md の別表にも出す）
上限: ツール呼び出し 100 回
```

### A-5b. P1-G2（GitHub の中身、Sonnet）

```text
役割: 計画書 2-6 の探索単位のうち G-6、G-11、G-5、G-4 をこの順で、2-6 に書かれた方法・完了判定・上限のとおりに実行する。G-6 は最初の 1 本を疎通確認にし（2-6 G-6 の 422 の扱い）、org 内の 12 クエリを org ごとに実行し（1 分に 10 件以内。間に他の呼び出しを挟む）、次に org 外の 2 クエリ。G-6 の追加確認: C4 = SchemaStore の catalog.json を mcp__fetch__fetch で取り、name / description / url に claude か anthropic を含むエントリを抽出して 1-2 の判定を付ける。C9 = {出力先}/p1-local.md の予約 Marketplace 名の全件を path:.claude-plugin filename:marketplace.json "<名前>" と G-1 のリポジトリ名で実体に対応づける。G-11 = in / boundary の全リポジトリと、R4 の抜き取り（G-1 の out から無作為 10 件とスター上位 10 件）に git/trees/{default_branch}?recursive=1 を当て（truncated なら分割。出力は {scratchpad}/github-trees/ に書いて Grep ツールで抽出）、2-5 の署名・語に当たるパスを記録する。抜き取りで 1 件でも当たれば boundary で回す。G-5 は対象リポジトリ（{出力先}/p1-github-structure.jsonl の scope_verdict が in / boundary のもの。既定の anthropics/claude-code、anthropics/claude-plugins-official、anthropics/skills は常に含める）について、ラベル一覧 → 2-5 の語に当たるラベル → ラベルごとの issue（created >= {since}。R10: {since} は P1-C が特定した「hooks / statusline / skills / plugin の初出のうち最古」。起動時に値が渡されなければ、自分で anthropics/claude-code の CHANGELOG.md を見て特定する。それもできなければ暫定 2025-10-01 を使い、その旨を記録する。issue 数が上限を超える期間は未走査として明記する）→ author_association で絞り → 本文のリンクを抽出。pinned issue と announcement カテゴリの Discussions は条件に関わらず全件。G-4 の対象は同じ in / boundary のリポジトリのうち gh.has_wiki が真のもの（2-6 G-4 の隔離規則を守る）。追加確認: https://json.schemastore.org/claude-code-settings.json の出所（SchemaStore/schemastore 上のファイルと投稿者。docs からの参照の有無は P1-D が見る）。
レート制限: 開始時と 20 回ごとに gh api rate_limit を見る。code search は 10 回 / 分。secondary rate limit（403 / 429）が出たら、その探索単位を「未走査（レート制限）」として記録し次へ進む。最終報告に残量を含める。
読む入力: {計画書の絶対パス}（1-2、2-5、2-6、4-4）、{出力先}/p1-github-structure.jsonl（P1-G1 の出力。本エージェントは P1-G1 の完了後に起動される）、{出力先}/p1-local.md（C9 の予約名一覧。無ければ C9 を未走査に）、{出力先}/p1-changelog-registry.md（P1-C の since。あれば）
使えるツール: gh api、gh search code / issues、git clone（wiki だけ。{scratchpad}/github-wiki/{owner}__{repo}/ へ）、find、wc、mcp__github__search_code / search_issues / get_issue / get_issue_comments / get_file_contents、WebFetch（github.com/anthropics、raw.githubusercontent.com）、mcp__fetch__fetch（json.schemastore.org）
個別の禁止事項: clone した wiki の中のファイルを実行しない、その中で interpreter を起動しない。ラベル・期間・著者の条件に合わない issue を列挙しない。
出力: {出力先}/p1-github-content.md と .jsonl（G-5 で見つかったリンク先は md の「未知」表にも出す。各 code search クエリのヒット数と 1,000 件上限の該当を「走査の記録」に書く）
上限: ツール呼び出し 140 回（超える場合は G-6 → G-11 → G-5 → G-4 の優先で、後ろを期間で絞るか未走査にする）
```

### A-6. P1-C（CHANGELOG / Releases とレジストリ、Sonnet）

```text
役割: W-4 として anthropics/claude-code の CHANGELOG.md と GitHub Releases の全エントリを 2-5 の語で走査し、Plugin / skill / marketplace / eval / validate / hook / mod に関する機能と資産を抽出して、対応する docs ページの有無を記録する。W-5 として npm の @anthropic-ai スコープの全パッケージと、anthropics org の Python リポジトリから逆引きした PyPI パッケージを列挙し、maintainers / project_urls を記録する。mods のテストキット（claude-code/testing 等）の有無を確認する。R10: CHANGELOG で hooks / statusline / skills / plugin の各機能の初出の版と日付を特定し、最古の日付を since として md の冒頭と最終報告の 1 行目に書く（P1-G2 が使う）。R6: npm は maintainer: 検索（registry の search API で maintainer 名を変えて）で @anthropic-ai 以外のスコープの Anthropic 発パッケージを拾い、PyPI は Anthropic の organization ページで列挙する。CHANGELOG 本文に現れる GitHub の owner を集めて「走査の記録」に出す（P2-V の owner 集合用）。
読む入力: {計画書の絶対パス}（1-2、2-2、2-5、4-4）
使えるツール: mcp__github__get_file_contents、gh api repos/anthropics/claude-code/releases、WebFetch（raw.githubusercontent.com、registry.npmjs.org、pypi.org）、mcp__fetch__fetch（代替）
出力: {出力先}/p1-changelog-registry.md と .jsonl（since と初出の表は md の冒頭に置く）
上限: ツール呼び出し 50 回
```

### A-7. P1-B（blog / support と補助チャネル、Sonnet）

```text
役割: 最初のタスクとして anthropic.com と claude.com の sitemap（sitemap.xml、robots.txt の Sitemap 行）の有無を確認する。あれば W-6 として全 URL をパス接頭辞ごとに集計し、claude.com は /docs/ 以外のパス（blog、resources 等。C6）を、anthropic.com は全 URL を 2-5 の語でフィルタする。無ければ WebSearch の site:anthropic.com / site:claude.com -inurl:/docs/ クエリで代替し、W-6 を補助チャネルへ降格したことを記録する。C10 / S-5: Anthropic Academy のコースカタログを、URL を推測せず W-6 の結果と W-8 の seed（anthropics/skills の academy-guide 束）から辿って特定し、コース一覧の全タイトルを 2-5 でフィルタする（Plugin を扱うコースが 0 ならその旨を記録。B6 の判定に使う）。W-7 として support.claude.com の Claude Code 関連カテゴリの全記事タイトルを列挙する。S-1 として固定クエリ（{2-5 の語から Fable が 10〜15 件を組む}）を WebSearch で実行し、上位の L1 / L2 ドメインの URL だけ拾う。S-3 としてコミュニティのリスト（awesome-claude-code 等）から「公式」と注記された項目だけ抽出する。
読む入力: {計画書の絶対パス}（1-1、2-2、2-3、2-5、4-4）
使えるツール: WebFetch（anthropic.com、support.claude.com）、WebSearch、mcp__fetch__fetch（コミュニティのリスト等）
出力: {出力先}/p1-blog-support.md と .jsonl
上限: ツール呼び出し 50 回
```

### A-8. P2-R（結合と検証、Sonnet）

```text
役割: Phase 1 の全 JSONL を結合し、url（最終 URL）で重複を除いて 1 項目にまとめる（channel は和集合、verified は最新）。M5: 加えて identity（name + tree_sha か content_sha256 + origin）で「複製グループ」の表を作る。identity が無い L1 / L2 の資産項目には、ディレクトリなら gh api repos/{o}/{r}/contents/{path} の tree SHA、単一ファイルなら取得内容の sha256 を取って埋める。複製間で SHA が違えば版のずれとして記録する（例: skill-creator の claude-plugins-official 側と anthropics/skills 側、C3 のアカウント供給分）。survey 2 節に無い新規の L1 / L2 項目を全件再取得し、存在・リダイレクト先・権威の根拠（org 欄、scope、author）を確かめる。既知の項目は再取得しない。確認できないものは status を "unverified" に落とし、理由を notes に書く。
読む入力: {出力先}/p1-*.jsonl（6 本）、{survey の絶対パス}（2 節）、{計画書の絶対パス}（1-2）。gh オブジェクトは結合時にそのまま保持する
使えるツール: WebFetch（4-3 の全ドメイン）、mcp__fetch__fetch、gh api、mcp__github__get_file_contents
個別の禁止事項: 項目を追加しない（検証だけ）。判定を変えない（authority と scope_verdict は元のまま。異議は notes に書く）。
出力: {出力先}/p2-merged.jsonl（結合済みの全件）、{出力先}/p2-merged.md（要約だけ: 新規 L1 / L2 の一覧、unverified の一覧、boundary の一覧、複製グループの表（M5）、チャネル別の件数表。300 行以内）、{出力先}/p2-verify.md（再取得した項目ごとの結果）
上限: ツール呼び出し 60 回（超える場合は L1 の検証 → identity の順に優先し、未検証の残りを一覧にして終える）
```

### A-9. P2-V（クロスチェック、Opus）

```text
役割: Phase 1 の全出力と blind 探索者（P0-B / C）の出力を突き合わせ、次を判定する。(1) E3（R1。部分的独立）: まず blind の「走査の記録」に計画書 2 節に無いチャネル種別があるかを見る（これが本来の検出対象）。次に項目の一致計算を除外規則で行う: (a) 注入文脈にしか無い語（cc-workspace、LLMs、official-llms-txts、empty-can、marketplace-for-cc、.claude/work、official-assets、test-repo-design、claude-code-guide、statusline、pre-compact、cc-relative-info、インストール済み Plugin 名）に当たる項目は flag、(b) そのうち verified に取得 URL と方法が無いものだけを一致計算から除外する（取得で裏付けられた項目は残す）。flag 件数と除外件数を「文脈由来の混入量」として報告する。(2) E2（R3）: P1-D の「未知」表にある L1 / L2 のドメイン・org・repo + path 接頭辞と、既知 repo 内の path を G-6 / G-11 の列挙と突き合わせた差分。(3) E4（R2）: 索引ごとに「seed / 入力に使ったか」の列を作り、使っていない索引（org の pinnedItems と profile README、C9 の予約名一覧、claude-code-guide agent の説明が参照する項目）だけで包含率を出す。使った索引（build/overview の 7 ツール、code.claude.com の関連リンク、claude-code の README）は参考値。(4) R6: 全 P1 出力から GitHub の owner と npm / PyPI のスコープの集合を作り、既知 org の外に 1-2 をかけ、未判定の org を再走査の対象として挙げる。(5) 定義（1 節）の適用の矛盾。(6) E1（R4 の抜き取り結果を含む）/ E5 / E6 の達成度。再走査が要るなら対象チャネルと理由を 1 つに絞り、初回から何を変えるか（クエリ・seed・モデル・チャネル）も提案する（R7）。
読む入力: {出力先}/p0-*.md、{出力先}/p1-*.md、{計画書の絶対パス}
使えるツール: WebFetch（4-3 の全ドメイン。抜き取りの再確認だけ）、mcp__github__get_file_contents
個別の禁止事項: 新たな情報収集をしない（再確認のみ）。項目を追加しない（指摘として書く）。
出力: {出力先}/p2-coverage.md（指摘の表: 種別 E2 / E3 / E4 / 矛盾、内容、根拠、推奨対応）
上限: ツール呼び出し 30 回
最終報告: 「完了。穴 N 件（E2 a / E3 b / E4 c / R6 d）、矛盾 M 件、文脈由来 flag f 件・除外 e 件、再走査: 要 / 不要（対象: ...、変える変数: ...）」の 1 行
```

### A-10. P2-M（対応づけ、Opus）

```text
役割: p2-merged.jsonl の status "candidate" かつ authority L1 / L2 かつ scope_verdict "in" の資産ごとに、「何を確かめられるか / 確かめられないか / 採用するか（仮）」を、テスト手法の整理文書の軸（1 節の 5 観点、2-7 の 9 手法、開発 / テスト / 配布の 3 活動）に対応づける。E6 のマトリクス（9 手法 × 3 活動）を埋め、各セルに「資産あり（ID）」か「確認済みで無し」を入れる。必要なら資産の中身を読む。R8: 「確認済みで無し」のセルには、照会したチャネル・クエリの ID（L-x / W-x / G-x とクエリ番号）を必ず書く。「どの手法・活動にも対応づかない資産」を独立の表に出し、件数を最終報告に含める（0 でなければ Fable が行の追加を検討する。例: /skill-doctor の診断、CI の validate --strict、claude plugin tag の版管理）。
読む入力: {出力先}/p2-merged.jsonl、{test-methods の絶対パス}（1 節、2-6、2-7）、資産の中身（~\.claude\plugins\cache\、mcp__github__get_file_contents）
使えるツール: Read、Grep、mcp__github__get_file_contents、WebFetch（4-3 の全ドメイン）
個別の禁止事項: 「採用するか」は仮判定にとどめ、根拠を付ける。設計書を編集しない。
出力: {出力先}/p2-mapping.md（資産ごとの表と E6 マトリクス）
上限: ツール呼び出し 40 回
最終報告: 「完了。対応づけ N 件、E6 のセル埋め率 x%、『確認済みで無し』のセル: ...、対応先の無い資産: m 件」の 2 行以内
```

（付録 A: **確定**（Round 2）。変数は冒頭の一覧を Fable が埋める）

## 9. Phase 2 の判定（Fable、2026-10-13 02:40。P2-V の `p2-coverage.md` に対する決定。作業指示者が上書きできる）

### 9-1. 再走査（D2: 2 回目まで可）

| # | 対象 | 変える変数 | 担当 | 位置づけ |
|---|---|---|---|---|
| 再走査 1 | G-11 を anthropics の G-1 で out の全 repo（約 68）と anthropic-experimental の 2 repo に拡大。補助として G-6 を `path:` 無しで再実行 | 対象の範囲（抜き取り → org 全件）、分類器（語 → 木の署名）、T の固定（G-1 の tree SHA） | P1-G2（resume、+120 回） | P2-V 推奨 1 |
| 再走査 2 | G-5 を代替の著者集合（A Release author ∪ B contributors × @anthropic.com メール ∪ C ラベル付与・close の actor。補助 D npm maintainer、E login 接尾辞）で再実行。CONTRIBUTOR 13 件は全件読む | 著者条件 | P1-G3（新規 Sonnet、120 回） | P2-V 優先 2 |
| 補完 | R6-2（L-2 の object source の owner 集合）、C-8（anthropic-skills の 2 群分け）、C-7（docs の kind を source に）、C-5（schema URL を unverified に） | — | P1-L（resume、+20 回） | 欠落の補完（再走査に数えない） |
| 優先 3 | E2-1 の未判定ホスト（claude.dev、console.anthropic.com、support.anthropic.com、brand.anthropic.com、resources.anthropic.com、skills.sh）のフッターとリダイレクト確認 | — | P2-R の検証に含める（既存の unverified 行） | 再走査に数えない |

### 9-2. 矛盾 11 件と判定の修正（P2-V の C-1〜C-11、E2-F、E4-2、E1-5）

| ID | Fable の判定 | 根拠・備考 |
|---|---|---|
| C-1 | **1-2 に規則を追加**: 「`anthropics` org 配下、または Anthropic 管理の Marketplace の `./plugins/` にあり、宣言された著作者が社員個人名（owner.name や author が個人）の場合は L1。置き場所が権威で、個人名は連絡先と見なす。第三者の組織名、または第三者と明示されている場合だけ L3」 | B1 の判定（`external_plugins/` = 第三者 → L3）と整合。8 節 **D12** として作業指示者に提示 |
| C-2 | SchemaStore の plugin / marketplace / settings スキーマは **out**（Anthropic 管理下の場所ではなく、投稿者も確認できない）。残存リスク 1「公式の JSON Schema が取得できない」に記載 | L3 の定義（Anthropic 管理下への掲載）を満たさない |
| C-3 | claude-plugins-community: **repo = L1**（Anthropic 運営のカタログ）、**収録エントリ = L3**（別表） | カタログと収録物を分ける |
| C-4 | claude.com/marketplace/plugins/{plugin-dev、security-guidance、claude-code-setup、claude-md-management} は **L1** | author = Anthropic（P1-L） |
| C-5 | P1-L-105 / 106 の schema URL は **unverified**（404） | 証拠ポリシー |
| C-6 | URL ごとの scope_verdict: plugins/security **内**、plugins/relevance **境界**、mods/interface・gallery **境界**、whats-new/index **境界**、pre-submission-checklist **内**（ポリシー。D6 の参照可）、claude-code-playground **内**（公式のサンプル mod / hook を含む）、resources/articles/build-plugins-for-claude **内**（情報源）、縦割り marketplace（life-sciences、financial-services、healthcare、claude-for-legal）**すべて境界**（marketplace.json の参照実装として P2-M が読んでよい）、claude-code-action **内**（配布。`plugins` 入力と CI の validate）、sandbox-runtime **境界**、devcontainer-features **境界** | 本文を読んだ P1-D の判定を題名による判定より優先。境界は作業指示者へ |
| C-7 | docs ページの kind は **source** | 0-3 の定義 |
| C-8 | anthropic-skills 名前空間: Anthropic 著作で L1 の複製と同一のもの = **L1（複製グループ）**、アカウント固有のもの = **out** | identity は P2-R |
| C-9 | 別名（plugins-reference、plugins、discover-plugins、subagents、docs.claude.com / docs.anthropic.com の旧 URL）は **aliases に統合** | P2-R の重複除去 |
| C-10 | anthropic-plugin-directory は **実体あり（claude.ai の directory 同期。公開 repo なし）** | P1-L の観測 |
| C-11 | agentskills org は **L2 確定** | L1 からのリンク（code.claude.com/docs/en/skills）と profile README の「maintained by Anthropic」 |
| E2-F | anthropic-cookbook / sdk-demos / apps は P2-R が API の full_name で解決（改名か 404 か） | G-1 の穴ではない |
| E4-2 | C2 索引は P2-V の転記（claude-code-guide の説明の参照項目）を **採用** | P1-L が展開していなかった |
| E1-5 | claude-code の `mods/` と claude-code-playground の `claude-code/{mods,hooks,settings,workflows}` は **P2-M が木から個別に読み、資産として行にする** | 公式のサンプル mod / hook |
| E3-1 / E3-2 | resources.anthropic.com（PDF 配布）は **残存リスク 7 に記載**し W-6 に但し書き。GitHub の Atom / RSS（releases.atom、feed.xml）は **監視案（D3）に追加** | 新種別 2 件は列挙チャネルには加えない |

### 9-3. 終了宣言の残存リスク（個別）

P2-V の 7 節の 12 項目を採用する（公式 JSON Schema の不在、code search の構造的限界、社員の識別不能、marketplace の owner が個人名、予約名の実体不明 5 件、古い slug / repo 名、sitemap 外のホスト、cache と marketplace の版ずれ、anthropic-experimental の権威未確定、Packages 403、docs と CHANGELOG の版記述の食い違い、W-8 の非飽和）。再走査 1 / 2 の結果で解消したものは消す。

### 9-4. 8 節への追加

| # | 事項 | 種別 | 状態 |
|---|---|---|---|
| D12 | C-1 の規則（anthropics 配下で社員個人名の宣言は L1） | Fable の決定 → 作業指示者 | 承認待ち |
| D13 | C-6 の境界 10 件（plugins/relevance、mods/interface・gallery、whats-new/index、縦割り marketplace 4 件、sandbox-runtime、devcontainer-features）の範囲判定 | 作業指示者 | 終了時に一覧で提示 |

## 変更履歴

- 2026-10-13 04:00: **実行完了**。P2-R 最終版（3,191 件）、P2-M の草稿（`official-assets/p2-mapping.md`。対応づけ 44 件、E6 74%、境界 165、設計書への影響 7）を Fable が検証し、棚卸し文書と終了宣言の草稿 **`official-assets-inventory_2026-10-13.md`（0.9 版）** を作成。survey 2-4（権威の対象単位の階層）と 3-4（結果）を更新。Fable の追加判定: `/skill-doctor` を L1 資産として数える、`claude plugin tag` の対応先は手法整理文書の再開時に作業指示者が決める、feed.xml は確認済み扱い、E6 の対応先なしは 2 件。作業指示者の判断待ち: D4〜D7、D11〜D13、設定と rule の追記のコミット
- 2026-10-13 03:20: 再走査 2（P1-G3）完了。初回 G-5 の「OWNER / MEMBER / COLLABORATOR 0 件」はラベル絞りの副作用で、全件列挙では COLLABORATOR 25 件（7 名）。著者集合 71 名（主 54）。docs に先行する告知は claude-code#91870「Mods」の 1 件で、リンク先 `anthropics/claude-code/tree/main/mods` に公式サンプル mod（`mods/diff`、`mods/agents-md` に `.claude-plugin/plugin.json`、`hooks/hooks.json`、`tests/`。README に `claude plugin test mods/diff`、`claude --plugin-dir mods/diff`、`/plugin-types`）がある。**設計書への影響: mods のテストキットとサンプルは「自作しない」候補として棚卸しに載せる**。Plugin 依存の version とタグ `{name}--v{version}` の issue 3 件（#64457、#65337、#63986）は本 Marketplace のリリースタグ規約に関係。P2-R を差分モードで再起動（再走査 1 / 2 と P1-L 更新の結合、9-2 の判定適用、未再取得 34 件、URL 全文）
- 2026-10-13 03:05: Fable の抜き取り検証（5-1「検証者の検証」）。P2-R が「確認済み」とした 168 件から 10 件おきに 17 件（ローカル 2、gh api 8、WebFetch 7）を再取得し、**17 件すべて記録と一致**（ローカルの存在とファイル数、repo の owner / fork / archived、commerce-agents の marketplace.json の sha256 296d737c58b0、Discussion #92 の投稿者、npm claude-trace の maintainers、claude.com 記事 4 件と Academy 1 件のフッター © Anthropic PBC）。P2-R の出力全体を信頼してよい。注意: p2-verify.md の表は URL を約 110 文字で切っているので最終結合で全文にさせる。再走査 1 完了（署名あり 5 repo を boundary に、`path:` 無しの G-6 は木と一致）。P1-L 補完完了（L-2 の owner 200 件に anthropics / agentskills は 0）。P2-R 追加検証完了（新規 L1 / L2 の確認済み 168、未再取得 34。console.anthropic.com と support.anthropic.com は L1 へリダイレクト、skills.sh は Vercel で除外、claude.dev と brand.anthropic.com は unverified）。残り: P1-G3（再走査 2）
- 2026-10-13 02:40: Phase 2 前半（P2-V 完了。P2-R は実行中）。9 節を新設し、再走査 1（P1-G2）、再走査 2（P1-G3）、P1-L の補完を起動。矛盾 11 件への Fable の判定を 9-2 に記録。D12 / D13 を追加
- 2026-10-13: 0.1 版。メインセッションとの対話前。Claude（Fable 5.1、専任の計画立案エージェント）
- 2026-10-13: 0.2 版。Round 1 の回答と追補 1（GitHub の探索戦略）・追補 2（費用は優先度最低）を反映。変更した節: 0-2（Marketplace の現状、Q3 の帰結を追記。確定）、0-4（Round 1 の事実と GitHub 追補の行を追記）、1-1（L1 / L3 の定義に著作者の条件を追加、L2 の MCP を範囲外に）、1-2（ドメイン判定 (b) を緩和、著作者の行を差し替え）、1-4（判定済みに更新、派生作業を追加。確定）、2-1（L-1 / L-2 の実体、L-2b を追加、L-3 の制約）、2-2（W-2 / W-3 を 2-6 へ吸収、W-1 / W-4 / W-6 に追加確認）、2-3（S-4 の有限化部分を G-5 へ格上げ）、2-4（X-6 を追加）、2-5（境界語を新設）、**2-6（新設。GitHub の探索戦略 G-1〜G-10、制約と上限の根拠）**、3-1（E5 を収束判定主体に、E6 の確定表現）、3-2（費用を理由に落とさない）、3-3（残存リスクの定型文、GitHub の制約の記載欄）、4-1（上限を有限化のためのものに再定義、13 体、P1-G 系は逆算）、4-2（権限を確定表記に、P2-R を新設、P1-G を G1 / G2 に分割、追加確認を各行に配置）、4-3（Fable 決定の権限一覧に差し替え、`search_users` と wiki clone の扱い）、4-4（Markdown 8 列 + JSONL の二本立て、`gh` オブジェクト）、4-5（wiki clone の隔離）、5-1（P2-R 新設の理由）、5-2（Phase 2 を前半・後半に分割、Phase 1 は 6 体）、7 節（回答と反映先を記録、Q2 に追補 2）、8 節（新設。D1 は上限値の確認）、付録 A（新設。A-5 は G1 / G2 の 2 本）
- 2026-10-13: 0.3 版（確定、実行へ）。Round 2 の回答を反映。全節の印を「確定」に。変更箇所: 2-6 冒頭と 4-2 / 5-2 手順 2 / A-5b（P1-G2 を P1-G1 の完了後に起動し、`p1-github-structure.jsonl` の in / boundary を G-4 / G-5 の対象にする）、4-2 P0-B / C と 4-5 / A-2（blind 探索者から WebFetch を外し、`mcp__fetch__fetch` と WebSearch を主に。1-2 の表を転記せず 1 文に要約）、付録 A 冒頭（Fable が埋める変数の一覧、A-3〜A-8 の最終報告は A-0 の定型）、A-0（承認を主張しない、権限拒否は回避せず報告して続行、出力パスの変数名を統一、JSONL に `gh`）、5-2 手順 7（survey の誤記訂正は実施済み）、8 節 D9 / D10（D10 は採用で閉じた）、6 節 Round 3 行。未確定として残した事項: 無し
- 2026-10-13: 0.4 版（Phase 0 の反映。Fable 決定の転記。再議論無し）。P0-A（`official-assets/p0-ideas.md`）の C1〜C10・R1〜R10・M1〜M5 を全件採用として転記。変更箇所: 0-2（M3）、1-2（M1）、2-1 L-1（C5 / C9）・L-2（M2）・L-3（C1〜C4）、2-2 W-1（C5 / M3）・W-6（C6 / M4）・W-8（R3 / C10）、2-3 S-5（C10）、2-4 X-5（M3 / C3）、2-6 G-1（R2）・G-5（R10）・G-6（C4 / C9）・G-9（R6）・G-11 新設（C7 / R4）・G-12 新設（C8）、3-1 E1〜E6（R4 / R3 / R1 / R2 / R7 / R8）、3-3（R1 / R9 / R4）、4-1（上限の再計算）、4-2（全 P1 と P2 の役割に Phase 0 追加を明記）、4-3（`claude --version`、packages の権限拒否）、4-4（`identity`。M5）、4-5（R9 / R1）、5-2 手順 4（R6 / R7）、8 節 D11（R1）、付録 A（A-0、A-3、A-4、A-5a、A-5b、A-6、A-7、A-8、A-9、A-10、変数 `{since}`）。備考: 異議無し。G-11 のツリー出力はサブエージェントのコンテキストを圧迫しうるので、標準出力に流さず一時ディレクトリへ書いて Grep する手順を 2-6 G-11 と A-5b に置いた（実装上の注意で、決定の変更ではない）
- 2026-10-13: Phase 1 実行中の事象（Fable 記録）。(1) P1-B と P1-C は上限到達で終了し、未走査を明記。P1-B には Fable が +40 回の追加走査を指示（Phase 2 後の再走査 1 回とは別扱い）。(2) **gh CLI が未認証**（`gh auth status` で未ログイン、`GH_TOKEN` 未設定）と判明。P1-C の Releases、P1-G1 の GraphQL / parent / 公開メンバー / search/users / G-12 は「未走査（gh 未認証）」。P1-G1 には GitHub MCP で可能な範囲へ切り替えて続行するよう指示。作業指示者に `gh auth login` を依頼し、認証後に P1-G1 と P1-C の gh 依存部分を追加走査、その後 P1-G2 を起動する。(3) P1-C の R10: since = 2025-06-30（hooks の初出 1.0.38 の npm publish 時刻。CHANGELOG に日付は無い）
- 2026-10-13 02:20: Phase 1 完了（Fable 記録）。6 体すべて完了。上限到達の P1-B（+40）、P1-D（+60）、gh 認証後の P1-G1（+80）、P1-C（+30）に追加走査を実施（Phase 2 後の再走査 1 回とは別扱い）。gh は作業指示者がデバイス認証で keyring に保存（01:43 頃）。主な事実: anthropics org 115 リポジトリ、`claude-plugins-public` は rename、`anthropic-experimental` org は未判定、G-9 の名前検索で agentskills は不出現（R6 実証）、code search の `path:` は直下の前置一致のみで入れ子の署名は索引外（G-11 のツリーで補完）、G-5 は author_association が公開メンバー無しのため 0 件（著者条件の見直しを P2-V に委任）、wiki 21 件は全て内容無し、Releases は v2.0.73（2025-12-19）以降のみ、since = 2025-06-30、Academy に Claude Code の Plugin 教材は 0 件、W-8 は未飽和（深さ 3 未実施）、Packages は 403（read:packages 無し。回避せず）。Phase 2 の P2-R と P2-V を並列起動。作業指示者は 6〜8 時間不在で、Fable は応答不要の範囲で進める（D2 の 2 回目再走査、D3、D7、D11 は待つ）
- 2026-10-13: 0.3.1 版。Round 3（Fable の確認）。A-0 の禁止事項に「gh と git は読み取り専用で使う」の 1 行を Fable が追加（ローカルの allow が `Bash(gh *)` / `Bash(git *)` と広く、プロンプトでしか絞れないため）。Phase 0 を起動
