# p2-mapping: 公式資産の棚卸し（対応づけ）— 草稿（P2-M、Opus）。Fable の検証前

## 0. 記録

- `claude --version`: `2.1.296 (Claude Code)` / 取得時刻: 2026-10-13 03:38:43 +0900（作業開始）
- **草稿（P2-M、Opus）。Fable の検証前**。本書の「採用するか」はすべて仮判定で、作業指示者の承認ではない。設計書・survey・p2-merged は編集していない
- 抽出条件: p2-merged.jsonl（3,191 行）から status=candidate かつ authority∈{L1, L2} かつ scope_verdict=in。**141 件 = 資産 35 件（2 節）+ 情報源 106 件（4 節）**。E1-5 の 9 行（3 節）は既存の merged_id（P2-R-1230〜1233、1357〜1361。現状は boundary / unverified）を使い、P2-M が GitHub の木で存在を確かめた。判定の変更は Fable
- 境界（7 節）: authority∈{L1, L2} かつ kind=asset かつ scope_verdict=boundary の 164 件（status を問わない）に、anthropic-skills の出所未判定 8 件の行 P2-R-3137（authority=out）を足した 165 件
- 数え方: **対応づけ N = 2 節 35 + 3 節 9 = 44 件**。判定は「採用（既採用）」= 設計書 v3.3 で既に使う手法の実体、「採用」= 本書で新たに使うと判断したもの、「条件付き」、「不採用」、「不採用（複製）」= 同じ資産の別行（木の集約行・cache）で、判断は元の行に従う。E6 のセル埋め率 = 資産ありのセル / 27
- 生成値: 資産の表 35 行（{'採用（既採用）': 3, '採用': 8, '条件付き': 9, '不採用': 5, '不採用（複製）': 10}）、3 節 9 行（{'条件付き': 5, '不採用': 4}）、情報源 106 件、境界 165 件（区分別 {'OP': 22, 'CA': 5, 'GT': 4, 'DIR': 2, 'L2M': 1, 'BI': 4, 'AS': 3, 'SC': 1, 'SUP': 2, 'MOD': 10, 'CCR': 4, 'SK': 7, 'AGS': 1, 'VM': 29, 'SDK': 23, 'SEC': 8, 'MCP': 4, 'OBS': 2, 'RES': 8, 'R1': 23, 'EDU': 1, 'X': 1}）
- 読了の区分（各行の「読了」列）: 原文既読 / WebFetch 要約のみ / 一覧のみ / 未読（P1・P2 の記録に基づく）。要約しか読んでいないものは引用符で書いていない

## 1. 要約

- **二重発明は無い（survey 2-1 を追認）。** サンドボックスでのヘッドレス実行、証跡の構造、モデルと effort の固定に相当する L1 / L2 の資産は範囲内に無い。部分的な重なりは 3 点: (1) plugin-dev の hook 検査スクリプト（既知・採用済み）、(2) skill-creator の `scripts/run_eval.py` = `claude -p` による発火テストの公式実装（新規。ただし description だけを一時 command で測る）、(3) `claude plugin test` = スクリプト単体テストの公式キット（新規。ただし hooks module を持つ mod が対象で、本 Marketplace の現行 Plugin には当たらない）
- 対応づけ 44 件: 採用 11（うち既採用 3）/ 条件付き 14 / 不採用 19（うち複製 10）
- E6: 資産ありのセル 20 / 27（74%）。確認済みで無し 7（A×配布、probe×開発・テスト、発火×配布、利用実績の観測×3）。利用実績の観測は境界（measure、Analytics API、monitoring-guide）と、行の無い `/skill-doctor` だけ
- 対応先の無い資産 22 件（参照・雛形 20、`claude plugin tag`、feed.xml）。行の追加案を 6 節に出す
- 境界 165 件（D13 の材料）。設計書 v3.3 への影響 7 件（11 節）

## 2. 資産の表（採用 → 条件付き → 不採用）

「設計書」列は 11 節の項番号。URL は jsonl の値をそのまま出す（ローカルパスを含む）。

| 判定 | ID | 名称 | URL | 権威（根拠） | 権威の対象 | 何を確かめられるか | 確かめられないか・前提 | 採否の根拠 | 手法 / 活動 | 設計書 | 読了 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 採用（既採用） | 0069 | skill-creator (claude-plugins-official) | ~/.claude/plugins/marketplaces/claude-plugins-official/plugins/skill-creator | L1: official の marketplace.json で author.name=Anthropic、./plugins/ 配下 | 参照実装・挙動 | skill の出力と手順・主観的品質（with / without、evals.json、grading、benchmark の平均と標準偏差、ビューア）＝手法 A。scripts/run_eval.py は `claude -p` で description が skill を起動させるかを query ごとに判定し JSON を出す（発火）。run_loop.py・improve_description.py で description の改善ループ | run_eval.py は `<project>/.claude/commands/<name>-skill-<id>.md` に description だけを載せた一時 command を作って測る（run_eval.py 45〜68 行）。Plugin に入った実物の skill、名前空間付きの名前、本文の実行ゲートは測らない。cwd 側の `.claude/` へ書き込む副作用がある。モデルと effort の固定は呼び出し側の責任 | 設計書の手法 A。発火テスト（test-methods 2-6）の比較対象として run_eval.py を新たに評価する | A・発火 / 開発・テスト | 11-1 | ファイル一覧、run_eval.py 先頭 70 行 |
| 採用（既採用） | 0093 | claude plugin eval (options and init subcommand) | claude plugin eval --help | L1: Claude Code 同梱 CLI の --help | 挙動 | evals/ 配下の case.yaml または prompt.md と graders による隔離環境での回帰（出力と手順、Plugin の寄与、モデル起動の発火）。--ablation、--threshold、--runs、--json / --report | 対象 Plugin だけを読む隔離なので、ユーザー設定・hooks・memory・他 Plugin との競合と副作用は測れない（test-methods 1-3）。init は対話の聞き取りで書き込みを伴う（未実行）。HTML レポートは既定で claude.ai へ公開（P1-L の記録） | 設計書の手法 B | B（発火の一部）/ 開発・テスト・配布 | — | 未読（P1-L の --help 記録） |
| 採用（既採用） | 0092 | claude plugin subcommands (15) | claude plugin --help | L1: Claude Code 同梱 CLI の --help | 挙動 | validate（manifest・marketplace・skills / agents / commands の構文とスキーマ）＝C。tag（`{name}--v{version}`。validate、plugin.json と Marketplace エントリの版一致、作業ツリーの clean を確かめてから作る＝.claude/CLAUDE.md の規約）。test（mod の tests/ を実行。3 節）。marketplace / install / enable / list（配布後の導入確認） | validate は skill 本文の質・発火・実行時の挙動を見ない。ルートの validate は skill / agent / hook の中身を検査しない（.claude/CLAUDE.md）。test は hooks module を持つ mod が対象（3 節） | validate は設計書の C（既採用）。tag・test・marketplace / install は本書で新たに対応づけ | C・manual・スクリプト単体（mod のみ） / 開発・テスト・配布 | 11-3、11-4 | 未読（P1-L の --help 記録） |
| 採用 | 0068 | plugin-dev (claude-plugins-official) | ~/.claude/plugins/marketplaces/claude-plugins-official/plugins/plugin-dev | L1: official の marketplace.json で author.name=Anthropic | 参照実装・形式 | hook-development/scripts の test-hook.sh（hook スクリプトにサンプル JSON を stdin で与えて出力を表示。`--create-sample <event>` で PreToolUse 等の入力を生成）、validate-hook-schema.sh、hook-linter.sh。agent-development/scripts/validate-agent.sh、plugin-settings/scripts/validate-settings.sh。agent の plugin-validator・skill-reviewer による静的レビュー。create-plugin の Phase 7 は `--plugin-dir` で人が確かめるチェックリスト（survey 2-3） | モデルを使う挙動テストは持たない。スクリプトは bash 前提で、Windows の Git Bash での動作と依存コマンドは未確認（test-hook.sh は先頭 60 行だけ既読）。mod は対象外 | survey 2-1 の決定どおり、command hook のスクリプト単体テストは自作せずこれを使う | スクリプト単体・C（静的）・manual / 開発・テスト | 11-3 | ファイル一覧、test-hook.sh 先頭 60 行 |
| 採用 | 0101 | anthropics/claude-code CHANGELOG.md (github blob and raw URLs) | https://raw.githubusercontent.com/anthropics/claude-code/refs/heads/main/CHANGELOG.md | L1: org anthropics。URL は claude.exe に埋め込み | 変更履歴 | 版ごとの挙動変化。環境の事実確認（設計書 2 節の F 根拠の再確認）を起動する条件の検出。docs より先に出る | 再現手順は無い。docs と版の記述が食い違う例がある（/skill-doctor: docs は v2.1.252、CHANGELOG の初出は 2.1.261。p2-coverage 7 節 11） | 監視と、環境の事実確認のトリガ。feed.xml（Atom）は同内容（10 節） | 環境の事実確認 / 開発・テスト・配布 | 11-5 | 未読（P1-C の記録） |
| 採用 | 2904 | @anthropic-ai/claude-code | https://www.npmjs.com/package/@anthropic-ai/claude-code | L1: npm スコープ @anthropic-ai、publisher は GitHub Actions | 挙動・参照実装 | 検証に使う Claude Code の版を固定し再現する。dist-tags は stable 2.1.287、latest / next 2.1.296（P2-R の記録）。旧版との差を環境の事実確認で確かめる | Plugin 自体は検査しない。stable と latest の 2 系統があり、利用者の版は一意でない | 版の記録と固定の基準 | 環境の事実確認 / 開発・テスト・配布 | 11-5 | 未読（P2-R の記録） |
| 採用 | 0100 | anthropics/claude-code | https://github.com/anthropics/claude-code | L1: org anthropics（is_verified） | 変更履歴・挙動 | CHANGELOG.md、feed.xml、mods/（同梱 mod のソースと tests）、plugins/（claude-code-plugins Marketplace の Plugin）を 1 か所で監視できる | Claude Code 本体のソースは無い（mods は同梱物の写し） | 監視の起点 | 環境の事実確認 / 開発・テスト・配布 | 11-5 | 一部（mods/ の一覧） |
| 採用 | 1383 | anthropics/claude-plugins-official | https://github.com/anthropics/claude-plugins-official | L1: org anthropics（is_verified）。旧名 claude-plugins-public | 参照実装・ポリシー | Anthropic 所有 Plugin（./plugins/*）の構成・hooks・evals を人の目で比較する | 比較であって合否は出ない。./external_plugins/* は L3 | 参照実装の正本。ローカルの clone が自動更新される | 手法なし（参照） / 開発・配布 | — | 一部（plugin-dev・skill-creator・hookify・security-guidance のファイル一覧） |
| 採用 | 2789 | anthropics/claude-plugins-official :: .claude-plugin/marketplace.json | https://github.com/anthropics/claude-plugins-official/blob/main/.claude-plugin/marketplace.json | L1: marketplace.json の owner.name=Anthropic | 参照実装・ポリシー | 本 Marketplace の marketplace.json の項目（source、author 等）を 315 エントリの公式例と突き合わせる | 合否は validate（C）が出す。予約名なので名前は流用できない | 配布の参照例 | 手法なし（参照） / 配布 | — | 未読（P1-G2 の記録） |
| 採用 | 1336 | agentskills/agentskills | https://github.com/agentskills/agentskills | L2: org agentskills（is_verified。Fable 判定 C-11） | 参照実装・形式 | SKILL.md 形式の正本（specification と docs の原稿）と、参照実装 skills-ref（validate、read-properties、to-prompt）の所在 | skills-ref は README が「デモ用途で本番向きではない」（survey 2-2）。Claude Code 固有の frontmatter は code.claude.com 側が正本 | 形式の正本として参照・監視。skills-ref は境界（7 節） | 手法なし（参照） / 開発 | — | 未読 |
| 採用 | 1380 | anthropics/skills | https://github.com/anthropics/skills | L1: org anthropics（is_verified） | 参照実装・形式 | skill の書き方の実例（skills/ 19 件、template、academy-guide）と、skill だけを束ねる Marketplace（anthropic-agent-skills）の構成。evals/ 7 件を木で観測 | evals/ の中身は未読。spec/ は agentskills.io への誘導（survey 2-2） | 参照実装 | 手法なし（参照） / 開発・配布 | — | 未読（P1-L のファイル名のみ） |
| 条件付き | 0065 | anthropics/skills skills/skill-creator | ~/.claude/plugins/marketplaces/anthropic-agent-skills/skills/skill-creator/SKILL.md | L1: org anthropics の clone | 参照実装・挙動 | 0069 と同じ skill 本体（本体 18 ファイル中 17 が blob 一致、差は LICENSE.txt。p2-merged 5 節） | plugin.json が無く版を追えない。`/skill-creator:skill-creator` として入るのは official 版 | SKILL.md 単体で配るときの参照に限る。正本は 0069（8 節） | A・発火 / 開発・テスト | — | 未読（P2-R の blob 比較） |
| 条件付き | 0102 | anthropics/claude-code-action | https://github.com/anthropics/claude-code-action | L1: org anthropics（is_verified） | 参照実装 | GitHub Actions 上で Claude Code を動かし、`plugins` / `plugin_marketplaces` 入力で Marketplace から Plugin を入れて実行できる。配布後に「Marketplace から入れて起動する」経路の確認になる | action 自体は `claude plugin validate` を実行しない（action.yml の WebFetch 要約）。Linux runner で、作業指示者の Windows 環境・ユーザー設定と条件が違う。API の費用がかかる。本 Marketplace には CI が無い | CI を導入する場合だけ | probe（仮置き） / 配布 | — | WebFetch 要約のみ（action.yml） |
| 条件付き | 0111 | built-in skill plugin-authoring (mods) | (system prompt skill list) | L1: 同梱の組み込み skill（docs の commands 表に記載） | 挙動・参照実装 | mod（hooks module）の作成・変更・デバッグの手引き | 本 Marketplace の Plugin は mod でない。本文は未読 | mod を作る場合だけ | 手法なし（開発） | — | 未読 |
| 条件付き | 1229 | anthropics/claude-code-playground | https://github.com/anthropics/claude-code-playground | L1: org anthropics（is_verified） | 参照実装 | 3 節のサンプル mod（tests/ なし）と、hooks / settings / workflows の置き場（現状は README のみ） | 中身の大半は個人の設定の共有で、README は「推奨ではない」と述べる（WebFetch 要約） | 3 節の各行に従う | 3 節 | — | 一覧と README の WebFetch 要約 |
| 条件付き | 1254 | anthropics/claude-code の mods ディレクトリ（組み込み mod 4 種のソース） | https://github.com/anthropics/claude-code/tree/main/mods | L1: README が「Claude Code に同梱される mod のソース」と宣言。mods/diff の plugin.json は author.name=Anthropic | 参照実装・形式・挙動 | `claude plugin test` と `claude-code/testing` による mod の決定的なテストの実例（3 節） | mod 以外には使えない。early access（3 節） | mod を書く場合の正本 | スクリプト単体（mod のみ） / 開発・テスト | 11-3 | 一覧、README の WebFetch 要約 |
| 条件付き | 2786 | anthropics/claude-code :: .claude-plugin/marketplace.json | https://github.com/anthropics/claude-code/blob/main/.claude-plugin/marketplace.json | L1: marketplace.json の owner.name=Anthropic | 参照実装・ポリシー | 13 Plugin の小規模な Marketplace（claude-code-plugins）の書き方 | 公式 Marketplace と別系統。plugins/ 側の Plugin は境界（P2-R-1255） | 2789 で足りないときの比較例 | 手法なし（参照） / 配布 | — | 未読 |
| 条件付き | 2798 | anthropics/skills :: .claude-plugin/marketplace.json | https://github.com/anthropics/skills/blob/main/.claude-plugin/marketplace.json | L1（C-1: owner.name は社員個人名でも L1） | 参照実装・ポリシー | skill だけを束ねる Marketplace（5 Plugin）の書き方 | 本 Marketplace は skill 以外も含む | skill だけの Plugin を作るときの参照 | 手法なし（参照） / 配布 | — | 未読 |
| 条件付き | 2901 | $schema の受理（plugin.json / marketplace.json / hooks.json） | https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md#21120 | L1: CHANGELOG 2.1.120 の項 | 挙動 | plugin.json / marketplace.json / hooks.json に `$schema` を書いても読み込み時は無視される（docs の項目表）。エディタ補完用のキー | 公式の schema URL は 404（P2-R-0096・0097。残存リスク 1）。SchemaStore 版は out（C-2）。機械可読な L1 の形式定義は無い | 公式 schema が公開されたら採用。それまでは validate が唯一の機械検査 | C（補助） / 開発 | — | 未読 |
| 条件付き | 0064 | anthropics/skills template/SKILL.md | ~/.claude/plugins/marketplaces/anthropic-agent-skills/template/SKILL.md | L1: org anthropics の clone | 形式・参照実装 | 新しい skill の雛形 | plugin-dev の skill-development と役割が重なる | 新規 skill を作るときだけ | 手法なし（開発） | — | 未読 |
| 不採用 | 0063 | anthropics/skills spec/agent-skills-spec.md | ~/.claude/plugins/marketplaces/anthropic-agent-skills/spec/agent-skills-spec.md | L1: org anthropics の clone | 形式 | — | 正本ではない（spec/ は agentskills.io への誘導。survey 2-2） | 正本は https://agentskills.io/specification（P2-R-0382） | 手法なし | — | 未読 |
| 不採用 | 1227 | anthropics/claude-plugins-community | https://github.com/anthropics/claude-plugins-community | L1（C-3: repo は L1、収録エントリは L3） | 参照実装・ポリシー | 提出された Plugin のカタログと、その CI（action.yml 4、evals.json 3 を木で観測） | 収録物は L3。CI の中身は未読 | 提出しない前提。CI の中身を読めば再評価の余地あり | 手法なし | — | 未読 |
| 不採用 | 2799 | anthropics/claude-plugins-community :: .claude-plugin/marketplace.json | https://github.com/anthropics/claude-plugins-community/blob/main/.claude-plugin/marketplace.json | L1: owner.name=Anthropic | 参照実装・ポリシー | 2,284 エントリのカタログ | 1.5 MB。エントリは L3 | 提出しない前提 | 手法なし | — | 未読 |
| 不採用 | 2796 | anthropics/life-sciences :: .claude-plugin/marketplace.json | https://github.com/anthropics/life-sciences/blob/main/.claude-plugin/marketplace.json | L1: owner.name=Anthropic | 参照実装・ポリシー | 業種別 Marketplace（21 Plugin）の例 | repo 側は境界（D13） | 参照例は 2789 で足りる | 手法なし | — | 未読 |
| 不採用 | 1403 | anthropics/claude-code-base-action | https://github.com/anthropics/claude-code-base-action | L1: org anthropics | 参照実装 | claude-code-action の base のミラー | — | 使うなら 0102 | 手法なし | — | 未読 |
| 不採用（複製） | 0085 | cache claude-plugins-official/plugin-dev/f359d43b4060 | ~/.claude/plugins/cache/claude-plugins-official/plugin-dev/f359d43b4060 | L1: 同一資産の別行 | 参照実装・形式 | 0068 と同じ | 0068 と同じ | 判断は P2-R-0068 に従う | 0068 に従う | — | — |
| 不採用（複製） | 0088 | cache claude-plugins-official/skill-creator, 10 version dirs (aggregated) | ~/.claude/plugins/cache/claude-plugins-official/skill-creator | L1: 同一資産の別行 | 参照実装・挙動 | 0069 と同じ | 0069 と同じ | 判断は P2-R-0069 に従う | 0069 に従う | — | — |
| 不採用（複製） | 2800 | anthropics/skills :: 署名ファイル群 | https://github.com/anthropics/skills/tree/main | L1: 同一資産の別行 | 参照実装 | 1380 と同じ | 1380 と同じ | 判断は P2-R-1380 に従う | 1380 に従う | — | — |
| 不採用（複製） | 2801 | anthropics/claude-code :: 署名ファイル群 | https://github.com/anthropics/claude-code/tree/main | L1: 同一資産の別行 | 参照実装・変更履歴 | 0100 と同じ | 0100 と同じ | 判断は P2-R-0100 に従う | 0100 に従う | — | — |
| 不採用（複製） | 2804 | anthropics/claude-plugins-official :: 署名ファイル群 | https://github.com/anthropics/claude-plugins-official/tree/main | L1: 同一資産の別行 | 参照実装・変更履歴 | 1383 と同じ | 1383 と同じ | 判断は P2-R-1383 に従う | 1383 に従う | — | — |
| 不採用（複製） | 2806 | agentskills/agentskills :: 署名ファイル群 | https://github.com/agentskills/agentskills/tree/main | L2: 同一資産の別行 | 参照実装・形式 | 1336 と同じ | 1336 と同じ | 判断は P2-R-1336 に従う | 1336 に従う | — | — |
| 不採用（複製） | 2809 | anthropics/claude-code-action :: 署名ファイル群 | https://github.com/anthropics/claude-code-action/tree/main | L1: 同一資産の別行 | 参照実装 | 0102 と同じ | 0102 と同じ | 判断は P2-R-0102 に従う | 0102 に従う | — | — |
| 不採用（複製） | 2814 | anthropics/claude-plugins-community :: 署名ファイル群 | https://github.com/anthropics/claude-plugins-community/tree/main | L1: 同一資産の別行 | 参照実装 | 1227 と同じ | 1227 と同じ | 判断は P2-R-1227 に従う | 1227 に従う | — | — |
| 不採用（複製） | 2823 | anthropics/claude-code-base-action :: 署名ファイル群 | https://github.com/anthropics/claude-code-base-action/tree/main | L1: 同一資産の別行 | 参照実装 | 1403 と同じ | 1403 と同じ | 判断は P2-R-1403 に従う | 1403 に従う | — | — |
| 不採用（複製） | 2836 | anthropics/claude-code-playground :: 署名ファイル群 | https://github.com/anthropics/claude-code-playground/tree/main | L1: 同一資産の別行 | 参照実装 | 1229 と同じ | 1229 と同じ | 判断は P2-R-1229 に従う | 1229 に従う | — | — |

## 3. 公式のサンプル mod / hook（E1-5。ディレクトリ単位）

親: P2-R-1254（mods/、2 節）と P2-R-1229（claude-code-playground、2 節）。木の確認: `mods/` = README.md、tsconfig.json、agents-md、diff、sec-default、telemetry、types（4 mod とも `.claude-plugin/`、README.md、hooks/、tests/。telemetry は types/ も）。playground の `claude-code/` = README.md、claude-md、hooks、mods、settings、workflows（claude-md は E1-5 の列挙外で、未読）。

**`claude plugin test` で確かめられること（code.claude.com/docs/en/plugins/mods/test.md を原文で既読）**

- 対象: hooks module（`register(on)`）を持つ mod。`*.test.ts` を Plugin ディレクトリのどこにでも置け、`claude-code/testing` の `test` / `expect` / `mock` / `tier` を使う。`test()` が 1 つも無いファイルは失敗
- 方法: テストの `$` が Claude Code の役をし、`$.tool.call`・`$.command.run`・`$.prompt.submit`・`$.session.start`・`$.turn.complete`・`$.classic.*`（settings hook のイベント）を発火して mod の hook に通す。`on` で Claude Code の応答をスタブする。モデル・ストア・ツールは走らず、セッション・サインイン・ネットワークは不要（決定的）
- 道具: `mock.clock`（advance / set / settle / sleep）、`mock.store`、`mock.env`、`mock.session`（v2.1.293 以上）、`$.ui.mount` の press / input / select / find / unmount、`tier('prepend' | 'append' | 'builtin')` と `{ plugins: [...] }` による方針 mod の検査
- CI: テストが失敗すると終了コード 1。mod を読み込めないシェルでは `claude plugin test: hooks modules are turned off` を出して 1
- 記述が無いもの: hooks.json の command 型 hook のシェル実行、skill、agent の検証は test.md に記述が無い。描画テストは木の妥当性だけで、実際の描画は実セッションで見るよう docs が求める。Windows での実行は未実施
- 前提の版の記述（整合は取っていない）: mods/README 原文「Early access: hooks modules load only where function hooks are enabled, and the API these mods are written against may change between releases without notice」（base64 を復号）/ playground の mods/README の要約「2.1.287 以上で既定ロード」

| 判定 | ID | 名称 | URL（jsonl の値。playground の 4 件は実体がディレクトリなので tree が正しい） | 何を確かめられるか | 確かめられないか・前提 | 採否の根拠 | 手法 / 活動 | 読了 |
|---|---|---|---|---|---|---|---|---|
| 条件付き | 1358 | anthropics/claude-code / mods/diff | https://github.com/anthropics/claude-code/tree/main/mods/diff | mod（hooks module）の挙動を決定的に確かめる実例。tests/ に register.test.ts（33 KB）、views.test.ts、git.test.ts、record.test.ts と、ask・backend・classify・git・pane-state・pane-toggle・todos・turns・views・fixtures の各フォルダ。record.test.ts（全文既読）は `tier('builtin')`、`Fixtures.inRepository(on, …)` で git の世界をスタブし、`$.session.start` → `$.command.run` → `world.clock.advance` → `$.tool.call({ tool: 'Bash', … })` と発火して、`telemetry.mark` に記録された行を `expect(…).toEqual([…])` で照合する。README の「What it hooks」表（base64 を部分的に復号）は hook するイベント（session.start、ui.render、command.run、ui.close、ui.scroll、ui.focus、tool.call、prompt.submit）と `$` の呼び出し一覧を表で持つ | command 型 hook・skill・agent は対象外（test.md に記述なし）。early access: hooks module は function hooks が有効な環境でだけ読み込まれ、API は予告なく変わりうる（mods/README 原文。base64 を復号）。この repo の marketplace に載らず、効くのは本体に同梱された写し | mod を書くときの最大の雛形。本 Marketplace の現行 Plugin には当たらない | スクリプト単体（mod のみ） / 開発・テスト | 一覧、record.test.ts 全文、README の base64 を部分的に復号 |
| 条件付き | 1357 | anthropics/claude-code / mods/agents-md | https://github.com/anthropics/claude-code/tree/main/mods/agents-md | 最小の雛形。tests/ は register.test.ts（3.7 KB）と fixtures/ だけ。README の Testing 節が「`tests/` runs under `claude plugin test <this folder>`」と書き、覆う場合（AGENTS.md だけの project は project instruction として読み debug log を 1 行、CLAUDE.md がある project は走査しない、走査の失敗では context をそのまま返す、telemetry の provider を座らせた場合と座らせない場合）を文章で列挙する＝期待項目を README に書く型 | command 型 hook は対象外。中身は WebFetch の要約のみで、test の原文は読めていない | 期待項目の書き方の参照（test-methods M12）。mod を書く場合の最小雛形 | スクリプト単体（mod のみ） / 開発・テスト | 一覧、README と register.test.ts の WebFetch 要約 |
| 条件付き | 1359 | anthropics/claude-code / mods/sec-default | https://github.com/anthropics/claude-code/tree/main/mods/sec-default | managed settings や managed-mcp.json がある機械、Team / Enterprise の組織で最外層に座り、組織の classic hooks、prompt、managed settings、tool policy、権限規則、固定した環境変数を、利用者が入れた Plugin から触れないようにする。自前の方針は足さない（mods/README の表の要約）。tests/ あり | README（25 KB）と tests/ は未読。command hook の Plugin への影響は未確認 | managed 環境での挙動の前提を読む情報源として | 環境の事実確認 / テスト | 一覧のみ |
| 不採用 | 1360 | anthropics/claude-code / mods/telemetry | https://github.com/anthropics/claude-code/tree/main/mods/telemetry | built-in Plugin が `$.telemetry` で一次の分析行を送るための noun | 利用者が入れた Plugin を拒否する。Claude Code の分析が無効なら何も送らない（mods/README の要約） | 本 Marketplace の Plugin からは使えない | — | 一覧のみ |
| 条件付き | 1361 | anthropics/claude-code / mods/types/claude-code.d.ts | https://github.com/anthropics/claude-code/blob/main/mods/types/claude-code.d.ts | mod の hooks と tests を型検査する宣言（`tsc -p mods/tsconfig.json`）。`/plugin-types` が同じ宣言を書く（mods/README の要約） | 516 KB で未読。版ごとに変わる | mod を書く場合だけ | 手法なし（開発） | 一覧のみ（サイズ） |
| 条件付き | 1230 | anthropics/claude-code-playground / claude-code/mods | https://github.com/anthropics/claude-code-playground/blob/main/claude-code/mods | サンプル mod 3 件（blast-radius: 危険な shell コマンドを止めて Proceed / Cancel、replay-theater: 前ターンの編集を 1 diff ずつ、token-weather: context の予報）と `.claude-plugin/`（marketplace 名 claude-code-playground-mods）。導入は `claude --plugin-dir ./<mod>` か、`claude plugin marketplace add ./` → `claude plugin install <mod>@claude-code-playground-mods --scope user`（README の要約。2.1.287 以上で既定ロード） | blast-radius の一覧に tests/ は無い（他 2 件は未確認）。mods/README（claude-code 側）の「function hooks が有効な環境のみ」との整合は取っていない | local marketplace 経由で入れる手順の実例として | 手法なし（参照） / 配布 | 一覧（mods、blast-radius）、README の WebFetch 要約 |
| 不採用 | 1231 | anthropics/claude-code-playground / claude-code/hooks | https://github.com/anthropics/claude-code-playground/blob/main/claude-code/hooks | hook の例の置き場。各 hook はスクリプト、settings.json の断片、README を持つ決まり | 現状は README（517 B）だけで hook の実体は無い。「CLAUDE.md から hook にすべき規則を見つける」が予告のみ（WebFetch 要約） | 中身が無い | — | 一覧、README の WebFetch 要約 |
| 不採用 | 1232 | anthropics/claude-code-playground / claude-code/settings | https://github.com/anthropics/claude-code-playground/blob/main/claude-code/settings | settings.json の例の置き場 | 現状は README（396 B）だけ。README は未読 | 中身が無い | — | 一覧のみ |
| 不採用 | 1233 | anthropics/claude-code-playground / claude-code/workflows | https://github.com/anthropics/claude-code-playground/blob/main/claude-code/workflows | 他のカテゴリを組み合わせた個人の構成の置き場 | 現状は README（385 B）だけ。README は未読 | 中身が無い | — | 一覧のみ |

## 4. 参照すべき情報源（kind=source 106 件。権威の対象タグ別。1 件が複数のタグに属す）

各タグの正本は 9 節。`.md` 付きと無しの URL は別行のまま（p2-merged 7 節の正規化規則）。

**形式（31 件）**

- ローカル: ~/.claude/plugins/marketplaces/anthropic-agent-skills/.claude-plugin/marketplace.json
- agentskills.io: https://agentskills.io/home https://agentskills.io/specification
- claude.com: https://claude.com/docs/plugins/build https://claude.com/docs/skills/how-to https://claude.com/resources/articles/build-plugins-for-claude https://claude.com/resources/articles/claude-code-plugins https://claude.com/resources/articles/complete-guide-to-building-skills-for-claude https://claude.com/resources/articles/skills https://claude.com/resources/guides/the-complete-guide-to-building-skills-for-claude
- code.claude.com: https://code.claude.com/docs/en/hooks.md https://code.claude.com/docs/en/plugin-dependencies https://code.claude.com/docs/en/plugins/components.md https://code.claude.com/docs/en/plugins/create-marketplace https://code.claude.com/docs/en/plugins/dependencies.md https://code.claude.com/docs/en/plugins/manifest-reference https://code.claude.com/docs/en/plugins/manifest-reference.md https://code.claude.com/docs/en/plugins/marketplace-reference https://code.claude.com/docs/en/plugins/marketplace-reference.md https://code.claude.com/docs/en/plugins/mods/api.md https://code.claude.com/docs/en/plugins/mods/reference.md https://code.claude.com/docs/en/plugins/overview https://code.claude.com/docs/en/settings-reference.md https://code.claude.com/docs/en/skills https://code.claude.com/docs/en/skills.md https://code.claude.com/docs/en/statusline.md https://code.claude.com/docs/en/sub-agents https://code.claude.com/docs/en/sub-agents.md
- github.com: https://github.com/agentskills https://github.com/anthropics/skills/tree/main/skills/skill-creator
- www.anthropic.com: https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills

**挙動（58 件）**

- ローカル: ~/.local/share/claude/versions/2.1.296
- agentskills.io: https://agentskills.io/skill-creation/evaluating-skills
- claude.com: https://claude.com/docs/plugins/build https://claude.com/docs/plugins/org-sync https://claude.com/docs/plugins/platform-support https://claude.com/resources/articles/beyond-permission-prompts-making-claude-code-more-secure-and-autonomous https://claude.com/resources/articles/claude-code-mods https://claude.com/resources/articles/how-to-configure-hooks https://claude.com/resources/articles/steering-claude-code-skills-hooks-rules-subagents-and-more https://claude.com/resources/articles/subagents-in-claude-code
- code.claude.com: https://code.claude.com/docs/en/best-practices https://code.claude.com/docs/en/cli-reference.md https://code.claude.com/docs/en/commands.md https://code.claude.com/docs/en/debug-your-config.md https://code.claude.com/docs/en/headless.md https://code.claude.com/docs/en/hooks.md https://code.claude.com/docs/en/plugin-dependencies https://code.claude.com/docs/en/plugin-evals.md https://code.claude.com/docs/en/plugins/cli-reference.md https://code.claude.com/docs/en/plugins/components.md https://code.claude.com/docs/en/plugins/create-marketplace https://code.claude.com/docs/en/plugins/create-marketplace.md https://code.claude.com/docs/en/plugins/create.md https://code.claude.com/docs/en/plugins/dependencies.md https://code.claude.com/docs/en/plugins/host-marketplace.md https://code.claude.com/docs/en/plugins/install.md https://code.claude.com/docs/en/plugins/loading https://code.claude.com/docs/en/plugins/loading.md https://code.claude.com/docs/en/plugins/manifest-reference https://code.claude.com/docs/en/plugins/marketplace-reference https://code.claude.com/docs/en/plugins/mods/api.md https://code.claude.com/docs/en/plugins/mods/create.md https://code.claude.com/docs/en/plugins/mods/events.md https://code.claude.com/docs/en/plugins/mods/overview https://code.claude.com/docs/en/plugins/mods/overview.md https://code.claude.com/docs/en/plugins/mods/reference.md https://code.claude.com/docs/en/plugins/mods/test.md https://code.claude.com/docs/en/plugins/mods/troubleshoot.md https://code.claude.com/docs/en/plugins/org.md https://code.claude.com/docs/en/plugins/overview https://code.claude.com/docs/en/plugins/overview.md https://code.claude.com/docs/en/plugins/publish https://code.claude.com/docs/en/plugins/publish.md https://code.claude.com/docs/en/plugins/security https://code.claude.com/docs/en/plugins/troubleshooting.md https://code.claude.com/docs/en/sandboxing.md https://code.claude.com/docs/en/skills https://code.claude.com/docs/en/skills.md https://code.claude.com/docs/en/statusline https://code.claude.com/docs/en/statusline.md https://code.claude.com/docs/en/sub-agents https://code.claude.com/docs/en/sub-agents.md https://code.claude.com/docs/es/plugins/overview https://code.claude.com/docs/zh-CN/plugins/anthropic-marketplaces
- github.com: https://github.com/anthropics
- www.anthropic.com: https://www.anthropic.com/engineering/claude-code-auto-mode https://www.anthropic.com/engineering/claude-code-sandboxing https://www.anthropic.com/news/enabling-claude-code-to-work-more-autonomously

**ポリシー（15 件）**

- ローカル: ~/.claude/plugins/marketplaces/claude-plugins-official/.claude-plugin/marketplace.json
- claude.com: https://claude.com/docs/build/overview https://claude.com/docs/plugins/org-rollout https://claude.com/docs/plugins/org-sync https://claude.com/docs/plugins/pre-submission-checklist https://claude.com/resources/articles/organization-skills-and-directory
- code.claude.com: https://code.claude.com/docs/en/plugins/anthropic-marketplaces.md https://code.claude.com/docs/en/plugins/host-marketplace.md https://code.claude.com/docs/en/plugins/marketplace-reference.md https://code.claude.com/docs/en/plugins/marketplace-reference.md#reserved-names https://code.claude.com/docs/en/plugins/org.md https://code.claude.com/docs/en/plugins/publish https://code.claude.com/docs/en/plugins/publish.md https://code.claude.com/docs/en/plugins/security https://code.claude.com/docs/zh-CN/plugins/anthropic-marketplaces

**参照実装（50 件）**

- ローカル: ~/.claude/plugins/marketplaces/anthropic-agent-skills/.claude-plugin/marketplace.json ~/.claude/plugins/marketplaces/claude-plugins-official/.claude-plugin/marketplace.json
- agentskills.io: https://agentskills.io/home https://agentskills.io/skill-creation/best-practices https://agentskills.io/skill-creation/evaluating-skills https://agentskills.io/skill-creation/optimizing-descriptions https://agentskills.io/skill-creation/quickstart https://agentskills.io/skill-creation/using-scripts
- claude.com: https://claude.com/docs/build/overview https://claude.com/docs/llms.txt https://claude.com/docs/plugins/platform-support https://claude.com/docs/plugins/quickstart https://claude.com/docs/skills/how-to https://claude.com/marketplace/plugins https://claude.com/resources/articles/build-plugins-for-claude https://claude.com/resources/articles/building-verification-loops-in-claude-code-with-skills https://claude.com/resources/articles/claude-code-mods https://claude.com/resources/articles/claude-code-plugins https://claude.com/resources/articles/complete-guide-to-building-skills-for-claude https://claude.com/resources/articles/extending-claude-capabilities-with-skills-mcp-servers https://claude.com/resources/articles/how-to-configure-hooks https://claude.com/resources/articles/how-to-create-skills-key-steps-limitations-and-examples https://claude.com/resources/articles/improving-skill-creator-test-measure-and-refine-agent-skills https://claude.com/resources/articles/organization-skills-and-directory https://claude.com/resources/articles/skills https://claude.com/resources/articles/skills-explained https://claude.com/resources/articles/steering-claude-code-skills-hooks-rules-subagents-and-more https://claude.com/resources/articles/subagents-in-claude-code https://claude.com/resources/guides/the-complete-guide-to-building-skills-for-claude https://claude.com/resources/guides/the-complete-guide-to-building-skills-for-claude/distribution-and-sharing https://claude.com/resources/guides/the-complete-guide-to-building-skills-for-claude/testing-and-iteration https://claude.com/skills
- code.claude.com: https://code.claude.com/docs/en/best-practices https://code.claude.com/docs/en/claude-directory.md https://code.claude.com/docs/en/commands.md https://code.claude.com/docs/en/features-overview.md https://code.claude.com/docs/en/hooks-guide.md https://code.claude.com/docs/en/plugins/anthropic-marketplaces https://code.claude.com/docs/en/plugins/anthropic-marketplaces.md https://code.claude.com/docs/en/plugins/cli-reference.md https://code.claude.com/docs/en/plugins/create.md https://code.claude.com/docs/en/plugins/mods/overview.md https://code.claude.com/docs/en/plugins/overview https://code.claude.com/docs/en/plugins/overview.md https://code.claude.com/docs/es/plugins/overview
- github.com: https://github.com/anthropics https://github.com/anthropics/skills/tree/main/skills/skill-creator
- platform.claude.com: https://platform.claude.com/llms.txt
- pypi.org: https://pypi.org/org/anthropic/
- www.anthropic.com: https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills

**変更履歴（9 件）**

- claude.com: https://claude.com/resources/articles/improving-skill-creator-test-measure-and-refine-agent-skills https://claude.com/resources/articles/skills
- code.claude.com: https://code.claude.com/docs/en/changelog.md https://code.claude.com/docs/en/whats-new/2026-w37.md
- github.com: https://github.com/anthropics https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md https://github.com/anthropics/claude-code/releases https://github.com/anthropics/claude-code/tags
- www.anthropic.com: https://www.anthropic.com/news/enabling-claude-code-to-work-more-autonomously

## 5. E6 マトリクス（9 手法 × 3 活動）

セルの ID は P2-R- を省略。「資産あり」は scope=in の行だけ。照会 ID: S-1 #n = p1-blog-support.md 3-5 の固定クエリ、G-6 #n = p1-github-content.md の G-6 表（org:anthropics）。

| 手法 | 開発 | テスト | 配布 |
|---|---|---|---|
| C | 資産あり（0092 validate、0068 の validate-hook-schema.sh・validate-agent.sh） | 資産あり（0092） | 資産あり（0092。validate --strict の CI 利用は docs P2-R-1225、tag が validate を内包） |
| B | 資産あり（0093。eval init で suite を作る） | 資産あり（0093） | 資産あり（0093。CI での固定は docs P2-R-0009） |
| A | 資産あり（0069。0065 は同一本体） | 資産あり（0069） | 確認済みで無し（L-2: skill-creator の scripts 一覧を本書で確認。package_skill.py は skill を束ねるもので Plugin の配布ではない（名前からの判断、未読）。G-6 #3・#8a・#8b、S-1 #11） |
| probe | 確認済みで無し（L-3: `claude --help`・`claude plugin --help` にハーネス無し。S-1 #14 は docs の headless だけ。G-6 #10。境界: Agent SDK 1386・2913・2940、claude-trace 2932） | 確認済みで無し（L-3: `claude --help`・`claude plugin --help` にハーネス無し。S-1 #14。G-6 #10） | 資産あり（0102。plugins 入力。仮置き） |
| manual | 資産あり（0068。create-plugin Phase 7 のチェックリスト） | 資産あり（0068） | 資産あり（0092。marketplace add / install。手順の実例は 3 節 1230） |
| 発火テスト | 資産あり（0069。run_eval.py・run_loop.py・improve_description.py） | 資産あり（0069、0093 のモデル起動の発火） | 確認済みで無し（L-1: docs_map の relevance・cli-hints は導入の推薦で skill の発火ではない＝境界 0025・0012。S-1 #11。G-6 #8a・#8b） |
| スクリプト単体 | 資産あり（0068 の test-hook.sh ほか＝command hook。1254 の tests/＝mod のみ） | 資産あり（0068、0092 の test＝mod のみ） | 資産あり（0092 の test は失敗で終了コード 1、CI 可。mod のみ） |
| 環境の事実確認 | 資産あり（0101、2904） | 資産あり（0101、2904） | 資産あり（0101、2904、0100） |
| 利用実績の観測 | 確認済みで無し（範囲内の行なし。L-3 C2: `/skill-doctor` は行が無く P2-R-0032・0112 の notes に記載＝6 節。L-1 docs_map。境界: 0011 measure、1417 monitoring-guide） | 確認済みで無し（範囲内の行なし。L-3 C2、L-1 docs_map。境界: 0011、1417） | 確認済みで無し（W-1 platform.claude.com の llms.txt 絞り込みで 0523 Analytics API が境界。L-1 の 0011 measure も境界） |

## 6. 対応先の無い資産（R8）

**(a) P2-V の候補 7 件の判定**

| 候補 | 判定 | 行 | 提案 |
|---|---|---|---|
| `/skill-doctor` の診断 | 対応先あり（利用実績の観測 × 開発・テスト）、**行の欠落** | 無し（P2-R-0032・0112 の notes だけ） | kind=asset、L1（同梱の組み込みコマンド）の行を追加。docs と CHANGELOG の版記述の食い違い（残存リスク 11）を notes に |
| CI の `claude plugin validate --strict` | 対応先あり（C × 配布） | 0092 に集約、docs は 1225 | 個別行は不要（Fable 判断） |
| `claude plugin tag` の版管理 | **対応先なし**（9 手法はテストで、tag はリリース操作。内部で validate・版一致・clean tree を確かめる） | 0092 に集約 | E6 に「リリース検査」行を足すか、C の評価内容に「tag の検査結果」を加える |
| `claude plugin test`（mods のテストキット） | 対応先あり（スクリプト単体、mod のみ） | 0092、1254（3 節 1357・1358） | 手法の定義に「mod 以外は対象外」を書く（11-3） |
| claude-code の `feed.xml` | **対応先なし**（監視） | 1257（境界・unverified。本書で取得し Atom と確認） | 環境の事実確認の起動条件として扱い、監視（10 節）へ |
| claude-code-action の `plugins` 入力 | 対応先あり（probe × 配布に仮置き） | 0102 | 「配布後の導入確認」行を E6 に足すか Fable 判断 |
| plugins/measure と Analytics API | 対応先あり（利用実績の観測）だが境界 | 0011、0523（境界） | D13 で範囲に入れれば利用実績の観測 × 配布のセルが埋まる |

**(b) 本書の対応づけで手法に乗らなかった資産（参照・雛形・監視。複製行は元の行に従う）**

| 区分 | ID | 提案 |
|---|---|---|
| 形式の正本・雛形 | 0063、0064、1336 | E6 に「参照（手法外）」行を足し、開発の列に置く |
| 参照実装・Marketplace の例 | 1380、1383、2786、2789、2798、2796、2799、1227 | 同上（開発・配布の列） |
| mod の開発用 | 0111、1361 | 同上（開発の列） |
| 中身なし・使えない | 1231、1232、1233、1360 | 行の追加は不要（不採用） |
| その他 | 1229、1230、1403 | 同上（参照）。1403 は不採用 |

件数: (a) の対応先なし 2 + (b) 20 = **22 件**。(b) を数に入れるかは Fable が決める（入れなければ 2 件）。

## 7. 境界の資産（D13 の材料。165 件）

区分ごとに理由をまとめ、資産ごとの事情があるものは「得られるもの」に個別に書いた。P2-R-3137 が P1-L-133 相当（authority=out だが指示により収録）。

| ID | 状態 | 名称 | URL | 境界とされた理由 | 範囲に入れた場合に得られるもの |
|---|---|---|---|---|---|
| 0070 | L1/cand | hookify (claude-plugins-official) | ~/.claude/plugins/marketplaces/claude-plugins-official/plugins/hookify | 開発・テスト用でない機能 Plugin（参照実装） | hook の生成（テストとは無関係。survey 2-3） |
| 0071 | L1/cand | claude-security (claude-plugins-official) | ~/.claude/plugins/marketplaces/claude-plugins-official/plugins/claude-security | 開発・テスト用でない機能 Plugin（参照実装） | 公開前のセキュリティ検査（survey 2-3） |
| 0072 | L1/cand | security-guidance (claude-plugins-official) | ~/.claude/plugins/marketplaces/claude-plugins-official/plugins/security-guidance | 開発・テスト用でない機能 Plugin（参照実装） | pytest による hook の単体テスト（tests/ 5 本）の実例＝スクリプト単体 |
| 0073 | L1/cand | agent-sdk-dev (claude-plugins-official) | ~/.claude/plugins/marketplaces/claude-plugins-official/plugins/agent-sdk-dev | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 0074 | L1/cand | mcp-server-dev (claude-plugins-official) | ~/.claude/plugins/marketplaces/claude-plugins-official/plugins/mcp-server-dev | 開発・テスト用でない機能 Plugin（参照実装） | MCP サーバーを含む Plugin の構築ツール（claude.com/docs build/overview が挙げる 7 つの 1 つ） |
| 0075 | L1/cand | claude-code-setup (claude-plugins-official) | ~/.claude/plugins/marketplaces/claude-plugins-official/plugins/claude-code-setup | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 0076 | L1/cand | claude-md-management (claude-plugins-official) | ~/.claude/plugins/marketplaces/claude-plugins-official/plugins/claude-md-management | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 0078 | L1/cand | example-plugin (unlisted dir in claude-plugins-official/plugins) | ~/.claude/plugins/marketplaces/claude-plugins-official/plugins/example-plugin | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 0079 | L1/cand | Anthropic-authored sample plugins, 18 entries (aggregated) | ~/.claude/plugins/marketplaces/claude-plugins-official/plugins | 開発・テスト用でない機能 Plugin（参照実装） | Anthropic 作のサンプル Plugin 18 件の構成 |
| 1344 | L1/unverified | anthropics/claude-plugins-official / plugins/clangd-lsp | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/clangd-lsp | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 1345 | L1/unverified | anthropics/claude-plugins-official / plugins/csharp-lsp | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/csharp-lsp | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 1346 | L1/unverified | anthropics/claude-plugins-official / plugins/gopls-lsp | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/gopls-lsp | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 1347 | L1/unverified | anthropics/claude-plugins-official / plugins/jdtls-lsp | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/jdtls-lsp | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 1348 | L1/unverified | anthropics/claude-plugins-official / plugins/kotlin-lsp | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/kotlin-lsp | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 1349 | L1/unverified | anthropics/claude-plugins-official / plugins/lua-lsp | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/lua-lsp | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 1350 | L1/unverified | anthropics/claude-plugins-official / plugins/php-lsp | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/php-lsp | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 1351 | L1/unverified | anthropics/claude-plugins-official / plugins/pyright-lsp | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/pyright-lsp | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 1352 | L1/unverified | anthropics/claude-plugins-official / plugins/ruby-lsp | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/ruby-lsp | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 1353 | L1/unverified | anthropics/claude-plugins-official / plugins/rust-analyzer-lsp | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/rust-analyzer-lsp | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 1354 | L1/unverified | anthropics/claude-plugins-official / plugins/swift-lsp | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/swift-lsp | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 1355 | L1/unverified | anthropics/claude-plugins-official / plugins/typescript-lsp | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/typescript-lsp | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 1356 | L1/unverified | anthropics/claude-plugins-official / plugins/commit-commands | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/commit-commands | 開発・テスト用でない機能 Plugin（参照実装） | hooks・agents の実装例 |
| 0082 | L1/cand | cache claude-plugins-official/claude-security/0.12.0 | ~/.claude/plugins/cache/claude-plugins-official/claude-security/0.12.0 | ローカル cache の複製（版の痕跡） | 版ずれの観測のみ（8 節） |
| 0083 | L1/cand | cache anthropic-plugin-directory (claude-security 0.11.0-c447c3207a42,… | ~/.claude/plugins/cache/anthropic-plugin-directory | ローカル cache の複製（版の痕跡） | 版ずれの観測のみ（8 節） |
| 0084 | L1/cand | cache claude-plugins-official/hookify/f359d43b4060 | ~/.claude/plugins/cache/claude-plugins-official/hookify/f359d43b4060 | ローカル cache の複製（版の痕跡） | 版ずれの観測のみ（8 節） |
| 0086 | L1/cand | cache claude-plugins-official/security-guidance/2.0.8 | ~/.claude/plugins/cache/claude-plugins-official/security-guidance/2.0.8 | ローカル cache の複製（版の痕跡） | 版ずれの観測のみ（8 節） |
| 0087 | L1/cand | cache claude-plugins-official/playground/f359d43b4060 | ~/.claude/plugins/cache/claude-plugins-official/playground/f359d43b4060 | ローカル cache の複製（版の痕跡） | 版ずれの観測のみ（8 節） |
| 1259 | L1/unverified | anthropics/claude-plugins-official / plugins/plugin-dev | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/plugin-dev | 範囲内資産の GitHub 側 URL（deep link） | 新しい知見なし（範囲内の行と同一） |
| 1260 | L1/unverified | anthropics/claude-plugins-official / plugins/mcp-server-dev | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/mcp-server-dev | 範囲内資産の GitHub 側 URL（deep link） | 0074 の GitHub 側 |
| 1261 | L1/unverified | anthropics/claude-plugins-official / plugins/skill-creator | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator | 範囲内資産の GitHub 側 URL（deep link） | 新しい知見なし（範囲内の行と同一） |
| 1263 | L1/cand | anthropics/claude-plugins-official / .claude-plugin/ | https://github.com/anthropics/claude-plugins-official/tree/main/.claude-plugin | 範囲内資産の GitHub 側 URL（deep link） | 範囲内 2789 の置き場 |
| 0089 | L1/cand | plugin-directory-cache-v2.json | ~/.claude/plugins/plugin-directory-cache-v2.json | Plugin ディレクトリのキャッシュ（L-2b。主に L3） | ディレクトリ掲載の Anthropic 所有エントリの把握 |
| 0090 | L1/cand | plugin-catalog-cache.json | ~/.claude/plugins/plugin-catalog-cache.json | Plugin ディレクトリのキャッシュ（L-2b。主に L3） | ディレクトリ掲載の Anthropic 所有エントリの把握 |
| 0077 | L2/cand | mcp-apps (claude-plugins-official, object source) | https://github.com/modelcontextprotocol/ext-apps (git-subdir plugins/mcp-apps) | MCP（範囲外の L2）の object source | MCP Apps を含む Plugin を作る場合のみ |
| 0095 | L1/unverified | /help built-in command list (interactive) | (interactive /help) | 組み込みの skill / agent / コマンド（専用の docs ページなし、または対話専用） | 組み込みコマンドの全一覧 |
| 0112 | L1/unverified | built-in agent claude-code-guide | (system prompt agent list) | 組み込みの skill / agent / コマンド（専用の docs ページなし、または対話専用） | eval と /skill-doctor を説明する組み込み agent＝利用実績の観測の入口 |
| 3129 | L1/cand | built-in skills update-config and workflow-authoring | (system prompt skill list) | 組み込みの skill / agent / コマンド（専用の docs ページなし、または対話専用） | 設定変更・Workflow 作成の組み込み skill |
| 3132 | L1/unverified | built-in agent statusline-setup | (system prompt agent list) | 組み込みの skill / agent / コマンド（専用の docs ページなし、または対話専用） | statusline Plugin の比較対象 |
| 3134 | L1/cand | anthropic-skills: のうち anthropics/skills に同名 skill がある 4 件（docx, pdf, p… | (system prompt skill list; local counterpart ~/.claude/plugins/marketplaces/anthropic-agent-skills/skills/<name>) | claude.ai アカウント経由で供給される skill（C3） | document skills の複製（L1） |
| 3135 | L1/cand | anthropic-skills:skill-creator vs skill-creator copies (C3 comparison) | (system prompt skill list) | claude.ai アカウント経由で供給される skill（C3） | skill-creator と同一文（複製） |
| 3137 | out/unverified | anthropic-skills: 同名の L1 資産が無い 8 件（出所未判定） | (system prompt skill list) | claude.ai アカウント経由で供給される skill（C3） | P1-L-133。8 件（built-in-browser ほか）。出所未判定 |
| 0097 | L1/unverified | https://anthropic.com/claude-code/marketplace.schema.json | https://anthropic.com/claude-code/marketplace.schema.json | 公式 schema URL が 404（C-5） | 公開されれば形式の機械可読な正本 |
| 0107 | L1/unverified | support.claude.com/en/articles/* (8 article ids in binary) | https://support.claude.com/en/articles/ | 本体バイナリ内のリンク、API docs（X-4） | 小 |
| 0440 | L1/unverified | platform.claude.com/docs/en/agents-and-tools/mcp-connector | https://platform.claude.com/docs/en/agents-and-tools/mcp-connector | 本体バイナリ内のリンク、API docs（X-4） | 小 |
| 1230 | L1/unverified | anthropics/claude-code-playground / claude-code/mods | https://github.com/anthropics/claude-code-playground/blob/main/claude-code/mods | 既知 repo 内の deep link（unverified） | 3 節を参照（E1-5。P2-M が木で存在を確認） |
| 1231 | L1/unverified | anthropics/claude-code-playground / claude-code/hooks | https://github.com/anthropics/claude-code-playground/blob/main/claude-code/hooks | 既知 repo 内の deep link（unverified） | 3 節を参照（E1-5。P2-M が木で存在を確認） |
| 1232 | L1/unverified | anthropics/claude-code-playground / claude-code/settings | https://github.com/anthropics/claude-code-playground/blob/main/claude-code/settings | 既知 repo 内の deep link（unverified） | 3 節を参照（E1-5。P2-M が木で存在を確認） |
| 1233 | L1/unverified | anthropics/claude-code-playground / claude-code/workflows | https://github.com/anthropics/claude-code-playground/blob/main/claude-code/workflows | 既知 repo 内の deep link（unverified） | 3 節を参照（E1-5。P2-M が木で存在を確認） |
| 1234 | L1/unverified | anthropics/claude-code-playground / _template/PREFLIGHT.md | https://github.com/anthropics/claude-code-playground/blob/main/_template/PREFLIGHT.md | 既知 repo 内の deep link（unverified） | playground の投稿前チェックリスト（未読） |
| 1357 | L1/unverified | anthropics/claude-code / mods/agents-md | https://github.com/anthropics/claude-code/tree/main/mods/agents-md | 既知 repo 内の deep link（unverified） | 3 節を参照（E1-5。P2-M が木で存在を確認） |
| 1358 | L1/unverified | anthropics/claude-code / mods/diff | https://github.com/anthropics/claude-code/tree/main/mods/diff | 既知 repo 内の deep link（unverified） | 3 節を参照（E1-5。P2-M が木で存在を確認） |
| 1359 | L1/unverified | anthropics/claude-code / mods/sec-default | https://github.com/anthropics/claude-code/tree/main/mods/sec-default | 既知 repo 内の deep link（unverified） | 3 節を参照（E1-5。P2-M が木で存在を確認） |
| 1360 | L1/unverified | anthropics/claude-code / mods/telemetry | https://github.com/anthropics/claude-code/tree/main/mods/telemetry | 既知 repo 内の deep link（unverified） | 3 節を参照（E1-5。P2-M が木で存在を確認） |
| 1361 | L1/unverified | anthropics/claude-code / mods/types/claude-code.d.ts | https://github.com/anthropics/claude-code/blob/main/mods/types/claude-code.d.ts | 既知 repo 内の deep link（unverified） | 3 節を参照（E1-5。P2-M が木で存在を確認） |
| 1255 | L1/cand | anthropics/claude-code / plugins/ | https://github.com/anthropics/claude-code/tree/main/plugins | anthropics/claude-code 内の deep link | claude-code-plugins Marketplace の Plugin（旧 plugin-dev 等） |
| 1256 | L1/unverified | anthropics/claude-code / .claude-plugin/ | https://github.com/anthropics/claude-code/tree/main/.claude-plugin | anthropics/claude-code 内の deep link | marketplace.json の置き場（2786 と同じ） |
| 1257 | L1/unverified | anthropics/claude-code / feed.xml | https://github.com/anthropics/claude-code/blob/main/feed.xml | anthropics/claude-code 内の deep link | Atom の changelog（今回取得: title「Claude Code Changelog」、1 版 1 entry、link は CHANGELOG.md）＝監視（10 節） |
| 1258 | L1/unverified | anthropics/claude-code / examples/ | https://github.com/anthropics/claude-code/tree/main/examples | anthropics/claude-code 内の deep link | examples/（未読） |
| 0066 | L1/cand | anthropics/skills skills/academy-guide | ~/.claude/plugins/marketplaces/anthropic-agent-skills/skills/academy-guide | anthropics/skills 内の deep link・集約 | SKILL.md の実例 |
| 0067 | L1/cand | anthropics/skills other 17 example skills (aggregated) | ~/.claude/plugins/marketplaces/anthropic-agent-skills/skills | anthropics/skills 内の deep link・集約 | SKILL.md の実例 |
| 1235 | L1/cand | anthropics/skills / skills/academy-guide（seed: academy-guide 束） | https://github.com/anthropics/skills/tree/main/skills/academy-guide | anthropics/skills 内の deep link・集約 | SKILL.md の実例 |
| 1264 | L1/cand | anthropics/skills / skills | https://github.com/anthropics/skills/tree/main/skills | anthropics/skills 内の deep link・集約 | SKILL.md の実例 |
| 1265 | L1/unverified | anthropics/skills / spec | https://github.com/anthropics/skills/tree/main/spec | anthropics/skills 内の deep link・集約 | 範囲内 0063 の GitHub 側 |
| 1266 | L1/unverified | anthropics/skills / template | https://github.com/anthropics/skills/tree/main/template | anthropics/skills 内の deep link・集約 | 範囲内 0064 の GitHub 側 |
| 1267 | L1/unverified | anthropics/skills / .claude-plugin | https://github.com/anthropics/skills/tree/main/.claude-plugin | anthropics/skills 内の deep link・集約 | 範囲内 2798 の置き場 |
| 1337 | L2/unverified | agentskills/agentskills / skills-ref | https://github.com/agentskills/agentskills/tree/main/skills-ref | agentskills の参照実装 skills-ref（B3: README がデモ用途と明記） | SKILL.md の機械検査（skills-ref validate）＝C の補助（SKILL.md 形式のみ） |
| 1228 | L1/cand | anthropics/knowledge-work-plugins | https://github.com/anthropics/knowledge-work-plugins | 役割別・業種別の Marketplace（D13。C-6 で境界） | claude.com/docs が「ディレクトリに載る役割別 Plugin の実例」として参照（survey 2-2） |
| 1381 | L1/cand | anthropics/financial-services | https://github.com/anthropics/financial-services | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 1385 | L1/cand | anthropics/claude-for-legal | https://github.com/anthropics/claude-for-legal | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 1392 | L1/cand | anthropics/commerce-agents | https://github.com/anthropics/commerce-agents | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 1410 | L1/cand | anthropics/life-sciences | https://github.com/anthropics/life-sciences | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 1411 | L1/cand | anthropics/k12-teacher-skills | https://github.com/anthropics/k12-teacher-skills | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 1414 | L1/cand | anthropics/healthcare | https://github.com/anthropics/healthcare | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 1426 | L1/cand | anthropics/oncall-kit | https://github.com/anthropics/oncall-kit | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 1438 | L1/cand | anthropics/claude-for-financial-advisors | https://github.com/anthropics/claude-for-financial-advisors | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 1442 | L1/cand | anthropics/claude-tag-plugins | https://github.com/anthropics/claude-tag-plugins | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2787 | L1/cand | anthropics/claude-for-financial-advisors :: .claude-plugin/marketplace… | https://github.com/anthropics/claude-for-financial-advisors/blob/main/.claude-plugin/marketplace.json | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2788 | L1/cand | anthropics/claude-for-legal :: .claude-plugin/marketplace.json | https://github.com/anthropics/claude-for-legal/blob/main/.claude-plugin/marketplace.json | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2790 | L1/cand | anthropics/claude-tag-plugins :: .claude-plugin/marketplace.json | https://github.com/anthropics/claude-tag-plugins/blob/main/.claude-plugin/marketplace.json | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2791 | L1/cand | anthropics/commerce-agents :: .claude-plugin/marketplace.json | https://github.com/anthropics/commerce-agents/blob/main/.claude-plugin/marketplace.json | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2792 | L1/cand | anthropics/financial-services :: .claude-plugin/marketplace.json | https://github.com/anthropics/financial-services/blob/main/.claude-plugin/marketplace.json | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2793 | L1/cand | anthropics/healthcare :: .claude-plugin/marketplace.json | https://github.com/anthropics/healthcare/blob/main/.claude-plugin/marketplace.json | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2794 | L1/cand | anthropics/k12-teacher-skills :: .claude-plugin/marketplace.json | https://github.com/anthropics/k12-teacher-skills/blob/main/.claude-plugin/marketplace.json | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2795 | L1/cand | anthropics/knowledge-work-plugins :: .claude-plugin/marketplace.json | https://github.com/anthropics/knowledge-work-plugins/blob/main/.claude-plugin/marketplace.json | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2797 | L1/cand | anthropics/oncall-kit :: .claude-plugin/marketplace.json | https://github.com/anthropics/oncall-kit/blob/main/.claude-plugin/marketplace.json | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2803 | L1/cand | anthropics/financial-services :: 署名ファイル群 | https://github.com/anthropics/financial-services/tree/main | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2805 | L1/cand | anthropics/knowledge-work-plugins :: 署名ファイル群 | https://github.com/anthropics/knowledge-work-plugins/tree/main | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2808 | L1/cand | anthropics/claude-for-legal :: 署名ファイル群 | https://github.com/anthropics/claude-for-legal/tree/main | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2816 | L1/cand | anthropics/commerce-agents :: 署名ファイル群 | https://github.com/anthropics/commerce-agents/tree/main | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2828 | L1/cand | anthropics/life-sciences :: 署名ファイル群 | https://github.com/anthropics/life-sciences/tree/main | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2829 | L1/cand | anthropics/k12-teacher-skills :: 署名ファイル群 | https://github.com/anthropics/k12-teacher-skills/tree/main | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2830 | L1/cand | anthropics/healthcare :: 署名ファイル群 | https://github.com/anthropics/healthcare/tree/main | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2835 | L1/cand | anthropics/oncall-kit :: 署名ファイル群 | https://github.com/anthropics/oncall-kit/tree/main | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2838 | L1/cand | anthropics/claude-for-financial-advisors :: 署名ファイル群 | https://github.com/anthropics/claude-for-financial-advisors/tree/main | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 2839 | L1/cand | anthropics/claude-tag-plugins :: 署名ファイル群 | https://github.com/anthropics/claude-tag-plugins/tree/main | 役割別・業種別の Marketplace（D13。C-6 で境界） | 複数 Plugin を束ねる marketplace.json と Plugin 構成の実例 |
| 1238 | L1/cand | anthropics/claude-quickstarts | https://github.com/anthropics/claude-quickstarts | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 1239 | L1/cand | anthropics/claude-agent-sdk-demos | https://github.com/anthropics/claude-agent-sdk-demos | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 1240 | L1/cand | anthropics/claude-cookbooks | https://github.com/anthropics/claude-cookbooks | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 1386 | L1/cand | anthropics/claude-agent-sdk-python | https://github.com/anthropics/claude-agent-sdk-python | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 1399 | L1/cand | anthropics/claude-agent-sdk-typescript | https://github.com/anthropics/claude-agent-sdk-typescript | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 1402 | L1/cand | anthropics/launch-your-agent | https://github.com/anthropics/launch-your-agent | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 1406 | L1/cand | anthropics/code-migration-kit-with-claude-code | https://github.com/anthropics/code-migration-kit-with-claude-code | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 1407 | L1/cand | anthropics/cwc-long-running-agents | https://github.com/anthropics/cwc-long-running-agents | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 1433 | L1/cand | anthropics/agent-sdk-workshop | https://github.com/anthropics/agent-sdk-workshop | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 2802 | L1/cand | anthropics/claude-cookbooks :: 署名ファイル（再走査 1） | https://github.com/anthropics/claude-cookbooks/tree/main | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 2807 | L1/cand | anthropics/claude-quickstarts :: 署名ファイル（再走査 1） | https://github.com/anthropics/claude-quickstarts/tree/main | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 2810 | L1/cand | anthropics/claude-agent-sdk-python :: 署名ファイル群 | https://github.com/anthropics/claude-agent-sdk-python/tree/main | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 2817 | L1/cand | anthropics/claude-agent-sdk-demos :: 署名ファイル群 | https://github.com/anthropics/claude-agent-sdk-demos/tree/main | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 2818 | L1/cand | anthropics/cwc-workshops :: 署名ファイル（再走査 1） | https://github.com/anthropics/cwc-workshops/tree/main | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 2820 | L1/cand | anthropics/claude-agent-sdk-typescript :: 署名ファイル群 | https://github.com/anthropics/claude-agent-sdk-typescript/tree/main | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 2822 | L1/cand | anthropics/launch-your-agent :: 署名ファイル群 | https://github.com/anthropics/launch-your-agent/tree/main | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 2825 | L1/cand | anthropics/code-migration-kit-with-claude-code :: 署名ファイル群 | https://github.com/anthropics/code-migration-kit-with-claude-code/tree/main | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 2826 | L1/cand | anthropics/cwc-long-running-agents :: 署名ファイル群 | https://github.com/anthropics/cwc-long-running-agents/tree/main | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 2837 | L1/cand | anthropics/agent-sdk-workshop :: 署名ファイル群 | https://github.com/anthropics/agent-sdk-workshop/tree/main | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 2913 | L1/cand | @anthropic-ai/claude-agent-sdk | https://www.npmjs.com/package/@anthropic-ai/claude-agent-sdk | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 2940 | L1/cand | claude-agent-sdk | https://pypi.org/project/claude-agent-sdk/ | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 2942 | L1/cand | claude-code-sdk | https://pypi.org/project/claude-code-sdk/ | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | deprecated（claude-agent-sdk へ移行） |
| 3215 | L1/cand | claude-agent-sdk-python の examples/streaming_mode.py（commit c4384ea 時点… | https://github.com/anthropics/claude-agent-sdk-python/blob/c4384ead710e2c264f13524ce63a985a31b43e3c/examples/streaming_mode.py | Agent SDK・デモ・教材（Plugin 開発の資産ではない） | Agent SDK で Claude Code を自動実行する方式＝probe ハーネスの代替候補（11-2） |
| 1387 | L1/cand | anthropics/defending-code-reference-harness | https://github.com/anthropics/defending-code-reference-harness | セキュリティ・隔離の基盤（sandbox-runtime・devcontainer-features は D13） | probe の隔離手段の候補 |
| 1388 | L1/cand | anthropics/claude-code-security-review | https://github.com/anthropics/claude-code-security-review | セキュリティ・隔離の基盤（sandbox-runtime・devcontainer-features は D13） | PR 時のセキュリティレビュー Action |
| 1389 | L1/cand | anthropics/sandbox-runtime | https://github.com/anthropics/sandbox-runtime | セキュリティ・隔離の基盤（sandbox-runtime・devcontainer-features は D13） | sandbox-runtime（D13）。probe の隔離手段の候補 |
| 1422 | L1/cand | anthropics/devcontainer-features | https://github.com/anthropics/devcontainer-features | セキュリティ・隔離の基盤（sandbox-runtime・devcontainer-features は D13） | devcontainer-features（D13）。隔離環境の候補 |
| 2811 | L1/cand | anthropics/defending-code-reference-harness :: 署名ファイル群 | https://github.com/anthropics/defending-code-reference-harness/tree/main | セキュリティ・隔離の基盤（sandbox-runtime・devcontainer-features は D13） | probe の隔離手段の候補 |
| 2812 | L1/cand | anthropics/claude-code-security-review :: 署名ファイル群 | https://github.com/anthropics/claude-code-security-review/tree/main | セキュリティ・隔離の基盤（sandbox-runtime・devcontainer-features は D13） | probe の隔離手段の候補 |
| 2813 | L1/cand | anthropics/sandbox-runtime :: 署名ファイル群 | https://github.com/anthropics/sandbox-runtime/tree/main | セキュリティ・隔離の基盤（sandbox-runtime・devcontainer-features は D13） | probe の隔離手段の候補 |
| 2931 | L1/cand | @anthropic-ai/sandbox-runtime | https://www.npmjs.com/package/@anthropic-ai/sandbox-runtime | セキュリティ・隔離の基盤（sandbox-runtime・devcontainer-features は D13） | sandbox-runtime の npm 版 |
| 1339 | L1/unverified | anthropics/claude-ai-mcp | https://github.com/anthropics/claude-ai-mcp/issues | MCP 関連（範囲外の話題） | 小（MCP を含む Plugin の場合のみ） |
| 1412 | L1/cand | anthropics/claude-ai-mcp | https://github.com/anthropics/claude-ai-mcp | MCP 関連（範囲外の話題） | 小（MCP を含む Plugin の場合のみ） |
| 1434 | L1/cand | anthropics/github-mcp-server | https://github.com/anthropics/github-mcp-server | MCP 関連（範囲外の話題） | fork（parent github/github-mcp-server。異議あり） |
| 2930 | L1/cand | @anthropic-ai/mcpb | https://www.npmjs.com/package/@anthropic-ai/mcpb | MCP 関連（範囲外の話題） | MCP バンドル形式 |
| 1417 | L1/cand | anthropics/claude-code-monitoring-guide | https://github.com/anthropics/claude-code-monitoring-guide | 監視・記録の道具（Plugin 開発専用ではない） | OpenTelemetry による利用状況の観測＝利用実績の観測（E6 の空セル） |
| 2932 | L1/cand | @anthropic-ai/claude-trace | https://www.npmjs.com/package/@anthropic-ai/claude-trace | 監視・記録の道具（Plugin 開発専用ではない） | Claude Code のセッション記録＝probe の記録の補助（未読） |
| 2875 | L1/unverified | 予約 Marketplace 名: claude-code-marketplace | （URL なし） | 予約 Marketplace 名で公開の実体なし・文字列のみ（E4-1） | 無し（名前の衝突回避の確認のみ） |
| 3138 | L1/unverified | 予約 Marketplace 名: anthropic-marketplace | （URL なし） | 予約 Marketplace 名で公開の実体なし・文字列のみ（E4-1） | 無し（名前の衝突回避の確認のみ） |
| 3139 | L1/unverified | 予約 Marketplace 名: anthropic-plugins | （URL なし） | 予約 Marketplace 名で公開の実体なし・文字列のみ（E4-1） | 無し（名前の衝突回避の確認のみ） |
| 3140 | L1/unverified | 予約 Marketplace 名: agent-skills | （URL なし） | 予約 Marketplace 名で公開の実体なし・文字列のみ（E4-1） | 無し（名前の衝突回避の確認のみ） |
| 3141 | L1/unverified | 予約 Marketplace 名: financial-services-plugins | （URL なし） | 予約 Marketplace 名で公開の実体なし・文字列のみ（E4-1） | 無し（名前の衝突回避の確認のみ） |
| 3142 | L1/unverified | 予約 Marketplace 名: first-party-plugins | （URL なし） | 予約 Marketplace 名で公開の実体なし・文字列のみ（E4-1） | 無し（名前の衝突回避の確認のみ） |
| 3143 | L1/unverified | 予約 Marketplace 名: anthropic-plugin-directory | （URL なし） | 予約 Marketplace 名で公開の実体なし・文字列のみ（E4-1） | 無し（名前の衝突回避の確認のみ） |
| 3144 | L1/unverified | 予約 Marketplace 名: claude-plugin-directory | （URL なし） | 予約 Marketplace 名で公開の実体なし・文字列のみ（E4-1） | 無し（名前の衝突回避の確認のみ） |
| 2815 | L1/cand | anthropics/anthropic-sdk-python :: 署名ファイル（再走査 1） | https://github.com/anthropics/anthropic-sdk-python/tree/main | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 2819 | L1/cand | anthropics/anthropic-sdk-typescript :: 署名ファイル（再走査 1） | https://github.com/anthropics/anthropic-sdk-typescript/tree/main | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 2821 | L1/cand | anthropics/anthropic-sdk-go :: 署名ファイル（再走査 1） | https://github.com/anthropics/anthropic-sdk-go/tree/main | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 2824 | L1/cand | anthropics/buffa :: 署名ファイル（再走査 1） | https://github.com/anthropics/buffa/tree/main | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 2827 | L1/cand | anthropics/anthropic-cli :: 署名ファイル（再走査 1） | https://github.com/anthropics/anthropic-cli/tree/main | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 2831 | L1/cand | anthropics/anthropic-sdk-java :: 署名ファイル（再走査 1） | https://github.com/anthropics/anthropic-sdk-java/tree/main | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 2832 | L1/cand | anthropics/anthropic-sdk-ruby :: 署名ファイル（再走査 1） | https://github.com/anthropics/anthropic-sdk-ruby/tree/main | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 2833 | L1/cand | anthropics/anthropic-sdk-csharp :: 署名ファイル（再走査 1） | https://github.com/anthropics/anthropic-sdk-csharp/tree/main | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 2834 | L1/cand | anthropics/ClaudeForFoundationModels :: 署名ファイル（再走査 1） | https://github.com/anthropics/ClaudeForFoundationModels/tree/main | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 2889 | L1/cand | anthropics/uplifting-biomolecular-modeling :: 署名ファイル（再走査 1） | https://github.com/anthropics/uplifting-biomolecular-modeling/tree/main | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 2893 | L1/cand | anthropics/serde-saphyr :: 署名ファイル（再走査 1） | https://github.com/anthropics/serde-saphyr/tree/master | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 3145 | L1/cand | anthropics/anthropic-sdk-php :: 署名ファイル（再走査 1） | https://github.com/anthropics/anthropic-sdk-php/tree/main | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 3146 | L1/cand | anthropics/orjson :: 署名ファイル（再走査 1） | https://github.com/anthropics/orjson/tree/anthropic-3.11.7 | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 3147 | L1/cand | anthropics/rclone :: 署名ファイル（再走査 1） | https://github.com/anthropics/rclone/tree/master | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 3148 | L1/cand | anthropics/s5cmd :: 署名ファイル（再走査 1） | https://github.com/anthropics/s5cmd/tree/master | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 3149 | L1/cand | anthropics/tokio :: 署名ファイル（再走査 1） | https://github.com/anthropics/tokio/tree/anthropic-1.52.3 | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 3150 | L1/cand | anthropics/httpcore :: 署名ファイル（再走査 1） | https://github.com/anthropics/httpcore/tree/anthropic-1.0.9 | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 3151 | L1/cand | anthropics/argo-cd :: 署名ファイル（再走査 1） | https://github.com/anthropics/argo-cd/tree/master | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 3152 | L1/cand | anthropics/torchtyping :: 署名ファイル（再走査 1） | https://github.com/anthropics/torchtyping/tree/anthropic-0.1.5 | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 3153 | L1/cand | anthropics/sse-starlette :: 署名ファイル（再走査 1） | https://github.com/anthropics/sse-starlette/tree/master | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 3154 | L1/cand | anthropics/raft-rs :: 署名ファイル（再走査 1） | https://github.com/anthropics/raft-rs/tree/master | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 3155 | L1/cand | anthropics/leptos-chartistry :: 署名ファイル（再走査 1） | https://github.com/anthropics/leptos-chartistry/tree/master | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 3156 | L1/cand | anthropics/snix :: 署名ファイル（再走査 1） | https://github.com/anthropics/snix/tree/canon | 再走査 1 で署名が見つかった範囲外の話題の repo（fork を含む） | 社内の `.claude/` 設定の実例のみ |
| 1338 | L1/unverified | anthropics/courses | https://github.com/anthropics/courses/tree/master/anthropic_api_fundamentals | 教材（B6） | Plugin を扱う教材は 0（catalog.json の記録） |
| 1341 | L1/excluded | anthropics/sdk-demos | https://github.com/anthropics/sdk-demos/issues | 404（E2-F） | 無し |

## 8. 複製と版ずれ（p2-merged 5 節の 2 件）

| DG | 内容 | 参照すべき正本 | 根拠 |
|---|---|---|---|
| DG-009 skill-creator | claude-plugins-official/plugins/skill-creator（T1、plugin 形式 21 ファイル）と anthropics/skills/skills/skill-creator（T2、18 ファイル）。本体 18 中 17 が blob 一致、差は LICENSE.txt（著作権者の行。survey 2-2）。ローカルの official clone と cache 10 版は T1 と一致 | **T1（P2-R-0069、https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator）** | `/skill-creator:skill-creator` として入るのは T1 で、plugin.json により版を追える。docs（skills、build/overview）も plugins/skill-creator を案内（P2-R-1261 の notes）。本体が同一なので挙動の差は無い。T2 は SKILL.md 単体で使う場合の参照 |
| DG-008 security-guidance | marketplace の clone（22 ファイル、2.0.13）と cache 2.0.8（tests 4 本が欠け、9 ファイルが異なる） | **marketplace の clone = GitHub main（P2-R-0072）** | cache 2.0.8 は導入済みの旧版の痕跡。参照・比較は上流で行う。同種の版ずれ: claude-security 0.11.0（ディレクトリの cache）/ 0.12.0（P2-V 7 節 8） |

## 9. 情報源の階層の更新案（権威の対象タグ別の正本）

現行（survey 2-4）の 3 段は「サイト単位」。今回の結果から、タグごとに正本を分ける案:

| タグ | 正本（1 位） | 2 位以下 | 備考 |
|---|---|---|---|
| 形式（SKILL.md） | https://agentskills.io/specification（L2） | https://code.claude.com/docs/en/skills（Claude Code 固有の frontmatter） | 現行 1 位を維持 |
| 形式（plugin.json・marketplace.json・hooks.json・mod） | code.claude.com の plugins/manifest-reference、plugins/marketplace-reference、hooks、plugins/mods/reference | `claude plugin validate`（実装としての判定） | 機械可読な L1 の schema は無い（404）。mod の型は https://github.com/anthropics/claude-code/blob/main/mods/types/claude-code.d.ts |
| 挙動（読み込み・validate・eval・test・headless） | 手元の版の `claude plugin --help` と code.claude.com/docs | — | docs は最新版を書くので、手元の版と食い違えば `--help` と実測を優先（判断） |
| ポリシー（予約名・公開・組織配布） | code.claude.com の plugins/marketplace-reference#reserved-names、plugins/publish | claude.com/docs/plugins/pre-submission-checklist（提出しないが品質基準）、org-rollout、org-sync | 現行 3 段目の「提出時の検査」をここへ |
| 参照実装 | claude-plugins-official の ./plugins/*（Anthropic 作） | anthropics/skills、anthropics/claude-code の mods/ | ./external_plugins/* と community の収録物は L3 |
| 変更履歴 | anthropics/claude-code の CHANGELOG.md（= feed.xml） | code.claude.com の changelog・whats-new（週次）、Releases・tags | 版の事実は CHANGELOG を正本にする案（残存リスク 11 の解消案。Fable 判断） |
| 背景 | — | claude.com/resources/articles、anthropic.com/engineering | 挙動・形式の根拠には使わない |

## 10. 監視対象の追加案（D3。LLMs リポジトリのバックログ用）

| サイト | 取得 URL | 監視可能性 | 推奨度 |
|---|---|---|---|
| claude.com/docs | https://claude.com/docs/llms.txt | llms.txt（266 ページ。survey 2-2）。差分で新ページを検出 | 高（面をまたぐ Plugin・Skill の仕様。未監視） |
| agentskills.io | https://agentskills.io/llms.txt | llms.txt（9 ページ。survey 2-2） | 高（SKILL.md 形式の正本。小さい） |
| anthropics/claude-code | https://raw.githubusercontent.com/anthropics/claude-code/refs/heads/main/CHANGELOG.md | git（raw の差分） | 高（docs より先。feed.xml と二者択一） |
| anthropics/claude-code | https://raw.githubusercontent.com/anthropics/claude-code/main/feed.xml | Atom（本書で取得: title「Claude Code Changelog」、1 版 1 entry、最新 v2.1.296 2026-10-09） | 高（版ごとの entry と日付があり差分が取りやすい。CHANGELOG と二者択一） |
| anthropics/claude-code Releases | https://github.com/anthropics/claude-code/releases.atom | Atom。P0-B の WebFetch は robots で拒否（p2-coverage E3-2）。本書では未取得 | 低（CHANGELOG と重複） |
| claude-plugins-official | https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json | git（190 KB。ローカル clone が自動更新されるので clone の差分でも可） | 中（skill-creator・plugin-dev の更新と新しい開発用 Plugin の検出。./plugins/* の author=Anthropic に絞る） |
| anthropics/skills | https://raw.githubusercontent.com/anthropics/skills/main/.claude-plugin/marketplace.json | git（2 KB。clone あり） | 中（skill-creator の T2 と spec の移動） |
| platform.claude.com/docs | https://platform.claude.com/llms.txt | llms.txt（P2-R-0104）。skill 関連ページだけに絞る必要 | 低（API 全般で X-4 の範囲外が大半） |
| claude.com（resources/articles） | sitemap（URL は P1-B の W-6 の記録に依存。本書では未取得） | sitemap | 低（背景の情報源） |
| academy.claude.com | https://academy.claude.com/assets/data/catalog.json | JSON（308 件。Claude Code の Plugin 教材は 0。P2-R-1237） | 低（B6 は範囲外側で確定済み） |

## 11. 設計書 v3.3 への影響

| # | 節 | 影響 | 推奨対応 |
|---|---|---|---|
| 11-1 | 4 節 14、8-1（A の run）／test-methods M4（発火テストの置き場） | skill-creator の run_eval.py は `claude -p` で発火を測る公式実装。ただし一時 command で description だけを測り、実物の skill・名前空間・実行ゲートは測らない | 発火テストの設計時に run_eval.py を比較対象として明記。ゲート付き skill の 3 段（呼び出し・ゲート通過・手順の実行）は自作のまま |
| 11-2 | 7-2、7-10（ハーネス） | 範囲内に公式のハーネスは無い（二重発明でない）。境界の Agent SDK（1386・2913・2940）と claude-trace（2932）が代替・補助の候補 | D13 で範囲判定してから、11 節（残課題）に載せるか決める |
| 11-3 | test-methods 2-6 のスクリプト単体、M7（hook とスクリプトの Plugin の手法） | `claude plugin test` は mod 専用（test.md に command hook の記述なし）。command hook は plugin-dev の test-hook.sh。statusline の hook はこちらの見込み（未検証） | スクリプト単体の定義を「mod は `claude plugin test`、それ以外は test-hook.sh」と分ける。mod 化する場合の雛形は 3 節 1357 |
| 11-4 | 7-5（C） | `claude plugin tag` が validate・版一致・clean tree を確かめる。dry-run の有無は未確認 | リリース時の C の証跡に tag の結果を残すか検討（6 節 (a)） |
| 11-5 | 2 節（F 根拠）、6-2 `meta.json`、M8（環境の事実確認） | CHANGELOG / feed.xml が環境の事実確認のトリガになる。npm の dist-tags が stable 2.1.287 と latest 2.1.296 の 2 系統 | `meta.json` の環境に Claude Code の版と配布チャネル（stable / latest）を残す案。M8 の置き場と合わせる |
| 11-6 | 6-6 `evals.json` | agentskills.io の Evaluating skill output quality（P2-R-0387）が skill-creator と同じ形式（survey 2-2） | 6-6 の根拠に https://agentskills.io/skill-creation/evaluating-skills を併記 |
| 11-7 | 2 節、7-1・8-1 の手動確認（managed 環境） | sec-default は managed 環境で最外層に座り、組織の hooks・設定・権限規則を利用者の Plugin から守る（mods/README の要約）。command hook の Plugin への影響は未確認 | managed 環境での手動確認の記録項目に「sec-default が有効か」を足すか検討 |

## 12. 走査の記録

- 読んだ入力: p2-merged.jsonl（Python で抽出のみ）、p2-merged.md（1〜7 節）、p2-coverage.md（1・2・6・7 節）、test-methods（1 節、2-6、2-7）、survey（全文。11 KB）、計画書（0-3〜2-4、A-10、9 節）、設計書 v3.3（見出し、4 節、7-2、7-5、7-10、8-1〜8-3、11 節）、p1-blog-support.md 3-5（S-1 クエリ）、p1-github-content.md 120〜139 行（G-6 クエリ）
- 原文既読の資産: code.claude.com/docs/en/plugins/mods/test.md（全文）、mods/diff/tests/record.test.ts（全文）、mods/README.md と mods/diff/README.md（get_file_contents の base64 を部分的に復号）、skill-creator の run_eval.py（先頭 70 行）、plugin-dev の test-hook.sh（先頭 60 行）
- WebFetch 要約のみ: mods/README.md、mods/agents-md/README.md、mods/agents-md/tests/register.test.ts、playground の claude-code/README.md・mods/README.md・hooks/README.md、claude-code-action の action.yml、claude-code の feed.xml（先頭 100,000 字）
- 一覧のみ: mods/、mods/diff、mods/diff/tests、mods/agents-md、mods/agents-md/tests、mods/sec-default、mods/telemetry、mods/types、playground の claude-code/、mods、mods/blast-radius、hooks、settings、workflows、official clone の plugin-dev・skill-creator・hookify・security-guidance（Glob）
- 未読: mods/sec-default・telemetry の README と tests、mods/types/claude-code.d.ts（516 KB）、playground の settings・workflows・claude-md の中身と replay-theater・token-weather、anthropics/skills の spec・template・evals、各 marketplace.json、claude-plugins-community の CI、plugin-dev の agent 本文・validate-hook-schema.sh・hook-linter.sh、skill-creator の run_loop.py・improve_description.py・package_skill.py、built-in skill plugin-authoring
- P2-R-1257（feed.xml）は本書の取得で存在と形式（Atom）を確認した。unverified の解消材料（判定の変更は Fable）
- ツール呼び出し: 約 67 回（上限 80）。権限拒否: 無し
- 逸脱: 初回の Bash で `mkdir -p`（scratchpad の作業フォルダ作成）、Python 実行前の `cd`（scratchpad へ）、出力の `head` を使った（いずれも許可列挙外のコマンド。データのあるディレクトリでは実行していない）。p1-blog-support.md と p1-github-content.md の一部を、照会 ID を取るため読んだ（役割 4 の指示）
