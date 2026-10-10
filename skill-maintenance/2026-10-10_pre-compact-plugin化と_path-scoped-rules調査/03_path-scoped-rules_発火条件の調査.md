# 03. path-scoped rule / `paths:` 付き skill / 入れ子 CLAUDE.md の発火条件 — 調査記録

- 日付: 2026-10-10
- 発端: 作業指示者の懸念「`paths:` frontmatter による path-scoped rule は、そのパス配下のファイルを Read ツールで読まないと発火しない（Grep ツールでもダメ）と先月聞いた。auto モードでは Claude Code がファイル読み込みに Bash の cat / tail を使うことがほとんどなので、path-scoped rule はいつの間にか機能しなくなっていた。現在は改善されている可能性もある」
- 許可された情報源: 公式 docs（ローカルミラー）、GitHub `anthropics/claude-code` の issue（GitHub MCP 経由、準一次情報）、Web 検索（二次情報）。さらに本セッションで実機検証を行った
- 原文: `sources/official-docs-excerpts.md`（docs）、`sources/github-issue-*.json`（issue 8 件の API 原文）、`sources/github-search_q*.json`（issue 検索の生結果）、`sources/web-search-results_2026-10-10.md`
- 実測: `検証/発火テスト手順書.md`、`検証/発火テスト結果_2026-10-10.md`

## 1. 結論（2026-10-10、Claude Code 2.1.296 時点）

1. **作業指示者の記憶は 2.1.292 以前については正しい。** path-scoped rule は Read ツールでしか発火せず、Bash の `cat` / `grep` も、Write / Edit さえ発火しなかった
2. **2.1.288（2026-10-02）で Write / Edit が発火対象になり、2.1.293（2026-10-07）で Bash の単一ファイル `cat` `head` `tail` `sed -n` `grep` が発火対象になった**（changelog 原文は §2.2）
3. **実測では `cd X && cat file` や `cd X && head -1 file && echo done` の `&&` 連結でも発火した。** docs の定義「単一ファイル・パイプ無し・リダイレクト無し」より寛容
4. **発火しないもの（実測）**: パイプ付き（`cat f | head`）、Grep ツール、Bash 編集（`sed -i`）。Write / Edit は発火するが本文が届くのはツール結果と一緒＝書き込み後
5. **`paths:` 付き skill は 2.1.293 の修正対象外。** Bash の `cat` では発火せず、Read で「利用可能になった」通知が出るだけ。さらにサーフェスされるまでは Skill ツールにも `/name` にも「存在しない」扱い
6. **入れ子 `CLAUDE.md` は rule と同じ 1 行で修正され、`cd && cat` で祖先 2 階層分が発火した**
7. rule はセッション途中に追加しても即発火する。発火済み rule を編集しても同一セッションでは再注入されない（1 セッション 1 rule 1 回）。rules 用の reload コマンドは無い
8. 発火判定はハーネス側の処理なので、モデルのバージョンではなく **Claude Code のバージョン**で決まる。2.1.293 未満の職場環境では Read ツール限定のまま

## 2. 公式 docs の記述（一次情報）

### 2.1 現行の定義

- memory ページ「Path-specific rules」: *A path-scoped rule loads when Claude uses the Read, Write, or Edit tool on a matching file. It also loads when Claude views a matching file with a Bash command that counts as a read, such as `cat` or `head` on a single file. Matching also works when Claude reaches a file through a symlinked path to the project directory.*
- memory ページ nested CLAUDE.md: *Instead of loading them at launch, Claude Code loads each one once Claude reads, writes, or edits another file in that subdirectory. Reading includes viewing the file with a Bash command that counts as a read, such as `cat` or `head` on a single file.*
- tools-reference「Edit tool behavior」（「counts as a read」の定義）: *Viewing a file with Bash also satisfies the read-before-edit requirement when the command is `cat`, `nl`, `bat`, `batcat`, `head`, `tail`, `sed -n 'X,Yp'`, `grep`, `egrep`, `fgrep`, or `rg` on a single file with no pipes or redirects. Piped output and other Bash commands don't count toward the read-before-edit check.*
- memory ページ「Rule frontmatter reference」: `paths` は rule が読む唯一の frontmatter。YAML が壊れていると frontmatter を無視し無条件 rule として読む。glob は `**/*.ts` のような拡張子指定も可（表あり）。brace 展開の予算は 1,000 パターン / 4 MiB
- skills ページ「Frontmatter reference」`paths` 行: *Glob patterns that limit when this skill is activated. … When set, Claude loads the skill automatically only when working with files matching the patterns. Uses the same format as path-specific rules.*
- hooks ページ「InstructionsLoaded」: CLAUDE.md や rule がロードされたときに発火する観測専用 hook。`load_reason` は `session_start` / `nested_traversal` / `path_glob_match` / `include` / `compact`。`trigger_file_path` でどのファイルが契機かが分かる。決定制御は無い
- context-window「What survives compaction」: `paths:` 付き rule と入れ子 CLAUDE.md は圧縮後に「on demand で再ロード」、ルート CLAUDE.md と `paths:` 無し rule は「ディスクから再注入」。invoked skill 本文は 5,000 トークン / 合計 25,000 の予算で再注入
- commands ページ: `/reload-plugins` と `/reload-skills` はあるが rules 用は無い。`/compact [instructions]`、`/clear [name]`（エイリアス `/reset` `/new`）
- hooks ページ「Limitations」: *Command hooks communicate through stdout, stderr, and exit codes only. They can't trigger `/` commands or tool calls. Text returned via `additionalContext` is injected as a system reminder that Claude reads as plain text.*
- memory ページ「CLAUDE.md vs auto memory」: *Claude treats them as context, not enforced configuration. To block an action regardless of what Claude decides, use a PreToolUse hook instead.*
- Plugin 標準レイアウト（manifest reference「Standard layout」）に rules というコンポーネントは無い → **rules は Plugin で配布できない**。配布経路は層 1（リポジトリの `.claude/rules/`）か `~/.claude/rules/`。managed settings ディレクトリ経由は CLAUDE.md と skills は docs に記載があるが rules の記載は見つけられなかった

### 2.2 changelog（抜粋。バージョンは直上の `<Update label>`）

```text
2.1.293 (October 7, 2026):  Fixed path-scoped rules and nested CLAUDE.md files not loading when Claude views a file with a single-file cat, head, tail, sed -n or grep command in the Bash tool instead of the Read tool
2.1.288 (October 2, 2026):  Fixed path-scoped `.claude/rules` and nested CLAUDE.md files not loading when Write or Edit creates or changes a file in their scope (previously only Read loaded them)
2.1.269:  Fixed `permission_denials` in `--output-format stream-json` results omitting Read, Edit and Write calls blocked by a path-scoped deny rule
2.1.211:  Fixed nested `.claude/rules/*.md` files loading even when setting sources exclude project settings
2.1.198:  Fixed `.claude/rules/` conditional rules not loading when the target file is reached via a symlinked path
2.1.176:  Fixed hook `if` conditions for Read/Edit/Write tool paths: documented patterns like `Edit(src/**)`, `Read(~/.ssh/**)`, and `Read(.env)` now match correctly
2.1.84:   Rules and skills `paths:` frontmatter now accepts a YAML list of globs
2.1.69:   Added `InstructionsLoaded` hook event … / Fixed conditional `.claude/rules/*.md` files (with `paths:` frontmatter) and nested CLAUDE.md files not loading in print mode (`claude -p`)
2.0.64:   Added support for .claude/rules/
```

関連（skill の文中言及）:

```text
2.1.287:  Improved `/skill` names typed mid-message: Claude is now told they are skills, including `disable-model-invocation` ones
2.1.292:  Fixed a compaction summary that repeated `/name` letting Claude invoke a skill that is reserved for the user
2.1.110:  Fixed skills with `disable-model-invocation: true` failing when invoked via `/<skill>` mid-message
```

### 2.3 docs ミラー更新の記録

本セッション中（2026-10-10 15:00:04）にローカルミラー `llms-full.txt` が更新された（119,210 行 → 120,369 行）。セッション前半で参照した行番号は旧ミラーのもので、`sources/official-docs-excerpts.md` は新ミラーから見出し起点で再抽出している。`/compact Focus on the API changes` の例は新ミラーにも存在する（2450 行）。

## 3. GitHub issue（準一次情報）

### 3.1 作業指示者からの補足（扱い方のルール）

> claude code はソース非公開であり、GitHub の claude code リポジトリは利用者からの issue による不具合報告スペース。issue から PR が作られることはない。開発チームは issue への返信やステータス管理にはほとんど時間を割いていない。**close されていても解消されているとは判断できず（一定期間コメントの無い issue は bot がクローズして回る）、open だからといって解消されていないとも言えない。** 公式ドキュメントも、リリース内容の掲載が当日・翌日より後になることが稀にある。よってあくまで準一次情報として扱い、実際に解消されているかは動作確認が必要。

→ 本調査では issue のステータスを根拠にせず、changelog と実測を根拠にした。実測前にステータス・issue 内測定だけで述べていた 3 点（Grep ツール不発、`sed -i` 不発、`paths:` 付き skill 未修正）はすべて実測で確認した。

### 3.2 検索

GitHub MCP `search_issues` を 2 クエリ（`repo:anthropics/claude-code rules paths frontmatter bash cat not loading` / `repo:anthropics/claude-code "path-scoped" rules Bash tool Read tool`、updated 降順）。結果の生 JSON は `sources/github-search_q1_*.json` / `q2_*.json`。番号・状態・作成日・タイトルの一覧:

```text
#100366 [open]   2026-10-08  [DOCS] Sub-agents page: omitClaudeMd and Explore do not stop a nested CLAUDE.md or path-scoped rule loaded after a Read; --agent session has no git status
#93706  [open]   2026-09-11  Auto mode steers the model to Bash, which cuts path-scoped rules off at the knees
#93403  [open]   2026-09-10  [BUG] Nested <subdir>/.claude/skills and subdirectory CLAUDE.md never load in auto mode: trigger fires only on Read/Edit
#92958  [open]   2026-09-09  [BUG] Cowork Windows: September 2026 cumulative update breaks Plan9 share attach（無関係）
#91870  [open]   2026-09-03  Mods - make Claude 10x more extensible（無関係）
#90450  [open]   2026-08-28  [BUG] Auto Mode's Bash-first instruction silently disables nested CLAUDE.md and path-scoped rules
#90449  [open]   2026-08-28  [BUG] Subdirectory `CLAUDE.md` loads only via the `Read` tool — every other file access path silently skips it
#90004  [open]   2026-08-27  [BUG] Conditional (paths:) skills can never activate in auto mode — the trigger is wired only to Read/Edit/Write
#88565  [open]   2026-08-21  [BUG] Auto mode silently disables path-scoped rules: it instructs the agent to edit files through Bash, and Bash edits never trigger them
#88279  [open]   2026-08-20  Bash tool's injected `grep` shadow silently drops .gitignore'd files（無関係）
#87971  [open]   2026-08-19  [BUG] Claude abuses bash tools for reads, writes, and edits when running in Auto Mode
#87804  [open]   2026-08-19  [FEATURE] Prompt-topic triggers for .claude/rules/ — `paths:` covers files, nothing covers subjects
#84747  [closed] 2026-08-07 (closed 2026-10-09)  fix(hookify): enforce proper rule evaluation scope and secure file read（無関係）
#82056  [open]   2026-07-28  A session cannot determine whether its auto-memory index loaded whole, truncated, or not at all
#79984  [closed] 2026-07-22 (closed 2026-09-22, stale bot)  [BUG]（path-scoped rule は Read のみ）
#78795  [open]   2026-07-18  [FEATURE] Triggered injection for auto-memory topic files (rules-style frontmatter)
#17204  [closed] 2026-01-09 (closed 2026-05-16)  Documentation: .claude/rules/ frontmatter format incorrect - globs works, paths with quotes/YAML list does not
（他、無関係なものは省略。全件は JSON を参照）
```

### 3.3 主要 issue の要点（原文は `sources/github-issue-<番号>.json` の `body`）

- **#79984**（2026-07-22、v2.1.216、closed: stale bot が 09-22 に閉じた）: path-scoped rule は Read ツールでのみ注入。Write、Bash 経由の読み取り（`git show`、`grep`、`cat`）では注入されない。マッチする rule があったのに適用されなかったことを示す診断が無い。高リスクなのは subagent / review agent で、Bash で中身を集めるため rule を一度も受け取らない。再現手順: `.claude/rules/py-rule.md` に `paths: ["**/*.py"]` と SENTINEL を書き、`git show HEAD:<file>.py` → 不発、Read → 発火、Write で新規 .py → 不発
- **#90449**（2026-08-28、v2.1.250、Windows、open、has repro）: 27 通りのアクセス方法を各々独立ディレクトリで測定し、発火したのは Read ツールのみ（絶対パス・相対パス・**存在しないパス**・2 階層下のファイル）。Grep / Glob / Write / Edit ツール、POSIX の `cat` `sed -n` `head` `tail` `awk` `python` `ls -la` `grep` `find` `sed -i` heredoc、PowerShell の `Get-Content` `Select-String` `Get-ChildItem` `[System.IO.File]::ReadAllText()` `Set-Content`、cmd の `type` はすべて不発。機構は「ファイルアクセス」ではなく「パス解決」（存在しないファイルの Read でも注入）。1 ディレクトリ 1 セッション 1 回。path-scoped rule も同じトリガーで、4 ペア（`.claude/agents/**` に PowerShell `Get-Content`、`.claude/skills/**` に Grep ツール、`.claude/rules/**` に `awk`、`plugins/**` に `head -5`）で陰性→Read で陽性を確認。rule 固有の差として「rule は 1 rule 1 回で重複排除」「rule の発見は起動時で、途中作成・編集は再起動まで効かない（nested CLAUDE.md は live 発見）」と記述 → **後者は 2.1.296 の実測で否定**（途中追加が即発火）。提案 3 案と診断の追加要望。関連 #63142 #24987 #48031 #2571 #3529 #3103 #18098
- **#93706**（2026-09-11、open、duplicate ラベル）: auto モードの system 指示「Do your work through the Bash tool wherever it can accomplish the job: read files with cat, head, or sed -n …」が Read を使う理由を消し、唯一のトリガーだった Read が使われなくなる。5 つの path-scoped rule を持つリポジトリで長い auto セッション中に 1 つも発火しなかった。再現: `head` → 不発、Bash 書き込み → 不発、Write ツール → 不発、存在しないファイルの Read → 発火（＝ Read ツールの `file_path` 引数への glob 照合が実行前に評価される）。修正案: ツールではなく触ったパスで判定、無理なら auto モードの Bash 誘導をやめる。hook での回避は「一級機能のトリガーを手で組む」ことになる。関連 #23478 #38487 #63142 #16853 #31292 #85511 #39979
- **#90004**（2026-08-27、open）: `paths:` 付き skill も同じく Read/Edit/Write にしか配線されておらず auto モードでは発火しない → **2.1.296 の実測で Bash `cat` 不発を確認（未修正）**
- **#93403**（2026-09-10、open）: 入れ子 `.claude/skills` とサブディレクトリ CLAUDE.md が auto モードでロードされない（トリガーが Read/Edit のみ）
- **#88565 / #90450**（2026-08、open）: 同系統の auto モード起因報告
- **#100366**（2026-10-08、2.1.293 で測定、open、docs ラベル）: `omitClaudeMd: true` の subagent や Explore も、起動時は CLAUDE.md を省くが、**Read 後には入れ子 CLAUDE.md と path-scoped rule が system-reminder として届く**。`claude -p --agent` では git status snapshot が無い。→ 修正後の版での測定として「Read で rule が届く」ことの傍証
- **#17204**（closed、2026-05 解決扱い）: `paths:` の引用符付き・YAML リストが効かず `globs:` が効いた（古い版）。2.1.84 で YAML リストに対応

## 4. 実機検証の要約

詳細は `検証/発火テスト結果_2026-10-10.md`。総括表:

| アクセス方法 | path-scoped rule | 入れ子 CLAUDE.md | `paths:` 付き skill |
|---|---|---|---|
| Bash `cat file`（単独） | 発火 | — | **不発** |
| Bash `cd X && cat file` | **発火** | **発火**（2 階層） | — |
| Bash `cd X && head -1 file && echo done` | **発火** | — | — |
| Bash `cat file \| head -1` | 不発 | — | — |
| Bash `sed -i` | 不発 | — | — |
| Grep ツール（content） | 不発 | — | — |
| Read ツール | 発火 | 発火 | 通知のみ（本文は起動時） |
| Write ツール | 発火（書き込み後に本文） | — | — |
| Skill ツール / `-p` の `/name`（未サーフェス） | — | — | **Unknown skill** |
| 途中追加 | 即有効 | — | 登録更新待ち |
| 発火済みの編集 | 再注入なし | — | — |

## 5. 評価と含意（作業指示者とのやり取りで確定した内容）

### 5.1 「ほとんど解消されていない」という評価に対して

- **一部は反対**: 最も多用される `cd X && cat/head/tail file` は発火する。読み取りの大半は 2.1.293 で救われた
- **同意する点**: パイプ付き（`| head` `| grep > 出力`）、Grep ツール、`sed -i` などの Bash 編集は不発。Write / Edit の注入は編集内容の生成より後に届く（「無視するか作り直すか」の二択になる）。`paths:` 付き skill は未修正
- 「編集直前までロードされない」が実害になるのは、最初の接触が書き込みである場合（新規作成）と、パイプ・Grep ツールだけで中身を見てから編集する場合。単独やチェーンの `cat` で読んでから `sed -i` する流れなら、読んだ時点で rule は載っている
- **より本質的な点**: 「あらゆる作業の前にロードされなければならない」内容を path-scoped rule に置くのは仕組みの設計と合わない。path-scoped rule は遅延ロードが本質。常時適用が必要なら `paths:` 無し rule かルート `CLAUDE.md`、強制したいなら hook。本リポの `.ps1` 文字コード規約はその構成（rule は説明、`if: Edit(**/*.ps1)` 等の hook が強制）で、検証中も hook 側が実害を止めた
- 作業指示者の総括: 「`cat &&` の結合で発火してくれるのであればかなりの割合で発火しそう。ただし読み込みだけでもパイプで grep に繋げるケース（`cd <folder> && cat <file> | grep <keyword> > 出力`）がとても多いので充分とは言えない。開発チームが着実に対応している様子が可視化されて安心はできた」

### 5.2 `paths:` 付き skill が使えないことで影響を受ける一般的ユースケース

- 領域別の手順 skill（`db/migrations/**` でマイグレーション手順、`**/*.test.ts` でテスト規約、`*.tf` で IaC 手順）。memory ページは「多段の手順や一部分にしか関係しない内容は skill か path-scoped rule へ」と案内しており、その移し先の片方
- ファイル種別に紐付くツール同梱 skill（`*.xsd` → XSD 解析スクリプト、`*.ipynb`、`*.bat`/`*.ps1` → 文字コード変換、`openapi.yaml` → docs 再生成）。作業指示者環境の `xsd-to-rdb` や `large-file-reading` も候補だったが、Bash 読み取り中心の運用では逆効果
- skill 一覧のコンテキスト節約（説明文は 1,536 字で切り詰め、一覧の予算は文脈窓の 1%、超過時は使用頻度の低い skill から説明が落ちる）。`paths:` で外した skill は Bash 読み取りでは戻ってこない
- Plugin で配る領域特化 skill（利用者が auto モードなら届かない）
- 影響が無いもの: 説明文で起動判断させる通常の skill、`disable-model-invocation: true` の手動起動 skill、rule

### 5.3 回避策と、その後の訂正

1. skill の `paths:` を外し、説明文の一致で起動させる（常時一覧のコストを払う）
2. **rule を引き金、skill を本体にする**: `paths:` 付き rule に短い指示を書き、手順本体は skill に置く
   - **訂正（C ラウンドの実測後）**: この構成で skill 側に `paths:` を付けてはいけない。rule が `cd && cat` で発火しても skill はサーフェスされず、rule が指示する `/skill名` の起動は `Unknown skill` で失敗する。skill は `paths:` 無しで常時登録し、rule だけで絞る
3. **作業指示者案（サーフェス専用 rule）**: skill に `paths:` を残したまま、同じ `paths:` の rule を併設し「対応する skill を **Read** しろ」の一文だけ書く。将来制約が解消したら rule を消すだけで戻せる
   - 成立する。条件: 「`/skill名` を起動せよ」ではなく「`<path>/SKILL.md` を Read せよ」と書く（ファイルとして読む分には登録状態と無関係）
   - Read は skill 起動と等価ではない: `$ARGUMENTS` / `${CLAUDE_SKILL_DIR}` の置換、`allowed-tools` の付与、skill frontmatter `hooks` の登録は行われない。圧縮後の再注入は「最近読んだファイル 5 件」枠。手順書型 skill なら実害はほぼ無い
   - Plugin 配布の skill には使いにくい: SKILL.md がキャッシュ（`~/.claude/plugins/cache/<marketplace>/<plugin>/<version>/skills/…`）にあり、rule には `${CLAUDE_PLUGIN_ROOT}` の置換が無いので固定パスを書けない
   - rules は Plugin で配布できない（§2.1）。層 1 で配る skill には有効
   - 対象 skill が数個なら `paths:` を外す方が単純（1 skill 約 100 トークン）。多い環境では提案方式の方が節約効果が出る

### 5.4 skill の確実な実行について（作業指示者の理解の確認）

作業指示者の理解: 「本来あるべき挙動でも、明示的に指示しない限り意図した skill が意図通りに起動するとは限らない。確実に実行させたいなら hook の pre 系イベントや workflow 化で実行をコード化する必要がある。言い換えれば path-scoped rule はコンテキスト消費量の最適化が主目的で、ルール通りに skill を実行させる仕組みではない」→ **合っている**。補足 2 点:

1. rule 自体も「指示」であって強制ではない（memory ページ: context, not enforced configuration）
2. hook も skill を起動できない（hooks ページ「Limitations」）。hook が保証できるのは (a) hook 自身のスクリプトが必ず走る、(b) 条件を満たすまで操作を deny で止める、(c) `additionalContext` で文章を必ず届ける、の 3 つ。「確実に skill を実行させる」は正確には「skill の内容を確実に届ける」か「条件未達の操作を確実に止める」。処理そのものを確実に行いたいなら hook や workflow のコードに処理を書く

確実性の階段: 説明文からの自動起動 ＜ rule による Read 指示 ＜ ユーザーの明示起動 ＜ hook による注入・ブロック ＜ hook / workflow のコードが処理自体を行う。

### 5.5 最終確認 2 点（作業指示者の理解）

1. **Plugin 配布の skill には `paths:` を付けない。コンテキスト節約は `SKILL.md` のスリム化と補助ファイル・スクリプト・`workflows/` への外出しで行う** → 合っている。`paths:` が節約するのは説明文 1 行分（数十〜百トークン）だけで、本文は起動時にしか読まれない。手動起動専用なら `disable-model-invocation: true` で説明文ごと消える。補助ファイルは `${CLAUDE_SKILL_DIR}` / `${CLAUDE_PLUGIN_ROOT}` で参照
2. **ディレクトリ単位の規約は入れ子 `CLAUDE.md` に寄せる（部分一致でロードされるためロード漏れリスクが低い）** → 方向は妥当だが根拠は成立しない。発火条件は rule と完全に同じ（同じ修正行、同じ不発条件）。寄せる判断は「スコープの形」で: ディレクトリ形（配下すべて）は入れ子 CLAUDE.md、拡張子・横断形（`**/*.ps1`）は rule。入れ子 CLAUDE.md は配下のどんなファイルでも発火するので発火回数は増える。`claudeMdExcludes` の影響あり。配布はどちらも層 1

### 5.6 rules のリロード

- `/reload-skills` `/reload-plugins` に相当する rules 用コマンドは無い（commands ページ）
- 実測: 途中追加は即発火、発火済みの編集は再注入されない
- 反映手段: `/compact`（ルート CLAUDE.md と `paths:` 無し rule はディスクから再注入、`paths:` 付き rule と入れ子 CLAUDE.md は次に対象を触ったときに再ロード）、`/clear`、再起動
- 確認手段: `/context`、`InstructionsLoaded` hook（`load_reason: compact` で圧縮後の再ロードも区別可）

## 6. メンテナンス仕組みの設計への含意（まとめ）

- 手順の正本は明示起動の skill（`paths:` 無し）に置く。rule は短い注意書きに限定。守らせたい規約は hook で強制
- `InstructionsLoaded` hook（`load_reason: path_glob_match`）のログで「いつの間にか発火しなくなっていた」を事後監査できる
- rules・CLAUDE.md は Plugin に入らない。配布は層 1
- メンテナンス仕組みの確立は独立の活動テーマとして別ブランチで詰める（作業指示者の方針）
