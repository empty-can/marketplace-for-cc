# P1-C: CHANGELOG / Releases / レジストリ（W-4, W-5）

- claude --version（開始時）: 2.1.296 (Claude Code)。取得時刻: 2026-10-13T01:18:55+09:00
- claude --version（終了時）: 2.1.296 (Claude Code)。取得時刻: 2026-10-13T01:48:48+09:00
- 取得元 CHANGELOG: anthropics/claude-code main の CHANGELOG.md, blob sha e0d7e4b305a2faeeb774e64c67a389dcf3f27794（2.1.296。8789 行、版見出し 418）。npm 最新 2.1.296 と一致
- 注意: CHANGELOG に日付は無い。日付は npm registry の `time`（publish 時刻）で、GitHub Release の日付とは数十分ずれうる（例: 2.1.118 は npm 2026-04-22T23:48Z、Release 2026-04-23T00:42Z）

since: 2025-06-30（根拠: hooks の初出 1.0.38。CHANGELOG L8439「Released hooks」。npm publish 時刻 2025-06-30T20:29:03Z）

## since と各機能の初出の表

| 機能 | 初出の版 | 日付（npm publish） | CHANGELOG の該当行（blob e0d7e4b3 の行番号） |
|---|---|---|---|
| **hooks（Hooks）** | 1.0.38 | 2025-06-30 | L8439: Released hooks. Special thanks to community input in .../issues/712. Docs: https://code.claude.com/docs/en/hooks |
| **statusline（/statusline）** | 1.0.71 | 2025-08-07 | L8263: Customizable status line: add your terminal prompt to Claude Code with /statusline |
| **skills（Claude Skills）** | 2.0.20 | 2025-10-16 | L7984: Added support for Claude Skills |
| **Plugin system / marketplace（/plugin, /plugin marketplace, extraKnownMarketplaces）** | 2.0.12 | 2025-10-09 | L8021: **Plugin System Released**: Extend Claude Code with custom commands, agents, hooks, and MCP servers from marketplaces |
| /plugin validate → claude plugin validate | 2.0.12 | 2025-10-09 | L8024: `/plugin validate` command for validating plugin structure and configuration |
| claude plugin tag | 2.1.118 | 2026-04-22 | L5571: Added `claude plugin tag` to create release git tags for plugins with version validation |
| claude plugin eval | 2.1.269 | 2026-09-11 | L2119: Added `claude plugin eval`: run a plugin's eval suite against Claude Code and get scored, reproducible results (JSON + HTML report) |
| /skill-doctor | 2.1.261 | 2026-09-04 | L2439: Added `/skill-doctor` to show which loaded skills go unused and what they cost in context, so you can prune them |
| Claude Mods（mods） | 2.1.287 | 2026-10-01 | L712: Added Claude Mods: plugins may now modify deeper behavior |
| claude plugin test / mods テストキット claude-code/testing | 2.1.288 | 2026-10-02 | L708: Fixed `claude plugin test` reporting mods as turned off remotely when it had only read an out-of-date saved setting |
| --plugin-dir | 2.1.74 | 2026-03-11 | L6573: Changed `--plugin-dir` so local dev copies now override installed marketplace plugins with the same name |
| $schema の受理（plugin.json / marketplace.json / hooks.json） | 2.1.120 | 2026-04-24 | L5492: `claude plugin validate` now accepts `$schema`, `version`, and `description` at the top level of `marketplace.json` and `$schema` in `plugin.json` |
| claude plugin サブコマンド群（init / prune / details / configure / uninstall 等） | 2.1.47 | 2026-02-18 | L7039: 初出の版: update 2.1.97, marketplace add 2.1.117, prune 2.1.121, install/details 2.1.139, list 2.1.140, enable/disable 2.1.143, init 2.1.157, eval 2.1.269, marketplace update/list 2.1.275, uninstall 2.1.281, configure 2.1.285, test 2.1.288（validate は 2.1.47 で言及） |
| subagents（/agents） | 1.0.60 | 2025-07-24 | L8322: You can now create custom subagents for specialized tasks! Run /agents to get started |
| custom slash commands（.claude/commands/） | 0.2.31 | 2025-03-05 | L8772: Custom slash commands: Markdown files in .claude/commands/ directories now appear as custom slash commands |
| headless / print mode（-p, --output-format stream-json） | 0.2.59 | 2025-04-02 | L8715: Bugfixes for non-interactive mode (-p)（stream-json 対応は 0.2.66 L8698） |
| sandbox（/sandbox, sandbox 設定） | 2.0.24 | 2025-10-20 | L7964: Sandbox: Releasing a sandbox mode for the BashTool on Linux & Mac |
| Claude Code SDK → Claude Agent SDK | 2.0.0 | 2025-09-29 | L8083: SDK: The Claude Code SDK is now the Claude Agent SDK |
| output styles | 1.0.81 | 2025-08-14 | L8234: Released output styles, including new built-in educational output styles |

R10 の 4 機能（太字）の最古は hooks（1.0.38, 2025-06-30）。statusline 2025-08-07、plugin 2025-10-09、skills 2025-10-16 はこれより新しい。GitHub Releases / tags は v2.0.73（2025-12-19）以降しか無く、since の根拠にできない（追加走査で確認）。

## 登録簿（status が candidate の行。範囲判定『境界』を含む）

| ID | 名称 | URL（最終 URL） | 種別・権威 | 権威の対象 | 活動と範囲判定 | 発見チャネル | 一次確認（取得日、SHA か version） |
|---|---|---|---|---|---|---|---|
| P1-C-001 | anthropics/claude-code CHANGELOG.md | https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md | 情報源 / L1 | 変更履歴 | 開発・テスト・配布 / 内 | W-4 | 2026-10-13、mcp__github__get_file_contents（base64 を python で復号）、blob sha e0d7e4b3, 2.1.296, 8789 行, 版見出し 418 |
| P1-C-002 | anthropics/claude-code GitHub Releases | https://github.com/anthropics/claude-code/releases | 情報源 / L1 | 変更履歴 | 開発・テスト・配布 / 内 | W-4 | 2026-10-13、gh api repos/anthropics/claude-code/releases?per_page=100 --paginate（GET）、241 件。最古 v2.0.73 2025-12-19T00:59:32Z、最新 v2.1.296 2026-10-09T19:28:59Z。tags 245 件 |
| P1-C-003 | Claude Code changelog（docs ページ） | https://code.claude.com/docs/en/changelog.md | 情報源 / L1 | 変更履歴 | 開発 / 内 | W-4 | 2026-10-13、mcp__fetch__fetch code.claude.com/docs/llms.txt、llms.txt 61,821 文字・268 ページ中に掲載。ページ本文は未取得 |
| P1-C-004 | hooks（Hooks） | https://code.claude.com/docs/en/hooks.md | 資産 / L1 | 挙動 | 開発・テスト / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt)、CHANGELOG blob e0d7e4b3 v1.0.38 L8439。日付 2025-06-30 は npm publish 時刻 |
| P1-C-005 | statusline（/statusline） | https://code.claude.com/docs/en/statusline.md | 資産 / L1 | 挙動 | 開発 / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt)、CHANGELOG blob e0d7e4b3 v1.0.71 L8263。日付 2025-08-07 は npm publish 時刻 |
| P1-C-006 | skills（Claude Skills） | https://code.claude.com/docs/en/skills.md | 資産 / L1 | 挙動 | 開発 / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt)、CHANGELOG blob e0d7e4b3 v2.0.20 L7984。日付 2025-10-16 は npm publish 時刻 |
| P1-C-007 | Plugin system / marketplace（/plugin, /plugin marketplace, extraKnownMarketplaces） | https://code.claude.com/docs/en/plugins/overview.md | 資産 / L1 | 挙動 | 開発・配布 / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt)、CHANGELOG blob e0d7e4b3 v2.0.12 L8021。日付 2025-10-09 は npm publish 時刻 |
| P1-C-008 | /plugin validate → claude plugin validate | https://code.claude.com/docs/en/plugins/cli-reference.md | 資産 / L1 | 挙動 | テスト・配布 / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt)、CHANGELOG blob e0d7e4b3 v2.0.12 L8024。日付 2025-10-09 は npm publish 時刻 |
| P1-C-009 | claude plugin tag | https://code.claude.com/docs/en/plugins/cli-reference.md | 資産 / L1 | 挙動 | 配布 / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt) + ローカル llms-full.txt の Grep（本文）、CHANGELOG blob e0d7e4b3 v2.1.118 L5571。日付 2026-04-22 は npm publish 時刻 |
| P1-C-010 | claude plugin eval | https://code.claude.com/docs/en/plugin-evals.md | 資産 / L1 | 挙動 | テスト / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt)、CHANGELOG blob e0d7e4b3 v2.1.269 L2119。日付 2026-09-11 は npm publish 時刻 |
| P1-C-011 | /skill-doctor | https://code.claude.com/docs/en/skills.md | 資産 / L1 | 挙動 | テスト / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt) + ローカル llms-full.txt の Grep（本文）、CHANGELOG blob e0d7e4b3 v2.1.261 L2439。日付 2026-09-04 は npm publish 時刻 |
| P1-C-012 | Claude Mods（mods） | https://code.claude.com/docs/en/plugins/mods/overview.md | 資産 / L1 | 挙動 | 開発 / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt)、CHANGELOG blob e0d7e4b3 v2.1.287 L712。日付 2026-10-01 は npm publish 時刻 |
| P1-C-013 | claude plugin test / mods テストキット claude-code/testing | https://code.claude.com/docs/en/plugins/mods/test.md | 資産 / L1 | 挙動 | テスト / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt)、CHANGELOG blob e0d7e4b3 v2.1.288 L708。日付 2026-10-02 は npm publish 時刻 |
| P1-C-014 | --plugin-dir | https://code.claude.com/docs/en/plugins/cli-reference.md | 資産 / L1 | 挙動 | 開発・テスト / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt)、CHANGELOG blob e0d7e4b3 v2.1.74 L6573。日付 2026-03-11 は npm publish 時刻 |
| P1-C-015 | $schema の受理（plugin.json / marketplace.json / hooks.json） | https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md#21120 | 資産 / L1 | 挙動 | 開発・テスト / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt) + ローカル llms-full.txt の Grep（本文）、CHANGELOG blob e0d7e4b3 v2.1.120 L5492。日付 2026-04-24 は npm publish 時刻 |
| P1-C-016 | claude plugin サブコマンド群（init / prune / details / configure / uninstall 等） | https://code.claude.com/docs/en/plugins/cli-reference.md | 資産 / L1 | 挙動 | 開発・配布 / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt)、CHANGELOG blob e0d7e4b3 v2.1.47 L7039。日付 2026-02-18 は npm publish 時刻 |
| P1-C-017 | subagents（/agents） | https://code.claude.com/docs/en/sub-agents.md | 資産 / L1 | 挙動 | 開発 / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt)、CHANGELOG blob e0d7e4b3 v1.0.60 L8322。日付 2025-07-24 は npm publish 時刻 |
| P1-C-018 | custom slash commands（.claude/commands/） | https://code.claude.com/docs/en/commands.md | 資産 / L1 | 挙動 | 開発 / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt)、CHANGELOG blob e0d7e4b3 v0.2.31 L8772。日付 2025-03-05 は npm publish 時刻 |
| P1-C-019 | headless / print mode（-p, --output-format stream-json） | https://code.claude.com/docs/en/headless.md | 資産 / L1 | 挙動 | テスト / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt)、CHANGELOG blob e0d7e4b3 v0.2.59 L8715。日付 2025-04-02 は npm publish 時刻 |
| P1-C-020 | sandbox（/sandbox, sandbox 設定） | https://code.claude.com/docs/en/sandboxing.md | 資産 / L1 | 挙動 | テスト / 内 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt)、CHANGELOG blob e0d7e4b3 v2.0.24 L7964。日付 2025-10-20 は npm publish 時刻 |
| P1-C-021 | Claude Code SDK → Claude Agent SDK | https://code.claude.com/docs/en/agent-sdk/migration-guide.md | 資産 / L1 | 挙動 | 開発 / 境界 | W-4 | 2026-10-13、CHANGELOG 走査 + mcp__fetch__fetch(llms.txt)、CHANGELOG blob e0d7e4b3 v2.0.0 L8083。日付 2025-09-29 は npm publish 時刻 |
| P1-C-023 | @anthropic-ai/claude-code | https://www.npmjs.com/package/@anthropic-ai/claude-code | 資産 / L1 | 挙動・参照実装 | 開発・テスト・配布 / 内 | W-5 | 2026-10-13、mcp__fetch__fetch registry.npmjs.org search（maintainer:user-92 ほか 2 名）、@anthropic-ai/claude-code@2.1.296 (npm search date 2026-10-09) |
| P1-C-032 | @anthropic-ai/claude-agent-sdk | https://www.npmjs.com/package/@anthropic-ai/claude-agent-sdk | 資産 / L1 | 挙動・参照実装 | 開発 / 境界 | W-5 | 2026-10-13、mcp__fetch__fetch registry.npmjs.org search（maintainer:user-92 ほか 2 名）、@anthropic-ai/claude-agent-sdk@0.3.296 (npm search date 2026-10-09) |
| P1-C-049 | @anthropic-ai/mcpb | https://www.npmjs.com/package/@anthropic-ai/mcpb | 資産 / L1 | 参照実装 | 開発 / 境界 | W-5 | 2026-10-13、mcp__fetch__fetch registry.npmjs.org search（maintainer:user-92 ほか 2 名）、@anthropic-ai/mcpb@2.1.2 (npm search date 2025-12-04) |
| P1-C-050 | @anthropic-ai/sandbox-runtime | https://www.npmjs.com/package/@anthropic-ai/sandbox-runtime | 資産 / L1 | 参照実装 | テスト / 境界 | W-5 | 2026-10-13、mcp__fetch__fetch registry.npmjs.org search（maintainer:user-92 ほか 2 名）、@anthropic-ai/sandbox-runtime@0.0.79 (npm search date 2026-10-07) |
| P1-C-051 | @anthropic-ai/claude-trace | https://www.npmjs.com/package/@anthropic-ai/claude-trace | 資産 / L1 | 参照実装 | テスト / 境界 | W-5 | 2026-10-13、mcp__fetch__fetch registry.npmjs.org search（maintainer:user-92 ほか 2 名）、@anthropic-ai/claude-trace@0.1.2 (npm search date 2025-12-15) |
| P1-C-058 | PyPI organization: Anthropic, PBC. | https://pypi.org/org/anthropic/ | 情報源 / L1 | 参照実装 | 開発 / 内 | W-5 | 2026-10-13、WebFetch pypi.org/org/anthropic/（prompt 抽出）、掲載: claude-code, anthropic, claude, claude-agent-sdk, claude-sdk, claude-code-sdk |
| P1-C-059 | claude-agent-sdk | https://pypi.org/project/claude-agent-sdk/ | 資産 / L1 | 参照実装 | 開発 / 境界 | W-5 | 2026-10-13、WebFetch pypi.org/pypi/claude-agent-sdk/json（prompt 抽出。先頭 100,000 文字のみ読了）、version 0.2.165 |
| P1-C-061 | claude-code-sdk | https://pypi.org/project/claude-code-sdk/ | 資産 / L1 | 参照実装 | 開発 / 境界 | W-5 | 2026-10-13、WebFetch pypi.org/pypi/claude-code-sdk/json（prompt 抽出。先頭 100,000 文字のみ読了）、version 0.0.25 |
| P1-C-065 | anthropics/claude-agent-sdk-python | https://github.com/anthropics/claude-agent-sdk-python | 資産 / L1 | 参照実装 | 開発 / 境界 | W-5 | 2026-10-13、mcp__github__search_repositories（org:anthropics language:python） + gh api repos/anthropics/claude-code-sdk-python、検索 total_count 29 中の 1 件。stars 8254, pushed 2026-10-09 |
| P1-C-070 | anthropics/claude-code tags | https://github.com/anthropics/claude-code/tags | 情報源 / L1 | 変更履歴 | 開発・配布 / 内 | W-4 | 2026-10-13、gh api repos/anthropics/claude-code/tags?per_page=100 --paginate（GET）、245 件。最古 v2.0.73、最新 v2.1.296。CHANGELOG の版 418 中 239 に tag |
| P1-C-113 | claude-code | https://www.npmjs.com/package/claude-code | 資産 / out | 参照実装 | 開発 / 境界 | W-5 | 2026-10-13、mcp__fetch__fetch registry.npmjs.org search（追加走査）、claude-code@1.0.0 (npm search date 2025-10-15) |

## 件数表（採用 = status candidate かつ範囲判定『内』の仮判定。最終判定は Fable / 作業指示者）

| チャネル | 列挙 | 採用 | 除外 | 未確認 | 境界 |
|---|---|---|---|---|---|
| W-4 CHANGELOG / Releases / docs changelog | 23 | 21 | 1 | 0 | 1 |
| W-5 npm / PyPI（Python リポジトリ逆引きを含む） | 90 | 2 | 80 | 0 | 8 |
| 合計 | 113 | 23 | 81 | 0 | 9 |

除外の内訳（一覧は JSONL のみ）: MCP 系 @modelcontextprotocol/* 38（B4: L2、範囲外・監視済み）、Anthropic ドメインの maintainer を持たない第三者 4、プラットフォーム別バイナリ 16、API クライアント SDK 10、名前予約 / placeholder 9、PyPI 側が anthropics org を指さない / 不在 3、2-5 の語に当たらない 1。合計 81

## 走査の記録

**フィルタ基準**: 計画書 2-5 の語。CHANGELOG は大文字小文字を無視した awk で語ごとのヒット数と最古ヒットの版・行を取った。ヒット数: hook 349, status line 52, skill 262, plugin 545, marketplace 149, validate 39, eval 9, mod 58, --plugin-dir 17, subagent 277, slash command 121, $schema/schemastore 2, skill-doctor 1, plugin directory 7, plugin tag 1, sandbox 134, headless 67, stream-json 26, agent sdk 22, settings.json 71, claude plugin 83, 署名ファイル名 32, testing / test kit 0。

**取得手段の制約（gh が使えなかった）**: `gh api` は『You are not logged into any GitHub hosts』で失敗した（権限拒否ではなく未認証）。そのため CHANGELOG は mcp__github__get_file_contents（base64、987,162 バイト）を python -I で scratchpad に復号して走査し、Releases は mcp__fetch__fetch で api.github.com の GET を 1 件ずつ取った（--paginate は不可）。

**未走査の範囲（初回走査時点。解消・縮小した項目は次の『追加走査』節）**:
- CHANGELOG の全行精読はしていない（語ごとの最古ヒットと最新 2〜3 件、サブコマンド・hook イベント名の初出、docs URL の全抽出のみ）。新しい版で追加された機能の取りこぼしがありうる
- GitHub Releases の本文の個別走査、最古の Release の特定、CHANGELOG との同一性の照合（v2.1.296 と v2.1.118 が存在することだけ確認。v1.0.38 / v1.0.71 / v2.0.12 / v2.0.20 は Release も tag も無い）
- docs ページ本文: mods/test.md だけ本文を確認。他は llms.txt の題名と説明文での存否判断で、本文中の記載（例: cli-reference.md の validate / tag）は未確認。code.claude.com の changelog ページ本文と GitHub 版の差分も未照合
- npm: `scope:anthropic-ai` は npm search で有効な修飾子ではなく、指定どおりの URL は無関係な fuzzy 結果（nanoid, @ai-sdk/* 等）を返した（90,000 文字で打切り。@anthropic-ai/* は混入 2 件のみ）。代替として `maintainer:` 検索（user-92, user-69, user-67）を実行し、3 件とも同一の 35 件（total 35）を得た。他の maintainer 名（user-92, user-28, user-11, user-62, user-29, user-46 ほか）での検索は未実施で、この 35 件に載らない Anthropic 発パッケージが残る可能性がある
- PyPI: 各 JSON は WebFetch の先頭 100,000 文字のみ読了（upload_time は claude-code-sdk のみ取得）。逆引きは org:anthropics の Python リポジトリ 29 件（total_count 29）から claude-agent-sdk と anthropic のみ対応づけ。PySvelte, anthropic-tools, blobfile は PyPI 側を取得していない。claude-code-sdk の Homepage（anthropics/claude-code-sdk-python）は 29 件に無い
- `claude-code/testing`: docs の本文では存在を確認（plugins/mods/test.md）。同梱の実体（バイナリ内）は未確認。npm の別パッケージとしては、取得した manifest の範囲に exports / testing の文字列が無い

**CHANGELOG 本文に現れた GitHub の owner（P2-V の owner 集合用）**: anthropics のみ（github.com/anthropics/claude-code 1 件、`anthropics/claude-code#N` 形式の参照 59 件）。他に GitHub の owner は無い。同本文のホストは code.claude.com 13, www.anthropic.com 5, claude.ai 3, platform.claude.com 1, claude.com 1, downloads.claude.ai 1, storage.googleapis.com 1, github.com 1。npm のパッケージ名は @anthropic-ai/claude-code, @anthropic-ai/claude-agent-sdk、`pip install claude-code-sdk` が各 1 件。

**レジストリ由来の owner / 名前**: GitHub org anthropics（npm repository: anthropic-sdk-typescript, claude-agent-sdk-typescript, sandbox-runtime, anthropic-tokenizer-typescript。PyPI project_urls: claude-agent-sdk-python, anthropic-sdk-python, claude-code-sdk-python）。GitHub ユーザー user-07（Releases の author）。npm の publisher: GitHub Actions, user-63, user-41, user-39, user-92, danrigsby（無 scope の anthropic）, pacifier136（napi 名前予約）。

**npm maintainers の和集合（35 件のパッケージ全体、17 名）**: user-92, user-28, user-11, user-62, user-29, user-46, user-67, user-69, user-22, user-63, user-82, user-90, user-59, user-31, user-41, user-53, user-45

**R6 の結果**: @anthropic-ai 以外で Anthropic の maintainer を持つパッケージは 6 件（無 scope の anthropic と、名前予約の *-napi 5 件）。PyPI の organization ページ（https://pypi.org/org/anthropic/）は存在し、6 プロジェクトを掲載。

**権限拒否**: 無し。

## 追加走査（Fable 指示、gh 認証後、2026-10-13）

gh は account empty-can でログイン済み（実施 2026-10-13T01:44:02+09:00 以降）。

**1. Releases / tags の全件**（`gh api ... --paginate`、releases.json 3.6 MB、tags.json）: Releases は 241 件（draft 0、prerelease 0、本文が空 6）。最古 v2.0.73（2025-12-19T00:59:32Z）、最新 v2.1.296（2026-10-09T19:28:59Z）。author は user-07 のみ。tags は 245 件で、最古は同じ v2.0.73、最新 v2.1.296。Release も tag も v2.0.73 以降にしか無く、hooks / statusline / plugin / skills の初出は Release では特定できない。**since は変更なし**（npm time が唯一の日付源）。
- CHANGELOG の版 418 のうち tag があるのは 239、Release があるのは 236。CHANGELOG に無い版の Release が 5 件（v2.1.1, v2.1.100, v2.1.104, v2.1.146, v2.1.177）。Release 本文と CHANGELOG の該当節の突合: 一致またはほぼ一致 216、差異 20（軽微）。2025-12 以降は Releases を CHANGELOG のミラーとして扱えるが完全一致ではない
- 本文の語ヒット（該当 Release 数、最古、最新）: plugin 126（v2.0.73, v2.1.296）、skill 110（v2.0.74, v2.1.296）、marketplace 77（v2.0.73, v2.1.296）、eval 8（v2.1.268, v2.1.293）、validate 50（v2.1.25, v2.1.296）、hook 114（v2.1.2, v2.1.296）、mod 8（v2.1.287, v2.1.296）、statusline 40（v2.1.6, v2.1.296）。最古はいずれも CHANGELOG の初出より新しい（Release が v2.0.73 以降のため）
- Release 本文の docs URL（7 件）: code.claude.com/docs/en/agent-view、code.claude.com/docs/en/auto-mode-classifier-billing、code.claude.com/docs/en/fast-mode、code.claude.com/docs/en/tools-reference#powershell-tool、www.anthropic.com/news/claude-fable-5-mythos-5、www.anthropic.com/news/claude-sonnet-5、www.anthropic.com/research/end-subset-conversations
- Release 本文の GitHub owner: github.com/<owner> 形式は 0 件。`owner/repo#N` 参照は anthropics/claude-code の 59 件（と placeholder の owner/repo 2 件）で、CHANGELOG と同じ。ホストは code.claude.com 4、www.anthropic.com 3、claude.ai 1、docs.anthropic.com 1。assets は 1 Release あたり平均 6.1（ネイティブバイナリの tarball 等）

**2. npm**: `text=%40anthropic-ai&size=250` は total 172,884（fuzzy）のうち 250 件を返し、`@anthropic-ai/` で始まるのは 28 件で全て既知の 35 件に含まれる（新規 0。@anthropic-ai/universal-sdk は 250 件に出ない）。250 件上限のため scope の網羅は保証できない。`maintainer:` 検索を、既知パッケージの maintainers 欄に現れた全 17 名で実行した（結果の total: user-11=35、user-22=35、user-28=35、user-29=35、user-31=35、user-41=35、user-45=43、user-46=35、user-53=1、user-59=35、user-62=35、user-63=35、user-67=35、user-69=35、user-82=35、user-90=36、user-92=35）。
- 35 件に無い新規パッケージ 43 件（user-45=43 件と user-90=36 件の検索で出現）: MCP 系（@modelcontextprotocol/*）38 件、@anthropic.com の maintainer を持つもの 1 件（claude-code）、それ以外の第三者 4 件。Anthropic 所属の maintainer 17 名のうち user-45 だけが個人ドメインのメール（[redacted-email]）

**3. PyPI の逆引き**: pysvelte は 404（PyPI に無い）。anthropic-tools は別作者 rizerphe（home_page github.com/rizerphe/anthropic-tools）。blobfile は Christopher Hesse の作で Homepage は github.com/blobfile/blobfile。3 件とも anthropics org を指さず除外とした。`gh api repos/anthropics/claude-code-sdk-python` は full_name=anthropics/claude-agent-sdk-python を返し、claude-code-sdk の Homepage は rename 後のリポジトリへのリダイレクトだった（stars 8255、pushed 2026-10-09T19:32:25Z）。

**4. docs 本文の再確認**（ローカル llms-full.txt の Grep。保存日は L-1 の取得日に依存し、リモートの最新との差は未確認）: 
- `claude plugin tag`: 本文にある（L9293 の CHANGELOG 転載のほか、cli-reference#plugin-tag の節 L78776、公開手順 L34276〜L34293・L40403、`/plugin tag` L79067）。題名・説明文には出ないだけで、docs に無いわけではなかった
- `/skill-doctor`: 本文にある（`/docs/en/skills#find-unused-skills` へのリンク、使用状況計測の節 L35647〜L35668、L45325〜L45329）。『v2.1.252 以降』と書かれ、CHANGELOG の初出 2.1.261 と食い違う
- `$schema`: plugin.json / marketplace.json の項目表に『Claude Code ignores it at load time』の記載（L80265, L80901。所属ページは未特定）。settings.json の `$schema` は json.schemastore.org/claude-code-settings.json、keybindings は www.schemastore.org/claude-code-keybindings.json を案内（L49493, L70381, L87544）

**追加走査後も残る未走査**:
- Release 本文 241 件の全行精読（語ヒットと CHANGELOG 節との突合のみ）。v2.0.73 より前の日付は npm time のみ
- npm は scope 一覧 API が無く、`maintainer:` 検索は現在の maintainers の 17 名分。過去の maintainers（packument の履歴）やパッケージごとに maintainers が異なる別パッケージは未走査。文字列検索は 250 件上限
- PyPI の JSON は WebFetch の先頭 100,000 文字のみ（claude-agent-sdk / anthropic の upload_time は未取得）。`$schema` の記載ページ名、/skill-doctor の計測節の所属ページ名は未特定
- `claude-code/testing` のバイナリ内確認（L-3）、SchemaStore の catalog.json と投稿者（G-6 / B5）

## CHANGELOG で抽出した機能と docs ページの対応（docs に無いものを明示）

docs の存否は https://code.claude.com/docs/llms.txt（2026-10-13 取得、268 ページ）の題名・説明文による。『無』は llms.txt に該当ページが見えないという意味で、本文に記載が無いという意味ではない。

| 機能 | 版 | docs ページ（code.claude.com/docs/en/ 以下） | docs の有無 |
|---|---|---|---|
| hooks（Hooks） | 1.0.38 | hooks.md, hooks-guide.md | 有 |
| statusline（/statusline） | 1.0.71 | statusline.md | 有 |
| skills（Claude Skills） | 2.0.20 | skills.md | 有 |
| Plugin system / marketplace（/plugin, /plugin marketplace, extraKnownMarketplaces） | 2.0.12 | plugins/overview.md, plugins/create.md, plugins/install.md, plugins/create-marketplace.md, plugins/marketplace-reference.md, plugins/manifest-reference.md | 有 |
| /plugin validate → claude plugin validate | 2.0.12 | plugins/cli-reference.md, plugins/create-marketplace.md | 有（validate の記述は本文未確認） |
| claude plugin tag | 2.1.118 | plugins/cli-reference.md | 有（ローカル llms-full.txt の本文で確認: cli-reference#plugin-tag、公開手順の節、/plugin tag。llms.txt の題名・説明文には出ない） |
| claude plugin eval | 2.1.269 | plugin-evals.md | 有 |
| /skill-doctor | 2.1.261 | skills.md | 有（本文で確認: skills#find-unused-skills へのリンク、使用状況の計測の節（plugins/measure.md と見られるが所属ページは未特定）。『v2.1.252 以降』と記載） |
| Claude Mods（mods） | 2.1.287 | plugins/mods/overview.md, plugins/mods/create.md, plugins/mods/reference.md, plugins/mods/api.md, plugins/mods/events.md, plugins/mods/interface.md, plugins/mods/gallery.md, plugins/mods/troubleshoot.md, plugins/mods/admin.md | 有（mods/ 配下 10 ページ） |
| claude plugin test / mods テストキット claude-code/testing | 2.1.288 | plugins/mods/test.md | 有（本文確認済み） |
| --plugin-dir | 2.1.74 | plugins/cli-reference.md | 有（説明文に『flags that load a plugin for one session』） |
| $schema の受理（plugin.json / marketplace.json / hooks.json） | 2.1.120 | （なし） | 有（本文で確認: plugin.json / marketplace.json の項目表に『$schema: JSON Schema URL for editor autocomplete. Claude Code ignores it at load time』（llms-full.txt L80265, L80901。所属ページ名は未特定）。settings.json は json.schemastore.org/claude-code-settings.json、keybindings は www.schemastore.org/claude-code-keybindings.json を案内） |
| claude plugin サブコマンド群（init / prune / details / configure / uninstall 等） | 2.1.47 | plugins/cli-reference.md | 有（説明文: claude plugin shell commands の reference。各コマンドの記載は本文未確認） |
| subagents（/agents） | 1.0.60 | sub-agents.md | 有 |
| custom slash commands（.claude/commands/） | 0.2.31 | commands.md, skills.md | 有（skills.md の説明に custom commands を含む） |
| headless / print mode（-p, --output-format stream-json） | 0.2.59 | headless.md | 有 |
| sandbox（/sandbox, sandbox 設定） | 2.0.24 | sandboxing.md, sandbox-environments.md | 有 |
| Claude Code SDK → Claude Agent SDK | 2.0.0 | agent-sdk/migration-guide.md, agent-sdk/overview.md | 有 |
| output styles | 1.0.81 | output-styles.md | 有 |

追加走査（ローカル llms-full.txt の本文 Grep）で、claude plugin tag、/skill-doctor、$schema の受理はいずれも docs 本文に記載があると確認した。llms.txt の題名・説明文だけで判定すると『無』になる（偽陰性）。
