# p1-docs: docs サイトの llms.txt（W-1）・sitemap 差集合（C5/R5）・リンク閉包（W-8）

- `claude --version`: 2.1.296 (Claude Code)（終了時の再測定。開始時は 2.1.296 (Claude Code) で同一）
- 取得時刻: 開始 2026-10-13T01:18:53+09:00 ／ 初回の書き出し 2026-10-13T01:40:12+09:00 ／ 追加走査後の書き出し 2026-10-13T01:53:38+09:00
- 担当 P1-D。取得は mcp__fetch__fetch（raw: llms.txt・sitemap.xml・llms-full.txt・個別ページ）と WebFetch（GitHub のページ。小モデル要約のためリンク網羅は保証されない）。作業用の中間ファイルはスクラッチパッドのみ
- 件数の定義: 採用 = status candidate かつ scope in ／ 境界 = candidate かつ boundary ／ 除外 = excluded ／ 未確認 = unverified。範囲判定は仮判定で、最終判定は Fable と作業指示者
- JSONL: p1-docs.jsonl（1248 行。初回 1,154 行 + 追加走査で追記。既存行の更新は status・notes・verified 等のみで id は不変）。翻訳ロケール群は「サイト × ロケール」で 1 行。除外一覧は JSONL のみ

## 表（status が candidate の行。ID が範囲のものは同種のまとめ行）

| ID | 名称 | URL（最終 URL） | 種別 / 権威 | 権威の対象 | 活動と範囲判定 | 発見チャネル | 一次確認（取得日、取得方法） |
|---|---|---|---|---|---|---|---|
| P1-D-0001 | Build for Claude（claude.com/docs/build/overview） | https://claude.com/docs/build/overview | 情報源 / L1 | reference,policy | 開発・テスト・配布 / 内 | W-1/W-8 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0003 | Decide what to include in your plugin（claude.com/docs/connectors/building/what-to-build） | https://claude.com/docs/connectors/building/what-to-build | 情報源 / L1 | reference | 開発 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0004 | Connectors, skills, and plugins（claude.com/docs/extend/overview） | https://claude.com/docs/extend/overview | 情報源 / L1 | reference | 開発 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0006 | Manage plugins for your organization（claude.com/docs/plugins/admin） | https://claude.com/docs/plugins/admin | 情報源 / L1 | policy | 配布 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0007 | Plugin structure and testing（claude.com/docs/plugins/build） | https://claude.com/docs/plugins/build | 情報源 / L1 | format,behavior | 開発・テスト / 内 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0008 | Roll out a plugin to your whole organization（claude.com/docs/plugins/org-rollout） | https://claude.com/docs/plugins/org-rollout | 情報源 / L1 | policy | 配布 / 内 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0009 | Sync your organization's plugins from a repository（claude.com/docs/plugins/org-sync） | https://claude.com/docs/plugins/org-sync | 情報源 / L1 | policy,behavior | 配布 / 内 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0010 | Plugins（claude.com/docs/plugins/overview） | https://claude.com/docs/plugins/overview | 情報源 / L1 | reference | 開発 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0011 | Plugin feature support across platforms（claude.com/docs/plugins/platform-support） | https://claude.com/docs/plugins/platform-support | 情報源 / L1 | behavior,reference | 開発・配布 / 内 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0012 | Plugin pre-submission checklist（claude.com/docs/plugins/pre-submission-checklist） | https://claude.com/docs/plugins/pre-submission-checklist | 情報源 / L1 | policy | テスト・配布 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0013 | Build your first plugin（claude.com/docs/plugins/quickstart） | https://claude.com/docs/plugins/quickstart | 情報源 / L1 | reference | 開発・テスト / 内 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0015 | Create custom skills（claude.com/docs/skills/how-to） | https://claude.com/docs/skills/how-to | 情報源 / L1 | format,reference | 開発・テスト / 内 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0016 | Skills overview（claude.com/docs/skills/overview） | https://claude.com/docs/skills/overview | 情報源 / L1 | reference | 開発 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0018 | MCP, plugins, skills, and hooks（claude.com/docs/third-party/claude-desktop/extensions） | https://claude.com/docs/third-party/claude-desktop/extensions | 情報源 / L1 | behavior | 開発・配布 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0266 | Agent Skills Overview（agentskills.io/home） | https://agentskills.io/home | 情報源 / L2 | format,reference | 開発 / 内 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0267 | Specification（agentskills.io/specification） | https://agentskills.io/specification | 情報源 / L2 | format | 開発・テスト / 内 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0269 | Quickstart（agentskills.io/skill-creation/quickstart） | https://agentskills.io/skill-creation/quickstart | 情報源 / L2 | reference | 開発 / 内 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0270 | Best practices for skill creators（agentskills.io/skill-creation/best-practices） | https://agentskills.io/skill-creation/best-practices | 情報源 / L2 | reference | 開発 / 内 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0271 | Optimizing skill descriptions（agentskills.io/skill-creation/optimizing-descriptions） | https://agentskills.io/skill-creation/optimizing-descriptions | 情報源 / L2 | reference | 開発・テスト / 内 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0272 | Evaluating skill output quality（agentskills.io/skill-creation/evaluating-skills） | https://agentskills.io/skill-creation/evaluating-skills | 情報源 / L2 | reference,behavior | テスト / 内 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0273 | Using scripts in skills（agentskills.io/skill-creation/using-scripts） | https://agentskills.io/skill-creation/using-scripts | 情報源 / L2 | reference | 開発 / 内 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0274 | How to add skills support to your agent（agentskills.io/client-implementation/adding-skills-support） | https://agentskills.io/client-implementation/adding-skills-support | 情報源 / L2 | reference | 開発 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap, llms-full) |
| P1-D-0276 | Overview（platform/docs/en/agents-and-tools/agent-skills/overview） | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview | 情報源 / L1 | reference | 開発 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap) |
| P1-D-0278 | Quickstart（platform/docs/en/agents-and-tools/agent-skills/quickstart） | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/quickstart | 情報源 / L1 | reference | 開発 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap) |
| P1-D-0340 | Best practices（platform/docs/en/agents-and-tools/agent-skills/best-practices） | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices | 情報源 / L1 | reference | 開発 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap) |
| P1-D-0341 | Skills for enterprise（platform/docs/en/agents-and-tools/agent-skills/enterprise） | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/enterprise | 情報源 / L1 | policy | 配布 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap) |
| P1-D-0361 | Skills in the API（platform/docs/en/build-with-claude/skills-guide） | https://platform.claude.com/docs/en/build-with-claude/skills-guide | 情報源 / L1 | reference | 開発 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap) |
| P1-D-0397 | Agent Skills（platform/docs/en/managed-agents/skills） | https://platform.claude.com/docs/en/managed-agents/skills | 情報源 / L1 | reference | 開発 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap) |
| P1-D-0408 | Claude Code Analytics API（platform/docs/en/manage-claude/claude-code-analytics-api） | https://platform.claude.com/docs/en/manage-claude/claude-code-analytics-api | 情報源 / L1 | reference | 配布 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap) |
| P1-D-0548 | Trigger a routine（platform/docs/en/api/claude-code/routines-fire） | https://platform.claude.com/docs/en/api/claude-code/routines-fire | 情報源 / L1 | reference | 開発 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap) |
| P1-D-0550 | Overview（platform/docs/en/agents-and-tools/agent-skills/claude-api-skill） | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/claude-api-skill | 情報源 / L1 | reference | 開発 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap) |
| P1-D-1077 | What's new（code.claude.com/docs/en/whats-new） | https://code.claude.com/docs/en/whats-new | 情報源 / L1 | changelog | 開発 / 境界 | C5 | 2026-10-13, fetch(llms+sitemap) |
| P1-D-1078 | What's new（code.claude.com/docs/en/whats-new/index） | https://code.claude.com/docs/en/whats-new/index | 情報源 / L1 | changelog | 開発 / 境界 | W-1 | 2026-10-13, fetch(llms+sitemap) |
| P1-D-1102 | Plugins overview（seed: plugins） | https://code.claude.com/docs/en/plugins/overview | 情報源 / L1 | reference,behavior | 開発・配布 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1103 | Create a marketplace（seed: plugin-marketplaces） | https://code.claude.com/docs/en/plugins/create-marketplace | 情報源 / L1 | format,behavior | 開発・テスト・配布 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1104 | Plugin manifest reference（seed: plugins-reference） | https://code.claude.com/docs/en/plugins/manifest-reference | 情報源 / L1 | format | 開発・テスト / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1105 | Marketplace reference | https://code.claude.com/docs/en/plugins/marketplace-reference | 情報源 / L1 | format,behavior | 開発・テスト・配布 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1106 | Extend Claude with skills（seed: skills） | https://code.claude.com/docs/en/skills | 情報源 / L1 | format,behavior | 開発・テスト / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1107 | Test plugins with evals（seed: plugin-eval） | https://code.claude.com/docs/en/plugin-evals | 情報源 / L1 | behavior | テスト / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1108 | Mods overview（seed: mods） | https://code.claude.com/docs/en/plugins/mods/overview | 情報源 / L1 | behavior | 開発・テスト / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1109 | Anthropic's marketplaces | https://code.claude.com/docs/en/plugins/anthropic-marketplaces | 情報源 / L1 | reference | 配布 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1110 | Publish and distribute a plugin | https://code.claude.com/docs/en/plugins/publish | 情報源 / L1 | policy,behavior | 配布 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1111 | Plugin loading reference | https://code.claude.com/docs/en/plugins/loading | 情報源 / L1 | behavior | 開発・テスト / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1112 | anthropics/claude-plugins-community | https://github.com/anthropics/claude-plugins-community | 資産 / L1 | reference | 配布 / 境界 | W-8 | 2026-10-13, WebFetch |
| P1-D-1113 | anthropics/knowledge-work-plugins | https://github.com/anthropics/knowledge-work-plugins | 資産 / L1 | reference | 配布 / 境界 | W-8 | 2026-10-13, WebFetch |
| P1-D-1114 | anthropics/claude-code-playground | https://github.com/anthropics/claude-code-playground | 資産 / L1 | reference | 開発・テスト / 境界 | W-8 | 2026-10-13, WebFetch |
| P1-D-1120 | anthropics/skills / skills/academy-guide（seed: academy-guide 束） | https://github.com/anthropics/skills/tree/main/skills/academy-guide | 資産 / L1 | reference | 開発 / 境界 | W-8 | 2026-10-13, WebFetch+fetch(raw) |
| P1-D-1121 | academy.claude.com（Claude Academy） | https://academy.claude.com | 情報源 / L1 | reference | 開発 / 境界 | W-8 | 2026-10-13, fetch(raw) |
| P1-D-1122 | academy.claude.com/assets/data/catalog.json | https://academy.claude.com/assets/data/catalog.json | 情報源 / L1 | reference | 開発 / 境界 | W-8 | 2026-10-13, fetch(raw) |
| P1-D-1123 | anthropics/claude-quickstarts | https://github.com/anthropics/claude-quickstarts | 資産 / L1 |  |  / 境界 | W-8 | 2026-10-13, WebFetch |
| P1-D-1124 | anthropics/claude-agent-sdk-demos | https://github.com/anthropics/claude-agent-sdk-demos | 資産 / L1 |  |  / 境界 | W-8 | 2026-10-13, WebFetch |
| P1-D-1125 | anthropics/claude-cookbooks | https://github.com/anthropics/claude-cookbooks | 資産 / L1 |  |  / 境界 | W-8 | 2026-10-13, WebFetch |
| P1-D-1132 | Claude Marketplace（claude.com/marketplace） | https://claude.com/marketplace | 情報源 / L1 | reference | 開発 / 境界 | W-8 | 2026-10-13, fetch(raw) |
| P1-D-1135 | claude.com/blog: Improving skill-creator（test, measure, refine） | https://claude.com/resources/articles/improving-skill-creator-test-measure-and-refine-agent-skills | 情報源 / L1 | reference | 開発 / 境界 | W-8 | 2026-10-13, fetch(raw) |
| P1-D-1136 | support.claude.com: What are skills? | https://support.claude.com/en/articles/12512176-what-are-skills | 情報源 / L1 | reference | 開発 / 境界 | W-8 | 2026-10-13, fetch(raw) |
| P1-D-1137 | support.claude.com: Using skills in Claude | https://support.claude.com/en/articles/12512180-use-skills-in-claude | 情報源 / L1 | reference | 開発 / 境界 | W-8 | 2026-10-13, fetch(raw) |
| P1-D-1138 | support.claude.com: Creating custom skills | https://support.claude.com/en/articles/12512198-how-to-create-custom-skills | 情報源 / L1 | reference | 開発 / 境界 | W-8 | 2026-10-13, fetch(raw) |
| P1-D-1139 | anthropic.com/engineering: Equipping agents for the real world with Agent Skills | https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills | 情報源 / L1 | reference | 開発 / 境界 | W-8 | 2026-10-13, fetch(raw) |
| P1-D-1140 | anthropic.com/news/create-files | https://claude.com/resources/articles/create-files | 情報源 / L1 | reference | 開発 / 境界 | W-8 | 2026-10-13, fetch(raw) |
| P1-D-1141 | anthropics/claude-code / mods/ | https://github.com/anthropics/claude-code/tree/main/mods | 資産 / L1 | reference | 開発・テスト / 境界 | W-8 | 2026-10-13, WebFetch |
| P1-D-1142 | anthropics/claude-code / plugins/ | https://github.com/anthropics/claude-code/tree/main/plugins | 資産 / L1 | reference | 開発・テスト / 境界 | W-8 | 2026-10-13, WebFetch |
| P1-D-1150 | anthropics/claude-plugins-official / .claude-plugin/ | https://github.com/anthropics/claude-plugins-official/tree/main/.claude-plugin | 資産 / L1 | reference | 開発 / 境界 | W-8 | 2026-10-13, WebFetch |
| P1-D-1151 | anthropics/skills / skills | https://github.com/anthropics/skills/tree/main/skills | 資産 / L1 | reference | 開発 / 境界 | W-8 | 2026-10-13, WebFetch |
| P1-D-1155 | Install and manage plugins（code.claude.com/docs/en/plugins/install） | https://code.claude.com/docs/en/plugins/install | 情報源 / L1 | behavior | 配布 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1156 | Code intelligence plugins（code.claude.com/docs/en/plugins/code-intelligence） | https://code.claude.com/docs/en/plugins/code-intelligence | 情報源 / L1 | reference | 開発 / 境界 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1157 | Plugin security and trust（code.claude.com/docs/en/plugins/security） | https://code.claude.com/docs/en/plugins/security | 情報源 / L1 | policy,behavior | 配布・開発 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1158 | Create a Claude Code plugin（code.claude.com/docs/en/plugins/create） | https://code.claude.com/docs/en/plugins/create | 情報源 / L1 | behavior,reference | 開発・テスト / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1159 | Add components to a plugin（code.claude.com/docs/en/plugins/components） | https://code.claude.com/docs/en/plugins/components | 情報源 / L1 | format,behavior | 開発 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1160 | Plugin dependencies（code.claude.com/docs/en/plugins/dependencies） | https://code.claude.com/docs/en/plugins/dependencies | 情報源 / L1 | format,behavior | 開発・配布 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1161 | Measure plugin cost and usage（code.claude.com/docs/en/plugins/measure） | https://code.claude.com/docs/en/plugins/measure | 情報源 / L1 | behavior | テスト・配布 / 境界 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1162 | Recommend your plugin from your CLI（code.claude.com/docs/en/plugins/cli-hints） | https://code.claude.com/docs/en/plugins/cli-hints | 情報源 / L1 | behavior | 配布 / 境界 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1163 | Host and maintain a marketplace（code.claude.com/docs/en/plugins/host-marketplace） | https://code.claude.com/docs/en/plugins/host-marketplace | 情報源 / L1 | behavior,policy | 配布 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1164 | Recommend plugins for your org（code.claude.com/docs/en/plugins/relevance） | https://code.claude.com/docs/en/plugins/relevance | 情報源 / L1 | behavior | 配布 / 境界 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1165 | Manage Claude Code plugins for your organization（code.claude.com/docs/en/plugins/org） | https://code.claude.com/docs/en/plugins/org | 情報源 / L1 | policy,behavior | 配布 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1166 | Troubleshoot plugins（code.claude.com/docs/en/plugins/troubleshooting） | https://code.claude.com/docs/en/plugins/troubleshooting | 情報源 / L1 | behavior | テスト・開発 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1167 | Plugin commands reference（code.claude.com/docs/en/plugins/cli-reference） | https://code.claude.com/docs/en/plugins/cli-reference | 情報源 / L1 | behavior,reference | 開発・テスト・配布 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1168 | Create a mod（code.claude.com/docs/en/plugins/mods/create） | https://code.claude.com/docs/en/plugins/mods/create | 情報源 / L1 | behavior | 開発 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1169 | Mods reference（code.claude.com/docs/en/plugins/mods/reference） | https://code.claude.com/docs/en/plugins/mods/reference | 情報源 / L1 | format,behavior | 開発 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1170 | Draw in the interface with a mod（code.claude.com/docs/en/plugins/mods/interface） | https://code.claude.com/docs/en/plugins/mods/interface | 情報源 / L1 | reference | 開発 / 境界 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1171 | Interface gallery for mods（code.claude.com/docs/en/plugins/mods/gallery） | https://code.claude.com/docs/en/plugins/mods/gallery | 情報源 / L1 | reference | 開発 / 境界 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1172 | React to events with a mod（code.claude.com/docs/en/plugins/mods/events） | https://code.claude.com/docs/en/plugins/mods/events | 情報源 / L1 | behavior | 開発 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1173 | Use the mods API（code.claude.com/docs/en/plugins/mods/api） | https://code.claude.com/docs/en/plugins/mods/api | 情報源 / L1 | behavior | 開発 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1174 | Test a mod（code.claude.com/docs/en/plugins/mods/test） | https://code.claude.com/docs/en/plugins/mods/test | 情報源 / L1 | behavior | テスト / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1175 | Troubleshoot a mod（code.claude.com/docs/en/plugins/mods/troubleshoot） | https://code.claude.com/docs/en/plugins/mods/troubleshoot | 情報源 / L1 | behavior | テスト・開発 / 内 | W-8 | 2026-10-13, fetch(llms-full) |
| P1-D-1176 | Manage mods for your organization（code.claude.com/docs/en/plugins/mods/admin） | https://code.claude.com/docs/en/plugins/mods/admin | 情報源 / L1 | policy | 配布 / 境界 | W-8 | 2026-10-13, fetch(llms-full) |

## 件数表（チャネルごと）

| チャネル | 列挙 | 採用 | 除外 | 未確認 | 境界 |
|---|---|---|---|---|---|
| W-1 claude.com/docs | 265 | 7 | 251 | 0 | 7 |
| W-1 agentskills.io | 9 | 7 | 1 | 0 | 1 |
| W-1 platform.claude.com (en) | 760 | 0 | 751 | 0 | 9 |
| C5 platform.claude.com 差集合 | 42 | 0 | 42 | 0 | 0 |
| C5 code.claude.com 差集合 | 25 | 0 | 23 | 0 | 2 |
| W-8 | 147 | 25 | 47 | 48 | 27 |
| 合計 | 1248 | 39 | 1115 | 48 | 46 |

## 走査の記録

### フィルタ基準
- 2-5 のキーワード（従）を title / URL / description に適用した（claude.com/docs、agentskills.io）。強語・境界語・除外語の当たりは各行の notes に「フィルタ印」として残した。署名（marketplace.json 等）は docs の title / description に現れないため、このチャネルでは適用できない
- platform.claude.com は追加条件どおり title / URL に skill / claude code を含む行だけを候補にした（llms.txt に description が無い）。en 760 ページ中 33 件が当たり、9 件を candidate（boundary）、24 件を X-4（API エンドポイント参照）で excluded にした。残り 727 件は不一致で excluded
- 仮判定の規則: X-3（directory 提出）・X-4（API 全般）・X-5（Cowork・別製品・別面）・除外語は excluded。迷いは boundary。claude.com/docs の candidate は追加走査で本文を取得し、本文の証拠（plugin.json・marketplace.json・SKILL.md・validate・--plugin-dir・eval・bin/・pluginRoot の語数。notes に cc / pj / mj / sk / val / pd / ev / bin / pr / hk の語数を記録）で見直した

### sitemap と llms.txt の差集合（C5 / R5）

| サイト | sitemap の URL 数 | llms.txt 行 / ユニーク | sitemap のみ | llms.txt のみ | 内訳・備考 |
|---|---|---|---|---|---|
| claude.com/docs | 265 | 266 / 265 | 0 | 0 | cowork/changelog が 1 行重複。正規化 4 件（/docs↔index、connectors/building↔building/index、connectors/github↔github/index、connectors/slack↔slack/index）。sitemap は docs/sitemap.xml の slug を目視で転記して Python で照合。llms-full.txt の Source 行は 262 ページ（末尾 3 ページは 4 チャンク目の外） |
| agentskills.io | 9 | 9 / 9 | 0 | 0 | .md を除くと全 slug が一致（目視）。llms-full.txt も 9 ページ |
| platform.claude.com | 3,849 | 761 / 761 | 3,089 | 1 | sitemap のみ = 11 ロケール × 278 = 3,058（slug は全て en の部分集合）+ docs 配下でない UI / ルート系 31。llms.txt のみ = llms-full.txt。en の 760 ページは両側で一致 |
| code.claude.com | 2,641 | 268 / 233 | 2,421 | 13 | sitemap のみ = en/whats-new 1 + 11 ロケール × 220 = 2,420（slug は全て en の部分集合）。llms.txt のみ = en/claude-tag、en/whats-new/index、_llms/*.txt 11（言語別索引）。llms.txt は 35 行が重複。en は 221 対 222 |

- claude.com/docs と agentskills.io は差が 0 で、llms.txt を全集合と見なせる根拠になる。platform と code.claude.com も en の docs ページは一致し、差は翻訳と UI / ルート系パスに限られる。翻訳は「サイト × ロケール」の 22 行にまとめた（内容の同一性は未検証）
- platform の UI / ルート系 31 件: /skills・/claude-code は Console の SPA シェル、/claude-code/settings は Console の管理設定画面（title: Managed settings）と取得して確認。残りは URL 文字列でフィルタ

### 追加確認（追加走査で更新）
- **Plugin ディレクトリ機能の説明ページ**: ある。claude.ai の directory カタログと account sync（`<name>@synced`）を説明するのは code.claude.com の plugins/anthropic-marketplaces・publish・loading。claude.com/docs の directory/publish・plugins/submit・pre-submission-checklist は X-3 の対象。**L-2b のローカルキャッシュ**（plugin-directory-cache-v2.json・plugin-catalog-cache.json）は、取得済みの code.claude.com 141 / 222 ページ、claude.com/docs 262 ページ、agentskills.io 9 ページのどこにも記述が無い（語の出現 0 件）。`anthropic-plugin-directory` は plugins/cli-reference（`plugin marketplace add / remove` のその予約名の扱い）と plugins/marketplace-reference（予約 Marketplace 名）にだけ出る。したがって `marketplaces/anthropic-plugin-directory/` は同名の予約 Marketplace のディレクトリと読めるが、これは推定
- **$schema / schemastore**: 言及はある。vs-code ページが settings.json に `"$schema": "https://json.schemastore.org/claude-code-settings.json"` を追加する案内、keybindings ページが `"$schema": "https://www.schemastore.org/claude-code-keybindings.json"` の例、cloud-environments ページが許可ドメイン一覧に json.schemastore.org・www.schemastore.org を載せる。plugin.json と marketplace.json の `$schema` は manifest-reference・marketplace-reference が「editor autocomplete 用の JSON Schema URL。load 時は無視」と書くだけで URL は示さない。範囲は取得済み 141 / 222 ページ（未取得 81 ページ）。B5 の出所確認（SchemaStore 上のファイルと投稿者）は P1-G2
- **M3（Organization 配布の受理条件）**: claude.com/docs/plugins/org-sync に明記（本文を取得）。metadata.pluginRoot の bare name は unsupported source として拒否。受理する source は github / url / git-subdir / `./` 始まりの相対パス。トップレベル `bin/` は拒否（エラー文言 "Plugin contains a top-level bin/ directory"）。github.com / gitlab.com の marketplace repo は private か internal。代替は scripts/ に置き `${CLAUDE_PLUGIN_ROOT}/scripts/<name>` で参照。同旨は claude.com/docs/plugins/build と code.claude.com の manifest-reference（Standard layout の bin/ 行）。pluginRoot の仕様自体（v2.1.239 以降）は marketplace-reference

### W-8 の到達範囲
- 深さ 0（seed）: 初回走査で全件。academy-guide 束は anthropics/skills の skills/academy-guide（SKILL.md と LICENSE.txt）
- 深さ 1: 初回に org-sync・plugins/build・anthropic-marketplaces・marketplace-reference・publish・loading。追加走査で code.claude.com の plugins/ 配下の残り 22 ページ（mods/ 9 を含む）、skills の末尾、claude.com/docs の plugins/quickstart・platform-support・org-rollout・admin・pre-submission-checklist・share、skills/how-to、directory/publish、agentskills.io の 9 ページを本文取得
- 深さ 2: 初回に community・knowledge-work-plugins・playground の各リポジトリページ、academy-guide の SKILL.md。追加走査で support.claude.com 記事 3、anthropic.com 記事 2、claude.com/resources/articles（旧 blog）1、claude.com/marketplace、academy.claude.com（と catalog.json）、claude-quickstarts・claude-agent-sdk-demos・claude-cookbooks、clau.de、docs.claude.com を 1 回ずつ取得（深さ 3 には進んでいない）

## 追加走査（Fable 指示、2026-10-13）

実施した項目:
1. 深さ 1 の未取得ページを全件取得。方法: code.claude.com と claude.com の llms-full.txt を mcp__fetch__fetch（raw）で 900,000 字ずつ分割取得（code 7 チャンク（0 / 0.9M / 2.7M / 3.6M / 4.5M / 5.4M / 6.3M 字目から。1.8M 字目のチャンクは未取得）、claude.com 4 チャンク）、agentskills.io は 1 回で全 9 ページ。Source 行でページに分割し、Markdown リンク・href・山括弧 URL をローカルで抽出（WebFetch の返す要約より網羅的）。code.claude.com は plugins/ 配下・skills・plugin-evals の 32 ページが全て取得済みで、チャンク末尾で切れたものは無い（22 ページを新規行に、10 ページは既存行へ追記）
2. 未知の確定: 別表 1 に到達元つきで確定。深さ 2 の指定 14 ページを 1 回ずつ取得し、外向きリンクの有無を確認
3. claude.com/docs の candidate 本文: 262 ページ分の本文を取得済み。candidate 39 件のうち本文を確認できたもの 39 件（結果: 内 7 件〔本文で境界から内へ上げたのは plugins/org-rollout の 1 件〕/ 境界 7 件 / 外へ 25 件 / 該当ページ無し 0 件）
4. skills ページの末尾 7,078 字は取得済み（リンクは agentskills.io・platform.claude.com の best-practices・claude.com/docs の claude-tag/admins/skills-repo のみ）。platform.claude.com/claude-code/settings は Console の管理設定画面（除外）
5. 取らなかったもの（指示どおり）: claude.com/sitemap.xml、platform.claude.com/cookbook/sitemap.xml

主な発見（事実）:
- Academy の catalog.json（generatedAt 2026-10-09、contentCommit 2f799c9）は 308 件。Claude Code の Plugin を扱う教材は 0 件、Plugin は Cowork 向け 6 件。Claude Code 向けの skill 教材はある（B6 の判断材料。notes と ID 1122）
- clau.de/plugin-directory-submission は claude.com/docs/directory/publish へ、docs.claude.com/en/api/skills-guide は platform.claude.com/docs/en/build-with-claude/skills-guide へ、リダイレクトされることを確認。claude.com/blog と anthropic.com/news は claude.com/resources/articles/* へ移っている
- code.claude.com の plugins/ 系 22 ページの外部リンクで Anthropic 外の新規単位は少ない: git-lfs.com、Shopify/liquid-skills、npm/node-semver、modelcontextprotocol/mcpb。Anthropic 内は claude-plugins-official の言語サーバー Plugin 12 件と claude-code の mods/ 配下、claude-plugins-community
- claude.com/docs の connectors/building/* は MCP の実装・認証が中心で、Plugin 形式の記述が無い。第三者の技術ドメイン（OAuth・ブラウザ互換・Okta・Figma など）が新規の未知の大半を占める（別表 1）
- platform.claude.com/docs/en/api/admin/analytics/plugins/list（Plugin の利用分析 API）が plugins/measure からリンクされる。platform の llms.txt には en/api/admin/... として載っており、title / URL 条件に当たらず excluded のまま（再判定は Fable）

W-8 の飽和: **飽和していない**。深さ 0 → 1 → 2 と未知の単位が増え続けた（初回の未知 = 別表 1 の最初の 6 ドメイン + 6 repo。追加走査の新規 = 未知の単位 54 件〔第三者ドメイン 31・MCP 系ドメイン 3・Anthropic 系ドメイン候補 4・repo / org 15・Console の route 1〕と、既知 repo の deep link 18 件）。新規の大半は第三者の一般技術ドメイン（out）。Anthropic 系の新規は claude.dev・console.anthropic.com・support.anthropic.com・brand.anthropic.com と、anthropics の repo 5 件（courses・claude-ai-mcp・anthropic-cookbook・sdk-demos・apps）、agentskills/agentskills。深さ 3 は指示どおり未実施で、再走査（最大 1 回）をするかは Fable の判断

### 未走査（追加走査後も残るもの）
- 深さ 3 以降。別表 1 の Anthropic 系候補（claude.dev・console.anthropic.com・support.anthropic.com・brand.anthropic.com・claude.ai の各ページ、anthropics/courses・claude-ai-mcp・anthropic-cookbook・sdk-demos・apps、agentskills/agentskills）の中身
- code.claude.com の llms-full.txt のうち未取得の 81 / 222 ページ（1.8M 字目のチャンクと 7.2M 字目以降。総サイズは未確認）。$schema / schemastore の「docs 全体での有無」はこの範囲を除く
- claude-plugins-official の言語サーバー Plugin 12 件・commit-commands と claude-code の mods/ 配下の中身（リンクのみ観測）。anthropics/skills の spec・template・skills/ 配下各 skill の中身
- claude.com/docs の candidate のうち本文を取得できなかったページ（0 件。notes 参照）。platform.claude.com の candidate 9 件と 24 件の中身（本文未取得）。claude.com/marketplace/plugins・claude.com/plugins/・claude.ai の各ページ
- sitemap: claude.com/sitemap.xml、platform.claude.com/cookbook/sitemap.xml（指示により取らない）
- 権限拒否: 無し。作業用ファイルの加工に Bash の python を使った（取得には使っていない）

### 計画書・他エージェントへの事実の共有（判断ではない）
- 計画書の seed 名（plugin-marketplaces・plugins-reference・plugin-eval）は現行 llms.txt に無い。現行は plugins/create-marketplace・plugins/manifest-reference・plugins/marketplace-reference・plugin-evals。claude-plugins-official の README は旧 slug（plugin-marketplaces、/plugins）にリンクしており、リダイレクトの有無は未確認
- anthropics/claude-code に feed.xml（トップレベル）。中身は未取得で、watchable rss の候補。academy.claude.com/assets/data/catalog.json は列挙可能な索引（S-5。P1-B が活用できる）
- anthropics に claude-plugins-community・knowledge-work-plugins・claude-code-playground・courses・claude-ai-mcp・apps・sdk-demos が存在または参照される（G-1 の対象）。anthropics/claude-plugins-public は今回のページでは観測していない

## 別表 1: W-8 の未知（ドメイン / org / repo + path 接頭辞）

未知の判定単位は repo + path 接頭辞（R3）。既知集合は 1-1 の「該当」列。到達元は「seed → ページ → リンク」。

| 種別 | 単位 | 到達元（深さ） | 状態・判定材料 | ID |
|---|---|---|---|---|
| ドメイン | academy.claude.com（hub と catalog.json） | anthropics/skills の academy-guide SKILL.md（深さ 1）。code.claude.com の overview・prompt-library・quickstart・admin-setup・communications-kit と claude.com/docs 索引もリンク | 取得済み。claude.com 配下で L1 候補。catalog.json は 308 件 | 1121, 1122 |
| ドメイン | claude.ai（/directory、/directory/manage、/admin-settings/*、/customize/*） | claude.com/docs の 24 ページ（plugins・directory・connectors/building・build）、code.claude.com の plugins/host-marketplace・org（深さ 1） | 未取得（認証面）。1-1 に無い | 1126 |
| ドメイン | claude.dev ／ console.anthropic.com ／ support.anthropic.com ／ brand.anthropic.com | claude.com/marketplace・anthropic.com 記事のフッター ／ claude-quickstarts・claude-agent-sdk-demos・claude-cookbooks の README ／ connectors/building/mcp-apps/design-guidelines（深さ 2） | 未取得。anthropic.com / claude.com 系で L1 候補（運営は未確認） | P1-D-1209〜1212（4 件） |
| ドメイン | clau.de ／ docs.claude.com | claude-plugins-official・community の README ／ skills ページ・anthropics/skills README | 解決済み（別名）: claude.com/docs/directory/publish ／ platform.claude.com/docs/en/build-with-claude/skills-guide | 1127, 1128 |
| ドメイン | skills.sh ／ notion.so（L3）／ mintcdn.com | anthropics/skills README、docs | 運営者未確認 ／ 別表のみ ／ 画像 CDN で除外 | 1130, 1129, 1131 |
| ドメイン（第三者） | git-lfs.com・api.slack.com・datatracker.ietf.org・developer.mozilla.org・learn.microsoft.com・openid.net・support.okta.com・www.figma.com・www.npmjs.com・discord.gg・bun.sh ほか計 29 | code.claude.com plugins/host-marketplace、claude.com/docs connectors/building/*、agentskills.io の home・skill-creation/*（深さ 1） | 除外（Plugin 開発資産ではない）。到達元ページは各 JSONL 行 | P1-D-1177〜1205（29 件） |
| ドメイン（MCP 系） | modelcontextprotocol.github.io・registry.modelcontextprotocol.io・apps.extensions.modelcontextprotocol.io | claude.com/docs connectors/building/mcp-apps/*・directory-vs-custom（深さ 1） | B4: L2 だが範囲外で除外 | P1-D-1206〜1208（3 件） |
| ドメイン（まとめ） | SNS（x.com・linkedin・youtube・threads・instagram）／ 配信インフラ（intercom・hcaptcha・fonts・assets.claude.com） | HTML フッター（深さ 2） | 除外 | 1213, 1214 |
| repo | anthropics/claude-plugins-community ／ knowledge-work-plugins ／ claude-code-playground | anthropic-marketplaces（深さ 2）／ plugins/build（深さ 1→2）／ mods/overview（深さ 1） | 取得済み。community は L3 の鏡、knowledge-work-plugins は Cowork 向け（X-5）、playground は sample mods | 1112, 1113, 1114 |
| repo | anthropics/claude-quickstarts ／ claude-agent-sdk-demos ／ claude-cookbooks | claude-code-playground README（深さ 2） | 取得済み。API / Agent SDK のクイックスタート。境界語 agent sdk | 1123, 1124, 1125 |
| repo | anthropics/courses ／ claude-ai-mcp ／ anthropic-cookbook ／ sdk-demos ／ apps | claude-quickstarts・cookbooks README ／ connectors/building/troubleshooting ／ claude-agent-sdk-demos README ／ directory/publish（深さ 2〜3 相当） | 未取得（深さ 3 は未実施） | P1-D-1225〜1229（5 件） |
| org / repo | agentskills/agentskills（と skills-ref） | agentskills.io の home・specification、skills/how-to（深さ 1） | 未取得。1-1 の agentskills org の repo。B3 | P1-D-1223〜1224（2 件） |
| org / repo | modelcontextprotocol/{ext-apps,mcpb,modelcontextprotocol,python-sdk,typescript-sdk} | connectors/building/*、code.claude.com plugins/components | B4 で除外 | P1-D-1218〜1222（5 件） |
| org / repo（第三者） | Shopify/liquid-skills（plugins/liquid-lsp）／ npm/node-semver ／ aws-samples/anthropic-on-aws | code-intelligence ／ plugins/dependencies ／ claude-cookbooks README | L3 別表のみ ／ 除外 ／ 除外 | P1-D-1215〜1217（3 件） |
| repo + path | anthropics/skills + skills/academy-guide | seed | 取得済み（ツリーと SKILL.md） | 1120 |
| 既知ドメインの docs 以外のパス | claude.com/marketplace・/marketplace/plugins・/plugins/、claude.com/resources/articles/{improving-skill-creator-…,create-files}（旧 blog / news）、support.claude.com の記事 3、anthropic.com/engineering の記事 | plugins/overview、anthropic-marketplaces、各 README、skills ページ（深さ 1） | marketplace と記事 6 件は取得済み、/marketplace/plugins と /plugins/ は未取得。P1-B（W-6 / W-7）へ | 1132, 1133, 1134, 1135, 1140, 1136, 1137, 1138, 1139 |
| JSONL に載せないリンク | claude.com/product/{claude-code,cowork}、anthropic.com/legal/{commercial-terms,privacy}、anthropic.com/discord | README | マーケ・法務・Discord（X-1）。記録のみ | - |

## 別表 2: 既知 repo 内の deep link（repo + path 接頭辞。G-6 / G-11 との差は P2-V）

| repo | path 接頭辞 | リンク元 | 確認 | ID |
|---|---|---|---|---|
| anthropics/claude-code | mods/（diff・agents-md・sec-default・telemetry）、mods/types/claude-code.d.ts | mods/overview・admin・reference | リンクと本文の記述。ツリー未取得 | 1141, P1-D-1244〜1248（5 件） |
| anthropics/claude-code | plugins/（demo Marketplace claude-code-plugins）、plugins/README.md | anthropic-marketplaces、plugins/create、README | 本文の記述。ツリー未取得 | 1142 |
| anthropics/claude-code | .claude-plugin/ ・ examples/ ・ feed.xml（top-level 一覧）。CHANGELOG.md は W-4 | README のページ | 一覧で観測。中身未取得 | 1143, 1145, 1144 |
| anthropics/claude-plugins-official | plugins/{plugin-dev,skill-creator,mcp-server-dev} | build/overview、skills ページ | リンクのみ。mcp-server-dev は L-2 のキャッシュに無い | 1146, 1148, 1147 |
| anthropics/claude-plugins-official | plugins/{clangd-lsp,csharp-lsp,gopls-lsp,jdtls-lsp,kotlin-lsp,lua-lsp,php-lsp,pyright-lsp,ruby-lsp,rust-analyzer-lsp,swift-lsp,typescript-lsp,commit-commands} | code.claude.com plugins/code-intelligence・install | リンクのみ（追加走査）。中身未取得 | P1-D-1231〜1243（13 件） |
| anthropics/claude-plugins-official | external_plugins/（L3）・ .claude-plugin/ | README のページ | 一覧で観測 | 1149, 1150 |
| anthropics/skills | skills/academy-guide（SKILL.md、LICENSE.txt） | seed | ツリーと SKILL.md を取得 | 1120 |
| anthropics/skills | skills/（19 ディレクトリ。skill-creator・brand-guidelines・internal-comms・pdf を skills/how-to がリンク）・ spec/ ・ template/ ・ .claude-plugin/ | README、ツリー、skills/how-to | skills/ は一覧を取得。他は未取得 | 1151, 1152, 1153, 1154 |
| anthropics/claude-code-playground（未知 repo） | claude-code/{mods,hooks,settings,workflows} ・ _template/PREFLIGHT.md（claude-code/claude-md、skills/、demos/、launch-demos/ も README にあるが JSONL 化せず） | playground README | リンクのみ。中身未取得 | P1-D-1115〜1119（5 件） |
| agentskills.io（L2） | /specification ・ /skill-creation/evaluating-skills | plugins/build、skills ページ | 表の ID 参照 | - |
