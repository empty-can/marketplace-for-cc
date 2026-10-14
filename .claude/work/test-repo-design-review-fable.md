# test-repo-design.md のレビュー（Fable 5.1）

レビュー日: 2026-10-10 / 対象: `.claude/work/test-repo-design.md`（Opus 5.5 作成）/ 環境: Claude Code v2.1.296、Windows 11

検証は使い捨てディレクトリで `claude -p`（haiku、合計約 0.05 ドル）を使って行った。リポジトリと `~/.claude/projects/` に痕跡は無い。

## 総評

骨格（証跡をラウンド単位にする、作業領域と証跡を分ける、テスト環境ごとに git init する、memory を repo の外に置く、suite は Plugin 側に置く）は妥当で、根拠もおおむね正しい。ただし、設計の土台になっている前提のうち 2 つが実機で崩れた。

1. **許可リストは柵として機能していない。** ユーザー設定の `defaultMode` が `auto` で、`claude -p` もそれを継承する。auto mode では許可リストに無い操作も分類器が承認するため、設計書の「柵 4」は書かれたままでは効かない。
2. **パス限定の Write / Edit 許可ルールは Windows で一致しなかった。** 3 形式を試してすべて不一致だった。素の `Write` は無制限に効く。したがって「allow で書き込み先を絞る」設計は使えない。

どちらも代替手段を検証済みで、構成を変えずにスクリプトの引数で直せる。

## 検証結果（2026-10-10、v2.1.296）

内側に別 git リポジトリを持つ入れ子ディレクトリで、外側に `CLAUDE.md`（合言葉入り）と `.claude/skills/outer-probe/` を置き、内側から起動した。

| # | 条件 | 結果 | 設計書への影響 |
|---|---|---|---|
| P1 | 除外なし | 外側の合言葉が読めた。外側の skill は init イベントの一覧に**無い** | 2-1 の「CLAUDE.md は git 境界で止まらない」「skills はリポジトリのルートで止まる」を実測で裏付け。理由 3・4 は成立 |
| P2 | `--settings` で `claudeMdExcludes: ["C:/.../CLAUDE.md"]` | 合言葉が読めなくなった（NONE） | 未確認事項 3 を解決。`C:/` 形式のスラッシュ区切りで一致する |
| P3 | auto mode、`Write(//C:/.../repo/**)` を allow | repo 内も repo 外も書けた。拒否なし | allow が効いていない、かつ auto mode が repo 外の書き込みを承認している |
| P4 | auto mode、`permissions.deny: ["Write(//C:/.../protected/**)"]` | repo 内は書けた。protected は拒否 | deny の `//C:/` 形式は一致する（P7b との比較で帰属を確認） |
| P5 | `--permission-mode default`、P3 と同じ allow | **両方拒否**（repo 内も） | パス限定の allow が一致していない |
| P6a〜c | default mode で `Write(**)`、`Write(//C:\...\**)`、`--settings` 経由の `Write(//C:/.../**)` | すべて両方拒否 | 相対・バックスラッシュ・設定経由のいずれも不一致。原因は未特定 |
| P7a | default mode、素の `Write` | 両方書けた | 素の Write は無制限 |
| P7b | auto mode、ルール無し | protected に書けた | P4 の拒否は deny ルールによるもの |
| P7c | `--permission-mode acceptEdits`、Write ルール無し | repo 内は書けた。protected は拒否 | **acceptEdits は cwd 内だけを自動承認する** |
| P8 | acceptEdits + `--add-dir <memory>`、Write ルール無し | repo 内と memory は書けた。protected は拒否 | **書き込み先を repo と memory に限定する手段として使える** |

### 追加検証（同日、作業指示者の承認後）

公式 docs（77771 行、103217 行）に「ファイル権限の判定は `Edit(path)` と `Read(path)` だけを参照し、`Write(path)` ルールは受理されるが参照されない」と明記されていた。上の P3〜P6 と P4 はすべて `Write(path)` で書いていたので、やり直した。

| # | 条件（すべて分類器を介さない mode） | 結果 |
|---|---|---|
| R4 | acceptEdits、deny `Write(C:/.../repo/**)`、cwd 内に Write | 書けた。`Write(path)` は参照されない（docs どおり） |
| R5 | default、allow `Edit(**)` | repo 内は書けた、外は拒否。相対形式は効く |
| R1 / R3 | allow または deny を `Edit(//C:/.../**)` | どちらも不一致 |
| R7b / R6d | deny を `Edit(/C:/...)`、`Edit(//Users/...)` | 不一致 |
| R7a | deny `Edit(~/AppData/.../repo/**)` | 拒否された。`~/` 形式は効く |
| R7c / R8a | deny `Edit(C:/.../repo/**)`（接頭辞なし） | 対象は拒否、対象外のパスは通る。効くが docs に無い書き方 |
| R8b | default、allow `Edit(C:/.../repo/**)` | repo 内は書けた、外は拒否 |
| R9a / R9b | deny と allow を `Edit(//c/Users/.../repo/**)` | deny は拒否、allow は repo 内だけ許可。**docs 記載の正式な形式**（77806 行: Windows では `C:\Users\alice` を `/c/Users/alice` に正規化してから照合する。v1.0.106 で修正） |

結論: Windows の絶対パスは **`//c/Users/...`（ドライブ文字を小文字にし、コロンを外す）** で書く。`~/...` も使える。`//C:/...` は一致しない。

訂正: P4 と R2 で auto mode の deny が「効いた」ように見えたのは、docs 上は参照されない `Write(path)` ルールだったので、分類器の揺らぎと見るべきである。auto mode では deny ルールの検証自体ができない。

`claudeMdExcludes` は `C:/` 形式で効いた（P2）。バックスラッシュ形式は権限ルールでは正しく渡せず未確認。スクリプトはスラッシュ区切りで出力すること。

eval（B）の機構確認は、Plugin のコピーを使い捨て領域に置き、prompt 先頭に `/pre-compact:pre-compact` を書いた case を 1 run・with 腕のみ・haiku で実行した。

| 確認項目 | 結果 |
|---|---|
| 先頭スラッシュで skill 本文は実行されるか | 実行された（最終応答に終了方式の提示と `/compact` コメント案） |
| `tool_used: Skill` はユーザー起動を数えるか | **数えない**（`Skill called 0x`）。起動確認は `regex` か `llm` grader で最終応答を見る |
| B の run 内で auto memory は使えるか | **使えない**。一時 config に memory ディレクトリは作られる（空）が、読み取りは権限設定で拒否された。`Bash` もツール自体が無い |

## 誤り・修正が必要な箇所（重要度順）

### 1. 柵 4「コマンドの許可リスト」は auto mode では効かない（6-3、2-4）

- ユーザー設定 `~/.claude/settings.json` の `permissions.defaultMode` は `auto`。`claude -p` の init イベントでも `permissionMode: auto` だった
- 設計書 2-4 の「許可リスト外のコマンドは拒否される」は、前回の評価が `--permission-mode acceptEdits` を明示していたから成り立った観察で、一般化すると誤り
- 設計書の `launch-sandbox.sh`（6-1）と `run-probe.sh`（6-3）はどちらも permission mode を指定していないので、auto mode が継承される
- **修正**: 両スクリプトで `--permission-mode acceptEdits` を固定する。acceptEdits では、cwd 外への書き込みと許可リストに無い Bash は非対話モードで拒否される（P7c、および前回評価での pytest 拒否）

### 2. 書き込み先の限定は allow ではなく mode と `--add-dir` で行う（6-3、6-5）

- 設計書 6-5 の `Write(...)` ルールは、docs どおり参照されない。ファイル権限は `Edit(path)` と `Read(path)` で書く。`Edit` ルールは Write を含む全ファイル編集ツールに及ぶ
- Windows の絶対パスは `//c/Users/...` の形（ドライブ文字を小文字、コロンなし）で書く。docs 77806 行に明記があり、実測でも一致した。`//C:/...` は一致しない。`~/...` も使える
- **修正（推奨）**: `--permission-mode acceptEdits --add-dir <memory>` とし、`--allowedTools` に `Write` / `Edit` を入れない。これだけで書き込みは repo と memory に限定される（P8）。パスルールは不要
- deny を最後の防御として残すなら `Edit(//c/cc-workspace/marketplace-for-cc/**)` と `Edit(~/.claude/**)` の形で書く。deny は Claude Code が認識する Bash のファイル操作（`cat` `sed` `tee` とリダイレクト）にも及ぶが、任意コマンドには及ばない。許可する Bash を読み取り系 git に限れば実害は無い
- 結果として `config/probe-settings.json` に残るのは deny と `autoMemoryDirectory` と `claudeMdExcludes` だけになる。雛形ファイルを別に持つ必要は薄く、ハーネス内で JSON を生成する方が簡単

### 3. B のベースライン腕は、この Plugin では成立しない（5、6-2、未確認事項 6）

- `disable-model-invocation: true` の skill は、B の case でも prompt の先頭に `/pre-compact:pre-compact` を置かないと起動しない（非対話モードで文中起動が拒否されたことは 2-4 のとおり）
- without 腕では Plugin が無いので、その行は未知のスラッシュコマンドになる。changelog（v2.1.147）によれば、非対話モードの未知スラッシュコマンドはエラーになる。したがって Δ は無意味
- **修正**: pre-compact の case は `--ablation none` で with 腕だけを採点するか、`context.history_file` を使う case にする（path 指定の target では既定でベースライン無し）。`tool_used: Skill` grader はユーザー起動を数えない（追加検証で `Skill called 0x`）ので、起動確認は `regex` か `llm` grader で最終応答を見る
- 加えて、B の run では Bash ツール自体が無く、auto memory も読めない（追加検証）。skill のステップ 2（`git status`）と 3（memory の更新）は常に実行できないので、grader で減点しない設計が要る。実測では、skill はその旨を断った上で `/compact` を推奨し、コメント案を出した。未確認事項 6 は「memory と git の確認は probe 側に残す」で確定

### 4. 事実と推論の区別（2-3）

- 「Write と Edit の許可は、サンドボックスを必要としない」は docs の明記ではなく、サンドボックス要件が Bash / PowerShell についてだけ書かれていることからの推論。印を付ける
- 2-1 の 2 行（CLAUDE.md の越境、skills の境界）と 2-3 の deny 形式・`claudeMdExcludes` は、今回の実測で「docs」から「検証済み」に格上げできる

### 5. `evals/results/` の除外は必須、かつ内容は公開前提（3-2、未確認事項 1）

- `claude plugin eval init` は作成した case を試行実行し、結果を Plugin 側の `evals/results/` に書く。marketplace-for-cc の `.gitignore` への追加は「念のため」ではなく必須
- marketplace-for-cc は public リポジトリなので、`evals/` に置く fixture（会話記録、memory のサンプル）は公開される前提で作る。合成データに限る
- `evals/` を配布物から除外する手段は docs に見当たらない。無いものとして扱ってよい

## 構成への改善提案

1. **`CLAUDE.md` を置かず、README と project skill で代える案を検討する。** `.claude/skills/` は入れ子 git で止まる（P1）ので漏れない。`claudeMdExcludes` 方式も動く（P2）が、手動で `claude` を起動したときに除外を忘れると漏れる。どちらでも成立するが、構造で防ぐ skill 方式の方が運用ミスに強い
2. **`launch-sandbox.sh` も `--permission-mode acceptEdits --add-dir <memory>` を付ける。** 手動確認でも auto mode の分類器に任せない
3. **`tools/probes/` は `tools/harness/` に改名し、A の実行器を兼ねることを明示する。** pre-compact のように memory・git・Plugin の読み込みが要る skill は、skill-creator 同梱の subagent 方式では再現できない。`claude -p` ハーネスで実行し、skill-creator は採点集計とビューアだけ使う（未確認事項 8 への回答）
4. **ラウンド名は `<YYYY-MM-DD>_v<version>_<sha7>` に固定する。** リリース前後を問わず一意になり、判断が要らない（未確認事項 7 への回答）
5. **作業順を決める（未確認事項 9 への回答）。** 構成は過剰ではないが、一度に作らない。`validate.sh` と `launch-sandbox.sh` を先に作る（文中起動の対話確認に後者が要る）。ハーネスは現状のまま移す。`run-eval.sh` は suite ができてから。設定テンプレートは作らない
6. **`run-eval.sh` は `--json` を使うなら `--trust-plugin` が必須。** 非対話では信頼プロンプトを出せず、exit 1 で拒否される
7. **`/cd` で Plugin ルートへ移った後は marketplace-for-cc の hooks が効かない。** `.claude/settings.json` は親へ遡らないため。`.bat` 保護の hook も無効になる。evals の作成には影響しないが、5 節の注意に加える
8. **`context.history_file` の `.jsonl` 形式は未確認。** 実セッションの記録を流用する想定なら、記録の取り方（transcript の形式）を先に確かめる
9. **`launch-sandbox.sh` の `--plugin-dir` は Plugin 単体を既定にし、`plugins/` 全体は明示オプションに限る。** セッション限定で Plugin を読み込む起動フラグは `--plugin-dir` と `--plugin-url` だけで（79039 行）、Marketplace を起動時に一時追加する手段は無い。`plugins/` を渡すと statusline も読み込まれ、その SessionStart hook がユーザー環境へ `statusline.sh` をコピーするので、単体テストの隔離が崩れる。Marketplace のルートを渡すのは誤り（33632 行）。この点は設計書 6-1 に追記済み（2026-10-11）

## 残る未確認事項

すべて解決した。

解決済み（2026-10-11、作業指示者が対話セッションで確認、v2.1.296）: **`/cd` では auto memory の保存先は切り替わらない。** 移動後に Claude 自身が「システム側の案内には移動前の repoA のパスが残っていた」と述べ、自分の判断で repoB 側のパスを組み立てて書いた。セッションの記録は移動先のプロジェクト保存領域へ移る。`/cd` したセッションでは memory に依存する作業を行わない、と設計書 5 節に注記した。

解決済み（2026-10-11、作業指示者が対話セッションで確認、v2.1.296、Sonnet 5.5）: **文中起動は対話セッションでも拒否される。** `動作確認です。/pre-compact:pre-compact を実行してください` と `動作確認です。/pre-compact を実行してください` のどちらも、Claude が Skill ツールを呼んだ時点で `cannot be used with Skill tool due to disable-model-invocation` と拒否された。先頭に置いた `/pre-compact:pre-compact` は正常に実行された。公式 docs 44392〜44397 行の「文中の `/skill名` はそのメッセージでの実行許可になる」という記述は、少なくとも `disable-model-invocation: true` の skill には適用されない。設計書 2-4 の記述を「非対話・対話ともに拒否」に改める。pre-compact Plugin の README・CHANGELOG・SKILL.md「起動方法」節の修正が必要（別途、作業指示者の判断待ち）。

解決済み（追加検証）: `tool_used: Skill` はユーザー起動を数えない。B の run 内では auto memory は読めず Bash も無い。パスルールが効かなかった原因は `Write(path)` を書いていたことと、Windows で `//C:/` 形式が一致しないこと。正式な形式は docs 77806 行の `//c/Users/...`（実測で効く）。`~/...` も効く。
