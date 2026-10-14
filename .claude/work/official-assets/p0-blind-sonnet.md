作成: P0-B（Sonnet）、2026-10-13

本表は status が candidate の行と、未確認（unverified）の行を含む。除外（excluded）の行は JSONL のみ。範囲判定・採用の最終決定は作業指示者。

| ID | 名称 | URL（最終 URL） | 種別・権威 | 権威の対象 | 活動と範囲判定 | 発見した場所 | 一次確認（取得日、SHA か version） |
|---|---|---|---|---|---|---|---|
| P0-B-001 | Claude Code docs llms.txt（索引） | https://code.claude.com/docs/llms.txt | 情報源 / L1 | behavior | 開発・テスト・配布 / 内 | docs-index | 2026-10-13 / mcp__fetch__fetch で全文取得（61.1KB） / 569行 |
| P0-B-002 | Plugins overview | https://code.claude.com/docs/en/plugins/overview.md | 情報源 / L1 | behavior | 開発・テスト・配布 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で本文先頭700文字を直接取得 / Claude Code 2.1.296 (npm latest) 時点。ページ自体に版記載なし |
| P0-B-003 | Create a Claude Code plugin（作成手順） | https://code.claude.com/docs/en/plugins/create.md | 情報源 / L1 | behavior, reference | 開発・テスト / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-004 | Add components to a plugin | https://code.claude.com/docs/en/plugins/components.md | 情報源 / L1 | format, behavior | 開発 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-005 | Plugin manifest reference（plugin.json） | https://code.claude.com/docs/en/plugins/manifest-reference.md | 情報源 / L1 | format, behavior | 開発・テスト / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で本文先頭9000文字を直接取得 / Claude Code 2.1.296 (npm latest) 時点。ページ自体に版記載なし |
| P0-B-006 | Marketplace reference（marketplace.json） | https://code.claude.com/docs/en/plugins/marketplace-reference.md | 情報源 / L1 | format, behavior | 配布 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-007 | Plugin commands reference（claude plugin / /plugin / /reload-plugins） | https://code.claude.com/docs/en/plugins/cli-reference.md | 情報源 / L1 | behavior | 開発・テスト・配布 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-008 | Plugin loading reference | https://code.claude.com/docs/en/plugins/loading.md | 情報源 / L1 | behavior | 開発・テスト / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-009 | Plugin dependencies | https://code.claude.com/docs/en/plugins/dependencies.md | 情報源 / L1 | format, behavior, policy | 配布 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-010 | Create a marketplace | https://code.claude.com/docs/en/plugins/create-marketplace.md | 情報源 / L1 | format, behavior | 配布 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で本文先頭700文字を直接取得 / Claude Code 2.1.296 (npm latest) 時点。ページ自体に版記載なし |
| P0-B-011 | Host and maintain a marketplace | https://code.claude.com/docs/en/plugins/host-marketplace.md | 情報源 / L1 | behavior, policy | 配布 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-012 | Publish and distribute a plugin | https://code.claude.com/docs/en/plugins/publish.md | 情報源 / L1 | policy, behavior | 配布 / 境界 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-013 | Measure plugin cost and usage | https://code.claude.com/docs/en/plugins/measure.md | 情報源 / L1 | behavior | 配布 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-014 | Troubleshoot plugins（validate メッセージ別の対処） | https://code.claude.com/docs/en/plugins/troubleshooting.md | 情報源 / L1 | behavior | 開発・テスト / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-015 | Plugin security and trust | https://code.claude.com/docs/en/plugins/security.md | 情報源 / L1 | policy, behavior | 配布 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-016 | Manage Claude Code plugins for your organization | https://code.claude.com/docs/en/plugins/org.md | 情報源 / L1 | policy, behavior | 配布 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-017 | Anthropic's marketplaces（official / community / demo） | https://code.claude.com/docs/en/plugins/anthropic-marketplaces.md | 情報源 / L1 | reference, policy | 配布 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で本文先頭7000文字を直接取得 / Claude Code 2.1.296 (npm latest) 時点。ページ自体に版記載なし |
| P0-B-018 | Install and manage plugins | https://code.claude.com/docs/en/plugins/install.md | 情報源 / L1 | behavior | 開発・テスト・配布 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-019 | Recommend plugins for your org（relevance ブロック） | https://code.claude.com/docs/en/plugins/relevance.md | 情報源 / L1 | format, behavior | 配布 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-020 | Recommend your plugin from your CLI | https://code.claude.com/docs/en/plugins/cli-hints.md | 情報源 / L1 | behavior | 配布 / 境界 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-021 | Code intelligence plugins（LSP） | https://code.claude.com/docs/en/plugins/code-intelligence.md | 情報源 / L1 | behavior | 開発 / 境界 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-022 | Mods ドキュメント群（plugins/mods/* 全 10 ページ） | https://code.claude.com/docs/en/plugins/mods/overview.md | 情報源 / L1 | format, behavior | 開発 / 境界 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-023 | Test a mod | https://code.claude.com/docs/en/plugins/mods/test.md | 情報源 / L1 | behavior, reference | テスト / 境界 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-024 | Test plugins with evals（claude plugin eval） | https://code.claude.com/docs/en/plugin-evals.md | 情報源 / L1 | behavior, reference, format | テスト / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で本文先頭5500文字を直接取得 / Claude Code 2.1.296 (npm latest) 時点。ページ自体に版記載なし |
| P0-B-025 | Extend Claude with skills | https://code.claude.com/docs/en/skills.md | 情報源 / L1 | format, behavior | 開発 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で本文先頭3500文字を直接取得 / Claude Code 2.1.296 (npm latest) 時点。ページ自体に版記載なし |
| P0-B-026 | Hooks reference | https://code.claude.com/docs/en/hooks.md | 情報源 / L1 | format, behavior | 開発 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-027 | Automate actions with hooks（ガイド） | https://code.claude.com/docs/en/hooks-guide.md | 情報源 / L1 | reference | 開発 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-028 | Create custom subagents | https://code.claude.com/docs/en/sub-agents.md | 情報源 / L1 | format, behavior | 開発 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-029 | All settings（settings.json 全キー） | https://code.claude.com/docs/en/settings-reference.md | 情報源 / L1 | behavior | 配布 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-030 | Explore the .claude directory | https://code.claude.com/docs/en/claude-directory.md | 情報源 / L1 | reference, format | 開発 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-031 | Debug your configuration | https://code.claude.com/docs/en/debug-your-config.md | 情報源 / L1 | behavior | テスト / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-032 | Commands（組込コマンド一覧） | https://code.claude.com/docs/en/commands.md | 情報源 / L1 | behavior | 開発・テスト / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-033 | Extend Claude Code（skill/subagent/hook/MCP/plugin の使い分け） | https://code.claude.com/docs/en/features-overview.md | 情報源 / L1 | reference | 開発 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-034 | Claude Code changelog（docs 版） | https://code.claude.com/docs/en/changelog.md | 情報源 / L1 | changelog | 開発・テスト・配布 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-035 | What's new（週次ダイジェスト） | https://code.claude.com/docs/en/whats-new/index.md | 情報源 / L1 | changelog | 開発・テスト・配布 / 内 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-036 | managed-settings / server-managed-settings / admin-setup（組織配布統制の 3 ページ） | https://code.claude.com/docs/en/managed-settings.md | 情報源 / L1 | policy, behavior | 配布 / 境界 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-037 | Claude Code GitHub Actions | https://code.claude.com/docs/en/github-actions.md | 情報源 / L1 | behavior | テスト・配布 / 境界 | docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-038 | anthropics/claude-code（リポジトリ） | https://github.com/anthropics/claude-code | 資産 / L1 | changelog, reference | 開発・テスト・配布 / 内 | github-org-listing | 2026-10-13 / mcp__fetch__fetch で api.github.com/orgs/anthropics/repos?per_page=100&sort=pushed&type=public を取得（gh api は未認証で失敗） / pushed_at=2026-10-11（日付のみ記録） |
| P0-B-039 | claude-code CHANGELOG.md | https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md | 情報源 / L1 | changelog | 開発・テスト・配布 / 内 | github-raw | 2026-10-13 / mcp__fetch__fetch で先頭900文字を取得 / 最新 2.1.296（npm latest と一致） |
| P0-B-040 | claude-code/plugins/README.md | https://github.com/anthropics/claude-code/blob/main/plugins/README.md | 情報源 / L1 | reference | 開発 / 内 | github-contents-api | 2026-10-13 / mcp__github__get_file_contents で plugins/ を列挙 / blob sha cf4a21ecc5b8da5394f0711aa513e566d1d7c0ea |
| P0-B-041 | claude-code/plugins/ demo Marketplace（claude-code-plugins） | https://github.com/anthropics/claude-code/tree/main/plugins | 資産 / L1 | reference | 開発 / 内 | github-contents-api, linked-from-L1-doc | 2026-10-13 / mcp__github__get_file_contents で plugins/ を列挙 / 14 エントリ（README + 13 Plugin） |
| P0-B-042 | plugin-dev（Plugin 開発キット） | https://github.com/anthropics/claude-code/tree/main/plugins/plugin-dev | 資産 / L1 | reference, behavior | 開発・テスト / 内 | github-contents-api, marketplace-json | 2026-10-13 / contents API と marketplace.json で存在確認 / tree sha b2a89d6d91a632af92dc5f00b3a530dde1cfcbb6 |
| P0-B-043 | hookify | https://github.com/anthropics/claude-code/tree/main/plugins/hookify | 資産 / L1 | reference | 開発 / 境界 | github-contents-api, marketplace-json | 2026-10-13 / contents API と marketplace.json で存在確認 / tree sha c4650339a98105b7ae6dbd71e41aa5991785b0a8 |
| P0-B-044 | anthropics/claude-plugins-official（リポジトリ） | https://github.com/anthropics/claude-plugins-official | 資産 / L1 | reference, policy | 開発・テスト・配布 / 内 | github-org-listing, linked-from-L1-doc | 2026-10-13 / mcp__fetch__fetch で api.github.com/orgs/anthropics/repos?per_page=100&sort=pushed&type=public を取得（gh api は未認証で失敗） / pushed_at=2026-10-12（日付のみ記録） |
| P0-B-045 | claude-plugins-official/.claude-plugin/marketplace.json | https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json | 資産 / L1 | format, reference, policy | 配布 / 内 | marketplace-json | 2026-10-13 / mcp__fetch__fetch で全文取得（190,810文字・4,429行） / main ブランチ raw（commit SHA は未取得） |
| P0-B-046 | skill-creator（公式 Plugin） | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator | 資産 / L1 | behavior, reference | 開発・テスト / 内 | marketplace-json, linked-from-L1-doc | 2026-10-13 / marketplace.json で存在確認。plugin-evals.md が言及 / main ブランチ（SHA 未取得） |
| P0-B-047 | 公式 Marketplace の Anthropic 著作 Plugin 群（./plugins/* 39 件） | https://github.com/anthropics/claude-plugins-official/tree/main/plugins | 資産 / L1 | reference | 開発 / 境界 | marketplace-json | 2026-10-13 / marketplace.json を python で集計 / 39 件 / main（SHA 未取得） |
| P0-B-048 | claude-plugins-community（リポジトリ） | https://github.com/anthropics/claude-plugins-community | 資産 / L1 | reference | 配布 / 境界 | github-org-listing, linked-from-L1-doc | 2026-10-13 / mcp__fetch__fetch で api.github.com/orgs/anthropics/repos?per_page=100&sort=pushed&type=public を取得（gh api は未認証で失敗） / pushed_at=2026-10-12（日付のみ記録） |
| P0-B-049 | anthropics/skills（リポジトリ） | https://github.com/anthropics/skills | 資産 / L1 | reference, format | 開発 / 境界 | github-org-listing, readme-link | 2026-10-13 / mcp__fetch__fetch で api.github.com/orgs/anthropics/repos?per_page=100&sort=pushed&type=public を取得（gh api は未認証で失敗） / pushed_at=2026-10-09（日付のみ記録） |
| P0-B-050 | anthropics/skills の template/ | https://github.com/anthropics/skills/tree/main/template | 資産 / L1 | reference | 開発 / 内 | readme-link | 未確認: 2026-10-13 / README の記述のみ（実体未取得） / 未取得 |
| P0-B-051 | anthropics/knowledge-work-plugins（リポジトリ） | https://github.com/anthropics/knowledge-work-plugins | 資産 / L1 | reference | 配布 / 境界 | github-org-listing, linked-from-L1-doc | 2026-10-13 / mcp__fetch__fetch で api.github.com/orgs/anthropics/repos?per_page=100&sort=pushed&type=public を取得（gh api は未認証で失敗） / pushed_at=2026-10-12（日付のみ記録） |
| P0-B-052 | anthropics/claude-code-action（GitHub Action） | https://github.com/anthropics/claude-code-action | 資産 / L1 | behavior | テスト・配布 / 境界 | github-org-listing, linked-from-L1-doc | 2026-10-13 / mcp__fetch__fetch で api.github.com/orgs/anthropics/repos?per_page=100&sort=pushed&type=public を取得（gh api は未認証で失敗） / pushed_at=2026-10-09（日付のみ記録） |
| P0-B-053 | @anthropic-ai/claude-code（npm パッケージ） | https://registry.npmjs.org/@anthropic-ai/claude-code/latest | 資産 / L1 | behavior | 開発・テスト・配布 / 内 | npm-registry | 2026-10-13 / mcp__fetch__fetch で registry の latest を取得（先頭900文字） / version 2.1.296 / shasum c07c326b6fdff6f1c20c8a1b863a9af7fa395ba5 |
| P0-B-054 | claude plugin validate | https://code.claude.com/docs/en/plugins/manifest-reference.md#validate-the-manifest | 資産 / L1 | behavior | 開発・テスト・配布 / 内 | cli-builtin, docs-direct | 2026-10-13 / manifest-reference.md 本文で記述を確認 / v2.1.296 時点。MCP 検査は v2.1.281+ |
| P0-B-055 | claude plugin eval / eval init | https://code.claude.com/docs/en/plugin-evals.md | 資産 / L1 | behavior, reference | テスト / 内 | cli-builtin, docs-direct | 2026-10-13 / plugin-evals.md 本文で記述を確認 / v2.1.269 以降が必要 |
| P0-B-056 | claude plugin * / /plugin / /reload-plugins（組込コマンド） | https://code.claude.com/docs/en/plugins/cli-reference.md | 資産 / L1 | behavior | 開発・テスト・配布 / 内 | cli-builtin, docs-llms-txt | 2026-10-13 / mcp__fetch__fetch で code.claude.com/docs/llms.txt を取得し索引エントリを確認（本文未取得） / llms.txt 61.1KB / 569行 |
| P0-B-057 | claude plugin tag | https://code.claude.com/docs/en/plugins/cli-reference.md | 資産 / L1 | behavior | 配布 / 内 | cli-builtin | 未確認: 2026-10-13 / 本走査では公式本文で確認していない / 未取得 |
| P0-B-058 | Agent Skills specification | https://agentskills.io/specification | 情報源 / L2 | format | 開発 / 内 | linked-from-L1-doc | 2026-10-13 / mcp__fetch__fetch で先頭1800文字を取得 / ページに版記載なし |
| P0-B-059 | Customize Claude Code with plugins（ブログ） | https://claude.com/blog/claude-code-plugins | 情報源 / L1 | changelog, reference | 開発・テスト・配布 / 内 | web-search | 2026-10-13 / mcp__fetch__fetch で先頭1000文字を取得 / 2025-10-09 公開（ページ記載） |
| P0-B-060 | $schema: marketplace.schema.json | https://anthropic.com/claude-code/marketplace.schema.json | 資産 / L1 | format | 配布 / 内 | marketplace-json | 未確認: 2026-10-13 / mcp__fetch__fetch で取得を試行 / 404（2026-10-13） |
| P0-B-061 | Claude Marketplace（Web） | https://claude.com/marketplace/plugins | 情報源 / L1 | reference | 配布 / 境界 | linked-from-L1-doc | 未確認: 2026-10-13 / docs の記述のみ（未取得） / 未取得 |
| P0-B-062 | Manage plugins for your organization（support 記事） | https://support.claude.com/en/articles/13837433-manage-plugins-for-your-organization | 情報源 / L1 | policy | 配布 / 境界 | web-search | 未確認: 2026-10-13 / WebSearch の結果に表示（本文未取得） / 未取得 |
| P0-B-063 | Equipping agents for the real world with Agent Skills（Engineering ブログ） | https://anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills | 情報源 / L1 | reference | 開発 / 境界 | readme-link | 未確認: 2026-10-13 / anthropics/skills README のリンクのみ（未取得） / 未取得 |
| P0-B-064 | Anthropic 組織の業務ドメイン向け Plugin リポジトリ群 | https://github.com/anthropics | 資産 / L1 | reference | 開発 / 境界 | github-org-listing | 未確認: 2026-10-13 / mcp__fetch__fetch で api.github.com/orgs/anthropics/repos?per_page=100&sort=pushed&type=public を取得（gh api は未認証で失敗） / pushed_at=2026-09-21（日付のみ記録） |
| P0-B-065 | anthropics/claude-tag-plugins | https://github.com/anthropics/claude-tag-plugins | 資産 / L1 | reference | 開発 / 境界 | github-org-listing | 未確認: 2026-10-13 / mcp__fetch__fetch で api.github.com/orgs/anthropics/repos?per_page=100&sort=pushed&type=public を取得（gh api は未認証で失敗） / pushed_at=2026-10-07（日付のみ記録） |

## 件数

| 列挙 | 採用 | 除外 | 未確認 | 境界 |
|---|---|---|---|---|
| 79 | 判定しない（作業指示者） | 14 | 8 | 13 |

列挙 = JSONL の行数。除外 / 未確認 / 境界（status が candidate で scope_verdict が boundary）は互いに重ならない。残り 44 件は status が candidate かつ scope_verdict が in。
1 行にまとめた集約項目あり（第三者 Plugin 群、mods 10 ページ、組織設定 3 ページ、demo Marketplace の 13 Plugin 等）。実際のページ数・Plugin 数は JSONL の notes に記載。

## 走査の記録

### 検索したクエリ
- WebSearch（standard、allowed_domains = anthropic.com / claude.com / support.claude.com）: 「Claude Code plugins marketplaces blog post how to build and distribute plugins」 1 回のみ
- GitHub 検索 API（mcp__github__search_*）と gh search は使っていない。GitHub は org 一覧と contents API で辿った

### 見に行った場所
- https://code.claude.com/docs/llms.txt（全文）。plugins/*、plugin-evals、skills、hooks、whats-new 等を抽出
- code.claude.com/docs/en の manifest-reference（9000 字）、anthropic-marketplaces（7000 字）、plugin-evals（5500 字）、skills（3500 字）、plugin-marketplaces（700 字）、plugins（700 字）
- api.github.com/orgs/anthropics/repos（per_page=100、pushed 順、1 ページ目 100 件）。gh api が未認証で失敗したため fetch ツールで代替
- raw.githubusercontent.com の claude-plugins-official/.claude-plugin/marketplace.json（全文）、anthropics/skills/README.md（3500 字）、anthropics/claude-code/CHANGELOG.md（900 字）
- mcp__github__get_file_contents で anthropics/claude-code の plugins/ を列挙
- registry.npmjs.org/@anthropic-ai/claude-code/latest、agentskills.io/specification、claude.com/blog/claude-code-plugins

### 見たが除外した理由（要約。個別は JSONL）
- 第三者 Plugin（L3）、Agent SDK、claude.ai / Cowork 側、個別 Plugin の利用ページ、CLI 配布・開発コンテナ・サンドボックス・API 学習用リポジトリ

### 見られなかった場所
- gh api / gh search: 「gh auth login」未実施のため失敗（Claude Code の権限拒否ではない）。org 一覧と 8 リポジトリ個別の API 呼び出しを fetch で代替
- github.com/anthropics/claude-code/releases.atom: GitHub の robots.txt により fetch ツールが拒否。rss の watch 可否は未確認
- anthropic.com/claude-code/marketplace.schema.json: 404
- 未走査: anthropics 組織の 2 ページ目以降（1 ページ目が上限の 100 件ちょうど）、docs の sitemap.xml、plugins/* 各ページの本文（llms.txt の索引のみ確認したものが多数）、claude-plugins-community の marketplace.json、agentskills.io/llms.txt と GitHub 側のリポジトリ、platform.claude.com の Agent Skills ドキュメント、anthropic.com/engineering・news の Plugin 関連記事、support.claude.com 記事の本文、claude-code の issues / discussions、Plugin ディレクトリ提出フロー（範囲外）、日本語版 docs
- ツール呼び出しは上限 30 回をほぼ使用。うち失敗 4 回（gh 未認証 1、Python の cp932 出力 2、コマンド長超過 1）
