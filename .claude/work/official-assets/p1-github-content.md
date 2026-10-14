# P1-G2 GitHub の中身（G-6 / G-11 / G-5 / G-4）

- claude --version: 2.1.296 (Claude Code)（開始時、2026-10-13T01:43:40+09:00）／2.1.296 (Claude Code)（終了時、2026-10-13T02:44:58+09:00）。版のずれ: 無し
- 入力: 計画書（1-1、1-2、2-5、2-6、4-4）、p1-github-structure.jsonl（初回 533 行。再走査 1 は更新後の 1,433 行）、p1-local.md の別表 1（C9 予約名）。G-5 の since は 2025-06-30（P1-C の hooks 初出 1.0.38。指示で受領）
- 版: 初回完了 2026-10-13T02:16 → 再走査 1（Fable 指示）反映。再走査 1 の内容は「走査の記録」の「再走査 1」節、別表 4、一覧の ID 124 以降（JSONL は追記）
- 出力: 本ファイルと p1-github-content.jsonl（209 行）。木・G-6 の生データは scratchpad の github-trees/、g6/、g5/（本ファイルには要約のみ）
- 注: P1-G1 の記録は「gh 未認証」だが、本エージェントの gh は認証済み（アカウント empty-can、scope は gist / read:org / repo）。使用は GET と読み取り GraphQL のみ

## 一覧（status が candidate の行。scope_verdict は右から 2 列目の「内 / 境界」）

| ID | 名称 | URL（最終 URL） | 種別・権威 | 権威の対象 | 活動と範囲判定 | 発見チャネル | 一次確認（取得日、SHA か version） |
|---|---|---|---|---|---|---|---|
| 001 | anthropics/claude-code :: .claude-plugin/marketplace.json | https://github.com/anthropics/claude-code/blob/main/.claude-plugin/marketplace.json | 資産 / L1 | 参照実装・ポリシー | 配布 / 内 | G-6, G-11, C9 | 2026-10-13, 3deb873 |
| 002 | anthropics/claude-for-financial-advisors :: .claude-plugin/marke | https://github.com/anthropics/claude-for-financial-advisors/blob/main/.claude-plugin/marketplace.json | 資産 / L1 | 参照実装 | 配布 / 境界 | G-6, G-11 | 2026-10-13, 96fbcb4 |
| 003 | anthropics/claude-for-legal :: .claude-plugin/marketplace.json | https://github.com/anthropics/claude-for-legal/blob/main/.claude-plugin/marketplace.json | 資産 / L1 | 参照実装・ポリシー | 配布 / 境界 | G-6, G-11, C9 | 2026-10-13, 4a6c651 |
| 004 | anthropics/claude-plugins-official :: .claude-plugin/marketplace | https://github.com/anthropics/claude-plugins-official/blob/main/.claude-plugin/marketplace.json | 資産 / L1 | 参照実装・ポリシー | 配布 / 内 | G-6, G-11, C9 | 2026-10-13, f359d43 |
| 005 | anthropics/claude-tag-plugins :: .claude-plugin/marketplace.json | https://github.com/anthropics/claude-tag-plugins/blob/main/.claude-plugin/marketplace.json | 資産 / L1 | 参照実装・ポリシー | 配布 / 境界 | G-6, G-11, C9 | 2026-10-13, b6ee25f |
| 006 | anthropics/commerce-agents :: .claude-plugin/marketplace.json | https://github.com/anthropics/commerce-agents/blob/main/.claude-plugin/marketplace.json | 資産 / L1 | 参照実装 | 配布 / 境界 | G-6, G-11 | 2026-10-13, fd4d592 |
| 007 | anthropics/financial-services :: .claude-plugin/marketplace.json | https://github.com/anthropics/financial-services/blob/main/.claude-plugin/marketplace.json | 資産 / L1 | 参照実装・ポリシー | 配布 / 境界 | G-6, G-11, C9 | 2026-10-13, 574ed36 |
| 008 | anthropics/healthcare :: .claude-plugin/marketplace.json | https://github.com/anthropics/healthcare/blob/main/.claude-plugin/marketplace.json | 資産 / L1 | 参照実装・ポリシー | 配布 / 境界 | G-6, G-11, C9 | 2026-10-13, c7ed150 |
| 009 | anthropics/k12-teacher-skills :: .claude-plugin/marketplace.json | https://github.com/anthropics/k12-teacher-skills/blob/main/.claude-plugin/marketplace.json | 資産 / L1 | 参照実装 | 配布 / 境界 | G-6, G-11 | 2026-10-13, 281eb8d |
| 010 | anthropics/knowledge-work-plugins :: .claude-plugin/marketplace. | https://github.com/anthropics/knowledge-work-plugins/blob/main/.claude-plugin/marketplace.json | 資産 / L1 | 参照実装・ポリシー | 配布 / 境界 | G-6, G-11, C9 | 2026-10-13, 02ffa99 |
| 011 | anthropics/life-sciences :: .claude-plugin/marketplace.json | https://github.com/anthropics/life-sciences/blob/main/.claude-plugin/marketplace.json | 資産 / L1 | 参照実装・ポリシー | 配布 / 内 | G-6, G-11, C9 | 2026-10-13, e96556b |
| 012 | anthropics/oncall-kit :: .claude-plugin/marketplace.json | https://github.com/anthropics/oncall-kit/blob/main/.claude-plugin/marketplace.json | 資産 / L1 | 参照実装 | 配布 / 境界 | G-6, G-11 | 2026-10-13, c03282c |
| 013 | anthropics/skills :: .claude-plugin/marketplace.json | https://github.com/anthropics/skills/blob/main/.claude-plugin/marketplace.json | 資産 / L1 | 参照実装・ポリシー | 配布 / 内 | G-6, G-11, C9 | 2026-10-13, dbd4588 |
| 014 | anthropics/claude-plugins-community :: .claude-plugin/marketplac | https://github.com/anthropics/claude-plugins-community/blob/main/.claude-plugin/marketplace.json | 資産 / L1 | 参照実装・ポリシー | 配布 / 内 | G-11, C9 | 2026-10-13, f60f045 |
| 015 | anthropics/skills :: 署名ファイル群 | https://github.com/anthropics/skills/tree/main | 資産 / L1 | 参照実装 | 開発・テスト・配布 / 内 | G-11, G-6 | 2026-10-13, dbd4588 |
| 016 | anthropics/claude-code :: 署名ファイル群 | https://github.com/anthropics/claude-code/tree/main | 資産 / L1 | 参照実装・変更履歴 | 開発・配布 / 内 | G-11, G-6 | 2026-10-13, 3deb873 |
| 017 | anthropics/claude-cookbooks :: 署名ファイル群 | https://github.com/anthropics/claude-cookbooks/tree/main | 資産 / L1 | 参照実装 | 開発・テスト・配布 / 境界 | G-6, G-11 | 2026-10-13, 9c1e493 |
| 018 | anthropics/financial-services :: 署名ファイル群 | https://github.com/anthropics/financial-services/tree/main | 資産 / L1 | 参照実装 | 開発・配布 / 境界 | G-11, G-6 | 2026-10-13, 574ed36 |
| 019 | anthropics/claude-plugins-official :: 署名ファイル群 | https://github.com/anthropics/claude-plugins-official/tree/main | 資産 / L1 | 参照実装・変更履歴 | 開発・テスト・配布 / 内 | G-11, G-6 | 2026-10-13, f359d43 |
| 020 | anthropics/knowledge-work-plugins :: 署名ファイル群 | https://github.com/anthropics/knowledge-work-plugins/tree/main | 資産 / L1 | 参照実装・変更履歴 | 開発・配布 / 境界 | G-11, G-6 | 2026-10-13, 02ffa99 |
| 021 | agentskills/agentskills :: 署名ファイル群 | https://github.com/agentskills/agentskills/tree/main | 資産 / L2 | 参照実装・形式 | - / 内 | G-11 | 2026-10-13, 69ef37e |
| 022 | anthropics/claude-quickstarts :: 署名ファイル群 | https://github.com/anthropics/claude-quickstarts/tree/main | 資産 / L1 | 参照実装・変更履歴 | 開発・配布 / 境界 | G-6, G-11 | 2026-10-13, 9ec32b9 |
| 023 | anthropics/claude-for-legal :: 署名ファイル群 | https://github.com/anthropics/claude-for-legal/tree/main | 資産 / L1 | 参照実装 | 開発・配布 / 境界 | G-11, G-6 | 2026-10-13, 4a6c651 |
| 024 | anthropics/claude-code-action :: 署名ファイル群 | https://github.com/anthropics/claude-code-action/tree/main | 資産 / L1 | 参照実装 | 開発・配布 / 内 | G-11, G-6 | 2026-10-13, 1d6de8c |
| 025 | anthropics/claude-agent-sdk-python :: 署名ファイル群 | https://github.com/anthropics/claude-agent-sdk-python/tree/main | 資産 / L1 | 参照実装・変更履歴 | 開発・配布 / 境界 | G-11, G-6 | 2026-10-13, b6e9d12 |
| 026 | anthropics/defending-code-reference-harness :: 署名ファイル群 | https://github.com/anthropics/defending-code-reference-harness/tree/main | 資産 / L1 | 参照実装 | 開発 / 境界 | G-11, G-6 | 2026-10-13, d3bea6b |
| 027 | anthropics/claude-code-security-review :: 署名ファイル群 | https://github.com/anthropics/claude-code-security-review/tree/main | 資産 / L1 | 参照実装 | テスト・配布 / 境界 | G-11, G-6 | 2026-10-13, 0c6a49f |
| 028 | anthropics/sandbox-runtime :: 署名ファイル群 | https://github.com/anthropics/sandbox-runtime/tree/main | 資産 / L1 | 参照実装 | - / 内 | G-11 | 2026-10-13, 6b4fc1d |
| 029 | anthropics/claude-plugins-community :: 署名ファイル群 | https://github.com/anthropics/claude-plugins-community/tree/main | 資産 / L1 | 参照実装 | 開発・テスト・配布 / 内 | G-11, G-6 | 2026-10-13, f60f045 |
| 031 | anthropics/commerce-agents :: 署名ファイル群 | https://github.com/anthropics/commerce-agents/tree/main | 資産 / L1 | 参照実装 | 開発・配布 / 境界 | G-11, G-6 | 2026-10-13, fd4d592 |
| 032 | anthropics/claude-agent-sdk-demos :: 署名ファイル群 | https://github.com/anthropics/claude-agent-sdk-demos/tree/main | 資産 / L1 | 参照実装・変更履歴 | 開発・配布 / 境界 | G-11, G-6 | 2026-10-13, 826b268 |
| 033 | anthropics/cwc-workshops :: 署名ファイル群 | https://github.com/anthropics/cwc-workshops/tree/main | 資産 / L1 | 参照実装 | 開発・テスト / 境界 | G-6, G-11 | 2026-10-13, 068b84b |
| 035 | anthropics/claude-agent-sdk-typescript :: 署名ファイル群 | https://github.com/anthropics/claude-agent-sdk-typescript/tree/main | 資産 / L1 | 参照実装・変更履歴 | 配布 / 境界 | G-11, G-6 | 2026-10-13, 85d8f8e |
| 037 | anthropics/launch-your-agent :: 署名ファイル群 | https://github.com/anthropics/launch-your-agent/tree/main | 資産 / L1 | 参照実装 | 開発 / 境界 | G-11, G-6 | 2026-10-13, d5d0ffb |
| 038 | anthropics/claude-code-base-action :: 署名ファイル群 | https://github.com/anthropics/claude-code-base-action/tree/main | 資産 / L1 | 参照実装 | 開発・配布 / 内 | G-11, G-6 | 2026-10-13, 0adbfaf |
| 039 | anthropics/buffa :: 署名ファイル群 | https://github.com/anthropics/buffa/tree/main | 資産 / L1 | 参照実装・変更履歴 | 開発・配布 / 境界 | G-6, G-11 | 2026-10-13, c5528ac |
| 040 | anthropics/code-migration-kit-with-claude-code :: 署名ファイル群 | https://github.com/anthropics/code-migration-kit-with-claude-code/tree/main | 資産 / L1 | 参照実装 | 開発 / 境界 | G-11, G-6 | 2026-10-13, cf91c9d |
| 041 | anthropics/cwc-long-running-agents :: 署名ファイル群 | https://github.com/anthropics/cwc-long-running-agents/tree/main | 資産 / L1 | 参照実装 | 開発 / 境界 | G-11 | 2026-10-13, ad107a9 |
| 042 | anthropics/anthropic-cli :: 署名ファイル群 | https://github.com/anthropics/anthropic-cli/tree/main | 資産 / L1 | 参照実装・変更履歴 | 配布 / 境界 | G-6, G-11 | 2026-10-13, 4035cbe |
| 043 | anthropics/life-sciences :: 署名ファイル群 | https://github.com/anthropics/life-sciences/tree/main | 資産 / L1 | 参照実装 | 開発・配布 / 内 | G-11, G-6 | 2026-10-13, e96556b |
| 044 | anthropics/k12-teacher-skills :: 署名ファイル群 | https://github.com/anthropics/k12-teacher-skills/tree/main | 資産 / L1 | 参照実装 | 開発・テスト・配布 / 境界 | G-11, G-6 | 2026-10-13, 281eb8d |
| 045 | anthropics/healthcare :: 署名ファイル群 | https://github.com/anthropics/healthcare/tree/main | 資産 / L1 | 参照実装 | 開発・配布 / 境界 | G-11, G-6 | 2026-10-13, c7ed150 |
| 050 | anthropics/oncall-kit :: 署名ファイル群 | https://github.com/anthropics/oncall-kit/tree/main | 資産 / L1 | 参照実装 | 開発・配布 / 境界 | G-11, G-6 | 2026-10-13, c03282c |
| 051 | anthropics/claude-code-playground :: 署名ファイル群 | https://github.com/anthropics/claude-code-playground/tree/main | 資産 / L1 | 参照実装 | 開発・配布 / 内 | G-11, G-6 | 2026-10-13, 569c528 |
| 052 | anthropics/agent-sdk-workshop :: 署名ファイル群 | https://github.com/anthropics/agent-sdk-workshop/tree/main | 資産 / L1 | 参照実装 | - / 境界 | G-11 | 2026-10-13, a273fbe |
| 053 | anthropics/claude-for-financial-advisors :: 署名ファイル群 | https://github.com/anthropics/claude-for-financial-advisors/tree/main | 資産 / L1 | 参照実装 | 開発・配布 / 境界 | G-11, G-6 | 2026-10-13, 96fbcb4 |
| 054 | anthropics/claude-tag-plugins :: 署名ファイル群 | https://github.com/anthropics/claude-tag-plugins/tree/main | 資産 / L1 | 参照実装 | 開発・配布 / 境界 | G-11, G-6 | 2026-10-13, b6ee25f |
| 055 | anthropics/redis-py :: 署名ファイル群 | https://github.com/anthropics/redis-py/tree/master | 資産 / L1 | 参照実装 | 配布 / 境界 | G-6, G-11 | 2026-10-13, 04589d4 |
| 077 | anthropics/claude-code-action Announcements discussion #286: Mer | https://github.com/anthropics/claude-code-action/discussions/286 | 情報源 / L1 | 変更履歴 | 配布 / 境界 | G-5 | 2026-10-13, createdAt 2025-07-17 |
| 078 | anthropics/claude-ai-mcp Announcements discussion #92: Reduced u | https://github.com/anthropics/claude-ai-mcp/discussions/92 | 情報源 / L1 | 挙動 | 配布 / 境界 | G-5 | 2026-10-13, createdAt 2026-03-10 |
| 079 | agentskills/agentskills pinned issue #255: Proposal: `.well-know | https://github.com/agentskills/agentskills/issues/255 | 情報源 / L2 | 形式 | 配布 / 境界 | G-5 | 2026-10-13, createdAt 2026-03-17 |
| 087 | SchemaStore Claude Code Settings schema (claude-code-settings.js | https://json.schemastore.org/claude-code-settings.json | 資産 / out | 形式 | 開発 / 境界 | C4, G-6 | 2026-10-13, blob 63bdcc7; first commit f |
| 088 | SchemaStore Claude Code Plugin Manifest schema (claude-code-plug | https://json.schemastore.org/claude-code-plugin-manifest.json | 資産 / L3 | 形式 | 開発・配布 / 境界 | C4, G-6 | 2026-10-13, blob 5711af1; first commit d |
| 089 | SchemaStore Claude Code Plugin Marketplace schema (claude-code-m | https://json.schemastore.org/claude-code-marketplace.json | 資産 / L3 | 形式 | 配布 / 境界 | C4, G-6 | 2026-10-13, blob 3a6d5f4; first commit d |
| 090 | SchemaStore Claude Code Keybindings schema (claude-code-keybindi | https://json.schemastore.org/claude-code-keybindings.json | 資産 / out | 形式 | 開発 / 境界 | C4, G-6 | 2026-10-13, blob c061b5a; first commit 6 |
| 091 | SchemaStore Claude Code Launch Preview schema (claude-code-launc | https://www.schemastore.org/claude-code-launch.json | 資産 / out | 形式 | 開発 / 境界 | C4, G-6 | 2026-10-13, blob 65ad358; first commit a |
| 114 | R4 抜き取り anthropics/uplifting-biomolecular-modeling | https://github.com/anthropics/uplifting-biomolecular-modeling/tree/main | 資産 / L1 | 参照実装 | - / 境界 | G-11 | 2026-10-13, f4f62fa |
| 123 | R4 抜き取り検査 20 件の集約（G-1 out 判定の基準見直し材料） | (複数。別表 4 参照) | 情報源 / out | - | - / 境界 | G-11 | 2026-10-13, gh api git/trees 20 件 + Grep |
| 124 | anthropics/claude-cookbooks :: 署名ファイル（再走査 1） | https://github.com/anthropics/claude-cookbooks/tree/main | 資産 / L1 | 参照実装 | 開発 / 境界 | G-11 | 2026-10-13, 7a8eb12 |
| 125 | anthropics/claude-quickstarts :: 署名ファイル（再走査 1） | https://github.com/anthropics/claude-quickstarts/tree/main | 資産 / L1 | 参照実装・変更履歴 | 開発・配布 / 境界 | G-11 | 2026-10-13, 6b39ef5 |
| 126 | anthropics/cwc-workshops :: 署名ファイル（再走査 1） | https://github.com/anthropics/cwc-workshops/tree/main | 資産 / L1 | 参照実装 | 開発 / 境界 | G-11 | 2026-10-13, b67c1d2 |
| 127 | anthropics/buffa :: 署名ファイル（再走査 1） | https://github.com/anthropics/buffa/tree/main | 資産 / L1 | 参照実装・変更履歴 | 開発・配布 / 境界 | G-11 | 2026-10-13, 78e8b47 |
| 128 | anthropics/uplifting-biomolecular-modeling :: 署名ファイル（再走査 1） | https://github.com/anthropics/uplifting-biomolecular-modeling/tree/main | 資産 / L1 | 参照実装・変更履歴 | 開発・配布 / 境界 | G-11 | 2026-10-13, c68c6a4 |
| 129 | anthropics/anthropic-sdk-python :: 署名ファイル（再走査 1） | https://github.com/anthropics/anthropic-sdk-python/tree/main | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, d197651 |
| 130 | anthropics/anthropic-sdk-typescript :: 署名ファイル（再走査 1） | https://github.com/anthropics/anthropic-sdk-typescript/tree/main | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, 0ae28e1 |
| 131 | anthropics/anthropic-sdk-go :: 署名ファイル（再走査 1） | https://github.com/anthropics/anthropic-sdk-go/tree/main | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, a2f6867 |
| 132 | anthropics/anthropic-cli :: 署名ファイル（再走査 1） | https://github.com/anthropics/anthropic-cli/tree/main | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, aa1d87a |
| 133 | anthropics/anthropic-sdk-java :: 署名ファイル（再走査 1） | https://github.com/anthropics/anthropic-sdk-java/tree/main | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, b01fce6 |
| 134 | anthropics/anthropic-sdk-ruby :: 署名ファイル（再走査 1） | https://github.com/anthropics/anthropic-sdk-ruby/tree/main | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, b6a15f0 |
| 135 | anthropics/anthropic-sdk-csharp :: 署名ファイル（再走査 1） | https://github.com/anthropics/anthropic-sdk-csharp/tree/main | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, 744ab09 |
| 136 | anthropics/ClaudeForFoundationModels :: 署名ファイル（再走査 1） | https://github.com/anthropics/ClaudeForFoundationModels/tree/main | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, 1950341 |
| 137 | anthropics/anthropic-sdk-php :: 署名ファイル（再走査 1） | https://github.com/anthropics/anthropic-sdk-php/tree/main | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, 421fc5d |
| 138 | anthropics/orjson :: 署名ファイル（再走査 1） | https://github.com/anthropics/orjson/tree/anthropic-3.11.7 | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, cc3d977 |
| 139 | anthropics/rclone :: 署名ファイル（再走査 1） | https://github.com/anthropics/rclone/tree/master | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, fb1ac25 |
| 140 | anthropics/s5cmd :: 署名ファイル（再走査 1） | https://github.com/anthropics/s5cmd/tree/master | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, 0a99584 |
| 141 | anthropics/tokio :: 署名ファイル（再走査 1） | https://github.com/anthropics/tokio/tree/anthropic-1.52.3 | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, dea5b3b |
| 142 | anthropics/httpcore :: 署名ファイル（再走査 1） | https://github.com/anthropics/httpcore/tree/anthropic-1.0.9 | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, e84f3df |
| 143 | anthropics/argo-cd :: 署名ファイル（再走査 1） | https://github.com/anthropics/argo-cd/tree/master | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, 79ca5b9 |
| 144 | anthropics/torchtyping :: 署名ファイル（再走査 1） | https://github.com/anthropics/torchtyping/tree/anthropic-0.1.5 | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, a98e461 |
| 145 | anthropics/sse-starlette :: 署名ファイル（再走査 1） | https://github.com/anthropics/sse-starlette/tree/master | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, a2ac653 |
| 146 | anthropics/raft-rs :: 署名ファイル（再走査 1） | https://github.com/anthropics/raft-rs/tree/master | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, e2f4500 |
| 147 | anthropics/leptos-chartistry :: 署名ファイル（再走査 1） | https://github.com/anthropics/leptos-chartistry/tree/master | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, 7194893 |
| 148 | anthropics/serde-saphyr :: 署名ファイル（再走査 1） | https://github.com/anthropics/serde-saphyr/tree/master | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, dabcf62 |
| 149 | anthropics/snix :: 署名ファイル（再走査 1） | https://github.com/anthropics/snix/tree/canon | 資産 / L1 | 変更履歴 | 配布 / 境界 | G-11 | 2026-10-13, 7b2d8d2 |

ID は P1-G2-NNN の NNN。名称が「署名ファイル群」の行（初回）は repo ごとに署名（marketplace.json、plugin.json、SKILL.md、hooks.json、.mcp.json、.claude/agents、.claude/skills、evals、CHANGELOG.md、action.yml、claude 名の workflow）と語に当たったパスの集約（件数と例は JSONL の notes）。「署名ファイル（再走査 1）」の行（124 以降）は org の out repo の署名全パス（固定 SHA の木）で、署名ありは scope_verdict=boundary。

## 件数表（探索単位 = 各項目の channel の先頭）

| 探索単位 | 列挙 | 採用（candidate かつ内） | 除外 | 未確認 | 境界（candidate かつ境界） |
|---|---|---|---|---|---|
| G-6 | 28 | 4 | 9 | 0 | 15 |
| G-11 | 136 | 11 | 79 | 0 | 46 |
| G-5 | 10 | 0 | 6 | 1 | 3 |
| G-4 | 21 | 0 | 21 | 0 | 0 |
| C4 | 5 | 0 | 0 | 0 | 5 |
| C9 | 9 | 0 | 0 | 9 | 0 |
| 計 | 209 | 15 | 115 | 10 | 69 |
| （うち G-11 の再走査 1。ID 124 以降） | 86 | 0 | 60 | 0 | 26 |

## 走査の記録

### 実行と呼び出し数
- エージェントのツール呼び出し: 約 90 回（初回 約 70 + 再走査 1 約 20。上限 140 + 120）。スクリプト経由の API（概算）: code search 111 回（初回 98 + 再走査 13、エラー 0）、REST 約 250 回（木 65 + 再走査 93、contents 約 50、SchemaStore 約 30、rate_limit ほか）、GraphQL 約 240 回（G-5 の 206 回を含む）、search/issues 20 回、git clone 21 件
- rate_limit: 初回開始時 core 5000 / search 30 / code_search 10 / graphql 4993。再走査 1 開始時 core 5000 / search 30 / code_search 10 / graphql 4972。最終 core 5000 / search 30 / code_search 10 / graphql 4997（P1-G1・P1-G3 が並行利用のため参考値）。停止閾値 500 には到達せず
- secondary rate limit（403 / 429）: 発生なし。code search は 7 秒間隔（毎分 8.5 件以下）。リトライ不要

### G-6 署名による code search
- 疎通確認: org 内 1 本（org:anthropics path:.claude-plugin filename:marketplace.json → 13 件）と org 外 1 本（同、org 修飾なし → 39,296 件）。**422 は出なかった**。org 外も実行可能
- org 内 13 クエリ（クエリ 8 は 8a / 8b の 2 本）を anthropics と agentskills で実行。1,000 件上限に達したクエリは org 内で 0 本（>1,000 件の分割は不要）

| # | クエリ（org:anthropics を前置） | total_count | 取得 / 重複除去後 | repo 数 | agentskills |
|---|---|---|---|---|---|
| 1 | path:.claude-plugin filename:marketplace.json | 13 | 13 / 13 | 13 | 0 |
| 2 | path:.claude-plugin filename:plugin.json | 2 | 2 / 2 | 2 | 0 |
| 3 | filename:SKILL.md | 868 | 868 / 737 | 29 | 0 |
| 4 | path:hooks filename:hooks.json | 1 | 1 / 1 | 1 | 0 |
| 5 | filename:.mcp.json（境界語） | 61 | 61 / 61 | 11 | 0 |
| 6 | path:.claude/agents extension:md | 9 | 9 / 9 | 4 | 0 |
| 7 | path:.claude/skills filename:SKILL.md | 13 | 13 / 13 | 4 | 0 |
| 8a | filename:evals.json | 3 | 3 / 3 | 1 | 0 |
| 8b | path:evals | 12 | 12 / 12 | 2 | 0 |
| 9 | "claude plugin validate" | 23 | 23 / 23 | 9 | 0 |
| 10 | path:.github/workflows claude | 72 | 72 / 72 | 19 | 0 |
| 11 | filename:action.yml | 14 | 14 / 14 | 7 | 0 |
| 12 | filename:CHANGELOG.md path:plugins | 1 | 1 / 1 | 1 | 0 |

- org 外 2 クエリ: 1 は total 39,296 件、2 は 28,096 件。いずれも 1,000 件で打ち切り（**上限到達、非網羅**）。取得 1,000 件の重複除去後は 774 / 891 件、repo は計 1652。うち 100 スター以上 112 repo（別表 6）。fork 0、archived 0
- **ページ重複**: クエリ 3 は total 868 に対し取得 868 件だが重複除去後 737 件（131 件が重複）。filename: は完全一致でなく接尾辞でも当たる（greeting-SKILL.md が 7 件、marketplace.json.archived も）
- **G-1 との対応**: org 内の全ヒット repo は p1-github-structure.jsonl に存在（未対応 0）。うち G-1 で out の anthropics repo が 13 件（署名ファイルを木で確認できたのは 6 件。別表 4 と一覧の「署名ファイル群」）
- **fork / archived / 大きさの索引**（観測）: repo:anthropics/github-mcp-server（fork、★127）の README.md は 0 件、repo:gsd-build/get-shit-done と repo:anthropics/courses（archived）も 0 件、対照の repo:anthropics/skills は 14 件 → fork と archived は索引外。anthropics/claude-plugins-community の marketplace.json（1,566,683 B）はクエリ 1 に出ず、384 KB 超の索引外と整合
- **agentskills**: 13 クエリすべて 0 件。木でも署名 0 件で一致（agentskills/agentskills は SKILL.md 形式の docs と skills-ref。語(従)のみ 24 件）

### G-11 ファイルツリー（索引外の差）
- 取得: in / boundary 32 repo + G-6 に当たった out の anthropics 13 repo + R4 抜き取り 20 件 = 65 木。**truncated は全て false**、エラー 0。署名・語の抽出は Python の集計と Grep ツール（-o）の両方で行い、claude-code の署名 37 件、全 anthropics 木の marketplace.json 19 件が一致
- 索引外 = 木にあって G-6 に出ないパス（anthropics の走査済み 47 repo の合計）。**path: 修飾子は repo ルート先頭一致のように振る舞う**: path: 付きクエリの G-6 ヒットはすべてルート先頭（先頭以外のヒット 0 件）で、入れ子の該当は 1 件も出なかった

| 署名 | G-6 # | 木 | 一致 | 索引外 | うち入れ子（path: 先頭外） | うち 384 KB 超 | path: 無しで再実行後の索引外（再走査 1） |
|---|---|---|---|---|---|---|---|
| marketplace.json | 1 | 19 | 13 | 6 | 5 | 1 | 1（木 19、G-6 18） |
| plugin.json | 2 | 160 | 2 | 158 | 158 | 0 | 0（木 160、G-6 160） |
| SKILL.md | 3 | 730 | 730 | 0 | - | 0 | 0（木 730、G-6 730） |
| hooks.json | 4 | 35 | 1 | 34 | 34 | 0 | 0（木 35、G-6 35） |
| .mcp.json | 5 | 61 | 61 | 0 | - | 0 | -（未再実行） |
| .claude/agents/*.md | 6 | 13 | 9 | 4 | 4 | 0 | -（未再実行） |
| .claude/skills/*/SKILL.md | 7 | 32 | 13 | 19 | 19 | 0 | -（未再実行） |
| evals.json | 8a | 3 | 3 | 0 | - | 0 | -（未再実行） |
| evals/ | 8b | 36 | 12 | 24 | 22 | 0 | -（未再実行） |
| action.yml | 11 | 12 | 12 | 0 | - | 0 | -（未再実行） |
| CHANGELOG.md(plugins) | 12 | 1 | 1 | 0 | - | 0 | -（未再実行） |

- 初回に適用した規則: G-1 で out の repo（G-6 に当たった 13 件、R4 抜き取り 20 件）については CHANGELOG.md 単独を署名ヒットに数えなかった（該当 8 repo）。**再走査 1 では指示どおり CHANGELOG.md を署名に数える**（8 repo は candidate / boundary に変わる。初回の excluded 行は残し、追記行で再分類）
- 署名を持たない資産（語(従)のみ）は各 repo の notes に件数と上位ディレクトリ。例: claude-code の mods/（diff、telemetry、sec-default、agents-md）、plugins/plugin-dev、plugins/hookify。署名・語とも該当なし: claude-ai-mcp、claude-code-monitoring-guide、devcontainer-features、github-mcp-server
- **R4 抜き取り（スター上位 10 + 無作為 10、seed 20261013）**: 20 件中 18 件で署名ファイルに当たった（第三者 17 / 17 件、anthropics 1 / 3 件: uplifting-biomolecular-modeling（SKILL.md×1, CHANGELOG.md×2））。規則により boundary で P2-V へ（G-1 の out 基準の見直し材料。判定はしない）。別表 4

### G-5 Issues / Discussions
- 対象 32 repo（in / boundary。既定 3 repo を含む）。issue 無効: commerce-agents、github-mcp-server。ラベルは GraphQL で全件取得（claude-code 90 件、他 9〜25 件）
- 2-5 の語に当たるラベルの選び方: 語を含む（agent / skill / plugin / hook / permission / sandbox / statusline など）、境界語（mcp、agent-sdk）は境界として走査、除外語（model、cowork）は除く。`claude-code-assisted`（8 repo）は語が製品名のみなので除外。当たるラベルが無い repo: 24 repo（claude-code・claude-code-action・claude-ai-mcp・new-plugin 持ちの 3 repo 以外。agentskills は clients / awaiting-reply / distribution / auth で非該当）
- 期間は created >= 2025-06-30 の全期間を GraphQL のカーソルで走査（1,000 件上限なし）。**未走査の期間は無い**。search/issues の件数と一致（差は走査中の新規 issue 数件）

| repo | 走査したラベル: 期間内の issue 数 | author_association |
|---|---|---|
| anthropics/claude-code | area:mcp:4162(境界), area:hooks:1858, area:agents:3329, area:agent:170, area:agent-sdk:173, area:skills:1697, area:plugins:2038, area:permissions:2903, area:statusline:659, agent:1, area:sandbox:806, area:agent-view:1128 | NONE 18917, CONTRIBUTOR 7 |
| anthropics/financial-services | new-plugin:0 | - |
| anthropics/claude-plugins-official | new-plugin:0 | - |
| anthropics/knowledge-work-plugins | new-plugin:0 | - |
| anthropics/claude-code-action | area:permissions:78, mcp:40(境界) | NONE 112, CONTRIBUTOR 6 |
| anthropics/claude-ai-mcp | mcp-apps:15(境界), tool-permission:2, local-mcp-server:1(境界) | NONE 18 |

- ラベル一覧（実在名。共通 9 件 = bug, documentation, duplicate, enhancement, good first issue, help wanted, invalid, question, wontfix。以下は共通以外）: anthropics/skills（1 件）: claude-code-assisted；anthropics/claude-code（84 件）: has repro, platform:windows, api:bedrock, api:vertex, platform:macos, platform:linux, area:cost, area:tui, area:a11y, external, area:auth, area:tools, area:model, area:core, area:api, area:packaging, area:mcp, area:security, area:ide, memory, perf:memory, platform:vscode, platform:intellij, area:bash, high-priority, area:hooks, macos, user-experience, area:agents, model, platform:android, autoclose, oncall, platform:ios, area:claude-code-web, area:vscode, area:cowork, area:lsp, feature, med-priority, platform:web, needs more info, low-priority, needs-info, regression, platform:wsl, terminal, area:installation, area:agent, area:agent-sdk, area:cli, perf:cpu, area:skills, area:docs, area:plugins, area:networking, area:permissions, needs-repro, area:statusline, api:anthropic, agent, git, perf:reliability, platform:aws-bedrock, performance, area:integrations, area:ui, area:browser-extension, data-loss, feature request, area:web, area:desktop, area:sandbox, keybindings, area:chrome, area:providers, stale, claude-code-assisted, vscode, area:routines, area:agent-view, area:self-hosted-environments, reproduced, github-integration；anthropics/financial-services（2 件）: claude-code-assisted, new-plugin；anthropics/claude-plugins-official（3 件）: claude-code-assisted, new-plugin, sha-bump；anthropics/knowledge-work-plugins（2 件）: claude-code-assisted, new-plugin；anthropics/claude-code-action（16 件）: provider:1p, provider:bedrock, provider:vertex, area:permissions, area:installation, performance, dev-experience, mcp, installation, windows, experimental-review, feature-request, p1, p2, p3, claude-code-assisted；anthropics/claude-agent-sdk-python（2 件）: planned, claude-code-assisted；anthropics/sandbox-runtime（1 件）: sec:dep-vuln-fix；anthropics/commerce-agents（3 件）: dependencies, javascript, python；anthropics/claude-agent-sdk-typescript（2 件）: planned, claude-code-assisted；anthropics/claude-ai-mcp（15 件）: claude-code-assisted, triaged, fix-in-progress, server-developer-report, auth, user-report, mcp-apps, known-issue, fixed, tool-search, tool-permission, backlog, local-mcp-server, needs-more-info, reference；anthropics/healthcare（1 件）: auto-sync；agentskills/agentskills（4 件）: clients, awaiting-reply, distribution, auth
- **結果**: 走査した issue（ラベル × issue の延べ 19,060 件）のうち OWNER / MEMBER / COLLABORATOR は **0 件**（NONE 19,047、CONTRIBUTOR 13）。org の公開メンバーは無く（P1-G1）、社員の投稿は NONE と表示されるため、著者条件では告知 issue を拾えない。**条件 2 の見直しを Fable へ**。したがって issue 本文のリンク抽出は 0 件
- pinned issue: 3 件（claude-code-action #674、claude-ai-mcp #125、agentskills #255）。announcement 系カテゴリの Discussions: 5 repo に Announcements があり計 6 件（claude-code-action 2、claude-ai-mcp 2、agentskills 2。skills と claude-code-base-action は 0 件）。本文リンクは 5 種で、未知は別表 1 の 1 件

### 再走査 1（Fable 指示、2026-10-13）
- 契機: P2-V が R4 の規則を発動（G-1 で out の anthropics repo に署名ファイルがあり、code search の path: は入れ子を拾えない）。
- **変えた変数**: (1) 対象の範囲: in / boundary + 抜き取り 20 → org の全 repo（owner が anthropics で G-1 が out の 84 repo + anthropic-experimental の 2 repo = 86 repo。初回に木を取っていた 16 repo も固定 SHA で取り直し）。(2) 分類器: 語 → 木の署名と語（署名 = marketplace.json、plugin.json、SKILL.md、hooks/hooks.json、.mcp.json、.claude/agents/*.md、.claude/skills/*/SKILL.md、evals.json、CHANGELOG.md。語 = plugin / marketplace / skill / hook / eval / statusline / slash / settings / permission / sandbox / harness / headless / subagent / stream-json / .claude/ / commands/ / agents/ をパスに含む。test・agent・command・release など広すぎる語は数えない。action.yml と claude 名 workflow は署名に数えない）。(3) 補助クエリ: path: 無しの G-6 を 4 本
- **T の固定**: 各 repo の identity.tree_sha（P1-G1 の p1-github-structure.jsonl、更新後 1,433 行の各行）の SHA で git/trees/{sha}?recursive=1 を取得。85 repo はこの SHA、homebrew-claude 1 件は SHA が無く default_branch を使ったが空の repo（HTTP 409）で木なし。初回 16 repo の HEAD 時点の木と固定 SHA の木は root SHA が 16 件とも異なったが、署名のクラス別件数は 16 件とも同一（差 0）
- **結果（対象 86 repo）**: 署名あり 5 / 署名あり（CHANGELOG.md のみ）21 / 語のみ 24 / なし 35 / 木取得不能 1。署名ありの内訳は別表 4。署名あり 5 件は cookbooks、quickstarts、cwc-workshops、buffa、uplifting-biomolecular-modeling（初回の 6 件のうち action.yml のみだった anthropic-cli は CHANGELOG のみ、redis-py は語のみ）
- **truncated**: 初回 truncated=true は fermats-last-theorem（62,679 エントリ）の 1 件のみ。直下サブツリー 6 回に分割し、最終 truncated=false、未取得サブツリー 0。他は全て false
- **Grep ツールでの照合**: pinned の木 85 件に Grep（-o）を当て、SKILL.md と .claude/agents/*.md は 32 件（Python 集計と一致）、marketplace.json・plugin.json・hooks/hooks.json・.mcp.json・evals.json は 0 件、CHANGELOG.md を持つ木は 24 件（署名あり 5 件のうち 3 件 + CHANGELOG のみ 21 件）で一致
- **G-6 を path: 無しで再実行**（org:anthropics filename:…、7 秒間隔、エラー 0）: plugin.json は total 160 で木の 160 と一致、hooks.json は 35 で木の 35 と一致、marketplace.json は 18 で木の 19 との差 1 件（claude-plugins-community の 1,566,683 B。384 KB 超）、SKILL.md は total 868（重複除去後 737、exact 730 で木の 730 と一致、偽陽性 7）。**path: を外すと入れ子も拾え、索引外は 384 KB 超の 1 件のみ**。なお archived・fork の repo にはこの 4 種の署名ファイルが無く、この 4 本では archived・fork の索引外を再観測できない（README.md の直接検査は初回に 0 件）
- **残った未走査**: 第三者 org の out repo の木（更新後の構造ファイルで 915 repo。初回の抜き取り 17 件を除く。R4 の抜き取りは初回の out 483 件から引いたもので、母集団は 1,001 件に増えている）、agentskills org の out repo（.github）1 件、path: 無しの再実行を行っていないクエリ（.mcp.json は初回から path 無し。.claude/agents・.claude/skills・evals・action.yml・CHANGELOG の 5 種は未再実行。ただし 86 repo の木の全件照合で入れ子の署名は拾えている）、署名ありの repo 内の語のみ該当パスの個別列挙（件数と上位 dir のみ）

### G-4 wiki
- 対象 21 repo（in / boundary で has_wiki=true）。**全件 clone 失敗（remote: Repository not found）= 内容無し**。ページ数 0。別表 5
- 手順の注記: 既定の資格情報（Git Credential Manager。username が別アカウントに固定）では未作成 wiki が 401 になり判別できなかったため、`gh auth git-credential` で認証して clone した（最初の 3 回の試行は CRLF 混入、GIT_ASKPASS 指定、username 競合で失敗。結果には影響しない）。clone 先は scratchpad の github-wiki/（中身なし）

### 未走査の範囲
- G-6: org 外 2 クエリは上位 1,000 件のみ（total 39,296 / 28,096）。G-9 の追加 org は対象外（指示は anthropics と agentskills）
- G-11: 再走査 1 で anthropics と anthropic-experimental の out 86 repo は全件取得。残りは第三者 org の out repo（915）と agentskills の out repo 1 件（再走査 1 の節）
- G-5: 2-5 の語に当たらないラベルの issue、PR、issue 無効の 2 repo。author_association が OWNER / MEMBER / COLLABORATOR 以外の issue は条件により列挙しない
- G-4: 無し（21 件完了）。C4: catalog の全文は mcp__fetch__fetch で取らず（541,710 B）、先頭 600 文字の取得と、repo 上の同ファイル（SchemaStore/schemastore の src/api/json/catalog.json、blob 98737ec）を gh api で取得して Grep で抽出。両者の全文一致は未確認

## 別表 1. G-5 で見つかったリンク先のうち未知

「既知集合」= p1-github-structure.jsonl の repo 集合 + L1 ドメインの存在（p1-docs.md は読めないため、docs のパス単位の照合は P2-R）。

| リンク先 | 出現 | 元 | 判定 |
|---|---|---|---|
| https://platform.claude.com/docs/en/agents-and-tools/mcp-connector | 1 | claude-ai-mcp Discussion #92（2026-03-10） | 未知（パス単位）。ドメインは L1 候補。mcp は境界語 |
| 既知: anthropics/claude-code/issues/11482、anthropics/claude-code-base-action/、agentskills/agentskills の discussions カテゴリ 2 件 | 4 | pinned #674、Discussion #286、#273 | 既知 repo 内（資産ではない） |

## 別表 2. C9 予約 Marketplace 名と実体の対応

根拠: 各 repo の .claude-plugin/marketplace.json の name 欄を gh api で取得（14 ファイル）、code search（org:anthropics 付き / 非限定）、G-1 の repo 名。

| 予約名 | 実体の区分 | 実体 | code search（scoped / 非限定） |
|---|---|---|---|
| claude-code-marketplace | 文字列のみ出現 | anthropics/claude-code の marketplace.json 内に 1 回（name は claude-code-plugins） | 1 / 2288 |
| claude-code-plugins | 実体あり | anthropics/claude-code（marketplace.json の name=claude-code-plugins） | 2 / 141 |
| claude-plugins-official | 実体あり | anthropics/claude-plugins-official（marketplace.json の name=claude-plugins-official） | 2 / 146 |
| anthropic-marketplace | 実体不明 | - | 0 / 0 |
| anthropic-plugins | 実体不明 | - | 0 / 0 |
| agent-skills | 文字列のみ出現 | claude-plugins-official ほか 3 repo の marketplace.json 内（名前でなく語として出現） | 3 / 1046 |
| anthropic-agent-skills | 実体あり | anthropics/skills（marketplace.json の name=anthropic-agent-skills） | 1 / 39 |
| life-sciences | 実体あり | anthropics/life-sciences（marketplace.json の name=life-sciences） | 1 / 28 |
| knowledge-work-plugins | 実体あり | anthropics/knowledge-work-plugins（marketplace.json の name=knowledge-work-plugins） | 1 / 15 |
| claude-for-legal | 実体あり | anthropics/claude-for-legal（marketplace.json の name=claude-for-legal） | 1 / 12 |
| claude-for-financial-services | 実体あり | anthropics/financial-services（marketplace.json の name=claude-for-financial-services） | 1 / 11 |
| financial-services-plugins | 実体不明 | - | 0 / 4 |
| first-party-plugins | 実体不明 | - | 0 / 0 |
| claude-tag-plugins | 実体あり | anthropics/claude-tag-plugins（marketplace.json の name=claude-tag-plugins） | 1 / 1 |
| claude-community | 実体あり | anthropics/claude-plugins-community（marketplace.json の name=claude-community） | 0 / 5 |
| claude-plugins-community | repo 名のみ一致 | anthropics/claude-plugins-community（marketplace 名は claude-community） | 0 / 3 |
| healthcare | 実体あり | anthropics/healthcare（marketplace.json の name=healthcare） | 1 / 107 |
| anthropic-plugin-directory | 実体不明 | - | 0 / 0 |
| claude-plugin-directory | 実体不明 | - | 0 / 0 |

- 実体あり 10 / repo 名のみ一致 1 / 文字列のみ出現 2 / 実体不明 6。marketplace.json の owner.name が Anthropic でないもの: financial-services（個人名（マスク））、skills（個人名（マスク））。予約名でない marketplace 名: claude-for-financial-advisors、claude-commerce-agents、k12-teacher-skills、oncall-kit-marketplace

- 範囲の閉じ方: p1-local.md 別表 1 のうち具体名の 19 件（公式 14、コミュニティ 3、Plugin directory 2）を対象にした。なりすまし例、非 marketplace 由来の名前（inline、builtin、synced など）、ツール名、JS メンバー名、claudeai- 接頭辞、DL フォルダ名は規則の区分または例示で marketplace の実体を持たないため対象外

## 別表 3. C4 SchemaStore の該当エントリと claude-code-settings.json の出所

catalog.json の name / description / url に claude か anthropic を含むのは 5 件のみ（Grep -i）。url はいずれも schemastore.org 配下（第三者ホスト）。ホスト自体は 1-2(a)(b) を満たさず L1 でない。

| catalog の name | 初出 PR / 投稿者（author_association） | 投稿者の所属表示 | 判定（仮。決めるのは Fable） |
|---|---|---|---|
| Claude Code Settings | [PR 4798](https://github.com/SchemaStore/schemastore/pull/4798) user-88、2025-06-17（CONTRIBUTOR） | @moon | out（個人投稿）。boundary で回す |
| Claude Code Plugin Manifest | [PR 5603](https://github.com/SchemaStore/schemastore/pull/5603) user-25、2026-04-23（CONTRIBUTOR） | @anthropics  | L3 候補（自己申告のみ）。boundary |
| Claude Code Plugin Marketplace | [PR 5603](https://github.com/SchemaStore/schemastore/pull/5603) user-25、2026-04-23（CONTRIBUTOR） | @anthropics  | 同上 |
| Claude Code Keybindings | [PR 5325](https://github.com/SchemaStore/schemastore/pull/5325) antrewmorrison、2026-02-02（CONTRIBUTOR） | なし | out（個人投稿）。boundary |
| Claude Code Launch Preview | [PR 6132](https://github.com/SchemaStore/schemastore/pull/6132) pragmabits、2026-07-27（CONTRIBUTOR） | なし | out（個人投稿）。boundary |

- claude-code-settings.json: SchemaStore/schemastore の src/schemas/json/claude-code-settings.json（commit fc9037b、PR #4798「Add Claude Code settings.json schema」、2025-06-17、投稿者 user-88 はプロフィール上 company=@moon）。全 40 commit、最新 2026-10-08。$id は https://json.schemastore.org/claude-code-settings.json、description に code.claude.com の docs へのリンクがある。**Anthropic 公開とは確認できない**（orgs/anthropics/members/{login} は 5 人とも 404）。anthropics/claude-code の木で名称に schema を含むパスは plugins/plugin-dev/skills/hook-development/scripts/validate-hook-schema.sh のみ（Grep）で、本体側のスキーマファイルは見つからない
- plugin.json / marketplace.json のスキーマは PR #5603（user-25、プロフィールは company=@anthropics と自己申告、2026-04-23）で追加。M1 により、docs からのリンクだけでは L1 にしない

## 別表 4. R4 抜き取り検査と org の全 out repo の印（再走査 1 で更新）

- 初回の R4（G-1 の out 483 件から スター上位 10 + 無作為 10、seed 20261013）: 署名ありは 20 件中 18 件（第三者 17 / 17、anthropics 1 / 3 = uplifting-biomolecular-modeling の SKILL.md×1）。第三者の署名あり: affaan-m/ECC（★277686）、NousResearch/hermes-agent（★253033）、DietrichGebert/ponytail（★161674）、farion1231/cc-switch（★143254）、morluto/rea（★142241）、nextlevelbuilder/ui-ux-pro-max-skill（★135088）、Graphify-Labs/graphify（★125792）、JuliusBrussee/caveman（★111186）、addyosmani/agent-skills（★105437）、paperclipai/paperclip（★100792）、davila7/claude-code-templates（★32580）、browser-act/skills（★6133）、kharmanskyi/open-steps（★1282）、justxor/claude-code-pro-course（★290）、Bande-a-Bonnot/Boucle-framework（★125）、wakatime/claude-code-wakatime（★94）、sheeki03/Few-Word（★38）。第三者の agent-skills 系に署名があるのは当然で、基準見直しの信号は anthropics 側。規則により boundary で P2-V へ（判定はしない）

| 印（再走査 1。86 repo） | 件数 | repo（署名ありは署名の件数） |
|---|---|---|
| 署名あり | 5 | claude-cookbooks（SKILL.md×4, .claude/agents/*.md×3, .claude/skills/*/SKILL.md×1）、claude-quickstarts（SKILL.md×11, .claude/skills/*/SKILL.md×3, CHANGELOG.md×1）、cwc-workshops（SKILL.md×11, .claude/skills/*/SKILL.md×8）、buffa（.claude/agents/*.md×2, CHANGELOG.md×1）、uplifting-biomolecular-modeling（SKILL.md×1, CHANGELOG.md×2） |
| 署名あり（CHANGELOG.md のみ） | 21 | anthropic-sdk-python、anthropic-sdk-typescript、anthropic-sdk-go、anthropic-cli、anthropic-sdk-java、anthropic-sdk-ruby、anthropic-sdk-csharp、ClaudeForFoundationModels、anthropic-sdk-php、orjson(fork)、rclone(fork)、s5cmd、tokio(fork)、httpcore(fork)、argo-cd(fork)、torchtyping(fork)、sse-starlette(fork)、raft-rs(fork)、leptos-chartistry(fork)、serde-saphyr(fork)、snix |
| 語のみ | 24 | prompt-eng-interactive-tutorial、courses、claudes-c-compiler、jacobian-lens、fermats-last-theorem、evals、ConstitutionalHarmlessnessPaper、PySvelte、anthropic-retrieval-demo、automated-auditing、political-neutrality-eval、riv2025-long-horizon-coding-agent-demo、cargo-nix-plugin、scone-bench、swift-markdown-ui(fork)、maestro(fork)、swift-markdown(fork)、redis-py、beam(fork)、terragrunt(fork)、riegeli-rs(fork)、nix-eval-jobs(fork)、xls(fork)、OpenROAD-flow-scripts |
| なし | 35 | original_performance_takehome、claude-desktop-buddy、hh-rlhf、oss-scanner、html-effectiveness、agentic-misalignment、anthropic-tools、formal-math、toy-models-of-superposition、sleeper-agents-paper、claude-constitution、mythos-5-incident-transcript、anthropic-tokenizer-typescript、attribution-graphs-frontend、cryptography-research-demo、anthropic-bedrock-python、headvis、homebrew-tap、DecompositionFaithfulnessPaper、anthropic-bedrock-typescript、triton(fork)、model-cards、sycophancy-to-subterfuge-paper、apitools(fork)、tailscale-hint-extension、hypercorn(fork)、rogue-deploy-eval、python-tblib(fork)、blobfile、cfaulthandler(fork)、mockturtle、rayon(fork)、axt-verify、amulet2、claude-tag-wif-gateway-sample |
| 木取得不能 | 1 | homebrew-claude（空の repo、HTTP 409） |

- 初回に G-6 で当たった out の anthropics repo 13 件との対応: 署名あり 4 件（cookbooks、quickstarts、cwc-workshops、buffa）、CHANGELOG のみ 8 件（anthropic-sdk-* 6 件、ClaudeForFoundationModels、anthropic-cli）、語のみ 1 件（redis-py）。署名あり 5 件目の uplifting-biomolecular-modeling は初回の R4 経由。固定 SHA の木と初回の木でクラス別件数の差は無い

## 別表 5. G-4 wiki の内容の有無

対象 21 repo（has_wiki=true）は全件 wiki_has_content=false、wiki_pages=0（clone が Repository not found）。

| repo（anthropics/） | repo | repo |
|---|---|---|
| financial-services | knowledge-work-plugins | claude-for-legal |
| claude-code-action | defending-code-reference-harness | claude-code-security-review |
| claude-plugins-community | claude-agent-sdk-demos | claude-agent-sdk-typescript |
| launch-your-agent | claude-code-base-action | code-migration-kit-with-claude-code |
| cwc-long-running-agents | life-sciences | k12-teacher-skills |
| healthcare | claude-code-monitoring-guide | oncall-kit |
| claude-code-playground | agent-sdk-workshop | claude-tag-plugins |

## 別表 6（補足）. G-6 org 外の L3 候補（100 スター以上、上位 10。全 112 repo は JSONL の G-6 項目の notes と scratchpad の g6/l3.json）

| repo | ★ | repo | ★ |
|---|---|---|---|
| dontbesilent2025/dbskill | 10625 | 21st-dev/magic-mcp | 5998 |
| SummerSec/ShiroAttack2 | 2635 | tanweai/wooyun-legacy | 1778 |
| actionbook/actionbook | 1613 | dvdsgl/claude-canvas | 1512 |
| mohitagw15856/pm-claude-skills | 1440 | MaJerle/c-code-style | 1353 |
| AvdLee/Diagnostics | 1310 | mozilla-ai/cq | 1283 |
