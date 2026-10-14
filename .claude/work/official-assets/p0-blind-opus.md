作成: P0-C（Opus）、2026-10-13

# Claude Code Plugin の開発・テスト・配布で参照すべき公式資産（P0-C ブラインド走査）

- 全項目（除外を含む）は同じディレクトリの `p0-blind-opus.jsonl` にある。この表には status が candidate の行だけを載せる（範囲判定が「内」と「境界」の両方を含む）
- 「一次確認」の「索引」は、`https://code.claude.com/docs/llms.txt` を 2026-10-13 に取得して掲載を確認したもので、ページ本体は開いていない。「fetch」はページ本体を取得したもの
- docs の各 URL は末尾に `.md` を付けると Markdown 版を取得できる（llms.txt はその形で載せている）

## 候補一覧

| ID | 名称 | URL（最終 URL） | 種別・権威 | 権威の対象 | 活動と範囲判定 | 発見した場所 | 一次確認 |
|---|---|---|---|---|---|---|---|
| P0-C-001 | Claude Code Docs 索引 llms.txt | https://code.claude.com/docs/llms.txt | 情報源 / L1 | format, behavior, reference | 開発・テスト・配布 / 内 | 公式 docs サイトの索引を直接取得 | 2026-10-13 fetch |
| P0-C-002 | Plugins overview | https://code.claude.com/docs/en/plugins/overview | 情報源 / L1 | reference, behavior | 開発 / 内 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-003 | Create a Claude Code plugin | https://code.claude.com/docs/en/plugins/create | 情報源 / L1 | reference, behavior | 開発・テスト / 内 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-004 | Add components to a plugin | https://code.claude.com/docs/en/plugins/components | 情報源 / L1 | format, reference | 開発 / 内 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-005 | Plugin dependencies | https://code.claude.com/docs/en/plugins/dependencies | 情報源 / L1 | format, behavior | 開発・配布 / 内 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-006 | Test plugins with evals | https://code.claude.com/docs/en/plugin-evals | 情報源 / L1 | behavior, reference | テスト / 内 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-007 | Publish and distribute a plugin | https://code.claude.com/docs/en/plugins/publish | 情報源 / L1 | policy, behavior | 配布 / 内 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-008 | Measure plugin cost and usage | https://code.claude.com/docs/en/plugins/measure | 情報源 / L1 | behavior | テスト / 境界 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-009 | Recommend your plugin from your CLI | https://code.claude.com/docs/en/plugins/cli-hints | 情報源 / L1 | format, behavior | 配布 / 境界 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-010 | Create a marketplace | https://code.claude.com/docs/en/plugins/create-marketplace | 情報源 / L1 | format, behavior | 配布・テスト / 内 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-011 | Host and maintain a marketplace | https://code.claude.com/docs/en/plugins/host-marketplace | 情報源 / L1 | policy, behavior | 配布 / 内 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-012 | Recommend plugins for your org | https://code.claude.com/docs/en/plugins/relevance | 情報源 / L1 | format, behavior | 配布 / 境界 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-013 | Manage Claude Code plugins for your organization | https://code.claude.com/docs/en/plugins/org | 情報源 / L1 | policy, behavior | 配布 / 境界 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-014 | Troubleshoot plugins | https://code.claude.com/docs/en/plugins/troubleshooting | 情報源 / L1 | behavior | テスト / 内 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-015 | Plugin loading reference | https://code.claude.com/docs/en/plugins/loading | 情報源 / L1 | behavior | テスト・配布 / 内 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-016 | Plugin manifest reference | https://code.claude.com/docs/en/plugins/manifest-reference | 情報源 / L1 | format | 開発 / 内 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-017 | Marketplace reference | https://code.claude.com/docs/en/plugins/marketplace-reference | 情報源 / L1 | format, policy | 配布 / 内 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-018 | Plugin commands reference | https://code.claude.com/docs/en/plugins/cli-reference | 情報源 / L1 | behavior | 開発・テスト・配布 / 内 | llms.txt の Plugins 節 → 本体取得 | 2026-10-13 fetch（冒頭 9000 字） |
| P0-C-019 | Install and manage plugins | https://code.claude.com/docs/en/plugins/install | 情報源 / L1 | behavior | テスト・配布 / 内 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-020 | Anthropic's marketplaces | https://code.claude.com/docs/en/plugins/anthropic-marketplaces | 情報源 / L1 | reference, policy | 配布 / 内 | llms.txt の Plugins 節 → 本体取得 | 2026-10-13 fetch（全文） |
| P0-C-021 | Plugin security and trust | https://code.claude.com/docs/en/plugins/security | 情報源 / L1 | policy | 配布 / 境界 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-022 | Code intelligence plugins | https://code.claude.com/docs/en/plugins/code-intelligence | 情報源 / L1 | reference, behavior | 開発 / 境界 | llms.txt の Plugins 節 | 2026-10-13 索引 |
| P0-C-023 | Mods overview | https://code.claude.com/docs/en/plugins/mods/overview | 情報源 / L1 | reference, behavior | 開発 / 境界 | llms.txt の Plugins 節（Mods） | 2026-10-13 索引 |
| P0-C-024 | Create a mod | https://code.claude.com/docs/en/plugins/mods/create | 情報源 / L1 | reference | 開発・テスト / 境界 | llms.txt の Plugins 節（Mods） | 2026-10-13 索引 |
| P0-C-025 | Mods reference | https://code.claude.com/docs/en/plugins/mods/reference | 情報源 / L1 | format, behavior | 開発 / 境界 | llms.txt の Plugins 節（Mods） | 2026-10-13 索引 |
| P0-C-026 | Test a mod | https://code.claude.com/docs/en/plugins/mods/test | 情報源 / L1 | behavior, reference | テスト / 境界 | llms.txt の Plugins 節（Mods） | 2026-10-13 索引 |
| P0-C-027 | Troubleshoot a mod | https://code.claude.com/docs/en/plugins/mods/troubleshoot | 情報源 / L1 | behavior | テスト / 境界 | llms.txt の Plugins 節（Mods） | 2026-10-13 索引 |
| P0-C-028 | Mods 構築ページ群（interface / gallery / events / api） | https://code.claude.com/docs/en/plugins/mods/interface | 情報源 / L1 | reference, behavior | 開発 / 境界 | llms.txt の Plugins 節（Mods） | 2026-10-13 索引 |
| P0-C-029 | Manage mods for your organization | https://code.claude.com/docs/en/plugins/mods/admin | 情報源 / L1 | policy | 配布 / 境界 | llms.txt の Plugins 節（Mods） | 2026-10-13 索引 |
| P0-C-030 | Extend Claude with skills | https://code.claude.com/docs/en/skills | 情報源 / L1 | format, behavior | 開発 / 内 | llms.txt の Build 節 → 本体取得 | 2026-10-13 fetch（冒頭 6000 字） |
| P0-C-031 | Create custom subagents | https://code.claude.com/docs/en/sub-agents | 情報源 / L1 | format, behavior | 開発 / 内 | llms.txt の Build 節 | 2026-10-13 索引 |
| P0-C-032 | Hooks reference | https://code.claude.com/docs/en/hooks | 情報源 / L1 | format, behavior | 開発 / 内 | llms.txt の Reference 節 | 2026-10-13 索引 |
| P0-C-033 | Automate actions with hooks（ガイド） | https://code.claude.com/docs/en/hooks-guide | 情報源 / L1 | reference | 開発 / 境界 | llms.txt の Build 節 | 2026-10-13 索引 |
| P0-C-034 | Connect Claude Code to tools via MCP | https://code.claude.com/docs/en/mcp | 情報源 / L1 | behavior | 開発 / 境界 | llms.txt の Build 節 | 2026-10-13 索引 |
| P0-C-035 | Output styles | https://code.claude.com/docs/en/output-styles | 情報源 / L1 | format | 開発 / 境界 | llms.txt の Configuration 節 | 2026-10-13 索引 |
| P0-C-036 | All settings（settings reference） | https://code.claude.com/docs/en/settings-reference | 情報源 / L1 | behavior | テスト・配布 / 境界 | llms.txt の Configuration 節 | 2026-10-13 索引 |
| P0-C-037 | Environment variables | https://code.claude.com/docs/en/env-vars | 情報源 / L1 | behavior | 開発・テスト / 境界 | llms.txt の Reference 節 | 2026-10-13 索引 |
| P0-C-038 | CLI reference | https://code.claude.com/docs/en/cli-reference | 情報源 / L1 | behavior | テスト / 境界 | llms.txt の Reference 節 | 2026-10-13 索引 |
| P0-C-039 | Commands reference | https://code.claude.com/docs/en/commands | 情報源 / L1 | behavior | テスト / 境界 | llms.txt の Reference 節 | 2026-10-13 索引 |
| P0-C-040 | Debug your configuration | https://code.claude.com/docs/en/debug-your-config | 情報源 / L1 | behavior | テスト / 境界 | llms.txt の Build 節 | 2026-10-13 索引 |
| P0-C-041 | Extend Claude Code（features overview） | https://code.claude.com/docs/en/features-overview | 情報源 / L1 | reference | 開発 / 境界 | llms.txt の Getting started 節 | 2026-10-13 索引 |
| P0-C-042 | Explore the .claude directory | https://code.claude.com/docs/en/claude-directory | 情報源 / L1 | behavior | 開発 / 境界 | llms.txt の Getting started 節 | 2026-10-13 索引 |
| P0-C-043 | Claude Code changelog（docs） | https://code.claude.com/docs/en/changelog | 情報源 / L1 | changelog | 開発・テスト・配布 / 内 | llms.txt の Getting started 節 | 2026-10-13 索引 |
| P0-C-044 | What's new（週次ダイジェスト索引） | https://code.claude.com/docs/en/whats-new/index | 情報源 / L1 | changelog | 開発・テスト・配布 / 内 | llms.txt の What's New 節 | 2026-10-13 索引（最新 W37） |
| P0-C-045 | What's new W37（claude plugin eval） | https://code.claude.com/docs/en/whats-new/2026-w37 | 情報源 / L1 | changelog | テスト / 内 | llms.txt の What's New 節 | 2026-10-13 索引 |
| P0-C-046 | What's new W19（.zip・URL から Plugin 読み込み） | https://code.claude.com/docs/en/whats-new/2026-w19 | 情報源 / L1 | changelog | 配布 / 内 | llms.txt の What's New 節 | 2026-10-13 索引 |
| P0-C-047 | What's new W23（/plugin list、managed のバージョン範囲） | https://code.claude.com/docs/en/whats-new/2026-w23 | 情報源 / L1 | changelog | 配布・テスト / 内 | llms.txt の What's New 節 | 2026-10-13 索引 |
| P0-C-048 | What's new W14（Plugin の実行ファイルを PATH に） | https://code.claude.com/docs/en/whats-new/2026-w14 | 情報源 / L1 | changelog | 開発 / 内 | llms.txt の What's New 節 | 2026-10-13 索引 |
| P0-C-049 | What's new W17（Plugin でカラーテーマ配布） | https://code.claude.com/docs/en/whats-new/2026-w17 | 情報源 / L1 | changelog | 開発 / 境界 | llms.txt の What's New 節 | 2026-10-13 索引 |
| P0-C-050 | Claude Code GitHub Actions（docs） | https://code.claude.com/docs/en/github-actions | 情報源 / L1 | behavior | テスト / 境界 | llms.txt の Getting started 節（CI/CD） | 2026-10-13 索引 |
| P0-C-051 | Claude Code with GitHub Enterprise Server | https://code.claude.com/docs/en/github-enterprise-server | 情報源 / L1 | behavior | 配布 / 境界 | llms.txt の Getting started 節（CI/CD） | 2026-10-13 索引 |
| P0-C-052 | npm パッケージ @anthropic-ai/claude-code | https://registry.npmjs.org/@anthropic-ai/claude-code | 資産 / L1 | behavior | 開発・テスト・配布 / 内 | パッケージレジストリの @anthropic-ai スコープを直接取得 | 2026-10-13 v2.1.296 |
| P0-C-053 | claude plugin validate（組み込み） | https://code.claude.com/docs/en/plugins/cli-reference | 資産 / L1 | behavior, format | テスト・配布 / 内 | P0-C-018 の本文 | 2026-10-13 fetch（終了コード記述のみ） |
| P0-C-054 | claude plugin eval（組み込み） | https://code.claude.com/docs/en/plugin-evals | 資産 / L1 | behavior | テスト / 内 | llms.txt と P0-C-018 の本文 | 2026-10-13 fetch＋索引 |
| P0-C-055 | claude plugin init（組み込みの雛形生成） | https://code.claude.com/docs/en/plugins/cli-reference | 資産 / L1 | behavior, reference | 開発 / 内 | P0-C-018 の本文 | 2026-10-13 fetch |
| P0-C-056 | /plugin・/reload-plugins とセッション限定読み込みフラグ | https://code.claude.com/docs/en/plugins/cli-reference | 資産 / L1 | behavior | テスト / 内 | P0-C-018 の本文 | 2026-10-13 fetch（フラグ名は未確認） |
| P0-C-057 | anthropics/claude-plugins-official（公式 Marketplace） | https://github.com/anthropics/claude-plugins-official | 資産 / L1 | reference, format, policy | 開発・配布 / 内 | GitHub 組織検索、P0-C-020 のリンク | 2026-10-13 marketplace.json blob 9c46c5c |
| P0-C-058 | anthropics/claude-code の demo Marketplace（plugins/） | https://github.com/anthropics/claude-code/tree/main/plugins | 資産 / L1 | reference | 開発・配布 / 内 | GitHub 組織検索、P0-C-020 のリンク | 2026-10-13 README blob cf4a21e |
| P0-C-059 | plugin-dev（Plugin 開発支援 Plugin） | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/plugin-dev | 資産 / L1 | reference, format | 開発・テスト / 内 | 公式 marketplace.json、demo の plugins/ | 2026-10-13 blob 9c46c5c / tree b2a89d6 |
| P0-C-060 | skill-creator | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator | 資産 / L1 | reference | 開発・テスト / 内 | 公式 marketplace.json | 2026-10-13 blob 9c46c5c |
| P0-C-061 | hookify | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/hookify | 資産 / L1 | reference | 開発 / 境界 | 公式 marketplace.json、demo の plugins/ | 2026-10-13 blob 9c46c5c |
| P0-C-062 | LSP Plugin 群（*-lsp 12 件） | https://github.com/anthropics/claude-plugins-official/tree/main/plugins | 資産 / L1 | reference, format | 開発 / 境界 | 公式 marketplace.json | 2026-10-13 blob 9c46c5c |
| P0-C-063 | security-guidance | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/security-guidance | 資産 / L1 | reference | 開発・配布 / 境界 | 公式 marketplace.json、demo の plugins/ | 2026-10-13 v2.0.13 |
| P0-C-064 | その他の Anthropic 著作・汎用開発 Plugin | https://github.com/anthropics/claude-plugins-official/tree/main/plugins | 資産 / L1 | reference | 開発 / 境界 | 公式 marketplace.json、demo の plugins/ | 2026-10-13 blob 9c46c5c |
| P0-C-065 | anthropics/skills | https://github.com/anthropics/skills | 資産 / L1 | reference, format | 開発・配布 / 境界 | GitHub 組織検索、P0-C-020 の本文 | 2026-10-13 README blob eb54ee8 |
| P0-C-066 | anthropics/knowledge-work-plugins | https://github.com/anthropics/knowledge-work-plugins | 資産 / L1 | reference | 開発・配布 / 境界 | GitHub 組織検索、P0-C-020 の本文 | 2026-10-13 pushed_at 2026-10-12 |
| P0-C-067 | anthropics/claude-code-action | https://github.com/anthropics/claude-code-action | 資産 / L1 | behavior, reference | テスト / 境界 | GitHub 組織検索 → action.yml 取得 | 2026-10-13 action.yml（v1.0） |
| P0-C-068 | anthropics/devcontainer-features | https://github.com/anthropics/devcontainer-features | 資産 / L1 | reference | テスト / 境界 | GitHub 組織検索 | 2026-10-13 pushed_at 2025-12-16 |
| P0-C-069 | Agent Skills specification | https://agentskills.io/specification | 情報源 / L2 | format | 開発 / 内 | P0-C-030 の本文リンク（agentskills.io） | 2026-10-13 fetch（冒頭 2500 字） |
| P0-C-070 | agentskills/agentskills（仕様のリポジトリ） | https://github.com/agentskills/agentskills | 情報源 / L2 | format, changelog | 開発 / 内 | agentskills.io から組織検索 | 2026-10-13 pushed_at 2026-08-09 |
| P0-C-071 | ブログ: Customize Claude Code with plugins | https://claude.com/blog/claude-code-plugins | 情報源 / L1 | changelog, reference | 開発・配布 / 境界 | WebSearch（anthropic.com / claude.com 限定） | 2026-10-13 fetch（記事日付 2025-10-09） |

## 件数

| 列挙 | 採用 | 除外 | 未確認 | 境界 |
|---|---|---|---|---|
| 104 | 71 | 26 | 7 | 35 |

- 「採用」は status=candidate の件数で、採用判定ではない（採用は作業指示者が決める）
- 「境界」は candidate のうち範囲判定が boundary の件数（35）。candidate で範囲内は 36。未確認 7 件のうち 4 件も境界（P0-C-075〜078）
- 除外 26 件は JSONL にだけ載せた

### 未確認（unverified）の項目

- P0-C-072 `https://anthropic.com/claude-code/marketplace.schema.json`: 公式 marketplace.json の `$schema` が指す URL。2026-10-13 に取得すると HTTP 404
- P0-C-073 `claude plugin tag`: cli-reference の取得範囲（冒頭 9000 字）に記載がなく、存在と仕様は未確認
- P0-C-074 anthropics/claude-code の CHANGELOG.md: 取得していない
- P0-C-075 Anthropic Engineering「Equipping agents for the real world with Agent Skills」: WebSearch に出ただけ。P0-C-069 を L2 とする根拠（Anthropic 起草）の補強材料
- P0-C-076 claude.com/marketplace/plugins: L1 docs のリンクで存在を知ったが本体は取得していない
- P0-C-077 resources.anthropic.com の skill 作成ガイド PDF: WebSearch に出ただけ
- P0-C-078 anthropics/claude-code-playground: 説明文がなく用途不明

## 走査の記録

### 公式がどこに置くと考えたか

docs サイト（code.claude.com の llms.txt）、GitHub 組織 anthropics、npm スコープ @anthropic-ai、Marketplace カタログ（marketplace.json）、ブログ（claude.com / anthropic.com）、サポート記事（support.claude.com）、仕様サイト（L1 docs からの外部リンク先）、GitHub Action。

### 検索したクエリ

1. `mcp__github__search_repositories`: `org:anthropics claude-code OR plugin OR plugins OR skills`（23 件）
2. `mcp__github__search_repositories`: `org:agentskills`（2 件）
3. WebSearch: `Claude Code plugins announcement Anthropic blog marketplace`（ドメイン限定: anthropic.com, claude.com, support.claude.com）
4. WebSearch: `Anthropic Agent Skills open standard agentskills.io specification published`（ドメイン限定: anthropic.com, claude.com, agentskills.io）

### 取得した場所

- `https://code.claude.com/docs/llms.txt`（全文、2 回に分けて取得）
- `https://code.claude.com/docs/en/plugins/anthropic-marketplaces.md`（全文）
- `https://code.claude.com/docs/en/skills.md`（冒頭 6000 字）、`https://code.claude.com/docs/en/plugins/cli-reference.md`（冒頭 9000 字）
- `https://agentskills.io/specification`（冒頭 2500 字）、`https://claude.com/blog/claude-code-plugins`（冒頭 1500 字）
- `https://registry.npmjs.org/@anthropic-ai/claude-code/latest`（2.1.296）
- `https://anthropic.com/claude-code/marketplace.schema.json`（404）
- `https://raw.githubusercontent.com/anthropics/claude-code-action/main/action.yml`（冒頭 9000 字）
- GitHub contents: `anthropics/claude-plugins-official/.claude-plugin/marketplace.json`、`anthropics/claude-code/plugins`、`anthropics/skills` のルート

### 除外した理由の要約

Agent SDK とその docs 節・SDK / MCP 開発用 Plugin（範囲外）、MCP サーバー実装の仕様（Channels reference）、claude.ai / Cowork 側の skill・Plugin（サポート記事、claude.com/docs、Cowork 向けリポジトリ）、Anthropic directory への提出（submission portal のブログ、community Marketplace）、L3（公式カタログの第三者 Plugin 275 件。source の内訳は url 164、git-subdir 97、external_plugins 14）、ドメイン特化または Plugin と無関係の anthropics リポジトリ、ミラー（claude-code-base-action）。公式カタログの Anthropic 著作 40 件は、開発・テスト・配布に効くものを候補または境界に入れ、残りは 2 つの集約項目として除外した。

### 見られなかった場所・未走査

- Bash の `gh api orgs/anthropics/repos` は未認証で失敗した（「gh auth login」を求められた。権限拒否ではない）。MCP の GitHub ツールで代替したため、anthropics 組織のうち検索語（claude-code / plugin / plugins / skills）に掛からないリポジトリは見ていない
- MCP の結果が大きすぎてローカルの tool-results ファイルに退避された 2 件（組織検索と marketplace.json）は、自分の取得結果として `python -I` で要約した。入力ファイルは読んでいないが、Bash を gh 以外に使った点をここに記録する
- docs ページ本体の大半（索引の掲載確認だけ）。cli-reference の 9000 字以降（`claude plugin tag`、validate 節本体、セッション限定フラグの名前）
- 旧 docs URL（docs.anthropic.com/en/docs/claude-code/... や code.claude.com/docs/en/discover-plugins）からのリダイレクト。確認できないため、どの項目の aliases にも入れていない
- anthropics/claude-code の CHANGELOG.md・GitHub Releases・ルート一覧・examples、claude-plugins-official の README と各 Plugin 本体、anthropics/skills の .claude-plugin・spec・template の中身
- sitemap.xml と RSS（確認していないので watchable に sitemap・rss は付けていない）、言語別索引 `/_llms/jp.txt`
- @anthropic-ai スコープの他パッケージ、PyPI など他のレジストリ
- support.claude.com の Claude Code Plugin 向け記事（WebSearch で出なかった）、claude.com/marketplace/plugins 本体
- 第三者の JSON Schema（SchemaStore 等）と MCP 仕様サイトは L1 / L2 の範囲外なので見ていない
- GitHub の pushed_at は agentskills 以外、検索結果を日付に切り詰めて記録した。リポジトリ項目の「一次確認」は commit SHA ではなく、取得したファイルの blob / tree SHA か pushed_at
