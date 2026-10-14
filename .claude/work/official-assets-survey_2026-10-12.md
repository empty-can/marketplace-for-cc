# 公式のプラグイン開発資産の情報整理（2026-10-12）

| 項目 | 内容 |
|---|---|
| 位置づけ | branch「公式のプラグイン開発資産の情報整理」（session `<uuid>`。元は branch「テスト手法の再整理」）の作業記録。設計書 v3.3 とテスト手法の整理（`test-methods-organized_2026-10-12.md`）を一旦止め、公式・準公式の情報源と公開資産を棚卸しする |
| 作成 | Claude（Fable 5.1）。作業指示者の提起と Fable の確認結果を転記 |
| 状態 | 1 節と 2 節は確認済み。3 節の計画立案はこれから（サブエージェントに委任する） |

## 1. 作業指示者の提起（2026-10-12）

- GitHub を軽く検索したところ、これから作る仕組みが公式 Skill として既に公開されている可能性と、公式ドキュメントとしてウォッチできていない情報源の存在に気づいた。車輪の二重発明を排除するため、設計を一旦止めて情報整理に切り替える
- 今回見つけた情報源は、手順やルールに沿って辿り着いたのではなく、場当たり的に辿り着いたもの。**まだ他にも、存在を知らない公式・権威情報・資産があるのではないか**が懸念
- やみくもに探すと情報収集から抜け出せないので、**Claude Code の Plugin を開発するに当たって、あらかじめ把握しておくべき情報源・公開資産はもう他には無いと、ある程度の確信を持って言える状態**になるための、情報収集の戦略・計画（≒終了条件）を立案してほしい
- 立案の進め方: メインセッションの Fable はオーケストレータとして取りまとめを担当し、個別の調査やアプローチのアイデア出しは複数の Sonnet / Opus のサブエージェントに委任する。依頼が曖昧なので、まず「計画立案の進め方の計画」から始めてよく、その場合も専任のエージェント（Fable か Opus）を立てて対話しながら練り上げる

## 2. 今回確認した情報源と資産（2026-10-12、一次情報で確認済み）

### 2-1. 結論

- **設計中の仕組みは公式資産の二重発明ではない。** claude.com/docs の Build for Claude のページ（`https://claude.com/docs/build/overview.md`）の「Tools that help you build and check a plugin」が、Anthropic 自身による構築・確認ツールの列挙で、内容は次の 7 つ: `claude plugin validate`、`claude --plugin-dir`、`claude plugin eval`、`/skill-doctor`、skill-creator、plugin-dev、mcp-server-dev。作業状態を再現したサンドボックスでのヘッドレス実行、証跡の構造、モデルと effort の固定に相当する公式資産は無い
- **唯一の重複**: plugin-dev 同梱の `test-hook.sh`、`validate-hook-schema.sh`、`hook-linter.sh`（`skills/hook-development/scripts/`）。テスト手法の整理で候補に挙げた「スクリプト単体テスト」の hook の部分に相当する。自作せず採用する
- **claude.com/docs は Claude Code 固有の事項を code.claude.com/docs に委譲している。** テストの節は `claude plugin eval` と `claude plugin validate` を code.claude.com へのリンクで参照する

### 2-2. 情報源の一覧

| 情報源 | 性質 | 規模・形式 | 監視の有無 | 確認したこと |
|---|---|---|---|---|
| `https://code.claude.com/docs/` | Claude Code の公式 docs。読み込み、eval、validate、mods の正本 | `llms.txt`、`llms-full.txt`（2026-10-12 版 120,978 行） | LLMs リポジトリで日次ウォッチ済み | 設計書 2 節の F 根拠の出所 |
| `https://claude.com/docs/` | 上位の公式 docs。chat、Cowork、Claude Code を横断する Plugin・Skill の仕様と、Anthropic ディレクトリへの提出時の検査 | `llms.txt` に 266 ページ。トップレベルは connectors、extend、plugins、skills、build、directory、cowork、claude-tag、office-agents、claude-science、third-party、government | **未監視** | `/docs/extend/` と `/docs/build/` は概要 1 ページずつで、実体は `/docs/plugins/`（11 ページ）、`/docs/skills/`、`/docs/connectors/` にある。`plugins/build`（Plugin structure and testing）、`plugins/pre-submission-checklist`（提出時の検査。README 40 語以上、ライセンス、名前の規則、launcher のバージョン固定、シンボリックリンクと LFS の禁止など。`claude plugin validate` では検査されない）、`skills/how-to`（skill の作成とテスト。`skills-ref validate` と skill-creator を案内） |
| `https://agentskills.io/` | Agent Skills の仕様サイト。「originally developed by Anthropic, released as an open standard」。GitHub は `agentskills/agentskills` | `llms.txt` に 9 ページ（Overview、Specification、Client Showcase、Quickstart、Best practices、Optimizing descriptions、Evaluating skill output quality、Using scripts、Adding skills support） | **未監視** | claude.com/docs が SKILL.md 仕様の参照先としてリンクする。「Evaluating skill output quality」は skill-creator と同じ方法論（`evals.json`、`iteration-N/`、`with_skill` / `without_skill`、`grading.json`、`benchmark.json`）。参照実装 `skills-ref`（Python。`validate`、`read-properties`、`to-prompt`）は README が「デモ用途で本番向きではない」と明記 |
| `https://github.com/anthropics/claude-plugins-official` | 公式 Marketplace。`~/.claude/plugins/marketplaces/claude-plugins-official/` に clone 済み | 315 Plugin。うち Anthropic 所有（`./plugins/`）で開発・テスト関連は agent-sdk-dev、claude-code-setup、claude-md-management、code-review、feature-dev、hookify、mcp-server-dev、plugin-dev、pr-review-toolkit、security-guidance、session-report、skill-creator、playground、claude-security（`./plugins/claude-security`、author Anthropic。2026-10-13 訂正: 旧記述「外部 URL 参照」は誤り）。`./external_plugins/*` は著者が第三者（例: Clay）で、`homepage` は `github.com/anthropics/claude-plugins-public/...` を指す（`claude-plugins-official` と別名のリポジトリ。存在と関係は要確認） | Plugin キャッシュとして更新される | skill-creator は `./plugins/skill-creator` に自前のコピーを持つ |
| `https://github.com/anthropics/skills` | Skill だけの公式 Marketplace（`anthropic-agent-skills`）。`~/.claude/plugins/marketplaces/anthropic-agent-skills/` に clone 済み（最終 commit 2026-10-09） | 5 つの Plugin 束（document-skills、example-skills、claude-api、academy-guide、discernment-nudge）と `skills/` 直下 19 skill、`spec/`（agentskills.io へのリダイレクト）、`template/` | 同上 | skill-creator は claude-plugins-official のキャッシュ 2 版（`2a8ad9f74633`、`f359d43b4060`）と、`LICENSE.txt` の著作権者の行以外は同一。同期は Anthropic 側の手作業で、現時点では一致 |
| `https://github.com/anthropics/knowledge-work-plugins` | claude.com/docs が「ディレクトリに載る役割別 Plugin の実例」として参照 | 未確認 | 未監視 | 未確認 |
| `https://modelcontextprotocol.io/` | MCP の仕様 | `llms.txt`、`llms-full.txt` | LLMs リポジトリで監視済み | 本件では未参照 |

### 2-3. 公式 Marketplace の Plugin のうち今回調べたもの

| Plugin | 中身 | 設計との関係 |
|---|---|---|
| plugin-dev | 作成ワークフロー（`commands/create-plugin.md`、8 Phase）と 7 skill、3 agent。Phase 6 Validation は plugin-validator と skill-reviewer の 2 エージェントによる静的レビューとシェル検証（`validate-agent.sh`、`validate-hook-schema.sh`、`test-hook.sh`）。Phase 7 Testing は `--plugin-dir` で起動して人が確かめるチェックリスト。`command-development/references/testing-strategies.md`（702 行）の Automated Testing も frontmatter と構造のシェル検証 | 自動テストの仕組みは持たない。hook の検証スクリプトだけ採用候補 |
| claude-security（0.12.0） | 複数エージェントで脆弱性を探索し検証する深いスキャン。公式 docs（code.claude.com、`claude-security` のページ）の表では、セッション中の security-guidance Plugin、単発の `/security-review`、この Plugin の深いスキャン、PR 時の Code Review、管理型の Claude Security 製品、CI の既存スキャナという層構成 | 挙動のテストとは直交。公開リポジトリのリリース前ゲートの候補 |
| hookify | 会話の分析か指示から hook を作る | テストとは無関係 |
| playground | HTML の探索ツール生成 | テストとは無関係 |
| skill-creator | テスト手法の整理文書 2-3 参照 | 手法 A |

### 2-4. 情報源の階層（この Marketplace は Claude Code 向けで、ディレクトリへ提出しない前提）

2026-10-13 の棚卸しで「サイト単位」から「権威の対象単位」に更新（詳細は `official-assets-inventory_2026-10-13.md` 4 節）。

| 権威の対象 | 正本（1 位） | 2 位以下 |
|---|---|---|
| 形式（SKILL.md） | agentskills.io/specification（L2） | code.claude.com/docs/en/skills |
| 形式（plugin.json、marketplace.json、hooks.json、mod） | code.claude.com の manifest-reference、marketplace-reference、hooks、mods/reference | `claude plugin validate`。機械可読な公式 schema は無い（URL は 404） |
| 挙動 | 手元の版の `claude plugin --help` と code.claude.com/docs | 食い違えば `--help` と実測を優先 |
| ポリシー | code.claude.com の marketplace-reference#reserved-names、publish | claude.com/docs の pre-submission-checklist（品質基準として参照）、org-sync |
| 参照実装 | claude-plugins-official の `./plugins/*` | anthropics/skills、anthropics/claude-code の `mods/` |
| 変更履歴 | anthropics/claude-code の CHANGELOG.md（= feed.xml） | code.claude.com の changelog、Releases（v2.0.73 以降のみ） |

旧（2026-10-12）: 1. agentskills.io、2. code.claude.com/docs、3. claude.com/docs（参照は限定的）

### 2-5. 本活動で新たに見つかった参照必須の資産（2026-10-13。2-2 の表に無かったもの）

| 資産 | 所在 | 性質 | 設計との関係 |
|---|---|---|---|
| `claude plugin test` と `claude-code/testing` | code.claude.com/docs/en/plugins/mods/test.md、`anthropics/claude-code/tree/main/mods`（diff、agents-md、sec-default、telemetry の 4 mod。`tests/` 付き） | mod（hooks module）専用のテストキット。モデルもネットワークも使わない決定的テスト。command 型 hook・skill・agent は対象外 | 手法「スクリプト単体」を mod とそれ以外で分ける。mod 化する場合の雛形 |
| skill-creator の `scripts/run_eval.py` | claude-plugins-official の `plugins/skill-creator/scripts/` | `claude -p` で description が skill を起動させるかを測る発火テストの公式実装。一時 command に description だけを載せて測る | 発火テストの比較対象。実物の skill・名前空間・実行ゲートは自作のまま |
| Organization 配布の受理条件 | claude.com/docs/plugins/org-sync | `metadata.pluginRoot` の bare name と トップレベル `bin/` の拒否（`.claude/CLAUDE.md` の規約の正本） | 配布の制約 |
| 予約 Marketplace 名と公開ポリシー | code.claude.com の plugins/marketplace-reference#reserved-names（19 件）、plugins/publish | ポリシーの正本 | Marketplace 名の制約 |
| `anthropics/claude-code` の `feed.xml` | https://raw.githubusercontent.com/anthropics/claude-code/main/feed.xml | CHANGELOG と同内容の Atom（1 版 1 entry、日付あり） | 環境の事実確認のトリガ、監視 |
| claude.com/marketplace/plugins | https://claude.com/marketplace/plugins | 第三者 Plugin の掲載一覧 336 件（L3） | 参照のみ |
| `anthropic-experimental` org | https://github.com/anthropic-experimental | 公開 2 repo はモデル安全性研究。権威未確定（残存リスク） | 範囲外 |
| npm の非スコープ `claude-code` | registry.npmjs.org | Anthropic ドメインの maintainer を持つ。境界 | D13 |

## 3. 情報収集の戦略・計画の立案（これから）

### 3-1. 成果物と終了条件（作業指示者と合意済みの枠）

- 成果物: 公式資産の棚卸し文書 1 本（資産ごとに、何を確かめられるか、確かめられないか、設計で採用するか、をテスト手法の整理文書の軸に対応づける）と、情報源の階層、監視対象の追加判断
- 終了条件の要件: 「あらかじめ把握しておくべき情報源・公開資産はもう他には無い」と、ある程度の確信を持って言えること。やみくもな探索にならないよう、戦略に基づく終了条件を定義する

### 3-2. 立案の進め方（作業指示者の指示）

- Fable（メインセッション）はオーケストレータ。個別の調査とアプローチのアイデア出しは Sonnet / Opus のサブエージェントへ委任する
- まず「計画立案の進め方の計画」を、専任エージェント（Fable の fork か Opus）と対話しながら練る

### 3-3. Fable の初期仮説（専任エージェントへの入力。検証前）

- 探索の単位を「話題」ではなく「公開チャネル」にする。公式資産が公開されうるチャネルを列挙し、チャネルごとに網羅の方法と完了の判定を決める。候補: Anthropic の GitHub 組織（`anthropics`、`agentskills`、他）、claude.com/docs と code.claude.com/docs と platform.claude.com/docs の `llms.txt`、support.claude.com の記事、Anthropic engineering blog、公式 Marketplace の Anthropic 所有 Plugin、Claude Code の changelog、npm / PyPI の Anthropic 発パッケージ（例: mods のテストキット `claude-code/testing`）、agentskills.io の Client Showcase
- 終了条件の候補: (1) 列挙したチャネルをすべて走査した、(2) 既知の公式ページから辿れるリンクの集合が飽和した（新しい公式ドメイン・リポジトリが増えない）、(3) 独立した探索者 N 人が互いに知らない情報源を出さなくなった
- 範囲の限定: 「Claude Code の Plugin を開発・テスト・配布するときに参照すべき」情報源と資産に限る。MCP サーバー実装や Agent SDK は、Plugin が含む場合にだけ対象にする

### 3-4. 結果（2026-10-13）

- 計画: `official-assets-planning-approach_2026-10-13.md`（専任エージェントと 3 往復で確定、red team の指摘 25 件を反映した 0.4 版、9 節に Phase 2 の判定）
- 成果物: **`official-assets-inventory_2026-10-13.md`**（棚卸し文書と終了宣言の草稿、0.9 版）。資産ごとの全表は `official-assets/p2-mapping.md`、結合済みの全件は `official-assets/p2-merged.jsonl`（3,191 行）、クロスチェックは `official-assets/p2-coverage.md`
- 結論: 二重発明ではない（2-1 を追認）。部分的に重なる公式資産は plugin-dev の hook 検査スクリプト、skill-creator の `run_eval.py`（発火テストの公式実装）、`claude plugin test`（mod 専用のテストキット）の 3 つ
- 作業指示者の判断事項: D4〜D7、D11〜D13（棚卸し文書 8 節）
