# marketplace-for-cc-test 設計書 v2

| 項目 | 内容 |
|---|---|
| 版 | 2.7（改訂版。セルフチェック 7 巡目の反映） |
| 日付 | 2026-10-11 |
| 作成 | Claude（Fable 5.1）。作業指示者との検討結果を清書 |
| 位置づけ | テスト用リポジトリ `marketplace-for-cc-test` と各種スクリプトを開発するときの**唯一のインプット**。前版 `test-repo-design.md`（Opus 5.5）、レビュー `test-repo-design-review-fable.md`、確認手順書 `test-repo-verification-procedure.md`（8 節で証跡へ移す予定）は経緯の参照用で、本書と食い違う場合は本書を正とする |
| 対象環境 | Windows 11 Pro、Claude Code v2.1.296、PowerShell 7（Windows PowerShell 5.1 も併存）、Git for Windows、Python 3.14。WSL2 は使わない |
| 公式 docs の参照版 | `C:\cc-workspace\LLMs\official-llms-txts\code.claude.com\docs\llms-full.txt`（2026-10-11 15:00 更新、120,807 行）。行番号はこの版のもの。更新で動くので、付録 A の検索語で辿り直す。前日版からの差分は 2026-10-11 に判定済みで、本書に影響する変更は無かった |

## 1. 目的と前提

### 1-1. 目的

`C:\cc-workspace\marketplace-for-cc`（Claude Code 用 Plugin Marketplace。GitHub で public）の Plugin を開発・定期メンテナンスするときのテストを、再現性のある形で実施し、証跡を残すための専用リポジトリ `C:\cc-workspace\marketplace-for-cc-test` を新設する。

### 1-2. 前提

- 想定利用者は作業指示者本人だけ。対象は自作 Plugin なので、悪意あるコードへの防御ではなく、**再現性**と**誤操作の防止**を重視する
- Plugin の挙動確認は、必ず `claude --plugin-dir <Plugin のパス>` で Plugin を読み込んで行う（2-5）
- テストは次の 3 手法を基本とする。Bash や memory を使う確認は、B では行えないので probe（`claude -p` ハーネス）で補う。A の各 run も probe と同じハーネスで実行する（5 節）
  - **A.** skill-creator によるレビューと採点（セッション内）
  - **B.** `claude plugin eval` による回帰 suite の作成（B-1）と実行（B-2）
  - **C.** `claude plugin validate --strict` による構造検証（毎回）
- 作業指示者が実行するスクリプトは **PowerShell** で書く。Git Bash 標準のターミナル（mintty）では対話セッションが起動できないため（F14）
- ユーザー設定の `permissions.defaultMode` は `auto` で、`claude -p` もそれを継承する。テストでは mode を明示して上書きする（F10）
- サンドボックスと probe はユーザー設定（`~/.claude/settings.json`）を継承する。B の一時ホームによる隔離とは強さが違う（F34）
- 既存の証跡（`C:\cc-workspace\marketplace-for-cc-evals\pre-compact\`）を移行する（8 節）

### 1-3. 作業指示者が確定した決定事項

| 決定 | 内容 | 日付 |
|---|---|---|
| D1 | テスト用リポジトリ直下に `CLAUDE.md` を置かない。手順は README と project skill で示す | 2026-10-11 |
| D2 | 証跡のフォルダ構成は `evidence/<plugin>/<version>/<YYYYMMDD>/<commit_count>_<sha7>/<test_num>/<test-method>/`（3-2） | 2026-10-11 |
| D3 | 書き込み先の限定は `--permission-mode acceptEdits` と `--add-dir` で行い、deny ルールを最後の防御として残す | 2026-10-11 |
| D4 | 活動（`<YYYYMMDD>`）の完了は、フォルダ名に `_fin` を付けて表す | 2026-10-11 |
| D5 | 複数 Plugin を横断するテストは `evidence/_multi-plugins/`、Marketplace 全体のテストは `evidence/_marketplace/` に置く | 2026-10-11 |
| D6 | テスト対象の同一性は commit ハッシュではなく Plugin ディレクトリの tree ハッシュで判定する（rebase 対策） | 2026-10-11 |
| D7 | 作業指示者が実行するスクリプトは PowerShell（`.ps1`）で書く | 2026-10-11 |

### 1-4. 用語と識別子の対応

| 日本語（本書で使う） | 構成要素 | スクリプトでの名前 |
|---|---|---|
| 活動 | `evidence/.../<YYYYMMDD>[_fin]/` | `Activity`、`-Activity <YYYYMMDD>` |
| 断面 | `<commit_count>_<sha7>/` | `CommitFolder`、`Resolve-CommitFolder` |
| 試行 | `<test_num>/` | `Attempt`、`-Attempt <path>`、`New-TestAttempt` |
| 手法 | `<test-method>/` | `Method`、`-Method` |
| 実行 | 手法を 1 回呼び出すこと（スクリプトの 1 回の起動）。同じ試行の同じ手法を何度も実行できる（7-4） | `Invocation`、`invocations[]` |
| run | probe と A で、1 つの case を 1 つの腕で 1 回動かすこと。1 回の実行が `-Runs` 個の run を含む | `run-<k>`、`run.json` |
| 腕 | with 腕（Plugin あり）と without 腕（Plugin なし）。`<config>` = `with_skill` / `without_skill` | `-Baseline`（指定で without 腕） |
| サンドボックス | `repo/` + `memory/` + `settings.json` の組。手動確認用は `work/<plugin>/sandbox/`、probe と A 用は `work/<plugin>/runs/` の下（3-3） | `Sandbox` |
| 対象 | テストした marketplace-for-cc の状態（commit、`plugin_tree`、`tree`、version） | `Identity`、`Get-TargetIdentity` |

### 1-5. 本書が決める範囲と、実装時に決める範囲

本書は、フォルダ構成、スクリプトの入出力と拒否条件、証跡のスキーマ、docs と実測に基づく制約を決める。次は実装時に決め、決めた内容を README の「実装メモ」に残す。

- メッセージの文言、ログの書式、引数の細かな型（文字列か列挙か）
- `run.json`（6-3）と判定 JSON（6-4）の、本書に挙げた項目以外の補助項目
- Python 側の内部構造（関数の分割、case 定義の読み込み方）
- 本書に「実装時に決める」と明記した事項

セルフチェックとレビューでは、本書内の矛盾と、本書が決めると宣言した事項の欠落を指摘の対象とし、上記の委任事項は対象外とする。

## 2. 根拠（確認済みの事実）

行番号は表紙に示した版の `llms-full.txt` のもの。実測は Claude Code v2.1.296 で行った。各事実の検索語は付録 A。

### 2-1. 設定の読み込み範囲

| # | 事実 | 根拠 |
|---|---|---|
| F1 | `CLAUDE.md` と `CLAUDE.local.md` は、起動ディレクトリとその上の全階層から読み込まれる。**入れ子の git リポジトリの境界では止まらない** | docs 30747 行。実測 2026-10-10（外側の `CLAUDE.md` の合言葉が内側の別 git リポジトリから読めた） |
| F2 | `.claude/rules/` も同じく上の全階層から読み込まれる | docs 51966 行（Agent SDK の `settingSources` 表に「`<cwd>` と全親ディレクトリ」と記載）。CLI 側の明記は未確認 |
| F3 | `.claude/skills/` は、起動ディレクトリからリポジトリのルートまで遡って読み込まれる。**入れ子の git リポジトリのルートで止まる** | docs 44493 行。実測 2026-10-10（外側の skill は内側の init イベントの一覧に出なかった） |
| F4 | `.claude/settings.json` と hooks は、起動ディレクトリ直下の `.claude/` からだけ読み込まれる | docs 77998 行 |
| F5 | `claudeMdExcludes` は `--settings` の JSON でも効き、Windows では `C:/...` 形式の絶対パスで一致する | docs 30933 行。実測 2026-10-10 |
| F35 | `autoMemoryDirectory` は `--settings` を含むどの設定層からも読まれる。project 設定（`.claude/settings.json`）に置くと、信頼と `blockReadsOutsideWorkingDirectories` の条件で読み書きされないことがある | docs 31121 行、89081 行付近。実測 2026-10-10（`--settings` の JSON とファイルの両方で保存先が切り替わった） |

### 2-2. `/cd` コマンド

| # | 事実 | 根拠 |
|---|---|---|
| F6 | `/cd <path>` は会話を引き継いだまま主作業ディレクトリを移し、移動先の `CLAUDE.md`、project settings、hooks、skills、subagents を適用する。hooks の `${CLAUDE_PROJECT_DIR}` は起動時のまま | docs 77961 行 |
| F7 | **`/cd` では auto memory の保存先は切り替わらない。** システムが Claude に案内する memory のパスは移動前のまま残り、Claude が移動先のパスを自分で組み立てて書くこともあるため、書き込み先が不定になる。セッションの記録（`.jsonl`）は移動先のプロジェクト保存領域へ移る | 実測 2026-10-11（作業指示者）。記録の移動は docs 44146 行にも記載 |

### 2-3. 権限と permission mode

| # | 事実 | 根拠 |
|---|---|---|
| F8 | ファイル権限の判定は `Edit(path)` と `Read(path)` だけを参照する。`Write(path)` ルールは受理されるが参照されない。`Edit` ルールは Write を含む全ファイル編集ツールに及ぶ | docs 77696 行、103235 行。実測 2026-10-10 |
| F9 | Windows ではパスを POSIX 形式に正規化して照合する。絶対パスは **`//c/Users/...`**（ドライブ文字を小文字にし、コロンを外す）で書く。`//C:/...` と `/C:/...` は一致しない。`~/...` と cwd 相対の `**` も効く | docs 77731 行。changelog v1.0.106（docs 12529 行付近）で POSIX 形式に統一。実測 2026-10-10（deny と allow の両方） |
| F10 | ユーザー設定の `defaultMode: auto` は `claude -p` に継承され、auto mode では許可リストに無い操作も分類器が承認する。auto mode では deny ルールの検証もできない。分類器のリクエストが無料対象外のセッションでは、`-p` は stderr に、`stream-json` は `system` の警告メッセージとして通知を出す | 実測 2026-10-10。通知は docs 54897〜54925 行（「Auto mode classifier request charges」）。`acceptEdits` を明示したときに通知が出ないかは未確認 |
| F11 | `--permission-mode acceptEdits` では、cwd 内と `--add-dir` で追加したディレクトリ内の書き込みだけが自動承認され、その外は非対話モードで拒否される。`--allowedTools` に素の `Write` / `Edit` を入れると書き込みは無制限になる | docs 77430 行付近（「作業ディレクトリと `additionalDirectories` 内のファイル編集と `mkdir` などを自動承認」）。実測 2026-10-10 |
| F12 | `acceptEdits` で `--allowedTools` に無い Bash コマンドは、非対話モードで確認なしに拒否される | docs 26508 行（「読み取り専用コマンド以外は `--allowedTools` か `permissions.allow` が要る」）。実測 2026-10-10（pytest が拒否された） |
| F13 | deny ルールは Claude Code が認識する Bash のファイル操作（`cat` `head` `tail` `sed` `tee` とリダイレクト）にも及ぶが、任意のサブプロセス（Python スクリプトが自分で開くファイルなど）には及ばない | docs 77699 行の Warning |

### 2-4. 起動と引数の扱い

| # | 事実 | 根拠 |
|---|---|---|
| F14 | 素の `claude` は標準出力が本物のターミナルでないと非対話モードに入り、`-p` 無しでも `Input must be provided ... when using --print` で止まる。docs は PowerShell ISE と IDE の出力ペインを例に挙げ、Windows Terminal か PowerShell コンソールを使うよう案内する。Git Bash 標準のターミナル（mintty）もこれに該当する | docs 22078 行。実測 2026-10-11（作業指示者、mintty で再現） |
| F15 | `claude -p` に相対パスを渡すと子セッションの cwd 基準で解決され、Plugin が読み込まれず memory が `~/.claude/projects/` に書かれる。パスは絶対パスで渡す | 実測 2026-10-10 |
| F16 | Git Bash は引数の `/c/...` を `C:/...` に変換するが、`--settings` の JSON 文字列の中は変換しない。JSON 内の `/c/...` は `\c\Users\...` と解釈され別の場所になる。`--settings` にはファイルを渡し、中のパスは `C:/...` で書く | 実測 2026-10-11 |
| F17 | auto memory とセッション記録のプロジェクトディレクトリ名は、cwd の絶対パスの `:` `\` `/` `_` を `-` に置き換えて作られる（例: `C--cc-workspace-marketplace-for-cc-evals-sandbox-2026-10-11-midmsg-repo`） | 実測 2026-10-11 |
| F36 | `autoMemoryDirectory` を指定しても、cwd に対応するプロジェクトディレクトリは `~/.claude/projects/` に作られ、セッションの記録（`.jsonl`）が置かれる。memory だけが指定先へ移る。`--no-session-persistence` を付けた `claude -p` では作られない | 実測 2026-10-11（確認 1 の記録 2 件が残った）、2026-10-10（`autoMemoryDirectory` と `--no-session-persistence` を併用した probe では残らなかった。併用時の確認は 9 節の段階 4 でも行う） |

### 2-5. Plugin の読み込み

| # | 事実 | 根拠 |
|---|---|---|
| F18 | セッション限定で Plugin を読み込む起動フラグは `--plugin-dir` と `--plugin-url` の 2 つだけ。Marketplace を起動時に一時追加するフラグは起動フラグ一覧に無く、Marketplace の追加は `claude plugin marketplace add` などの永続的な登録になる（後半は一覧からの推論） | docs 78973〜78981 行 |
| F19 | `--plugin-dir` に Plugin のフォルダ（`plugins/`）を渡すと、`.claude-plugin/plugin.json` を持つ直下のサブフォルダがすべて読み込まれる（v2.1.265 以降）。v2.1.281 以降は、そのフォルダ直下に `.claude-plugin/marketplace.json` があってもよい。Marketplace のルートを渡しても、Plugin が `plugins/` の下にある marketplace-for-cc では読み込まれず、エラーも出ない | docs 78981 行、33606〜33612 行、33692 行 |
| F20 | `--plugin-dir` で読み込んだ Plugin の出所は `inline` と表示される。skill は `/<plugin名>:<skill名>` で呼べる | docs 35119 行、33453 行。実測 2026-10-11（作業指示者） |
| F21 | `disable-model-invocation: true` の skill は、指示文の途中に `/skill名` を書いても Skill ツールが拒否する。対話・非対話とも同じ。先頭起動だけが動く | 実測 2026-10-11（作業指示者）。pre-compact はこれを受けて設定を外した（marketplace-for-cc commit `2fb2068`） |
| F22 | statusline Plugin は SessionStart hook（`hooks/hooks.json`）から `scripts/sync.sh` を呼び、`statusline.sh` をユーザー環境の Plugin データディレクトリへコピーする | `plugins/statusline/hooks/hooks.json`、`plugins/statusline/scripts/sync.sh` |
| F38 | ユーザー設定の `enabledPlugins` で有効な Plugin はどのセッションにも読み込まれる。`--plugin-dir` で同じ manifest 名の Plugin を読み込むと、インストール済みの方は黙って置き換えられる（managed settings で固定された名前は例外で、`--plugin-dir` 側が無視される）。本設計で問題になるのは、without 腕（`--plugin-dir` 無し）にインストール済みの対象 Plugin が混ざること | docs 35427〜35434 行（「Name conflicts」） |

### 2-6. `claude plugin eval`

| # | 事実 | 根拠 |
|---|---|---|
| F23 | `claude plugin eval init` は Plugin ルートでしか実行できない。suite は Plugin 配下にしか置けない（`--eval-dir` は Plugin 配下の相対パスのみ） | docs 41670 行、31912 行 |
| F24 | `claude plugin eval <Plugin のパス>` はどこからでも実行できる。結果は既定で Plugin 側の `evals/results/<timestamp>/` に書かれ、`--output-dir` で変えられる。`init` は作成直後に case を試行実行する。その結果の書き込み先は docs に明記が無いが、既定の出力先（`evals/results/`）と見るのが自然（推論） | docs 31992 行、32041 行、32085 行、31674 行 |
| F25 | 各 run は一時ホームで `claude -p` として実行され、ユーザー設定・`CLAUDE.md`・memory・他の Plugin は読み込まれない。**auto memory は読めず、Bash ツール自体が無い** | docs 32144 行。実測 2026-10-10（memory の読み取りが権限で拒否、`No such tool available: Bash`） |
| F26 | Bash か PowerShell を許可した case（`Bash(npm test *)` のような括弧付きの形を含む、あらゆる形）は OS サンドボックス内で実行され、サンドボックスが無い環境では拒否される。ネイティブ Windows には無い | docs 32020 行、83179 行 |
| F27 | `tool_used: Skill` grader は、prompt 先頭のスラッシュによるユーザー起動を数えない（`Skill called 0x`）。skill 本文は実行される | 実測 2026-10-10 |
| F28 | 非対話モードで未知のスラッシュコマンドはエラーになる。Plugin を読み込まないベースライン腕に `/pre-compact:pre-compact` で始まる prompt を渡すとエラーになる | changelog v2.1.147（docs 8465 行） |
| F29 | `case.yaml` の `context.history_file`（`.jsonl`）で会話の続きとして実行できる。path 指定の target では既定でベースライン腕が無い | docs 31925 行 |
| F30 | `--json` を使う非対話実行では信頼プロンプトを出せず、`--trust-plugin` が無いと exit 1 で拒否される | docs 32132 行 |
| F37 | `claude plugin eval` の終了コード: 0 は全 case が閾値以上。1 は閾値未達、case の読み込み失敗、case が 0 件、実行を開始できなかった、Plugin ディレクトリが未信頼、オプション不正のいずれか。2 は予算超過などの部分実行。130 は中断（部分結果あり）、143 は終了。結果 JSON の主要値は `aggregates.overallScore`、`aggregates.casesPassed`、`aggregates.casesTotal`、`aggregates.meanDelta`、トップレベルの `partial`、`costUsd`。終了コード 1 のうち実行前に止まる場合は結果 JSON が無い。target は `--tag`、`--allow-tools`、`--json` より前に置く | docs 32004〜32006 行、32063〜32069 行、32085 行、32104〜32122 行（`costUsd` は 32122 行）。結果 JSON の名前は出力先の `aggregate-result.json`（32085 行「case が 1 つ以上ある実行はすべて `results/<timestamp>/` に `aggregate-result.json` と `report.html` を書く」）。終了コード 2 の説明（32067 行）にある `results.json` は、直前の CI 例（32053 行）で `--json results.json` と指定したファイル名を指すもので、別の既定ファイルではない。終了コード 2 と 130 のとき `aggregate-result.json` が実際に書かれ `partial: true` を持つかは未確認（9 節の段階 7 で確かめる） |

### 2-7. その他

| # | 事実 | 根拠 |
|---|---|---|
| F31 | Plugin ディレクトリの内容は `git rev-parse <commit>:plugins/<plugin>` で tree ハッシュとして取れる。中身が同じなら rebase で commit が変わっても同じ値になる | git の標準機能 |
| F32 | このマシンの `LongPathsEnabled` は未設定（0）で、260 文字のパス上限が効く。git は `core.longpaths=true` | 実測 2026-10-11 |
| F33 | 前回評価の生データで最も深いファイルの絶対パスは、3-2 の構成で約 188 文字 | 実測 2026-10-11 |
| F34 | サンドボックスと probe（`claude -p`）は、新しい cwd と git で隔離しても `~/.claude/settings.json`（`defaultMode`、`permissions.allow`、`enabledPlugins`）を継承する。B の一時ホームによる隔離（F25）とは異なる | 実測 2026-10-10（`-p` の init イベントの `permissionMode` がユーザー設定の `auto` だった） |
| F39 | Python 3.14 の `-I` オプションは、スクリプトのディレクトリを `sys.path` に入れず、`PYTHONUTF8` も無視する。`-I` 下の既定エンコーディングは cp932 | 実測 2026-10-11（セルフチェック 2 巡目） |

## 3. リポジトリ構成

### 3-1. テスト用リポジトリ

```text
marketplace-for-cc-test/
├── README.md                     # 人間向け（3-5）
├── .gitignore                    # work/ を除外する
├── .gitattributes                # marketplace-for-cc と同じ。*.ps1 と *.psm1 は UTF-8 BOM + CRLF、他は LF
├── .claude/
│   ├── settings.json             # 作業セッション向けの許可設定（3-5）
│   └── skills/
│       └── test-repo-guide/
│           └── SKILL.md          # 作業手順の案内（D1。CLAUDE.md の代わり。3-5）
├── scripts/
│   ├── common/
│   │   └── Evidence.psm1         # 共通関数（6-1）
│   ├── Start-Sandbox.ps1         # 手動確認用の対話セッションを起動する（6-2）
│   ├── Invoke-Probe.ps1          # ハーネスで case を実行する。A の実行器も兼ねる（6-3）
│   ├── Invoke-ProbeGrade.ps1     # 手動判定を取り込んで採点する（6-4）
│   ├── Invoke-PluginEval.ps1     # B-2 を実行する（6-5）
│   ├── Invoke-Validate.ps1       # C を実行する（6-6）
│   ├── New-Attempt.ps1           # 手動確認用の試行を作る（6-7）
│   ├── Set-MethodStatus.ps1      # 手動確認の手法を完了にする（6-7）
│   ├── Complete-Activity.ps1     # 活動を完了にする（6-8）
│   └── Find-Evidence.ps1         # commit から証跡を探す（6-9）
├── tools/
│   └── harness/                  # Invoke-Probe.ps1 が呼ぶ Python（6-10）
├── evidence/                     # 証跡。コミット対象（3-2）
└── work/                         # 使い捨ての作業領域。git 管理外（3-3）
```

`CLAUDE.md` は置かない（D1）。F1 のとおり `CLAUDE.md` は入れ子の git を越えて `work/` 配下のサンドボックスに漏れるが、F3 のとおり `.claude/skills/` は漏れない。作業セッションは起動後に `/test-repo-guide` を実行して手順を読む。

### 3-2. 証跡（`evidence/`）

```text
evidence/
├── <plugin>/                          # 例: pre-compact
│   ├── README.md                      # 活動の一覧（7-3）
│   └── <version>/                     # plugin.json の version。先頭の v は付けない（例: 0.9.0）
│       └── <YYYYMMDD>[_fin]/          # 活動。開始日（Asia/Tokyo）。完了したら _fin を付ける
│           ├── activity.json          # purpose / goal / started / closed_at（7-1）
│           └── <commit_count>_<sha7>/ # 断面。活動内でテストした対象の通し番号（00 から）と、その時点の commit
│               └── <test_num>/        # 試行（00 から）。追記専用（7-4）
│                   ├── meta.json      # 実行日時・Claude Code 版・モデル・手法・対象の識別子（7-2）
│                   └── <test-method>/ # skill-creator / plugin-eval / validate / probe / manual
├── _multi-plugins/                    # 複数 Plugin が協調する機能やユースケースのテスト（D5）
│   ├── README.md
│   └── <YYYYMMDD>[_fin]/<commit_count>_<sha7>/<test_num>/<test-method>/
└── _marketplace/                      # Marketplace 全体のテスト（validate .、名前衝突）（D5）
    ├── README.md
    └── <YYYYMMDD>[_fin]/<commit_count>_<sha7>/<test_num>/<test-method>/
```

- `<YYYYMMDD>` は**活動を開始した日付**で、活動が日を跨いでも変えない。1 つの活動は一連の作業に対応し、`activity.json` の `purpose`（`feature` 機能追加 / `release` リリース前 / `maintenance` 定期メンテナンス / `investigation` 調査）で区別する。**活動は版に属し、1 つの版につき 1 日 1 活動**とする。同じ版で同じ日に 2 つ目の活動は作れない。閉じた活動の続きが要るときは翌日以降に新しい活動を作る
- `<commit_count>` は活動の中でテストした対象の通し番号。テストせずに通過した commit には番号を付けない
- `<sha7>` はテスト開始時点の marketplace-for-cc の HEAD の短縮ハッシュ。人間と Claude が `git show` で辿るための値で、同一性の判定には使わない（D6、7-2）
- 手法フォルダの中は手法ごとに次のとおり。`manual` を除き、1 回の実行が新しいファイルだけを追加する構成（7-4）
  - `probe`: `<case>/<config>/run-<k>/`（`<config>` は `with_skill` か `without_skill`、`<k>` は 1 から。再実行は既存の最大 `<k>` の次から振る。失敗した run も証跡に残し `<k>` を消費する）と、直下に `judgments-<yyyyMMdd_HHmmss>.json`
  - `skill-creator`: `iteration-<n>/` の下に、`eval-<id>-<case>/<config>/run-<k>/`（`<k>` の規則は同上）、`evals.json`（その Plugin の全 case 定義から生成）、`judgments-<yyyyMMdd_HHmmss>.json`、および集計物（`benchmark.json`、`benchmark.md`、`review.html`、`report.md`）。集計物は同じ iteration 内で再生成してよい（7-4）
  - `plugin-eval`: `<yyyyMMdd_HHmmss>/`
  - `validate`: `<yyyyMMdd_HHmmss>.txt`
  - `manual`: 作業指示者が置く任意のファイル。同じ試行で複数回の実行を登録したときは、ファイル名に実行日時を含めて既存ファイルを上書きしない（7-4）
- `_multi-plugins` と `_marketplace` には `<version>` の層が無い。commit が全 Plugin の版を同時に決めるため。同一性は commit 全体の `tree` で判定し、`meta.json` の `target.plugins` に各 Plugin の名前・版・`plugin_tree` を列挙する。Marketplace のインストール導線（`claude plugin marketplace add`）の検証は永続的な登録を伴う（F18）ので、スクリプトの対象外とし、作業指示者の手動確認として `_marketplace/.../manual/` に記録する
- 絶対パスは 200 文字以内を目安にする（F32、F33）。eval の case 名が長くなる場合は手で短くする

### 3-3. 作業領域（`work/`）

```text
work/
└── <plugin>/                          # _multi-plugins も同じ構成
    ├── sandbox/<YYYYMMDD>_<name>/     # 手動確認用（Start-Sandbox.ps1 が作る）。日付は実行日
    │   ├── repo/                      # git init 済み。リモートなし
    │   ├── memory/                    # このサンドボックス専用の auto memory
    │   └── settings.json              # autoMemoryDirectory と deny ルール
    └── runs/<attempt_key>/            # Invoke-Probe.ps1 が作る。<attempt_key> は試行を一意にする文字列（下記）
        ├── probe/<case>/<config>/run-<k>/                              # -Method probe。各 run はサンドボックスの構成
        └── skill-creator/iteration-<n>/eval-<id>-<case>/<config>/run-<k>/   # -Method skill-creator。skill-creator 同梱スクリプトが期待する配置
```

- `<attempt_key>` = `<version>_<YYYYMMDD>_<commit_count>_<test_num>`（`_multi-plugins` では `<version>` を `-` にする）。版・活動・断面・試行の組で一意になる
- `run-<k>` の `<k>` は証跡側と同じ番号を使う。`work/` 側に同じ run のディレクトリが既にあれば拒否する
- `repo/` と `memory/` を兄弟にする。memory を `repo/` の中に置くと、未追跡ファイルとして `git status` に現れ、skill の未コミット変更の判定を汚すため
- `work/` 全体を `.gitignore` に入れる。各 `repo/` が `.git` を持ち、コミットすると入れ子のリポジトリになるため

### 3-4. marketplace-for-cc 側

```text
marketplace-for-cc/plugins/<plugin>/
└── evals/                    # B-1 の成果。Plugin と一緒にバージョン管理する（F23）
    ├── <case>/...
    └── results/              # eval の既定の出力先（F24）。.gitignore に入れる（必須）
```

- marketplace-for-cc の `.gitignore` に `plugins/*/evals/results/` を追加する
- marketplace-for-cc は public なので、`evals/` の fixture（会話記録、memory のサンプル）は公開前提で合成データに限る
- `evals/` を配布物から除外する手段は docs に無い。利用者に届くものとして扱う
- `evals/` は Plugin ディレクトリの中なので、**suite を追加・変更すると `plugin_tree` が変わり、新しい断面になる**。skill の挙動は同じでも断面は分かれる。B-1 の後は suite を commit してから B-2 を実行する（5-1 の clean 検査で止まるため）

### 3-5. 段階 1 で作るファイルの中身

| ファイル | 必須の内容 |
|---|---|
| `README.md` | 目的（1-1）、前提（1-2 の要約と実行ターミナルの条件）、テストの流れ（5-1、5-2）、スクリプト一覧と書式（6-2〜6-9 の書式行）、環境変数（`MARKETPLACE_DIR`、`CLAUDE_TEST_MODEL`、`CLAUDE_TEST_JUDGE_MODEL`）、証跡の構成と命名（3-2、7 節）、後片付け（`work/` と `~/.claude/projects/` の該当ディレクトリ）、既知の制約（F7、F14、F21、F25〜F28、F36）、実装メモ（1-5 の委任事項で決めた内容） |
| `.claude/skills/test-repo-guide/SKILL.md` | frontmatter: `name: test-repo-guide`、`description` は「このリポジトリで Plugin のテストや証跡の整理を始めるときに最初に読む。テストの流れ・スクリプトの使い方・証跡の規約を案内する」。`disable-model-invocation` は付けない。本文: README の「テストの流れ」「スクリプト一覧」「証跡の規約」への案内と、守ること 3 点（`evidence/` の既存ファイルは 7-4 の変更の許容項目以外は書き換えない、`work/` 以外にサンドボックスを作らない、marketplace-for-cc 側を直接編集するときはその場で commit してから戻る） |
| `.claude/settings.json` | `permissions.allow` に `Bash(git status *)` `Bash(git diff *)` `Bash(git log *)` `Bash(pwsh -NoProfile -File ./scripts/*)`。deny は置かない（A のセッションが `evidence/.../skill-creator/` に書く必要があるため）。`defaultMode` は設定しない |

## 4. 採用理由

1. **証跡を「活動 → 断面 → 試行 → 手法」の順に階層化した（D2）。** `<version>` 直下の増加は 1 日 1 フォルダに抑えられ、同じ断面への再テストは試行の追加で安全に積める。手法は最下層なので、手法の増減が上位に波及しない
2. **試行は追記専用にした（7-4）。** 各手法の出力先を実行ごとに一意にする（run 番号、タイムスタンプ）ことで、再実行が既存ファイルを上書きしない。再テストの理由（Claude Code の版やモデルの違い）は試行ごとの `meta.json` に残る
3. **活動の完了を `_fin` で表す（D4）。** スクリプトはフォルダ名の確認だけで「未作成 / 実施中 / 完了」を判別でき、`activity.json` を読む必要がない。完了した活動は再開しない。続きが要るときは翌日以降に新しい活動を作る（同じ版・同じ日には作れない。3-2）
4. **同一性は tree ハッシュで判定する（D6）。** 作業指示者は rebase を使うので commit ハッシュは変わりうる。Plugin ディレクトリの tree ハッシュは中身が同じなら不変で（F31）、rebase 前後の紐づけに別の仕組みが要らない
5. **`CLAUDE.md` を置かない（D1）。** F1 と F3 の非対称性を使い、構造でサンドボックスへの漏れを防ぐ。`claudeMdExcludes` 方式（F5）も動くが、スクリプトを通さずに起動したときに漏れる
6. **サンドボックスごとに `git init` する。** skill の探索がそこで止まり（F3）、skill が使う `git status` もサンドボックスだけを見る。リモートを設定しないので push 事故が起きない
7. **memory は `repo/` の外（サンドボックスの `memory/`）に置き、`~/.claude/projects/` には memory を書かない。** 隔離した `autoMemoryDirectory`（F35）でユーザーの memory を汚さない。セッションの記録は `~/.claude/projects/` に残る（F36）ので、後片付けはサンドボックスの削除と、F17 の規則で名前が決まるプロジェクトディレクトリの削除の 2 つになる。probe は `--no-session-persistence` で記録自体を残さない
8. **書き込み先の限定は mode と `--add-dir` で行う（D3）。** パス限定の allow ルールは `Edit(path)` と `//c/...` 形式なら効く（F8、F9）が、`acceptEdits` と `--add-dir` だけで同じ効果が得られ（F11）、設定が少ない。deny は mode の指定漏れに備える最後の防御として残す
9. **suite は Plugin 側に置き、結果だけをテスト用リポジトリへ出す（F23、F24）。**
10. **B は Bash と memory を使わない確認に限り、それ以外は probe で行う（F25、F26）。** WSL2 を使わない以上、B で Bash を許可すると全 case が拒否される。B の一時ホームによる隔離は Bash 無しでも働くので、再現性は保てる
11. **スクリプトは PowerShell にする（D7）。** 対話セッションの起動が mintty では動かない（F14）。Git Bash での `-p` 実行は動くが、作業指示者の実行シェルを 1 つに揃える
12. **`--plugin-dir` は既定で Plugin 単体を指す。** `plugins/` 全体を渡すと statusline も読み込まれ、その hook がユーザー環境へ書き込む（F19、F22）。`_multi-plugins` のときだけ `plugins/` を渡す

## 5. テストの流れ

### 5-1. 1 回の試行の流れ

証跡を作るスクリプト（`Invoke-Probe.ps1`、`Invoke-PluginEval.ps1`、`Invoke-Validate.ps1`、`New-Attempt.ps1`）は、この順で共通処理を行う。

1. `Assert-CleanTree`: marketplace-for-cc の `plugins/<plugin>/` の作業ツリーが clean であることを確認する（`_multi-plugins` と `_marketplace` では全体）。汚れていれば拒否する。テストした内容と `<sha7>` がずれるため
2. `Get-TargetIdentity`: HEAD の commit、`sha7`、ブランチ、`plugin_tree`、`tree`、`plugin.json` の version を取る
3. `Resolve-Activity`: open の活動が 1 つで版が一致すればそれを継続し、無ければ今日の日付で作る（`-Purpose` と `-Goal` が必須）。版が違う open があれば拒否する
4. `Resolve-CommitFolder`: 活動内に同じ `plugin_tree` の断面があればそれを使い、無ければ次の `<commit_count>` を割り当てる
5. `New-TestAttempt`: 次の `<test_num>` を作り、`meta.json` を書く。最初の手法を `running` で登録する
6. 手法を実行し、結果を `<test-method>/` に書く。終わったら手法の状態を `completed` か `aborted` にする
7. 活動の区切りで `Complete-Activity.ps1` を実行し、`_fin` を付けて `README.md` を更新する

`-Attempt <path>` で既存の試行を渡した場合は、3〜5 の代わりに `Resolve-Attempt` を行う。試行のパスから活動・版・断面を導き、手順 2 の `plugin_tree`（`_multi-plugins` と `_marketplace` では `tree`）が試行の `meta.json` の `target` と一致することを確認し、違えば拒否する。試行が `_fin` 付きの活動の下にあれば拒否する。一致すれば `Add-AttemptMethod` で手法の実行を登録する（同じ手法の 2 回目以降も可。7-4）。`-Attempt` と併用できる引数は 6-0 の表のとおり。

### 5-2. 手法ごとの実行場所と方法

| 手法 | 実行場所 | 方法 | 出力先（試行配下） |
|---|---|---|---|
| A: skill-creator | テスト用リポジトリ直下で起動した対話セッション | `/skill-creator:skill-creator` を実行する。流れは次のとおり。(1) 最初の case を `Invoke-Probe.ps1 -Method skill-creator -Iteration 1` で実行し、表示された試行のパスを Claude が控える。(2) 残りの case と without 腕を、同じ試行に `-Method skill-creator -Iteration <n> -Attempt <path>` で追加実行する。(3) Claude が記録を読んで判定 JSON を作り、`Invoke-ProbeGrade.ps1 -Attempt <path> -Method skill-creator -Iteration <n> -Judgments <file>` で `grading.json` を確定する。(4) skill-creator 同梱の集計（`aggregate_benchmark`）とビューア（`generate_review.py --static`）を実行し、出力をその試行の `skill-creator/iteration-<n>/` へ直接書く | `skill-creator/iteration-<n>/`（run ごとの記録・`evals.json`・判定・集計物） |
| B-1: suite 作成 | 同じセッションで `/cd` により Plugin ルートへ移動 | Claude に `claude plugin eval init` の実行を頼む。A の所見を踏まえて case を設計する。marketplace-for-cc の `.gitignore` に `plugins/*/evals/results/` が無ければ追加する（3-4）。終わったら suite と `.gitignore` を commit し、`/cd` で戻る | marketplace-for-cc 側の `evals/` |
| B-2: suite 実行 | PowerShell（セッション不要） | `Invoke-PluginEval.ps1` | `plugin-eval/<yyyyMMdd_HHmmss>/`（`aggregate-result.json`、`report.html`、`summary.json`、`console.txt`） |
| C: 構造検証 | PowerShell | `Invoke-Validate.ps1` | `validate/<yyyyMMdd_HHmmss>.txt` |
| 手動確認 | 毎回新しい対話セッション | `New-Attempt.ps1 -Method manual` で試行を作り、`Start-Sandbox.ps1 -Attempt <path>` で起動して作業指示者が操作する。終わったら `Set-MethodStatus.ps1` で完了にする | `manual/`（作業指示者が記録を置く） |
| probe | PowerShell | `Invoke-Probe.ps1 -Method probe`。Bash や memory が要る確認、文中起動の確認など、B で測れない項目。手動判定が要る項目は `Invoke-ProbeGrade.ps1` で確定する | `probe/<case>/<config>/run-<k>/` |

### 5-3. `/cd` の注意点

- `/cd` で Plugin ルートへ移ると、marketplace-for-cc 側の `CLAUDE.md`、`.claude/rules/`、`.claude/skills/`（旧版の pre-compact を含む）が読み込まれる。一方、marketplace-for-cc の `.claude/settings.json` の hooks は効かない（F4、F6）。suite の作成には支障ないが、そのセッションで skill の挙動を確かめない
- `/cd` は会話を引き継ぐので、まっさらなセッションでの挙動確認には使えない。手動確認は毎回 `Start-Sandbox.ps1` で新しいセッションを起動する
- `/cd` では auto memory の保存先が切り替わらず、書き込み先が不定になる（F7）。`/cd` したセッションでは memory に依存する作業（pre-compact の実行など）を行わない

### 5-4. B の case 設計で守ること

- 各 run には Bash も memory も無い（F25）。skill が `git status` や `MEMORY.md` を使う手順は常に実行できないので、grader はそこを減点しない。実測では、pre-compact はその旨を断った上で終了方式の提示とコメント案の出力を行った
- `tool_used: Skill` はユーザー起動を数えない（F27）。起動確認は `regex` か `llm` grader で最終応答を見る
- prompt 先頭にスラッシュコマンドを置く case は、Plugin の無いベースライン腕でエラーになる（F28）。`--ablation none` で with 腕だけを採点するか、`context.history_file` の case にする（F29）。pre-compact は `disable-model-invocation` を外した（F21）ので、文中で実行を求める prompt なら両腕を比較できる
- `--allow-tools` に `Bash` と `PowerShell` を、どの形でも含めない（F26）。`Write` と `Edit` は許可してよい
- marketplace-for-cc は public なので、fixture は合成データに限る（3-4）

## 6. スクリプト仕様

### 6-0. 共通規約

**言語と文字コード**

- PowerShell。PowerShell 7 で動作確認し、Windows PowerShell 5.1 でも動く書き方を優先する。ファイルは UTF-8 BOM + CRLF（marketplace-for-cc の規約）
- テキストの書き出しは ASCII だけなら `Set-Content -Encoding Ascii`、それ以外は `[IO.File]::WriteAllText`（UTF-8 BOM なし）を使い、5.1 の `-Encoding utf8` が付ける BOM を避ける
- Python は `python -X utf8 <script>` で呼ぶ（`-I` は使わない。F39）。Python 側はすべての入出力で `encoding="utf-8"` を明示する

**実行場所**

- Windows Terminal の PowerShell か PowerShell コンソール。ISE と mintty は不可（F14）。README に `python -c "import sys;print(sys.stdout.isatty())"` が `True` なら起動できる、と書く

**パスと環境変数**

- すべて `C:/...` 形式のスラッシュ区切りの絶対パスに展開してから Claude Code に渡す（F15、F16）
- `MARKETPLACE_DIR`: marketplace-for-cc の場所。既定は `C:/cc-workspace/marketplace-for-cc`
- `CLAUDE_TEST_MODEL`、`CLAUDE_TEST_JUDGE_MODEL`: `-Model` / `-JudgeModel` の省略時の既定。引数も環境変数も無ければ Claude Code の既定に任せ、`meta.json` の実行の `model` / `judge_model` には null を記録する（7-2）

**責務の分担**（PowerShell と Python）

- PowerShell が、活動と試行の解決、`settings.json` の生成（`New-SandboxSettings`）、case 定義の読み取り、`claude` の起動引数の組み立て（`run.json`）、証跡へのコピーを担う
- Python（`tools/harness/`）が、fixture の生成、`claude -p` の実行、記録の整形、機械判定を担う。`run.json` に書かれた引数をそのまま使い、Python 側で引数を足したり組み立てたりしない

**Claude Code の起動引数**（`Start-Sandbox.ps1` と `Invoke-Probe.ps1` で共通。probe では PowerShell が `run.json` に書く）

- `--permission-mode acceptEdits`（F10、F11）
- `--add-dir <memory の絶対パス>`
- `--settings <settings.json の絶対パス>`
- `--plugin-dir`: `-Plugin <name>` なら `<MARKETPLACE_DIR>/plugins/<name>`、`-Plugin _multi-plugins` なら `<MARKETPLACE_DIR>/plugins`。Marketplace のルートは渡さない（F19）。without 腕（`-Baseline`）では付けない
- `--allowedTools` の既定は `Bash(git status *)` `Bash(git diff *)` `Bash(git log *)` の 3 つ。probe の case 定義（`allowed_tools`）で Bash のパターンを追加できる。素の `Write` / `Edit` / `Bash` は指定があっても拒否する（F11）。`Start-Sandbox.ps1` は既定だけを使う
- `-Model` があれば `--model`。`-Effort` は `settings.json` の `effortLevel` で渡す（引数ではない）
- `Invoke-Probe.ps1` はさらに `--no-session-persistence --output-format stream-json --verbose`（F36）。`stream-json` には F10 の `system` 通知が混ざりうるので、整形側は未知の `system` メッセージを無視する

**起動前の検査**（`Start-Sandbox.ps1` と `Invoke-Probe.ps1`）

- `Assert-PluginNotEnabled`: ユーザー設定の `enabledPlugins` で有効（値が `true`）な id のうち、対象 Plugin の名前で始まるものがあれば拒否する。`-Plugin _multi-plugins` では `<MARKETPLACE_DIR>/plugins/` 配下の全 Plugin 名を対象にする（F38。without 腕に混入するため）

**deny ルール**（`settings.json` に生成する。D3、F8、F9）

- `Edit(//c/cc-workspace/marketplace-for-cc/**)`（`MARKETPLACE_DIR` から生成する。ドライブ文字は小文字、コロン無し）
- `Edit(~/.claude/**)`

**`-Plugin` に渡せる値とスクリプトの対応**

| スクリプト | `<name>`（Plugin 名） | `_multi-plugins` | `_marketplace` |
|---|---|---|---|
| `Start-Sandbox.ps1` | 可 | 可（`plugins/` を読み込む） | 拒否 |
| `Invoke-Probe.ps1` | 可 | 可 | 拒否 |
| `Invoke-PluginEval.ps1` | 可 | 拒否 | 拒否 |
| `Invoke-Validate.ps1` | 可（Plugin と Marketplace の両方を検証） | 拒否 | 可（Marketplace だけを検証） |
| `New-Attempt.ps1` | 可 | 可 | 可 |
| `Complete-Activity.ps1`、`Find-Evidence.ps1` | 可 | 可 | 可 |

`Set-MethodStatus.ps1` と `Invoke-ProbeGrade.ps1` は `-Plugin` を取らず、`-Attempt` のパスから Plugin を導く。

**`-Attempt` と他の引数の併用**

| 引数 | `-Attempt` と併用したとき |
|---|---|
| `-Activity`、`-Purpose`、`-Goal`、`-Reason` | 指定があれば拒否する（試行から導く値と食い違うため） |
| `-Model`、`-Effort`、`-JudgeModel` | 可（各スクリプトが取る引数に限る。`-Effort` は `Invoke-Probe.ps1`、`New-Attempt.ps1`、`Start-Sandbox.ps1`、`-JudgeModel` は `Invoke-PluginEval.ps1` だけ）。`Invoke-Probe.ps1`、`Invoke-PluginEval.ps1`、`New-Attempt.ps1` では、その実行の `methods[].invocations[]` に記録する（7-2）。`Start-Sandbox.ps1` は実行を登録しないので `Add-AttemptNote` に記録する（6-2）。試行の `model` / `effort` は最初の実行の値のまま |
| `-Notes` | `Add-AttemptNote` に渡す |

**拒否の順序**

- 引数と case 定義だけで判定できる拒否（`-Plugin` の値、`-Method` と `-Iteration` の組み合わせ、`-AllowTools` の内容、`-Attempt` との併用禁止、case 定義の有無と `baseline` と `allowed_tools` の内容、サンドボックスの既存）は、5-1 の共通処理より前に行う。この規則は `-Plugin` か `-Attempt` を取る全スクリプト（6-2〜6-9）に適用し、各手順に明記が無くても先に行う。共通処理は活動の作成と試行の登録を含み、追記専用（7-4）のため後から消せない。引数の誤りで活動・試行・`aborted` の実行が証跡に残ることを避ける
- 共通処理の中で起きる拒否（clean でない、版違いの open、同一性の不一致）と、手法の実行中の失敗は、この順序の対象外で、6-2〜6-9 の各手順に従う

**拒否時の表示と失敗時の状態**

- 処理を拒否するときは、何が起きたか、なぜ止めたか、どうすれば進められるかの 3 点を標準出力に出し、終了コードを 1 にする。共通関数は `throw` し、入口のスクリプトが `try` / `catch` で捕まえて表示と `exit 1` を行う。Claude が実行した場合はそのまま作業指示者へ報告させる
- 入口のスクリプトは、手法の実行を登録した後に例外が出たら `finally` で、その実行がまだ `running` のときだけ `aborted` にしてから終了する（既に `completed` か `aborted` なら触れない。`Set-InvocationStatus` が状態の上書きを拒否するため）

**引数の表記**

- 本書の書式行と 6-1 の関数一覧では、値を取る引数は `-Name <型>`、省略可能なものは `[ ]` で囲む

**証跡の規約**: 7 節

### 6-1. `scripts/common/Evidence.psm1`

| 関数 | 役割 |
|---|---|
| `Get-MarketplaceDir` | `MARKETPLACE_DIR` か既定値を `C:/...` 形式で返す |
| `Assert-CleanTree -Plugin <name>` | `git status --porcelain -- plugins/<plugin>` が空であることを確認する。`_multi-plugins` と `_marketplace` では `git status --porcelain` 全体。汚れていれば拒否する（`-AllowDirty` は用意しない） |
| `Get-TargetIdentity -Plugin <name> [-Commit <ref>]` | `<ref>`（既定 HEAD）の `commit`（完全）、`sha7`、`branch`（HEAD のときだけ。それ以外は null）、`plugin_tree`（`git rev-parse <ref>:plugins/<plugin>`）、`tree`（`git rev-parse <ref>^{tree}`）、`version`（その commit の `plugin.json`）を返す。`<ref>` が commit に解決できなければ拒否する（「ref が不正」）。解決できても、その commit に `plugins/<plugin>` が無ければ拒否する（「Plugin が無い」。前者と区別できる形で `throw` する）。`_multi-plugins` と `_marketplace` では `plugin_tree` と `version` は null で、代わりに `plugins`（全 Plugin の `name` / `version` / `plugin_tree` の配列）を返す |
| `Get-EvidenceRoot -Plugin <name> -Identity <obj>` | `evidence/<plugin>/<version>/` を返す。`_multi-plugins` と `_marketplace` では `evidence/<plugin>/` |
| `Resolve-Activity -Plugin <name> -Identity <obj> [-Activity <YYYYMMDD>] [-Purpose <値>] [-Goal <文>]` | 活動のパスを返す。(1) `-Activity` 指定時: `Get-EvidenceRoot` 配下のそのフォルダが open ならそれを使う。無いか `_fin` 付きなら拒否する。(2) 指定なし: `evidence/<plugin>/` 配下を**版をまたいで**探し（`_multi-plugins` と `_marketplace` では直下）、open の活動を数える。2 つ以上なら拒否する（「状態が不正。`_fin` の付け忘れの可能性が高い」）。1 つで、その版が `Identity.version` と同じなら継続し、日付と開始からの経過日数を表示する。このとき `-Purpose` / `-Goal` が指定され、`activity.json` の値と違えば警告を表示する。1 つで版が違えば拒否する（「先に `Complete-Activity.ps1` を実行する」）。0 なら今日の日付で `Get-EvidenceRoot` 配下に作る。作成には `-Purpose` と `-Goal` が必須で、無ければ拒否する。今日の日付の `_fin` 付きフォルダが既にあれば拒否する（1 版・1 日・1 活動） |
| `Resolve-CommitFolder -Activity <path> -Identity <obj>` | 活動内の各断面の全試行の `meta.json` を読み、`target.plugin_tree`（`_multi-plugins` と `_marketplace` では `target.tree`）が一致する断面があればそれを返す。無ければ次の `<commit_count>_<sha7>` のパスを返す（この時点ではフォルダを作らない） |
| `New-TestAttempt -CommitFolder <path> -Identity <obj> -Method <name> [-Model <id>] [-Effort <level>] [-JudgeModel <id>] [-Reason <文>] [-Notes <文>]` | 断面フォルダが無ければ作り、次の `<test_num>` を作って `meta.json`（7-2）を書き、そのパスを返す。最初の手法の最初の実行を `running` で登録する。既存の試行には触れない。`claude_code_version` は `claude --version` の出力の先頭の空白までの語（`2.1.296`）、`executed_at` は `Get-Date -Format o`、`environment` は `Get-EnvironmentInfo` から取る |
| `Resolve-Attempt -Plugin <name> -Attempt <path> -Identity <obj>` | 試行のパスから活動・版・断面を導き、`meta.json` の `target` と `Identity` の `plugin_tree`（または `tree`）が一致することを確認する。`_fin` 付きの活動の下なら拒否する |
| `Assert-AttemptOpen -Attempt <path>` | 試行が `_fin` 付きの活動の下なら拒否する（同一性は見ない。`Invoke-ProbeGrade.ps1` と `Set-MethodStatus.ps1` が使う） |
| `Add-AttemptMethod -Attempt <path> -Method <name> [-Model <id>] [-Effort <level>] [-JudgeModel <id>]` | `meta.json` の `methods` に手法が無ければ追加し、その手法の `invocations` に新しい実行（`running`、開始日時、Claude Code 版、model、effort、judge_model）を追記し、手法の状態と試行の `status` を再計算して（7-2）、実行番号を返す |
| `Set-InvocationStatus -Attempt <path> -Method <name> -Invocation <n> -Status <completed または aborted> [-Result <obj>]` | 該当する実行の状態と終了日時、任意の結果（終了コードなど）を書き、手法の状態と試行の `status` を再計算する（7-2）。該当する実行が `running` でなければ拒否する（状態の上書きは許さない） |
| `Add-AttemptNote -Attempt <path> -Note <文>` | `meta.json` の `notes` に日時付きで 1 行追記する |
| `Get-EnvironmentInfo` | `~/.claude/settings.json` の SHA-256 と、`enabledPlugins` で値が `true` の id 一覧を返す。ファイルが無ければ SHA-256 は null、一覧は空 |
| `Write-Refusal -What <文> -Why <文> -How <文>` | 3 点を 1 つのメッセージにまとめて `throw` する |
| `New-SandboxSettings -Path <file> -MemoryDir <dir> [-Effort <level>]` | `settings.json`（`autoMemoryDirectory`、`permissions.deny`、指定があれば `effortLevel`）を生成する |
| `Get-ProjectStorageDir -Cwd <path>` | F17 の規則で `~/.claude/projects/<名前>` を返す（後片付け用） |
| `Assert-PluginNotEnabled -Plugin <name>` | 6-0 の「起動前の検査」 |
| `Get-AttemptKey -Attempt <path>` | 3-3 の `<attempt_key>` を返す |

### 6-2. `scripts/Start-Sandbox.ps1`（手動確認）

```text
Start-Sandbox.ps1 -Plugin <name> -Name <name> [-Attempt <path>] [-Fixture <dir>] [-Model <id>] [-Effort <level>] [-AutoClean]
```

1. 引数だけで判定できる検査を先に行う（6-0「拒否の順序」）。`-Plugin _marketplace` は拒否する。`work/<plugin>/sandbox/<YYYYMMDD>_<name>/`（日付は実行日）が既にあれば拒否する。次に `Assert-PluginNotEnabled` を行う。`-Attempt` があれば `Assert-CleanTree`、`Get-TargetIdentity`、`Resolve-Attempt` で作業ツリーが clean で対象が一致することを確認する。`-Attempt` が無ければ clean 検査は行わない（証跡を作らないため）
2. `work/<plugin>/sandbox/<YYYYMMDD>_<name>/` を作る
3. `repo/` を作って `git init` し、リポジトリ内だけの `user.name` と `user.email` を設定する。リモートは設定しない。`-Fixture` があれば中身を `repo/` にコピーする
4. `memory/` と `settings.json` を作る
5. `-Attempt` があれば、起動する旨、`plugin_tree`、使った `-Model` / `-Effort` を `Add-AttemptNote` で記録する（手動確認の実行は `New-Attempt.ps1` が登録済みなので、ここでは実行を追加しない。ノートは消せないので起動の直前に書く）。`repo/` に `Set-Location` し、6-0 の共通引数で対話セッションを起動する
6. 終了後、`memory/` にファイルがあれば一覧を表示する（作業指示者が記録に添えるため）。次に `Get-ProjectStorageDir` で `~/.claude/projects/` 側のディレクトリを特定し、後片付けのコマンド（サンドボックスの削除とそのディレクトリの削除）を表示する。`-AutoClean` のときは一覧の表示の後に両方を削除する

証跡は作らない。手動確認の記録は、`New-Attempt.ps1` で作った試行の `manual/` に作業指示者が置く。

### 6-3. `scripts/Invoke-Probe.ps1`（ハーネス）

```text
Invoke-Probe.ps1 -Plugin <name> -Case <name> [-Method <probe または skill-creator>] [-Runs <n>] [-Baseline] [-Iteration <n>]
                 [-Model <id>] [-Effort <level>] [-Activity <YYYYMMDD>] [-Attempt <path>] [-Purpose <値>] [-Goal <文>] [-Reason <文>] [-Notes <文>]
```

1. 引数と case 定義だけで判定できる検査を先に行う（6-0「拒否の順序」）。`-Method` の既定は `probe`。`skill-creator` のときは `-Iteration` が必須、`probe` のときに `-Iteration` があれば拒否する。case 定義 `tools/harness/cases/<plugin>/<case>.json` を読み、無ければ拒否する。case 定義に `baseline: false` があって `-Baseline` が指定されたら拒否する（prompt 先頭のスラッシュコマンドは without 腕でエラーになるため。F28）。case 定義の `allowed_tools` に素の `Write` / `Edit` / `Bash` があれば拒否する（6-0 の `--allowedTools`）。次に `Assert-PluginNotEnabled` と 5-1 の共通処理を行う（`-Attempt` 指定時は 5-1 末尾の手順）。prompt は、with 腕では case 定義の `invocation`（あれば）と `prompt` を連結したもの、without 腕では `prompt` だけ
2. `<config>` は `-Baseline` なら `without_skill`、それ以外は `with_skill`。`<k>` は、証跡側の `<case>/<config>/` にある既存の最大 `run-<k>` の次から `-Runs`（既定 1）個を振る。`work/` 側に同じ run のディレクトリが既にあれば拒否する
3. 各 run について、作業ディレクトリ（3-3）に `settings.json` と `run.json` を書き、`python -X utf8 tools/harness/run_one.py --run-spec <run.json>` を呼ぶ。`run.json` の項目は下表。Python 側は `build_fixtures.py` で `repo/`（git init 済み）と `memory/` を作り、`claude -p` を実行し、記録を整形し、`extract.py` で機械判定用の事実（`facts.json`）を書き、`grading.auto.json`（機械判定だけの採点）と `timing.json` を書く。`run_one.py` の終了コードは、0 が正常、1 が `claude` の起動失敗かタイムアウト、2 が記録の整形失敗（`claude` 自身の応答内容や `permission_denials` の有無は成否に含めない。それらは採点の対象）。ある run が 1 か 2 で終わっても残りの run は続け、`-Runs` 個すべてを実行してから手順 4 へ進む（割り当てた `<k>` はすべて消費する）
4. 要点を証跡へコピーする。失敗した run も、残っている記録と `run_one.py` の終了コードを添えてコピーし、`<k>` を消費する（再実行で `work/` 側と衝突しないため）。`repo/` はコピーせず、`git status --short` と `git diff` の出力で代える。`run.json` は、パス項目を 7-4 の相対パス規約で書き換えた写しをコピーする（`dirs.*` と `--settings` / `--add-dir` の値は `<WORK>`、`case` は `<TEST_REPO>`、`--plugin-dir` は `<MARKETPLACE_DIR>` になる）。コピー先は `-Method` で変わる
   - `probe`: 試行の `probe/<case>/<config>/run-<k>/`
   - `skill-creator`: 試行の `skill-creator/iteration-<n>/eval-<id>-<case>/<config>/run-<k>/`（skill-creator 同梱の `aggregate_benchmark` と `generate_review.py` がそのまま読める配置）。その iteration の最初の実行で、`tools/harness/cases/<plugin>/` の全 case 定義から skill-creator 用の `evals.json` を `skill-creator/iteration-<n>/` に生成する（既にあれば生成しない。生成時点で定義済みの全 case を含める。生成後に追加した case は含まれない）。形式は skill-creator の `references/schemas.md` に合わせ、`skill_name`（Plugin 名）と `evals[]`（`id`、`name`、`prompt`、`expected_output`、`expectations`）を持つ（`name` は schemas.md に無い本書独自の追加項目。同梱スクリプトは読まない）。`id`、`name`、`prompt`、`expected_output` は case 定義の同名項目を写し（`prompt` には `invocation` を付けない）、`expectations` は case 定義の `expectations[].text` を順に並べた文字列の配列にする（`id` は含めない。判定との結び付けは case 定義の側で行う）
5. 全 run の `run_one.py` が 0 ならその実行を `completed` にし、1 つでも 1 か 2 があれば `aborted`（`result` に失敗した run の `<k>` と終了コードの一覧を添える）にして終了コード 1 で終わる。どちらの場合も試行のパスを表示する（A のセッションで Claude が控える）。手順 1〜4 の途中で例外が出たときは 6-0 の `finally` の規則に従う

`run.json` の項目（本書が決める範囲。補助項目は実装時に追加してよい）:

| 項目 | 内容 |
|---|---|
| `case` | case 定義のパス（絶対） |
| `config` | `with_skill` か `without_skill` |
| `run` | `<k>` |
| `dirs.run`、`dirs.repo`、`dirs.memory` | 作業ディレクトリの絶対パス |
| `claude.args` | `claude` に渡す引数の配列。先頭の `-p` と prompt 本文、`--output-format stream-json`、`--verbose`、`--no-session-persistence` を含む完成形。PowerShell が組み立てる |
| `timeout_seconds` | 既定 600 |
| `model`、`effort` | 記録用（引数には `claude.args` 経由で含まれている） |

コピーする要点と置き場所（`probe` と `skill-creator` で同じ）: `run-<k>/outputs/` に、プロンプト、タイムライン（ツール呼び出しの合間のテキストを含む）、最終応答、途中テキストの一覧、memory の差分、git の状態、費用を置く。`run-<k>/` 直下に `facts.json`、`grading.auto.json`、`timing.json`、相対化した `run.json` を置く（`grading.json` も 6-4 がここに書く）。`outputs/` は skill-creator 同梱のビューア（`generate_review.py`）が run を見つける条件で、`aggregate_benchmark` は `run-<k>/grading.json` を読む。

### 6-4. `scripts/Invoke-ProbeGrade.ps1`（手動判定の取り込み）

```text
Invoke-ProbeGrade.ps1 -Attempt <path> -Method <probe または skill-creator> -Judgments <file> [-Iteration <n>]
```

1. `Assert-AttemptOpen` を行う。`-Method skill-creator` のときは `-Iteration` が必須で、試行の `skill-creator/iteration-<n>/` が無ければ拒否する。`-Method probe` で `-Iteration` が指定されていれば拒否する。以下の「手法フォルダ」は、`probe` では `probe/`、`skill-creator` では `skill-creator/iteration-<n>/` を指す
2. `-Judgments` は手動判定の JSON。形式は次のとおり。期待項目の正本は case 定義の `expectations`（`id` と `text` を持つ配列）で、判定はその `id` で結び付ける

   ```json
   {
     "runs": {
       "<case>/<config>/run-<k>": {
         "<expectation id>": { "passed": true, "evidence": "根拠" }
       }
     }
   }
   ```

   作業指示者か A のセッションの Claude が、試行配下の記録を読んで作る。`<case>` の部分は、`skill-creator` では `eval-<id>-<case>` と読み替える
3. 対象は `-Judgments` に載っている run だけ。載っていない run には触れない。次のいずれかに当たる run が 1 つでもあれば全体を拒否する: 手法フォルダの下にその run が無い、その run に `grading.auto.json` が無い（失敗した run）、その run に既に `grading.json` がある（7-4）。判定に case 定義の `expectations` に無い `id` があれば拒否する。欠けの検査は、`expectations` の `id` のうちその run の `grading.auto.json` に結果が無いもの（`auto_checks` が判定しない項目）を対象とし、1 つでも手動判定が無ければ拒否する。機械判定の結果がある `id` に手動判定もある場合は、手動判定を優先する（移行元の `grade.py` と同じ）。確認が通れば各 run について `grade.py` を呼び、`facts.json` と手動判定を合わせて `grading.json` を書く。`-Judgments` のファイルは手法フォルダ直下に `judgments-<yyyyMMdd_HHmmss>.json` としてコピーして残す
4. `Add-AttemptNote` で判定を取り込んだ旨を記録する

採点は 2 段階になる。`Invoke-Probe.ps1` が機械判定（`grading.auto.json`）まで行い、人の判定が要る項目は本スクリプトで `grading.json` に確定する。skill-creator の集計（`aggregate_benchmark`）は `grading.json` を読む。

### 6-5. `scripts/Invoke-PluginEval.ps1`（B-2）

```text
Invoke-PluginEval.ps1 -Plugin <name> [-Case <glob>] [-Runs <n>] [-Ablation <none または with-without>] [-AllowTools <list>] [-MaxCostUsd <n>]
                      [-Model <id>] [-JudgeModel <id>] [-Activity <YYYYMMDD>] [-Attempt <path>] [-Purpose <値>] [-Goal <文>] [-Reason <文>] [-Notes <文>]
```

1. `-AllowTools` に `Bash` か `PowerShell` が、素の形でも `Bash(...)` の形でも含まれていれば拒否する（F26。全 case が拒否され採点 0 になるため）。引数だけで判定できるので 5-1 の前に行う（6-0「拒否の順序」）
2. 5-1 の共通処理を行う。`-Model`（省略時 `CLAUDE_TEST_MODEL`）と `-JudgeModel`（省略時 `CLAUDE_TEST_JUDGE_MODEL`）の値を、その実行の `model` / `judge_model` に記録する（どちらも無ければ null。7-2）
3. `claude plugin eval` を次の順で組み立てて実行する（target を先頭に置く。F37）。標準出力と標準エラーは `plugin-eval/<yyyyMMdd_HHmmss>/console.txt` に保存する

   | 位置 | 内容 |
   |---|---|
   | 1 | `<MARKETPLACE_DIR>/plugins/<plugin>` |
   | 2 | `--no-publish --trust-plugin --output-dir <試行>/plugin-eval/<yyyyMMdd_HHmmss> --max-cost-usd <n>`（`-MaxCostUsd` の既定 3） |
   | 3 | `-Case` があれば `--case <glob>`、`-Runs` があれば `--runs <n>`、`-Ablation` があれば `--ablation <mode>` |
   | 4 | `-Model`（省略時 `CLAUDE_TEST_MODEL`）があれば `--model <id>`、`-JudgeModel`（省略時 `CLAUDE_TEST_JUDGE_MODEL`）があれば `--judge-model <id>` |
   | 5 | `-AllowTools` があれば最後に `--allow-tools <list...>` |

4. 終了コードを記録する（F37）。出力先に `aggregate-result.json` があれば、`aggregates.overallScore`、`aggregates.casesPassed`、`aggregates.casesTotal`、`aggregates.meanDelta`、`partial`、`costUsd` を `summary.json` に抜き出して表示し、その実行を `completed`（結果に終了コードと `partial` を添える）にする。終了コード 2 と 130 の部分実行も、`aggregate-result.json` があれば `completed` とする（7-2 の例）。無ければ `aborted` にする（終了コード 1 のうち実行前に止まった場合、143 など）。どの場合も証跡は残す
5. `claude plugin eval` の終了コードをそのまま返す

### 6-6. `scripts/Invoke-Validate.ps1`（C）

```text
Invoke-Validate.ps1 -Plugin <name> [-Activity <YYYYMMDD>] [-Attempt <path>] [-Purpose <値>] [-Goal <文>] [-Reason <文>] [-Notes <文>]
```

1. 5-1 の共通処理を行う
2. `claude plugin validate --strict <MARKETPLACE_DIR>/plugins/<plugin>` と `claude plugin validate --strict <MARKETPLACE_DIR>` を実行する。`-Plugin _marketplace` のときは後者だけ。`-Plugin <name>` のとき、後者の対象（`marketplace.json` や他の Plugin）は 5-1 の clean 検査と同一性（`plugin_tree`）の範囲外で、同じ断面に別の Marketplace 状態の結果が積まれうる。Marketplace 全体の状態を断面として残したいときは `-Plugin _marketplace` で実行する（割り切り）
3. 両方の出力に Claude Code の版、commit、実行日時を添えて `validate/<yyyyMMdd_HHmmss>.txt` に保存する
4. 検証が失敗しても証跡は残し、その実行を `completed`（結果に終了コードを添える）にした上で終了コード 1 で終わる。`claude` が起動できないなどの実行失敗は `aborted` にする

### 6-7. `scripts/New-Attempt.ps1` と `scripts/Set-MethodStatus.ps1`（手動確認用）

```text
New-Attempt.ps1 -Plugin <name> -Method <name> [-Model <id>] [-Effort <level>] [-Activity <YYYYMMDD>] [-Attempt <path>] [-Purpose <値>] [-Goal <文>] [-Reason <文>] [-Notes <文>]
Set-MethodStatus.ps1 -Attempt <path> -Method <name> -Status <completed または aborted> [-Notes <文>]
```

- `New-Attempt.ps1` は 5-1 の共通処理だけを行い、手法フォルダを空で作って試行のパスを表示する。`-Attempt` で既存の試行に同じ手法の実行を追加するとき、手法フォルダが既にあればそのまま使う（拒否しない）。手法は `manual` を想定するが、他の名前も受け付ける。`-Model` / `-Effort` は手動確認で使う予定の値を実行の記録に残すためのもの
- `Set-MethodStatus.ps1` は、5-1 の共通処理を通さず、`Assert-AttemptOpen` の後に、その手法の最新の実行を `-Status` の状態にする（`Set-InvocationStatus`）。手法が試行に無い場合と、最新の実行が `running` でない場合は拒否する。記録を置き終えた作業指示者が実行する。作業ツリーの clean や HEAD の一致は要求しない（完了報告の時点で Plugin が変わっていても、テストした対象は `meta.json` に記録済みのため）

### 6-8. `scripts/Complete-Activity.ps1`

```text
Complete-Activity.ps1 -Plugin <name> [-Version <ver>] [-Activity <YYYYMMDD または YYYYMMDD_fin>] [-Force]
```

1. 対象を特定する。未指定なら `evidence/<plugin>/` 配下で版をまたいだ open の活動を探し、0 件か 2 件以上なら拒否する。`-Activity` 指定時は `-Version` も必須（`_multi-plugins` と `_marketplace` では不要）で、そのフォルダを使う。`_fin` 付きの指定は、手順 2〜4 を飛ばして手順 5 だけを行う再実行として扱う
2. 活動内の全試行の `invocations[]` を直接走査し、`running` の実行が残っていれば一覧を表示する。`-Force` が無ければ拒否する（手動確認の `Set-MethodStatus.ps1` の忘れを防ぐ）。`-Force` があれば、それらの実行を `aborted`（`result` に「Complete-Activity による強制終了」と記録）にしてから進む
3. `activity.json` の `closed_at` が null なら書く（既に値があれば変えない）
4. フォルダ名に `_fin` を付ける
5. `evidence/<plugin>/README.md`（7-3）に行を追加する。README が無ければ見出し行から作る。同じ（版、活動名）の行（`_multi-plugins` と `_marketplace` では同じ活動名の行）が既にあれば追加しない（再実行しても重複しない）

途中で失敗した場合: 手順 3 まで終わっていればフォルダ名は open のままなので、再実行で手順 4 と 5 が行われる。手順 4 まで終わっていれば、`-Activity` に `_fin` 付きの名前を渡して手順 5 だけを行う。

### 6-9. `scripts/Find-Evidence.ps1`

```text
Find-Evidence.ps1 -Plugin <name> -Commit <ref>
```

`Get-TargetIdentity -Commit <ref>` で `plugin_tree`（`_multi-plugins` と `_marketplace` では `tree`）を計算し、`evidence/<plugin>/` 配下の全 `meta.json` を照合して、一致する試行の一覧（活動・断面・試行・実行日時・手法と状態）を表示する。その commit に `plugins/<plugin>` が無ければ `Get-TargetIdentity` が「Plugin が無い」で拒否するので、本スクリプトはそれだけを捕まえて「その commit に Plugin が無い」旨を表示し、終了コード 0 で終わる（一致する試行が 0 件の場合と同じ扱い。拒否ではない）。`<ref>` が解決できない「ref が不正」は捕まえず、通常の拒否（終了コード 1）とする。rebase で commit ハッシュが変わった後でも、同じ内容をテストした証跡を見つけられる（D6、F31）。

### 6-10. `tools/harness/`

前回の評価で使った Python（`marketplace-for-cc-evals\pre-compact\raw-2026-10-10\tools\`）を移し、Plugin ごとの case 定義と共通部分に分ける。すべての入出力で `encoding="utf-8"` を明示し、外部コマンドの `diff` は `difflib` に置き換える（F39、PowerShell の PATH に `diff` が無いため）。pre-compact 固有の機械判定（silent の判定、`/compact` コメント案の長さや構文）は、case 定義の `auto_checks` に判定の種類と引数を宣言し、`extract.py` と `grade.py` は種類ごとの汎用の判定器を持つ形にする。判定器の種類の一覧は実装時に決める（1-5）。

| ファイル | 役割 | 現行（移行元）との違い |
|---|---|---|
| `cases/<plugin>/<case>.json` | case の定義: `id`、`name`（`<case>` と同じ文字列。ファイル名の語幹とも同じで、`eval-<id>-` を含めない）、fixture（git 履歴と未コミット変更、memory、会話記録）、`prompt`、`invocation`（任意。with 腕だけで `prompt` の先頭に前置する起動行。例 `/pre-compact:pre-compact\n\n`。without 腕は `prompt` だけを使う）、`expected_output`（期待する結果の 1 文。`evals.json` に写す）、`allowed_tools`（追加する Bash パターン）、`baseline`（既定 true。`prompt` 自体がスラッシュで始まる case だけ false にする）、`expectations`（`id` と `text` の配列）、`auto_checks`（判定の種類と引数。対象の `expectations` の `id` を持つ。該当しない run では `grading.auto.json` にその `id` の結果を `"passed": null, "not_applicable": true` で残し、6-4 の欠けの検査では「結果あり」と扱う） | 現行は fixture と期待項目を Python コード（`build_fixtures.py`、`grade.py`）と `evals.json` に埋め込んでいる。JSON へ移す。現行の `evals.json` の `name`（`eval-1-uncommitted` など）は `eval-<id>-` を外して `name` にする。現行 `run_one.py` が with 腕だけに前置していた `/pre-compact:pre-compact\n\n` は `invocation` に移す。現行 `grade.py` が提示された run だけに動的に追加していたコメント案の 4 項目は、静的な `expectations` と `auto_checks` の「該当なし」で表す |
| `build_fixtures.py` | case 定義から `repo/` と `memory/` を作る | 入力を case 定義に変える。`settings.json` は作らない（PowerShell が作る） |
| `run_one.py` | `run.json` を読んで `claude -p` を実行し、記録を整形する。終了コードは 6-3 の定義 | 現行は位置引数 4 つで引数を自分で組み立て、モデルを固定し、`--settings` に JSON 文字列を渡す。すべて `run.json` 由来に変える。`diff` を `difflib` に置き換える。未知の `system` メッセージを無視する |
| `extract.py` | 1 run の記録から機械判定用の事実を `facts.json` に書く | 現行は iteration ディレクトリを受けて全 run を一括処理する。1 run 単位に変え、判定の種類を `auto_checks` から読む |
| `grade.py` | `facts.json` と手動判定を合わせて `grading.json` を書く。手動判定が無ければ `grading.auto.json` を書く | 現行は固定パス（`workspace/evals/evals.json`、`workspace/judgments.json`）を読み、pre-compact 固有の判定を内蔵する。入力の所在をすべて引数で受け、固有の判定を `auto_checks` に移す |
| `run_all.py` | 廃止 | 現行は 5 並列で実行していた。`Invoke-Probe.ps1` の `-Runs` は順次実行なので、run 数に比例して時間が延びる |

## 7. 証跡の規約

### 7-1. `activity.json`

```json
{
  "plugin": "pre-compact",
  "version": "0.9.0",
  "started": "2026-10-10T18:00:00+09:00",
  "closed_at": null,
  "purpose": "feature | release | maintenance | investigation",
  "goal": "1 行で、この活動が何を確かめたら終わるか",
  "timezone": "Asia/Tokyo"
}
```

- 状態（未作成 / 実施中 / 完了）は**フォルダ名の `_fin` を正**とし、`closed_at` は記録用。食い違ったら `_fin` を優先する
- `_multi-plugins` と `_marketplace` では `plugin` に枝の名前を入れ、`version` は null

### 7-2. `meta.json`

```json
{
  "attempt": "00",
  "status": "running | completed | aborted",
  "executed_at": "2026-10-10T19:30:00+09:00",
  "claude_code_version": "2.1.296",
  "model": "claude-opus-5-5 または null（Claude Code の既定に任せた）",
  "effort": "high または null",
  "methods": [
    {
      "name": "skill-creator",
      "status": "completed",
      "invocations": [
        { "n": 1, "status": "completed", "started": "...", "finished": "...", "claude_code_version": "2.1.296", "model": "...", "effort": "...", "judge_model": null, "result": null }
      ]
    },
    {
      "name": "plugin-eval",
      "status": "completed",
      "invocations": [
        { "n": 1, "status": "completed", "started": "...", "finished": "...", "claude_code_version": "2.1.296", "model": null, "effort": null, "judge_model": "claude-haiku-5-5", "result": { "exit_code": 2, "partial": true } }
      ]
    }
  ],
  "target": {
    "commit": "<完全な commit ハッシュ>",
    "sha7": "4733d90",
    "branch": "feat/pre-compact",
    "plugin_tree": "<git rev-parse HEAD:plugins/pre-compact>",
    "tree": "<git rev-parse HEAD^{tree}>",
    "version": "0.9.0",
    "plugins": null
  },
  "environment": {
    "user_settings_sha256": "<~/.claude/settings.json の SHA-256>",
    "enabled_plugins": ["skill-creator@claude-plugins-official"]
  },
  "reason": "再テストの理由。初回は null",
  "notes": ["2026-10-10T19:40:00+09:00 自由記述"]
}
```

- 同一性の判定は `target.plugin_tree`（`_multi-plugins` と `_marketplace` では `target.tree`）で行う。フォルダ名の `<sha7>` と現在の HEAD が違っても、`plugin_tree` が同じなら同じ断面として扱い、`commit` と `sha7` に実際の HEAD を記録する
- `_multi-plugins` と `_marketplace` では `target.plugin_tree` と `target.version` を null にし、`target.plugins` に `[{ "name", "version", "plugin_tree" }]` を列挙する
- 手法の `status` はその手法の最新の実行の状態。試行の `status` は全手法から導く（1 つでも `running` なら `running`、そうでなく 1 つでも `aborted` なら `aborted`、それ以外は `completed`）。古い実行が `running` のまま残ることを検出する処理（`Complete-Activity.ps1`）は、この `status` ではなく `invocations[]` を直接走査する
- 試行の `claude_code_version`、`model`、`effort`、`environment` は最初の実行（試行の作成）時点の値。実行ごとの `claude_code_version`、`model`、`effort`、`judge_model`（`plugin-eval` 以外は null）は `invocations[]` に持つ
- `environment` は F34 の継承を記録するためのもの。ユーザー設定の内容そのものは保存しない
- 証跡内のパス項目は 7-4 の相対パス規約で書く

### 7-3. `evidence/<plugin>/README.md`

| 活動 | 版 | 目的 | 開始 | 完了 | 断面 | 試行 | 結論 |
|---|---|---|---|---|---|---|---|
| `20261010_fin` | 0.9.0 | investigation | 2026-10-10 | 2026-10-11 | 2 | 3 | 文中起動は不可。`disable-model-invocation` を外して対応 |

- `Complete-Activity.ps1` が行を追加し、結論は作業指示者が書く。活動の列はリネーム後の名前。目的の列は `activity.json` の `purpose` の値。行の同一性は（版、活動）の組で判定する（`_multi-plugins` と `_marketplace` では活動名だけで判定する。活動名は枝の中で一意なため）
- `_multi-plugins` と `_marketplace` の README は「版」の列を「対象 Plugin」に置き換える。値は、活動内で最後に作られた試行の `target.plugins` から `name@version` を列挙する

### 7-4. 追記専用の定義

- 既存のファイルは上書きしない。新しいファイルとフォルダの追加はよい。各手法の出力先は実行ごとに一意になるよう 3-2 で決めてあるので、同じ試行で同じ手法を何度実行してもよい
- 既存ファイルの変更が許されるのは次の 5 つ（「変更の許容項目」と呼ぶ）だけ。4 の結論の記入と 5 を除き、スクリプトが行う
  1. `meta.json` の `methods`（`Add-AttemptMethod`、`Set-InvocationStatus`）、`status`（`Add-AttemptMethod`、`Set-InvocationStatus`）、`notes`（`Add-AttemptNote`）の更新
  2. `activity.json` の `closed_at` の初回書き込み（`Complete-Activity.ps1`）
  3. 活動フォルダ名への `_fin` の付加（`Complete-Activity.ps1`）
  4. `README.md` への行の追加（`Complete-Activity.ps1`）と、結論の列の記入（作業指示者）
  5. skill-creator の集計物（`benchmark.json`、`benchmark.md`、`review.html`、`report.md`）の同じ `iteration-<n>/` 内での再生成（A のセッションの Claude）。run の記録と判定は再生成しない
- `grading.auto.json` から `grading.json` への確定（`Invoke-ProbeGrade.ps1`）は新規ファイルの追加であり、上の許容項目には数えない。`grading.json` が既にあれば拒否する
- `_fin` 付きの活動の下には、試行の追加も手法の実行も判定の確定も、集計物の再生成（項目 5）も行わない
- 一意化の規則は、スクリプトが書く手法（`probe`、`skill-creator`、`plugin-eval`、`validate`）に適用する。`manual` は作業指示者が置くので規則の対象外とし、同じ試行で `manual` の実行を複数回登録したときは、ファイル名に実行日時を含めて既存ファイルを上書きしない運用とする
- **パスの書き方**（「相対パス規約」と呼ぶ）。対象は、本書のスクリプトが書く JSON のパス項目（`meta.json`、`run.json` の写し、`summary.json` など）に限る。記録した生の出力（`console.txt`、`validate/*.txt`、`aggregate-result.json`、タイムライン、`git diff` の出力など）に含まれる絶対パスは書き換えない。パス項目は次の順で最初に当たる規則で書く（`_fin` でフォルダ名が変わるため、試行フォルダを基準にする）。「配下」はパス区切りで区切った部分の一致で判定し、文字列の前方一致では判定しない（`C:/cc-workspace/marketplace-for-cc-test/tools/...` は `C:/cc-workspace/marketplace-for-cc` の配下ではない。前方一致で判定すると規則 3 が先に当たり、`<TEST_REPO>` で書くべきパスが `<MARKETPLACE_DIR>-test/...` と誤変換される）
  1. 試行フォルダの中を指すパス: 試行フォルダからの相対パス
  2. `work/` 配下: `<WORK>` を前置した `work/` からの相対パス
  3. `MARKETPLACE_DIR` 配下: `<MARKETPLACE_DIR>` を前置した相対パス
  4. ユーザーのホーム配下: `<HOME>` を前置した相対パス
  5. テスト用リポジトリ内のその他（`tools/harness/cases/` など）: `<TEST_REPO>` を前置したリポジトリルートからの相対パス
  6. 上記のいずれにも当たらないパス: 絶対パスのまま
- 移行した既存データ（8 節）は絶対パスを含むが、「相対パス規約の免除」として直さない
- 絶対パスは 200 文字以内を目安にする

## 8. 既存データの移行

前回の評価と確認は、marketplace-for-cc の commit `4733d90`（pre-compact 0.9.0 初版）と `2fb2068`（`disable-model-invocation` を外した版）を対象に行った。1 つの活動（`investigation`、2026-10-10 開始、2026-10-11 完了）として移す。試行の `meta.json` と `activity.json` は手で書く。`plugin_tree` は `git rev-parse 4733d90:plugins/pre-compact` と `git rev-parse 2fb2068:plugins/pre-compact` で計算する。

移行先の接頭辞 `E` = `evidence/pre-compact/0.9.0/20261010_fin/`。移行した記録は、3-2 の手法フォルダ内の構成（`<case>/<config>/run-<k>/` など）に合わせず、当時の構成のまま置く。当時の絶対パスも書き換えない（7-4 の「相対パス規約の免除」）。移行した手順書には「`~/.claude/projects/` に何も残らない」という旧記述があるので、`meta.json` の `notes` に F36 を参照する注記を付ける。移行後、`Complete-Activity.ps1 -Plugin pre-compact -Version 0.9.0 -Activity 20261010_fin` で README の行を作る（6-8 の手順 5 だけの再実行）。

| 移行元（`marketplace-for-cc-evals\pre-compact\`） | 移行先 | 備考 |
|---|---|---|
| `iteration-1\report.md`、`review.html`、`evals.json`、`judgments.json` | `E/00_4733d90/00/skill-creator/` | 報告書・ビューア・case 定義・手動判定。`workspace\evals\evals.json` と `workspace\judgments.json` は同じ内容なので移さない |
| `iteration-1\benchmark.json`、`benchmark.md` | 移さない | 次行の `iteration-1/` 内の同名ファイルと同じ内容 |
| `raw-2026-10-10\workspace\iteration-1\`（`benchmark.json`、`benchmark.md`、各 `eval-*/<config>/run-*/` の記録と採点。`sandbox/` は除外済み） | `E/00_4733d90/00/skill-creator/iteration-1/` | そのまま移す |
| `raw-2026-10-10\workspace\run_all.log` | `E/00_4733d90/00/skill-creator/run_all.log` | 実行ログ |
| `raw-2026-10-10\probe\midmsg.jsonl`、`midmsg.err` | `E/00_4733d90/00/probe/midmsg/` | 非対話での文中起動拒否の記録。当時の構成のまま |
| 作業指示者の確認 1（文中起動、対話）と確認 2（`/cd` と memory）の記録 | `E/00_4733d90/01/manual/` | 記録の本文は作業指示者の手元にある。転記して置く |
| `.claude/work/test-repo-verification-procedure.md` | `E/00_4733d90/01/manual/procedure.md` | 移した後、`.claude/work/` 側は消す。本書の表紙の参照先もこの移行先に読み替える |
| ゲート方式への変更後の肯定・否定テスト（2026-10-11、`claude -p`） | `E/01_2fb2068/00/probe/` | 記録は前セッションの一時領域にあり、残っていれば移す。無ければ `meta.json` の `notes` に結果の要約だけ書く |
| `raw-2026-10-10\tools\*.py` | `tools/harness/`（9 節の段階 4 で移植する） | 6-10 の変更を加える |
| `raw-2026-10-10\workspace\preflight\` | 移さない | ハーネスの事前確認の実行記録で、評価の一部ではない |
| `raw-2026-10-10\workspace\skill-snapshot\` | 移さない | 評価時の Plugin の複製。commit `4733d90` で代替する |

## 9. 作業順

一度に作らない。各段階で動作を確認してから次へ進む。段階 2〜5 の確認で作る活動と試行は本物の証跡ではないので、テスト用リポジトリを別の場所（例: `C:\cc-workspace\marketplace-for-cc-test-verify`）にクローンした使い捨てのコピーで行い、確認後にコピーごと捨てる。`evidence/` の下に確認用の活動を残さない。

| 段階 | 作業 | 確認方法 |
|---|---|---|
| 1 | リポジトリ作成、`README.md`、`.gitignore`、`.gitattributes`、`.claude/settings.json`、`test-repo-guide` skill（3-5） | `claude` を直下で起動し、`/test-repo-guide` が出ること。`work/` 配下に `git init` した環境を作って起動し、skill が見えないこと |
| 2 | `Evidence.psm1`、`Invoke-Validate.ps1`、`New-Attempt.ps1`、`Set-MethodStatus.ps1` | pre-compact に対して `-Purpose investigation -Goal ...` 付きで実行し、`evidence/pre-compact/0.9.0/<今日>/00_<sha7>/00/validate/<yyyyMMdd_HHmmss>.txt` ができること。同じ試行に `-Attempt` で再実行すると 2 つ目の `.txt` が増えること。`-Purpose` 無しで新規作成しようとすると拒否されること。`-Attempt` に HEAD と異なる断面の試行を渡すと拒否されること。`New-Attempt.ps1 -Method manual` で試行を作り、`Set-MethodStatus.ps1 -Status completed` で完了にでき、もう一度実行すると拒否されること |
| 3 | `Start-Sandbox.ps1` | 起動したセッションで `/plugin` の Installed に `pre-compact` が `Plugin inline` で載ること。`/memory` の「Open auto-memory folder」が `memory/` を開くこと。cwd 外への書き込みが拒否されること。終了後に表示された後片付けを実行し、`~/.claude/projects/` に残骸が無いこと |
| 4 | `tools/harness/` の移植と `Invoke-Probe.ps1`、`Invoke-ProbeGrade.ps1` | 前回の case 1 を `-Method probe` で 1 run 実行し、`probe/<case>/with_skill/run-1/` に記録が入ること。`-Baseline` で同じ case を同じ試行に実行し、`without_skill/run-1/` に入ること。もう一度 with 腕を実行すると `run-2` になること。`-Method skill-creator -Iteration 1` で実行し、`Invoke-ProbeGrade.ps1 -Method skill-creator -Iteration 1` で `grading.json` ができ、2 回目は拒否されること。その後、skill-creator 同梱の `aggregate_benchmark` がその配置と `grading.json` を読めること。`~/.claude/projects/` に何も増えないこと（F36 の併用時の確認を兼ねる） |
| 5 | `Complete-Activity.ps1`、`Find-Evidence.ps1` | 段階 2〜4 の活動を閉じて `_fin` が付き、README が無い状態から見出し行と 1 行が作られること。再実行で行が増えないこと。`running` の実行が残っていると拒否されること。`Find-Evidence.ps1 -Plugin pre-compact -Commit HEAD` が試行を返すこと |
| 6 | 既存データの移行（8 節） | 本物のテスト用リポジトリで行う。`Find-Evidence.ps1 -Plugin pre-compact -Commit 4733d90` が移行した試行を返すこと。README に `20261010_fin` の行があること |
| 7 | `Invoke-PluginEval.ps1` | pre-compact の suite（B-1）ができてから。それまでは着手しない。実施時に、終了コード 2 と 130 のとき `aggregate-result.json` が書かれ `partial: true` を持つこと（F37）を確かめる |

## 10. 残課題

- `context.history_file` の `.jsonl` の形式は未確認。実セッションの記録を流用するなら、形式を先に確かめる
- probe でユーザー設定（F34）を読まない方法として `--setting-sources` の利用が考えられるが、未検証。当面は `meta.json` の `environment` に記録し、`Assert-PluginNotEnabled` で対象 Plugin の混入だけを防ぐ。拒否の代わりにサンドボックスの `settings.json` で `enabledPlugins` を上書きする案は、`--settings` がユーザー設定より優先されるか未確認
- `LongPathsEnabled` の有効化は、パスが 200 文字を超える見込みが出たときに検討する。現状は不要
- `_multi-plugins` のテスト内容は、対象となる Plugin の組み合わせが出てから設計する。構成と `-Plugin _multi-plugins` の扱いだけを用意する
- `claude plugin eval` の終了コード 2 と 130 のとき、`aggregate-result.json` が書かれ `partial: true` を持つか（F37）は段階 7 で確かめる
- `acceptEdits` を明示したときに F10 の分類器の通知が出ないかは未確認。整形側で無視する対処で影響を受けない

## 付録 A. 公式 docs の検索語

行番号がずれたときは、`llms-full.txt` を次の文字列で `grep -F` して辿り直す。検索語は原則として記号を除いた部分文字列にしてある。docs 側でバッククォートに囲まれた語を含む検索語は、バッククォートごと `grep -F` に渡す。

| # | 検索語 |
|---|---|
| F1 | How CLAUDE.md files load |
| F2 | and every parent directory for CLAUDE.md and rules |
| F3 | Claude Code loads project skills from |
| F4 | keys load from the current working directory |
| F5 | Exclude specific CLAUDE.md files |
| F6 | Move the session to another directory |
| F7 | relocates it to the new directory's project storage |
| F8 | checks file permissions against / rules govern all built-in tools that write files |
| F9 | paths are normalized to POSIX form before matching / Fixed path permission matching to consistently use POSIX format |
| F10 | Auto mode classifier request charges |
| F11 | for paths in the working directory or |
| F12 | other shell commands and network requests still need an |
| F13 | Read and Edit deny rules apply to Claude's built-in file tools |
| F14 | Input must be provided when using |
| F18、F19 | Flags that load a plugin for one session / Load a folder of plugins / at a marketplace root doesn't load the plugins under |
| F20 | You started Claude Code with / plugin skills and agents get the plugin name as a prefix |
| F23 | is not a plugin or skill folder / Use a different eval directory |
| F24 | Choose what to evaluate / and `report.html` go / Every run with at least one case writes / proposes the cases and graders, tries them |
| F25 | How runs are isolated |
| F26 | in any form, every command runs under / The sandbox runs on macOS, Linux, and WSL2 |
| F28 | Fixed unknown slash commands silently doing nothing in headless |
| F29 | Seed the workspace or conversation |
| F30 | to assert the trust yourself |
| F35 | autoMemoryDirectory |
| F37 | Put the target before / Partial run: / aggregates.overallScore / 32085 行は F24 の Every run with at least one case writes |
| F38 | Name conflicts |

## 変更履歴

| 版 | 日付 | 内容 |
|---|---|---|
| 2.0 | 2026-10-11 | 前版（Opus 5.5）にレビューと作業指示者の決定事項 D1〜D7 を反映して清書 |
| 2.1 | 2026-10-11 | セルフチェック 1 巡目（Sonnet、29 件）を反映。docs 行番号を 2026-10-11 15:00 版に更新し付録 A を追加。`~/.claude/projects/` の残骸（F36）、追記専用の定義、活動の入力経路と同日の衝突、`_multi-plugins` / `_marketplace` の扱い、A の実行経路（`-Method`）、`meta.json` の入力元、README 列の統一、clean 検査の範囲と B-1 後の commit、`Invoke-PluginEval.ps1` の終了コードと JSON パス、段階 1 の成果物（3-5）、F34・F35・F37 の追加、用語対応表（1-4）、移行表の網羅 |
| 2.2 | 2026-10-11 | セルフチェック 2 巡目（Sonnet、33 件）と docs 差分判定（要修正 0 件、補強 3 件）を反映。7-4 の例外の明記、活動を版に紐づけ版違いの open を拒否、probe にも `<config>` 層を導入、PowerShell と Python の責務分担（`run.json`）、`-Attempt` 時の同一性検査（`Resolve-Attempt`）、手動判定の 2 段階化（`Invoke-ProbeGrade.ps1`）、`-Plugin` 値とスクリプトの対応表、`New-Attempt.ps1` の追加、手法ごとの状態、`Get-TargetIdentity -Commit`、失敗時の `finally`、`enabledPlugins` の検査（F38）、Python の `-X utf8`（F39）と `difflib`、F37 の終了コードを docs どおりに、F7・F11・F12 に docs の根拠を追記、付録 A と移行表の修正、`-New` の廃止 |
| 2.3 | 2026-10-11 | セルフチェック 3 巡目（Sonnet、27 件）を反映。同じ手法の複数回実行を許す構成（手法内の出力先を実行ごとに一意化、`invocations[]`）、`Set-MethodStatus.ps1` の新設と `New-Attempt.ps1 -Complete` の廃止、作業領域のキー `<attempt_key>`、3-2 の skill-creator の構成の修正、A の流れに `Invoke-ProbeGrade.ps1` を明記、`run.json` と判定 JSON のスキーマ、6-10 の現行との差分の明記、`Assert-PluginNotEnabled` の `_multi-plugins` 対応、README の重複判定を（版、活動）に、`Start-Sandbox.ps1 -Attempt`、`Invoke-PluginEval.ps1` の引数順序と終了コード 130/143、`-Attempt` と併用できる引数の表、F10 と F38 の根拠の訂正、F37 に target の順序を追加、7-4 の例外を 4 つに整理、確認用の活動を使い捨てコピーで行う方針、本書が決める範囲の明記（1-5）、付録 A の検索語を記号なしに統一 |
| 2.4 | 2026-10-11 | セルフチェック 4 巡目（Sonnet、17 件）を反映。skill-creator の集計物を `iteration-<n>/` 内に置き再生成を許容項目 5 に追加、`evals.json` を全 case から iteration ごとに生成、失敗 run も証跡に残して `<k>` を消費、`run.json` の相対化の基準を試行フォルダに統一しトークンを定義、`Complete-Activity.ps1 -Force` と再実行の手順を訂正、`Set-InvocationStatus` と `Set-MethodStatus.ps1` の拒否条件、`Invoke-ProbeGrade.ps1` の対象 run と拒否の粒度、`Start-Sandbox.ps1 -Attempt` の clean 検査と `-Effort`、`New-Attempt.ps1` の `-Model` / `-Effort`、`-Plugin` 対応表の修正、用語表に run を追加、「例外」の語を「変更の許容項目」と「相対パス規約の免除」に分離、F12・F37 の行番号、付録 A の F24 検索語、段階 2 の確認項目 |
| 2.5 | 2026-10-11 | セルフチェック 5 巡目（Sonnet、15 件）を反映。付録 A の F24 の検索語をバッククォート込みに修正し根拠行に直結する語へ変更、`Invoke-ProbeGrade.ps1` に `-Iteration` を追加し拒否条件（存在しない run、`grading.auto.json` の無い run）を追加、7-4 の許容項目 5 の実行主体と `_fin` 配下での禁止を明記、相対パス規約を 7-4 に集約（対象を JSON のパス項目に限定、`<TEST_REPO>` トークンと優先順位を定義）、`manual` を一意化規則の対象外に、6-0 の `-Attempt` 併用表に `Start-Sandbox.ps1` の例外、`Add-AttemptMethod` の状態再計算、`finally` の条件を `running` のときに限定、`Invoke-Probe.ps1` の失敗 run の扱い（全 run を続行し最後に `aborted`）、`Invoke-PluginEval.ps1` の完了判定に `results.json` を追加、`evals.json` の `expected_output` の生成規則、`Find-Evidence.ps1` の Plugin 無し時の終了コード、変更履歴の並び順 |
| 2.6 | 2026-10-11 | セルフチェック 6 巡目（Sonnet、14 件。要修正 0）を反映。F37 の `results.json` の読み違いを訂正（CI 例の `--json` 指定名であり、出力先の既定は `aggregate-result.json`）し 6-5・9 節・10 節を揃える、6-4 の欠けの検査対象を `grading.auto.json` に結果が無い `id` に限定し手動優先を明記、`judge_model` を `invocations[]` と関数に追加、`manual` の除外を 3-2・6-7・7-4 に反映、6-0 に「拒否の順序」（引数だけで判定できる拒否は 5-1 の前）を追加し 6-3・6-5 の手順を並べ替え、付録 A の F24 に 32085 行の検索語、相対パス規約の「配下」をパス区切りで判定、5-2 の A の流れ (2) と段階 4・7 の確認順序、README の同一性を `_multi-plugins` / `_marketplace` では活動名だけに、`evals.json` の形式を skill-creator の schemas.md に合わせ `expected_output` を case 定義に追加、`Get-TargetIdentity` の「ref が不正」と「Plugin が無い」を区別し `Find-Evidence.ps1` の捕捉範囲を限定、`environment` を最初の実行時点の値と明記 |
| 2.7 | 2026-10-11 | セルフチェック 7 巡目（Sonnet、15 件。要修正 0）を反映。case 定義に `invocation`（with 腕だけの起動行）を追加し `<case>` と `name` の関係と `eval-<id>-` の扱いを定義、`auto_checks` の「該当なし」の記録方法、6-0「拒否の順序」を全スクリプトに適用し `allowed_tools` の検査とサンドボックス既存の検査を加え 6-2 の手順を並べ替え（ノートは起動直前）、7-4 の「配下」の例を誤変換が起きる向きに訂正、`evals.json` の `name` を独自項目と注記、run の記録を `outputs/` に置く配置（ビューアの条件）、6-6 の Marketplace 検証の範囲の割り切り、F37 の行番号範囲（`costUsd` 32122 行）と付録 A の検索語、`-Effort` を取るスクリプトに `Start-Sandbox.ps1`、`<timestamp>` を `<yyyyMMdd_HHmmss>` に統一、5-2 の A の流れ (3) の必須引数、B-1 に `.gitignore` の追加を担当させる、変更履歴 2.6 の記載漏れ |
