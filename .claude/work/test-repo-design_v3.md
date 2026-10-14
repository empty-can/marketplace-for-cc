# marketplace-for-cc-test 設計書 v3

| 項目 | 内容 |
|---|---|
| 版 | 3.3（v3.2 の差分に限定した Sonnet の最終確認 17 件を反映した版） |
| 日付 | 2026-10-11 |
| 作成 | Claude（Fable 5.1）。作業指示者との検討結果を清書 |
| 位置づけ | テスト用リポジトリ `marketplace-for-cc-test` と各種スクリプトを開発するときの**唯一のインプット**。v2 系（`test-repo-design_v2.md`、最終 v2.7）、前版 `test-repo-design.md`（Opus 5.5）、レビュー `test-repo-design-review-fable.md`、確認手順書 `test-repo-verification-procedure.md`（9 節で証跡へ移す予定）は経緯の参照用で、本書と食い違う場合は本書を正とする |
| 対象環境 | Windows 11 Pro、Claude Code v2.1.296、PowerShell 7（Windows PowerShell 5.1 も併存）、Git for Windows、Python 3.14。WSL2 は使わない |
| 公式 docs の参照版 | `C:\cc-workspace\LLMs\official-llms-txts\code.claude.com\docs\llms-full.txt`（2026-10-11 15:00 更新、120,807 行）。行番号はこの版のもの。更新で動くので、付録 A の検索語で辿り直す |

## 0. 本書の構成原則

v2 系は、同じ決定が v2.7 の 5-1（流れ）、6-0（共通規約）、6-1（関数表）、6-x（各スクリプトの手順）、7-4（証跡規約）、9 節（確認項目）に分散し（節番号はいずれも v2.7 のもの）、修正のたびに波及漏れが生まれて収束しなかった。v3 は次の原則で組み替えた。内容の決定は v2.7 と同じで、変えた箇所は変更履歴に挙げる。

- **1 決定 1 箇所。** 横断的な規則は 5 節に規則 ID（R1〜R10）で 1 回だけ書く。データの形式は 6 節に 1 回だけ書く。他の節はこれらを ID か節番号で参照し、言い換えて再掲しない
- **スクリプト節（7 節）は契約だけ。** 書式、固有の引数検査、固有の処理、出力、終了コードと状態を書き、共通処理は規則 ID で参照する
- **共通関数の分割は実装に委ねる。** v2.7 の `Evidence.psm1` の関数表は、手順との二重記述の発生源だったので廃止した。振る舞いは規則として定義し、どの関数に分けるかは 1-5 の委任事項とする
- **確認項目（10 節）は「どの規則が成り立つこと」で書く。** 手順を再掲しない

## 1. 目的と前提

### 1-1. 目的

`C:\cc-workspace\marketplace-for-cc`（Claude Code 用 Plugin Marketplace。GitHub で public）の Plugin を開発・定期メンテナンスするときのテストを、再現性のある形で実施し、証跡を残すための専用リポジトリ `C:\cc-workspace\marketplace-for-cc-test` を新設する。

### 1-2. 前提

- 想定利用者は作業指示者本人だけ。対象は自作 Plugin なので、悪意あるコードへの防御ではなく、**再現性**と**誤操作の防止**を重視する
- Plugin の挙動確認は、必ず `claude --plugin-dir <Plugin のパス>` で Plugin を読み込んで行う（2-5）
- テストは次の 3 手法を基本とする。Bash や memory を使う確認は、B では行えないので probe（`claude -p` ハーネス）で補う。A の各 run も probe と同じハーネスで実行する（8 節）
  - **A.** skill-creator によるレビューと採点（セッション内）
  - **B.** `claude plugin eval` による回帰 suite の作成（B-1）と実行（B-2）
  - **C.** `claude plugin validate --strict` による構造検証（毎回）
- 作業指示者が実行するスクリプトは **PowerShell** で書く。Git Bash 標準のターミナル（mintty）では対話セッションが起動できないため（F14）
- ユーザー設定の `permissions.defaultMode` は `auto` で、`claude -p` もそれを継承する。テストでは mode を明示して上書きする（F10）
- サンドボックスと probe はユーザー設定（`~/.claude/settings.json`）を継承する。B の一時ホームによる隔離とは強さが違う（F34）
- 既存の証跡（`C:\cc-workspace\marketplace-for-cc-evals\pre-compact\`）を移行する（9 節）

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
| 断面 | `<commit_count>_<sha7>/` | `CommitFolder` |
| 試行 | `<test_num>/` | `Attempt`、`-Attempt <path>` |
| 手法 | `<test-method>/` | `Method`、`-Method` |
| 実行 | 手法を 1 回呼び出すこと（スクリプトの 1 回の起動）。同じ試行の同じ手法を何度も実行できる（R5） | `Invocation`、`invocations[]` |
| run | probe と A で、1 つの case を 1 つの腕で 1 回動かすこと。1 回の実行が `-Runs` 個の run を含む | `run-<k>`、`run.json` |
| 腕 | with 腕（Plugin あり）と without 腕（Plugin なし）。`<config>` = `with_skill` / `without_skill` | `-Baseline`（指定で without 腕） |
| サンドボックス | `repo/` + `memory/` + `settings.json` の組。手動確認用は `work/<plugin>/sandbox/`、probe と A 用は `work/<plugin>/runs/` の下（3-3） | `Sandbox` |
| 対象 | テストした marketplace-for-cc の状態（R1 の識別子） | `Identity` |
| 枝 | `evidence/` 直下の `<plugin>`、`_multi-plugins`、`_marketplace` のいずれか。後の 2 つを「版なしの枝」と呼ぶ | `-Plugin` の値 |

### 1-5. 本書が決める範囲と、実装時に決める範囲

本書は、フォルダ構成と命名、横断規則（5 節）、データ形式（6 節）、スクリプトの契約（7 節）、docs と実測に基づく制約（2 節）を決める。次は実装時に決め、決めた内容を README の「実装メモ」に残す。

- メッセージの文言、ログの書式、引数の細かな型（文字列か列挙か）
- 6 節の各形式で「本書に挙げた項目以外の補助項目」
- PowerShell の共通関数（`scripts/common/Evidence.psm1`）の分割と名前。本書が規則として定めた振る舞いを満たせばよい
- Python 側の内部構造（関数の分割、case 定義の読み込み方）、判定器（`auto_checks`）の種類の一覧
- `run-<k>/outputs/` に置く各ファイルの名前（3-2、F40）
- case 定義（6-3）の fixture の構造
- 本書に「実装時に決める」と明記した事項

セルフチェックとレビューでは、本書内の矛盾と、本書が決めると宣言した事項の欠落を指摘の対象とし、上記の委任事項は対象外とする。v2.7 から委任に移した事項は変更履歴に挙げる。

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
| F17 | auto memory とセッション記録のプロジェクトディレクトリ名は、cwd の絶対パスの英数字以外の文字（`:` `\` `/` `_` `.` は実測済み）を `-` に置き換えて作られる（例: `C--cc-workspace-marketplace-for-cc-evals-sandbox-2026-10-11-midmsg-repo`、`...<other-workspace>\.claude\...` は `...<other-workspace>--claude-...`）。非 ASCII 文字も `-` になると推測されるが未確認。本設計では cwd の各要素に ASCII の英数字と `-` `_` 以外を使わない（7-1 の `-Name` の制約。ドライブ文字の `:` とパス区切りは実測済み）ので、規則の未確認部分に依存しない | 実測 2026-10-11（`.` の置換は Opus のクロスレビューで実測） |
| F36 | `autoMemoryDirectory` を指定しても、cwd に対応するプロジェクトディレクトリは `~/.claude/projects/` に作られ、セッションの記録（`.jsonl`）が置かれる。memory だけが指定先へ移る。`--no-session-persistence` を付けた `claude -p` では作られない | 実測 2026-10-11（確認 1 の記録 2 件が残った）、2026-10-10（`autoMemoryDirectory` と `--no-session-persistence` を併用した probe では残らなかった。併用時の確認は 10 節の段階 4 でも行う） |

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
| F37 | `claude plugin eval` の終了コード: 0 は全 case が閾値以上。1 は閾値未達、case の読み込み失敗、case が 0 件、実行を開始できなかった、Plugin ディレクトリが未信頼、オプション不正のいずれか。2 は予算超過などの部分実行。130 は中断（部分結果あり）、143 は終了。結果 JSON の主要値は `aggregates.overallScore`、`aggregates.casesPassed`、`aggregates.casesTotal`、`aggregates.meanDelta`、トップレベルの `partial`、`costUsd`。終了コード 1 のうち実行前に止まる場合は結果 JSON が無い。target は `--tag`、`--allow-tools`、`--json` より前に置く | docs 32004〜32006 行、32063〜32069 行、32085 行、32104〜32122 行（`costUsd` は 32122 行）。結果 JSON の名前は出力先の `aggregate-result.json`（32085 行「case が 1 つ以上ある実行はすべて `results/<timestamp>/` に `aggregate-result.json` と `report.html` を書く」）。終了コード 2 の説明（32067 行）にある `results.json` は、直前の CI 例（32053 行）で `--json results.json` と指定したファイル名を指すもので、別の既定ファイルではない。終了コード 2 と 130 のとき `aggregate-result.json` が実際に書かれ `partial: true` を持つかは未確認（10 節の段階 7 で確かめる） |

### 2-7. その他

| # | 事実 | 根拠 |
|---|---|---|
| F31 | Plugin ディレクトリの内容は `git rev-parse <commit>:plugins/<plugin>` で tree ハッシュとして取れる。中身が同じなら rebase で commit が変わっても同じ値になる | git の標準機能 |
| F32 | このマシンの `LongPathsEnabled` は未設定（0）で、260 文字のパス上限が効く。git は `core.longpaths=true` | 実測 2026-10-11 |
| F33 | 前回評価の生データで最も深いファイルの絶対パスは、3-2 の構成で約 188 文字 | 実測 2026-10-11 |
| F34 | サンドボックスと probe（`claude -p`）は、新しい cwd と git で隔離しても `~/.claude/settings.json`（`defaultMode`、`permissions.allow`、`enabledPlugins`）を継承する。B の一時ホームによる隔離（F25）とは異なる | 実測 2026-10-10（`-p` の init イベントの `permissionMode` がユーザー設定の `auto` だった） |
| F39 | Python 3.14 の `-I` オプションは、スクリプトのディレクトリを `sys.path` に入れず、`PYTHONUTF8` も無視する。このマシンは `PYTHONUTF8` が未設定で、`-X utf8` を付けない Python の既定エンコーディングは cp932。文字コードを指定せずにファイルを開くスクリプト（skill-creator 同梱の `aggregate_benchmark.py`、`generate_review.py` を含む）は、日本語を含む JSON を読むと `UnicodeDecodeError` で止まる | 実測 2026-10-11（セルフチェック 2 巡目。同梱スクリプトの停止と `-X utf8` での成功は Opus のクロスレビューで実測） |
| F41 | Windows の Claude Code には Bash ツールのほかに PowerShell ツールがあり、`claude -p` でも使える。権限ルールは Bash と同じ形（`PowerShell(git status *)` など）で、`acceptEdits` では `--allowedTools` に無い PowerShell コマンドは拒否される。Claude が git を PowerShell ツールで呼ぶと、Bash の許可だけでは拒否される | docs 77668 行（PowerShell の権限ルール）。実測 2026-10-10（前回評価の without 腕で `tool_name: PowerShell` の `permission_denials` が記録されていた。Opus のクロスレビューで確認） |
| F42 | ユーザー設定の `model`（新しいセッションすべてが使うモデル。`--model` が優先）、`effortLevel`（Opus 5.5 以降では無視され `modelSettings` の値が使われる）、`modelSettings` は、サンドボックスと probe に継承される（F34）。このマシンのユーザー設定は `model: sonnet`、`effortLevel: xhigh`、`modelSettings` にモデルごとの effort を持つ。`--model` も `effortLevel` も渡さずに起動すると、ユーザー設定のモデルと effort で動く。`--settings` で渡した `effortLevel` は全モデルに効く（ユーザー設定ファイルのトップレベル `effortLevel` が Opus 5.5 以降で無視されるのとは別。R8 が `--settings` で渡すのはこのため）。`--effort` フラグと環境変数 `CLAUDE_CODE_EFFORT_LEVEL` はこれらより優先するので、本設計では使わず、作業指示者の環境に `CLAUDE_CODE_EFFORT_LEVEL` が無いことを前提にする。B の各 run（F25）は一時ホームなので継承しない | docs 88531〜88535 行、88406 行、88677 行、74010 行（`--settings` の `effortLevel`）、60329 行（`--effort`）。実測 2026-10-11（ユーザー設定の値。Opus のクロスレビュー）。probe の init イベントでの確認は未実施 |
| F40 | skill-creator 同梱のビューア `generate_review.py` は、`outputs/` サブディレクトリを持つディレクトリを run として見つけ、run の prompt を `eval_metadata.json`（run 直下か親。`prompt` と `eval_id`）から、無ければ `transcript.md` の `## Eval Prompt` 節から取る（どちらも無いと「No prompt found」になる。前回の `review.html` は全 run がこれだった）。`grading.json` は run 直下か親から読む。集計 `aggregate_benchmark.py` は `eval-*/<config>/run-*/grading.json` を読み、`grading.json` に `timing` が無いか 0 のときは同じ run の `timing.json` から `total_duration_seconds` と `total_tokens` を読み、eval の id は `eval-*/eval_metadata.json` の `eval_id` があればそれ、無ければフォルダ名の 2 番目の要素（`eval-<id>-...` の `<id>`）とする。`references/schemas.md` の `evals.json` は `skill_name` と `evals[]`（`id`、`prompt`、`expected_output`、任意の `files`、`expectations` は文字列の配列）を持ち、`name` は無い | `~/.claude/plugins/cache/claude-plugins-official/skill-creator/<hash>/skills/skill-creator/` の `eval-viewer/generate_review.py`（`find_runs`）、`scripts/aggregate_benchmark.py`、`references/schemas.md`。実測 2026-10-11（セルフチェック 7 巡目） |

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
│   │   └── Evidence.psm1         # 共通関数（分割は 1-5 の委任事項）
│   ├── Start-Sandbox.ps1         # 手動確認用の対話セッションを起動する（7-1）
│   ├── Invoke-Probe.ps1          # ハーネスで case を実行する。A の実行器も兼ねる（7-2）
│   ├── Invoke-ProbeGrade.ps1     # 手動判定を取り込んで採点する（7-3）
│   ├── Invoke-PluginEval.ps1     # B-2 を実行する（7-4）
│   ├── Invoke-Validate.ps1       # C を実行する（7-5）
│   ├── New-Attempt.ps1           # 手動確認用の試行を作る（7-6）
│   ├── Set-MethodStatus.ps1      # 手動確認の手法を完了にする（7-7）
│   ├── Complete-Activity.ps1     # 活動を完了にする（7-8）
│   └── Find-Evidence.ps1         # commit から証跡を探す（7-9）
├── tools/
│   └── harness/                  # Invoke-Probe.ps1 が呼ぶ Python（7-10）
├── evidence/                     # 証跡。コミット対象（3-2）
└── work/                         # 使い捨ての作業領域。git 管理外（3-3）
```

`CLAUDE.md` は置かない（D1）。F1 のとおり `CLAUDE.md` は入れ子の git を越えて `work/` 配下のサンドボックスに漏れるが、F3 のとおり `.claude/skills/` は漏れない。作業セッションは起動後に `/test-repo-guide` を実行して手順を読む。

### 3-2. 証跡（`evidence/`）

```text
evidence/
├── <plugin>/                          # 例: pre-compact
│   ├── README.md                      # 活動の一覧（6-8）
│   └── <version>/                     # plugin.json の version。先頭の v は付けない（例: 0.9.0）
│       └── <YYYYMMDD>[_fin]/          # 活動。開始日（Asia/Tokyo）。完了したら _fin を付ける（R2）
│           ├── activity.json          # 6-1
│           └── <commit_count>_<sha7>/ # 断面。活動内でテストした対象の通し番号（00 から）と、その時点の commit（R3）
│               └── <test_num>/        # 試行（00 から）。追記専用（R5）
│                   ├── meta.json      # 6-2
│                   └── <test-method>/ # skill-creator / plugin-eval / validate / probe / manual
├── _multi-plugins/                    # 複数 Plugin が協調する機能やユースケースのテスト（D5）
│   ├── README.md
│   └── <YYYYMMDD>[_fin]/<commit_count>_<sha7>/<test_num>/<test-method>/
└── _marketplace/                      # Marketplace 全体のテスト（validate .、名前衝突）（D5）
    ├── README.md
    └── <YYYYMMDD>[_fin]/<commit_count>_<sha7>/<test_num>/<test-method>/
```

**活動**

- `<YYYYMMDD>` は**活動を開始した日付**で、活動が日を跨いでも変えない。1 つの活動は一連の作業に対応し、`activity.json` の `purpose`（`feature` 機能追加 / `release` リリース前 / `maintenance` 定期メンテナンス / `investigation` 調査）で区別する
- **活動は版に属し、1 つの版につき 1 日 1 活動**とする。同じ版で同じ日に 2 つ目の活動は作れない。閉じた活動の続きが要るときは翌日以降に新しい活動を作る。完了した活動は再開しない

**断面と試行**

- `<commit_count>` は活動の中でテストした対象の通し番号。テストせずに通過した commit には番号を付けない
- `<sha7>` はテスト開始時点の marketplace-for-cc の HEAD の短縮ハッシュ。人間と Claude が `git show` で辿るための値で、同一性の判定には使わない（D6、R1）

**版なしの枝**

- `_multi-plugins` と `_marketplace` には `<version>` の層が無い。commit が全 Plugin の版を同時に決めるため。同一性は R1 のとおり `_multi-plugins` では `plugins/` 全体の tree、`_marketplace` では commit 全体の `tree` で判定し、`meta.json` の `target.plugins` に各 Plugin の名前・版・`plugin_tree` を列挙する
- Marketplace のインストール導線（`claude plugin marketplace add`）の検証は永続的な登録を伴う（F18）ので、スクリプトの対象外とし、作業指示者の手動確認として `_marketplace/.../manual/` に記録する

**手法フォルダの中**（`manual` を除き、1 回の実行が新しいファイルだけを追加する構成。R5）。名前に含める `<yyyyMMdd_HHmmss>` は Asia/Tokyo の実行開始時刻。同じ名前が既にあれば拒否する（同じ秒の再実行）

| 手法 | 構成 |
|---|---|
| `probe` | `<case>/case.json`（7-2 が実行時に写した case 定義。7-3 の照合先）、`<case>/<config>/run-<k>/`、直下に `judgments-<yyyyMMdd_HHmmss>.json`。`<config>` は `with_skill` か `without_skill`。`<k>` は 1 から。再実行は既存の最大 `<k>` の次から振る。失敗した run も証跡に残し `<k>` を消費する |
| `skill-creator` | `iteration-<n>/` の下に、`eval-<id>-<case>/case.json`（同上）、`eval-<id>-<case>/<config>/run-<k>/`（`<k>` の規則は同上）、`evals.json`（6-6）、`judgments-<yyyyMMdd_HHmmss>.json`、および集計物（`benchmark.json`、`benchmark.md`、`review.html`、`report.md`）。集計物は同じ iteration 内で再生成してよい（R5）。`<n>` は試行の中の通し番号（1 から）。skill を改訂すると `plugin_tree` が変わり新しい断面と試行になるので、`<n>` は新しい試行で 1 から振り直す。改訂前後の比較は試行どうし（`meta.json` の `target`）で行う |
| `plugin-eval` | `<yyyyMMdd_HHmmss>/` |
| `validate` | `<yyyyMMdd_HHmmss>.txt` |
| `manual` | 作業指示者が置く任意のファイル。同じ試行で複数回の実行を登録したときは、ファイル名に実行日時を含めて既存ファイルを上書きしない |

**run の中**（`probe` と `skill-creator` で同じ。F40）

- `run-<k>/outputs/`: プロンプト、タイムライン（ツール呼び出しの合間のテキストを含む）、最終応答、途中テキストの一覧、memory の差分、git の状態（`git status --short` と `git diff` の出力。`repo/` はコピーしない）、費用。ファイル名は 1-5 の委任事項
- `run-<k>/` 直下: `facts.json`、`grading.auto.json`、`grading.json`（6-5）、`timing.json`、`eval_metadata.json`、`harness_result.json`（6-9）、相対化した `run.json`（6-4）。失敗した run では、残っている記録と `harness_result.json` を置く

**パスの長さ**: 絶対パスは 200 文字以内を目安にする（F32、F33）。eval の case 名が長くなる場合は手で短くする。

### 3-3. 作業領域（`work/`）

```text
work/
└── <plugin>/                          # _multi-plugins も同じ構成
    ├── sandbox/<YYYYMMDD>_<name>/     # 手動確認用（Start-Sandbox.ps1 が作る）。日付は実行日
    │   ├── repo/                      # git init 済み。リモートなし
    │   ├── memory/                    # このサンドボックス専用の auto memory
    │   └── settings.json              # autoMemoryDirectory と deny ルール（R8）
    └── runs/<attempt_key>/            # Invoke-Probe.ps1 が作る
        ├── probe/<case>/<config>/run-<k>/                              # -Method probe。各 run はサンドボックスの構成
        └── skill-creator/iteration-<n>/eval-<id>-<case>/<config>/run-<k>/   # -Method skill-creator
```

- `<attempt_key>` = `<version>_<YYYYMMDD>_<commit_count>_<test_num>`（版なしの枝では `<version>` を `-` にする）。版・活動・断面・試行の組で一意になる
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

- marketplace-for-cc の `.gitignore` に `plugins/*/evals/results/` を追加する。担当は B-1（8-1）
- marketplace-for-cc は public なので、`evals/` の fixture（会話記録、memory のサンプル）は公開前提で合成データに限る
- `evals/` を配布物から除外する手段は docs に無い。利用者に届くものとして扱う
- `evals/` は Plugin ディレクトリの中なので、**suite を追加・変更すると `plugin_tree` が変わり、新しい断面になる**。skill の挙動は同じでも断面は分かれる。B-1 の後は suite を commit してから B-2 を実行する（R1 の clean 検査で止まるため）

### 3-5. 段階 1 で作るファイルの中身

| ファイル | 必須の内容 |
|---|---|
| `README.md` | 目的（1-1）、前提（1-2 の要約と実行ターミナルの条件。R10）、テストの流れ（7 節冒頭の共通処理の順序と 8 節）、スクリプト一覧と書式（7-1〜7-9 の書式行と、R10 の引数の表記規則。`[ ]` 付きでも環境変数が無ければ必須の引数があることを含む）、環境変数（R8）、証跡の構成と命名（3-2、5 節、6 節）、後片付け（`work/` と `~/.claude/projects/` の該当ディレクトリ）、既知の制約（F7、F14、F21、F25〜F28、F36、F39 の `-X utf8`、F41、F42 の effort の実効値）、実装メモ（1-5 の委任事項で決めた内容） |
| `.claude/skills/test-repo-guide/SKILL.md` | frontmatter: `name: test-repo-guide`、`description` は「このリポジトリで Plugin のテストや証跡の整理を始めるときに最初に読む。テストの流れ・スクリプトの使い方・証跡の規約を案内する」。`disable-model-invocation` は付けない。本文: README の「テストの流れ」「スクリプト一覧」「証跡の規約」への案内と、守ること 3 点（`evidence/` の既存ファイルは R5 の変更の許容項目以外は書き換えない、`work/` 以外にサンドボックスを作らない、marketplace-for-cc 側を直接編集するときはその場で commit してから戻る） |
| `.claude/settings.json` | `permissions.allow` に `Bash(git status *)` `Bash(git diff *)` `Bash(git log *)` `Bash(pwsh -NoProfile -File ./scripts/*)` と、同じ 4 つの `PowerShell(...)` 版（F41。作業セッションの Claude がどちらのツールで呼んでも確認が出ないように）。deny は置かない（A のセッションが `evidence/.../skill-creator/` に書く必要があるため）。`defaultMode` は設定しない |

## 4. 採用理由

1. **証跡を「活動 → 断面 → 試行 → 手法」の順に階層化した（D2）。** `<version>` 直下の増加は 1 日 1 フォルダに抑えられ、同じ断面への再テストは試行の追加で安全に積める。手法は最下層なので、手法の増減が上位に波及しない
2. **試行は追記専用にした（R5）。** 各手法の出力先を実行ごとに一意にする（run 番号、タイムスタンプ）ことで、再実行が既存ファイルを上書きしない。再テストの理由（Claude Code の版やモデルの違い）は試行ごとの `meta.json` に残る
3. **活動の完了を `_fin` で表す（D4）。** スクリプトはフォルダ名の確認だけで「未作成 / 実施中 / 完了」を判別でき、`activity.json` を読む必要がない
4. **同一性は tree ハッシュで判定する（D6）。** 作業指示者は rebase を使うので commit ハッシュは変わりうる。Plugin ディレクトリの tree ハッシュは中身が同じなら不変で（F31）、rebase 前後の紐づけに別の仕組みが要らない
5. **`CLAUDE.md` を置かない（D1）。** F1 と F3 の非対称性を使い、構造でサンドボックスへの漏れを防ぐ。`claudeMdExcludes` 方式（F5）も動くが、スクリプトを通さずに起動したときに漏れる
6. **サンドボックスごとに `git init` する。** skill の探索がそこで止まり（F3）、skill が使う `git status` もサンドボックスだけを見る。リモートを設定しないので push 事故が起きない
7. **memory は `repo/` の外（サンドボックスの `memory/`）に置き、`~/.claude/projects/` には memory を書かない。** 隔離した `autoMemoryDirectory`（F35）でユーザーの memory を汚さない。セッションの記録は `~/.claude/projects/` に残る（F36）ので、後片付けはサンドボックスの削除と、F17 の規則で名前が決まるプロジェクトディレクトリの削除の 2 つになる。probe は `--no-session-persistence` で記録自体を残さない
8. **書き込み先の限定は mode と `--add-dir` で行う（D3）。** パス限定の allow ルールは `Edit(path)` と `//c/...` 形式なら効く（F8、F9）が、`acceptEdits` と `--add-dir` だけで同じ効果が得られ（F11）、設定が少ない。deny は mode の指定漏れに備える最後の防御として残す
9. **suite は Plugin 側に置き、結果だけをテスト用リポジトリへ出す（F23、F24）。**
10. **B は Bash と memory を使わない確認に限り、それ以外は probe で行う（F25、F26）。** WSL2 を使わない以上、B で Bash を許可すると全 case が拒否される。B の一時ホームによる隔離は Bash 無しでも働くので、再現性は保てる
11. **スクリプトは PowerShell にする（D7）。** 対話セッションの起動が mintty では動かない（F14）。Git Bash での `-p` 実行は動くが、作業指示者の実行シェルを 1 つに揃える
12. **`--plugin-dir` は既定で Plugin 単体を指す。** `plugins/` 全体を渡すと statusline も読み込まれ、その hook がユーザー環境へ書き込む（F19、F22）。`_multi-plugins` のときだけ `plugins/` を渡す
13. **引数の誤りは証跡を作る前に拒否する（R7）。** 証跡は追記専用で消せないため、引数だけで分かる誤りで活動や試行を残さない
14. **A の各 run を、skill-creator 標準のセッション内 subagent ではなく probe のハーネス（`claude -p`）で実行する。** subagent は親セッションの cwd・権限・memory・文脈を共有し、run ごとの隔離（git init した `repo/`、専用 `memory/`、`acceptEdits`）と `stream-json` の記録が得られない。ハーネスなら probe と同じ条件（F34、R8）で動き、前回の評価（9 節）とも方式が揃う。skill-creator の SKILL.md の手順から外れるのは run の実行方法だけで、判定・集計・ビューアは同梱のものを使う
15. **probe と手動確認ではモデルと effort を常に明示する（R8）。** 省くとユーザー設定の値で動き（F42）、証跡から読めない。B は一時ホーム（F25）なので省略してよい

## 5. 横断規則

7 節のスクリプトは、ここに定めた規則を ID で参照する。規則の振る舞いをどの共通関数に分けるかは 1-5 の委任事項。

### R1. 対象の同一性と識別子

- **識別子（`Identity`）**: `<ref>`（既定 HEAD）について、`commit`（完全ハッシュ）、`sha7`、`branch`（HEAD のときだけ。それ以外は null）、`plugin_tree`、`tree`（`git rev-parse <ref>^{tree}`）、`version`（その commit の `plugin.json`）。`plugin_tree` は `-Plugin <name>` では `git rev-parse <ref>:plugins/<plugin>`、`_multi-plugins` では `git rev-parse <ref>:plugins`（`plugins/` 全体。`.claude/` や docs だけの commit で断面が分かれないため）、`_marketplace` では null。版なしの枝では `version` は null で、代わりに `plugins`（全 Plugin の `name` / `version` / `plugin_tree` の配列）を持つ
- **識別子の取得で拒否する条件**: `<ref>` が commit に解決できない（「ref が不正」）。解決できても、その commit に `plugins/<plugin>` が無い（「Plugin が無い」。`_multi-plugins` では `plugins/` が無い場合、`_marketplace` では該当なし）。2 つは区別できる形で拒否する（7-9 が後者だけを捕まえるため）
- **同一性の判定**: `plugin_tree`（`_marketplace` では `tree`）が等しければ同じ対象。フォルダ名の `<sha7>` と現在の HEAD が違っても、`plugin_tree` が同じなら同じ断面として扱い、`meta.json` の `commit` と `sha7` には実際の HEAD を記録する（D6、F31）
- **clean 検査**: 証跡を作る前に、marketplace-for-cc の `plugins/<plugin>/` の作業ツリーが clean（`git status --porcelain -- plugins/<plugin>` が空）であることを確認する。版なしの枝では全体（`git status --porcelain`）。汚れていれば拒否する。テストした内容と `<sha7>` がずれるため。`-AllowDirty` のような回避は用意しない。`-Plugin <name>` で Marketplace 全体を検証するとき（7-5）、`marketplace.json` や他の Plugin は clean 検査と同一性の範囲外で、同じ断面に別の Marketplace 状態の結果が積まれうる（割り切り。Marketplace 全体の状態を断面として残したいときは `_marketplace` で実行する）

### R2. 活動の解決

証跡を作るスクリプトが、どの活動に書くかを決める規則。活動のパスを返す。

- **状態**: 未作成 / 実施中（open）/ 完了は**フォルダ名の `_fin` を正**とする。`activity.json` の `closed_at` は記録用で、食い違ったら `_fin` を優先する
- **`-Activity <YYYYMMDD>` 指定時**: 枝の版配下（版なしの枝では枝直下）のそのフォルダが open ならそれを使う。無いか `_fin` 付きなら拒否する
- **指定なし**: `evidence/<plugin>/` 配下を**版をまたいで**探し（版なしの枝では直下）、open の活動を数える
  - 2 つ以上: 拒否する（状態が不正。`_fin` の付け忘れの可能性が高い）
  - 1 つで、その版が `Identity.version` と同じ: 継続する。日付と開始からの経過日数を表示する。`-Purpose` / `-Goal` が指定され `activity.json` の値と違えば警告を表示する
  - 1 つで版が違う: 拒否する（先に `Complete-Activity.ps1` を実行する）
  - 0: 今日の日付（Asia/Tokyo）で版配下に作る。作成には `-Purpose` と `-Goal` が必須で、無ければ拒否する。今日の日付の `_fin` 付きフォルダが既にあれば拒否する（1 版・1 日・1 活動）
- **完了**: `Complete-Activity.ps1`（7-8）だけが `_fin` を付ける。`_fin` 付きの活動の下には、試行の追加も手法の実行も判定の確定も集計物の再生成も行わない（R5）

### R3. 断面と試行の割り当て

- **断面**: 活動内の各断面の全試行の `meta.json` を読み、`target.plugin_tree`（`_marketplace` では `target.tree`）が `Identity` と一致する断面があればそれを使う。無ければ次の `<commit_count>_<sha7>` を割り当てる（フォルダは試行を作るときに作る）
- **新しい試行**: 断面内の次の `<test_num>`（00 から）を作り、`meta.json`（6-2）を書く。既存の試行には触れない
- **既存の試行（`-Attempt <path>`）**: 試行のパスから活動・版・断面を導き、`meta.json` の `target` と `Identity` が R1 の同一性で一致することを確認し、違えば拒否する。試行が `_fin` 付きの活動の下にあれば拒否する。一致すれば R4 で手法の実行を登録する。`-Attempt` と併用できる引数は R9
- **`<attempt_key>`**: 3-3 の定義。作業領域のキー

### R4. 実行の登録と状態の導出

- **登録**: 手法を実行するたびに、`meta.json` の `methods[]` にその手法が無ければ追加し、その手法の `invocations[]` に新しい実行（`n`、`status: running`、`started`、`claude_code_version`、`model`、`effort`、`judge_model`、`test_repo_commit`、`test_repo_dirty`）を追記する。新しい試行の最初の手法の最初の実行も同じ形で登録する。同じ手法に `running` の実行が残っていても登録できる（7-6 だけは拒否する）
- **終了**: 実行を `completed` か `aborted` にし、`finished` と任意の `result`（終了コードなど）を書く。対象の実行が `running` でなければ拒否する（状態の上書きは許さない）
- **状態の導出**: 手法の `status` はその手法の最新の実行の状態。試行の `status` は全手法から導く（1 つでも `running` なら `running`、そうでなく 1 つでも `aborted` なら `aborted`、それ以外は `completed`）。登録と終了のたびに両方を再計算する。古い実行が `running` のまま残ることを検出する処理（7-8）は、この `status` ではなく `invocations[]` を直接走査する
- **記録する値**: `claude_code_version` は `claude --version` の出力の先頭の空白までの語（`2.1.296`）。`model` / `effort` / `judge_model` は引数、無ければ環境変数（R8）、どちらも無ければ null。ただし `effort` の環境変数を参照するのは 7-1、7-2、7-6 だけで、7-4 は `-Effort` を取らず `claude plugin eval` に effort を渡す手段も無いので常に null。null の意味は手法で異なる: 7-4 では Claude Code の既定（F25）、7-6 では未指定。7-1 と 7-2 では `-Model` と `-Effort` が必須（R8）なので null にならない。`judge_model` は `plugin-eval` 以外では常に null。`test_repo_commit` はテスト用リポジトリの HEAD（完全ハッシュ）、`test_repo_dirty` は `tools/harness/` と `scripts/` に未コミットの変更があれば true（採点基準とスクリプトの版を残すため。拒否はしない）。試行の `executed_at`（`Get-Date -Format o`）、`claude_code_version`、`model`、`effort`、`environment`（R8）は最初の実行（試行の作成）時点の値で、以後変えない
- **ノート**: `meta.json` の `notes` に日時付きで 1 行追記できる。ノートは消せないので、失敗しうる処理の後か直前に書く（7-1 は起動の直前に書く）

### R5. 追記専用と変更の許容項目

- 証跡の既存ファイルは上書きしない。新しいファイルとフォルダの追加はよい。スクリプトが書く手法（`probe`、`skill-creator`、`plugin-eval`、`validate`）の出力先は 3-2 のとおり実行ごとに一意なので、同じ試行で同じ手法を何度実行してもよい。`manual` は作業指示者が置くので一意化の対象外（3-2 の運用）
- 既存ファイルの変更が許されるのは次の 5 つ（「変更の許容項目」）だけ。4 の結論の記入と 5 を除き、スクリプトが行う
  1. `meta.json` の `methods`、`status`、`notes` の更新（R4）
  2. `activity.json` の `closed_at` の初回書き込み（7-8）
  3. 活動フォルダ名への `_fin` の付加（7-8）
  4. `README.md` への行の追加（7-8）と、結論の列の記入（作業指示者）
  5. skill-creator の集計物（`benchmark.json`、`benchmark.md`、`review.html`、`report.md`）の同じ `iteration-<n>/` 内での再生成（A のセッションの Claude）。run の記録と判定は再生成しない
- `grading.auto.json` から `grading.json` への確定（7-3）は新規ファイルの追加であり、許容項目には数えない。`grading.json` が既にある run は拒否する
- `_fin` 付きの活動の下で禁止する操作は R2
- **相対パス規約の免除**: 移行した既存データ（9 節）は当時の構成と絶対パスのまま置き、R6 を適用しない

### R6. 相対パス規約

- 対象は、本書のスクリプトが書く JSON のパス項目（`meta.json`、`run.json` の写し、`summary.json` など）に限る。記録した生の出力（`console.txt`、`validate/*.txt`、`aggregate-result.json`、タイムライン、`git diff` の出力など）に含まれる絶対パスは書き換えない
- パス項目は次の順で最初に当たる規則で書く（`_fin` でフォルダ名が変わるため、試行フォルダを基準にする）
  1. 試行フォルダの中を指すパス: 試行フォルダからの相対パス
  2. `work/` 配下: `<WORK>` を前置した `work/` からの相対パス
  3. `MARKETPLACE_DIR` 配下: `<MARKETPLACE_DIR>` を前置した相対パス
  4. ユーザーのホーム配下: `<HOME>` を前置した相対パス
  5. テスト用リポジトリ内のその他（`tools/harness/cases/` など）: `<TEST_REPO>` を前置したリポジトリルートからの相対パス
  6. 上記のいずれにも当たらないパス: 絶対パスのまま
- 「配下」はパス区切りで区切った部分の一致で判定し、文字列の前方一致では判定しない（`C:/cc-workspace/marketplace-for-cc-test/tools/...` は `C:/cc-workspace/marketplace-for-cc` の配下ではない。前方一致で判定すると規則 3 が先に当たり、`<TEST_REPO>` で書くべきパスが `<MARKETPLACE_DIR>-test/...` と誤変換される）
- 移行した既存データには適用しない（R5 の免除）

### R7. 拒否の順序、拒否時の表示、失敗時の状態

- **順序**: 引数と、引数が指すファイルだけで判定できる拒否（例: `-Plugin` の値（R9）、`-Method` の値と `-Iteration` の組み合わせ、`-Model` と `-Effort` の有無（R8）、`-Name` の文字、`-AllowTools` の内容、`-Attempt` との併用禁止（R9）、`-Activity` 指定時の `-Version`、`-Judgments` の存在と形式、case 定義の有無と `baseline` と `allowed_tools` の内容、`case.json` との不一致、サンドボックスの既存。完全な一覧は 7-1〜7-9 の「固有の引数検査」）は、R1〜R4 の共通処理より前に行う。作業領域の run ディレクトリの既存（3-3）は `<k>` が決まってからでないと判定できないので、共通処理の後でよい。`-Plugin` か `-Attempt` を取る全スクリプトに適用し、各契約に明記が無くても先に行う。共通処理は活動の作成と試行の登録を含み、追記専用（R5）のため後から消せない。共通処理の中で起きる拒否（clean でない、版違いの open、同一性の不一致）と、手法の実行中の失敗は、この順序の対象外
- **表示**: 処理を拒否するときは、何が起きたか、なぜ止めたか、どうすれば進められるかの 3 点を標準出力に出し、終了コードを 1 にする。共通関数は `throw` し、入口のスクリプトが `try` / `catch` で捕まえて表示と `exit 1` を行う。Claude が実行した場合はそのまま作業指示者へ報告させる
- **失敗時の状態**: 入口のスクリプトは、手法の実行を登録した後に例外が出たら `finally` で、その実行がまだ `running` のときだけ `aborted` にしてから終了する（既に `completed` か `aborted` なら触れない。R4 が状態の上書きを拒否するため）
- **終了コード**: 拒否と失敗は 1。正常は 0。例外は各契約に書く（7-4 は `claude plugin eval` の終了コードをそのまま返す、7-9 の「Plugin が無い」は 0）

### R8. Claude Code の起動、設定ファイル、環境変数

**環境変数**

- `MARKETPLACE_DIR`: marketplace-for-cc の場所。既定は `C:/cc-workspace/marketplace-for-cc`
- `CLAUDE_TEST_MODEL`、`CLAUDE_TEST_EFFORT`、`CLAUDE_TEST_JUDGE_MODEL`: `-Model` / `-Effort` / `-JudgeModel` の省略時の既定（記録は R4）。7-1 と 7-2 では `-Model` と `-Effort` を必須とし、引数も環境変数も無ければ拒否する。省くとユーザー設定のモデルと effort で動き（F42）、証跡から読めなくなるため。7-4 は F25 により省略可、7-6 は記録用なので省略可
- `CLAUDE_TEST_USER_SETTINGS`: 起動前の検査と `environment` が読むユーザー設定のパス。既定は `~/.claude/settings.json`。**確認用（10 節）で、本番では設定しない**。設定されていれば `environment` にそのパスも記録する

**起動引数**（7-1 と 7-2 で共通。7-2 では PowerShell が `run.json` に書く）

- `--permission-mode acceptEdits`（F10、F11）
- `--add-dir <memory の絶対パス>`
- `--settings <settings.json の絶対パス>`
- `--plugin-dir`: `-Plugin <name>` なら `<MARKETPLACE_DIR>/plugins/<name>`、`-Plugin _multi-plugins` なら `<MARKETPLACE_DIR>/plugins`。Marketplace のルートは渡さない（F19）。without 腕（`-Baseline`）では付けない
- `--allowedTools` の既定は `Bash(git status *)` `Bash(git diff *)` `Bash(git log *)` `PowerShell(git status *)` `PowerShell(git diff *)` `PowerShell(git log *)` の 6 つ（F41。Claude がどちらのツールで git を呼んでも同じ結果になるため）。7-2 では case 定義の `allowed_tools`（6-3）で Bash と PowerShell のパターンを追加できる。素の `Write` / `Edit` / `Bash` / `PowerShell` は指定があっても拒否する（F11）。7-1 は既定だけを使う
- `--model <id>` と `settings.json` の `effortLevel`（下記）を常に渡す（7-1、7-2。R8 の環境変数）
- `-Model` は `--model`、`-Effort` は `settings.json` の `effortLevel` で渡す（引数ではない）
- 7-2 はさらに `--no-session-persistence --output-format stream-json --verbose`（F36）。`stream-json` には F10 の `system` 通知が混ざりうるので、整形側は未知の `system` メッセージを無視する
- パスはすべて `C:/...` 形式のスラッシュ区切りの絶対パスに展開してから渡す（F15、F16）

**`settings.json`**（サンドボックスごとに生成する。D3、F8、F9）

- `autoMemoryDirectory`: そのサンドボックスの `memory/`
- `permissions.deny`: `Edit(//c/cc-workspace/marketplace-for-cc/**)`（`MARKETPLACE_DIR` から生成する。ドライブ文字は小文字、コロン無し）と `Edit(~/.claude/**)`
- `effortLevel`: `-Effort` の値（7-1、7-2 では常にある）

**起動前の検査**（7-1 と 7-2）

- ユーザー設定（`CLAUDE_TEST_USER_SETTINGS`）の `enabledPlugins` で有効（値が `true`）な id のうち、`@` より前の部分が対象 Plugin の名前と完全に一致するものがあれば拒否する（前方一致にしない。R6 と同じ理由）。`-Plugin _multi-plugins` では `<MARKETPLACE_DIR>/plugins/` 配下の全 Plugin 名を対象にする（F38。without 腕に混入するため）。with 腕だけの実行（7-1、`-Baseline` 無しの 7-2）でも同じ検査を行う。F38 の置き換えは黙って行われ、どちらが動いたかを証跡から判別できないため、警告ではなく拒否にする（単純さを優先した決定。インストール済みの対象 Plugin を常用する運用では、テストのたびに無効化が要る）

**`environment`**（`meta.json` に記録する。F34 の継承の記録。ユーザー設定の内容そのものは保存しない）

- ユーザー設定（`CLAUDE_TEST_USER_SETTINGS`）の SHA-256 と、`enabledPlugins` で値が `true` の id 一覧。ファイルが無ければ SHA-256 は null、一覧は空。設定の内容そのものは保存しないので、どのモデルで動いたかは `model` / `effort`（R4）と `facts.json`（6-5）で残す

**後片付け**

- セッションの記録は `~/.claude/projects/<名前>` に残る（F36）。`<名前>` は F17 の規則で cwd から決まる。7-1 はこのディレクトリの削除コマンドを表示する

### R9. `-Plugin` の値と `-Attempt` の併用

**`-Plugin` に渡せる値**

| スクリプト | `<name>`（Plugin 名） | `_multi-plugins` | `_marketplace` |
|---|---|---|---|
| `Start-Sandbox.ps1` | 可 | 可（`plugins/` を読み込む） | 拒否 |
| `Invoke-Probe.ps1` | 可 | 可 | 拒否 |
| `Invoke-PluginEval.ps1` | 可 | 拒否 | 拒否 |
| `Invoke-Validate.ps1` | 可（Plugin と Marketplace の両方を検証） | 拒否 | 可（Marketplace だけを検証） |
| `New-Attempt.ps1`、`Complete-Activity.ps1`、`Find-Evidence.ps1` | 可 | 可 | 可 |

`Set-MethodStatus.ps1` と `Invoke-ProbeGrade.ps1` は `-Plugin` を取らず、`-Attempt` のパスから枝を導く。

**`-Attempt` と他の引数の併用**

| 引数 | `-Attempt` と併用したとき |
|---|---|
| `-Activity`、`-Purpose`、`-Goal`、`-Reason` | 指定があれば拒否する（試行から導く値と食い違うため） |
| `-Model`、`-Effort`、`-JudgeModel` | 可（各スクリプトが取る引数に限る）。実行を登録するスクリプトではその実行に記録する（R4）。`Start-Sandbox.ps1` は実行を登録しないのでノートに記録する（7-1） |
| `-Notes` | ノートに追記する（R4） |

### R10. 言語、文字コード、実行場所、責務分担

- **PowerShell**。PowerShell 7 で動作確認し、Windows PowerShell 5.1 でも動く書き方を優先する。ファイルは UTF-8 BOM + CRLF（marketplace-for-cc の規約）。テキストの書き出しは ASCII だけなら `Set-Content -Encoding Ascii`、それ以外は `[IO.File]::WriteAllText`（UTF-8 BOM なし）を使い、5.1 の `-Encoding utf8` が付ける BOM を避ける
- **Python** は、本書の手順で呼ぶすべての Python（`tools/harness/` と、skill-creator 同梱の `aggregate_benchmark.py`、`generate_review.py` を含む）を `python -X utf8 ...` で呼ぶ（`-I` は使わない。F39。同梱スクリプトは文字コードを指定せずにファイルを開くので、`-X utf8` が無いとこのマシンでは止まる）。`tools/harness/` 側はすべての入出力で `encoding="utf-8"` を明示する。外部コマンドの `diff` は使わず `difflib` を使う（PowerShell の PATH に `diff` が無いため）
- **実行場所**: Windows Terminal の PowerShell か PowerShell コンソール。ISE と mintty は不可（F14）。README に `python -c "import sys;print(sys.stdout.isatty())"` が `True` なら起動できる、と書く
- **責務分担**: PowerShell が、活動と試行の解決（R2〜R4）、`settings.json` の生成（R8）、case 定義の読み取り、`claude` の起動引数の組み立て（`run.json`）、証跡へのコピーを担う。Python（`tools/harness/`）が、fixture の生成、`claude -p` の実行、記録の整形、機械判定を担う。`run.json` に書かれた引数をそのまま使い、Python 側で引数を足したり組み立てたりしない
- **引数の表記**: 本書の書式行では、値を取る引数は `-Name <型>`、省略可能なものは `[ ]` で囲む。`[ ]` 付きでも、R8 の環境変数で代替できる引数（7-1・7-2 の `-Model`、`-Effort`）は、引数も環境変数も無ければ拒否する

## 6. データ形式

各形式について、本書が決める項目を挙げる。補助項目の追加は 1-5 の委任事項。パス項目は R6 で書く。

### 6-1. `activity.json`

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

- `closed_at` の位置づけは R2。7-8 が初回だけ書く（R5 の許容項目 2）
- 版なしの枝では `plugin` に枝の名前を入れ、`version` は null

### 6-2. `meta.json`

```json
{
  "attempt": "00",
  "status": "running | completed | aborted",
  "executed_at": "2026-10-10T19:30:00+09:00",
  "claude_code_version": "2.1.296",
  "model": "claude-opus-5-5。null の意味は R4",
  "effort": "high。null の意味は R4",
  "methods": [
    {
      "name": "skill-creator",
      "status": "completed",
      "invocations": [
        { "n": 1, "status": "completed", "started": "...", "finished": "...", "claude_code_version": "2.1.296", "model": "...", "effort": "...", "judge_model": null, "test_repo_commit": "<テスト用リポジトリの HEAD>", "test_repo_dirty": false, "result": null }
      ]
    },
    {
      "name": "plugin-eval",
      "status": "completed",
      "invocations": [
        { "n": 1, "status": "completed", "started": "...", "finished": "...", "claude_code_version": "2.1.296", "model": null, "effort": null, "judge_model": "claude-haiku-5-5", "test_repo_commit": "...", "test_repo_dirty": false, "result": { "exit_code": 2, "partial": true } }
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
    "enabled_plugins": ["skill-creator@claude-plugins-official"],
    "user_settings_path": "null（既定の ~/.claude/settings.json を読んだ）。CLAUDE_TEST_USER_SETTINGS が設定されていればそのパスを R6 で書く"
  },
  "reason": "再テストの理由。初回は null",
  "notes": ["2026-10-10T19:40:00+09:00 自由記述"]
}
```

- `target` は R1 の識別子（版なしの枝の形も R1）。`plugins` の各要素は `{ "name", "version", "plugin_tree" }`
- `status`、`methods[]`、`invocations[]`、各値の記録時点は R4。`environment` は R8。変更してよい項目は R5

### 6-3. case 定義（`tools/harness/cases/<plugin>/<case>.json`）

| 項目 | 内容 |
|---|---|
| `id` | 整数。`eval-<id>-<case>` の `<id>`（F40） |
| `name` | `<case>` と同じ文字列。ファイル名の語幹とも同じで、`eval-<id>-` を含めない |
| fixture | git 履歴と未コミット変更、memory、会話記録。構造は 1-5 の委任事項 |
| `prompt` | 両腕で使う prompt 本文 |
| `invocation` | 任意。with 腕だけで `prompt` の先頭に前置する起動行（例 `/pre-compact:pre-compact\n\n`）。without 腕は `prompt` だけを使う |
| `expected_output` | 期待する結果の 1 文。`evals.json`（6-6）に写す |
| `allowed_tools` | `--allowedTools` に追加する Bash と PowerShell のパターン（`Bash(...)`、`PowerShell(...)`）の配列（R8、F41） |
| `baseline` | 既定 true。`prompt` 自体がスラッシュで始まる case だけ false にする（without 腕でエラーになるため。F28） |
| `expectations` | `id` と `text` を持つ配列。期待項目の正本 |
| `auto_checks` | 判定の種類と引数の配列。各要素は対象の `expectations` の `id` を持つ。判定器の種類は 1-5 の委任事項 |

### 6-4. `run.json`（7-2 が書き、Python が読む）

| 項目 | 内容 |
|---|---|
| `case` | case 定義のパス（絶対） |
| `config` | `with_skill` か `without_skill` |
| `run` | `<k>` |
| `dirs.run`、`dirs.repo`、`dirs.memory` | 作業ディレクトリの絶対パス |
| `claude.args` | `claude` に渡す引数の配列。先頭の `-p` と prompt 本文（腕ごとの組み立ては 6-3 の `invocation`）、R8 の引数（7-2 の追加分を含む）を含む完成形。PowerShell が組み立てる |
| `timeout_seconds` | 既定 600 |
| `model`、`effort` | 記録用。`model` は `claude.args` の `--model` にも含まれる。`effort` は `settings.json` の `effortLevel` で渡す（R8）ので `claude.args` には無い |

証跡には、パス項目を R6 で書き換えた写しを置く（`dirs.*` と `--settings` / `--add-dir` の値は `<WORK>`、`case` は `<TEST_REPO>`、`--plugin-dir` は `<MARKETPLACE_DIR>` になる）。

### 6-5. 判定と採点（run ごと）

| ファイル | 書き手 | 内容 |
|---|---|---|
| `facts.json` | `extract.py`（7-10） | 記録から抜き出した機械判定用の事実と、`stream-json` の init イベントにある実際の `model`（指定どおりのモデルで動いたかの検証用。F42） |
| `grading.auto.json` | `grade.py`（7-2 の実行中） | `auto_checks` による機械判定だけの採点。`expectations` の `id` ごとに結果を持つ。`auto_checks` の対象だが、その run に該当しない項目は `"passed": null, "not_applicable": true` で残す（「結果あり」と扱う） |
| `grading.json` | `grade.py`（7-3） | `facts.json` と手動判定を合わせた確定版。skill-creator の集計とビューア（F40）が読むので、`expectations[]`（各要素に `id`、`text`、`passed`、`evidence`）と `summary`（`passed`、`failed`、`total`、`pass_rate`）を必ず持つ。`summary` が無いと集計は黙って `pass_rate` を 0.0 にする。「該当なし」（`not_applicable`）の項目は `expectations[]` に `passed: null` のまま残し、`summary` の `total` から除く（`pass_rate` = `passed` / 該当する項目数。移行元の `grade.py` と同じ数え方で、移行データと比べられる）。同じ run に 2 度は書かない（R5） |

手動判定の JSON（7-3 の `-Judgments`）:

```json
{
  "runs": {
    "<case>/<config>/run-<k>": {
      "<expectation id>": { "passed": true, "evidence": "根拠" }
    }
  }
}
```

- `<case>` の部分は、`skill-creator` では `eval-<id>-<case>` と読み替える。キーに `iteration-<n>` は含めない（iteration は 7-3 の `-Iteration` で指定する）
- 作業指示者か A のセッションの Claude が、試行配下の記録を読んで作る
- 機械判定の結果がある `id` に手動判定もある場合は、手動判定を優先する（移行元の `grade.py` と同じ）

### 6-6. `evals.json`（skill-creator 用。7-2 が iteration ごとに生成する）

- 形式は skill-creator の `references/schemas.md`（F40）に合わせ、`skill_name`（Plugin 名）と `evals[]` を持つ。`evals[]` の各要素は `id`、`name`、`prompt`、`expected_output`、`expectations`
- `id`、`name`、`prompt`、`expected_output` は case 定義（6-3）の同名項目を写す（`prompt` には `invocation` を付けない）。`expectations` は case 定義の `expectations[].text` を順に並べた文字列の配列（`id` は含めない。判定との結び付けは case 定義の側で行う）
- `name` は schemas.md に無い本書独自の追加項目。同梱スクリプトは読まない
- 生成時点で定義済みの全 case を含める。生成後に追加した case は含まれない

### 6-7. `summary.json`（7-4 が書く）

`aggregate-result.json` から `aggregates.overallScore`、`aggregates.casesPassed`、`aggregates.casesTotal`、`aggregates.meanDelta`、`partial`、`costUsd` を抜き出したもの（F37）。

### 6-8. `evidence/<plugin>/README.md`

| 活動 | 版 | 目的 | 開始 | 完了 | 断面 | 試行 | 結論 |
|---|---|---|---|---|---|---|---|
| `20261010_fin` | 0.9.0 | investigation | 2026-10-10 | 2026-10-11 | 2 | 3 | 文中起動は不可。`disable-model-invocation` を外して対応 |

- 7-8 が行を追加し、結論は作業指示者が書く（R5 の許容項目 4）。活動の列はリネーム後の名前。目的の列は `activity.json` の `purpose` の値
- 行の同一性は（版、活動）の組で判定する。版なしの枝では活動名だけで判定する（活動名は枝の中で一意なため）
- 版なしの枝の README は「版」の列を「対象 Plugin」に置き換える。値は、活動内で最後に作られた試行の `target.plugins` から `name@version` を列挙する

### 6-9. run 直下の記録（`eval_metadata.json`、`timing.json`、`harness_result.json`）

| ファイル | 書き手 | 項目 |
|---|---|---|
| `eval_metadata.json` | `run_one.py`（7-10） | `eval_id`（case 定義の `id`）、`prompt`（その腕で実際に送った prompt。`run.json` の `claude.args` から取る）。skill-creator 同梱のビューアが prompt を表示するために読む（F40） |
| `timing.json` | `run_one.py` | `total_duration_seconds`、`total_tokens`。skill-creator の集計が `benchmark.json` の時間とトークンに使う（`grading.json` に `timing` が無いとき run 直下の `timing.json` を読む。名前が違うと黙って 0 になる。F40） |
| `harness_result.json` | 7-2（PowerShell） | `exit_code`（`run_one.py` の終了コード）、`finished`（終了時刻）。`run_one.py` が起動に失敗した場合も終了コードを知っているのは PowerShell だけなので、全 run について PowerShell が書く |

失敗した run では、`run_one.py` が書けなかったファイルは置かれない。`harness_result.json` だけはどの run にも必ずある。
## 7. スクリプトの契約

各スクリプトについて、書式、固有の引数検査（R7 の順序で共通処理より前に行う）、処理、出力、終了コードと状態を書く。「共通処理」は R1 の clean 検査と識別子の取得、R2 の活動の解決、R3 の断面と試行の割り当て、R4 の実行の登録を、この順で行うことを指す。`-Attempt` 指定時は R2 と R3 の新規割り当ての代わりに R3 の「既存の試行」を行う。

### 7-1. `scripts/Start-Sandbox.ps1`（手動確認）

```text
Start-Sandbox.ps1 -Plugin <name> -Name <name> [-Attempt <path>] [-Fixture <dir>] [-Model <id>] [-Effort <level>] [-AutoClean]
```

- **固有の引数検査**: `-Name` は ASCII の英数字と `-` だけを許す（F17 の規則の未確認部分を避けるため）。`-Model` と `-Effort` は必須（環境変数で省略可。R8）。`work/<plugin>/sandbox/<YYYYMMDD>_<name>/`（日付は実行日）が既にあれば拒否する（`-Plugin` の値は R9）
- **処理**
  1. R8 の起動前の検査を行う。`-Attempt` があれば R1 の clean 検査と識別子の取得、R3 の「既存の試行」で対象が一致することを確認する。`-Attempt` が無ければ clean 検査は行わない（証跡を作らないため）
  2. `work/<plugin>/sandbox/<YYYYMMDD>_<name>/` を作る。`repo/` を作って `git init` し、リポジトリ内だけの `user.name` と `user.email` を設定する。リモートは設定しない。`-Fixture` があれば中身を `repo/` にコピーする。`memory/` と `settings.json`（R8）を作る
  3. `-Attempt` があれば、起動する旨、`plugin_tree`、使った `-Model` / `-Effort` をノート（R4）に記録する。手動確認の実行は `New-Attempt.ps1` が登録済みなので、ここでは実行を追加しない
  4. `repo/` に `Set-Location` し、R8 の起動引数で対話セッションを起動する
  5. 終了後、`memory/` にファイルがあれば一覧を表示する（作業指示者が記録に添えるため）。次に `~/.claude/projects/` 側のディレクトリ（R8 の後片付け）を特定し、後片付けのコマンド（サンドボックスの削除とそのディレクトリの削除）を表示する。`-AutoClean` のときは一覧の表示の後に両方を削除する
- **出力**: 証跡は作らない。手動確認の記録は、`New-Attempt.ps1` で作った試行の `manual/` に作業指示者が置く
- **終了コード**: R7

### 7-2. `scripts/Invoke-Probe.ps1`（ハーネス。probe と A の実行器）

```text
Invoke-Probe.ps1 -Plugin <name> -Case <name> [-Method <probe または skill-creator>] [-Runs <n>] [-Baseline] [-Iteration <n>]
                 [-Model <id>] [-Effort <level>] [-Activity <YYYYMMDD>] [-Attempt <path>] [-Purpose <値>] [-Goal <文>] [-Reason <文>] [-Notes <文>]
```

- **固有の引数検査**: `-Method` の既定は `probe`。`skill-creator` のときは `-Iteration` が必須、`probe` のときに `-Iteration` があれば拒否する。`-Model` と `-Effort` は必須（環境変数で省略可。R8）。case 定義（6-3）を読み、無ければ拒否する。`baseline: false` の case に `-Baseline` が指定されたら拒否する。`allowed_tools` に素の `Write` / `Edit` / `Bash` / `PowerShell` があれば拒否する（R8）。`-Attempt` 指定時、その試行の case フォルダ（`probe/<case>/`、`skill-creator` では `skill-creator/iteration-<n>/eval-<id>-<case>/`）に `case.json` が既にあって中身が今の case 定義と違えば拒否する（採点基準が変わったら新しい試行にする。R5。引数とファイルだけで判定できるので共通処理の前に行う）
- **処理**
  1. R8 の起動前の検査と共通処理を行う
  2. `<config>` は `-Baseline` なら `without_skill`、それ以外は `with_skill`。case フォルダに `case.json` が無ければ case 定義を写す。`<k>` は 3-2 の規則で `-Runs`（既定 1）個を振り、作業領域の既存は 3-3 の規則で拒否する
  3. 各 run について、作業ディレクトリ（3-3）に `settings.json`（R8）と `run.json`（6-4）を書き、`python -X utf8 tools/harness/run_one.py --run-spec <run.json>` を呼ぶ。`run_one.py` の終了コードは、0 が正常、1 が `claude` の起動失敗かタイムアウト、2 が記録の整形失敗（`claude` 自身の応答内容や `permission_denials` の有無は成否に含めない。それらは採点の対象）。終了するたびに `harness_result.json`（6-9）を書く。ある run が 1 か 2 で終わっても残りの run は続け、`-Runs` 個すべてを実行する
  4. 各 run の要点を証跡へコピーする（3-2 の「run の中」の配置。失敗した run を含む）。コピー先は `-Method probe` なら試行の `probe/<case>/<config>/run-<k>/`、`skill-creator` なら `skill-creator/iteration-<n>/eval-<id>-<case>/<config>/run-<k>/`。`-Method skill-creator` で、その iteration の最初の実行なら、このときに `evals.json`（6-6）を `skill-creator/iteration-<n>/` に生成する（既にあれば生成しない）
- **出力**: 上記の run、`case.json`、`evals.json`。試行のパスを表示する（A のセッションで Claude が控える）
- **終了コードと状態**: 全 run の `run_one.py` が 0 なら実行を `completed` にして 0。1 つでも 1 か 2 があれば `aborted`（`result` に失敗した run の `<k>` と終了コードの一覧）にして 1。例外は R7

### 7-3. `scripts/Invoke-ProbeGrade.ps1`（手動判定の取り込み）

```text
Invoke-ProbeGrade.ps1 -Attempt <path> -Method <probe または skill-creator> -Judgments <file> [-Iteration <n>]
```

- **固有の引数検査**: `-Method skill-creator` のときは `-Iteration` が必須、`probe` のときに `-Iteration` があれば拒否する。`-Judgments` のファイルが無いか、6-5 の形式でなければ拒否する
- **処理**
  1. 試行が `_fin` 付きの活動の下なら拒否する（R2。同一性は見ない）。`-Method skill-creator` で `skill-creator/iteration-<n>/` が無ければ拒否する。以下の「手法フォルダ」は、`probe` では `probe/`、`skill-creator` では `skill-creator/iteration-<n>/`
  2. 対象は `-Judgments` に載っている run だけ。載っていない run には触れない。次のいずれかに当たる run が 1 つでもあれば全体を拒否する: 手法フォルダの下にその run が無い、その run に `grading.auto.json` が無い（失敗した run）、その run に既に `grading.json` がある（R5）
  3. 照合する case 定義は、各 run が属する case フォルダ（`<case>/`、`skill-creator` では `eval-<id>-<case>/`）の `case.json`（7-2 が実行時に写したもの。3-2）であり、`tools/harness/cases/` の現在の定義ではない。判定に `case.json` の `expectations` に無い `id` があれば拒否する。欠けの検査は、`expectations` の `id` のうちその run の `grading.auto.json` に結果が無いもの（`auto_checks` が判定しない項目）を対象とし、1 つでも手動判定が無ければ拒否する
  4. 各 run について `grade.py`（7-10）を呼び、`grading.json`（6-5）を書く。`-Judgments` のファイルを手法フォルダ直下に `judgments-<yyyyMMdd_HHmmss>.json` としてコピーして残す
  5. 判定を取り込んだ旨をノート（R4）に記録する
- **出力**: 各 run の `grading.json` と `judgments-*.json`
- **終了コード**: R7。実行は登録しない（手法の実行ではなく判定の確定）

採点は 2 段階になる。7-2 が機械判定（`grading.auto.json`）まで行い、人の判定が要る項目は本スクリプトで `grading.json` に確定する。

### 7-4. `scripts/Invoke-PluginEval.ps1`（B-2）

```text
Invoke-PluginEval.ps1 -Plugin <name> [-Case <glob>] [-Runs <n>] [-Ablation <none または with-without>] [-AllowTools <list>] [-MaxCostUsd <n>]
                      [-Model <id>] [-JudgeModel <id>] [-Activity <YYYYMMDD>] [-Attempt <path>] [-Purpose <値>] [-Goal <文>] [-Reason <文>] [-Notes <文>]
```

- **固有の引数検査**: `-AllowTools` に `Bash` か `PowerShell` が、素の形でも `Bash(...)` の形でも含まれていれば拒否する（F26。全 case が拒否され採点 0 になるため）
- **処理**
  1. 共通処理を行う（`judge_model` の記録は R4）
  2. `claude plugin eval` を次の順で組み立てて実行する（target を先頭に置く。F37）。標準出力と標準エラーは `plugin-eval/<yyyyMMdd_HHmmss>/console.txt` に保存する

     | 位置 | 内容 |
     |---|---|
     | 1 | `<MARKETPLACE_DIR>/plugins/<plugin>` |
     | 2 | `--no-publish --trust-plugin --output-dir <試行>/plugin-eval/<yyyyMMdd_HHmmss> --max-cost-usd <n>`（`-MaxCostUsd` の既定 3） |
     | 3 | `-Case` があれば `--case <glob>`、`-Runs` があれば `--runs <n>`、`-Ablation` があれば `--ablation <mode>` |
     | 4 | `-Model`（省略時 `CLAUDE_TEST_MODEL`）があれば `--model <id>`、`-JudgeModel`（省略時 `CLAUDE_TEST_JUDGE_MODEL`）があれば `--judge-model <id>` |
     | 5 | `-AllowTools` があれば最後に `--allow-tools <list...>` |

  3. 出力先に `aggregate-result.json` があれば `summary.json`（6-7）を書いて表示する
- **出力**: `plugin-eval/<yyyyMMdd_HHmmss>/`（`aggregate-result.json`、`report.html`、`summary.json`、`console.txt`）
- **終了コードと状態**: `aggregate-result.json` があれば実行を `completed`（`result` に終了コードと `partial`）にする。終了コード 2 と 130 の部分実行も、`aggregate-result.json` があれば `completed`。無ければ `aborted`（終了コード 1 のうち実行前に止まった場合、143 など）。どの場合も証跡は残す。スクリプトは `claude plugin eval` の終了コードをそのまま返す（F37）。例外: 同じコンソールの Ctrl+C で `claude plugin eval` が 130 で止まるとき、PowerShell も同時に止まり R7 の `finally` が先に動くので、状態は `aborted` のままになる（`aggregate-result.json` は残る。推測を含む。段階 7 で確かめる）

### 7-5. `scripts/Invoke-Validate.ps1`（C）

```text
Invoke-Validate.ps1 -Plugin <name> [-Activity <YYYYMMDD>] [-Attempt <path>] [-Purpose <値>] [-Goal <文>] [-Reason <文>] [-Notes <文>]
```

- **固有の引数検査**: 無し（`-Plugin` の値は R9）
- **処理**
  1. 共通処理を行う
  2. `claude plugin validate --strict <MARKETPLACE_DIR>/plugins/<plugin>` と `claude plugin validate --strict <MARKETPLACE_DIR>` を実行する。`-Plugin _marketplace` のときは後者だけ（後者の検証範囲と断面の関係は R1 の割り切り）
  3. 両方の出力に Claude Code の版、commit、実行日時を添えて `validate/<yyyyMMdd_HHmmss>.txt` に保存する
- **出力**: `validate/<yyyyMMdd_HHmmss>.txt`
- **終了コードと状態**: 検証が失敗しても証跡は残し、実行を `completed`（`result` に終了コード）にした上で終了コード 1 で終わる。`claude` が起動できないなどの実行失敗は `aborted` にして 1

### 7-6. `scripts/New-Attempt.ps1`（手動確認用の試行）

```text
New-Attempt.ps1 -Plugin <name> -Method manual [-Model <id>] [-Effort <level>] [-Activity <YYYYMMDD>] [-Attempt <path>] [-Purpose <値>] [-Goal <文>] [-Reason <文>] [-Notes <文>]
```

- **固有の引数検査**: `-Method` は `manual` だけを受け付ける（他の手法はそのスクリプトが自分で登録する。別の名前を許すと 7-7 で閉じられない `running` が残るため）。`-Plugin` の値と `-Attempt` の併用は R9
- **処理**: 共通処理を行い、手法フォルダを空で作る。`-Attempt` で既存の試行に実行を追加するとき、手法フォルダが既にあればそのまま使う（拒否しない）が、`manual` に `running` の実行が残っていれば拒否する（先に 7-7 で閉じる）。`-Model` / `-Effort` は手動確認で使う予定の値を実行の記録に残すためのもの
- **出力**: 試行のパスを表示する。登録した実行は `running` のまま終わる（7-7 が完了にする）
- **終了コード**: R7

### 7-7. `scripts/Set-MethodStatus.ps1`（手動確認の完了）

```text
Set-MethodStatus.ps1 -Attempt <path> -Method <name> -Status <completed または aborted> [-Notes <文>]
```

- **固有の引数検査**: 無し
- **処理**: 共通処理を通さない。試行が `_fin` 付きの活動の下なら拒否する（R2）。その手法の最新の実行を `-Status` の状態にする（R4。手法が試行に無い場合と、最新の実行が `running` でない場合は拒否する）。記録を置き終えた作業指示者が実行する。作業ツリーの clean や HEAD の一致は要求しない（完了報告の時点で Plugin が変わっていても、テストした対象は `meta.json` に記録済みのため）
- **終了コード**: R7

### 7-8. `scripts/Complete-Activity.ps1`

```text
Complete-Activity.ps1 -Plugin <name> [-Version <ver>] [-Activity <YYYYMMDD または YYYYMMDD_fin>] [-Force]
```

- **固有の引数検査**: `-Activity` 指定時は `-Version` も必須（版なしの枝では不要）
- **処理**
  1. 対象を特定する。未指定なら `evidence/<plugin>/` 配下で版をまたいだ open の活動を探し、0 件か 2 件以上なら拒否する。`-Activity` 指定時はそのフォルダを使う。`_fin` 付きの指定は、手順 2〜4 を飛ばして手順 5 だけを行う再実行として扱う
  2. 活動内の全試行の `invocations[]` を直接走査し（R4）、`running` の実行が残っていれば一覧を表示する。`-Force` が無ければ拒否する（7-7 の忘れを防ぐ）。`-Force` があれば、それらの実行を `aborted`（`result` に「Complete-Activity による強制終了」）にしてから進む
  3. `activity.json` の `closed_at` が null なら書く（既に値があれば変えない）
  4. フォルダ名に `_fin` を付ける
  5. `evidence/<plugin>/README.md`（6-8）に行を追加する。README が無ければ見出し行から作る。同一の行が既にあれば追加しない（再実行しても重複しない）
- **途中で失敗した場合**: 手順 3 まで終わっていればフォルダ名は open のままなので、再実行で手順 4 と 5 が行われる。手順 4 まで終わっていれば、`-Activity` に `_fin` 付きの名前を渡して手順 5 だけを行う
- **終了コード**: R7

### 7-9. `scripts/Find-Evidence.ps1`

```text
Find-Evidence.ps1 -Plugin <name> -Commit <ref>
```

- **処理**: `<ref>` の識別子（R1）を取り、`evidence/<plugin>/` 配下の全 `meta.json` を R1 の同一性で照合して、一致する試行の一覧（活動・断面・試行・実行日時・手法と状態）を表示する。rebase で commit ハッシュが変わった後でも、同じ内容をテストした証跡を見つけられる（D6、F31）
- **終了コード**: 一致が 0 件でも 0。R1 の「Plugin が無い」の拒否だけを捕まえて「その commit に Plugin が無い」旨を表示し、0 で終わる（拒否ではない）。「ref が不正」は捕まえず、通常の拒否（1）とする

### 7-10. `tools/harness/`（Python）

前回の評価で使った Python（`marketplace-for-cc-evals\pre-compact\raw-2026-10-10\tools\`）を移し、Plugin ごとの case 定義（6-3）と共通部分に分ける。文字コードと `difflib` は R10。pre-compact 固有の機械判定（silent の判定、`/compact` コメント案の長さや構文）は、case 定義の `auto_checks` に判定の種類と引数を宣言し、`extract.py` と `grade.py` は種類ごとの汎用の判定器を持つ形にする。

| ファイル | 役割 | 現行（移行元）との違い |
|---|---|---|
| `cases/<plugin>/<case>.json` | 6-3 | 現行は fixture と期待項目を Python コード（`build_fixtures.py`、`grade.py`）と `evals.json` に埋め込んでいる。JSON へ移す。現行の `evals.json` の `name`（`eval-1-uncommitted` など）は `eval-<id>-` を外して `name` にする。現行 `run_one.py` が with 腕だけに前置していた `/pre-compact:pre-compact\n\n` は `invocation` に移す。現行 `grade.py` が提示された run だけに動的に追加していたコメント案の 4 項目は、静的な `expectations` と `auto_checks` の「該当なし」（6-5）で表す |
| `build_fixtures.py` | case 定義から `repo/`（git init 済み）と `memory/` を作る | 入力を Python 内の定義から case 定義に変える。`settings.json` は現行も新形式も作らない（新形式では PowerShell が作る。R10） |
| `run_one.py` | `run.json`（6-4）を読んで `claude -p` を実行し、記録を整形して `outputs/`（3-2）と `eval_metadata.json`、`timing.json`（6-9）を書き、`extract.py` と `grade.py` を呼んで `facts.json`、`grading.auto.json` を書く。終了コードは 7-2 の定義 | 現行は位置引数 4 つ（fixture、run_dir、config、plugin_dir）で引数を自分で組み立て、モデルを固定し、`--settings` に JSON 文字列を渡す。すべて `run.json` 由来に変える。現行は prompt を `PROMPT_TMPL` と `fixture/transcript.md`（`<conversation>` として埋め込み、末尾に作業指示者の発言を足す）から組み立てるが、新形式では組み立て済みの全文を case 定義の `prompt` に持たせる（現行 `evals.json` の `prompt` は要約なので写さない）。現行の `--allowedTools` は素の `Read` / `Edit` / `Write` / `Glob` / `Grep` と `Bash(ls *)` などを含むが、新形式は R8 の既定と `allowed_tools` だけ。現行の `timeout=900` は 6-4 の既定 600 に変わる。現行は実行前に `run_dir` を `rmtree` して上書きするが、新形式は作業領域の既存を拒否する（3-3）。`diff` を `difflib` に置き換える。未知の `system` メッセージを無視する（R8） |
| `extract.py` | 1 run の記録から機械判定用の事実を `facts.json` に書く | 現行は iteration ディレクトリを受けて全 run を一括処理する。1 run 単位に変え、判定の種類を `auto_checks` から読む |
| `grade.py` | `facts.json` と手動判定を合わせて `grading.json` を書く。手動判定が無ければ `grading.auto.json` を書く（6-5） | 現行は固定パス（`workspace/evals/evals.json`、`workspace/judgments.json`）を読み、pre-compact 固有の判定を内蔵する。入力の所在をすべて引数で受け、固有の判定を `auto_checks` に移す。手動判定の形式も変える: 現行はキーが期待項目の `text`、値が `[passed, evidence]` の配列で、先頭に `_rule_output_scope` のメタキーがある。新形式は 6-5（キーは `id`、値は `{passed, evidence}`）。現行は手動判定も機械判定も無い項目で `SystemExit("未判定")` になるが、新形式では `grading.auto.json` に残し、欠けの検査は 7-3 が行う。9 節で移す現行の `judgments.json` は旧形式のままで、7-3 では読めない |
| `run_all.py` | 廃止 | 現行は 5 並列で実行していた。7-2 の `-Runs` は順次実行なので、run 数に比例して時間が延びる |

## 8. テストの流れ

### 8-1. 手法ごとの実行場所と方法

| 手法 | 実行場所 | 方法 | 出力先（試行配下） |
|---|---|---|---|
| A: skill-creator | テスト用リポジトリ直下で起動した対話セッション | `/skill-creator:skill-creator` を実行する。流れは次のとおり。(1) 最初の case を `Invoke-Probe.ps1 -Method skill-creator -Iteration 1` で実行し、表示された試行のパスを Claude が控える。(2) 残りの case と without 腕を、同じ試行に `-Method skill-creator -Iteration <n> -Attempt <path>` で追加実行する。(3) Claude が記録を読んで判定 JSON（6-5）を作り、`Invoke-ProbeGrade.ps1 -Attempt <path> -Method skill-creator -Iteration <n> -Judgments <file>` で `grading.json` を確定する。(4) skill-creator 同梱の集計とビューアを、`python -X utf8 -m scripts.aggregate_benchmark <iteration dir>` と `python -X utf8 eval-viewer/generate_review.py <iteration dir> --static <iteration dir>/review.html` の形（R10。SKILL.md の書き方を `-X utf8` 付きに読み替える）で実行し、出力をその試行の `skill-creator/iteration-<n>/` へ直接書く（R5 の許容項目 5） | `skill-creator/iteration-<n>/`（3-2） |
| B-1: suite 作成 | 同じセッションで `/cd` により Plugin ルートへ移動 | Claude に `claude plugin eval init` の実行を頼む。A の所見を踏まえて case を設計する。marketplace-for-cc の `.gitignore` に `plugins/*/evals/results/` が無ければ追加する（3-4）。終わったら suite と `.gitignore` を commit し、`/cd` で戻る | marketplace-for-cc 側の `evals/` |
| B-2: suite 実行 | PowerShell（セッション不要） | `Invoke-PluginEval.ps1`（7-4） | `plugin-eval/<yyyyMMdd_HHmmss>/` |
| C: 構造検証 | PowerShell | `Invoke-Validate.ps1`（7-5） | `validate/<yyyyMMdd_HHmmss>.txt` |
| 手動確認 | 毎回新しい対話セッション | `New-Attempt.ps1 -Method manual`（7-6）で試行を作り、`Start-Sandbox.ps1 -Attempt <path>`（7-1）で起動して作業指示者が操作する。終わったら `Set-MethodStatus.ps1`（7-7）で完了にする | `manual/`（作業指示者が記録を置く） |
| probe | PowerShell | `Invoke-Probe.ps1 -Method probe`（7-2）。Bash や memory が要る確認、文中起動の確認など、B で測れない項目。手動判定が要る項目は `Invoke-ProbeGrade.ps1`（7-3）で確定する | `probe/<case>/<config>/run-<k>/` |

活動の区切りで `Complete-Activity.ps1`（7-8）を実行し、`_fin` を付けて `README.md` を更新する。

### 8-2. `/cd` の注意点

- `/cd` で Plugin ルートへ移ると、marketplace-for-cc 側の `CLAUDE.md`、`.claude/rules/`、`.claude/skills/`（旧版の pre-compact を含む）が読み込まれる。一方、marketplace-for-cc の `.claude/settings.json` の hooks は効かない（F4、F6）。suite の作成には支障ないが、そのセッションで skill の挙動を確かめない
- `/cd` は会話を引き継ぐので、まっさらなセッションでの挙動確認には使えない。手動確認は毎回 `Start-Sandbox.ps1` で新しいセッションを起動する
- `/cd` では auto memory の保存先が切り替わらず、書き込み先が不定になる（F7）。`/cd` したセッションでは memory に依存する作業（pre-compact の実行など）を行わない

### 8-3. B の case 設計で守ること

- 各 run には Bash も memory も無い（F25）。skill が `git status` や `MEMORY.md` を使う手順は常に実行できないので、grader はそこを減点しない。実測では、pre-compact はその旨を断った上で終了方式の提示とコメント案の出力を行った
- `tool_used: Skill` はユーザー起動を数えない（F27）。起動確認は `regex` か `llm` grader で最終応答を見る
- prompt 先頭にスラッシュコマンドを置く case は、Plugin の無いベースライン腕でエラーになる（F28）。`--ablation none` で with 腕だけを採点するか、`context.history_file` の case にする（F29）。pre-compact は `disable-model-invocation` を外した（F21）ので、文中で実行を求める prompt なら両腕を比較できる
- `--allow-tools` に `Bash` と `PowerShell` を、どの形でも含めない（F26）。`Write` と `Edit` は許可してよい
- marketplace-for-cc は public なので、fixture は合成データに限る（3-4）

## 9. 既存データの移行

前回の評価と確認は、marketplace-for-cc の commit `4733d90`（pre-compact 0.9.0 初版）と `2fb2068`（`disable-model-invocation` を外した版）を対象に行った。1 つの活動（`investigation`、2026-10-10 開始、2026-10-11 完了）として移す。試行の `meta.json` と `activity.json` は手で書く。`plugin_tree` は `git rev-parse 4733d90:plugins/pre-compact` と `git rev-parse 2fb2068:plugins/pre-compact` で計算する。

移行先の接頭辞 `E` = `evidence/pre-compact/0.9.0/20261010_fin/`。移行した記録は、3-2 の手法フォルダ内の構成（`<case>/<config>/run-<k>/` など）に合わせず、当時の構成のまま置く。当時の絶対パスも書き換えない（R5 の免除）。移行した手順書には「`~/.claude/projects/` に何も残らない」という旧記述があるので、`meta.json` の `notes` に F36 を参照する注記を付ける。移行後、`Complete-Activity.ps1 -Plugin pre-compact -Version 0.9.0 -Activity 20261010_fin` で README の行を作る（7-8 の手順 5 だけの再実行）。

**手で書く `meta.json` と `activity.json` の規則**（6-1、6-2 の形式に従う。値の取得元は次の表。取れない項目は null にし、`notes` の先頭に「移行データ。null は不明を表す」と書く。R4 の null の意味とは別）

| 項目 | 取得元 |
|---|---|
| `target`（`commit`、`sha7`、`plugin_tree`、`tree`、`version`） | marketplace-for-cc で `git rev-parse` を実行して計算する。`branch` は null |
| `claude_code_version` | 表紙の対象環境の `2.1.296`（両日とも同じ版で実施） |
| `model`、`effort`（試行と各実行） | `00_4733d90/00`（skill-creator と probe）は移行元 `workspace\iteration-1\benchmark.md` の 3 行目（`claude-opus-5-5`、`high`）。`00_4733d90/01`（作業指示者の対話確認）は、確認時の設定が記録に無ければ null。`01_2fb2068/00`（ゲート方式のテスト）は `pos.jsonl` / `neg.jsonl` の init イベントの `model` を使い、effort は記録が無いので null |
| `executed_at`、`invocations[].started` / `finished` | 移行元の記録のファイル更新日時（`run_all.log`、`stream.jsonl` の最終行の時刻）。分からなければ日付だけの `2026-10-10T00:00:00+09:00` の形にし `notes` に明記 |
| `environment` | null（当時の設定は再現できない） |
| `test_repo_commit`、`test_repo_dirty` | null（テスト用リポジトリが無かった） |
| `activity.json` の `started` / `closed_at` | `2026-10-10T00:00:00+09:00` と `2026-10-11T23:59:59+09:00`（日付だけが分かっているため。`notes` に明記） |
| `reason` | null |

移行の担当と作業指示者の分担: 移行担当は表に挙げたファイルを置き `meta.json` を書く。作業指示者の手元にしか無い記録（確認 1・2 の観察記録）は、移行担当が着手前に作業指示者へパスを尋ね、無ければ `notes` に「作業指示者が後で置く」と書いて進める。

| 移行元（`marketplace-for-cc-evals\pre-compact\`） | 移行先 | 備考 |
|---|---|---|
| `iteration-1\report.md`、`review.html`、`evals.json`、`judgments.json` | `E/00_4733d90/00/skill-creator/` | 報告書・ビューア・case 定義・手動判定。`workspace\evals\evals.json` と `workspace\judgments.json` は同じ内容なので移さない |
| `iteration-1\benchmark.json`、`benchmark.md` | 移さない | 次行の `iteration-1/` 内の同名ファイルと同じ内容 |
| `raw-2026-10-10\workspace\iteration-1\`（`benchmark.json`、`benchmark.md`、各 `eval-*/<config>/run-*/` の記録と採点。`sandbox/` は除外済み） | `E/00_4733d90/00/skill-creator/iteration-1/` | そのまま移す |
| `raw-2026-10-10\workspace\run_all.log` | `E/00_4733d90/00/skill-creator/run_all.log` | 実行ログ |
| `raw-2026-10-10\probe\midmsg.jsonl`、`midmsg.err` | `E/00_4733d90/00/probe/midmsg/` | 非対話での文中起動拒否の記録。当時の構成のまま |
| 作業指示者の確認 1（文中起動、対話）と確認 2（`/cd` と memory）の観察記録 | `E/00_4733d90/01/manual/` | 記録の本文は作業指示者の手元にある。転記して置く |
| `~/.claude/projects/C--cc-workspace-marketplace-for-cc-evals-sandbox-2026-10-11-midmsg-repo/`（確認 1 のセッション記録 `.jsonl` 2 件）、同 `-cd-repoA/`（`memory/` だけ。確認 2 で `/cd` 前の保存先に書かれた memory）、同 `-cd-repoB/`（確認 2 のセッション記録と `memory/`） | `E/00_4733d90/01/manual/sessions/<ディレクトリ名>/` | F36 の「残った記録」の実体。そのままコピーする。コピー後に元のディレクトリを削除するかは作業指示者が決める（移行担当は削除しない） |
| `.claude/work/test-repo-verification-procedure.md` | `E/00_4733d90/01/manual/procedure.md` | 移した後、`.claude/work/` 側は消す。本書の表紙の参照先もこの移行先に読み替える |
| ゲート方式への変更後の肯定・否定テスト（2026-10-11、`claude -p`） | `E/01_2fb2068/00/probe/gate/` | 記録は `~\AppData\Local\Temp\claude\C--cc-workspace-marketplace-for-cc\<uuid>\scratchpad\probe\gate\`（`pos.jsonl`、`pos.err`、`neg.jsonl`、`neg.err` と `pos/`、`neg/` のサンドボックス）にある（2026-10-11 時点で実在を確認）。一時領域なので消えていることがあり、無ければ `meta.json` の `notes` に結果の要約（肯定テストで Skill ツール経由の実行、否定テストで自発起動なし）だけ書く |
| `raw-2026-10-10\tools\*.py` | `tools/harness/`（10 節の段階 4 で移植する） | 7-10 の変更を加える |
| `raw-2026-10-10\workspace\preflight\` | 移さない | ハーネスの事前確認の実行記録で、評価の一部ではない |
| `raw-2026-10-10\workspace\skill-snapshot\` | 移さない | 評価時の Plugin の複製。commit `4733d90` で代替する |

## 10. 作業順

一度に作らない。各段階で動作を確認してから次へ進む。確認項目は、どの規則が成り立つことを観測するかで書く。

**開発と確認の場所**

- スクリプトと Python は、本物のテスト用リポジトリの作業ブランチで書く。本物の場所でスクリプトを試し実行しない（`evidence/` に確認用の活動ができるため）
- 段階 2〜5 の確認は、テスト用リポジトリを別の場所（例: `C:\cc-workspace\marketplace-for-cc-test-verify`）にクローンした使い捨てのコピーで行う。クローンは段階 2〜5 を通して 1 つを使い続け（段階 5 が段階 2〜4 の活動を閉じるため）、変更は `git pull` で取り込む。確認後にコピーごと捨てる。`evidence/` の下に確認用の活動を残さない
- 段階 2〜5 では `MARKETPLACE_DIR` も marketplace-for-cc の使い捨てクローン（例: `C:\cc-workspace\marketplace-for-cc-verify`）に向ける。本物の marketplace-for-cc の作業ブランチを動かさないため。別の断面は、そのクローンで `4733d90` と `2fb2068` を checkout して作る（`plugin_tree` が異なり、版はどちらも 0.9.0 なので R2 の版違いの拒否は起きない。detached HEAD なので `branch` は null で記録される）。clean でない状態は、クローンの `plugins/pre-compact/` に未追跡ファイルを置いて作る
- R8 の起動前の検査は、`CLAUDE_TEST_USER_SETTINGS` に確認用の設定ファイル（`enabledPlugins` に `pre-compact@...` を入れたもの）を向けて確かめる。作業指示者のユーザー設定は触らない

**担当の分け方**

- PowerShell（`scripts/`、7-1〜7-9）はスクリプト実装の担当、Python（`tools/harness/`、7-10）は移植の担当、9 節は移行の担当。両担当の境界は `run.json`（6-4）、`run_one.py` の終了コード（7-2 の手順 3）、run 直下の記録（6-5、6-9）で、段階 4 に入る前にこの 3 つを固める
- README と `test-repo-guide` の更新は各段階の担当が行い、段階の完了時にオーケストレータが 3-5 の必須の内容を満たすか確かめる。段階 1 では、未実装でも 7 節の書式行をそのまま README に写してよい（書式は本書で確定している）。「実装メモ」は空の節として置き、以後の段階で追記する
- B-1（8-1）は作業指示者が A のセッションで主導する作業で、開発担当の範囲外。開発担当は marketplace-for-cc 側に触れない（`.gitignore` の追加も B-1 で行う）
- 8-1 の A の流れを通しで確かめる段階は設けない。段階 7 の後、最初の本物の活動で通す（本物の証跡を作るので、作業指示者の判断で実施する）

| 段階 | 作業 | 確認項目 |
|---|---|---|
| 1 | リポジトリ作成、`README.md`、`.gitignore`、`.gitattributes`、`.claude/settings.json`、`test-repo-guide` skill（3-5） | `claude` を直下で起動し、`/test-repo-guide` が出ること。`work/` 配下に `git init` した環境を作って起動し、skill が見えないこと（F3） |
| 2 | `Evidence.psm1`、7-5、7-6、7-7 | 次の順で行う。(1) open の活動が無い状態で、`-Purpose` 無しの 7-5 が拒否され `evidence/` に何も増えないこと（R2、R7）。(2) 引数の誤り（例: `-Attempt` と `-Purpose` の併用、`-Plugin _multi-plugins` の 7-5）で拒否され、何も増えないこと（R7、R9）。(3) クローンの `plugins/pre-compact/` に未追跡ファイルを置いた状態で拒否されること（R1）。(4) `-Purpose investigation -Goal ...` 付きで 7-5 を実行し、`evidence/pre-compact/0.9.0/<今日>/00_<sha7>/00/validate/<yyyyMMdd_HHmmss>.txt` ができること（R2、R3）。(5) 同じ試行に `-Attempt` で再実行すると 2 つ目の `.txt` が増えること（R4、R5）。(6) marketplace-for-cc のクローンで別の commit を checkout し、`-Attempt` に前の断面の試行を渡すと拒否されること（R3）。`-Attempt` 無しで実行すると `01_<sha7>` の断面ができること（R3）。(7) 手で open の活動をもう 1 つ作ると拒否されること（R2）。(8) 7-6 `-Method manual` で試行を作り、同じ試行に 7-6 `-Attempt` で再登録しようとすると `running` の残存で拒否されること（7-6）。7-7 `-Status completed` で完了にでき、もう一度実行すると拒否されること（R4）。7-6 `-Method validate` が拒否されること |
| 3 | 7-1 | `-Name` に `.` を含めると拒否されること（7-1、F17）。`-Model` と `-Effort` を引数でも環境変数でも渡さないと拒否されること（R8）。`CLAUDE_TEST_USER_SETTINGS` に `pre-compact@...` を有効にした設定を向けると拒否されること（R8）。起動したセッションで `/plugin` の Installed に `pre-compact` が `Plugin inline` で載ること（F20）。`/memory` の「Open auto-memory folder」が `memory/` を開くこと（R8）。書き込みの確認は 2 つに分ける: (a) R8 の deny の対象（`MARKETPLACE_DIR` 配下と `~/.claude` 配下）への書き込みが拒否されること。(b) それ以外の cwd 外（例: テスト用リポジトリの `evidence/`）への書き込みで確認のプロンプトが出ること（対話では拒否ではなく確認になる。F11）。(b) のプロンプトは承認しない。終了後に表示された後片付けを実行し、`~/.claude/projects/` に残骸が無いこと |
| 4 | `tools/harness/` の移植（7-10）と 7-2、7-3 | `CLAUDE_TEST_USER_SETTINGS` で R8 の検査が拒否すること。前回の case 1 を `-Method probe` で 1 run 実行し、`probe/<case>/case.json` と `probe/<case>/with_skill/run-1/` に 3-2 の「run の中」の配置で記録が入ること（`eval_metadata.json`、`harness_result.json` を含む。6-9）。`-Model` には完全なモデル ID を渡し、`facts.json` の `model` がそれと一致すること（F42。エイリアスでは一致しない）。`-Model` と `-Effort` を引数でも環境変数でも渡さないと拒否されること（R8）。`-Baseline` で同じ case を同じ試行に実行し、`without_skill/run-1/` に入ること（`invocation` が付かないこと）。もう一度 with 腕を実行すると `run-2` になること。case 定義を変えて同じ試行に実行すると、共通処理の前に拒否され `meta.json` に実行が増えないこと（7-2 の固有の引数検査、R7）。存在しないモデル名を `-Model` に渡して `run_one.py` が 1 で終わる run を作り、その run に `harness_result.json` だけが置かれ実行が `aborted` になること（6-9、7-2）。`-Method skill-creator -Iteration 1` で実行し、7-3 で判定が足りない `-Judgments` と `case.json` に無い `id` を含む `-Judgments` がそれぞれ拒否されること（7-3 の手順 3）、正しい `-Judgments` で `grading.json` ができ、2 回目は拒否されること（R5）。`grading.json` の `summary` が「該当なし」を `total` から除いていること（6-5）。その後、skill-creator 同梱の `aggregate_benchmark` と `generate_review.py` を R10 の形（`-X utf8`）で実行し、`benchmark.json` に `grading.json` の値と時間・トークンが入り、`review.html` が各 run と prompt を表示すること（F40）。`~/.claude/projects/` に何も増えないこと（F36 の併用時の確認を兼ねる）。証跡の `run.json` のパス項目が R6 で書かれていること |
| 5 | 7-8、7-9 | 段階 2〜4 の活動を閉じて `_fin` が付き、README が無い状態から見出し行と 1 行が作られること（R5 の許容項目 2〜4）。再実行で行が増えないこと。`running` の実行が残っていると拒否されること（R4）。7-9 `-Plugin pre-compact -Commit HEAD` が試行を返すこと（R1） |
| 6 | 既存データの移行（9 節） | 本物のテスト用リポジトリで行う。7-9 `-Plugin pre-compact -Commit 4733d90` が移行した試行を返すこと。README に `20261010_fin` の行があること |
| 7 | 7-4 | pre-compact の suite（B-1）ができてから。それまでは着手しない。実施時に、終了コード 2 と 130 のとき `aggregate-result.json` が書かれ `partial: true` を持つこと（F37）と、同じコンソールの Ctrl+C で止めたときの状態が 7-4 の例外のとおり `aborted` になることを確かめる |

## 11. 残課題

- `context.history_file` の `.jsonl` の形式は未確認。実セッションの記録を流用するなら、形式を先に確かめる
- probe でユーザー設定（F34）を読まない方法として `--setting-sources` の利用が考えられるが、未検証。当面は `meta.json` の `environment` に記録し、R8 の起動前の検査で対象 Plugin の混入だけを防ぐ。拒否の代わりにサンドボックスの `settings.json` で `enabledPlugins` を上書きする案は、`--settings` がユーザー設定より優先されるか未確認
- `LongPathsEnabled` の有効化は、パスが 200 文字を超える見込みが出たときに検討する。現状は不要
- `_multi-plugins` のテスト内容は、対象となる Plugin の組み合わせが出てから設計する。構成と `-Plugin _multi-plugins` の扱いだけを用意する
- `claude plugin eval` の終了コード 2 と 130 のとき、`aggregate-result.json` が書かれ `partial: true` を持つか（F37）は段階 7 で確かめる
- `acceptEdits` を明示したときに F10 の分類器の通知が出ないかは未確認。整形側で無視する対処で影響を受けない
- F42 の継承を probe の init イベントで実測していない。段階 4 の `facts.json` の `model` の確認で兼ねる。effort の実効値が init イベントか記録のどこかで確認できるかは未確認（確認できれば `facts.json` に加える）
- F17 の非 ASCII 文字の置換は未確認。7-1 の `-Name` の制約で依存を避けている

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
| F41 | PowerShell permission rules use the same shape as Bash rules |
| F42 | Set the model every new session uses / Opus 5.5 and models released after it ignore it / takes precedence over the top-level / a top-level `effortLevel` in your user settings file doesn't count for Opus 5.5 |

## 変更履歴

| 版 | 日付 | 内容 |
|---|---|---|
| 3.0 | 2026-10-11 | v2.7 を構成原則（0 節）に沿って組み替えた。内容の決定は v2.7 と同じ。構成の変更: 横断規則を 5 節（R1〜R10）に集約、データ形式を 6 節に集約、スクリプト節（7 節）を契約だけに、確認項目（10 節）を規則 ID で記述、`Evidence.psm1` の関数表を廃止。委任範囲の拡大（1-5）: 共通関数の分割と名前、`run-<k>/outputs/` のファイル名、判定器の種類の一覧（v2.7 でも委任）。追加: F40（skill-creator 同梱スクリプトの読み方。v2.7 では 6-3 の本文に書いていた）、採用理由 13（拒否の順序）。v2.7 で `Evidence.psm1` の関数表にだけあった振る舞い（`Get-MarketplaceDir`、`Get-EvidenceRoot`、`Get-AttemptKey`、`Get-ProjectStorageDir`、`Write-Refusal`、`New-SandboxSettings`）は R1〜R8 の規則として残し、関数名は本書から外した。v2 系の経緯（セルフチェック 1〜7 巡目）は `test-repo-design_v2.md` の変更履歴を参照 |
| 3.1 | 2026-10-11 | v3.0 の検証（Sonnet 2 件: v2.7 とのトレーサビリティ検査、外部資料との照合）を反映。トレーサビリティ: 「無い」0 件、「意味が変わった」4 件（R4 のノートの時点、R7 の「作業領域」、`evals.json` の生成時点、段階 4 の確認項目）、重複 8 件（6-1、6-2、6-4、R5、R6、7-1、7-5 を参照に置き換え）、参照先のずれ 3 件（1-5、3-5、0 節）を修正。外部資料: 7-10 の「現行との違い」に手動判定の形式、prompt の組み立て、`--allowedTools`、`timeout`、`rmtree` の相違を追加、`grading.json` の必須項目（6-5）、F40 に `eval_metadata.json` の優先と prompt の取得元を追加し、3-2「run の中」に `eval_metadata.json` を追加（ビューアが prompt を表示するため。v3.1 で新たに決めた事項） |
| 3.2 | 2026-10-11 | Opus 5.5 のクロスレビュー（`.claude/work/レビュー/クロスレビュー_論理整合性_2026-10-11.md`、`クロスレビュー_実用性_2026-10-11.md`。CRITICAL 0、IMPORTANT 10、SUGGESTION 6）の全 16 件と質問 9 件を反映。I1: `grading.json` の `summary` で「該当なし」を `total` から除く（6-5）。I2: 6-9「run 直下の記録」を新設し `eval_metadata.json`・`timing.json`・`harness_result.json` の書き手と項目を定義。I3: 7-2 が case 定義を `case.json` として手法フォルダに写し 7-3 はそれと照合、`invocations[]` に `test_repo_commit` / `test_repo_dirty` を追加。I4: 7-1・7-2 で `-Model` と `-Effort` を必須（`CLAUDE_TEST_EFFORT` を追加）、`facts.json` に init イベントの `model`、F42 を追加、6-2 の null の説明を R4 に統一。I5: F17 を「英数字以外を `-`」に訂正し 7-1 の `-Name` を英数字と `-` に制限。S1: 7-4 に Ctrl+C の例外。S2: 7-6 を `manual` 専用にし `running` 残存を拒否。S3: R8 の検査を `@` より前の完全一致に。S4: F41（PowerShell ツール）を追加し `--allowedTools` の既定に PowerShell の git 3 つ、`allowed_tools` に `PowerShell(...)` を許可、素の `PowerShell` を拒否。I-1: R10 の `-X utf8` を同梱スクリプトにも適用し 8-1 の A の (4) に実行形を明記、F39 を補強。I-2: 10 節に開発と確認の場所（marketplace-for-cc のクローン、checkout で断面を作る）と段階 2 の実施順。I-3: 段階 2〜4 に R1・R2・R8・R9 の拒否の確認を追加し `CLAUDE_TEST_USER_SETTINGS`（確認用）を R8 に追加、A の通しは最初の本物の活動で通す旨を明記。I-4: 段階 3 の書き込み確認を deny 対象と確認プロンプトの 2 つに分割。I-5: 9 節に手で書く `meta.json` の値の取得元の表と担当の分担、セッション記録 3 件とゲート方式テストの記録のパスを移行表に追加。S-1: 3-2 にタイムスタンプの時刻帯（Asia/Tokyo）と同名拒否。S-2: 7-2 手順 2 を 3-2・3-3 の参照に、`eval_metadata.json` の定義を 6-9 へ。質問への回答で変えた箇所: Q1（`iteration-<n>` は試行内の通し番号。3-2）、Q2（採用理由 14）、Q3（R8 に with 腕でも拒否する理由）、Q4（`_multi-plugins` の同一性を `plugins/` 全体の tree に変更。R1、3-2）、Q-1・Q-2・Q-4・Q-5（10 節「開発と確認の場所」「担当の分け方」）、Q-3（移行表）。採用理由 15 を追加 |
| 3.3 | 2026-10-11 | v3.2 の差分に限定した Sonnet の最終確認（要修正 1、推奨 10、軽微 6）を反映。「手法フォルダ」と「case フォルダ」（`<case>/`、`eval-<id>-<case>/`）の用語を分け 7-2・7-3 の `case.json` の参照先を訂正、`case.json` の照合を 7-2 の固有の引数検査（共通処理の前）に移動、6-4 の `effort` の渡し方、6-9 と F40 に `timing.json` の読み方、R4 で `effort` の環境変数を参照する手法を限定（7-4 は常に null）、R7 の列挙を例と明記し 3 項目を追加、3-5 の `.claude/settings.json` に PowerShell 版の許可、README に R10 の引数の表記規則、付録 A に F41・F42 の検索語、9 節の `model` / `effort` の取得元を断面ごとに書き分け、6-9 の文の修正、6-2 の `environment` に `user_settings_path`、R1 の「Plugin が無い」の版なしの枝での意味、F17・7-1 を ASCII と明記、F42 に `--settings` の `effortLevel` と `--effort` / `CLAUDE_CODE_EFFORT_LEVEL` の優先関係、11 節に effort の実効値の確認、10 節の段階 2〜4 に `-Model`/`-Effort` 無しの拒否・7-6 の `running` 残存・7-3 の欠けの検査・失敗 run の配置・完全なモデル ID の確認を追加 |
