# P2-V クロスチェック: 終了条件 E1〜E6 の達成度と穴の指摘

- `claude --version`: `2.1.296 (Claude Code)`（取得 2026-10-13 02:18:31 +0900。全 P1 出力の冒頭記録と同じ版で、Phase 1 中の版のずれは無い）
- 作成: P2-V（Opus）。入力: p0-ideas.md、p0-blind-sonnet.md / .jsonl（全文）、p0-blind-opus.md / .jsonl（全文）、p1-*.md 6 本（p1-*.jsonl は Grep のみ）、計画書（1〜4 節、付録 A-9）
- 本書は指摘と提案であり、作業指示者の承認ではない。判定の最終決定は Fable と作業指示者
- 抜き取りの再確認（5 回 / 上限 10）: WebFetch 3 回（`anthropic.com/claude-code/plugin.schema.json` → 404、`anthropic.com/claude-code/marketplace.schema.json` → 404、`code.claude.com/docs/en/plugins-reference` → 本文は「Plugin manifest reference」）、mcp__github__get_file_contents 2 回（`anthropics/apps`・`anthropics/sdk-demos` の README.md → どちらも 404）
- 逸脱の記録: (1) 冒頭の Bash（claude --version と date）に `wc -l`（入力ファイルの行数確認）を同じ呼び出しで含めた。(2) E4 の C2 索引は P1-L が説明の参照項目を展開していなかったため、P2-V 自身の system 文脈（同じ 2.1.296 環境の Agent 一覧にある claude-code-guide の説明）から転記した（ファイルの読み込みではない）。権限拒否: 無し

## 1. 判定の要約

| 条件 | 達成度 | 根拠（1 行。数の単位を併記） |
|---|---|---|
| E1 チャネル全走査 | **未達（基準見直しが発動）** | 件数記録は全チャネルで揃うが、R4 の抜き取りは設計（G-1 の out）と違う母集団で実施された（20 件中 17 件が G-7 の第三者 repo）。anthropics の out repo で署名ありが 7 repo（G-6 経由 6 + 無作為 1/3）あり、R4 の「1 件でもあれば見直す」が発動。out の anthropics repo 約 68 件は木が未取得。G-5 の著者条件は 19,060 件中 0 件で機能していない |
| E2 リンク閉包 | **部分達成（非飽和）** | W-8 は深さ 2 で未知が増え続けた。Anthropic 系の新規 repo はすべて G-1（公開 115 件）に含まれるか改名・非公開（3 名は G-1 外で 404）。1-2 未判定の Anthropic 系ホスト 4 件。既知 repo 内 deep link の G-6 / G-11 との差は、署名・語を持たないパス（feed.xml 等）だけ |
| E3 部分的独立の収束 | **成立（検出 2 件）** | 2 節に無いチャネル種別 2（resources.anthropic.com、GitHub の Atom/RSS フィード）。blind の L1 / L2 項目 183 件中 182 件が P1 の和集合に含まれ、無いのは 1 件（P0-C-077）。文脈由来 flag 15 件・除外 0 件（語リスト外の疑い 2 件） |
| E4 自己索引の包含 | **形式上達成、検出力は弱い** | 未使用索引 3 種で、実体のある項目の包含は 100%（agentskills の profile README 4/4、C9 は実体のある 12/12、C2 は範囲内 6/6）。ただし anthropics の pinnedItems と profile README は 0 件で計算不能、C9 の具体名 19 件のうち 7 件は公開の実体なし（全名基準 12/19 = 63%） |
| E5 収束と監視への移行 | **未達（再走査前）** | 再走査は未実施。推奨 1 件と変える変数を 6 節に提案。T 以前 / 以後の分離に G-1 の commit SHA を使える |
| E6 用途ベースの充足 | **未判定（P2-M 前）** | R8 の「対応先なし」欄の候補を 7 節末尾に引き渡す |

## 2. 指摘の表

穴の数え方: E2-1〜E2-3、E3-1〜E3-2、E4-1〜E4-2、R6-1〜R6-3 の計 10 件（E2 3 / E3 2 / E4 2 / R6 3）。E2-F（G-1 の穴ではなく名前の解決）、E1 の行、矛盾の行（C-1〜C-11 の 11 件）は穴の件数に含めない。

| ID | 種別 | 内容 | 根拠 | 推奨対応 |
|---|---|---|---|---|
| E1-1 | E1 | R4 の抜き取りの母集団が設計と違う。「スター上位 10」が全件 G-7 の第三者 repo（ECC、hermes-agent 等）で、G-1 の out 判定を検査していない。anthropics の repo は 20 件中 3 件だけ。有効な信号は無作為 1/3（uplifting-biomolecular-modeling: SKILL.md×1）と、G-6 に当たった out の anthropics 6 repo（anthropic-cli、buffa、claude-cookbooks、claude-quickstarts、cwc-workshops、redis-py）。R4 規則により G-1 の out 基準（名前・description・topics の語）は反証された | p1-github-content.md 別表 4・138 行・249 行、計画書 2-6 G-11（R4） | **再走査（推奨。6 節）** |
| E1-2 | E1 | G-6 の `path:` 修飾子はルート先頭一致としてしか働かない。木で確かめた範囲で plugin.json 160 中 158、hooks.json 35 中 34、.claude/skills 32 中 19、evals/ 36 中 22 が索引外。org 外の L3 発見（G-6 org 外 2 クエリ）はルート直下の marketplace.json / plugin.json にしか届かない | p1-github-content.md 120〜134 行 | 残存リスクに明記（org 内は再走査で木を全件取れば解消） |
| E1-3 | E1 | G-5 の著者条件が機能していない。OWNER / MEMBER / COLLABORATOR は 0 件（NONE 19,047、CONTRIBUTOR 13）。公開メンバー 0（G-8）で社員も NONE と表示されるため。G-5 で実際に列挙されたのは著者に依存しない pinned 3 件と Announcements 6 件だけ | p1-github-content.md 155〜156 行、p1-github-structure.md 72 行 | 再走査（優先 2。代替案は 6 節） |
| E1-4 | E1 | 未走査 k の個別一覧（件数でなく列挙。R4）: Packages 403（read:packages）、search/users `claude` の 301 件目以降 1,271 件、G-7 各 topic の 101 位以降、G-2 (a) の default 以外の branch、code.claude.com 本文 81/222 ページ（題名は P1-L で網羅）、npm 文字列検索の 250 件上限と maintainer 17 名限定、PyPI JSON の先頭 100,000 字、翻訳版のみの URL、L-2 cache の plugin.json 12 件の $schema、L-2 object source 262 件の個別 author、C1 binary のパス単位の一意化、`/help` の対話専用一覧 | 各 p1-*.md の「未走査」節 | 残存リスクに個別列挙 |
| E1-5 | E1 | 粒度: claude-code の `mods/`（diff、agents-md、sec-default、telemetry、`mods/types/claude-code.d.ts`）と claude-code-playground の `claude-code/{mods,hooks,settings,workflows}` は公式のサンプル mod / hook だが、G-11 の notes の集約にしか無く、資産として行になっていない | p1-docs.md 別表 2、p1-github-content.md 137 行 | P2-M が木から個別に読む（判定の修正） |
| E2-1 | E2 | 1-1 に無い Anthropic 系ホストが 1-2 (a)（フッター）未判定: claude.dev、console.anthropic.com、support.anthropic.com（P1-L-116 は support.claude.com の別名として記録、リダイレクト未確認）、brand.anthropic.com。加えて skills.sh（anthropics/skills の README がリンク、運営不明） | p1-docs.md 179・181 行、P1-D-1209〜1212 | 再走査（優先 3）。既存の unverified 行なので P2-R の検証で閉じる余地あり |
| E2-2 | E2 | 既知 repo 内 deep link のうち G-6 / G-11 の記録に出ないもの: anthropics/claude-code の `feed.xml`（P1-D-1144）と `examples/`、claude-code-playground の `_template/PREFLIGHT.md`・`demos/`・`launch-demos/`。木には在るが 2-5 の署名・語を含まないため抽出されない（R3 の残差） | p1-docs.md 201・207 行、p1-github-content.md 119〜137 行 | 残存リスクに明記。feed.xml は監視案（7 節） |
| E2-3 | E2 | W-8 は非飽和のまま（深さ 3 未実施）。深さ 2 の新規 54 単位の大半は第三者の技術ドメイン（out）で、Anthropic 系は上の E2-1 と repo 名だけ。repo は G-1 が org を全件列挙しているので深さ 3 で増える余地は小さいが、ドメインは閉じていない | p1-docs.md 156 行 | 残存リスクに明記（ドメインは E2-1 で閉じる） |
| E2-F | E2 | repo 名 anthropic-cookbook / sdk-demos / apps は G-1 の公開 115 件に無い（totalCount 一致）。apps と sdk-demos は README が 404（本書の再確認）。anthropic-cookbook は claude-cookbooks への改名と見られる | P1-D-1227〜1229、P1-G1 totalCount | 判定の修正（P2-R が claude-plugins-public と同じ方法 = API 応答の full_name で確かめる）。G-1 の穴ではない |
| E3-1 | E3 | **2 節に無いチャネル種別**: `resources.anthropic.com`（HubSpot の hubfs による PDF 配布）。P0-C-077「The Complete Guide to Building Skills for Claude（PDF）」。W-6 は www.anthropic.com の sitemap だけを見る。P1 では第三者 repo の homepage 欄に 1 回出るだけで、項目にもチャネルにもなっていない。内容は claude.com の resources/guides 版（P1-B-072〜074）と同一の可能性 | p0-blind-opus.jsonl 77 行、p1-github-structure.jsonl 307 行（Grep） | 残存リスクに明記し、W-6 の但し書きに「Anthropic のサブドメインの配布ホスト」を加える案。PDF と P1-B-072 の同一性は P2-M が確かめる |
| E3-2 | E3 | **2 節に無いチャネル種別（監視用）**: GitHub の Atom/RSS フィード。P0-B が `releases.atom` を試行（robots で拒否）、P1-D は claude-code の top-level `feed.xml` を観測。4-4 に `watchable: rss` の欄はあるが、チャネルとしても監視手段としても定義が無い | p0-blind-sonnet.md 101 行、P1-D-1144 | 監視案に追加（D3 の判断材料）。列挙チャネルには不要 |
| E4-1 | E4 | C9 の具体名 19 件のうち公開の実体が無いもの 7 件: 実体不明 5（anthropic-marketplace、anthropic-plugins、financial-services-plugins、first-party-plugins、claude-plugin-directory）、文字列のみ 2（claude-code-marketplace、agent-skills）。予約は防衛目的の可能性が高く資産の欠落とは限らない | p1-github-content.md 別表 2 | 残存リスクに明記（非公開 marketplace の可能性） |
| E4-2 | E4 | E4 の索引 (3)「claude-code-guide の説明が参照する項目」を P1-L が展開していない（C2 表は skill / agent 名の一覧で、説明の参照項目は無い）。本書は P2-V の system 文脈から転記して計算した（4 節） | p1-local.md 別表 2 | 判定の修正（Fable が本書 4 節の転記を採るか決める） |
| R6-1 | R6 | anthropic-experimental が未判定: is_verified=false、blog=anthropic.com（自己申告）、L1 からのリンク未確認。公開 2 repo はモデル安全性研究 | p1-github-structure.md 91 行 | 再走査の対象候補（優先低）。中身が範囲外なので L1 か否かを決めずに scope out で閉じる案もある |
| R6-2 | R6 | L-2 の object source（url 164 / git-subdir 98）の owner 集合が抽出されていない。R6 の発見源「L-2 の source / homepage」が欠け、名前に anthropic / claude を含まない Anthropic 所有 org がここに隠れていても検出できない | p1-local.md 144・147 行 | 再走査（P1-L の追加: source の owner を一意化して 1-2 にかける。機械作業で数回） |
| R6-3 | R6 | 社員の個人アカウントを判定する手続きが無い（G-8 = 0）。P1 出力に現れた個人: user-07（Releases の唯一の author）、user-91（skills の fork）、user-09（sandbox-runtime の fork）、user-86（community の fork）、user-25（SchemaStore に @anthropics と自己申告）。B2（L1 からリンクされた社員リポジトリ = L3）が実行できない | p1-changelog-registry.md 111 行、p1-github-structure.md 別表 3b、p1-github-content.md 別表 3 | 残存リスクに明記。G-5 の代替著者集合（6 節）と同じ集合で補える |
| C-1 | 矛盾 | 1-2 の「掲載元が宣言する著作者」を文字どおり適用すると L1 にならない例: marketplace.json の owner.name が個人（anthropics/skills = 個人名（マスク）、financial-services = 個人名（マスク））。security-guidance は marketplace の author = Anthropic、plugin.json の author = 個人名（マスク）。全エージェントが L1 のまま扱っている | p1-github-content.md 203 行、P1-L-077 | 判定の修正（Fable が「anthropics 配下で社員個人名の宣言は L1」等の規則を 1-2 に足すか決める） |
| C-2 | 矛盾 | SchemaStore の plugin manifest / marketplace スキーマを P1-G2 は「L3 候補」とした。L3 は Anthropic 管理下の場所への掲載が条件で、SchemaStore はそうでない。docs も URL を示さない（manifest-reference は「load 時は無視」のみ）。P1-L-107 は同種を「対象外（仮）」 | P1-G2-088 / 089、P1-L-107、計画書 1-1 L3 | 判定の修正（out / boundary） |
| C-3 | 矛盾 | claude-plugins-community: P1-G1 / G2 は L1・内、P1-D は境界（「L3 の鏡」）、P0-C は L3・除外。カタログ（Anthropic 運営）と収録物（第三者）を区別していない | P1-G1-034、P1-D-1112、P0-C-083 | 判定の修正（repo = L1、収録エントリ = L3 に分ける） |
| C-4 | 矛盾 | claude.com/marketplace/plugins/{plugin-dev、security-guidance、claude-code-setup、claude-md-management} を P1-B は L3（著作者未確認）、同じ Plugin を P1-L は L1（author = Anthropic） | P1-B-033・034・037・038、P1-L-073・077・080・081 | 判定の修正（L1 に揃える） |
| C-5 | 矛盾 | P1-L-105 `anthropic.com/claude-code/plugin.schema.json` は HTTP 未取得のまま L1・内・candidate。本書の再確認で 404（marketplace.schema.json も 404 で、blind 2 名の結果と一致）。証拠ポリシー（4-5）では unverified | P1-L-105 / 106、P0-B-060、P0-C-072、本書の WebFetch | 判定の修正（unverified） |
| C-6 | 矛盾 | 同じ対象で scope_verdict が食い違う: plugins/security（L 境界 / D 内）、plugins/relevance（L 内 / D 境界）、mods/interface・gallery（L 内 / D 境界）、whats-new/index（L 内 / D 境界）、pre-submission-checklist（D 境界 / B 内）、claude-code-playground（G1 内 / D 境界）、resources/articles/build-plugins-for-claude（B 内 / blind C は提出フローとして out）、縦割り marketplace（G1 で life-sciences だけ内、financial-services・healthcare・claude-for-legal は境界）、claude-code-action・sandbox-runtime・devcontainer-features（G1 内 / blind 除外） | 各 p1-*.md の候補表、p0-blind-*.jsonl | 判定の修正（Fable が URL ごとに 1 つに決める。P2-R は原値を保持する規則） |
| C-7 | 矛盾 | 種別: P1-L は docs ページを全件「資産」とし、他は「情報源」（0-3 の定義では情報源）。P1-L-066 / 067 の marketplace は「源」 | p1-local.md 13〜71 行 | 判定の修正（P2-M の対応づけに影響） |
| C-8 | 矛盾 | `anthropic-skills:` 名前空間 15 件を P1-L は一括で「対象外（仮）」。うち skill-creator は L1 の複製 12 件とサイズ一致（33168B）。一方 large-file-reading・xsd-to-rdb はアカウント固有（作業指示者側）。Anthropic 著作分とアカウント固有分が混在 | P1-L-127 / 128、p1-local.md 174 行 | 判定の修正（著作者で 2 群に分ける。identity は P2-R の M5） |
| C-9 | 矛盾 | 別名の二重計上: P1-B-121（plugins-reference）・122（plugins）・123（discover-plugins）・128（subagents）・130（docs.claude.com/…/headless）・172（docs.anthropic.com/…/statusline）を独立の candidate にしている。plugins-reference は本文が manifest-reference（本書の再確認）。1-2 では別名欄に入れる | p1-blog-support.md 89〜120 行、本書の WebFetch | 判定の修正（P2-R の重複除去で aliases に統合） |
| C-10 | 矛盾 | anthropic-plugin-directory: P1-L はローカル cache の名前空間（claude-security 0.11.0、playground）として実体を記録、P1-G2 は「実体不明」 | P1-L-092、p1-github-content.md 200 行 | 判定の修正（「実体あり（claude.ai の directory 同期。公開 repo なし）」） |
| C-11 | 矛盾 | agentskills org: P1-G1 は「L2（候補）。L1 からのリンク未確認」だが、code.claude.com/docs/en/skills → agentskills.io のリンクを P0-C-030 と P1-D（skills/how-to、skills ページ）が確認済み、profile README に「maintained by Anthropic」。L2 の条件を満たす | P1-G1-018、p1-docs.md 146 行、別表 2（E4） | 判定の修正（L2 確定） |

## 3. E3 の詳細

### 3-1. blind の「走査の記録」のチャネル種別と計画 2 節の対応

| blind の表記（走査者） | 計画の ID | 判定 |
|---|---|---|
| docs-index / docs-llms-txt / docs-llms-index（B, C） | L-1, W-1 | 既知 |
| docs-direct / docs-page-fetch（B, C） | W-1 | 既知 |
| linked-from-L1-doc / docs-outbound-link / readme-link（B, C） | W-8 | 既知 |
| github-org-listing（REST orgs/repos）/ github-org-search（search_repositories）（B, C） | G-1, G-9 | 既知 |
| github-contents-api / demo-marketplace-dir（B, C） | G-11（部分） | 既知 |
| github-raw（CHANGELOG、README、action.yml）（B, C） | W-4, G-10 | 既知 |
| marketplace-json / official-marketplace-catalog（B, C） | L-2 | 既知 |
| npm-registry（B, C） | W-5 | 既知 |
| cli-builtin（B） | L-3 | 既知 |
| web-search / websearch（B, C） | S-1 | 既知 |
| 言語別索引 `/_llms/jp.txt`（C、未取得） | C5（P1-D が llms.txt のみ 13 件で観測） | 既知 |
| 旧 docs URL（docs.anthropic.com、discover-plugins）（C、未確認） | 1-2 の別名規則、S-1 | 既知 |
| `$schema` の URL（B, C） | C4 | 既知 |
| **resources.anthropic.com の hubfs（PDF）（C）** | 該当なし | **新種別（E3-1）** |
| **GitHub の Atom/RSS フィード（releases.atom）（B）** | 該当なし（watchable の値のみ） | **新種別・監視用（E3-2）** |

### 3-2. 文脈由来の flag と除外（除外規則 (a)(b) の適用）

- 照合した欄: name、url、notes。行単位で数え、集約行も 1 件。`LLMs` は大文字小文字を区別し、公開ファイル名 `llms.txt` は数えない。P0-C-077 の URL 末尾 `.pdf` は anthropic-skills の skill 名 pdf と意味が違うので数えない（機械的には 1 件一致）
- **flag 15 件**: Sonnet 8 件（P0-B-024〔notes に skill-creator〕、041、042、043、046、047、071、079〔notes に claude-code-playground〕）、Opus 7 件（P0-C-058、059、060、061、063、078〔claude-code-playground〕、085〔notes に claude-security、playground〕）。当たった語は plugin-dev、hookify、skill-creator、security-guidance、claude-security、playground のみ。cc-workspace・empty-can・.claude/work・statusline・claude-code-guide・pre-compact 等の語は 0 件
- **除外 0 件**: 15 件すべてが verified に取得方法と取得 URL（marketplace.json の全文取得、contents API、llms.txt の取得、org の repo 一覧）を持つ
- **語リスト外の文脈由来の疑い 2 件**: P0-B-057 と P0-C-073（どちらも `claude plugin tag`）。両名とも取得根拠なしに列挙し、P0-B-057 の notes は「リポジトリ内運用文書の記述のみ」（注入された `.claude/CLAUDE.md` のリリース手順が出所）。規則の趣旨を拡張適用すれば除外 2 件。次回の blind には CLAUDE.md の固有語（`claude plugin tag`、`--plugin-dir`、`metadata.pluginRoot` 等）も語リストに入れる案
- 選択の偏り: Anthropic 著作 39 件のうち、blind が個別行に出したのは B が plugin-dev・hookify・skill-creator、C が plugin-dev・skill-creator・hookify・security-guidance で、インストール済みの 6 件と重なる。取得で裏付けられているので除外しないが、「何を個別に取り上げるか」に文脈の影響がありうる
- 一致計算（除外 0 のため分母は全件）: Sonnet 79 件中 79 件、Opus 104 件中 103 件が P1 の和集合（status を問わない）に含まれる。注記: (1) P0-B-059 / P0-C-071（claude.com/blog/claude-code-plugins）は P1-B-052（/resources/articles/claude-code-plugins）と別名で一致（P1-B は blog → articles の正規化を 2 件の抜き取りで確認、本件の個別リダイレクトは未確認）。(2) docs ページ 6 件（P0-C-035 output-styles、037 env-vars、050 github-actions、051 github-enterprise-server、081 channels-reference、P0-B-037 github-actions）は P1-L の集約行（p1-local.jsonl 61・65 行）でのみ一致し、ページ単位の範囲判定は展開されていない（計算の限界）。blind は 6 件とも境界
- 収束の解釈: 一致は「部分的独立」のもとでの弱い証拠にとどまる。blind 2 名とも Phase 1 のチャネルの大半（G-5、G-11 全件、W-6 / W-7 の sitemap、C1〜C4、C9）を走査しておらず、blind 側の和集合が P1 より小さいので、「blind に無い P1 項目」は網羅の反証にならない

### 3-3. blind の L1 / L2 項目のうち P1 の和集合に無いもの

| ID | 名称 | URL | blind の判定 | 備考 |
|---|---|---|---|---|
| P0-C-077 | The Complete Guide to Building Skills for Claude（PDF） | https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf | L1 / 境界 / unverified（WebSearch に出現、未取得） | P1 では第三者 repo の homepage 欄にのみ出現（p1-github-structure.jsonl 307 行）。内容は P1-B-072〜074（claude.com/resources/guides/the-complete-guide-to-building-skills-for-claude）と同一の可能性 |

## 4. E4 の表（索引ごとの包含）

| 索引 | seed / 入力に使ったか | 項目数 | 包含数 | 包含率 | 備考 |
|---|---|---|---|---|---|
| anthropics の pinnedItems | 未使用 | 0 | - | 計算不能 | 固定なし |
| anthropics の profile README | 未使用 | 0 | - | 計算不能 | `.github` repo なし |
| （参考）anthropics の Popular repositories | 未使用 | 6 | 6 | 100% | スター上位の自動表示で、Anthropic が選んだ索引ではない |
| agentskills の profile README | 未使用 | 4（agentskills.io、/specification、anthropics/skills、agentskills/agentskills） | 4 | 100% | P1-D-0266 / 0267、P1-G1-019 / 134。anthropic.com は既知ドメイン |
| anthropic-experimental の pinned / README | 未使用 | 0 | - | 計算不能 | |
| C9 予約 Marketplace 名（具体名） | 未使用（G-6 の対応づけにのみ使い、seed ではない） | 19 | 12 | 63%（実体のある名前に限れば 12/12） | 実体: GitHub 10 + repo 名一致 1（claude-plugins-community）+ ローカル cache 1（anthropic-plugin-directory。C-10）。残り 7 は E4-1 |
| C2 claude-code-guide の説明の参照項目 | 未使用 | 範囲内 6（hooks、slash commands、settings、`claude plugin eval`、eval の CI 実行、`/skill-doctor`）+ 境界・範囲外 5（MCP servers、IDE 連携、Agent SDK、Claude API 群、Claude Tag） | 範囲内 6、境界・範囲外 5 | 100% | P1-L-035 / 037 / 039、P1-C-010 / 011、github-actions は P1-L の集約行、Claude Tag は P1-G1-089 と C5 の en/claude-tag。転記元は P2-V の system 文脈（E4-2） |
| （参考）build/overview の 7 ツール | 使用（survey の出発点、W-8 の seed） | 7 | - | 未計算 | 7 ツールの一覧が本書の入力に無い。P1-D-0001 を seed に深さ 1 の全リンクを取得済みなので、構成上ほぼ 100% |
| （参考）code.claude.com の plugins / skills / eval / mods の関連リンク | 使用（W-8 の seed） | 32 ページ | 32 | 100% | P1-D の深さ 1 で全件 |
| （参考）anthropics/claude-code の README | 使用（W-8 の seed） | top-level 一覧 | - | - | `.claude-plugin/`、`examples/`、`feed.xml` を観測。後 2 者は E2-2 |

- 「使っていない索引を 2 つ以上」は形式上満たす（agentskills の README、C9、C2）。ただし Anthropic 本体（anthropics）の自己索引は 0 件で、残る 3 索引は分母が小さいか（README 4、C2 6）、資産でなく名前の予約（C9）である。包含 100% は検出力の弱い結果として読む

## 5. R6: owner・スコープの集合と 1-2 の判定

| 区分 | owner / スコープ / ホスト | 出現元 | 1-2 の判定 | 扱い |
|---|---|---|---|---|
| org（既知） | anthropics | 全 P1 | L1（verified、anthropic.com） | - |
| org（既知） | agentskills | G-1、P1-D、P0-C | L2（C-11 で確定可） | 判定の修正 |
| org | anthropic-experimental | G-9 / G-1 | 未判定（(a) 不成立、(b) 未確認） | R6-1 |
| org | modelcontextprotocol | P1-L-082、P1-D、P1-C（npm 38） | L2・範囲外（B4） | 対応不要 |
| org（第三者） | SchemaStore、Shopify（liquid-skills）、npm（node-semver）、aws-samples（verified だが AWS）、rizerphe、blobfile | P1-G2 C4、P1-D、P1-C | out（L3 別表は Shopify のみ） | C-2 |
| org（fork の親） | github、ijl、tokio-rs、apache、encode、ionelmc、google、patrick-kidger | G-2 (a) | out（外部の fork） | 対応不要 |
| org（類似名） | AnthropicAI、Antrophics、AnthropicsTechnology、usecorgi（blog = www.anthropic.com）、Anti-Anthropic、modmyclaude | G-9 | out（成りすましの可能性） | 監視メモ |
| 名前（404） | anthropic-streamlit ほか 6 | G-9 | org ではない（user か削除） | 対応不要 |
| 個人 | user-07、user-91、user-09、user-86、user-25、user-88 | P1-C、G-2 (b)、P1-G2 | B2（L1 からのリンクなし → 対象外） | R6-3 |
| L-2 source | url 164 / git-subdir 98 の owner | P1-L | 未抽出 | R6-2 |
| npm | @anthropic-ai（既知）、@modelcontextprotocol、無 scope の anthropic・claude-code（P1-C-113）、`*-napi` 5 件 | P1-C | 判定済み（P1-C） | maintainer 17 名限定は E1-4 |
| PyPI | org anthropic: claude-code、anthropic、claude、claude-agent-sdk、claude-sdk、claude-code-sdk | P1-C-058〜064 | 全件に行あり | 対応不要 |
| ホスト | resources.anthropic.com、claude.dev、console.anthropic.com、support.anthropic.com、brand.anthropic.com、skills.sh | P0-C、P1-D、P1-L | 未判定 | E3-1、E2-1 |
| ホスト | academy.claude.com | P1-D、P1-B | L1（P1-B が anthropic.com/learn からの 308 を確認 = 1-2 (b)） | P1-D の「運営未確認」は解消 |

- G-9 の sanity test（agentskills が検索に出ない）は手続きの欠陥として確定。補完の発見源のうち、W-8・CHANGELOG・npm / PyPI の owner は集めたが、L-2 の source の owner（R6-2）が欠けている

## 6. 再走査の提案（R7。採否は Fable）

**推奨（1 つ）: G-11 の対象を、anthropics の G-1 で out の全 repo（約 68 件）と anthropic-experimental の 2 repo に広げ、署名の有無で分類し直す**

- 理由: R4 の規則が発動した（E1-1。out の anthropics repo で署名あり 7 repo）。G-6 は入れ子の署名を拾えない（E1-2）ので、木を取っていない out repo の入れ子の plugin.json / hooks.json / .claude/skills / evals は現状まったく見えていない。対象は有限（約 70 呼び出し。これまでの 65 本の木で truncated は 0 件）で、抜き取りでなく org 全体を閉じられる
- 変える変数: (1) チャネルの範囲: in / boundary + 抜き取り 20 → org の全 repo。(2) 分類器: 名前・description・topics の語 → 木の署名と語。(3) 補助のクエリ: G-6 を `path:` 無しで再実行（`org:anthropics filename:plugin.json`、`filename:hooks.json`、`filename:marketplace.json`）し、結果のパスに `.claude-plugin/` 等を後段で当てて木の結果と突き合わせる。モデルは Sonnet のまま（判断を求めない作業）。著者条件は変えない
- T の固定: G-1 が記録した default branch の commit SHA（verified.ref / identity.tree_sha）で `git/trees/{sha}?recursive=1` を取れば、T 以後の追加を収束判定から外せる
- 期待する出力: out の各 repo に「署名あり / 語のみ / なし」の印。署名ありは boundary で Fable に回す（範囲判定は Fable）

**優先 2: G-5 を代替の著者集合で再実行**（変える変数: 著者条件）。著者条件の代替案:

| 案 | 方法 | 強み / 弱み |
|---|---|---|
| A. Release の author | claude-code の Releases の author（P1-C: user-07 のみ）、claude-code-action・sandbox-runtime の Releases の author | 書き込み権限の確証。人数が少ない |
| B. contributors 上位 × commit のメール | `repos/{o}/{r}/contributors` の上位 30 名について、`commits?author={login}` の commit.author.email が `@anthropic.com` か | 最も検証可能。API 呼び出しが人数分要る |
| C. ラベル付与・close の actor | GraphQL `timelineItems(itemTypes:[LABELED_EVENT, CLOSED_EVENT])` の actor | triage 権限保持者を拾える。社員以外の collaborator が混ざりうる |
| D. npm maintainer の対応づけ | P1-C の maintainer 17 名を同名の GitHub login に対応づける | 社員の可能性が高い。同名別人の危険 |
| E. login の接尾辞 | `-ant`、`-anthropic`（user-07、user-91、user-67 等） | 安価。誤検出・取りこぼしがある補助 |
| F. プロフィールの company | `users/{login}` の company が Anthropic / @anthropics | 自己申告で検証できない（user-25 が実例）。単独では使わない |

- 集合は A ∪ B ∪ C を主、D・E を補助にし、`search/issues` の `author:{login}` 修飾子と既存のラベル集合・since（2025-06-30）で絞る。CONTRIBUTOR の 13 件は全件読む

**優先 3: W-8 の未判定ホスト**（E2-1 の 4 件 + resources.anthropic.com + skills.sh）に 1-2 (a) のフッター確認とリダイレクト確認。P1-D-1209〜1212 は既存の unverified 行なので、P2-R の検証で閉じる余地がある

## 7. 終了宣言の「残存リスク（個別）」に書くべき定型外の項目の案

1. 公式の JSON Schema が取得できない: plugin.json / marketplace.json の `$schema` が指す `anthropic.com/claude-code/{plugin,marketplace}.schema.json` は 2026-10-13 に 404。形式の機械可読な L1 の正本は無く、形式の正本は docs の項目表と `claude plugin validate` に限られる（SchemaStore 版は第三者の投稿）
2. code search の構造的な限界: `path:` はルート先頭一致としてしか働かず、fork・archived・384 KB 超は索引外。org 外の L3 発見はルート直下の署名に限られ、上位 1,000 件で打ち切り（total 39,296 / 28,096）
3. 社員の識別ができない: 公開メンバー 0 のため author_association で社員を判定できず、G-5 の著者条件と B2 の判定が働かない（再走査で代替集合を使わない限り）
4. L1 の marketplace で owner / author が社員個人名（skills、financial-services、security-guidance の plugin.json）。権威の判定は置き場所に依存している
5. 予約 Marketplace 名のうち公開の実体が無いもの 5 件（非公開または将来用の可能性）
6. docs・README の古い slug / repo 名（plugin-marketplaces、plugins-reference、discover-plugins、anthropic-cookbook、sdk-demos、apps）。リダイレクトの有無が名前ごとに違い、リンク閉包の未知に偽の単位を生む
7. sitemap の外にある Anthropic のホスト（resources.anthropic.com、claude.dev ほか）は W-6 / W-7 の列挙に入らない
8. ローカルのキャッシュと marketplace の版のずれ（security-guidance 2.0.8 / 2.0.13、claude-security 0.11.0 / 0.12.0、skill-creator の cache 10 版）。L-2 の観測は取得時点の cache に依存する
9. anthropic-experimental の権威が未確定（範囲外の内容なので棚卸しへの影響は小さい）
10. ghcr.io の Packages は read:packages スコープが無く未確認（403）
11. docs と CHANGELOG の版記述の食い違い（`/skill-doctor` は docs が v2.1.252、CHANGELOG の初出は 2.1.261）。変更履歴タグの正本をどちらにするか未定
12. W-8 は深さ 2 で非飽和のまま終えた（深さ 3 未実施）

- E6 への引き渡し（R8 の「どの手法・活動にも対応づかない資産」の候補）: `/skill-doctor` の診断、CI の `claude plugin validate --strict`、`claude plugin tag` の版管理、`claude plugin test`（mods のテストキット `claude-code/testing`）、claude-code の `feed.xml`（監視）、claude-code-action の `plugins` 入力、plugins/measure と Analytics API（利用実績の観測）
