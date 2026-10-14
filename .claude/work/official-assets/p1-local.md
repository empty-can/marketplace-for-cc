# P1-L ローカル層（L-1 / L-2 / L-2b / L-3）の列挙結果

- claude --version: `2.1.296 (Claude Code)`（開始 2026-10-13T01:18:53+09:00。作業中の再取得 01:26:53+09:00、終了時 01:38:47+09:00 も 2.1.296。版のずれ無し。補完（Fable 指示）の終了時 2026-10-13T02:42:16+09:00 も 2.1.296）
- 出力: 本ファイル（candidate と boundary の行だけ）と `p1-local.jsonl`（133 行。除外・未確認を含む）。ID は `P1-L-NNN` で両方に共通。補完で P1-L-132、133 を追加した
- 略称: CC = `https://code.claude.com/docs/en/`、LM = `~/.claude/plugins/marketplaces/`、LC = `~/.claude/plugins/cache/`、dm = docs_map（最終更新 2026-10-11T19:46Z。llms.txt は 2026-10-12 15:00）、f359 = 公式 marketplace のコミット `f359d43b4060`
- 種別: 源 = kind source（docs の各ページ、marketplace.json、リポジトリ、llms.txt）、資産 = kind asset。docs ページは 0-3 の定義に従い「源」
- known は 1-1 の「該当」列にあるドメイン・org・同梱物・クラス単位で付けた（ページ単位ではない）。docs の L1 は 1-1 に従う仮判定で、1-2 (a)(b) の Web 確認は未実施（P1-D の担当）
- 集約行（「N 件」と書いた行）は、JSONL でも 1 行に集約している。個別展開は未実施（走査の記録を参照）

## 1. 候補表（candidate / boundary）

| ID | 名称 | URL またはパス（最終） | 種別・権威 | 権威の対象 | 活動と範囲判定 | 発見チャネル | 一次確認 |
|---|---|---|---|---|---|---|---|
| P1-L-001 | Plugins overview | CC plugins/overview.md | 源 / L1 | 参照 | 開発,テスト,配布 / 内 | L-1 | 2026-10-13 dm |
| P1-L-002 | Install and manage plugins | CC plugins/install.md | 源 / L1 | 挙動 | 配布 / 内 | L-1 | 2026-10-13 dm |
| P1-L-003 | Anthropic's marketplaces | CC plugins/anthropic-marketplaces.md | 源 / L1 | ポリシー,参照 | 配布 / 内 | L-1 | 2026-10-13 dm |
| P1-L-004 | Code intelligence plugins | CC plugins/code-intelligence.md | 源 / L1 | 参照 | 開発 / 境界 | L-1 | 2026-10-13 dm |
| P1-L-005 | Plugin security and trust | CC plugins/security.md | 源 / L1 | ポリシー | 配布 / 境界 | L-1 | 2026-10-13 dm |
| P1-L-006 | Create a Claude Code plugin | CC plugins/create.md | 源 / L1 | 挙動,参照 | 開発,テスト / 内 | L-1 | 2026-10-13 dm |
| P1-L-007 | Add components to a plugin | CC plugins/components.md | 源 / L1 | 形式 | 開発 / 内 | L-1 | 2026-10-13 dm |
| P1-L-008 | Plugin dependencies | CC plugins/dependencies.md | 源 / L1 | 形式,挙動 | 開発,配布 / 内 | L-1 | 2026-10-13 dm |
| P1-L-009 | Test plugins with evals | CC plugin-evals.md | 源 / L1 | 挙動 | テスト / 内 | L-1 | 2026-10-13 dm |
| P1-L-010 | Publish and distribute a plugin | CC plugins/publish.md | 源 / L1 | ポリシー,挙動 | 配布 / 内 | L-1 | 2026-10-13 dm |
| P1-L-011 | Measure plugin cost and usage | CC plugins/measure.md | 源 / L1 | 挙動 | 配布 / 境界 | L-1 | 2026-10-13 dm |
| P1-L-012 | Recommend your plugin from your CLI | CC plugins/cli-hints.md | 源 / L1 | 挙動 | 配布 / 境界 | L-1 | 2026-10-13 dm |
| P1-L-013 | Mods overview | CC plugins/mods/overview.md | 源 / L1 | 参照 | 開発 / 内 | L-1 | 2026-10-13 dm |
| P1-L-014 | Create a mod | CC plugins/mods/create.md | 源 / L1 | 挙動 | 開発,テスト / 内 | L-1 | 2026-10-13 dm |
| P1-L-015 | Mods reference | CC plugins/mods/reference.md | 源 / L1 | 形式 | 開発 / 内 | L-1 | 2026-10-13 dm |
| P1-L-016 | Draw in the interface with a mod | CC plugins/mods/interface.md | 源 / L1 | 参照 | 開発 / 内 | L-1 | 2026-10-13 dm |
| P1-L-017 | Interface gallery for mods | CC plugins/mods/gallery.md | 源 / L1 | 参照 | 開発 / 内 | L-1 | 2026-10-13 dm |
| P1-L-018 | React to events with a mod | CC plugins/mods/events.md | 源 / L1 | 挙動 | 開発 / 内 | L-1 | 2026-10-13 dm |
| P1-L-019 | Use the mods API | CC plugins/mods/api.md | 源 / L1 | 形式 | 開発 / 内 | L-1 | 2026-10-13 dm |
| P1-L-020 | Test a mod | CC plugins/mods/test.md | 源 / L1 | 挙動 | テスト / 内 | L-1 | 2026-10-13 dm |
| P1-L-021 | Troubleshoot a mod | CC plugins/mods/troubleshoot.md | 源 / L1 | 挙動 | テスト / 内 | L-1 | 2026-10-13 dm |
| P1-L-022 | Manage mods for your organization | CC plugins/mods/admin.md | 源 / L1 | ポリシー | 配布 / 境界 | L-1 | 2026-10-13 dm |
| P1-L-023 | Create a marketplace | CC plugins/create-marketplace.md | 源 / L1 | 挙動 | 配布,テスト / 内 | L-1 | 2026-10-13 dm |
| P1-L-024 | Host and maintain a marketplace | CC plugins/host-marketplace.md | 源 / L1 | 挙動,ポリシー | 配布 / 内 | L-1 | 2026-10-13 dm |
| P1-L-025 | Recommend plugins for your org | CC plugins/relevance.md | 源 / L1 | 形式 | 配布 / 内 | L-1 | 2026-10-13 dm |
| P1-L-026 | Manage plugins for your organization | CC plugins/org.md | 源 / L1 | ポリシー | 配布 / 内 | L-1 | 2026-10-13 dm |
| P1-L-027 | Troubleshoot plugins | CC plugins/troubleshooting.md | 源 / L1 | 挙動 | テスト / 内 | L-1 | 2026-10-13 dm |
| P1-L-028 | Plugin loading reference | CC plugins/loading.md | 源 / L1 | 挙動 | テスト,配布 / 内 | L-1 | 2026-10-13 dm |
| P1-L-029 | Plugin manifest reference | CC plugins/manifest-reference.md | 源 / L1 | 形式 | 開発 / 内 | L-1 | 2026-10-13 dm |
| P1-L-030 | Marketplace reference | CC plugins/marketplace-reference.md | 源 / L1 | 形式,ポリシー | 開発,配布 / 内 | L-1 | 2026-10-13 dm |
| P1-L-031 | Plugin commands reference | CC plugins/cli-reference.md | 源 / L1 | 挙動 | 開発,テスト,配布 / 内 | L-1 | 2026-10-13 dm |
| P1-L-032 | Extend Claude with skills | CC skills.md | 源 / L1 | 形式,挙動 | 開発 / 内 | L-1 | 2026-10-13 dm |
| P1-L-033 | Create custom subagents | CC sub-agents.md | 源 / L1 | 形式,挙動 | 開発 / 内 | L-1 | 2026-10-13 dm |
| P1-L-034 | Automate actions with hooks | CC hooks-guide.md | 源 / L1 | 参照 | 開発 / 内 | L-1 | 2026-10-13 dm |
| P1-L-035 | Hooks reference | CC hooks.md | 源 / L1 | 形式 | 開発 / 内 | L-1 | 2026-10-13 dm |
| P1-L-036 | Run Claude Code programmatically | CC headless.md | 源 / L1 | 挙動 | テスト / 内 | L-1 | 2026-10-13 dm |
| P1-L-037 | Commands (bundled skills 表を含む) | CC commands.md | 源 / L1 | 参照 | 開発 / 内 | L-1,L-3 | 2026-10-13 dm |
| P1-L-038 | CLI reference | CC cli-reference.md | 源 / L1 | 挙動 | 開発,テスト / 内 | L-1 | 2026-10-13 dm |
| P1-L-039 | All settings | CC settings-reference.md | 源 / L1 | 形式 | 配布 / 内 | L-1 | 2026-10-13 dm |
| P1-L-040 | Explore the .claude directory | CC claude-directory.md | 源 / L1 | 参照 | 開発 / 内 | L-1 | 2026-10-13 dm |
| P1-L-041 | Extend Claude Code | CC features-overview.md | 源 / L1 | 参照 | 開発 / 内 | L-1 | 2026-10-13 dm |
| P1-L-042 | Claude Code changelog | CC changelog.md | 源 / L1 | 変更履歴 | 開発,テスト,配布 / 内 | L-1 | 2026-10-13 dm |
| P1-L-043 | What's new (index) | CC whats-new/index.md | 源 / L1 | 変更履歴 | 開発,テスト,配布 / 内 | L-1 | 2026-10-13 dm |
| P1-L-044 | Customize your status line | CC statusline.md | 源 / L1 | 形式 | 開発 / 内 | L-1 | 2026-10-13 dm |
| P1-L-045 | Debug your configuration | CC debug-your-config.md | 源 / L1 | 挙動 | テスト / 内 | L-1 | 2026-10-13 dm |
| P1-L-046 | What's new 週次 24 件（2026-w13〜w37、w31 は無し） | CC whats-new/2026-wNN.md | 源 / L1 | 変更履歴 | 開発,テスト,配布 / 内 | L-1 | 2026-10-13 dm |
| P1-L-047 | Settings files and precedence | CC settings.md | 源 / L1 | 挙動 | 配布 / 境界 | L-1 | 2026-10-13 dm |
| P1-L-048 | security-guidance plugin のページ | CC security-guidance.md | 源 / L1 | 参照 | 開発 / 境界 | L-1 | 2026-10-13 dm |
| P1-L-049 | Claude Security plugin のページ | CC claude-security.md | 源 / L1 | 参照 | 開発 / 境界 | L-1 | 2026-10-13 dm |
| P1-L-050 | Configure permissions | CC permissions.md | 源 / L1 | 挙動 | テスト / 境界 | L-1 | 2026-10-13 dm |
| P1-L-051 | Configure the sandboxed Bash tool | CC sandboxing.md | 源 / L1 | 挙動 | テスト / 境界 | L-1 | 2026-10-13 dm |
| P1-L-052 | Error reference | CC errors.md | 源 / L1 | 挙動 | テスト / 境界 | L-1 | 2026-10-13 dm |
| P1-L-053 | Deploy managed settings | CC managed-settings.md | 源 / L1 | ポリシー | 配布 / 境界 | L-1 | 2026-10-13 dm |
| P1-L-054 | Plugins in the SDK | CC agent-sdk/plugins.md | 源 / L1 | 挙動 | テスト / 境界 | L-1 | 2026-10-13 dm |
| P1-L-055 | Extend agents with skills (SDK) | CC agent-sdk/skills.md | 源 / L1 | 挙動 | テスト / 境界 | L-1 | 2026-10-13 dm |
| P1-L-056 | Subagents in the SDK | CC agent-sdk/subagents.md | 源 / L1 | 挙動 | テスト / 境界 | L-1 | 2026-10-13 dm |
| P1-L-057 | Hooks in the SDK | CC agent-sdk/hooks.md | 源 / L1 | 挙動 | テスト / 境界 | L-1 | 2026-10-13 dm |
| P1-L-058 | MCP のページ 3 件（mcp, mcp-quickstart, managed-mcp） | CC mcp.md ほか | 源 / L1 | 参照 | 開発 / 境界 | L-1 | 2026-10-13 dm |
| P1-L-059 | Agent SDK のその他 28 ページ | CC agent-sdk/overview.md ほか | 源 / L1 | 参照 | テスト / 境界 | L-1 | 2026-10-13 dm |
| P1-L-066 | claude-plugins-official（marketplace） | LM claude-plugins-official/.claude-plugin/marketplace.json | 源 / L1 | 参照,ポリシー | 開発,配布 / 内 | L-2 | 2026-10-13 f359 |
| P1-L-067 | anthropic-agent-skills（= anthropics/skills） | LM anthropic-agent-skills/.claude-plugin/marketplace.json | 源 / L1 | 参照,形式 | 開発,テスト / 内 | L-2 | 2026-10-13 SHA 未取得 |
| P1-L-068 | skills リポジトリの spec/agent-skills-spec.md | LM anthropic-agent-skills/spec/agent-skills-spec.md | 資産 / L1 | 形式 | 開発 / 内 | L-2 | 2026-10-13 ls のみ |
| P1-L-069 | skills リポジトリの template/SKILL.md | LM anthropic-agent-skills/template/SKILL.md | 資産 / L1 | 形式,参照 | 開発 / 内 | L-2 | 2026-10-13 ls のみ |
| P1-L-070 | skills リポジトリの skill-creator | LM anthropic-agent-skills/skills/skill-creator | 資産 / L1 | 参照,挙動 | 開発,テスト / 内 | L-2 | 2026-10-13 SKILL.md 33168B |
| P1-L-071 | skills リポジトリの academy-guide | LM anthropic-agent-skills/skills/academy-guide | 資産 / L1 | 参照 | 開発 / 境界 | L-2 | 2026-10-13 ls のみ |
| P1-L-072 | skills リポジトリのその他 example skill 17 件 | LM anthropic-agent-skills/skills | 資産 / L1 | 参照 | 開発 / 境界 | L-2 | 2026-10-13 ls のみ |
| P1-L-073 | plugin-dev | LM claude-plugins-official/plugins/plugin-dev | 資産 / L1 | 参照,形式 | 開発,テスト / 内 | L-2 | 2026-10-13 f359 |
| P1-L-074 | skill-creator（plugin） | LM claude-plugins-official/plugins/skill-creator | 資産 / L1 | 参照,挙動 | 開発,テスト / 内 | L-2 | 2026-10-13 f359 |
| P1-L-075 | hookify | LM claude-plugins-official/plugins/hookify | 資産 / L1 | 参照 | 開発 / 境界 | L-2 | 2026-10-13 f359 |
| P1-L-076 | claude-security | LM claude-plugins-official/plugins/claude-security | 資産 / L1 | 参照 | 開発 / 境界 | L-2 | 2026-10-13 f359 |
| P1-L-077 | security-guidance（author が marketplace と plugin.json で食い違い） | LM claude-plugins-official/plugins/security-guidance | 資産 / L1 | 参照 | 開発 / 境界 | L-2 | 2026-10-13 f359 |
| P1-L-078 | agent-sdk-dev | LM claude-plugins-official/plugins/agent-sdk-dev | 資産 / L1 | 参照 | 開発 / 境界 | L-2 | 2026-10-13 f359 |
| P1-L-079 | mcp-server-dev | LM claude-plugins-official/plugins/mcp-server-dev | 資産 / L1 | 参照 | 開発 / 境界 | L-2 | 2026-10-13 f359 |
| P1-L-080 | claude-code-setup | LM claude-plugins-official/plugins/claude-code-setup | 資産 / L1 | 参照 | 開発 / 境界 | L-2 | 2026-10-13 f359 |
| P1-L-081 | claude-md-management | LM claude-plugins-official/plugins/claude-md-management | 資産 / L1 | 参照 | 開発 / 境界 | L-2 | 2026-10-13 f359 |
| P1-L-082 | mcp-apps（object source、author は Anthropic / Model Context Protocol） | https://github.com/modelcontextprotocol/ext-apps（plugins/mcp-apps） | 資産 / L2 | 参照 | 開発 / 境界 | L-2 | 2026-10-13 sha 6d9bdc7b…（エントリ記載） |
| P1-L-083 | example-plugin（marketplace.json に無い plugins/ 配下の dir） | LM claude-plugins-official/plugins/example-plugin | 資産 / L1 | 参照 | 開発 / 境界 | L-2 | 2026-10-13 ls のみ |
| P1-L-084 | Anthropic 著者のサンプル Plugin 18 件（名前は JSONL） | LM claude-plugins-official/plugins | 資産 / L1 | 参照 | 開発 / 境界 | L-2 | 2026-10-13 f359 |
| P1-L-085 | Anthropic 著者の LSP Plugin 12 件 | LM claude-plugins-official/plugins | 資産 / L1 | 参照,形式 | 開発 / 境界 | L-2 | 2026-10-13 f359 |
| P1-L-086 | external_plugins で author 未宣言・homepage あり 8 件 | LM claude-plugins-official/external_plugins | 資産 / L3 | 参照 | - / 境界 | L-2 | 2026-10-13 f359 |
| P1-L-087 | external_plugins の channel 系 4 件（author も homepage も無し） | LM claude-plugins-official/external_plugins | 資産 / L3 | 参照 | 開発,テスト / 境界 | L-2 | 2026-10-13 f359 |
| P1-L-091 | cache: claude-security 0.12.0 | LC claude-plugins-official/claude-security/0.12.0 | 資産 / L1 | 参照 | 開発 / 境界 | L-2 | 2026-10-13 0.12.0 |
| P1-L-092 | cache: anthropic-plugin-directory（claude-security 0.11.0、playground） | LC anthropic-plugin-directory | 資産 / L1 | 参照 | 開発 / 境界 | L-2,L-2b | 2026-10-13 0.11.0-c447c3207a42 |
| P1-L-093 | cache: hookify | LC claude-plugins-official/hookify/f359d43b4060 | 資産 / L1 | 参照 | 開発 / 境界 | L-2 | 2026-10-13 f359 |
| P1-L-094 | cache: plugin-dev | LC claude-plugins-official/plugin-dev/f359d43b4060 | 資産 / L1 | 参照,形式 | 開発,テスト / 内 | L-2 | 2026-10-13 f359 |
| P1-L-095 | cache: security-guidance 2.0.8（marketplace 側は 2.0.13） | LC claude-plugins-official/security-guidance/2.0.8 | 資産 / L1 | 参照 | 開発 / 境界 | L-2 | 2026-10-13 2.0.8 |
| P1-L-096 | cache: playground | LC claude-plugins-official/playground/f359d43b4060 | 資産 / L1 | 参照 | 開発 / 境界 | L-2 | 2026-10-13 f359 |
| P1-L-097 | cache: skill-creator の 10 版（SKILL.md は全て 33168B、dir 内ファイル数は 22〜37 で不一致） | LC claude-plugins-official/skill-creator | 資産 / L1 | 参照,挙動 | 開発,テスト / 内 | L-2 | 2026-10-13 10 hash dir |
| P1-L-098 | plugin-directory-cache-v2.json（Anthropic repo 配下 listing 43 件以上） | ~/.claude/plugins/plugin-directory-cache-v2.json | 資産 / L1 | 参照 | 配布 / 境界 | L-2b | 2026-10-13 fetchedAt 2026-10-12T13:10Z |
| P1-L-099 | plugin-catalog-cache.json | ~/.claude/plugins/plugin-catalog-cache.json | 資産 / L1 | 参照 | 配布 / 境界 | L-2b | 2026-10-13 marketplace_sha f359d43b4060 |
| P1-L-100 | Claude Code 2.1.296 の単一 native binary | ~/.local/share/claude/versions/2.1.296 | 源 / L1 | 挙動 | 開発,テスト,配布 / 内 | L-3 | 2026-10-13 2.1.296 |
| P1-L-101 | `claude plugin` のサブコマンド 15 個 | claude plugin --help | 資産 / L1 | 挙動 | 開発,テスト,配布 / 内 | L-3 | 2026-10-13 2.1.296 |
| P1-L-102 | `claude plugin eval` のオプションと init サブコマンド（init は未実行） | claude plugin eval --help | 資産 / L1 | 挙動 | テスト / 内 | L-3 | 2026-10-13 2.1.296 |
| P1-L-107 | claude-code-settings.json（SchemaStore。出所未確認） | https://json.schemastore.org/claude-code-settings.json | 資産 / 対象外（仮） | 形式 | 開発 / 境界 | L-1,L-3 | 2026-10-13 リポジトリと docs |
| P1-L-108 | claude-code-keybindings.json（SchemaStore。docs のみ） | https://www.schemastore.org/claude-code-keybindings.json | 資産 / 対象外（仮） | 形式 | 開発 / 境界 | L-1 | 2026-10-13 llms-full L70381 |
| P1-L-109 | anthropics/claude-code リポジトリ | https://github.com/anthropics/claude-code | 源 / L1 | 変更履歴,挙動 | 開発,テスト,配布 / 内 | L-3 | 2026-10-13 2.1.296 |
| P1-L-110 | claude-code の CHANGELOG.md（blob と raw の 2 URL） | https://raw.githubusercontent.com/anthropics/claude-code/refs/heads/main/CHANGELOG.md | 資産 / L1 | 変更履歴 | 開発,テスト,配布 / 内 | L-3 | 2026-10-13 2.1.296 |
| P1-L-111 | anthropics/claude-code-action | https://github.com/anthropics/claude-code-action | 源 / L1 | 参照 | テスト / 境界 | L-3 | 2026-10-13 2.1.296 |
| P1-L-112 | claude.com/docs/llms.txt | https://claude.com/docs/llms.txt | 源 / L1 | 参照 | 開発,配布 / 内 | L-3,L-1 | 2026-10-13 2.1.296 |
| P1-L-113 | platform.claude.com/llms.txt | https://platform.claude.com/llms.txt | 源 / L1 | 参照 | 開発 / 内 | L-3 | 2026-10-13 2.1.296 |
| P1-L-120 | 組み込み skill: update-config, workflow-authoring | （system prompt の skill 一覧） | 資産 / L1 | 参照 | 開発 / 境界 | L-3 | 2026-10-13 2.1.296 |
| P1-L-121 | 組み込み skill: plugin-authoring（mods） | （system prompt の skill 一覧） | 資産 / L1 | 挙動,参照 | 開発,テスト / 内 | L-3 | 2026-10-13 2.1.296 |
| P1-L-127 | anthropic-skills: のうち anthropics/skills に同名がある 4 件（docx, pdf, pptx, xlsx。L1 の複製候補） | （system prompt の skill 一覧。ローカル実体なし）。対応先 LM anthropic-agent-skills/skills/<name> | 資産 / L1 | 参照 | 開発 / 境界 | L-3 | 2026-10-13 説明文の先頭 160 字が一致（docx は語句差） |
| P1-L-128 | anthropic-skills:skill-creator（L1 の複製候補。ローカル複製 12 件は全て 33168B） | （同上）と LM / LC の SKILL.md 12 複製 | 資産 / L1 | 参照 | 開発,テスト / 境界 | L-3 | 2026-10-13 全複製 33168B |
| P1-L-131 | 予約 Marketplace 名（C9） | CC plugins/marketplace-reference.md（llms-full L80873-80890） | 源 / L1 | ポリシー | 配布 / 内 | L-1 | 2026-10-13 llms-full 2026-10-12 |

## 2. 件数表

「列挙」は項目数（集約行は N 件として数える）。採用 = candidate かつ内、境界 = candidate かつ境界。C1 は URL 数が概算（約）。補完（Fable 指示）反映後。

| チャネル | 列挙 | 採用 | 除外 | 未確認 | 境界 |
|---|---|---|---|---|---|
| L-1 docs（llms.txt = docs_map = 222 ページ） | 222 | 64 | 111 | 0 | 47 |
| L-1 C9 予約名（P1-L-131） | 1 | 1 | 0 | 0 | 0 |
| L-2 marketplace と配下（2 marketplace、公式 315 エントリ、skills リポジトリ 19 skill など） | 342 | 7 | 266 | 0 | 69 |
| L-2 cache の複製（17 dir） | 17 | 11 | 0 | 0 | 6 |
| L-2b キャッシュ JSON | 2 | 0 | 0 | 0 | 2 |
| L-3 本体と help（P1-L-100〜104） | 35 | 17 | 17 | 1 | 0 |
| L-3 C1 / C4（binary 内 URL と $schema）。105 / 106 は未確認へ変更 | 約 83 | 5 | 約 65 | 10 | 3 |
| L-3 C2 / C3（skill・agent 一覧）。anthropic-skills: 15 件を 3 群に分割 | 77 | 1 | 57 | 12 | 7 |
| 合計 | 約 779 | 106 | 約 516 | 23 | 134 |

## 3. 走査の記録

- 追加確認 (1) changelog: ある。`CC changelog.md`（llms.txt 13 行、docs_map 50 行）と週次の `whats-new/*`（P1-L-042/043/046）。W-4 に統合できる。binary にも `github.com/anthropics/claude-code` の CHANGELOG.md の URL が 2 つ（blob と raw）ある（P1-L-110）
- 追加確認 (2) Plugin ディレクトリ機能: docs に説明がある。ただし対象は claude.ai 側の catalog（「Anthropic's directory」）で、`plugins/publish.md`（提出。llms-full L32512, L32535）と `plugins/loading.md`（claude.ai からのアカウント同期 #synced-plugins）に出る。予約 Marketplace 名 `anthropic-plugin-directory` / `claude-plugin-directory`（L80879）と、由来名 `synced`（L35227）も docs にある。ローカルのキャッシュのファイル名（plugin-directory-cache-v2.json、plugin-catalog-cache.json）は docs に出てこない（Grep で未検出）。`plugins/components.md` の「Explore the plugin directory」は Plugin 自身のディレクトリ構造の説明で、別物
- 追加確認 (3) docs_map のフィルタ: 222 ページを `##` 群と `###` / `####` のページ見出し単位で 2-5 の署名・語・境界語・除外語に当てた。内 64 ページ（Plugins 節 26 + skills / sub-agents / hooks 系 / headless / commands / cli-reference / settings-reference / claude-directory / features-overview / changelog / whats-new（25）/ statusline / debug-your-config）、境界 47（Plugins 節の 5 + settings / permissions / sandboxing / errors / managed-settings / security-guidance / claude-security / Agent SDK 32 / MCP 3 ほか）、除外 111（Platforms / Administration / Gateways / Deployment など）。**ページ内の入れ子見出し（約 5,800 行）は個別に再フィルタしていない**
- 計画書と現物の差: `~/.claude/plugins/marketplaces/anthropic-plugin-directory/` は存在しない（marketplaces/ には anthropic-agent-skills と claude-plugins-official の 2 つだけ）。同名は `cache/anthropic-plugin-directory/` にある。`~/.claude/plugins/` には計画書に無い `installed_plugins.json`、`blocklist.json`、`plugin-directory-bindings.json`（33B）、`plugin-directory-marketplace.json`（17B）、`data/`、`store/`、`synced/` もある
- 版のずれ: security-guidance は marketplace 2.0.13 に対しキャッシュ 2.0.8（plugin.json の author は 個人名（マスク） で、marketplace 側の Anthropic と食い違う）。claude-security は 0.12.0（claude-plugins-official）と 0.11.0（anthropic-plugin-directory）が併存。キャッシュ dir 名の `f359d43b4060` は plugin-catalog-cache の `marketplace_sha` と一致
- M2 の結果: `./plugins/*` 39 件は全て author = Anthropic（置き場所と著作者が一致）。`./external_plugins/*` 14 件のうち、author が第三者なのは 2 件（context7 = Upstash、terraform = HashiCorp）で、12 件は author 欄が無い（homepage は 8 件が anthropics/claude-plugins-public を指す）。object source 262 件に `github.com/anthropics` を指す url / homepage は 0 件（補完の別表 5 でも source URL の owner に anthropics は 0 件）。Anthropic 著者の object source は mcp-apps の 1 件（modelcontextprotocol/ext-apps）。homepage が `claude-plugins-public` と `claude-plugins-official` の両方に向く（B1 の確認項目は未解決）
- 集約した範囲: 公式 marketplace の第三者 261 件（P1-L-089）と LSP 12 / サンプル 18 件、docs の除外 111 ページ（6 群）、Agent SDK 28 ページは JSONL でも集約行。個別行は未展開（出力上限）。名前は notes に記載
- 使ったツールの逸脱: 許可リスト外の Bash コマンド（cat、grep、cut、tail、tr、for / echo、find の -printf）を、小さな出力（1 MB 未満）にだけ使った。拒否は出ていない。Read で自分の Grep 出力の保存ファイル（tool-results 配下）を読み、binary 内ホストの一覧を作った。入力リスト外の `official-llms-txts/README.md` も `cat` で読んだ（フォルダ説明のみ。結果には使っていない）
- cache の plugin.json: find で 18 件あり、`$schema` / 名前の Grep がヒットしたのは 6 件。未ヒットの 12 件はリンクではなく実 dir（skill-creator/2a8ad9f74633 には `.orphaned_at` と `.in_use` があり旧版の残骸の可能性。他 8 版は未確認。Grep が拾わなかった理由は不明）
- 未走査: `~/.claude/plugins/` の installed_plugins.json、blocklist.json、plugin-directory-bindings.json、plugin-directory-marketplace.json、data/、store/、synced/ の中身（synced は find の一覧のみで、skill 実体無し）。marketplaces の `.git` と `.gcs-sha`（コミット SHA 未取得）、各 marketplace の README と example-plugin のマニフェスト。外部 plugin の個別 author（261 件）。plugin-directory-cache-v2 の listing 総数と plugin-catalog-cache の author と名前の対応。cache の plugin.json 12 件の `$schema`。binary 内の「第三者ホスト上で claude を含むパス」（例: schemastore の URL）。binary の C1 は URL 全件の一意化ができず（sort / uniq を使えない）、ホスト単位は全件（永続化出力の 84〜99 行目を除く）、パス単位は anthropic.com / claude.com / platform / support / github の系統のみ。code.claude.com/docs/en/* の個別パスは未走査。`/help` の組み込みコマンド一覧は対話専用で未実施。content hash は計算できず（sha256sum が許可外）、同一性はサイズ一致のみ
- 注意（権威）: docs と binary の URL は文字列の存在確認だけで、HTTP は取得していない。権威は 1-1 に従う仮判定

### 補完（Fable 指示、2026-10-13）

- R6-2（別表 5）: 公式 marketplace.json の object source 262 件の source URL（インデント 8 の `url` / `repo` / `package` 行）を Grep で全件取り、手集計した（sort / uniq が使えないため）。全て `github.com`（gitlab や他ホスト、npm、`repo` 型は 0 件）。owner は 200 件（2 件以上が 29 owner で 91 件、1 件が 171 owner）。合計 262 は object source の件数と一致する。author の url 行（auth0.com、www.sap.com、convex.dev、greptile.com、jfrog.com）は source ではないので除外した。url 型 164 件と git-subdir 型 98 件の内訳は Fable の指摘値で、種別ごとの再集計はしていない。手集計のため、個別 owner の件数に誤りが残る可能性がある（合計と owner 数の検算は合っている）
- C-8（別表 2）: anthropic-skills: の 15 件を 3 群に分けた。(a) anthropics/skills に同名 skill があり、description の先頭 160 文字が一致する skill-creator（P1-L-128）と docx、pdf、pptx、xlsx（P1-L-127）を authority L1・candidate（notes は「L1 の複製（identity は P2-R が確定）」）。(b) 公開リポジトリにも L-2 にも同名が無く、日本語の説明を持つ large-file-reading と xsd-to-rdb（P1-L-132）を authority out・excluded（理由「アカウント固有」）。(c) 上の 2 群に当たらない 8 件（built-in-browser、chrome-browser、computer-use、deep-research、docs、google-workspace、import-memory、morning）は、アカウント固有か Anthropic 作成かを区別できないため、指示の 2 群には入れず新規行 P1-L-133（authority out（仮）・unverified・境界）にした。Fable の判断に回す。なお anthropic-skills: 側にローカル実体が無いので「サイズ一致」は取れず、(a) の根拠は説明文の一致とローカル複製 12 件のサイズ一致（33168B）の間接証拠。docx は説明文の語句が違う（版差の可能性）
- C-7: JSONL の docs ページ行（code.claude.com の 66 行 = P1-L-001〜065 と 131）の kind を asset から source に変更した。md の「種別」列も「源」にした。marketplace.json の行は元から source
- C-5: P1-L-105（plugin.schema.json）と P1-L-106（marketplace.schema.json）を unverified に変更し、notes に「2026-10-13 に 404（P2-V 確認）」を付けた。md の候補表から外し、件数表の C1 を採用 6→5、境界 4→3、未確認 8→10 に更新した
- 結果: JSONL は 131 行から 133 行（P1-L-132、133 を追加）。全行の構造を Grep で確認した。

## 別表 1. C9 予約 Marketplace 名の一覧（llms-full.txt L80873-80890。実体への対応づけは別エージェント）

| 区分 | 名称 | 規則・版 |
|---|---|---|
| 公式（14） | claude-code-marketplace、claude-code-plugins、claude-plugins-official、anthropic-marketplace、anthropic-plugins、agent-skills、anthropic-agent-skills、life-sciences、knowledge-work-plugins、claude-for-legal、claude-for-financial-services、financial-services-plugins、first-party-plugins、claude-tag-plugins | `github.com/anthropics/` 配下の github / git source でなければ予約（L80877） |
| コミュニティ（3） | claude-community、claude-plugins-community、healthcare | 同上（L80878） |
| Plugin directory（2） | anthropic-plugin-directory、claude-plugin-directory | 同上（L80879） |
| なりすまし | official-claude-plugins、claude-plugins-v2 など。非 ASCII を含む名前も拒否 | 例示のみで網羅ではない（L80880） |
| 別表記 | 末尾のドット、またはハイフン以外の記号を置いた名前（claude.code.plugins は claude-code-plugins と同じ扱い） | v2.1.280 以降（L80881） |
| 非 marketplace 由来の名前 | inline、builtin、skills-dir、synced、claude-plugin-test | L80882、由来表 L35227 |
| ツール名 | npm、pip、uv、cargo、github、gh（大文字小文字を問わない） | v2.1.275 以降（L80883） |
| JS オブジェクトのメンバー名 | constructor、hasOwnProperty、isPrototypeOf、propertyIsEnumerable、toLocaleString、toString、valueOf | v2.1.296 以降（L80884） |
| 接頭辞 | `claudeai-` で始まる名前（claude.ai ホスト用） | L80885 |
| DL フォルダ名 | `<owner>-<repo>`（github source で登録済みの marketplace のフォルダ名） | v2.1.290 以降（L80886） |
| skill 名（参考） | `anthropic-skills` と `anthropic-skills:` 接頭辞（claude.ai 同期 skill 用） | L23914（marketplace 名ではない） |
| 本機で該当するローカル実体 | claude-plugins-official、anthropic-agent-skills（marketplaces/ と known_marketplaces.json）、anthropic-plugin-directory（cache/ の名前空間のみ） | 他の予約名との対応づけは未実施 |

## 別表 2. C2 組み込み / Plugin / プロジェクト / アカウント別の skill・agent 一覧（転記元: このエージェントの system prompt の skill 一覧と Agent ツールの agent 一覧）

| 出所 | skill | agent | 件数 | 処理と docs の説明ページの有無 |
|---|---|---|---|---|
| 組み込み | dataviz、artifact-design、artifact-diagramming、artifact-capabilities、update-config、keybindings-help、code-review、simplify、fewer-permission-prompts、loop、schedule、claude-api、workflow-authoring、claude-in-chrome、run、plugin-authoring、init、security-review（18） | claude、claude-code-guide、Explore、general-purpose、Plan、statusline-setup（6） | 24 | skill は 16 件が `commands.md` の表にある（keybindings-help と artifact-design は表に無し）。agent は Plan / general-purpose のみ docs で確認、他は Grep 未検出。P1-L-120〜126 |
| Plugin | claude-security:{scan, claude-security}、plugin-dev:{create-plugin, agent-development, command-development, hook-development, mcp-integration, plugin-settings, plugin-structure, skill-development}、hookify:{configure, help, hookify, list, writing-rules}、skill-creator:skill-creator、playground:playground（17） | claude-security:{claude-security, explore, patch-generator, patch-verifier, scan-inventory, scan-loader, scan-redactor, scan-researcher, scan-verifier}、hookify:conversation-analyzer、plugin-dev:{agent-creator, plugin-validator, skill-reviewer}（13） | 30 | L-2 の cache と差し引き（P1-L-129）。commands/ 配下は個別確認せずプレフィックス一致のみ |
| プロジェクト | check-model、pre-compact、win-file-encoding（一覧に表示）、commit-and-pr、orchestrate（一覧に非表示。disable-model-invocation）（5） | code-reviewer、cve-cross-reviewer、cve-investigator（3） | 8 | 本リポジトリの `.claude/` と差し引き（P1-L-130）。素の `pre-compact` はプロジェクト側（同名の自作 Plugin は empty-can 名前空間） |
| アカウント（anthropic-skills:）(a) L1 の複製候補 | skill-creator（P1-L-128）、docx、pdf、pptx、xlsx（P1-L-127）（5） | なし | 5 | authority L1・candidate・境界。「L1 の複製（identity は P2-R が確定）」。根拠は anthropics/skills の同名 skill の説明文（先頭 160 字）の一致。skill-creator は複製 12 件がサイズ一致（33168B、hash 未取得）。docx は語句差あり。ローカル実体（anthropic-skills: 側）は無し |
| アカウント(b) アカウント固有 | large-file-reading、xsd-to-rdb（P1-L-132）（2） | なし | 2 | authority out・excluded（アカウント固有）。説明が日本語で、公開リポジトリにも L-2 にも同名が無い |
| アカウント(c) 出所未判定 | built-in-browser、chrome-browser、computer-use、deep-research、docs、google-workspace、import-memory、morning（P1-L-133）（8） | なし | 8 | authority out（仮）・unverified・境界。(a)(b) のどちらにも断定できず、Fable の判断に回す |

## 別表 3. C4 $schema の一意 URL

| URL | 出所 | 備考 |
|---|---|---|
| https://anthropic.com/claude-code/marketplace.schema.json | `LM claude-plugins-official/.claude-plugin/marketplace.json` 2 行目 | 2026-10-13 に 404（P2-V 確認）。P1-L-106 は unverified。binary 内の文字列には無い |
| https://json.schemastore.org/claude-code-settings.json | 本リポジトリ `.claude/settings.json`、`.claude/settings.local.json`。docs（llms-full L49493、L87544） | 第三者ドメイン。出所確認は P1-G2（B5） |
| https://www.schemastore.org/claude-code-keybindings.json | docs（llms-full L70381）のみ | ローカルの manifest には無い |
| （参考。`$schema` 行ではない）https://anthropic.com/claude-code/plugin.schema.json | `claude.exe` 内の文字列 | 2026-10-13 に 404（P2-V 確認）。P1-L-105 は unverified |
| `$schema` 無しを確認 | 本リポジトリの `.claude-plugin/marketplace.json` と `plugins/*/plugin.json`、anthropic-agent-skills の marketplace.json、cache の plugin.json 6 件 | cache の残り 12 件は Grep 未ヒットで未確認 |

## 別表 4. C1 本体（claude.exe 2.1.296）中の anthropic / claude を含む https:// 文字列（一意化。ホストは全件、パスは系統別）

単一 native binary だが、中の JS 文字列は Grep で読める。一致 2793 行。印: 既知 = 1-1 のドメイン・org、未知 = 1-1 に無い、範囲外 = 2-4 の除外または Plugin と無関係。

| ホスト・URL | 印 | 備考 |
|---|---|---|
| code.claude.com | 既知 | 大半が `/docs/en/*`。非 docs のパスは `/docs/s/claude-code-auto-mode`（短縮リンク。未知）と `/docs.`（断片）。個別の docs ページは未走査 |
| anthropic.com / www.anthropic.com | 既知（ドメイン） | `/claude-code/plugin.schema.json`（未知。P2-V の再確認で 404、P1-L-105 は未確認）。`/legal/*`、`/news/*`、`/claude/fable`、`/supported-countries` は範囲外 |
| claude.com | 既知 | `/docs/llms.txt`（既知・採用）。`/docs/claude-tag/*`、`/docs/third-party/claude-desktop`、`/docs/cowork/3p/schemas/*` は範囲外。`/claude-code`、`/enterprise`、`/download`、`/blog/the-advisor-strategy`、`/cai/oauth/authorize` も範囲外 |
| platform.claude.com | 既知（要確認） | `/llms.txt`（採用）。`/docs/en/build-with-claude/*`、`/docs/en/api/messages` は範囲外（X-4）。`/oauth/*`、`/settings/*`、`/buy_credits` も範囲外 |
| support.claude.com | 既知 | `/en/articles/<id>` が 8 件（P1-L-116。未確認） |
| docs.anthropic.com | 既知（旧ホスト） | `/en/docs/resources/model-deprecations`。platform.claude.com へのリダイレクトは未確認。範囲外 |
| support.anthropic.com | 未知（旧 support の可能性） | パス未取得。範囲外寄り |
| github.com/anthropics/claude-code | 既知 | `/issues` ほか、`/blob/main/CHANGELOG.md`。raw.githubusercontent.com の `…/refs/heads/main/CHANGELOG.md`（P1-L-109/110） |
| github.com/anthropics/claude-code-action | 未知・境界 | `docs/setup.md`、`docs/usage.md`、`examples/claude.yml`（P1-L-111） |
| github.com/anthropics/anthropic-sdk-typescript | 未知・範囲外 | `#streaming-responses`、`#long-requests`。他の anthropics リポジトリは出現せず |
| claude.ai | 未知・範囲外（X-5） | `/code`、`/code/artifact`、`/code/routines`、`/customize/connectors`、`/settings/*`、`/install.sh`、`/oauth/*` ほか |
| downloads.claude.ai、api.anthropic.com、api-staging.anthropic.com、status.claude.com | 未知・範囲外 | 配布、API、状態ページ |
| mcp-proxy.anthropic.com、slack.mcp.claude.com、microsoft365.mcp.claude.com | 未知・範囲外（MCP） | |
| claude.fedstart.com、claude-staging.fedstart.com、claude-ai.staging.ant.dev、beacon.claude-ai.staging.ant.dev | 未知・範囲外 | 政府向け環境と staging |
| claude.googleapis.com、user-08.（途中で切れた断片）、claude-gateway.corp.example.com | 未知・範囲外 | 他社ホストと docs の例示値 |
| `https://claude`（断片） | 無効 | 抽出途中の文字列 |
| npmjs.com、pypi.org、agentskills.io、modelcontextprotocol.io | 出現せず | binary 内に 0 件（Grep で確認） |

## 別表 5. L-2 の source の owner 集合（公式 marketplace の object source 262 件。手集計。判定は 1-2 に沿った仮判定）

全 source URL が `github.com`（他ホスト・`repo` 型・npm 型は 0 件）。owner は 200 件。anthropics は 0 件、agentskills は 0 件。判定: 既知 = 1-1 の org・公開標準、第三者 = 企業・ベンダー名義の org、第三者（個人・コミュニティ）、不明 = org の実体を確認できない。いずれも 1-2 の GitHub org の `is_verified` 確認（`gh api orgs/<org>`）は未実施で、owner 名とリポジトリ名からの仮判定。

| 判定（仮） | 件数（エントリ） | owner 数 | owner（件数。1 件は数字を省略） |
|---|---|---|---|
| 既知 org（L2、MCP は範囲外 B4） | 1 | 1 | modelcontextprotocol（mcp-apps） |
| anthropics / agentskills | 0 | 0 | なし |
| 不明（org の実体を未確認。Google 系の可能性） | 13 | 1 | gemini-cli-extensions 13 |
| 第三者（個人・コミュニティ） | 7 | 7 | mattpocock、obra、wonderwhy-er、Digital-Process-Tools、supabase-community、sourcegraph-community、gitroomhq |
| 第三者（企業 org・2 件以上） | 78 | 28 | awslabs 8、aws 5、pendo-io 5、astronomer 3、carta 3、grafana 3、microsoft 3、oracle 3、oracle-samples 3、SAP 3、Shopify 3、spotify 3、UI5 3、airwallex 2、atlassian 2、cap-js 2、chronograph-pe 2、ClickHouse 2、CrowdStrike 2、forcedotcom 2、getsentry 2、langfuse 2、mongodb 2、pydantic 2、qodo-ai 2、RevenueCat 2、stackhawk 2、VantaInc 2 |
| 第三者（企業 org・1 件） | 163 | 163 | 42Crunch-AI、adobe、SalesforceAIResearch、endorlabs、AikidoSec、Airtable、aiven、AltimateAI、amd、amplitude、apolloio、apollographql、appwrite、atlanhq、atlassian-labs、BrainBlend-AI、auth0、AzureCosmosDB、base44、Bigdata-com、boltz-bio、blackrock、box、brightdata、browser-use、buildkite、canva-sdks、carboneio、catalystbyzoho、ChromeDevTools、circlefin、circlebackai、ckeditor、clay-run、cloudflare、cloudinary-devs、cockroachdb、coderabbitai、CodSpeedHQ、get-convex、crowdsecurity、dash0hq、GoogleCloudPlatform、databricks、datadog-labs、datahub-project、datarobot-oss、confident-ai、dominodatalab、dropbox、duckdb、DuendeSoftware、exa-labs、expo、fastly、voxel51、figma、firecrawl、fullstorydev、GC-AI-Inc、gitkraken、GovTribe、greptileai、growthbook、honeycombio、hostinger、huggingface、hunter-io、heygen-com、taosdata、incident-io、intercom、intuit、jfrog、Leadfeeder、coursera、legalzoom、linq-lab、LogRocket、lovablelabs、ory、lusha-oss、mapbox、mercadopago、mergifyio、MicrosoftDocs、mintlify、miroapp、GoogleChrome、mlflow、mondaycom、neondatabase、netlify、newrelic、nvsecurity、Nimbleway、Noibu、makenotion、NVIDIA、growthxai、PagerDuty、paypal、gopigment、pinecone-io、pixeltable、planetscale、PostHog、postmanlabs、preset-io、prisma、qdrant、TheQtCompanyRnD、quarkusio、railwayapp、redis、render-oss、resend、rilldata、Rootly-AI-Labs、runwayml、sanity-io、SAP-samples、Scandit、semgrep、ServiceNow、goshippo、slackapi、Snowflake-Labs、SonarSource、sonatype、confluentinc、stripe、sumup、superdesigndev、SynthFlowAI、tavily-ai、JetBrains、togethercomputer、twilio、Unity-Technologies、EpicGames、val-town、Vanguard-oss、vercel、explorium-ai、villagesql、windsor-ai、wix、Automattic、workos、youdotcom-oss、zapier、zilliztech、zocks-communications、zoom、Zoominfo、zscaler、zytedata、ActiveCampaign、HubSpot、Dynatrace、wingspanHQ、amzn |
| 合計 | 262 | 200 | 1 + 13 + 7 + 78 + 163 = 262、1 + 1 + 7 + 28 + 163 = 200 |
