# CLAUDE.md（共通指示）

本リポジトリにおける共通的作業の Claude Code 指示。

## plugin開発規約

> ここに開発規約を記載する。

## pluginリリース時の規約

> ここにpluginをリリースする際の規約を記載する。

## Git ワークフロー

> ここに本リポジトリのGitワークフローを記載する。

## マルチエージェント戦略

### Skills（メインセッションで実行）

> skillsフォルダ配下の利用できるSkillについて記述する

### Sub-agents（隔離コンテキストで実行）

> skillsフォルダ配下の利用できるSkillについて記述する


## Windows 向けファイルの文字コード

`.ps1` は **UTF-8 + BOM + CRLF**、`.bat` は **CP932 + CRLF**（BOM なし）で保存する。**`.bat` は Claude のファイルツールで直接扱えない**（UTF-8 前提のため、読むと文字化けし、書くと壊す）。

- **読む**: 普通に `Read` してよい。hook が UTF-8 の作業コピーへ差し替える
- **編集する**: 原本ではなく作業コピー（`.claude/.bat-shadow/…`）を `Edit` する。保存すると CP932 へ書き戻る
- **新規作成する**: `python .claude/hooks/bat_cp932_guard.py new <path>.bat`
- **`.bat` を Bash のリダイレクト・heredoc・`sed -i` で作成/編集してはならない**（hook が守れず、UTF-8 の
  壊れた `.bat` が生まれる。cmd.exe は 1 行目から誤動作する）

> このルールは**新規作成時にも効かせる必要がある**ためここに置いてある（`.claude/rules/win-file-encoding.md`は 
> path-scoped で、**既存ファイルを読んだ時にしかロードされない**）。詳細・根拠は同 rule を参照。
> hook には Python（3.10+）が要る。無い環境では `.bat` は読めないが、`permissions.deny` により編集は常に拒否されるので**原本が壊れることはない**。

## 重要な制約

- `.env` ファイルを直接編集しない。環境変数は実行環境から参照する
- API キー・パスワード等の機密情報をコードにハードコードしない
- 機密情報は `secrets/` 等へ隔離し、`.gitignore` で除外する（**除外されているかは各リポジトリで確認する**）
- DB マイグレーション等の破壊的操作は必ず確認を取ってから実行する

## Claude Code に関する公式ドキュメントのローカル参照先

1. `C:\cc-workspace\LLMs\official-llms-txts\code.claude.com\docs\llms.txt`
2. `C:\cc-workspace\LLMs\official-llms-txts\code.claude.com\docs\llms-full.txt`

なお、ファイル 2. は 1MB近くあるので、ファイル1.で関連見出し名を特定するか、Grepでキーワード検索し該当行番号を取得してから、offset付きのReadで読むこと。