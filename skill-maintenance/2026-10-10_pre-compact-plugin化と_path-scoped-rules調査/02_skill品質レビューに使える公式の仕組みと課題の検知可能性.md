# 02. skill の品質レビューに使える公式の仕組みと、作業指示者の課題の検知可能性

- 日付: 2026-10-10
- 対象: pre-compact Plugin 0.9.0（ただし内容は skill 一般に適用できる）
- 根拠の原文は `sources/official-docs-excerpts.md`（plugin-evals / measure / skills「Evaluate and iterate」/ cli-reference）

## 1. 使える公式の仕組み（4 つ）

### 1.1 `skill-creator` Plugin（公式。この環境にインストール済み: `skill-creator@claude-plugins-official`）

skills ページ「Run evals with skill-creator」が挙げる機能:

| 機能 | 内容 | 生成物 |
|---|---|---|
| Test cases | プロンプト・入力ファイル・期待挙動を蓄積 | skill ディレクトリ内 `evals/evals.json` |
| Isolated runs | ケースごとに subagent を spawn（クリーンな context）、token 数・所要時間を記録 | — |
| Grading | 各アサーションを出力と照合し pass/fail を根拠付きで記録 | `grading.json` |
| Benchmark | skill 有り／無しの pass 率・時間・token を集計 | `benchmark.json` |
| **Version comparison** | 2 バージョンを blind A/B し、編集が改善かをコミット前に確認 | — |
| Description tuning | should-trigger / should-not-trigger プロンプトで発火率を測定し description 修正案を提示 | — |
| **Review viewer** | 各出力を確認し定性フィードバックを記録する HTML レポート | — |

起動は「evaluate the pre-compact skill with skill-creator」のように依頼する。**制約**: ケースは subagent で隔離実行されるため auto memory が無く、pre-compact のステップ 3（memory 書き込み）は検証できない。評価できるのはステップ 1（方式判定）とステップ 4（`/compact` コメント生成）が中心。

### 1.2 `claude plugin eval`（公式 CLI、v2.1.269 以降）

- Plugin 単位の回帰テスト。各ケースは「プロンプト＋grader」。隔離された非対話セッションで Plugin 有り／無しの 2 arm を各 3 回走らせ、差分 Δ を出す。`--threshold` を切れば CI で exit 1
- pre-compact 向けに重要なのは **`case.yaml` の `context.history_file`**: 既存会話の `.jsonl` を投入し、ケースのプロンプトを「次のユーザー発話」にできる（「Seed the workspace or conversation」）。target がパスのとき、このケースは baseline arm 無しで走る
- **grader はツール呼び出しの trace を見られる**（「What a grader can look at」）。`tool_used: Skill` grader で発火率を、Write / Edit の有無で永続化の有無を採点できる
- **隔離の制約**（「How runs are isolated」）: 一時 HOME・空の作業ディレクトリ、user settings / hooks / CLAUDE.md / MCP / 他 Plugin / memory / skills は無い。project 設定も読まれない。`scaffold_script`（`--scaffold` 必須）で fixture ファイルや git リポジトリを作れるが、設定は読まれない。Artifact ツールは無効。Claude はケース定義を読めない
- `disable-model-invocation: true` の skill をプロンプト先頭の `/pre-compact:pre-compact` で起動できるかは docs に明記が無く未検証
- 位置づけ: 初回の品質確認より、改善後の回帰防止に向く
- 費用: 全 run と judge grader は実モデル呼び出しで課金される（「Requirements」）

### 1.3 コンテキストコストの計測

- `claude plugin details <name>`（measure ページ）: 常時（説明文）と起動時（本文）の推定トークン。Plugin がロード済みであること（`--plugin-dir` 付きでも可）
- `/skill-doctor`（v2.1.252 以降）: 各 skill のコストと利用回数。未使用 skill の洗い出し。feature-flag fetching を省くセッションでは使えない

pre-compact 0.9.0 の実測:

| 項目 | 推定トークン |
|---|---|
| 常時（説明文） | 約 130（`disable-model-invocation: true` なので実際には載らない） |
| 起動時（本文） | 約 3,400（圧縮後の再注入上限 5,000 には収まる） |

### 1.4 `plugin-dev` Plugin（公式、未インストール）

Plugin 作成のツールキット。統制手順書 §7 によると検証段で使える `plugin-validator` / `skill-reviewer` の agent を含む。公式 docs 側は「skill や hook を書き、完成した Plugin を検証する skill と agent を追加する」という説明にとどまる（create ページ）ので、agent 名は手順書の記述に依る。

### 1.5 進め方の提案

1. `skill-creator` で典型的な会話状態を 3〜4 ケース用意し、方式判定とコメント生成の品質を見る
2. memory 書き込みは自動評価できないので、実セッションで `/pre-compact:pre-compact` を使った後に `MEMORY.md` の差分を目視
3. 回帰防止が必要になったら `claude plugin eval` に `history_file` 付きケースとして移す

## 2. 作業指示者の 5 つの課題と、検知可能性

| # | 課題 | 検知手段 | 判定 |
|---|---|---|---|
| 1 | `/compact` `/clear` の最新仕様に追随できているか | 公式ツールは無い。`/release-notes`（会話に入らない）、ローカル `llms-full.txt` の changelog を `compact` `clear` `memory` で grep。skill 末尾の「公式情報」節を「依存している仕様の一覧」に拡張し、docs 更新のたびに照合 | 半自動 |
| 2 | compact コメントを英文にするルール | 既に「英語で書く（厳守）」を規定済み。公式 docs に言語の記述は無く例が英語なだけ。英和で要約品質を比べるには Agent SDK の `continue: true` で `/compact` を送る方法（agent-sdk「Compact history with /compact」）で保存済みセッションを `--resume` し 2 通りの指示で圧縮して比較するしかない。採点は人手か LLM judge | 手動 |
| 3 | `/clear` 推奨時の説明が負荷になっていないか | 説明文は出力トークンとして一度生成されるだけで、`/clear` 後は捨てられる。コストは生成分と読み時間。skill は「曖昧な場合に 1〜2 文」と規定しているので長い説明は追従不足。`skill-creator` の grading で出力行数や根拠の文数をアサーション | 自動化可 |
| 4 | compact 推奨時の事前準備が過剰でないか | `claude plugin eval`: `/compact` 推奨が妥当な会話を `history_file` で投入し、「Write / Edit が呼ばれていない」を trace grader にする。memory が無い環境でも Write の試行は trace に残る。**構造的原因**: skill が「判定が曖昧なら `/clear` 側の準備を採る」と定めているため曖昧なケースでは常に全量外部化が走る。これは設計どおりで検知対象ではなく閾値の判断 | 自動化可 |
| 5 | フロー自体の見直し（AskUserQuestion の活用等） | 仕組みではなく設計判断。`AskUserQuestion` は公式ツール（2.1.x で既定が自動続行なしに変更）。ただし `/compact` `/clear` は built-in で Claude からは実行できないので最後の実行は作業指示者のまま。改善案: 判定 → `AskUserQuestion` で方式選択 → 選ばれた方式の準備だけ → 提示 → 実行（課題 3・4 を同時に解消、対話 1 回増） | 設計 |

### 2.1 調査で見つかった、現行 skill に影響する公式仕様

- **skill 本文が圧縮後に再注入される**（「What survives compaction」「Skill content lifecycle」）: 直近に起動した skill の本文は圧縮後の新コンテキストに 1 skill 5,000 トークンまで再注入される。pre-compact は `/compact` 直前に起動するので必ず対象になり、約 3,400 トークンが役目を終えた後も残る。除外設定は docs に無い。対策は本文を短くし詳細を補助ファイルに逃がす構成（読んだだけのファイルは「最近変更した 5 ファイル」の再読み込み対象になりにくい）
- **部分要約という第 3 の選択肢**: `/rewind` の「Summarize up to here」は指定点より前だけを要約し直近を残す（checkpointing）。暗黙知が要るケースの一部は、全体の `/compact` より直近を残す部分要約が適する可能性がある

## 3. skill メンテナンスの分類と方法（作業指示者案への回答）

### 3.1 分類（作業指示者案）

1. 横断的に適用できる評価基準・観点のメンテナンス
2. skill 固有の評価基準・観点に基づくメンテナンス
3. 設計そのものの見直し・改良

**回答**: 3 分類は妥当。ただし前節の「ツールで検知できるか」は「横断的か固有か」とは独立の軸（固有でも自動化できるもの＝課題 4、横断的でも自動化できないもの＝課題 1 がある）。分類は「何を見るか（横断・固有・設計）」、方法は「どう見るか（自動・半自動・手動）」の 2 軸で持つ。

### 3.2 方法（作業指示者案と訂正）

| 案 | 回答 |
|---|---|
| 1. 公式の仕組みで評価〜改善できる観点 → 定期実行 | **時間ではなく事象で起動する**。eval は実モデル呼び出しで課金され、skill は放置しても変化しない。変わるのは Claude Code のバージョン・モデル・公式 docs。起動条件は「skill を変更した PR」「Claude Code を更新した」「docs ミラーを更新した」の 3 つ |
| 2. 対応できない観点 → 基準と手順を本リポ限定の資産として書き起こし、`plugins/<name>/CLAUDE.md` 等に置く | **置き場所を変える**。(a) Plugin ルートの `CLAUDE.md` は読み込まれず `claude plugin validate` が警告し、本リポは CI で `--strict` なので検証失敗になる。(b) インストール時は Plugin ディレクトリ全体がキャッシュへコピーされるので「配布されない場所」にならない。代替: `.claude/rules/` の path-scoped rule（`paths: plugins/pre-compact/**`）と `.claude/skills/` の skill。`plugin eval` のケースは公式の置き場が Plugin 内 `evals/` で `--eval-dir` も Plugin 配下限定なので配布に乗る（小さいテキストなので実害なし）。**→ ただし path-scoped rule の発火条件には制約がある（`03` 参照）。手順の正本は明示起動の skill、rule は短い注意書きに限定、守らせたい規約は hook で強制** |
| 3. 課題感は設計開発を伴う機能改善活動として行い、成果物に 1・2 を一度以上適用してデグレードを確認 | 妥当。変更前後のデグレード確認は `skill-creator` の Version comparison（blind A/B）がそのための道具。費用対効果は `claude plugin details` の起動時トークンを前後で比較。セキュリティレビューは本文だけの skill では `allowed-tools` に広い権限を足していないかの確認が実質（公式 docs もリポジトリ配布 skill の `allowed-tools` は確認せよと注意） |

作業指示者は「プラグインのメンテナンスの仕組みの確立」を独立した活動テーマとして別ブランチで詰める方針。
