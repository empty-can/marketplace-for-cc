# 2026-10-10 pre-compact Plugin 化と path-scoped rules 発火条件の調査

pre-compact skill を Plugin 化する作業から派生して、skill の品質メンテナンス手段と、path-scoped rule / `paths:` 付き skill / 入れ子 `CLAUDE.md` の発火条件を調査・実測した記録。**要約ではなく、後からこれらのファイルを追えば同じ結論に行き着けることを目的**にしているので、原文・生データ・実行したコマンドをそのまま残している。

環境: Claude Code 2.1.296（2026-10-09 版）、Windows 11、Git Bash、auto モード、モデル Fable 5.1。セッション: https://claude.ai/code/session_015BLdNfRP2yPpgfD7NzqUCv

## 読む順番

| ファイル | 内容 | 読む場面 |
|---|---|---|
| `04_議論ログ.md` | 作業指示者との問答と決定を時系列で 15 項目に整理 | 全体の流れと「なぜその結論か」を追う |
| `01_pre-compact_Plugin化の作業整理と実装.md` | Plugin 化の要件（公式 docs 根拠）、決定事項、実装・検証結果、起動方法の仕様 | pre-compact Plugin を触る、別 skill を Plugin 化する |
| `02_skill品質レビューに使える公式の仕組みと課題の検知可能性.md` | skill-creator / plugin eval / plugin details / plugin-dev の使い方と制約、5 つの課題の検知可能性、メンテナンス分類と方法への回答 | メンテナンス仕組みを設計する |
| `03_path-scoped-rules_発火条件の調査.md` | 結論、公式 docs と changelog の原文、GitHub issue の要点と扱い方、実測総括、評価・含意、回避策、最終確認 | rule / skill / CLAUDE.md の配置を決める |
| `検証/発火テスト手順書.md` | 再現手順（原理、重複排除の注意、テスト 15 件の設計） | 新しい Claude Code 版で再検証する |
| `検証/発火テスト結果_2026-10-10.md` | 実際に実行したコマンドと観察結果（A〜D ラウンド、総括表） | 当日の結果を確認する |
| `scripts/extract-doc-excerpts.sh` | 公式 docs ミラーから根拠箇所を見出し起点で抜き出す | docs 更新後に差分を見る |
| `scripts/setup-rule-probe.sh` / `cleanup-rule-probe.sh` | 発火テストの fixture 作成・削除 | 再検証 |
| `sources/official-docs-excerpts.md` | docs 抜粋の原文（行番号付き、2026-10-10 15:00 ミラー） | 根拠を確認する |
| `sources/github-issue-*.json` | GitHub API から取得した issue 8 件の原文 | issue の記述を確認する |
| `sources/github-search_q*.json` | GitHub MCP の issue 検索の生結果 2 件 | 検索の網羅性を確認する |
| `sources/web-search-results_2026-10-10.md` | Web 検索結果（二次情報）の原文 | — |

## 結論の要点（詳細は 03）

- path-scoped rule と入れ子 CLAUDE.md は、2.1.288 で Write/Edit、2.1.293 で Bash の単一ファイル読み取り（`cat` `head` `tail` `sed -n` `grep`）が発火対象になった。実測では `cd X && cat file` の `&&` 連結でも発火する。パイプ・Grep ツール・Bash 編集（`sed -i`）は不発。Write/Edit は書き込み後に本文が届く
- `paths:` 付き skill は未修正。Bash 読み取りでは発火せず、サーフェスされるまで Skill ツールにも `/name` にも存在しない扱い
- rule は途中追加で即発火、発火済みの編集は再注入されない。rules 用の reload コマンドは無く、`/compact` `/clear` で反映
- 判定はハーネス側なので Claude Code のバージョンで決まる
- rules・CLAUDE.md は Plugin で配布できない
- 設計含意: 手順の正本は `paths:` 無しの明示起動 skill、rule は短い注意書き、守らせたい規約は hook。`InstructionsLoaded` hook で発火を監査

## 情報源の信頼度の扱い

- 一次: 公式 docs（ローカルミラー。本セッション中の 15:00 に更新されたため、抜粋は新ミラーから見出し起点で取り直した）と実測
- 準一次: GitHub issue。**ステータス（open/closed）は対応状況を表さない**（作業指示者の指摘。bot が閉じる、開発チームは返信・管理をほぼしない）。changelog と実測で判断する
- 二次: Web 検索
