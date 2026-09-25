# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## リポジトリの位置付け

Claude Code 用 Plugin Marketplace（`.claude/` チーム共有・統制における「層2: Plugin・Marketplace」配布チャネル）を置くためのリポジトリ。現時点では README / LICENSE / .gitignore のみで、Marketplace 定義や Plugin 本体はまだ存在しない。ビルド・lint・テストの仕組みもない。

設計・配布・統制の**正本はこのリポジトリではなく** [`cc-relative-info` の `claude-dir-sharing-governance/`](https://github.com/empty-can/cc-relative-info/tree/develop/claude-dir-sharing-governance)。Marketplace による配布の手順は同ドキュメントの `reports/02.配布物の開発・テスト/01.Plugin・Marketplace編/` を参照し、構成・命名の判断はそちらに合わせる。

## `.claude/` について

`.claude/`（agents / skills / rules / templates / output-styles / settings）は他プロジェクトから持ち込んだ共通設定で、この作業環境用にコミットしている。配布対象の Plugin 本体ではない。`settings.local.json` は個人設定のため、ユーザーのグローバル gitignore で除外しておりコミットしない。

- `.claude/rules/*.md` は `paths:` frontmatter による path-scoped rule。該当ファイルを読み書きすると自動ロードされる:
  - `agent-permission-runtime.md` — agent 定義・SKILL.md・作業計画書を扱う際の permission 事前列挙チェックリスト。sub-agent / background Agent を起動する前に、必要な Write/Edit/Bash/MCP/WebFetch 権限を `settings.json` の allow と照合する
  - `workflow-authoring-runtime.md` — `workflows/*.js`（Workflow スクリプト）の実運用知見。特に resume はプロンプト文字列の同一性でキャッシュされる点に注意
  - `cross-review-runtime.md` — `**/レビュー/**/*.md` のクロスレビュー運用ルール
  - `coding-standards.md` — コードファイル編集時の規約
- rule / template 内で参照される `reports/...` や `research-for-local-RAG-for-cc/...` は別リポジトリのパスであり、このリポジトリには存在しない。
- `commit-and-pr` / `orchestrate` skill は `disable-model-invocation: true`（ユーザーが明示的に呼び出す専用）。
