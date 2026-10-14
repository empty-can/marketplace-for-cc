# marketplace-for-cc-test 構成案（レビュー用）

作成: 2026-10-10 / 作成者: Claude（Opus 5.5）と作業指示者の検討結果のまとめ / 状態: 案（未作成）

## 1. 目的と前提

`C:\cc-workspace\marketplace-for-cc-test` を、`marketplace-for-cc`（Claude Code 用 Plugin Marketplace）の Plugin を開発・定期メンテナンスするときのテスト用リポジトリとして新設する。

前提は次のとおり。

- 想定利用者は作業指示者本人だけ。対象は自作 Plugin なので、悪意あるコードへの防御より、再現性と誤操作の防止を重視する
- 環境はネイティブ Windows 11（Git Bash あり）。**WSL2 は使わない**（準備の手間を避けるため）
- Plugin の動作確認は、必ず `claude --plugin-dir` で Plugin を読み込んで行う
- テストは次の順で行う（Fable 5.1 の推奨）
  - **A.** skill-creator によるセッション内レビュー
  - **B.** `claude plugin eval` による回帰 suite の作成（B-1）と実行（B-2）
  - **C.** `claude plugin validate --strict` による構造検証（毎回）
- 既存の証跡（`C:\cc-workspace\marketplace-for-cc-evals\pre-compact\`）を移行する

## 2. 構成判断の根拠（確認済みの事実）

公式 docs はローカルの `C:\cc-workspace\LLMs\official-llms-txts\code.claude.com\docs\llms-full.txt`（2026-10-10 時点）の行番号で示す。

### 2-1. 設定の読み込み範囲

| 事実 | 根拠 |
|---|---|
| `CLAUDE.md` と `CLAUDE.local.md` は、起動ディレクトリと**その上の全階層**から読み込まれる。git リポジトリの境界では止まらない | 30689 行〜 |
| `.claude/rules/` も同じく上の全階層から読み込まれる | 78056 行付近の表（`project` 設定ソース） |
| `.claude/skills/` は、起動ディレクトリから**リポジトリのルートまで**遡って読み込まれる | 44384 行 |
| `.claude/settings.json` と hooks は、起動ディレクトリ直下の `.claude/` からだけ読み込まれる（親へは遡らない） | 78056 行 |
| `claudeMdExcludes` 設定で、特定の `CLAUDE.md` や rules を絶対パスの glob で除外できる。どの設定層にも書け、配列は層をまたいで結合される | 30875 行〜 |

### 2-2. `/cd` コマンド

| 事実 | 根拠 |
|---|---|
| `/cd <path>` はセッションの主作業ディレクトリを移す。**会話は引き継がれる** | 78019 行〜 |
| 移動先の `CLAUDE.md`、project settings、hooks、`.mcp.json`、skills、subagents が適用される（v2.1.246 以降） | 78019 行〜、44384 行 |
| hooks の `${CLAUDE_PROJECT_DIR}` は、セッションを起動したディレクトリのまま変わらない | 78019 行〜 |
| `/cd` 後に auto memory の保存先が切り替わるかは、docs に記載が無い | 未確認 |

### 2-3. `claude plugin eval`

| 事実 | 根拠 |
|---|---|
| `claude plugin eval init` は Plugin ルート（`.claude-plugin/plugin.json` か `SKILL.md` がある場所）でしか実行できない。他の場所では `is not a plugin or skill folder` で止まる | 41557 行 |
| suite の置き場所は Plugin 配下に限られる。`--eval-dir` と manifest の `experimental.evals` は、Plugin 配下の相対パスしか受け付けない（絶対パスや `..` は不可） | 31854 行〜 |
| `claude plugin eval <Plugin のパス>` は、どこからでも実行できる | 31934 行〜 |
| 結果は既定で Plugin 側の `evals/results/<timestamp>/` に書かれる。`--output-dir` で出力先を変えられる | 31983 行 |
| 各 run は一時ホーム・一時作業ディレクトリで `claude -p` として実行される。ユーザー設定・`CLAUDE.md`・memory・他の Plugin は読み込まれない | 32086 行〜 |
| 会話の続きとして試したい場合は、`case.yaml` の `context.history_file` に会話記録（`.jsonl`）を指定できる | 31867 行〜 |
| **Bash か PowerShell を許可したケースは OS サンドボックス内で実行される。サンドボックスが無い環境では実行を拒否する。ネイティブ Windows には無い** | 31962 行、83217 行 |
| セッション限定で Plugin を読み込む起動フラグは `--plugin-dir` と `--plugin-url` の 2 つだけ。Marketplace を起動時に一時追加するフラグは無く、Marketplace の追加は常に永続的な登録になる | 79039〜79040 行 |
| `--plugin-dir` に「Plugin のフォルダ」（`plugins/`）を渡すと、`.claude-plugin/plugin.json` を持つ直下のサブフォルダがすべて読み込まれる（v2.1.265 以降）。Marketplace のルートを渡しても `plugins/` 配下は読み込まれず、エラーも出ない | 79039 行、33632 行 |
| Write と Edit の許可は、サンドボックスを必要としない | 31962 行付近 |

### 2-4. 前回の評価（2026-10-10、pre-compact 0.9.0）での実測

Claude Code v2.1.296、`claude -p`（非対話）で確認した。

- **文中起動は拒否された**: 指示文の途中に `/pre-compact:pre-compact` を書くと、Claude は Skill ツールを呼んだが、`disable-model-invocation` を理由に拒否された。2026-10-11 に作業指示者が対話セッションでも同じ結果を確認（名前空間付き・短い名前とも）。これを受けて pre-compact は `disable-model-invocation` を外し、本文の実行ゲートで自発起動を抑える方式に変更した（commit は `git log plugins/pre-compact` 参照）
- **先頭起動は動いた**: メッセージ先頭に書けば skill 本文が読み込まれた
- **相対パスは失敗の元**: `--plugin-dir` と `autoMemoryDirectory` を相対パスで渡すと、子セッションの作業ディレクトリ基準で解決されて失敗した。Plugin は読み込まれず、memory は `~/.claude/projects/` 配下に書かれた
- **許可リスト外のコマンドは拒否される**: 非対話モードで `--allowedTools` に無いコマンド（pytest など）は、確認なしに拒否された

## 3. 最終フォルダ構成

### 3-1. テスト用リポジトリ

```text
marketplace-for-cc-test/
├── CLAUDE.md                 # A・B を行うセッション向けの指示。テスト環境では除外する
├── README.md                 # 人間向けの説明（目的・手順・命名規約）
├── .gitignore                # work/ を除外する
├── .gitattributes            # marketplace-for-cc と同じ改行方針（*.sh は LF）
├── .claude/
│   └── settings.json         # このリポジトリで作業するときの許可設定
├── config/
│   └── probe-settings.json   # 柵の設定の雛形（memory 保存先・CLAUDE.md 除外・deny ルール）
├── scripts/
│   ├── launch-sandbox.sh     # 手動確認: 使い捨て環境を作り、--plugin-dir 付きで対話起動する
│   ├── run-eval.sh           # B-2: plugin eval を実行し、結果を evidence へ出力する
│   ├── run-probe.sh          # Bash が要る確認を、柵付きの claude -p で実行する
│   └── validate.sh           # C: validate --strict の結果を evidence へ保存する
├── tools/
│   └── probes/               # run-probe.sh が使うフィクスチャ生成・実行・抽出・採点スクリプト
├── evidence/                 # 証跡（コミット対象）
│   └── <plugin>/
│       ├── README.md         # ラウンドの一覧（日付・版・実施したテスト・結論）
│       └── <YYYY-MM-DD>_v<版>/
│           ├── meta.json     # 対象 commit・Claude Code 版・モデル・effort
│           ├── A_skill-creator/   # 報告書・ビューア・集計・採点基準・iteration-N の生データ
│           ├── B_plugin-eval/     # aggregate-result.json・report.html
│           ├── C_validate/        # validate の出力
│           └── manual/            # 手動確認と run-probe.sh の結果
└── work/                     # git 管理外。使い捨ての作業領域
    └── <plugin>/
        ├── skill-creator/<ラウンド>/   # A の作業領域（iteration-N）
        ├── sandbox/<日付>_<名前>/
        │   ├── repo/         # 手動確認用のリポジトリ（git init 済み・リモートなし）
        │   └── memory/       # このテスト専用の auto memory
        └── probes/<日時>_<ケース>/run-<k>/
            ├── repo/
            └── memory/
```

### 3-2. marketplace-for-cc 側（suite の置き場所）

```text
marketplace-for-cc/plugins/<plugin>/
└── evals/                    # B-1 の成果。Plugin と一緒にバージョン管理する
    ├── <case>/...
    └── results/              # 既定の出力先。run-eval.sh は使わないが、念のため .gitignore に入れる
```

## 4. 構成を採用した理由

1. **証跡をラウンド単位にした**: 1 回の開発やメンテナンスで行った A・B・C・手動確認を 1 つのディレクトリにまとめる。どの版でどのテストを通したかが一目で分かる。A の中は skill-creator の `iteration-N` 構成を保ち、前回ラウンドとの比較表示（`generate_review.py --previous-workspace`）を使えるようにする。
2. **作業領域（`work/`）と証跡（`evidence/`）を分けた**: 作業中のデータは入れ子の `.git` を含み、そのままコミットすると入れ子のリポジトリになる。作業は `work/` で行い、要点だけを `evidence/` へコピーする。
3. **直下に `CLAUDE.md` を置き、テスト環境からは除外する**: A・B を行うセッションには、作業領域や命名規約の指示を与えたい。一方、`CLAUDE.md` は上の全階層から読み込まれるので、そのままではテスト環境に混入する（2-1）。そこで、テスト環境を起動するスクリプトが `claudeMdExcludes` で直下の `CLAUDE.md` を除外する。
4. **テスト環境ごとに `git init` する**: skill の探索がリポジトリのルートで止まるので、テスト用リポジトリの `.claude/skills/` が混入しない（2-1）。skill が使う `git status` もテスト環境だけを見る。リモートを設定しないので、誤って push されることもない。
5. **memory をテスト環境のリポジトリの外に置く**: リポジトリ内に置くと、未追跡ファイルとして `git status` に現れ、未コミット変更の判定を汚す。`repo/` と並ぶ `memory/` に置けば、テスト環境を消すだけで後片付けが終わり、ユーザーの `~/.claude/projects/` も汚れない。
6. **`.claude/settings.json` は直下に置いてよい**: 起動ディレクトリ直下からしか読み込まれないので、テスト環境には効かない（2-1）。
7. **suite は Plugin 側に置く**: 公式の制約で Plugin 配下にしか置けない（2-3）。代わりに、結果だけを `--output-dir` でテスト用リポジトリへ出す。
8. **WSL2 を使わない代わりに、B と probe で役割を分ける**: B で Bash を許可するとネイティブ Windows では拒否される（2-3）。B は Bash を使わないケース（判断・出力の質）に限り、Bash が要る確認（`git status` に依存する動作など）は `run-probe.sh` の柵付き `claude -p` で行う。B の一時ホームによる隔離は Bash を許可しなくても働くので、再現性は保てる。
9. **自作ハーネスは `tools/probes/` に格下げする**: 隔離・ベースライン比較・会話の再現は B が公式に提供する。自作ハーネスは、B で測れない単発の確認（文中起動の可否、memory への書き込み、Bash 依存の動作）に絞る。

## 5. テストの流れ

| 段階 | 実行場所 | 方法 |
|---|---|---|
| A | テスト用リポジトリ直下で起動した対話セッション | `/skill-creator:skill-creator` を実行する。作業領域は `work/<plugin>/skill-creator/<ラウンド>/`。各 run は run-probe.sh と同じ柵付き `claude -p` で実行する |
| B-1 | 同じセッションのまま `/cd` で Plugin ルートへ移動 | Claude に `claude plugin eval init` の実行を頼む。A の所見を踏まえて suite を設計できる。終わったら `/cd` で戻る |
| B-2 | シェル（セッション不要） | `scripts/run-eval.sh` |
| C | シェル | `scripts/validate.sh` |
| 手動確認 | 毎回新しい対話セッション | `scripts/launch-sandbox.sh` |
| Bash 依存の確認 | シェル | `scripts/run-probe.sh` |

`/cd` の注意点:

- `/cd` で Plugin ルートへ移ると、marketplace-for-cc 側の `CLAUDE.md` と `.claude/skills/`（旧版の pre-compact を含む）も読み込まれる。suite の作成には支障ないが、そのセッションで skill の挙動を確かめてはいけない
- `/cd` は会話を引き継ぐので、まっさらなセッションでの挙動確認には使えない。手動確認は毎回 `launch-sandbox.sh` で新しいセッションを起動する
- `/cd` では auto memory の保存先が切り替わらない（2026-10-11 実測、v2.1.296）。システムが Claude に案内する memory のパスは移動前のまま残り、Claude が移動先のパスを自分で組み立てて書くこともあるため、書き込み先が不定になる。セッションの記録自体は移動先のプロジェクト保存領域へ移る。`/cd` したセッションでは memory に依存する作業（pre-compact の実行など）を行わない

## 6. 各スクリプトの説明

すべて Git Bash で動く bash スクリプトとし、改行は LF にする。パスは内部で絶対パスに展開してから Claude Code に渡す（2-4 の失敗への対策）。marketplace-for-cc の場所は環境変数 `MARKETPLACE_DIR` で上書きでき、既定は `C:/cc-workspace/marketplace-for-cc`。

### 6-1. `scripts/launch-sandbox.sh`（手動確認）

```text
scripts/launch-sandbox.sh <plugin> <name> [--fixture <dir>]
```

1. `work/<plugin>/sandbox/<YYYY-MM-DD>_<name>/` を作る。既にあれば止まる
2. `repo/` を作って `git init` し、リポジトリ内だけの `user.name` と `user.email` を設定する。リモートは設定しない
3. `--fixture` があれば、その中身を `repo/` にコピーする
4. 次の形で対話セッションを起動する

```bash
claude --plugin-dir "<MARKETPLACE_DIR>/plugins/<plugin>" \
  --settings '{"autoMemoryDirectory":"<絶対パス>/memory","claudeMdExcludes":["<テスト用リポジトリの絶対パス>/CLAUDE.md"]}'
```

5. 終了後、後片付けの方法（ディレクトリを消すだけ）を表示する

読み込む Plugin の指定について:

- 既定は `plugins/<plugin>` の **単体指定**にする。テスト対象以外の Plugin を読み込むと挙動の切り分けができず、hook を持つ Plugin は起動のたびにテスト環境の外へ書き込む（statusline の SessionStart hook は `statusline.sh` をユーザー環境の Plugin データディレクトリへコピーする）
- 複数の Plugin の共存を確かめるときだけ、`--all` のようなオプションで `plugins/` を渡す。`.claude-plugin/plugin.json` を持つサブフォルダがすべて読み込まれる（v2.1.265 以降）
- Marketplace のルート（`marketplace-for-cc`）は渡さない。`plugins/` 配下が読み込まれず、エラーも出ない（2-3）
- Marketplace 経由（`claude plugin marketplace add <ローカルパス>` → `install`）は挙動テストには使わない。ユーザー設定に `empty-can` が永続登録され、後で GitHub 版を追加するときに名前が衝突する。リリース前の導線検証に 1 回だけ使い、終わったら `claude plugin marketplace remove empty-can` で外す

### 6-2. `scripts/run-eval.sh`（B-2）

```text
scripts/run-eval.sh <plugin> <ラウンド> [追加オプション...]
```

1. 実行対象を `<MARKETPLACE_DIR>/plugins/<plugin>`（絶対パス）にする
2. 出力先を `evidence/<plugin>/<ラウンド>/B_plugin-eval/<timestamp>/` にする（`--output-dir`）
3. 既定で `--no-publish`、`--model` と `--judge-model` の固定（環境変数で変更可）、`--max-cost-usd` の上限を付ける
4. 追加オプションの `--allow-tools` に Bash か PowerShell が含まれていたら、実行せずに止まる（ネイティブ Windows では全ケースが拒否され、採点 0 になるため）
5. 結果の要約（`aggregate-result.json` の主要値）を表示する

### 6-3. `scripts/run-probe.sh`（Bash が要る確認）

```text
scripts/run-probe.sh <plugin> <case> <ラウンド> [--runs N] [--baseline]
```

1. `tools/probes/` のフィクスチャ生成で、`work/<plugin>/probes/<日時>_<case>/run-<k>/` に `repo/`（git init 済み）と `memory/` を作る
2. `config/probe-settings.json` の雛形に絶対パスを埋めて、`--settings` に渡す
3. `claude -p --output-format stream-json --verbose` で実行する。`--plugin-dir` は `--baseline` のときだけ外す。`--allowedTools` はケース定義の許可リスト（読み取り系の git コマンドなど）だけにする
4. ツール呼び出しの合間のテキストも含めて記録し、抽出・採点する
5. 要点（最終応答・途中テキスト・memory の差分・git の状態・採点）を `evidence/<plugin>/<ラウンド>/manual/<case>/` にコピーする。`repo/` の `.git` はコピーしない

柵の構成:

| 柵 | 方法 | 防げること |
|---|---|---|
| 使い捨ての作業場所 | run ごとに `work/` 配下へ作る | 本物のファイルへの書き込み |
| 独立した git | run ごとに `git init`。リモートなし | push 事故・上位の skill 探索・memory の共有 |
| memory の隔離 | `autoMemoryDirectory` を run ディレクトリ内に向ける | `~/.claude/projects/` の汚染 |
| コマンドの許可リスト | `--allowedTools` を読み取り系の git だけにする | 任意コマンドの実行 |
| 拒否ルール | `permissions.deny` で marketplace-for-cc と `~/.claude` への Edit・Write を拒否する | 許可漏れがあった場合の最後の防御 |

OS サンドボックスと違い、Bash コマンドの読み取り範囲とネットワークは制限できない。許可するのが読み取り系の git コマンドだけなら実害は無いと判断している。

### 6-4. `scripts/validate.sh`（C）

```text
scripts/validate.sh <plugin> <ラウンド>
```

1. `claude plugin validate --strict <MARKETPLACE_DIR>/plugins/<plugin>` を実行する
2. `claude plugin validate --strict <MARKETPLACE_DIR>` を実行する（Marketplace 全体）
3. 両方の出力に、Claude Code の版と marketplace-for-cc の commit を添えて `evidence/<plugin>/<ラウンド>/C_validate/validate.txt` に保存する
4. どちらかが失敗したら終了コード 1 で終わる

### 6-5. `config/probe-settings.json`（雛形）

```json
{
  "autoMemoryDirectory": "{{MEMORY_DIR}}",
  "claudeMdExcludes": ["{{TEST_REPO}}/CLAUDE.md"],
  "permissions": {
    "deny": [
      "Edit(//{{MARKETPLACE_DIR}}/**)",
      "Write(//{{MARKETPLACE_DIR}}/**)",
      "Edit(~/.claude/**)",
      "Write(~/.claude/**)",
      "Bash(git push *)",
      "Bash(git remote *)"
    ]
  }
}
```

`{{...}}` は run-probe.sh が絶対パスに置き換える。

### 6-6. `tools/probes/`

前回の評価で使ったスクリプト（`build_fixtures.py`・`run_one.py`・`run_all.py`・`extract.py`・`grade.py`）を移し、Plugin ごとのフィクスチャ定義と共通部分に分ける。Python は `-I` オプション付きで実行する。

## 7. 既存データの移行

| 移行元 | 移行先 |
|---|---|
| `marketplace-for-cc-evals\pre-compact\iteration-1\` の報告書・ビューア・集計・採点基準 | `evidence/pre-compact/2026-10-10_v0.9.0/A_skill-creator/` |
| 前回 A の生データ（`marketplace-for-cc-evals\pre-compact\raw-2026-10-10\workspace\iteration-1\`） | 同上の `iteration-1/` |
| 文中起動が拒否された記録（`raw-2026-10-10\probe\midmsg.jsonl`） | `evidence/pre-compact/2026-10-10_v0.9.0/manual/` |
| 自作ハーネス（`raw-2026-10-10\tools\*.py`） | `tools/probes/` |
| フィクスチャ・事前確認の記録・skill のスナップショット | 移さない。フィクスチャは生成スクリプトで作り直せる。スナップショットは marketplace-for-cc の commit `4733d90` を `meta.json` に記録して代える |

前回の生データは、前セッションの一時領域から `C:\cc-workspace\marketplace-for-cc-evals\pre-compact\raw-2026-10-10\` に退避済み（2026-10-10）。各 run の `sandbox/` とフィクスチャは除外したので、入れ子の `.git` は含まない。事前確認の記録（`workspace\preflight\`）と skill のスナップショット（`workspace\skill-snapshot\`）も退避先にはあるが、移行はしない。

## 8. 未確認事項（レビューで見てほしい点）

1. **`evals/` が Plugin と一緒に配布される**: インストール時は Plugin ディレクトリごとキャッシュへコピーされるので、suite も利用者に届く。公式に除外する手段があるかは未確認。害は小さいと見ているが、妥当か
2. **Windows での拒否ルールのパス表記**: `permissions.deny` の絶対パス（`//C:/...` か `//c/...` か）の正しい書き方は未検証
3. **`--settings` の `claudeMdExcludes` が上位の `CLAUDE.md` に効くか**: docs 上は効くはずだが、実測していない
4. **`/cd` 後の auto memory の保存先**: docs に記載が無い
5. **文中起動の対話セッションでの挙動**: 作業指示者が確認予定。結果次第で pre-compact の README・CHANGELOG・SKILL.md の「起動方法」節を直す
6. **B で memory への書き込みを採点できるか**: B の run では memory が一時ホーム側に書かれると見られ、grader から見えるかは未確認。見えなければ memory の確認は probe 側に残す
7. **ラウンド名の版**: リリース前（version を上げる前）のテストは、どの版を名前に使うか。案はテスト対象 commit の `plugin.json` の版（必要ならプレリリース表記）
8. **A の実行方法の二重化**: A の各 run を run-probe.sh と同じ柵付き `claude -p` で行う案にしている。skill-creator 同梱のスクリプトとの役割分担として妥当か
9. **全体として過剰ではないか**: 想定利用者は作業指示者本人だけ。スクリプト 4 本と柵 5 層は、運用コストに見合うか
