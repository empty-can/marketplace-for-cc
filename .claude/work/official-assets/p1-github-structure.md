# P1-G1 GitHub の構造（G-1 / G-2 / G-3 / G-7 / G-8 / G-9 / G-10 / G-12）

- `claude --version`: 2.1.296 (Claude Code)
- 取得時刻（ISO 8601）: 初回走査 開始 2026-10-13T01:18:53+09:00（gh 未認証、MCP 代替）/ 追加走査 開始 2026-10-13T01:43:50+09:00（gh 認証後）/ このファイルの更新 2026-10-13T01:56:56+09:00。取得日 2026-10-13
- 初回走査は `gh` CLI が未認証だったため MCP 代替（search_repositories / get_file_contents / list_tags、WebFetch）で行い、gh 依存の項目を「未走査」とした。追加走査（Fable 指示）で gh 認証後に実施済み。**初回と追加で値が食い違う場合は追加走査（gh api / GraphQL）を正とする**
- 表の 8 列目「一次確認」: SHA は default branch HEAD の commit の先頭 12 桁（GraphQL `defaultBranchRef.target.oid`。tree_sha は JSONL の identity）。org 行は SHA 無し

## 候補表（status が candidate または scope_verdict が boundary の行のみ。34 行）

| ID | 名称 | URL（最終 URL） | 種別・権威 | 権威の対象 | 活動と範囲判定 | 発見チャネル | 一次確認（取得日、SHA か version） |
|---|---|---|---|---|---|---|---|
| P1-G1-001 | anthropics (GitHub org) | https://github.com/anthropics | 情報源 / L1 | 参照実装・変更履歴・挙動 | 開発・テスト・配布 / 内 | G-9・G-1 | 2026-10-13, gh api graphql |
| P1-G1-018 | agentskills (GitHub org) | https://github.com/agentskills | 情報源 / L2 | 形式 | 開発 / 内 | G-1 | 2026-10-13, gh api graphql |
| P1-G1-019 | anthropics/skills | https://github.com/anthropics/skills | 資産 / L1 | 参照実装 | 開発 / 内 | G-1・G-7 | 2026-10-13, gh api graphql, dbd4588f9e10 |
| P1-G1-020 | anthropics/claude-code | https://github.com/anthropics/claude-code | 資産 / L1 | 挙動・変更履歴 | 開発・テスト・配布 / 内 | G-1 | 2026-10-13, gh api graphql, 3deb87368737 |
| P1-G1-024 | anthropics/claude-plugins-official ※旧名 claude-plugins-public | https://github.com/anthropics/claude-plugins-official | 資産 / L1 | 参照実装 | 開発・配布 / 内 | G-1・G-7 | 2026-10-13, gh api graphql, f359d43b4060 |
| P1-G1-134 | agentskills/agentskills | https://github.com/agentskills/agentskills | 資産 / L2 | 形式 | 開発 / 内 | G-1・G-7 | 2026-10-13, gh api graphql, 69ef37e9424c |
| P1-G1-029 | anthropics/claude-code-action | https://github.com/anthropics/claude-code-action | 資産 / L1 | 参照実装 | 配布 / 内 | G-1・G-10 | 2026-10-13, gh api graphql, 1d6de8cb0c23 |
| P1-G1-033 | anthropics/sandbox-runtime | https://github.com/anthropics/sandbox-runtime | 資産 / L1 | 挙動 | テスト / 内 | G-1 | 2026-10-13, gh api graphql, 6b4fc1d27d43 |
| P1-G1-034 | anthropics/claude-plugins-community | https://github.com/anthropics/claude-plugins-community | 資産 / L1 | 参照実装 | 配布 / 内 | G-1 | 2026-10-13, gh api graphql, f60f0454df30 |
| P1-G1-049 | anthropics/claude-code-base-action | https://github.com/anthropics/claude-code-base-action | 資産 / L1 | 参照実装 | 配布 / 内 | G-1・G-10 | 2026-10-13, gh api graphql, 0adbfaf05435 |
| P1-G1-056 | anthropics/life-sciences | https://github.com/anthropics/life-sciences | 資産 / L1 | 参照実装 | 配布 / 内 | G-1 | 2026-10-13, gh api graphql, e96556b637b5 |
| P1-G1-068 | anthropics/devcontainer-features | https://github.com/anthropics/devcontainer-features | 資産 / L1 | 参照実装 | テスト / 内 | G-1 | 2026-10-13, gh api graphql, 4c6fe6a383af |
| P1-G1-073 | anthropics/claude-code-playground | https://github.com/anthropics/claude-code-playground | 資産 / L1 | — | 開発 / 内 | G-1 | 2026-10-13, gh api graphql, 569c5283d9a0 |
| P1-G1-022 | anthropics/financial-services | https://github.com/anthropics/financial-services | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, 574ed3624aeb |
| P1-G1-025 | anthropics/knowledge-work-plugins | https://github.com/anthropics/knowledge-work-plugins | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, 02ffa99ff00c |
| P1-G1-028 | anthropics/claude-for-legal | https://github.com/anthropics/claude-for-legal | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, 4a6c651889c9 |
| P1-G1-030 | anthropics/claude-agent-sdk-python | https://github.com/anthropics/claude-agent-sdk-python | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, b6e9d12fe1cc |
| P1-G1-031 | anthropics/defending-code-reference-harness | https://github.com/anthropics/defending-code-reference-harness | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, d3bea6b5793b |
| P1-G1-032 | anthropics/claude-code-security-review | https://github.com/anthropics/claude-code-security-review | 資産 / L1 | — | 配布 / 境界 | G-1・G-10 | 2026-10-13, gh api graphql, 0c6a49f1fa56 |
| P1-G1-037 | anthropics/commerce-agents | https://github.com/anthropics/commerce-agents | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, fd4d59224ab9 |
| P1-G1-039 | anthropics/claude-agent-sdk-demos | https://github.com/anthropics/claude-agent-sdk-demos | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, 826b268506a5 |
| P1-G1-045 | anthropics/claude-agent-sdk-typescript | https://github.com/anthropics/claude-agent-sdk-typescript | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, 85d8f8e07721 |
| P1-G1-048 | anthropics/launch-your-agent | https://github.com/anthropics/launch-your-agent | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, d5d0ffbca3ab |
| P1-G1-052 | anthropics/code-migration-kit-with-claude-code | https://github.com/anthropics/code-migration-kit-with-claude-code | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, cf91c9d5068d |
| P1-G1-053 | anthropics/cwc-long-running-agents | https://github.com/anthropics/cwc-long-running-agents | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, ad107a974bce |
| P1-G1-057 | anthropics/k12-teacher-skills | https://github.com/anthropics/k12-teacher-skills | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, 281eb8d41fe2 |
| P1-G1-058 | anthropics/claude-ai-mcp | https://github.com/anthropics/claude-ai-mcp | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, 43dac3a1bc64 |
| P1-G1-060 | anthropics/healthcare | https://github.com/anthropics/healthcare | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, c7ed150d376b |
| P1-G1-063 | anthropics/claude-code-monitoring-guide | https://github.com/anthropics/claude-code-monitoring-guide | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, 02777441f2a3 |
| P1-G1-072 | anthropics/oncall-kit | https://github.com/anthropics/oncall-kit | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, c03282cd5381 |
| P1-G1-080 | anthropics/agent-sdk-workshop | https://github.com/anthropics/agent-sdk-workshop | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, a273fbe2b377 |
| P1-G1-081 | anthropics/github-mcp-server | https://github.com/anthropics/github-mcp-server | 資産 / L1 | — | — / 境界 | G-1・G-2 | 2026-10-13, gh api graphql, 73822530fe79 |
| P1-G1-085 | anthropics/claude-for-financial-advisors | https://github.com/anthropics/claude-for-financial-advisors | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, 96fbcb479775 |
| P1-G1-089 | anthropics/claude-tag-plugins | https://github.com/anthropics/claude-tag-plugins | 資産 / L1 | — | — / 境界 | G-1 | 2026-10-13, gh api graphql, b6ee25f8f00a |

## 件数表（探索単位ごと。複数チャネルで見つかった行は各単位に重複して数える。採用 = candidate かつ in）

| 探索単位 | 列挙 | 採用 | 除外 | 未確認 | 境界 | 備考 |
|---|---|---|---|---|---|---|
| G-9 | 399 | 1 | 391 | 7 | 0 | search/users 2 本（anthropic 91 件、claude 1,571 件のうち先頭 300）+ 初回の repo 検索の owner を orgs API で判定。L1 は anthropics のみ。未確認 = anthropic-experimental と orgs が 404 の 6 件 |
| G-1 | 121 | 13 | 85 | 2 | 21 | GraphQL totalCount: anthropics 115 / agentskills 2 / anthropic-experimental 2 = 取得件数。org 行 2 を含む |
| G-2 | 125 | 0 | 124 | 0 | 1 | (a) anthropics の fork 25 件を compare 済み。(b) in の 10 リポジトリ × 上位 10 fork = 100 件 |
| G-7 | 817 | 3 | 814 | 0 | 0 | org 外: 1〜50 位 396 + 51〜100 位 418。org 内の既出 3 件を含む |
| G-10 | 3 | 2 | 0 | 0 | 1 | claude-code-action / base-action / security-review |
| G-3 | — | — | — | — | — | 追加呼び出し無し。notes に stars 順位を記録 |
| G-8 | — | — | — | — | — | public_members API: 0 件（行は作らない） |
| G-12 | — | — | — | — | — | in の L1 リポジトリ 11 件（行は作らない）。別表 4 |
| 全行（重複なし） | 1433 | 13 | 1390 | 9 | 21 | JSONL の総行数（初回 533 行 + 追加走査 900 行。既存 id は変更せず、新規は P1-G1-534 以降）|

## 走査の記録

- **フィルタ基準（範囲判定。初回走査）**: 2-5 の語（署名はファイルツリーが要るため G-11 に回す）。名前・description・topics のキーワードと、`org:anthropics fork:false <語> in:readme` を 5 語（plugin / marketplace / skill / hook / "claude code"）で検索した README 語の当たり（README 冒頭の目視は呼び出し数の都合で未実施。README 全体への当たりで代替）。判定は (a) 名前・description・topics に主要語 → in、(b) 境界語（mcp、agent sdk）または除外語（cowork）と主要語の衝突、description が無く README 語が 3 種以上、用途が Plugin 開発と無関係かもしれない → boundary、(c) それ以外 → out。迷えば boundary。README 語が 2 種以下の out は誤判定の余地があり、G-11 の抜き取り（out から 10 件 + スター上位 10 件）で検査する必要がある
- **初回走査（gh 未認証）の要約**: G-1 は `org:anthropics fork:true sort:stars` で 115 件（search の total_count）、G-9 は `anthropic in:name` / `claude in:name` の上位 50 の owner、G-7 は topic ごとの上位 50（`sort:stars`）、G-12 は MCP の list_tags（1 ページ目）。これらは追加走査で GraphQL / REST に置き換え済み

### 追加走査（Fable 指示、gh 認証後、2026-10-13）

- **G-1（GraphQL）**: `organization(login).repositories(privacy:PUBLIC)` を `--paginate`。totalCount は anthropics **115**、agentskills **2**、anthropic-experimental **2**。取得件数と一致し、初回の 115 / 2 / 2 とも一致（fork・archived・topics・wiki・discussions のフラグに差異なし。スター数は数分の経過で ±数件）。全 119 リポジトリの gh オブジェクトを GraphQL の値で更新し、`parent`、default branch の commit SHA（verified.ref）と tree SHA（identity.tree_sha）を入れた。tree_sha が null なのは空リポジトリの anthropics/homebrew-claude（default branch 無し）と、org 外の topic 行・G-2 (b) の fork 行（取得対象外）。`isVerified`: anthropics = true（websiteUrl https://anthropic.com）、agentskills = true（https://agentskills.io）、anthropic-experimental = false（websiteUrl https://anthropic.com）
- **pinnedItems / profile README（R2）**: 3 org とも `pinnedItems(types:REPOSITORY)` は 0 件（固定なし）。org ページの "Popular repositories" は自動表示。別表 2
- **G-2 (a)**: fork 25 件すべての parent を取得し、親リポジトリの default branch と fork の default branch を compare。`ahead_by > 0` は 8 件（github-mcp-server 7、orjson 19、tokio 36、beam 12、httpcore 8、python-tblib 7、apitools 2、torchtyping 1）、`identical` は 3 件、残りは behind。github-mcp-server のみ境界語 mcp のため boundary のまま（status は candidate に更新）。他は範囲語に当たらず out（excluded）。注意: 比較は default branch 同士で、別名 branch（xls の Anthropic 変更は別 branch など）の差分は見ていない
- **G-2 (b)**: in の L1 リポジトリ 10 件それぞれの `forks?sort=stargazers&per_page=10`（100 fork を JSONL に excluded で記録）。fork 側が親より stars が多く pushed_at も新しいもの（移管の可能性）は **0 件**。別表 3b
- **G-8**: `orgs/anthropics/public_members` は **0 件**（org ページの表記と一致）
- **G-9**: `search/users?q=anthropic+type:org`（total 91、全件取得）と `q=claude+type:org`（total 1,571、先頭 300 件のみ取得）を実行。**agentskills はどちらにも出なかった**（sanity test の結果は変わらず。理由は別表 1）。候補 400 org（検索 300+91 の重複除去後 + 初回の owner 17 + agentskills）に `orgs/{org}` を実行（394 件取得、6 件は 404）。L1 条件（is_verified かつ blog / company が Anthropic のドメイン）を満たすのは **anthropics のみ**。is_verified=true は 23 件だが、anthropics と agentskills 以外は各社自身のドメイン。別表 1
- **G-12**: in の L1 リポジトリ 10 件 + agentskills/agentskills の tags / releases / branches を `--paginate` で全件取得。`{plugin}--v{version}` 形式の tag / release は **0 件**。org の Packages は **403（"You need at least read:packages scope"）**。権限スコープ不足として記録し、`gh auth refresh` 等では回避していない。別表 4
- **G-7**: 10 topic の 51〜100 位（`page=2`、org 外 418 件が新規）を追加。org 内の独立した突き合わせ（`topic:<t> org:<org>`、anthropics と agentskills の 10 topic ずつ）は G-1 の topics と一致（claude-plugins-official = claude-code、skills = agent-skills、agentskills/agentskills = agent-skills の 3 件のみ）。`search/topics?q=claude-code` は total 90。関連 topic の追加候補（未実行）: claude-code-skill、claude-code-mod、claude-code-mods、claude-code-plugins-marketplace、claude-code-subagents、claude-code-agents、claude-code-commands、claude-code-sdk、claude-code-hook
- **rate_limit**: 追加走査の開始時 core 5000 / graphql 4993 / search 30。gh API 約 540 回（20 回ごとに記録、`rate_log.txt`）のあいだ core は 5000、graphql は 4993、search は 30 のまま変化しなかった（rate_limit の表示が追従していない可能性。未検証）。終了時: core 5000/5000, graphql 4989/5000, search 30/30 (2026-10-13 終了時点)。ツール呼び出し数は初回約 85 回 + 追加走査約 21 回

### JSONL の読み方と、追加走査後も残る未走査

- org 行（`kind=source`）は `gh` が null。G-4 / G-5 / G-11 の対象は `kind=="asset"` かつ `channel` に G-1 を含み、`scope_verdict` が in / boundary の行（G-2 (b) の fork 行と G-7 の org 外の行は G-1 を含まないので対象外）
- **未走査（追加走査後も残る）**: Packages（403: read:packages スコープ無し）、`claude+type:org` の 301 件目以降（1,271 件）、G-7 の各 topic の 101 位以降（total は別表 3）、G-2 (a) の default branch 以外の差分、boundary 21 件の tags / Releases / branches（G-12 の対象は in のみ）、README 冒頭の目視、org 外リポジトリの tree_sha、anthropic-experimental の L1 判定（blog の自己申告のみ。L1 の既知ページからのリンクを確認できる別担当か Fable に依頼）

## 別表 1: G-9 の候補 org と判定（sanity test の結果を含む）

**sanity test（R6）**: G-9 のクエリだけで `agentskills` は**候補に出なかった**（初回の repo 検索 77 owner、追加走査の `search/users` 2 本の 391 件のいずれにも無い）。`search/users` は login / name / description 等への語の一致で、agentskills の org 名・説明（"A simple, open format for giving agents new capabilities and expertise."）は anthropic / claude を含まない。手続きの欠陥の証拠として残す（org 名・説明に語が無い org は発見できない）。agentskills は計画書の既知 org として G-1 に seed した

| org | 判定 | is_verified | blog / company | public_repos | 備考 |
|---|---|---|---|---|---|
| anthropics | **L1**（確定） | True | https://anthropic.com / — | 115 | GraphQL / REST とも Verified、blog = anthropic.com |
| agentskills | L2（候補） | True | https://agentskills.io / — | 2 | Verified（agentskills.io）。.github の README が「maintained by Anthropic」。L1 からのリンクは未確認。search/users に不出現 |
| anthropic-experimental | 未検証（unverified） | False | https://anthropic.com / — | 2 | blog は anthropic.com を指すが未 Verified で自己申告のみ。L1 からのリンク有無を要確認。リポジトリ 2 件はモデルの安全性研究 |
| AnthropicAI | 対象外（類似名・ドメイン言及） | False | — / — | 0 | 名前が類似、または blog が Anthropic ドメインを指すが L1 条件を満たさない。成りすましまたは無関係の可能性（未評価） |
| Antrophics | 対象外（類似名・ドメイン言及） | True | https://neochess.ru / — | 2 | 名前が類似、または blog が Anthropic ドメインを指すが L1 条件を満たさない。成りすましまたは無関係の可能性（未評価） |
| AnthropicsTechnology | 対象外（類似名・ドメイン言及） | True | www.anthropics.com / — | 0 | 名前が類似、または blog が Anthropic ドメインを指すが L1 条件を満たさない。成りすましまたは無関係の可能性（未評価） |
| usecorgi | 対象外（類似名・ドメイン言及） | False | https://www.anthropic.com/ / — | 0 | 名前が類似、または blog が Anthropic ドメインを指すが L1 条件を満たさない。成りすましまたは無関係の可能性（未評価） |
| Anti-Anthropic | 対象外（類似名・ドメイン言及） | False | https://anti-anthropic.com / — | 0 | 名前が類似、または blog が Anthropic ドメインを指すが L1 条件を満たさない。成りすましまたは無関係の可能性（未評価） |
| modmyclaude | 対象外（類似名・ドメイン言及） | False | https://modmyclaude.com / — | 1 | 名前が類似、または blog が Anthropic ドメインを指すが L1 条件を満たさない。成りすましまたは無関係の可能性（未評価） |
| （is_verified=true の第三者 19 件）| 対象外 | true | 各社固有のドメイン | — | apimodels, stdapi-ai, LM-Client, windsor-ai, mnemoverse, Forkoff-app, Insightful-Pipe, MarkdownLM, SkillMedev, claude-mind, sqlew-io, ofmapi, ex-machina-co, aws-samples, xemantic, ComposioHQ, VoltAgent, Piebald-AI, zenstory-ai |
| （404 の 6 件）| 未確認 | — | — | — | anthropic-streamlit, NexGerCore, user-04, llm-anarchy, COO-LLM, Claude-Code-Skill |
| （その他 366 件）| 対象外 | false | — | — | JSONL に 1 行ずつ。L1 条件を満たさない |

## 別表 2: E4 用: org の pinnedItems と profile README の項目

| org | pinnedItems（GraphQL `pinnedItems(first:6, types:REPOSITORY)`） | profile README | 項目 |
|---|---|---|---|
| anthropics | **0 件（固定なし）**。org ページの "Popular repositories"（skills / claude-code / claude-cookbooks / financial-services / prompt-eng-interactive-tutorial / claude-plugins-official）はスター上位 6 件と一致する自動表示 | `anthropics/.github` は公開 115 件に無く、`profile/README.md` と `README.md` は 404。org の description も空 | 上記 6 リポジトリ名のみ（固定ではない）。website は https://anthropic.com |
| agentskills | 0 件 | あり（agentskills/.github `profile/README.md`、blob 77ab19db70e1a5e245cc449c38eb87a2b47e5270、853 bytes） | https://agentskills.io（Documentation）、https://agentskills.io/specification（Specification）、https://github.com/anthropics/skills（Example Skills）、https://github.com/agentskills/agentskills、「maintained by Anthropic（https://anthropic.com）」。org description: "A simple, open format for giving agents new capabilities and expertise." |
| anthropic-experimental | 0 件 | `.github` リポジトリ無し（公開 2 件のみ） | — |

## 別表 3: 100 スター以上の L3 候補（G-2 (b)、G-7 org 外）

G-2 (b) の 100 fork は 100 スター以上のものが無く、G-7 のみ（別表 3b）。**権威は未確認**（Anthropic の org / Marketplace への掲載を確認していない）で、挙動・形式の根拠には使わない。各 topic の total_count / 上位 100 の下限スター / 上位 100 のうち 100 スター以上の件数: claude-code 89,667 / 11.7k / 100; claude-code-plugin 9,659 / 282 / 100; claude-code-plugins 722 / 11 / 33; claude-plugins 296 / 2 / 8; claude-plugin 2,656 / 35 / 59; agent-skills 31,469 / 3.5k / 100; claude-skills 10,824 / 1.1k / 100; claude-code-skills 2,121 / 132 / 100; claude-code-hooks 614 / 6 / 26; claude-code-marketplace 473 / 3 / 12。org 外のユニーク 814 件のうち 100 スター以上は 480 件（全件は JSONL の status=excluded）。リンク元はいずれも `https://github.com/<owner>/<repo>` の topic 検索結果。スター降順（k = 千）

| スター降順 | | | | | | | |
|---|---|---|---|---|---|---|---|
| affaan-m/ECC (277.7k) | NousResearch/hermes-agent (253.0k) | DietrichGebert/ponytail (161.7k) | farion1231/cc-switch (143.3k) | morluto/rea (142.2k) | nextlevelbuilder/ui-ux-pro-max-skill (135.1k) | Graphify-Labs/graphify (125.8k) | JuliusBrussee/caveman (111.2k) |
| addyosmani/agent-skills (105.4k) | paperclipai/paperclip (100.8k) | nexu-io/open-design (100.7k) | thedotmack/claude-mem (100.0k) | Panniantong/Agent-Reach (96.5k) | Leonxlnx/taste-skill (95.0k) | stablyai/orca (90.5k) | Egonex-AI/Understand-Anything (86.0k) |
| rtk-ai/rtk (83.1k) | tt-a1i/archify (82.5k) | shareAI-lab/learn-claude-code (78.4k) | ComposioHQ/awesome-claude-skills (76.9k) | diegosouzapw/OmniRoute (75.6k) | headroomlabs-ai/headroom (75.1k) | career-ops-hq/career-ops (74.2k) | code-yeongyu/oh-my-openagent (70.0k) |
| asgeirtj/system_prompts_leaks (69.5k) | shanraisshan/claude-code-best-practice (67.4k) | gsd-build/get-shit-done (64.3k) | mvanhorn/last30days-skill (64.1k) | ayghri/i-have-adhd (56.6k) | blader/humanizer (56.1k) | hesreallyhim/awesome-claude-code (55.5k) | router-for-me/CLIProxyAPI (54.9k) |
| coreyhaines31/marketingskills (54.3k) | VoltAgent/awesome-openclaw-skills (53.1k) | CherryHQ/cherry-studio (52.6k) | cathrynlavery/diagram-design (52.1k) | Imbad0202/academic-research-skills (51.5k) | K-Dense-AI/scientific-agent-skills (48.5k) | jeecgboot/JeecgBoot (48.2k) | sickn33/agentic-awesome-skills (47.5k) |
| zhayujie/CowAgent (47.4k) | alibaba/open-code-review (46.4k) | DeusData/codebase-memory-mcp (46.4k) | MadsLorentzen/ai-job-search (46.3k) | reactive-resume/reactive-resume (44.2k) | Wei-Shaw/sub2api (43.8k) | herdrdev/herdr (43.6k) | chatboxai/chatbox (42.0k) |
| luongnv89/claude-howto (41.8k) | wshobson/agents (40.5k) | github/awesome-copilot (40.0k) | Yeachan-Heo/oh-my-claudecode (39.8k) | JCodesMore/ai-website-cloner-template (36.6k) | VoltAgent/awesome-agent-skills (35.6k) | virgiliojr94/book-to-skill (34.6k) | mukul975/Anthropic-Cybersecurity-Skills (34.3k) |
| iOfficeAI/AionUi (33.5k) | davila7/claude-code-templates (32.6k) | topoteretes/cognee (32.1k) | tirth8205/code-review-graph (32.1k) | feder-cr/invisible_dots (32.0k) | iOfficeAI/OfficeCLI (31.9k) | googleworkspace/cli (31.4k) | nanocoai/nanoclaw (30.9k) |
| decolua/9router (30.7k) | zarazhangrui/frontend-slides (30.5k) | oraios/serena (30.2k) | jarrodwatts/claude-hud (28.5k) | manaflow-ai/cmux (28.1k) | alirezarezvani/claude-skills (28.1k) | gastownhall/beads (27.8k) | op7418/guizang-ppt-skill (27.7k) |
| OthmanAdi/planning-with-files (27.4k) | mksglu/context-mode (27.0k) | phuryn/pm-skills (26.9k) | onlook-dev/onlook (26.9k) | JimLiu/baoyu-skills (26.6k) | Donchitos/Claude-Code-Game-Studios (26.2k) | titanwings/distilly (25.5k) | pascalorg/editor (24.8k) |
| slopus/happy (24.1k) | winfunc/opcode (22.4k) | steipete/CodexBar (22.4k) | KKKKhazix/khazix-skills (21.3k) | jnMetaCode/agency-agents-zh (21.2k) | liyupi/ai-guide (21.0k) | getpaseo/paseo (20.6k) | NVIDIA/SkillSpector (20.0k) |
| teng-lin/notebooklm-py (19.7k) | AgriciDaniel/claude-seo (18.8k) | microsoft/SkillOpt (18.3k) | rowboatlabs/rowboat (18.0k) | img2threejs/img2threejs (18.0k) | tradecatlabs/vibe-coding-cn (17.5k) | wanshuiyin/Auto-claude-code-research-in-sleep (17.3k) | lidge-jun/opencodex (17.3k) |
| citrolabs/ego-lite (17.2k) | MemoriLabs/Memori (17.1k) | kubesphere/kubesphere (17.1k) | xbtlin/ai-berkshire (16.7k) | alibaba/zvec (16.1k) | YishenTu/claudian (15.6k) | eigent-ai/eigent (15.5k) | AgriciDaniel/claude-obsidian (15.5k) |
| latent-spaces/brag (15.4k) | travisvn/awesome-claude-skills (15.4k) | yusufkaraaslan/Skill_Seekers (15.1k) | superset-sh/superset (15.1k) | NanmiCoder/cc-haha (15.0k) | kyegomez/OpenMythos (14.9k) | NevaMind-AI/memU (14.5k) | nidhinjs/prompt-master (14.4k) |
| siteboon/claudecodeui (14.0k) | Orchestra-Research/AI-Research-SKILLs (13.5k) | sirmalloc/ccstatusline (13.3k) | OrchestratorInc/agent-orchestrator (13.1k) | Piebald-AI/claude-code-system-prompts (12.9k) | krillinai/OpenCreator (12.8k) | Wei-Shaw/claude-relay-service (12.7k) | zilliztech/claude-context (12.6k) |
| Jeffallan/claude-skills (11.8k) | humanlayer/humanlayer (11.7k) | yizhiyanhua-ai/fireworks-tech-graph (11.7k) | Vincentwei1021/video-shotcraft (11.5k) | aden-hive/hive (11.1k) | tigerless-labs/autoharness (11.0k) | Agents365-ai/drawio-skill (10.1k) | AgriciDaniel/claude-ads (9.9k) |
| revfactory/harness (9.2k) | nexu-io/html-anything (9.1k) | jnMetaCode/superpowers-zh (8.3k) | xixu-me/xget (8.2k) | YaoApp/yao (8.1k) | anbeime/skill (7.9k) | Gentleman-Programming/gentle-ai (7.7k) | WenyuChiou/awesome-agentic-ai-zh (7.5k) |
| refly-ai/refly (7.5k) | trailofbits/skills (7.5k) | zenstory-ai/oh-story-claudecode (7.5k) | SnailSploit/Claude-Red (7.4k) | deanpeters/Product-Manager-Skills (7.3k) | mvschwarz/openrig (7.2k) | rehan-remade/universal-modder (7.0k) | Devin-AXIS/iPolloWork (6.9k) |
| ningzimu/codex-ppt-skill (6.8k) | internet-court/internet-court-skill (6.7k) | htmlstreamofficial/preline (6.5k) | gosom/google-maps-scraper (6.4k) | ThinkInAIXYZ/deepchat (6.4k) | heilcheng/awesome-agent-skills (6.3k) | ikaijua/Awesome-AITools (6.2k) | browser-act/skills (6.1k) |
| larashero3-dotcom/lieflat-charts (6.1k) | antfu/skills (6.0k) | epoko77-ai/im-not-ai (6.0k) | miqdadbadjuber/anti-slop (5.9k) | 0xNyk/awesome-hermes-agent (5.8k) | OpenSenseNova/SenseNova-Skills (5.8k) | wuyoscar/GPT-Image2-Skill (5.7k) | dotnet/skills (5.6k) |
| aipoch/open-science (5.5k) | dmmulroy/anti-slop (5.5k) | breaking-brake/cc-wf-studio (5.4k) | metalbear-co/mirrord (5.4k) | tinyplex/tinybase (5.2k) | Ryze-AI-Adgent/open-seo-mcp-skills (5.1k) | elementalsouls/Claude-BugHunter (5.0k) | eugeniughelbur/obsidian-second-brain (4.7k) |
| xixu-me/awesome-persona-distill-skills (4.7k) | zebbern/claude-code-guide (4.7k) | brycewang-stanford/Auto-Empirical-Research-Skills (4.6k) | sergebulaev/linkedin-skills (4.6k) | xianyu110/awesome-openclaw-tutorial (4.6k) | inkeep/open-knowledge (4.5k) | 0x0funky/agent-sprite-forge (4.4k) | irinabuht12-oss/marketing-skills (4.3k) |
| JimLiu/baoyu-design (4.3k) | Manavarya09/design-extract (4.2k) | liustack/modlens (4.2k) | microsoft/skill-recorder (4.2k) | nyldn/claude-octopus (4.2k) | muxuuu/serenity-skill (4.1k) | KKKKhazix/human-writing (4.0k) | parcadei/Continuous-Claude-v3 (3.9k) |
| evalstate/fast-agent (3.9k) | nowork-studio/notfair-plugin (3.9k) | zenbu-labs/terminal-browser (3.8k) | glitternetwork/pinme (3.8k) | gotalab/cc-sdd (3.7k) | geekjourneyx/md2wechat-skill (3.7k) | foryourhealth111-pixel/Vibe-Skills (3.7k) | davepoon/buildwithclaude (3.6k) |
| plannotator/effective-html (3.6k) | NVIDIA/skills (3.6k) | Ar9av/obsidian-wiki (3.6k) | ScrapeCreators/social-media-research-skills (3.5k) | jangviktor-web/nihaixia (3.5k) | agenticnotetaking/arscontexta (3.5k) | samber/cc-skills-golang (3.5k) | ljagiello/ctf-skills (3.4k) |
| codeaashu/claude-code (3.4k) | wesammustafa/Claude-Code-Everything-You-Need-to-Know (3.3k) | rebelytics/one-skill-to-rule-them-all (3.3k) | nateherkai/scroll-craft (3.2k) | QingYunA/answer-me-with-html (3.1k) | ciembor/agent-rules-books (3.0k) | addyosmani/web-quality-skills (2.9k) | rohitg00/pro-workflow (2.9k) |
| Natively-AI-assistant/natively-cluely-ai-assistant (2.9k) | kaankiziltug/logo-design-skill (2.8k) | jeremylongshore/tons-of-skills-marketplace (2.8k) | zenstory-ai/drama-skills (2.8k) | feder-cr/invisible_playwright_mcp (2.8k) | zilliztech/memsearch (2.7k) | oil-oil/oil-motion (2.6k) | Appllama/appllama-skills (2.6k) |
| alexgreensh/token-optimizer (2.5k) | romainsimon/paperasse (2.5k) | antonbabenko/terraform-skill (2.4k) | wondelai/skills (2.4k) | AgriciDaniel/claude-blog (2.4k) | amElnagdy/delegate-skills (2.4k) | Weizhena/Deep-Research-skills (2.3k) | JuneYaooo/nihaisha-nishi-tcm (2.2k) |
| Jakeschincariol/replica-skill (2.1k) | lemomo-ai/lemo-opuscar (2.0k) | cbrock84/headcount (2.0k) | zanwei/design-dna (2.0k) | composio-community/awesome-claude-plugins (1.9k) | coldteadotai/pr-lens (1.9k) | Jakeschincariol/linkedin-agent-skill (1.9k) | timescale/pg-aiguide (1.9k) |
| XiaoMaColtAI/math-modeling-skill (1.9k) | michael-denyer/pstack-claude (1.9k) | oil-oil/beautify-github-readme (1.9k) | filtalgo/Filtmall-Shopping-Skill (1.9k) | a5c-ai/babysitter (1.8k) | Prat011/awesome-llm-skills (1.8k) | BayramAnnakov/claude-reflect (1.8k) | mex-memory/mex (1.8k) |
| AMAP-ML/LongHorizon-Harness (1.7k) | Klotzkette/claude-fuer-deutsches-recht (1.7k) | feiskyer/claude-code-settings (1.7k) | pedrohcgs/claude-code-my-workflow (1.7k) | activeloopai/hivemind (1.6k) | Kaelio/ktx (1.6k) | kenryu42/cc-safety-net (1.6k) | plugin87/ux-ui-agent-skills (1.6k) |
| eatmoreduck/boss-zhipin-scraper (1.6k) | hyhmrright/brooks-lint (1.5k) | nagisanzenin/engram (1.4k) | mohitagw15856/pm-claude-skills (1.4k) | alexgreensh/attention-span (1.4k) | quemsah/awesome-claude-plugins (1.4k) | hesamsheikh/octogent (1.4k) | snflkd/fluent-korean (1.4k) |
| Mahanaicoach/google-maps-scraper-kit (1.4k) | alookai/alook (1.4k) | jordanrendric/claude-video-vision (1.4k) | oil-oil/oil-ui (1.4k) | JuneYaooo/gpt-image2-ppt-skills (1.4k) | specstoryai/getspecstory (1.4k) | bevibing/tutor-skills (1.3k) | OpenRaiser/NanoResearch (1.3k) |
| Shanyin-ai/shanyin-screenwriting-master (1.3k) | minsight-ai-info/AI-Search-Hub (1.3k) | kharmanskyi/open-steps (1.3k) | conorluddy/ios-simulator-skill (1.3k) | gooseworks-ai/goose-skills (1.2k) | reticlehq/reticle (1.2k) | ferdinandobons/startup-skill (1.2k) | vshulcz/deja-vu (1.2k) |
| fcakyon/claude-codex-settings (1.2k) | Gabberflast/academic-pptx-skill (1.2k) | itsmostafa/aws-agent-skills (1.2k) | agentrq/agentrq (1.1k) | rohitg00/awesome-claude-design (1.1k) | huangjia2019/claude-code-engineering (1.1k) | nexscope-ai/eCommerce-Skills (1.1k) | hoangsonww/Claude-Code-Agent-Monitor (1.1k) |
| jezweb/claude-skills (1.1k) | agiwhitelist/auteur (1.0k) | jiweiyeah/Skills-Manager (1.0k) | microsoft/power-platform-skills (997) | ccplugins/awesome-claude-code-plugins (970) | SethGammon/Citadel (924) | alexgreensh/anidoodle (890) | renezander030/capcut-cli (876) |
| hex/claude-council (870) | indranilbanerjee/digital-marketing-pro (868) | zenstory-ai/novel-to-game (851) | keskinonur/claude-code-ios-dev-guide (844) | 23blocks-OS/ai-maestro (818) | artokun/comfyui-mcp (816) | taekchef/claude-code-zh-cn (794) | Ark0N/Codeman (788) |
| unbrowse-ai/unbrowse (784) | ReflexioAI/claude-smart (783) | kitfunso/hippo-memory (777) | divar-ir/ai-doc-gen (767) | raiyanyahya/recall (756) | decebals/claude-code-java (751) | mliu98/awesome-human-distillation (751) | keli-wen/agy-staff (738) |
| quant-sentiment-ai/claude-equity-research (729) | LukasNiessen/terrashark (715) | gmickel/flow-next (709) | shinpr/claude-code-workflows (694) | JayPokale/Chisle (653) | openqodex/openqodex (625) | nWave-ai/nWave (616) | minhnv0807/ai-business-skills (612) |
| coldteadotai/abide (578) | levnikolaevich/claude-code-skills (576) | emotixco/claude-skills-founder (576) | aannoo/hcom (567) | zenstory-ai/video-recap-skills (567) | rsmdt/the-startup (565) | oliver-kriska/claude-elixir-phoenix (565) | KimGLee/Cambium (565) |
| tzachbon/smart-ralph (559) | zscole/adversarial-spec (556) | vladikk/modularity (556) | shanraisshan/claude-code-hooks (555) | cth9191/animate (551) | bitwize-music-studio/claude-ai-music-skills (548) | karanb192/awesome-claude-skills (546) | Lifecycle-Innovations-Limited/claude-ops (543) |
| karanb192/claude-code-hooks (542) | posit-dev/skills (539) | Hainrixz/the-architect (538) | jqueryscript/awesome-claude-code (530) | karanb192/awesome-claude-code-mods (520) | VikashLoomba/copilot-mcp (506) | mxyhi/ok-skills (495) | umputun/cc-thingz (486) |
| josstei/maestro-orchestrate (465) | gcpdev/llm-council-skill (465) | AThevon/genjutsu (464) | malob/nix-config (463) | boshu2/agentops (448) | jabrena/plinth (448) | BrianRWagner/ai-marketing-claude-code-skills (443) | ilyautov/humanizer-ru (436) |
| zapier/zapier-mcp (433) | aerovato/operator-memory (430) | GRCEngClub/claude-grc-engineering (420) | prekuter/dryforge (417) | fcakyon/phd-skills (416) | scaccogatto/okf-skills (409) | nuwa-skills/awesome-nuwa (403) | syahiidkamil/Software-Engineer-AI-Agent-Atlas (401) |
| pegasi-ai/reins (392) | ombulabs/claude-code_rails-upgrade-skill (391) | hypnguyen1209/offensive-claude (389) | mcpware/cross-code-organizer (384) | Ibrahim-3d/orchestrator-supaconductor (381) | yuting0624/antigravity-for-claude-code (381) | haddock-development/claude-reflect-system (380) | jaechang-hits/SciAgent-Skills (376) |
| AlpacaLabsLLC/skills-for-architects (375) | CronusL-1141/AI-company (372) | spencermarx/open-code-review (371) | zxkane/aws-skills (366) | kazukinagata/shinkoku (365) | jarrodwatts/claude-stt (364) | giuseppe-trisciuoglio/developer-kit (357) | hi0001234d/nexpath (356) |
| aerovato/container (351) | athola/claude-night-market (341) | marketingjuliancongdanh79-pixel/skill-generator (338) | JayantDevkar/claude-code-karma (331) | InterfaceX-co-jp/genshijin (330) | kerlos/pordee (329) | codeaashu/free-claude-code (326) | sunchaokun/PPT-Design-Skill (324) |
| Adityaraj0421/naksha-studio (323) | gendigitalinc/sage (312) | modu-ai/moai-cowork (307) | rrezartprebreza/spring-boot-skills (305) | seyedehsanhadi/sloptrim (304) | referodesign/refero_skill (303) | danjdewhurst/story-skills (301) | nurettincoban/ai-prd-workflow (300) |
| yonatangross/orchestkit (292) | prime-radiant-inc/greenfield (292) | justxor/claude-code-pro-course (290) | Mertcikla/tld (290) | sevenevesai/riso-windowseat (289) | majiayu000/spellbook (287) | Arch1eSUN/Arcgentic (286) | JuneYaooo/social-account-doctor (286) |
| testdouble/han (282) | Eigenwise/eigenwise-toolshed (280) | akseolabs-seo/AK-Threads-booster (277) | billy-enrizky/openbrowser-ai (276) | baidu-netdisk/bdpan-storage (275) | sno-ai/sno-station-skills (266) | tamtom/play-console-cli (265) | gbessoni/seobuild-onpage (256) |
| testdriverai/testdriverai (243) | arvindrk/extract-design-system (242) | jeecgboot/skills (240) | firecrawl/firecrawl-claude-plugin (237) | Avijit07x/claude-db (233) | secondsky/claude-skills (229) | OdradekAI/bundles-forge (229) | serejaris/personal-corp-os (229) |
| ethanhq/cc-fleet (218) | Christian-Katzmann/app-it (216) | infinri/Writ (215) | y49/tlive (215) | gwittebolle/claude-carbon (211) | seb1n/awesome-ai-agent-skills (210) | hamzafer/claude-code-mods (206) | sandbaseai/sandbase-skills (203) |
| heardlabs/heard (202) | juanandresgs/claude-ctrl (193) | GaZmagik/iso-24495 (191) | CesiumGS/cesiumjs-skills (189) | conorluddy/xclaude-plugin (183) | hqhq1025/skill-optimizer (181) | mattgierhart/PRD-driven-context-engineering (181) | smnandre/symfony-ux-skills (180) |
| smixs/skill-conductor (179) | DoHyun468/claw-hwp (177) | study8677/Readme.skill (171) | Yusuke710/manim-skill (170) | pattern-ai-labs/agentcall (165) | acogood/diffmode_free (164) | seranking/seo-skills (163) | OneMoh/html-explainer (161) |
| wanshuiyin/Anti-Autoresearch (160) | JuneYaooo/xhs-writer-skill (159) | Frappucc1no/recall-loom (154) | Nyrok/flompt (152) | serpro69/claude-toolbox (151) | UiPath/coder_eval (151) | camilleroux/genart-skill (150) | aofp/yume (150) |
| arbiterForge/codeArbiter (147) | NickCirv/engram (142) | NikiforovAll/claude-code-rules (141) | kirilxd/claude-tutor (139) | ToluVictor/canvas-apps-tools (139) | dinglebear-ai/unraid (138) | thevibeworks/claude-code-docs (138) | DogInfantry/claude-skill-management-consultant-B1 (138) |
| Tapetide-hq/nse-bse-indian-stock-market-data-mcp (138) | aaddrick/building-with-typesafe-jev (138) | techwolf-ai/ai-first-toolkit (134) | wrsmith108/linear-claude-skill (134) | DojoCodingLabs/remotion-superpowers (133) | k1p1l0/claude-telegram-supercharged (133) | damionrashford/RivalSearchMCP (132) | video-db/pair-programmer (131) |
| quillai-network/quillshield_skills (130) | TAJD/economist-style-guide-plugin (127) | Bande-a-Bonnot/Boucle-framework (125) | rohanmistry231/Claude-OS (124) | neonwatty/job-apply-plugin (124) | Houseofmvps/ultraship (123) | AgentToolkit/altk-evolve (123) | qkal/Canny (122) |
| ghy196830-del/agent-watch-approve (122) | khendzel/skills-janitor (122) | Avinash-jetwani/jevmem (121) | bestagentkits/motion-video-skill (119) | Vitorlindo201/Themata-Claude-Scribe (118) | Abhi24384/Anthropic-Mythos-Desktop-Studio (116) | belialberu4-oss/exo-harness-ai-pipeline (116) | opslane/verify (115) |
| Ormus-Solutions/LibreUIUX-Claude-Code (115) | aufamubarak/plan-execute-verify-claude-code (115) | neo4j-contrib/neo4j-skills (114) | trentmcnitt/cc-notifier (112) | cpj-dev/dsh-plugin-cc (106) | usetig/sage (104) | Rich627/whatsapp-claude-plugin (104) | joetawil7/first-pass (100) |

### 別表 3b: G-2 (b) in の L1 リポジトリの上位 fork（親より活発な fork は 0 件）

| 親 | 親の stars / forks | 上位 fork（stars） |
|---|---|---|
| skills | 180.7k / 21.4k | Kastalien-Research/rooskills (17); yamato-snow/skills (13); user-91/skills (11) |
| claude-code | 150.4k / 26.3k | mattpocock/claude-code (33); bunjavascript/claude-code (29); hesreallyhim/claude-code-fork (28) |
| claude-plugins-official | 37.7k / 4.2k | Moekyawaung-Linux/claude-plugins-official (13); moekyawaung-graduate/claude-plugins-official (12); moekyawaung-designer/claude-plugins-official (7) |
| claude-plugins-community | 4.6k / 330 | user-86/claude-plugins-community (6); Balerion107/claude-plugins-community (2); Nix2828/NVH-CLAUDE-PLUGIN-COMMUNE (1) |
| claude-code-action | 9.5k / 2.2k | grll/claude-code-action (457); markwylde/claude-code-gitea-action (165); RealMikeChong/claude-code-for-gitlab (121) |
| claude-code-base-action | 1.0k / 605 | grll/claude-code-base-action (23); figma/claude-code-base-action (7); Shopify/claude-code-base-action (2) |
| claude-code-playground | 214 / 19 | bhatt-neel-dev/claude-code-playground (0); ChinmayaThakral/claude-code-playground (0); Rexvirgo-cyber/claude-code-playground (0) |
| life-sciences | 618 / 109 | A3IO/life-sciences (1); lucasbergada/life-sciences (0); muneerah83/life-sciences (0) |
| sandbox-runtime | 5.5k / 483 | microsoft/vscode-sandbox-runtime (27); Scottcjn/sandbox-runtime (25); user-09/sandbox-runtime (11) |
| devcontainer-features | 311 / 58 | ifabrish/devcontainer-features (1); MGuneid/devcontainer-features (1); tommylee88k-creator/devcontainer-features (1) |

## 別表 4: G-12 の tags / Releases / branches / Packages の件数

| リポジトリ（in） | tags | Releases | branches | tag 名の形式 | `{plugin}--v{version}` 規約 | 最新 tag |
|---|---|---|---|---|---|---|
| anthropics/skills | 0 | 0 | 16 | — | 0 件 | — |
| anthropics/claude-code | 245 | 241 | 216 | v{version} | 0 件 | v2.1.296 |
| anthropics/claude-plugins-official | 0 | 0 | 772 | — | 0 件 | — |
| anthropics/claude-plugins-community | 0 | 0 | 214 | — | 0 件 | — |
| anthropics/claude-code-action | 315 | 312 | 131 | v{version}、v0、beta | 0 件 | v1.0.248 |
| anthropics/claude-code-base-action | 63 | 63 | 20 | v{version}、beta | 0 件 | v0.0.63 |
| anthropics/claude-code-playground | 0 | 0 | 3 | — | 0 件 | — |
| anthropics/life-sciences | 3 | 2 | 24 | v{version} | 0 件 | v1.1.1 |
| anthropics/sandbox-runtime | 42 | 42 | 264 | v{version} | 0 件 | v0.0.79 |
| anthropics/devcontainer-features | 4 | 0 | 5 | feature_{name}_{version} | 0 件 | feature_claude-code_1.0.5 |
| agentskills/agentskills | 0 | 0 | 9 | — | 0 件 | — |

- Packages: `orgs/anthropics/packages?package_type=container` と `orgs/agentskills/...` はどちらも **403（read:packages スコープ不足）**。回避していない。ghcr.io の配布物の有無は未確認
- 観測した tag / release に `{plugin}--v{version}` 規約のものは無い。claude-plugins-official（772 branches）と claude-plugins-community（214 branches）は tags / Releases が 0 件で、版は branch / commit で管理されている（`add/<vendor>` 形式の PR branch が大量にある）。claude-code の最新 tag v2.1.296 は、この実行環境の `claude --version`（2.1.296）と一致

## 別表 5: claude-plugins-public の正体

| 項目 | 結果 | 取得方法 |
|---|---|---|
| 判定 | **rename（別リポジトリではない）**。`anthropics/claude-plugins-public` は `anthropics/claude-plugins-official` と同一リポジトリ | — |
| 根拠 1（計画書の手順） | `gh api repos/anthropics/claude-plugins-public` の応答が `full_name: anthropics/claude-plugins-official`、`id: 1100776768`（`repos/anthropics/claude-plugins-official` の id と同一）、HTTP 200（リダイレクトを辿った後） | gh api（2026-10-13） |
| 根拠 2 | `get_file_contents(anthropics, claude-plugins-public, .claude-plugin/marketplace.json)` の応答 url が `repos/anthropics/claude-plugins-official/...`（blob SHA 9c46c5ce7fa33648b1cf80955b100628cfc242c3） | mcp__github__get_file_contents |
| 根拠 3 | anthropics の公開 115 件（GraphQL totalCount）に `claude-plugins-public` は無く `claude-plugins-official` がある | GraphQL |
| 副次情報 | 当該 marketplace.json の plugins は 315 件（source が `./plugins/*` 39、`./external_plugins/*` 14、url 164、git-subdir 98）。別リポジトリを指す source（url / git-subdir）が 262 件あり、別担当が追う価値がある | marketplace.json を保存して集計 |
