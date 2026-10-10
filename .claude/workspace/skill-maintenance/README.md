# skill-maintenance

Plugin / skill の定期メンテナンスに関する調査・検証・設計の記録を置くフォルダ。**配布物ではない**（`plugins/` の外にあるので Plugin のインストールでは利用者に届かず、`claude plugin validate` の対象にもならない。Claude Code は `.claude/` 内の未知のサブフォルダを読まない）。

置き場所について: 当初はリポジトリ直下 `skill-maintenance/` に作ったが、Marketplace の標準レイアウト（`.claude-plugin/` と `plugins/`）の外にある作業記録なので `.claude/` 配下へ移した。`.claude/work/` は本リポジトリの `.gitignore` で除外されている（ローカル作業用）ため、コミットして残す記録は `.claude/workspace/` に置く。

メンテナンス仕組みの確立は独立した活動テーマとして別ブランチで詰める予定（2026-10-10 時点の作業指示者の方針）。その際の入力がここに溜まる。

| フォルダ | 内容 |
|---|---|
| `2026-10-10_pre-compact-plugin化と_path-scoped-rules調査/` | pre-compact Plugin 化（0.9.0）の作業整理、skill 品質レビューに使える公式の仕組み、path-scoped rule / `paths:` 付き skill / 入れ子 CLAUDE.md の発火条件の調査と実測（Claude Code 2.1.296）、議論ログ、一次資料 |

書き方の方針: 要約より再現性。原文・生データ・実行コマンド・観察結果をそのまま残し、後から同じ結論に行き着けるようにする。
