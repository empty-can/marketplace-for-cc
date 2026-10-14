# 公式のプラグイン開発資産の棚卸し（2026-10-13）— 棚卸し文書と終了宣言の草稿

| 項目 | 内容 |
|---|---|
| 位置づけ | branch「公式のプラグイン開発資産の情報整理」の成果物。計画書 `official-assets-planning-approach_2026-10-13.md`（0.4 版 + 9 節）に沿って Phase 0〜2 と再走査 2 回を実施した結果 |
| 作成 | Claude（Fable 5.1、メインセッション）。P2-M（Opus）の草稿 `official-assets/p2-mapping.md` を Fable が検証して要約し、判定を加えた。資産ごとの全表・境界 165 件・情報源 106 件の URL は草稿を参照 |
| 状態 | **0.9 版（作業指示者の受理待ち）**。D7（終了宣言の受理）、D4〜D6、D11〜D13 の判断で 1.0 にする |
| 証拠 | 結合済みの全件 `official-assets/p2-merged.jsonl`（3,191 行）、検証記録 `p2-verify.md`、クロスチェック `p2-coverage.md`、各チャネルの走査記録 `p1-*.md`、Phase 0 の `p0-*.md`。Fable の抜き取り 17 件は全件一致 |

## 1. 結論

1. **設計中の仕組みは公式資産の二重発明ではない**（survey 2-1 を、org 全件のファイルツリー、code search、docs 全ページ、CHANGELOG、Releases、npm / PyPI、blog / support、Academy、blind 探索 2 名で確認したうえで追認）。作業状態を再現したサンドボックスでのヘッドレス実行、証跡の構造、モデルと effort の固定に相当する L1 / L2 の資産は範囲内に無い。
2. **部分的に重なる公式資産は 3 つ**。設計ではこれらを「自作しない」か「比較対象」にする。
   - plugin-dev 同梱の hook 検査スクリプト（`test-hook.sh`、`validate-hook-schema.sh`、`hook-linter.sh`）= command 型 hook のスクリプト単体テスト（既知。採用済み）
   - skill-creator の `scripts/run_eval.py` = `claude -p` で description が skill を起動させるかを測る**発火テストの公式実装**（新規）。ただし一時 command に description だけを載せて測るため、Plugin に入った実物の skill、名前空間付きの名前、本文の実行ゲートは測らない
   - `claude plugin test` と `claude-code/testing` = **mod（hooks module）のテストキット**（新規）。モデルもネットワークも使わない決定的なテストで、`anthropics/claude-code/tree/main/mods` の 4 mod が `tests/` 付きの実例。command 型 hook・skill・agent は対象外で、本 Marketplace の現行 Plugin（statusline、pre-compact）には当たらない
3. **情報源の階層は「サイト単位」から「権威の対象（タグ）単位」に改める**（4 節）。SKILL.md の形式は agentskills.io、plugin.json / marketplace.json / hooks.json / mod の形式と挙動は code.claude.com、ポリシーは code.claude.com の marketplace-reference と publish、参照実装は claude-plugins-official の `./plugins/*`、変更履歴は `anthropics/claude-code` の CHANGELOG.md。
4. **終了条件は E1〜E4 と E6 を満たし、E5 は再走査 2 回で範囲内の新規資産が 0 件**（6 節の終了宣言）。残存リスクは 12 項目を明記し、監視対象の追加案（5 節）を LLMs リポジトリのバックログに積む。
5. **「あらかじめ把握しておくべき情報源・公開資産はもう他には無い」と言えるか**: Anthropic 管理下のチャネル（docs 3 サイトの全ページ、GitHub org の全リポジトリとファイルツリー、公式 Marketplace、本体の同梱物、レジストリ、blog / support / Academy）を有限集合として全走査し、反証（リンク閉包、blind 探索、公式索引、再走査 2 回）が範囲内の新規資産を出さなかった、という意味で **言える**。言えないのは残存リスク 12 項目の範囲（SNS だけの告知、リンクも名前も無い資産、深さ 3 以降のリンク、第三者 org の中身）で、これは監視に委ねる。**手続きの妥当性の直接の証拠**: survey 作成時に場当たり的に辿り着いた情報源（claude.com/docs/build/overview、agentskills.io、anthropics/skills、agentskills/agentskills、anthropic-agent-skills Marketplace、skill-creator、plugin-dev、knowledge-work-plugins）は、すべて今回の手続きの別チャネル（W-1 の llms.txt、W-8 のリンク閉包、L-2 のローカル Marketplace、G-1 の org 全件、G-11 の木、S-3 / S-5）で独立に再発見された（p1-*.jsonl の channel 欄）。
6. **survey に無かった参照必須の資産**（survey 2-5 に追記）: `claude plugin test` と `anthropics/claude-code/tree/main/mods`（mod のテストキットと実例）、skill-creator の `scripts/run_eval.py`（発火テストの公式実装）、claude.com/docs/plugins/org-sync（Organization 配布の受理条件: `metadata.pluginRoot` の bare name と `bin/` の拒否）、code.claude.com の marketplace-reference#reserved-names（予約名 19 件）と plugins/publish、`anthropics/claude-code` の `feed.xml`（Atom の変更履歴）、claude.com/marketplace/plugins（第三者 Plugin の掲載一覧 336 件 = L3）、`anthropic-experimental` org（権威未確定）、npm の非スコープ `claude-code`（境界）。

## 2. 採用候補（資産 44 件のうち。詳細は草稿 2 節・3 節）

| 判定 | 件数 | 資産 |
|---|---|---|
| 採用（既採用） | 3 | skill-creator（手法 A・発火）、`claude plugin eval`（B）、`claude plugin` の 15 サブコマンド（validate = C、tag、test、marketplace / install） |
| 採用 | 8 | plugin-dev（hook のスクリプト単体、静的レビュー、手動チェックリスト）、`anthropics/claude-code` の CHANGELOG.md、npm `@anthropic-ai/claude-code`（版の固定。dist-tags は stable 2.1.287 / latest 2.1.296 の 2 系統）、`anthropics/claude-code`（監視の起点）、`anthropics/claude-plugins-official` とその marketplace.json（参照実装の正本）、`agentskills/agentskills`（形式の正本）、`anthropics/skills`（skill の実例） |
| 条件付き | 14 | mod を書く場合: `mods/`（diff、agents-md、sec-default、types）、組み込み skill plugin-authoring。CI を導入する場合: `anthropics/claude-code-action`（`plugins` 入力）。参照: skills 側の skill-creator、playground の mods、claude-code と skills の marketplace.json、template/SKILL.md、`$schema` の受理（公式 schema URL は 404） |
| 不採用 | 19 | 複製行 10（cache と木の集約行）、中身の無い playground の hooks / settings / workflows、telemetry mod（利用者の Plugin から使えない）、claude-plugins-community（提出しない前提）、life-sciences の marketplace.json、claude-code-base-action、spec/agent-skills-spec.md（正本は agentskills.io） |

**Fable が草稿に加えた判定**

- `/skill-doctor`（組み込みコマンド。利用実績の観測）は結合済みの一覧に行が無く notes にしか無い。棚卸しでは **L1 の資産（同梱）として数える**。docs の導入版（v2.1.252 以降）と CHANGELOG の初出（2.1.261）が食い違う点は残存リスク 11。
- `claude plugin tag` は 9 手法に対応先が無い（テストではなくリリース操作）。**手法整理文書に「リリース検査」を足すか、C の証跡に tag の結果を含めるかは、手法整理文書の再開時に作業指示者が決める**（影響 11-4）。
- `anthropics/claude-code` の `feed.xml` は P2-M が取得して Atom（1 版 1 entry、最新 v2.1.296）と確認した。結合済みの一覧では unverified のままなので、**確認済みとして扱う**（監視案 5 節）。
- 参照・雛形・監視用の 20 資産は「どの手法にも対応づかない」が欠落ではない。E6 の対応先なしは **2 件（`claude plugin tag`、feed.xml）** と数える。
- 複製の正本: skill-creator は claude-plugins-official 側（`/skill-creator:skill-creator` として入り plugin.json で版を追える。anthropics/skills 側は LICENSE.txt の著作権者行だけ違う）。security-guidance はローカル cache 2.0.8 ではなく marketplace の clone（2.0.13 = GitHub main）。

## 3. E6 マトリクス（9 手法 × 3 活動。資産は P2-R の merged_id）

| 手法 | 開発 | テスト | 配布 |
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

## 4. 情報源の階層（survey 2-4 の更新）

| 権威の対象 | 正本（1 位） | 2 位以下 |
|---|---|---|
| 形式（SKILL.md） | agentskills.io/specification（L2） | code.claude.com/docs/en/skills（Claude Code 固有の frontmatter） |
| 形式（plugin.json、marketplace.json、hooks.json、mod） | code.claude.com の plugins/manifest-reference、plugins/marketplace-reference、hooks、plugins/mods/reference | `claude plugin validate`（実装としての判定）。機械可読な L1 の schema は無い（公式 URL は 404、SchemaStore 版は第三者） |
| 挙動（読み込み、validate、eval、test、headless） | 手元の版の `claude plugin --help` と code.claude.com/docs | docs は最新版を書くので、手元の版と食い違えば `--help` と実測を優先 |
| ポリシー（予約名、公開、組織配布） | code.claude.com の plugins/marketplace-reference#reserved-names、plugins/publish | claude.com/docs の pre-submission-checklist（提出しないが品質基準。D6）、org-rollout、org-sync（Organization 配布の受理条件） |
| 参照実装 | claude-plugins-official の `./plugins/*`（Anthropic 作） | anthropics/skills、anthropics/claude-code の `mods/` |
| 変更履歴 | anthropics/claude-code の CHANGELOG.md（= feed.xml） | code.claude.com の changelog・whats-new、Releases（v2.0.73 以降のみ）・tags |
| 背景 | — | claude.com/resources/articles、anthropic.com/engineering（根拠には使わない） |

## 5. 監視対象の追加案（D3。LLMs リポジトリ側のバックログ。本活動では実装しない）

| 推奨 | サイト | 取得 URL | 方式 |
|---|---|---|---|
| 高 | claude.com/docs | https://claude.com/docs/llms.txt | llms.txt（262〜266 ページ）の差分 |
| 高 | agentskills.io | https://agentskills.io/llms.txt | llms.txt（9 ページ）の差分 |
| 高 | anthropics/claude-code | https://raw.githubusercontent.com/anthropics/claude-code/main/feed.xml（または CHANGELOG.md） | Atom。1 版 1 entry で日付あり |
| 中 | claude-plugins-official | ローカル clone の `.claude-plugin/marketplace.json`（自動更新） | `./plugins/*` の author = Anthropic に絞った差分 |
| 中 | anthropics/skills | 同上の clone | marketplace.json の差分 |
| 低 | platform.claude.com、claude.com の articles、academy.claude.com、Releases の Atom | — | 範囲外が大半、または CHANGELOG と重複 |

## 6. 終了宣言（草稿。D7）

```text
終了宣言（2026-10-13、Claude Code 2.1.296。Phase 1 の開始 01:18 から P2-M の終了 03:55 まで版のずれ無し）
- 定義: 計画書 1 節の L1（Anthropic 一次。anthropics org 配下で著作者が社員個人名でも L1 = D12）/ L2（Anthropic 発の公開標準 = agentskills、MCP は範囲外）。L3 は別表（p2-merged.jsonl の authority L3）。範囲: 計画書 0-2
- 走査したチャネル: ローカル層 L-1〜L-3（L-2b を含む）、列挙可能層 W-1〜W-8、GitHub G-1〜G-12（再走査 1 で G-11 を org 全件に拡大、再走査 2 で G-5 の著者集合を差し替え）、補助 S-1〜S-5
- 件数: 結合済み 3,191 件（7 本 3,329 行から統合 138）。範囲内の L1 / L2 の candidate 141（資産 35 + 情報源 106）、境界 316、新規の L1 / L2 224 件はすべて再取得で確認（確認済み 222、URL の無い 2 件は検証不能）。Fable の抜き取り 17 件は全件一致
- 主な母集団: anthropics org 115 リポジトリ（GraphQL の totalCount と一致。全件に範囲判定と tree SHA）、agentskills 4、anthropic-experimental 2。claude.com/docs 262 ページと agentskills.io 9 ページは sitemap と llms.txt の差 0。code.claude.com は docs_map の全見出しを走査。公式 Marketplace 315 エントリ、Plugin ディレクトリの cache、Claude Code 本体のバンドル内 URL、組み込み skill / agent の一覧。CHANGELOG 全行と Releases 241 件、npm @anthropic-ai 35 + maintainer 検索 43、PyPI org 6。anthropic.com 553 URL、claude.com 3,648 URL、support 361 記事（Claude Code 20）、Academy 308 コース（Claude Code の Plugin 教材 0）。issue は 19,060 件を著者で走査し社員集合 71 名で再走査。wiki 21 件は全て空
- GitHub の制約に当たった探索単位: code search の `path:` は直下の前置一致のみ（org 内は `path:` 無しの再実行と木で解消。org 外の L3 発見は上位 1,000 件のみ）、384 KB 超 1 ファイルは索引外、Packages は 403（read:packages 無し）、`claude` 名の org 検索は 300 件で打ち切り
- 反証の試み: E2 リンク閉包は深さ 2 で非飽和（Anthropic 系の未知は console / support のリダイレクト先が L1 と確定、claude.dev と brand.anthropic.com は未確認、repo は G-1 の全件に含まれる）。E3 blind 2 名（部分的独立。文脈由来 flag 15・除外 0）の L1 / L2 項目 183 件中 182 件が和集合に含まれ、2 節に無いチャネル種別は 2 件（resources.anthropic.com の PDF 配布 = www.anthropic.com/news へリダイレクト、GitHub の Atom = 監視案）。E4 は設計に使っていない索引（agentskills の profile README 4/4、予約名の実体あり 12/12、claude-code-guide の参照項目 6/6）で包含 100%（anthropics 本体の pinned と profile README は 0 件で計算不能）
- E5: 再走査 1（G-11 を out 全 repo へ。署名ありは 5 repo で境界）と再走査 2（G-5 の著者集合。docs に先行する告知 1 件 = claude-code#91870「Mods」。リンク先 `mods/` は W-8 の deep link で既に境界にあった行 P2-R-1254 を candidate に確定したもので、新規ではない）で、範囲内の新規 L1 / L2 資産は 0 件。3 回目は行わない（D2 の範囲内で終了）
- E6: 9 手法 × 3 活動のセル埋め率 74%。「確認済みで無し」7 セル（A × 配布、probe × 開発・テスト、発火 × 配布、利用実績の観測 × 3）。対応先の無い資産は Fable の数え方で 2 件（`claude plugin tag`、feed.xml）。P2-M の草稿は参照・雛形・監視用の 20 資産を含めて 22 と数えている（2 節の判定）
- 残存リスク（定型）: Discord / X / YouTube でしか告知されず docs / CHANGELOG / blog に現れていない資産は検出できない。どこからもリンクされず名前からも関連が分からない資産は E1 / E2 の対象外。LLM 探索者は学習データと注入文脈を共有するため共通の盲点は検出できない。観測環境（版・アカウント・組織設定）に依存する資産は、この環境で見えたものに限る
- 残存リスク（個別）: (1) 公式の JSON Schema が取得できない（404。形式の正本は docs の項目表と validate）、(2) code search の構造的限界（org 外の L3 は上位 1,000 件）、(3) 社員の識別は著者集合 71 名の近似（公開メンバー 0）、(4) L1 の marketplace で owner / author が社員個人名（D12 の規則で L1）、(5) 予約 Marketplace 名のうち公開の実体が無いもの 5 件、(6) docs・README の古い slug / repo 名（別名に統合済み）、(7) sitemap 外の Anthropic ホスト（claude.dev、brand.anthropic.com は未確認）、(8) ローカル cache と marketplace の版ずれ（security-guidance、claude-security）、(9) anthropic-experimental の権威未確定（内容は範囲外）、(10) Packages 403、(11) docs と CHANGELOG の版記述の食い違い（/skill-doctor）、(12) W-8 は深さ 2 で非飽和
- 監視への移行: 5 節の案（作業指示者が LLMs リポジトリのバックログへ。D3）
```

## 7. 設計書 v3.3 と手法整理文書への影響（設計の再開時に反映。本活動では編集しない）

| # | 対象 | 影響 | 推奨対応 |
|---|---|---|---|
| 1 | 設計書 4 節 14、8-1、手法整理 M4 | skill-creator の `run_eval.py` は `claude -p` で発火を測る公式実装。実物の skill・名前空間・実行ゲートは測らない | 発火テストの設計で `run_eval.py` を比較対象として明記。ゲート付き skill の 3 段（呼び出し、ゲート通過、手順の実行）は自作のまま |
| 2 | 設計書 7-2、7-10 | 範囲内に公式のハーネスは無い。境界の Agent SDK と claude-trace が補助の候補 | D13 の範囲判定後に 11 節（残課題）へ載せるか決める |
| 3 | 手法整理 2-6（スクリプト単体）、M7 | `claude plugin test` は mod 専用。command 型 hook は plugin-dev の `test-hook.sh` | 定義を「mod は `claude plugin test`、それ以外は test-hook.sh」と分ける。mod 化する場合の雛形は `mods/agents-md` |
| 4 | 設計書 7-5（C） | `claude plugin tag` が validate・版一致・clean tree を確かめる | リリース時の C の証跡に tag の結果を残すか検討。手法整理文書に「リリース検査」を足すかは作業指示者 |
| 5 | 設計書 2 節 F 根拠、6-2 `meta.json`、M8 | CHANGELOG / feed.xml が環境の事実確認のトリガ。npm の dist-tags は stable と latest の 2 系統 | `meta.json` に Claude Code の版と配布チャネルを残す |
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

## 9. 作業記録（要約）

- Phase 0: P0-A red team（Opus。チャネル候補 10、反証 10、矛盾 5 → 全件採用）、blind 探索者 P0-B（Sonnet 79 件）/ P0-C（Opus 104 件。Fable は未読）
- Phase 1: P1-L、P1-D、P1-G1、P1-G2、P1-C、P1-B（Sonnet 6 体）+ 上限到達と gh 認証後の追加走査。gh は作業指示者がデバイス認証（01:43）。P1-G2 は P1-G1 の後に起動
- Phase 2: P2-R（Sonnet。結合 3 回、再取得 224 件）、P2-V（Opus。穴 10、矛盾 11、再走査の提案）、再走査 1（P1-G2）、再走査 2（P1-G3）、P1-L 補完、P2-M（Opus。草稿）。Fable の抜き取り 17 件
- 変えた前提: E3 は「部分的独立」（注入文脈の経路。R1）。G-5 の著者条件は author_association から著者集合へ。G-6 は `path:` 無しで再実行。出力の上限は費用でなく有限化のため
- 未実施のまま終えたもの（残存リスクに記載）: 深さ 3 のリンク閉包、第三者 org の out 915 repo の木、Packages、`claude` 名の org の 301 件目以降、docs ページの content_sha256 約 80 件
