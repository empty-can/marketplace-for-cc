# 公式のプラグイン開発資産の棚卸し（2026-10-13）— 棚卸し文書と終了宣言の草稿

| 項目 | 内容 |
|---|---|
| 位置づけ | branch「公式のプラグイン開発資産の情報整理」の成果物。計画書 `official-assets-planning-approach_2026-10-13.md`（0.4 版 + 9 節）に沿って Phase 0〜2 と再走査 2 回を実施した結果 |
| 作成 | Claude（Fable 5.1、メインセッション）。P2-M（Opus）の草稿 `official-assets/p2-mapping.md` を Fable が検証して要約し、判定を加えた。資産ごとの全表・境界 165 件・情報源 106 件の URL は草稿を参照 |
| 状態 | **0.9.1 版（作業指示者の通読レビュー 1 巡目を反映。受理待ち）**。D7（終了宣言の受理）、D4〜D6、D11〜D14 の判断で 1.0 にする。変更履歴は末尾 |
| 証拠 | 結合済みの全件 `official-assets/p2-merged.jsonl`（3,191 行）、検証記録 `p2-verify.md`、クロスチェック `p2-coverage.md`、各チャネルの走査記録 `p1-*.md`、Phase 0 の `p0-*.md`。Fable の抜き取り 17 件は全件一致 |

## 1. 結論

1. **設計中の仕組みは公式資産の二重発明ではない**（survey 2-1 を、org 全件のファイルツリー、code search、docs 全ページ、CHANGELOG、Releases、npm / PyPI、blog / support、Academy、blind 探索 2 名で確認したうえで追認）。作業状態を再現したサンドボックスでのヘッドレス実行、証跡の構造、モデルと effort の固定に相当する L1 / L2 の資産は範囲内に無い。
2. **部分的に重なる公式資産は 3 つ**。設計ではこれらを「自作しない」か「比較対象」にする。
   - plugin-dev 同梱の hook 検査スクリプト（`test-hook.sh`、`validate-hook-schema.sh`、`hook-linter.sh`）= command 型 hook のスクリプト単体テスト（既知。採用済み）
   - skill-creator の `scripts/run_eval.py` = `claude -p` で description が skill を起動させるかを測る**発火テストの公式実装**（新規）。ただし一時 command に description だけを載せて測るため、Plugin に入った実物の skill、名前空間付きの名前、本文の実行ゲートは測らない
   - `claude plugin test` と `claude-code/testing` = **mod（hooks module）のテストキット**（新規）。モデルもネットワークも使わない決定的なテストで、`anthropics/claude-code/tree/main/mods` の 4 mod が `tests/` 付きの実例。command 型 hook・skill・agent は対象外で、本 Marketplace の現行 Plugin（statusline、pre-compact）には当たらない
3. **情報源の階層は「サイト単位」から「権威の対象単位」に改め、正本 / 準正本 / 参考の 3 段と参照規則を置く**（4 節。2026-10-17 改訂案）。Claude Code に関する問いは Claude Code の docs と実挙動で決める。SKILL.md を Claude Code が読む形式の正本は code.claude.com/docs/en/skills で、agentskills.io の仕様は準正本（可搬形式の問いと、docs が定義を委ねた項目でだけ正本）。plugin.json / marketplace.json / hooks.json / mod の形式は code.claude.com の reference、挙動の正本は手元の版の実挙動（docs は文書の正本かつ挙動の準正本）、ポリシーは code.claude.com の marketplace-reference と publish、Organization 配布の受理条件は claude.com/docs/plugins/org-sync、参照実装は claude-plugins-official の `./plugins/*`、版と変更履歴は `anthropics/claude-code` の CHANGELOG.md。0.9 版で agentskills.io を SKILL.md の正本としていたのは旧階層の引き継ぎで、spec と docs は既に食い違っている。
4. **終了条件は E1〜E4 と E6 を満たし、E5 は再走査 2 回で範囲内の新規資産が 0 件**（6 節の終了宣言）。残存リスクは 12 項目を明記し、監視対象の追加案（5 節。高 3 と中 2 を推奨、低 4 は積まない候補）を LLMs リポジトリのバックログに積む。
5. **「あらかじめ把握しておくべき情報源・公開資産はもう他には無い」と言えるか**: Anthropic 管理下のチャネル（docs 3 サイトの全ページ、GitHub org の全リポジトリとファイルツリー、公式 Marketplace、本体の同梱物、レジストリ、blog / support / Academy）を有限集合として全走査し、反証（リンク閉包、blind 探索、公式索引、再走査 2 回）が範囲内の新規資産を出さなかった、という意味で **言える**。言えないのは残存リスク 12 項目の範囲（SNS だけの告知、リンクも名前も無い資産、深さ 3 以降のリンク、第三者 org の中身）で、このうち監視（5 節）で補えるのは docs の新ページと Claude Code の新版の検出に限られる。SNS だけの告知など他の項目は、監視ではなく受容の対象である。**手続きの妥当性の直接の証拠**: survey 作成時に場当たり的に辿り着いた情報源（claude.com/docs/build/overview、agentskills.io、anthropics/skills、agentskills/agentskills、anthropic-agent-skills Marketplace、skill-creator、plugin-dev、knowledge-work-plugins）は、すべて今回の手続きの別チャネル（W-1 の llms.txt、W-8 のリンク閉包、L-2 のローカル Marketplace、G-1 の org 全件、G-11 の木、S-3 / S-5）で独立に再発見された（p1-*.jsonl の channel 欄）。
6. **survey に無かった参照必須の資産**（survey 2-5 に追記）: `claude plugin test` と `anthropics/claude-code/tree/main/mods`（mod のテストキットと実例）、skill-creator の `scripts/run_eval.py`（発火テストの公式実装）、claude.com/docs/plugins/org-sync（Organization 配布の受理条件: `metadata.pluginRoot` の bare name と `bin/` の拒否）、code.claude.com の marketplace-reference#reserved-names（予約名 19 件）と plugins/publish、`anthropics/claude-code` の `feed.xml`（Atom の変更履歴）、claude.com/marketplace/plugins（第三者 Plugin の掲載一覧 336 件 = L3）、`anthropic-experimental` org（権威未確定）、npm の非スコープ `claude-code`（境界）。

## 2. 採用候補（資産 44 件のうち。詳細は草稿 2 節・3 節）

| 判定 | 件数 | 資産 |
|---|---|---|
| 採用（既採用） | 3 | skill-creator（手法 A・発火）、`claude plugin eval`（B）、`claude plugin` の 15 サブコマンド（validate = C、tag、test、marketplace / install） |
| 採用 | 8 | plugin-dev（hook のスクリプト単体、静的レビュー、手動チェックリスト）、`anthropics/claude-code` の CHANGELOG.md、npm `@anthropic-ai/claude-code`（版の固定。dist-tags は stable 2.1.287 / latest 2.1.296 の 2 系統）、`anthropics/claude-code`（監視の起点）、`anthropics/claude-plugins-official` とその marketplace.json（参照実装の正本）、`agentskills/agentskills`（SKILL.md の可搬形式の正本。Claude Code が読む形式の正本は code.claude.com。4 節）、`anthropics/skills`（skill の実例） |
| 条件付き | 14 | 特定のケースで使う資産。ケースは表の直後の 6 種類（他の資産で足りないときの比較用や、外部の条件が成立してからの採用を含む） |
| 不採用 | 19 | 複製行 10（cache と木の集約行）、中身の無い playground の hooks / settings / workflows、telemetry mod（利用者の Plugin から使えない）、claude-plugins-community（提出しない前提）、life-sciences の marketplace.json、claude-code-base-action、spec/agent-skills-spec.md（正本は agentskills.io） |

「条件付き」14 件の内訳（ケース別。ID は草稿の merged_id。親行 2 件を含む）

- mod を書く場合（5）: `anthropics/claude-code` の `mods/`（1254。親行）、`mods/diff`（1358）、`mods/agents-md`（1357）、`mods/types`（1361）、組み込み skill plugin-authoring（0111）
- CI を導入する場合（1）: `anthropics/claude-code-action` の `plugins` 入力（0102）
- skill だけを作る・配る場合（3）: skills の template/SKILL.md（0064）、skills 側の skill-creator（0065。SKILL.md 単体で配るときの参照）、skills の marketplace.json（2798）
- Marketplace の書き方や導入手順を比較・参照する場合（2）: claude-code の marketplace.json（2786。公式 Marketplace の 2789 で足りないときの比較例）、playground の mods（1230。local marketplace 経由で入れる手順の実例）
- managed 環境（組織の管理下）の挙動を調べる場合（1）: `mods/sec-default`（1359。最外層に座る managed 環境の前提を読む情報源。7 節の 7 行目に対応。0.9 版では「mod を書く場合」に入れていたが草稿の根拠に合わせて移した）
- 外部の条件が成立したら（1）: `$schema` の受理（2901。公式 schema URL が 404 のため、公開されたら採用）
- 親行（1）: `claude-code-playground`（1229。中身は草稿 3 節の各行に従う）

**Fable が草稿に加えた判定**

- `/skill-doctor`（組み込みコマンド。利用実績の観測）は結合済みの一覧に行が無く notes にしか無い。棚卸しでは **L1 の資産（同梱）として数える**。docs の導入版（v2.1.252 以降）と CHANGELOG の初出（2.1.261）が食い違う点は残存リスク 11。
- `claude plugin tag` は 9 手法に対応先が無い（テストではなくリリース操作）。**手法整理文書に「リリース検査」を足すか、C の証跡に tag の結果を含めるかは、手法整理文書の再開時に作業指示者が決める**（影響は 7 節の 4）。
- `anthropics/claude-code` の `feed.xml` は P2-M が取得して Atom（1 版 1 entry、最新 v2.1.296）と確認した。結合済みの一覧では unverified のままなので、**確認済みとして扱う**（監視案 5 節）。
- 参照・雛形・監視用の 20 資産は「どの手法にも対応づかない」が欠落ではない。E6 の対応先なしは **2 件（`claude plugin tag`、feed.xml）** と数える。
- 複製の正本: skill-creator は claude-plugins-official 側（`/skill-creator:skill-creator` として入り plugin.json で版を追える。anthropics/skills 側は LICENSE.txt の著作権者行だけ違う）。security-guidance はローカル cache 2.0.8 ではなく marketplace の clone（2.0.13 = GitHub main）。

## 3. E6 マトリクス（9 手法 × 3 活動。資産は P2-R の merged_id）

3 活動は Plugin の「開発」「テスト」「配布」（計画書 0-2 と E6 の定義）。各セルは、その手法をその活動のときに使うために参照できる公式資産で、「開発」は Plugin を開発する活動を指す（本セッションで開発した資産ではない）。設計書の証跡の「活動」（`activity.json` の feature / release / maintenance / investigation）とは別の概念。

| 手法 \ 活動 | 開発（Plugin の開発） | テスト | 配布 |
|---|---|---|---|
| C（構文・スキーマ） | 0092 validate、0068 の validate-hook-schema.sh・validate-agent.sh | 0092 | 0092（`--strict` の CI 利用は docs 1225。tag が validate を内包） |
| B（plugin eval） | 0093（`eval init`） | 0093 | 0093（CI での固定は docs 0009） |
| A（skill-creator） | 0069 | 0069 | 確認済みで無し（L-2 の scripts 一覧、G-6 #3・#8a・#8b、S-1 #11） |
| probe | 確認済みで無し（L-3 の `--help`、S-1 #14、G-6 #10。境界: Agent SDK、claude-trace） | 同左 | 0102 claude-code-action（仮置き） |
| manual | 0068（create-plugin Phase 7） | 0068 | 0092（marketplace add / install。手順の実例は playground の mods） |
| 発火テスト | 0069（run_eval.py 等） | 0069、0093 | 確認済みで無し（L-1 docs_map の relevance・cli-hints は導入の推薦、S-1 #11、G-6 #8a・#8b） |
| スクリプト単体 | 0068（command hook）、1254（mod） | 0068、0092 test（mod） | 0092 test（終了コード 1 で CI 可。mod のみ） |
| 環境の事実確認 | 0101、2904 | 0101、2904 | 0101、2904、0100 |
| 利用実績の観測 | 確認済みで無し（`/skill-doctor` は行なし。境界: measure、monitoring-guide） | 同左 | 確認済みで無し（境界: Analytics API） |

セル埋め率 20 / 27（74%）。空の 7 セルは「確認済みで無し」で、照会したチャネルとクエリの ID を付けた。A × 配布と発火 × 配布は、配布後に実物の Plugin を対象にする仕組みが公式に無いことを意味し、設計書の手法 A の通しと発火テストが埋める。

手法名について。手法名はテスト手法の整理文書 2-7 の名称をそのまま使い、名称の見直しは整理文書の再開時に行う。`probe` は改名の記録が無く、設計書の識別子（`-Method probe`、`Invoke-Probe.ps1`、証跡の `probe/` フォルダ）と同じ名称で、`claude -p` のヘッドレス実行ハーネスを指す。行の性質は揃っていない。C・B・A・probe・manual・スクリプト単体は実行方式、発火テストは観点（実行方式と直交し、A・B・probe のいずれでも測れる）、環境の事実確認は目的、利用実績の観測は観測（整理文書が「テストではなく観測」と明記）で、後ろの 3 行は整理文書 2-6 で「現行の設計に無い手法（候補）」とされたもの。E6 は用途ベースの充足を見る表なので、行として残している。

## 4. 情報源の階層（survey 2-4 の更新。2026-10-17 改訂案。J-1・J-3 の承認で確定し、承認後に survey 2-4 と計画書 1-1・1-3 を同じ内容に直す）

本 Marketplace は Claude Code 専用で、ディレクトリへは提出しない（計画書 0-2）。Claude Code に関する問いは Claude Code の docs と実挙動で決める。他クライアント共通の標準（agentskills.io）が効くのは、可搬性の問いと、docs が定義を委ねた項目だけ。0.9 版で agentskills.io を SKILL.md の正本としていたのは survey 2-4 の旧階層を再評価せずに引き継いだもので、spec と docs は既に食い違っている（spec では `name` が必須で親ディレクトリ名と一致、docs では任意で既定がディレクトリ名。spec の `description` は必須、docs では推奨。`allowed-tools` の書式も異なる）。spec を正本にすると、Claude Code では正しい SKILL.md を誤りと判定してしまう。

**文書の権威と挙動の権威を分ける。** 挙動の正本は手元の版（`claude --version` を記録する）の Claude Code 本体の実挙動で、4-3 の観測手段で読む。code.claude.com の docs は開発元による文書化で、文書の正本であり、挙動の準正本でもある。claude.ai 側の受理条件、公開ポリシー、変更履歴は手元で観測できないので、文書が正本。

**docs の反映遅れへの扱い。** docs はリリースから数日遅れて反映されることがあり、逆に手元の版が docs より古いこともある。実挙動と docs が食い違ったら、CHANGELOG.md で手元の版と docs の版の間の変更を確かめる。説明が付けば実挙動に従う。説明が付かなければ「文書化されていない挙動」として版・環境と一緒に記録し、当面は実挙動に従うが依存は避け、版が上がるたびに確かめ直す（文書化されていない挙動は不具合として直されることがある。例: CHANGELOG 2.1.153 の undocumented な一時 worktree の修正）。

### 4-1. 権威の対象ごとの情報源

| 権威の対象 | 正本 | 準正本 | 参考 | 参照規則・食い違い時の扱い |
|---|---|---|---|---|
| 1. SKILL.md（Claude Code が読む形式と frontmatter） | https://code.claude.com/docs/en/skills（frontmatter の表、Using skill frontmatter outside Claude Code、命名の表） | https://agentskills.io/specification（docs が委ねる `license` / `compatibility` の意味、`scripts/` 等の構成の慣行）、https://code.claude.com/docs/en/plugins/components（Plugin 内の配置） | https://claude.com/docs/skills/how-to、https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills | 食い違ったら docs に従う。読み込まれるかの最終判定は 5 行目 |
| 2. SKILL.md の可搬形式（休眠。claude.ai への投稿、Skills API、`package_skill.py` を使うときだけ。J-2） | https://agentskills.io/specification | https://code.claude.com/docs/en/skills#using-skill-frontmatter-outside-claude-code（使える 6 項目と unexpected key のエラー） | https://github.com/agentskills/agentskills の skills-ref（デモ用途） | 現在は該当する配布経路が無い。spec の 6 項目だけで書けば Claude Code でもそのまま読める |
| 3. Plugin の構成ファイル（plugin.json、marketplace.json、hooks/hooks.json、agents/*.md、ディレクトリ構成） | https://code.claude.com/docs/en/plugins/manifest-reference、https://code.claude.com/docs/en/plugins/marketplace-reference、https://code.claude.com/docs/en/hooks、https://code.claude.com/docs/en/plugins/components、https://code.claude.com/docs/en/sub-agents | https://code.claude.com/docs/en/plugins/create-marketplace、https://code.claude.com/docs/en/plugins/create（解説ページ。reference と食い違ったら reference に従う） | https://claude.com/docs/plugins/build | 受理されるかの最終判定は、手元の版での読み込み（5 行目）。`claude plugin validate` は観測手段（4-3）。機械可読な公式の schema は無い（`$schema` の URL は 404。SchemaStore 版は権威外） |
| 4. mod（hooks module）の形式と API（mod を書く場合だけ） | https://code.claude.com/docs/en/plugins/mods/reference、https://code.claude.com/docs/en/plugins/mods/api | https://github.com/anthropics/claude-code/blob/main/mods/types/claude-code.d.ts（機械可読の型。main の版。J-7） | https://claude.com/resources/articles/claude-code-mods | docs と d.ts が食い違ったら、手元の版の `claude plugin test` と実挙動で決める（d.ts は手元の版より新しいことがある） |
| 5. 挙動: セッション内（読み込み、skill の発火、hook・statusline の実行、agent、`/reload-plugins`） | 手元の版の実挙動（4-3 の観測手段で、版・環境・手段・日時を付けて記録したもの） | https://code.claude.com/docs/en/plugins/loading、https://code.claude.com/docs/en/skills、https://code.claude.com/docs/en/hooks、https://code.claude.com/docs/en/sub-agents、https://code.claude.com/docs/en/statusline、https://code.claude.com/docs/en/debug-your-config。docs に未反映の版は https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md | https://claude.com/resources/articles/how-to-configure-hooks、https://claude.com/resources/articles/steering-claude-code-skills-hooks-rules-subagents-and-more | 食い違ったら冒頭の手順に従う。観測していない挙動は docs を根拠にしてよい（「docs による。未観測」と書く）。設計やリリースの前提にする挙動は観測する |
| 6. 挙動: CLI（`claude plugin` のサブコマンドと option、validate / eval / test / tag の判定、`claude -p`） | 手元の版の `claude … --help`、終了コード、出力 | https://code.claude.com/docs/en/plugins/cli-reference、https://code.claude.com/docs/en/cli-reference、https://code.claude.com/docs/en/plugin-evals、https://code.claude.com/docs/en/headless、https://code.claude.com/docs/en/plugins/mods/test | — | サブコマンドと option の一覧は `--help` を見る（docs 自身が「手元の版は `claude plugin --help` で確かめる」と委ねている）。意味・既定値・終了コードの説明は docs を見る。食い違ったら冒頭の手順に従う |
| 7. 版と変更履歴（どの版で何が変わったか） | https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md（= https://raw.githubusercontent.com/anthropics/claude-code/main/feed.xml） | https://code.claude.com/docs/en/changelog（CHANGELOG.md からの生成物）、npm `@anthropic-ai/claude-code` の dist-tags（stable / latest の版）、https://github.com/anthropics/claude-code/releases（v2.0.73 以降のみ） | https://code.claude.com/docs/en/whats-new（週次）、https://www.anthropic.com/news | 版の初出については、CHANGELOG が docs 本文の「Requires vX」に優先する（残存リスク 11 の解消）。手元の版は `claude --version` で確かめる |
| 8. 命名・公開のポリシー（予約名、Marketplace の公開） | https://code.claude.com/docs/en/plugins/marketplace-reference#reserved-names、https://code.claude.com/docs/en/plugins/publish | https://code.claude.com/docs/en/plugins/host-marketplace、https://code.claude.com/docs/en/plugins/security | https://claude.com/docs/plugins/pre-submission-checklist（提出はしないが、品質基準として参照する。D6） | 方針は文書が正本。CLI が強制する部分があれば観測でも確かめ、食い違ったら冒頭の手順に従う |
| 9. claude.ai の Organization 配布の受理条件（`metadata.pluginRoot` の bare name、トップレベルの `bin/` など） | https://claude.com/docs/plugins/org-sync | https://claude.com/docs/plugins/org-rollout、https://code.claude.com/docs/en/plugins/org | https://claude.com/resources/articles/organization-skills-and-directory | claude.ai 側の受理は手元で観測できないので、文書が正本。`.claude/CLAUDE.md` の該当規約の根拠（survey 2-5） |
| 10. 参照実装（Anthropic 自身の作例） | anthropics/claude-plugins-official の `./plugins/*`（author = Anthropic。読むのは `~/.claude/plugins/marketplaces/claude-plugins-official/` の clone で、cache ではない） | https://github.com/anthropics/skills、https://github.com/anthropics/claude-code/tree/main/mods | https://github.com/anthropics/claude-code-playground、https://claude.com/resources/articles の作例記事 | 実例は作り方の手本で、形式・挙動の根拠にはしない。docs と食い違ったら docs に従う（実例が古いことがある）。複製があるときは claude-plugins-official 側を採る（2 節） |
| 11. 作り方・評価の推奨（skill の書き方、description の最適化、評価の方法） | https://code.claude.com/docs/en/skills、https://code.claude.com/docs/en/plugin-evals。ただし evals.json の形式と反復の手順は、docs が委ねる https://agentskills.io/skill-creation/evaluating-skills | https://agentskills.io/skill-creation/best-practices、https://agentskills.io/skill-creation/optimizing-descriptions、https://agentskills.io/skill-creation/using-scripts | https://claude.com/resources/articles/improving-skill-creator-test-measure-and-refine-agent-skills、https://claude.com/resources/guides/the-complete-guide-to-building-skills-for-claude | 推奨は指針であり、形式・挙動の根拠にはしない。食い違ったら code.claude.com に従う |

### 4-2. 段ごとの参照規則

- **正本**: その対象で判断を確定する（設計に書く、リリースする）前に、必ず確認する。食い違ったら正本を採る。正本が定義を明示的に委ねている項目は、委ね先がその項目の正本になる（例: 11 行目の evals.json）。1 つの問いに判定を下す正本は 1 種類にする（同じ発行元のページが複数並ぶ行は、主題を分け合っていて 1 つの問いに 2 つの正本が当たることはない）
- **準正本**: 正本に記述が無い、曖昧、または正本が委ねているとき、あるいは docs が未反映の期間に、問いの主題を扱うものだけを読む（全件は読まない）。URL と取得日を付ければ根拠として引用してよい。準正本どうしが食い違ったら、セル内の記載順で仮に採る。挙動に関わる食い違いは観測で決める。準正本の中をさらに順位づけはしない（食い違いは横で比べず、上の正本か観測に戻して決める）
- **参考**: 根拠には使わない。背景や意図の理解と、新しい資産・変更に気づく手がかりにだけ使う。参考で知ったことは、正本・準正本・観測で裏付けてから使う。会社の engineering blog と claude.com の記事はドメイン上は L1 だが規範ではないのでここに置く。社員個人の blog・SNS は L3 または対象外（計画書 1-1、1-4 B2）で表に載せず、4-5 の方針で扱う。4 段目は設けない
- **表に無い情報源**: 4-5 の方針に従う

### 4-3. 観測手段（挙動の正本を読む手段。情報源ではない）

| 手段 | 見えるもの | 見えないもの・注意 |
|---|---|---|
| `claude --version` | 手元の版 | すべての観測記録に付ける |
| `claude plugin --help`、`claude plugin <sub> --help` | その版にあるサブコマンドと option | option の意味や既定値の詳細（docs で確かめる） |
| `claude plugin validate <plugin>` / `validate .` | マニフェストの構文・スキーマが受理されるか | ルートでは skill / agent / hook の中身を検査しない。通っても読み込み時の挙動は保証されない |
| `claude plugin tag` | validate、plugin.json と Marketplace エントリの版の一致、clean tree | タグを作るリリース操作を伴う（dry-run の有無は未確認） |
| `claude plugin eval` / `claude plugin test` | 実際のプロンプトでの効果 / mod の決定的なテスト | eval はモデルの揺らぎを含む。test は mod 専用 |
| `claude --plugin-dir` と `/reload-plugins`、`/context`・`/hooks`・`/doctor`、`claude -p` | 実際に読み込まれたもの、発火・実行の有無 | 設定、managed の方針、アカウント、OS に左右されるので、環境を記録する |

### 4-4. 食い違いの記録（様式と置き場所は J-5）

docs と実挙動の食い違い、docs と CHANGELOG の食い違いは、版・環境・観測手段・docs の該当箇所と取得日・CHANGELOG の確認結果を 1 行にまとめて記録する。版が上がるたびに見直し、docs に反映されたものは閉じる。

### 4-5. 権威情報源外の情報の扱い（方針案。置き場所は J-4）

4-1 の表（正本・準正本・参考）に無い情報源は、判断の根拠に使わない。これには、第三者の blog・記事・Q&A、コミュニティのリスト、SchemaStore などの第三者のスキーマ、Discord / X / YouTube の投稿、Anthropic 社員個人の公開物（L1 からリンクされていれば L3 として記録だけする）、そして Claude 自身の学習済み知識が含まれる。存在を知る手がかり、検索語、仮説の着想には使ってよい（本棚卸しの計画書も、権威の無いチャネルを「見落とし検出」にだけ使った）。使った場合は、正本・準正本・手元の版の観測で裏付けてから採用し、出所には裏付けた側を書く。裏付けられないものは「未確認」と明記して判断から外す。参考の段も根拠には使わないが、Anthropic の意図や背景の説明として引用はしてよい。この方針は現時点でどの文書にも一般方針として明記されておらず（計画書と本文書に活動を限った記述があるだけ）、毎セッション読み込まれる `.claude/CLAUDE.md` の「Claude Code に関する公式ドキュメントのローカル参照先」節の直前に「情報源の権威」節として置く案を提案する。

## 5. 監視対象の追加案（D3。LLMs リポジトリ側のバックログ。本活動では実装しない）

「本棚卸しの範囲」は Claude Code の Plugin の開発・テスト・配布。推奨度の理由は、Plugin 開発に関係する情報の量、既存の監視との重複、取得のしやすさ、監視コストの観点で書く。「高」と「中」はバックログに積む推奨、「低」は積まない候補（理由付きで記録。積むなら優先度低）。取得 URL が無い行は「無し（理由）」と書く（本表には無い）。

| 推奨 | サイト | 取得 URL | 方式 | 推奨度の理由 |
|---|---|---|---|---|
| 高 | claude.com/docs | https://claude.com/docs/llms.txt | llms.txt（262〜266 ページ）の差分 | Plugin・Skill の仕様が面をまたいで載り、新ページが増えやすい。llms.txt は sitemap と差 0 で全ページを網羅し、小さいので差分が安い。現状は未監視 |
| 高 | agentskills.io | https://agentskills.io/llms.txt | llms.txt（9 ページ）の差分 | SKILL.md の可搬な形式の正本。9 ページと小さく差分のコストはほぼ無い。llms.txt は sitemap と差 0 |
| 高 | anthropics/claude-code | https://raw.githubusercontent.com/anthropics/claude-code/main/feed.xml（一次）。代替: https://raw.githubusercontent.com/anthropics/claude-code/refs/heads/main/CHANGELOG.md | Atom（1 版 1 entry、日付あり）。CHANGELOG.md は raw の差分 | 新機能は docs より先に CHANGELOG に出る。feed.xml は取得して Atom と確認済み（最新 v2.1.296）で、1 版 1 entry で差分が取りやすい |
| 中 | anthropics/claude-plugins-official | https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json（ローカル clone の同名ファイルでも可） | marketplace.json（約 190 KB）の差分。`./plugins/*` の author = Anthropic に絞る | skill-creator・plugin-dev の更新と、新しい開発用 Plugin を検出できる。ローカル clone が自動更新されるので取得コストは低いが、第三者の Plugin が大半でノイズが多く、絞り込みが要る |
| 中 | anthropics/skills | https://raw.githubusercontent.com/anthropics/skills/main/.claude-plugin/marketplace.json（ローカル clone の同名ファイルでも可） | marketplace.json（約 2 KB）の差分 | skill-creator の更新と spec の移動を検出できる。2 KB で取得は安いが、変更頻度が低く Plugin 開発への影響は限られる |
| 低 | platform.claude.com/docs | https://platform.claude.com/llms.txt | llms.txt（760 ページ）の差分。skill 関連ページに絞る必要あり | API 全般の docs で、title / URL に skill / claude code を含むのは 33 件だけ。うち 24 件は API エンドポイント参照で、Plugin に関する情報がほとんど無く、760 ページを差分で追う手間に見合わない |
| 低 | claude.com（resources/articles） | https://claude.com/sitemap.xml（/resources/articles/ に絞る） | sitemap の lastmod 差分 | 記事は背景の情報源で、挙動・形式の根拠に使わない（4 節）。sitemap は 3,648 URL で marketplace/ の 1,299 件などが混ざり、絞り込みの手間が大きく監視コストが見合わない |
| 低 | academy.claude.com | https://academy.claude.com/assets/data/catalog.json | JSON（308 件）の差分 | 現時点で Claude Code の Plugin 教材は 0 件で、監視しても検出対象が無い。取得は JSON 1 本で安いが、Plugin 教材が現れるまで価値が無い |
| 低 | anthropics/claude-code Releases | https://github.com/anthropics/claude-code/releases.atom | Atom（取得は未確認。blind 探索の WebFetch は robots で拒否された） | CHANGELOG（feed.xml）と内容が重複し、Releases は v2.0.73（2025-12-19）以降しか無いため、CHANGELOG より新しい情報も古い情報も無い |

## 6. 終了宣言（草稿。D7）

```text
終了宣言（2026-10-13、Claude Code 2.1.296。Phase 1 の開始 01:18 から P2-M の終了 03:55 まで版のずれ無し）
- 定義: 計画書 1 節の L1（Anthropic 一次。anthropics org 配下で著作者が社員個人名でも L1 = D12）/ L2（Anthropic 発の公開標準 = agentskills、MCP は範囲外）。L3 は別表（p2-merged.jsonl の authority L3）。範囲: 計画書 0-2。なお L1 / L2 / L3 は範囲に入るかの分類であり、4 節の正本 / 準正本 / 参考は根拠に使う強さの分類で、別の軸
- 走査したチャネル: ローカル層 L-1〜L-3（L-2b を含む）、列挙可能層 W-1〜W-8、GitHub G-1〜G-12（再走査 1 で G-11 を org 全件に拡大、再走査 2 で G-5 の著者集合を差し替え）、補助 S-1〜S-5
- 件数: 結合済み 3,191 件（7 本 3,329 行から統合 138）。範囲内の L1 / L2 の candidate 141（資産 35 + 情報源 106）、境界 316、新規の L1 / L2 224 件はすべて再取得で確認（確認済み 222、URL の無い 2 件は検証不能）。Fable の抜き取り 17 件は全件一致
- 主な母集団: anthropics org 115 リポジトリ（GraphQL の totalCount と一致。全件に範囲判定と tree SHA）、agentskills 4、anthropic-experimental 2。claude.com/docs 262 ページと agentskills.io 9 ページは sitemap と llms.txt の差 0。code.claude.com は docs_map の全見出しを走査。公式 Marketplace 315 エントリ、Plugin ディレクトリの cache、Claude Code 本体のバンドル内 URL、組み込み skill / agent の一覧。CHANGELOG 全行と Releases 241 件、npm @anthropic-ai 35 + maintainer 検索 43、PyPI org 6。anthropic.com 553 URL、claude.com 3,648 URL、support 361 記事（Claude Code 20）、Academy 308 コース（Claude Code の Plugin 教材 0）。issue は 19,060 件を著者で走査し社員集合 71 名で再走査。wiki 21 件は全て空
- GitHub の制約に当たった探索単位: code search の `path:` は直下の前置一致のみ（org 内は `path:` 無しの再実行と木で解消。org 外の L3 発見は上位 1,000 件のみ）、384 KB 超 1 ファイルは索引外、Packages は 403（read:packages 無し）、`claude` 名の org 検索は 300 件で打ち切り
- 反証の試み: E2 リンク閉包は深さ 2 で非飽和（Anthropic 系の未知は console / support のリダイレクト先が L1 と確定、claude.dev と brand.anthropic.com は未確認、repo は G-1 の全件に含まれる）。E3 blind 2 名（部分的独立。文脈由来 flag 15・除外 0）の L1 / L2 項目 183 件中 182 件が和集合に含まれ、2 節に無いチャネル種別は 2 件（resources.anthropic.com の PDF 配布 = www.anthropic.com/news へリダイレクト、GitHub の Atom = 監視案。feed.xml は取得確認済み、releases.atom は robots により WebFetch が拒否され未確認）。E4 は設計に使っていない索引（agentskills の profile README 4/4、予約名の実体あり 12/12、claude-code-guide の参照項目 6/6）で包含 100%（anthropics 本体の pinned と profile README は 0 件で計算不能）
- E5: 再走査 1（G-11 を out 全 repo へ。署名ありは 5 repo で境界）と再走査 2（G-5 の著者集合。docs に先行する告知 1 件 = claude-code#91870「Mods」。リンク先 `mods/` は W-8 の deep link で既に境界にあった行 P2-R-1254 を candidate に確定したもので、新規ではない）で、範囲内の新規 L1 / L2 資産は 0 件。3 回目は行わない（D2 の範囲内で終了）
- E6: 9 手法 × 3 活動（開発 / テスト / 配布）のセル埋め率 74%。「確認済みで無し」7 セル（A（skill-creator）× 配布、probe × 開発・テスト、発火テスト × 配布、利用実績の観測 × 3）。条件付きの 14 件は、条件が成立した場合の対応先を含めない。対応先の無い資産は Fable の数え方で 2 件（`claude plugin tag`、feed.xml）。P2-M の草稿は参照・雛形・監視用の 20 資産を含めて 22 と数えている（2 節の判定）
- 残存リスク（定型）: Discord / X / YouTube でしか告知されず docs / CHANGELOG / blog に現れていない資産は検出できない。どこからもリンクされず名前からも関連が分からない資産は E1 / E2 の対象外。LLM 探索者は学習データと注入文脈を共有するため共通の盲点は検出できない。観測環境（版・アカウント・組織設定）に依存する資産は、この環境で見えたものに限る
- 残存リスク（個別）: (1) 公式の JSON Schema が取得できない（404。形式の文書上の正本は docs の項目表、受理の最終判定は手元の版の読み込みと `claude plugin validate` の実測で、機械可読な schema は無い）、(2) code search の構造的限界（org 外の L3 は上位 1,000 件）、(3) 社員の識別は著者集合 71 名の近似（公開メンバー 0）、(4) L1 の marketplace で owner / author が社員個人名（D12 の規則で L1）、(5) 予約 Marketplace 名のうち公開の実体が無いもの 5 件、(6) docs・README の古い slug / repo 名（別名に統合済み）、(7) sitemap 外の Anthropic ホスト（claude.dev、brand.anthropic.com は未確認）、(8) ローカル cache と marketplace の版ずれ（security-guidance、claude-security）、(9) anthropic-experimental の権威未確定（内容は範囲外）、(10) Packages 403、(11) docs と CHANGELOG の版記述の食い違い（/skill-doctor の導入版。4 節で版の初出は CHANGELOG を正本としたため docs 側を準正本として扱うが、実測で確認できるまでは未確認として残す）、(12) W-8 は深さ 2 で非飽和
- 監視への移行: 5 節の案（高 3 / 中 2 / 低 4。作業指示者が LLMs リポジトリのバックログへ。D3）。低 4 件は Plugin 情報が少なく監視コストが見合わないため、積まない候補として理由付きで記録した。監視で補えるのは新ページ・新版の検出に限られ、他の残存リスクは受容の対象
```

## 7. 設計書 v3.3 と手法整理文書への影響（設計の再開時に反映。本活動では編集しない）

番号は草稿 `p2-mapping.md` 11 節の 11-n に対応する。「対象」列の M＝手法整理文書の手法 ID、7-n・6-n・8-n・2 節＝設計書 v3.3 の節。

| # | 対象 | 影響 | 推奨対応 |
|---|---|---|---|
| 1 | 設計書 4 節 14、8-1、手法整理 M4 | skill-creator の `run_eval.py` は `claude -p` で発火を測る公式実装。実物の skill・名前空間・実行ゲートは測らない | 発火テストの設計で `run_eval.py` を比較対象として明記。ゲート付き skill の 3 段（呼び出し、ゲート通過、手順の実行）は自作のまま |
| 2 | 設計書 7-2、7-10 | 範囲内に公式のハーネスは無い。境界の Agent SDK と claude-trace が補助の候補 | D13 の範囲判定後に 11 節（残課題）へ載せるか決める |
| 3 | 手法整理 2-6（スクリプト単体）、M7 | `claude plugin test` は mod 専用。command 型 hook は plugin-dev の `test-hook.sh`。statusline の hook が command hook 側に当たる見込みは未検証 | 定義を「mod は `claude plugin test`、それ以外は test-hook.sh」と分ける。mod 化する場合の雛形は `mods/agents-md`（2 節の条件付き: mod を書く場合のみ） |
| 4 | 設計書 7-5（C） | `claude plugin tag` が validate・版一致・clean tree を確かめる（docs の記述。手元の版の `--help` と実測は未確認で、dry-run の有無も未確認） | リリース時の C の証跡に tag の結果を残すか検討。手法整理文書に「リリース検査」を足すかは作業指示者。4 節の原則どおり、前提にする前に手元の版で観測する |
| 5 | 設計書 2 節 F 根拠、6-2 `meta.json`、M8 | CHANGELOG / feed.xml が環境の事実確認のトリガ。npm の dist-tags は stable と latest の 2 系統 | `meta.json` に、手元で実測した Claude Code の版（`claude --version`）と配布チャネル（stable / latest）を残す。CHANGELOG / feed.xml は版の事実の根拠として併記する |
| 6 | 設計書 6-6 `evals.json` | agentskills.io の Evaluating skill output quality が skill-creator と同じ形式 | 6-6 の根拠に併記 |
| 7 | 設計書 2 節、7-1・8-1 の手動確認 | mod sec-default は managed 環境で最外層に座り、組織の設定と権限規則を利用者の Plugin から守る。command hook への影響は未確認 | managed 環境での手動確認に「sec-default が有効か」を足すか検討 |

## 8. 作業指示者の判断事項（計画書 8 節・9-4）

| # | 事項 | Fable の仮決定 | 状態 |
|---|---|---|---|
| D4 | `external_plugins/` は棚卸しに載せず L3 の別表に記録のみ | 仮決定で進行 | 承認待ち |
| D5 | docs からリンクされた社員個人のリポジトリは L3 で記録のみ（今回は該当なし。社員の識別は 71 名の集合で近似） | 仮決定で進行 | 承認待ち |
| D6 | pre-submission-checklist は提出しない前提を明記して品質基準として参照可 | 仮決定で進行 | 承認待ち |
| D7 | 終了宣言（6 節）の受理と残存リスク 12 項目の受容 | 草稿 | 受理待ち |
| D11 | blind 探索者を clean な環境（CLAUDE.md 無し、auto-memory と Plugin 無効）で出し直すか | 今回は部分的独立のまま終了宣言に明記。出し直す価値は低い（文脈由来の除外 0、和集合に無い項目 1 件のみ） | 判断待ち |
| D12 | anthropics 配下で著作者が社員個人名の宣言は L1 とする規則（計画書 1-2 に追加） | 決定済み（上書き可） | 承認待ち |
| D13 | 境界 165 件の範囲判定（基準: 結合済みの境界 316 件のうち authority L1 / L2 かつ kind = asset の 164 件 + anthropic-skills の出所未判定 1 行。情報源の境界は含まない。草稿 7 節に理由と「範囲に入れた場合に得られるもの」を列挙）。特に: Agent SDK 系（設計書 7-10 の補助候補）、plugins/measure と Analytics API（利用実績の観測）、security-guidance の pytest（hook の単体テストの実例）、縦割り marketplace 4 件、sandbox-runtime、devcontainer-features、anthropic-skills の出所未判定 8 件 | すべて境界のまま | 判断待ち |
| — | `.claude/settings.json`（WebFetch 9 ドメインと `claude` の 4 コマンド）と `.claude/rules/agent-permission-runtime.md` §3.6 の追記のコミット可否 | 未コミット | 判断待ち |
| D14 | 4 節の改訂案（2026-10-17）の承認。内訳 J-1: SKILL.md の正本を code.claude.com に切り替え、表を 11 行・3 段に組み替える（承認時に survey 2-4、計画書 1-1 の L2 欄と 1-3 の正本の例を同じ内容に直す）/ J-2: 可搬形式の行（4-1 の 2 行目）を休眠行として残すか削るか（claude.ai の Organization 配布で Plugin の skill に 6 項目の制限がかかるかは未確認）/ J-3: 「挙動の正本は手元の版の実挙動」と、食い違い時に CHANGELOG で原因を区別し文書化されていない挙動に依存しない原則 / J-4: 4-5 の方針と 4-1 の表の恒久的な置き場所（`.claude/CLAUDE.md` に方針、表は別ファイルか。cc-relative-info 側にも置くか）/ J-5: 4-4 の食い違いの記録の置き場所と様式 / J-6: 軽量版の定期棚卸しの周期と手順書の置き場所 / J-7: mod の行で d.ts を正本に上げるか | Fable の仮決定（R2 の案を採用） | 承認待ち |
| B-1 | バックログ: 公式情報源の完全な棚卸し手順を本リポジトリのメンテナンス手順書に組み込む。根拠となる作業記録は計画書 1-2、2 節、3-1、3-3、4-2、4-4、5-2、9-1、付録 A、本文書 6 節と 9 節、草稿 12 節、クロスチェック 6〜7 節、p2-merged.jsonl（次回の基準値）。実施は B-2 の手順 5 で完全版が必要と判断したときだけ | 記録 | バックログ |
| B-2 | バックログ: 軽量版の定期棚卸し手順を定義して運用を始める。骨子: (1) 契機 = LLMs リポジトリの日次差分にフィルタ語（計画書 2-5）に当たる変化、手元の `claude --version` の上昇、定期の点検日（周期は J-6）/ (2) 変化のあったチャネルだけを計画書 2 節の列挙方法と付録 A の雛形で再走査し、監視していないチャネル（org 全件、レジストリ、marketplace）は件数・tree SHA・marketplace.json の差分だけを p2-merged.jsonl と比べる / (3) 新規・変更は計画書 1-2 の手続きで権威レベルを判定し再取得して 4-1 の行と段に割り当てる / (4) 食い違いの記録（4-4）、4 節、survey 2-4、残存リスクを更新 / (5) 新しいチャネル種別・新 org・docs サイトの再編・残存リスクの顕在化があれば B-1 の完全版を提案して終える。足りないもの: 起動の契機と周期、差分の取り方、記録の様式、4 節の恒久的な置き場所 | 記録 | バックログ |

## 9. 作業記録（要約）

- Phase 0: P0-A red team（Opus。チャネル候補 10、反証 10、矛盾 5 → 全件採用）、blind 探索者 P0-B（Sonnet 79 件）/ P0-C（Opus 104 件。Fable は未読）
- Phase 1: P1-L、P1-D、P1-G1、P1-G2、P1-C、P1-B（Sonnet 6 体）+ 上限到達と gh 認証後の追加走査。gh は作業指示者がデバイス認証（01:43）。P1-G2 は P1-G1 の後に起動
- Phase 2: P2-R（Sonnet。結合 3 回、再取得 224 件）、P2-V（Opus。穴 10、矛盾 11、再走査の提案）、再走査 1（P1-G2）、再走査 2（P1-G3）、P1-L 補完、P2-M（Opus。草稿）。Fable の抜き取り 17 件
- 変えた前提: E3 は「部分的独立」（注入文脈の経路。R1）。G-5 の著者条件は author_association から著者集合へ。G-6 は `path:` 無しで再実行。出力の上限は費用でなく有限化のため
- 未実施のまま終えたもの（残存リスクに記載）: 深さ 3 のリンク閉包、第三者 org の out 915 repo の木、Packages、`claude` 名の org の 301 件目以降、docs ページの content_sha256 約 80 件

## 変更履歴

- 2026-10-13: 0.9 版。P2-M の草稿を Fable が検証して作成
- 2026-10-17: 0.9.1 版。作業指示者の通読レビュー（§2〜§7）を反映。回答と修正文面は 3 サブエージェントに委任（`official-assets/review-r1-sec2-3.md`、`review-r2-sec4.md`、`review-r3-sec5-7.md`）。§2: 「条件付き」14 件を 6 ケースに分けて内訳を追加、sec-default を managed 環境の行へ移動。§3: 3 活動の説明と列見出し、手法名の注記（probe は改名の記録無し、後ろ 3 行は観点・目的・観測）。§4: 正本 / 準正本 / 参考の 3 段に組み替え（11 行）、SKILL.md の正本を code.claude.com に変更、文書の権威と挙動の権威の分離、docs の反映遅れの扱い、観測手段の表、食い違いの記録、権威外の情報の扱いの方針案（J-1〜J-7 は D14 として承認待ち）。§5: 9 行に戻し「推奨度の理由」列を追加、「—」を廃止。§1・§6・§7 を整合（監視で補える範囲、定義の軸の注記、残存リスク 1 と 11、設計書への影響 3〜5）。§8: D14、バックログ B-1・B-2 を追加
