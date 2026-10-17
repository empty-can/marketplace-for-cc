# review-r2-sec4: 棚卸し文書 §4「情報源の階層」の再検討（回答案と修正文面）

作成: Claude（Opus 5.5、サブエージェント）、2026-10-17。**草稿であり作業指示者の承認ではない**。棚卸し文書・計画書・survey は編集していない。
略記: 「棚卸し」= `official-assets-inventory_2026-10-13.md`、「草稿」= `official-assets/p2-mapping.md`、「計画書」= `official-assets-planning-approach_2026-10-13.md`、「coverage」= `official-assets/p2-coverage.md`、「full NNNNN」= `C:\cc-workspace\LLMs\official-llms-txts\code.claude.com\docs\llms-full.txt` の行番号（2026-10-17 時点のローカル版）、「spec」= https://agentskills.io/specification（2026-10-17 に WebFetch で取得）。

## 1. 確認事項への回答

### 1-1. 確認事項 1（SKILL.md の正本）

> `code.claude.com/docs/en/skills`ではなく`agentskills.io/specification`を正本として扱うことが本当に適切かどうか、再検討してください。

**回答**: 適切ではない。本 Marketplace で SKILL.md について判断するときの正本は https://code.claude.com/docs/en/skills にし（挙動の問いでは、その上に手元の版の実挙動を置く。1-2）、agentskills.io/specification は準正本に下げる。agentskills.io が正本になるのは「Claude Code 以外へ持ち出せる形式か」という別の問いだけで、本 Marketplace では今のところこの問いが生じない（休眠行として残す案。2 節の 2 行目）。

**根拠**
- 現行の順位は再評価されずに引き継がれた: 草稿 9 節の備考「現行 1 位を維持」、survey 2-4 の旧階層「1. agentskills.io」。
- Claude Code の docs は、自分を標準の拡張と位置づけ、受け付ける項目を自分の表で定義している: full 43222「Claude Code skills follow the Agent Skills open standard … Claude Code extends the standard」、full 43613「Claude Code accepts every field in the table above」。
- 食い違いは一過性のものではなく、すでに存在する（full 43590〜43609 の frontmatter 表と spec の表を比較）:

| 項目 | spec | Claude Code の docs |
|---|---|---|
| `name` | 必須。親ディレクトリ名と一致しなければならない | 任意。既定はディレクトリ名。`deploy-staging/` に `name: deploy` で `/deploy` になる（full 43590、43638） |
| `description` | 必須。1〜1024 字 | 推奨。省略すると本文の最初の行を使う。`when_to_use` と合わせて 1,536 字で切る（full 43591） |
| `metadata` | 文字列から文字列への map | 自由形式の map。map でない値は捨てる（full 43607） |
| `allowed-tools` | 空白区切りの文字列。Experimental で実装により異なる | 空白区切り・カンマ区切りの文字列、または YAML の list。付与はそのターン限り（full 43597） |

  spec を正本にすると、`name` を省いた SKILL.md（Claude Code では正しい）を「誤り」と判定してしまう。
- 逆方向は安全: spec の 6 項目だけで書いた frontmatter は Claude Code でそのまま読める（full 43628）。spec を準正本として参照しても、Claude Code 上で困ることはない。
- docs が spec に定義を委ねている項目がある（`license`、`compatibility` は「as defined by the Agent Skills spec」。full 43608〜43609）。これらの項目と、ディレクトリ構成の慣行（`scripts/`、`references/`、`assets/`）については、委任によって spec が実質の正本になる（2 節 4-2 の委任規則）。

**Fable の暫定見解への賛否**: 賛成（問いを 2 つに分けて、Claude Code 側を優先する）。補強は 2 点。(a)「食い違いが出たら」ではなく、すでに食い違っている。(b) 可搬性の問いは本 Marketplace では休眠している（計画書 0-2: ディレクトリへ提出しない、claude.ai / Cowork の面は範囲外）。ただし、claude.ai の Organization 配布（org-sync）で Plugin の skill に 6 項目の制限がかかるかは確認できていない（本作業では org-sync を読んでいない）。制限がかかるなら休眠ではない（5 節 J-2）。

### 1-2. 確認事項 2（実挙動を情報源に含めるか、docs との順位）

> 権威情報現に Claude Code の実挙動を含めるべきか否か、含める場合、公式ドキュメントとの権威情報としての順位（いずれを正本にすべきか）を再検討してください。

**回答**
- 理解は合っている。現行 §4 は 2 行目に「`claude plugin validate`（実装としての判定）」、3 行目の正本に「手元の版の `claude plugin --help`」を置いており、実挙動の観測結果をすでに情報源として扱っている。ただし、文書との関係は書いていない。
- 実挙動は含めるべき。「手元の版でどう動くか」という問いの正本は手元の版の Claude Code 本体の実挙動で、docs はその準正本（開発元による文書化）になる。文書としての正本は引き続き docs。
- ただし、実挙動が正本になる範囲には境界がある。(a) 実挙動が正本になるのは、挙動と、形式のうち「受理されるか」の側だけ。(b) claude.ai 側の受理条件（Organization 配布）と公開ポリシーは手元で観測できないので、文書が正本。(c) 変更履歴（どの版で変わったか）は、過去の版を観測しない限り CHANGELOG.md が正本。(d)「この先も依存してよいか」については、docs に書かれた挙動だけが約束になる。文書化されていない挙動は予告なく変わる。
- 実挙動は直接は見えず、観測手段（`--help`、validate / eval / test / tag の判定、`--plugin-dir` での読み込み、`claude -p`）を通して読む。手段ごとに見える範囲は限られる（例: ルートでの `validate .` は skill / agent / hook の中身を検査しない。`.claude/CLAUDE.md`「ローカルでの開発・検証」）。そこで観測手段は情報源の段に入れず、別表にする（2 節 4-3）。観測結果は、版・環境・手段・日時を付けて記録したものだけを根拠にする（計画書 5-1 の証拠ポリシーと同じ考え方）。

**根拠**
- docs 自身が、版ごとの事実を本体に委ねている: full 75468「Run `claude plugin --help` in your shell to see which subcommands your version has」。
- docs の changelog ページは CHANGELOG.md から生成したもの（full 2663）。CHANGELOG は docs より先に変更が現れる文書で、docs が未反映の期間に頼れる文書になる（計画書 0-4「docs より先に機能・資産が現れる場所」、草稿 10 節。いずれも判断で、リリースとの同時性は実測していない）。
- 文書化されていない挙動は存在し、変わり、不具合として直されることもある: full 5739（2.1.266）「the undocumented `CLAUDE_CODE_USE_GATEWAY` … began forcing Cloud-gateway sign-in」、full 8793（2.1.153）「Fixed `Agent` tool … running in an undocumented temporary worktree」。
- docs は最新版を前提に、版の下限を注記する（例: full 43603 の `background` に「Requires Claude Code v2.1.218 or later」）。手元の版が古ければ docs が先行し、リリース直後なら docs が遅れる（作業指示者の観測）。ずれは両方向に起きる。配布の系統も 1 つではない（npm の dist-tags は stable 2.1.287 / latest 2.1.296 の 2 系統。棚卸し §2）。棚卸しは 2.1.296 で行ったが、ローカルの full にはすでに 2.1.302（2026-10-16）が載っている（full 2667）。

**Fable の暫定見解への賛否**: 「文書の権威と挙動の権威を分ける」と「観測結果は検証手段として別枠にする」には賛成。「食い違えば docs の反映遅れとして扱う」には一部反対する。食い違いの原因は (1) docs の未反映、(2) 手元の版が docs より古い、(3) 本体の不具合または文書化されていない挙動、の 3 つある。(3) を (1) として扱うと、いずれ直される挙動に依存してしまう。そこで、CHANGELOG で手元の版と docs の版の間の変更を確かめて原因を区別する手順を、§4 の冒頭に入れた（2 節）。

### 1-3. 確認事項 3（表全体の見直し）

> 1.と2.で指摘した行以外の権威の対象行 … にも、1.と2.で指摘した内容と同じ課題が散見されるため、表全体を見直してください。

**回答**: 次の問題を確認し、2 節の差し替え案で全行を組み替えた（7 行を 11 行に）。

| 現行の行 | 問題 | 差し替え案での扱い |
|---|---|---|
| 形式（plugin.json 等） | 2 位以下の列に、観測手段（validate）と注記（schema が無い）が混ざっている | validate は観測手段の表へ移す。受理の最終判定は挙動の行に置く。mod は別の行にし、d.ts を準正本にする（草稿 9 節の備考） |
| 挙動 | 正本に種類の違う 2 つ（`--help` = 実挙動、docs = 文書）が並ぶ。2 位以下の列に情報源ではなく規則が入っている。根拠「docs は最新版を書く」は docs の遅れを想定していない | セッション内の挙動と CLI の 2 行に分ける。どちらも正本 = 手元の版の実挙動、準正本 = docs と CHANGELOG |
| ポリシー | org-sync を 2 位以下に置いているが、棚卸し §1-6 と survey 2-5 は「`.claude/CLAUDE.md` の規約の正本」と書いている（文書内の矛盾）。提出しないのに pre-submission-checklist を 2 位以下に置いている | 命名・公開（code.claude.com）と Organization 配布（org-sync が正本）の 2 行に分ける。checklist は参考に移す（D6） |
| 参照実装 | 規範ではない実例を「正本」と呼び、docs と食い違ったときの規則が無い。cache と clone の版がずれている（残存リスク 8） | 実例は形式・挙動の根拠にしないと明記する。読むのは marketplace の clone |
| 変更履歴 | 正本は妥当。ただし docs 本文の版記述との食い違い（残存リスク 11、`/skill-doctor`）を解く規則が無い | 「版の初出は CHANGELOG が docs 本文に勝つ」と明記する。docs の changelog ページは生成物なので準正本 |
| 背景 | 正本が「—」の行は、権威の対象ではなく段にあたる | 各行の「参考」列に吸収する |
| （無い） | agentskills.io の skill-creation ページ（草稿 4 節で参照実装タグ）と、docs が委ねている evals の形式の置き場所が無い | 「作り方・評価の推奨」の行を新しく作る |

加えて、計画書 1-3 の「正本の例」も §4 と食い違っている（SKILL.md → agentskills.io、ポリシー → claude.com/docs）。承認時に一緒に直す箇所は 5 節 J-1。

### 1-4. 確認事項 4-1（2 位以下を参照するか、全件か）

> 「2 位以下」の情報源は参照するのでしょうか？参照する場合、記載されている全ての情報源を参照するのでしょうか？それとも一部だけでしょうか？

**回答**: 現行 §4 には参照規則が無い（規則に近い記述は、挙動の行の「食い違えば `--help` と実測を優先」と、背景の行の「根拠には使わない」だけ）。差し替え案では段ごとに規則を置いた。正本は、判断を確定する前に必ず確認する。準正本は、条件に当たるときに、該当するものだけを読む（全件ではない）。参考は根拠に使わない（2 節 4-2）。Fable の見解（3 段と段ごとの規則）に賛成。

### 1-5. 確認事項 4-2（参照する/しないの判別、準正本内の順位）

> 参照する/しないをどのように判別する想定でしょうか？ … 「2 位以下」に記載されている情報源を、更に権威性で順位を付ける必要は無いのでしょうか？

**回答**: 参照する/しないは条件で判別する。(a) 正本に記述が無い、(b) 正本の記述が曖昧、(c) 正本が定義を準正本に委ねている、(d) docs が未反映の期間である（このときは準正本の CHANGELOG を読む）。条件に当たった準正本のうち、問いの主題を扱っているものだけを読む。準正本の中をさらに細かく順位づける必要は低い。準正本どうしが食い違ったら、横に比べて決めるのではなく、上（正本、挙動なら観測）に戻して決める方が確実だから。順位づけは「セル内の記載順を仮の優先順とする」に留める。

### 1-6. 確認事項 4-3（正本は 1 つか、正本/準正本、3 段目の価値）

> 正本は一つである必要はないのでしょうか？ … 「正本」「準正本」と分けた方が実態に合うのではないでしょうか。 … 序列3位 … を記載する価値があるか無いかを検討してください。

**回答**
- 1 つの問いに判定を下す正本は 1 つであるべき。現行の挙動の行に正本が複数あるのは、種類の違う 2 つ（実挙動と文書）が並んでいるためで、対象の切り方が粗いことの表れ（Fable の見解に賛成）。差し替え案では、各行の正本は 1 種類（実挙動、または同じ発行元の reference ページ群）にした。同じ発行元のページが複数並ぶ場合も、主題を分け合っている（plugin.json は manifest-reference、marketplace.json は marketplace-reference）ので、1 つの問いに 2 つの正本が当たることはない。
- 「1 位 / 2 位以下」を「正本 / 準正本」に改めることに賛成。
- 3 段目（参考）は置く価値がある。理由は 2 つ。(1) anthropic.com/engineering と claude.com/resources/articles は、計画書 1-1 ではドメインによって L1（Anthropic 一次）になるが、規範ではない。段が無いと、根拠に使われてしまうか、存在ごと忘れられるかのどちらかになる。(2) 設計の意図や背景（なぜそうなっているか）は、docs より記事の方が詳しいことがあり、設計判断の材料になる。
- 作業指示者の例の「Anthropic 社員の blog」は 2 種類に分かれる。会社の engineering blog は L1 で、参考の段に入る。社員個人の blog・SNS は、計画書 1-1 と 1-4 B2 で L3 または対象外になる。後者は表に載せず、3 節の方針（根拠に使わない）で扱う。したがって 4 段目は要らない。

### 1-7. 確認事項 4-4（権威情報源外の扱い、明記の有無）

> 権威情報源に含まれない情報源は情報源と扱わない（＝そのような情報源から得られる情報はインプットに含めない）という方針で合っていますか？合っている場合、他のいずれかのドキュメントにその方針は明記されていますか？

**回答**: 方向は合っているが、「インプットに含めない」より「根拠に使わない。着想や発見の手がかりには使ってよい」とする方が妥当。計画書自身が、権威の無いチャネルを発見の装置として使っている（2-3 の S-3「権威は無い。見落とし検出のみ」、2-6 の G-3「権威の根拠にしない」）。入力から完全に外すと、docs に未反映の新機能を知る経路を失う。
明記の状況: 活動を限った記述はある（計画書 1-1「L3 … 挙動や形式の根拠には使わない」、2-3 の S-3、G-3、棚卸し §4 の背景の行）。しかし、日常の Plugin 開発に効く一般方針はどこにも無い（`.claude/CLAUDE.md` には docs のローカル参照先の節しかない）。棚卸し、計画書、survey、草稿、coverage、`.claude/CLAUDE.md` を Grep して確認した。Fable の見解に賛成。補足として、Claude 自身の学習済み知識も、権威外の情報源として方針に明記すべき（計画書 0-4 が「LLM 同士は学習データを共有」と述べるとおり、モデルの記憶は版の事実を保証しない）。方針案は 3 節。

### 1-8. 確認事項 4-5（手順化に足る作業記録があるか）

> 権威情報源の更新（＝定期的な棚卸し）を手順化できるだけの十分な内容の作業記録は残っているでしょうか。

**回答**: 完全版の棚卸しを手順化できるだけの記録は残っている。ただし定期運用には重すぎる（13 体。計画書 8 節 D1）ので、軽量版の手順は新たに定義する必要がある（Fable の見解に賛成）。バックログ案は 4 節（2 件）。
- 残っている記録: 計画書 1-2（権威判定の手続き）、2 節（チャネルごとの列挙方法と完了の判定）、2-5（フィルタ語）、2-6（GitHub の探索単位）、3-1（終了条件 E1〜E6）、3-3（終了宣言の雛形）、4-2（分割表）、4-4（記録様式）、5-2（統合手順）、9-1（再走査で変える変数）、付録 A（プロンプトの雛形 A-0〜A-10）。基準値は棚卸し §6 の母集団の件数と、p2-merged.jsonl（3,191 行。G-1 の全 repo に tree SHA）。実績は棚卸し §9、草稿 12 節、coverage 6〜7 節。各チャネルの p1-*.md にある「走査の記録」は棚卸しの証拠欄が挙げているが、本作業では読んでいない（未確認）。
- 足りないもの: 起動の契機と周期、チャネルごとの差分の取り方、食い違い記録の様式、§4 の恒久的な置き場所。

## 2. §4 の差し替え案（そのまま貼れる形）

```markdown
## 4. 情報源の階層（survey 2-4 の更新。2026-10-17 改訂）

本 Marketplace は Claude Code 専用で、ディレクトリへは提出しない（計画書 0-2）。Claude Code に関する問いは Claude Code の docs と実挙動で決める。他クライアント共通の標準（agentskills.io）が効くのは、可搬性の問いと、docs が定義を委ねた項目だけ。
**文書の権威と挙動の権威を分ける。** 挙動の正本は手元の版（`claude --version` を記録する）の Claude Code 本体の実挙動で、4-3 の観測手段で読む。code.claude.com の docs は開発元による文書化で、文書の正本であり、挙動の準正本でもある。claude.ai 側の受理条件、公開ポリシー、変更履歴は手元で観測できないので、文書が正本。
**docs の反映遅れへの扱い**: docs はリリースから数日遅れて反映されることがあり、逆に手元の版が docs より古いこともある。実挙動と docs が食い違ったら、CHANGELOG.md で手元の版と docs の版の間の変更を確かめる。説明が付けば実挙動に従う。説明が付かなければ「文書化されていない挙動」として版・環境と一緒に記録し、当面は実挙動に従うが依存は避け、版が上がるたびに確かめ直す（不具合として直されることがある。例: CHANGELOG 2.1.153）。

### 4-1. 権威の対象ごとの情報源

| 権威の対象 | 正本 | 準正本 | 参考 | 参照規則・食い違い時の扱い |
|---|---|---|---|---|
| 1. SKILL.md（Claude Code が読む形式と frontmatter） | https://code.claude.com/docs/en/skills（frontmatter の表、Using skill frontmatter outside Claude Code、命名の表） | https://agentskills.io/specification（docs が委ねる `license` / `compatibility` の意味、`scripts/` 等の構成の慣行）、https://code.claude.com/docs/en/plugins/components（Plugin 内の配置） | https://claude.com/docs/skills/how-to、https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills | 食い違ったら docs に従う（例: `name` は spec では必須でディレクトリ名と一致、docs では任意で既定はディレクトリ名）。読み込まれるかの最終判定は 5 行目 |
| 2. SKILL.md の可搬形式（休眠。claude.ai への投稿、Skills API、`package_skill.py` を使うときだけ） | https://agentskills.io/specification | https://code.claude.com/docs/en/skills#using-skill-frontmatter-outside-claude-code（使える 6 項目と unexpected key のエラー） | https://github.com/agentskills/agentskills の skills-ref（デモ用途） | 現在は該当する配布経路が無い。spec の 6 項目だけで書けば Claude Code でもそのまま読める |
| 3. Plugin の構成ファイル（plugin.json、marketplace.json、hooks/hooks.json、agents/*.md、ディレクトリ構成） | https://code.claude.com/docs/en/plugins/manifest-reference、https://code.claude.com/docs/en/plugins/marketplace-reference、https://code.claude.com/docs/en/hooks、https://code.claude.com/docs/en/plugins/components、https://code.claude.com/docs/en/sub-agents | https://code.claude.com/docs/en/plugins/create-marketplace、https://code.claude.com/docs/en/plugins/create（解説ページ。reference と食い違ったら reference に従う） | https://claude.com/docs/plugins/build | 受理されるかの最終判定は、手元の版での読み込み（5 行目）。`claude plugin validate` は観測手段（4-3）。機械可読な公式の schema は無い（`$schema` の URL は 404。SchemaStore 版は権威外） |
| 4. mod（hooks module）の形式と API（mod を書く場合だけ） | https://code.claude.com/docs/en/plugins/mods/reference、https://code.claude.com/docs/en/plugins/mods/api | https://github.com/anthropics/claude-code/blob/main/mods/types/claude-code.d.ts（機械可読の型。main の版） | https://claude.com/resources/articles/claude-code-mods | docs と d.ts が食い違ったら、手元の版の `claude plugin test` と実挙動で決める（d.ts は手元の版より新しいことがある） |
| 5. 挙動: セッション内（読み込み、skill の発火、hook・statusline の実行、agent、`/reload-plugins`） | 手元の版の実挙動（4-3 の観測手段で、版・環境・手段・日時を付けて記録したもの） | https://code.claude.com/docs/en/plugins/loading、https://code.claude.com/docs/en/skills、https://code.claude.com/docs/en/hooks、https://code.claude.com/docs/en/sub-agents、https://code.claude.com/docs/en/statusline、https://code.claude.com/docs/en/debug-your-config。docs に未反映の版は https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md | https://claude.com/resources/articles/how-to-configure-hooks、https://claude.com/resources/articles/steering-claude-code-skills-hooks-rules-subagents-and-more | 食い違ったら冒頭の手順に従う。観測していない挙動は docs を根拠にしてよい（「docs による。未観測」と書く）。設計やリリースの前提にする挙動は観測する |
| 6. 挙動: CLI（`claude plugin` のサブコマンドと option、validate / eval / test / tag の判定、`claude -p`） | 手元の版の `claude … --help`、終了コード、出力 | https://code.claude.com/docs/en/plugins/cli-reference、https://code.claude.com/docs/en/cli-reference、https://code.claude.com/docs/en/plugin-evals、https://code.claude.com/docs/en/headless、https://code.claude.com/docs/en/plugins/mods/test | — | サブコマンドと option の一覧は `--help` を見る（docs 自身がそう委ねている）。意味・既定値・終了コードの説明は docs を見る。食い違ったら冒頭の手順に従う |
| 7. 版と変更履歴（どの版で何が変わったか） | https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md（= https://raw.githubusercontent.com/anthropics/claude-code/main/feed.xml） | https://code.claude.com/docs/en/changelog（CHANGELOG.md からの生成物）、npm `@anthropic-ai/claude-code` の dist-tags（stable / latest の版）、https://github.com/anthropics/claude-code/releases（v2.0.73 以降のみ） | https://code.claude.com/docs/en/whats-new（週次）、https://www.anthropic.com/news | 版の初出については、CHANGELOG が docs 本文の「Requires vX」に優先する（残存リスク 11 の解消）。手元の版は `claude --version` で確かめる |
| 8. 命名・公開のポリシー（予約名、Marketplace の公開） | https://code.claude.com/docs/en/plugins/marketplace-reference#reserved-names、https://code.claude.com/docs/en/plugins/publish | https://code.claude.com/docs/en/plugins/host-marketplace、https://code.claude.com/docs/en/plugins/security | https://claude.com/docs/plugins/pre-submission-checklist（提出はしないが、品質基準として参照する。D6） | 方針は文書が正本。CLI が強制する部分があれば観測でも確かめ、食い違ったら冒頭の手順に従う |
| 9. claude.ai の Organization 配布の受理条件（`metadata.pluginRoot` の bare name、トップレベルの `bin/` など） | https://claude.com/docs/plugins/org-sync | https://claude.com/docs/plugins/org-rollout、https://code.claude.com/docs/en/plugins/org | https://claude.com/resources/articles/organization-skills-and-directory | claude.ai 側の受理は手元で観測できないので、文書が正本。`.claude/CLAUDE.md` の該当規約の根拠（survey 2-5） |
| 10. 参照実装（Anthropic 自身の作例） | anthropics/claude-plugins-official の `./plugins/*`（author = Anthropic。読むのは `~/.claude/plugins/marketplaces/claude-plugins-official/` の clone で、cache ではない） | https://github.com/anthropics/skills、https://github.com/anthropics/claude-code/tree/main/mods | https://github.com/anthropics/claude-code-playground、https://claude.com/resources/articles の作例記事 | 実例は作り方の手本で、形式・挙動の根拠にはしない。docs と食い違ったら docs に従う（実例が古いことがある）。複製があるときは claude-plugins-official 側を採る（棚卸し §2） |
| 11. 作り方・評価の推奨（skill の書き方、description の最適化、評価の方法） | https://code.claude.com/docs/en/skills、https://code.claude.com/docs/en/plugin-evals。ただし evals.json の形式と反復の手順は、docs が委ねる https://agentskills.io/skill-creation/evaluating-skills | https://agentskills.io/skill-creation/best-practices、https://agentskills.io/skill-creation/optimizing-descriptions、https://agentskills.io/skill-creation/using-scripts | https://claude.com/resources/articles/improving-skill-creator-test-measure-and-refine-agent-skills、https://claude.com/resources/guides/the-complete-guide-to-building-skills-for-claude | 推奨は指針であり、形式・挙動の根拠にはしない。食い違ったら code.claude.com に従う |

### 4-2. 段ごとの参照規則

- **正本**: その対象で判断を確定する（設計に書く、リリースする）前に、必ず確認する。食い違ったら正本を採る。正本が定義を明示的に委ねている項目は、委ね先がその項目の正本になる（例: 11 行目の evals.json）
- **準正本**: 正本に記述が無い、曖昧、または正本が委ねているとき、あるいは docs が未反映の期間に、問いの主題を扱うものだけを読む。URL と取得日を付ければ根拠として引用してよい。準正本どうしが食い違ったら、セル内の記載順で仮に採る。挙動に関わる食い違いは観測で決める
- **参考**: 根拠には使わない。背景や意図の理解と、新しい資産・変更に気づく手がかりにだけ使う。参考で知ったことは、正本・準正本・観測で裏付けてから使う
- **表に無い情報源**: 「権威情報源外の情報の扱い」の方針に従う

### 4-3. 観測手段（挙動の正本を読む手段。情報源ではない）

| 手段 | 見えるもの | 見えないもの・注意 |
|---|---|---|
| `claude --version` | 手元の版 | すべての観測記録に付ける |
| `claude plugin --help`、`claude plugin <sub> --help` | その版にあるサブコマンドと option | option の意味や既定値の詳細（docs で確かめる） |
| `claude plugin validate <plugin>` / `validate .` | マニフェストの構文・スキーマが受理されるか | ルートでは skill / agent / hook の中身を検査しない。通っても読み込み時の挙動は保証されない |
| `claude plugin tag` | validate、plugin.json と Marketplace エントリの版の一致、clean tree | タグを作るリリース操作を伴う |
| `claude plugin eval` / `claude plugin test` | 実際のプロンプトでの効果 / mod の決定的なテスト | eval はモデルの揺らぎを含む。test は mod 専用 |
| `claude --plugin-dir` と `/reload-plugins`、`/context`・`/hooks`・`/doctor`、`claude -p` | 実際に読み込まれたもの、発火・実行の有無 | 設定、managed の方針、アカウント、OS に左右されるので、環境を記録する |

### 4-4. 食い違いの記録

docs と実挙動の食い違い、docs と CHANGELOG の食い違いは、版・環境・観測手段・docs の該当箇所と取得日・CHANGELOG の確認結果を 1 行にまとめて記録する。版が上がるたびに見直し、docs に反映されたものは閉じる。
```

## 3. 方針の明文化案: 「権威情報源外の情報の扱い」

> **権威情報源外の情報の扱い**: §4 の表（正本・準正本・参考）に無い情報源は、判断の根拠に使わない。これには、第三者の blog・記事・Q&A、コミュニティのリスト、SchemaStore などの第三者のスキーマ、Discord / X / YouTube の投稿、Anthropic 社員個人の公開物（L1 からリンクされていれば L3 として記録だけする）、そして Claude 自身の学習済み知識が含まれる。存在を知る手がかり、検索語、仮説の着想には使ってよい。使った場合は、正本・準正本・手元の版の観測で裏付けてから採用し、出所には裏付けた側を書く。裏付けられないものは「未確認」と明記して判断から外す。表の「参考」段も根拠には使わないが、Anthropic の意図や背景の説明として引用はしてよい。

置き場所の提案: `.claude/CLAUDE.md` の「Claude Code に関する公式ドキュメントのローカル参照先」節の直前に、「情報源の権威」節として置く。毎セッション読み込まれるため。path-scoped rule は該当ファイルを読んだときにしか読み込まれない（`.claude/CLAUDE.md` の文字コード節の注記と同じ理由）。定義の詳細（L1〜L3、判定の手続き）は計画書 1-1・1-2 を、表は §4（または恒久的な置き場所。J-4）を参照させる。

## 4. バックログ案（確認事項 4-5）

### B-1. 公式情報源の完全な棚卸し手順を、本リポジトリのメンテナンス手順書に組み込む

- 根拠となる作業記録: 計画書 1-2、2 節（2-1〜2-6）、3-1、3-3、4-2、4-4、5-2、9-1、付録 A。棚卸し §6（母集団の件数 = 次回の基準値）と §9。草稿 12 節。coverage 6〜7 節。p2-merged.jsonl。各 p1-*.md の「走査の記録」（未読。棚卸しの証拠欄による）
- 内容: 計画書の Phase 0〜2 を、再利用できる手順に書き直す。日付・版・件数を変数にし、付録 A の雛形と D1 の上限値を流用し、終了宣言の雛形（3-3）を付ける。実施するのは、B-2 の手順 5 で完全版が必要と判断したときだけ

### B-2. 軽量版の定期棚卸し手順を定義して運用を始める

- 根拠となる作業記録: 棚卸し §5（監視対象の追加案）、計画書 8 節 D3（監視の追加は LLMs リポジトリのバックログ）、計画書 2 節と付録 A、p2-merged.jsonl（差分の基準値）、本書 2 節 4-4（食い違いの記録）
- 手順の骨子:
  1. **契機**: (a) LLMs リポジトリの日次差分（現在は code.claude.com の llms.txt / llms-full.txt。§5 が実装されれば claude.com/docs と agentskills.io の llms.txt、feed.xml も加わる）に、計画書 2-5 のフィルタ語に当たる変化がある、(b) 手元の `claude --version` が上がった、(c) 定期の点検日（周期は J-6）
  2. **対象の絞り込み**: 変化のあったチャネルだけを、計画書 2 節の該当チャネルの「列挙方法」と「完了の判定」、付録 A の雛形を使って再走査する（1 チャネルに 1 エージェント）。監視していないチャネル（G-1 の org 全件、W-5 のレジストリ、L-2 の marketplace）は、定期の点検日に件数・tree SHA・marketplace.json の差分だけを p2-merged.jsonl と比べる
  3. **判定と割り当て**: 新しい情報源や変わった情報源は、計画書 1-2 の手続きで権威レベルを判定し、URL と取得日を付けて再取得したうえで（P2-R と同じ方式）、§4 の行と段に割り当てる
  4. **記録の更新**: 食い違いの記録（4-4）を見直し、docs に反映されたものを閉じる。§4、survey 2-4、終了宣言の残存リスクを更新する
  5. **完全版への切り替えの判断**: 新しいチャネルの種別、新しい org、docs サイトの再編、残存リスクの顕在化のいずれかがあれば、B-1 の完全版を作業指示者に提案して終える

## 5. 作業指示者に決めてもらう点

| # | 事項 | 補足 |
|---|---|---|
| J-1 | SKILL.md の行の正本を code.claude.com に切り替え、表を 11 行・3 段に組み替えることの承認 | 承認する場合、同時に直す箇所: 棚卸し §1 の結論 3、§2 の「`agentskills/agentskills`（形式の正本）」、survey 2-4、計画書 1-1 の L2 欄「SKILL.md 形式の正本」、計画書 1-3 の正本の例（SKILL.md → agentskills.io、ポリシー → claude.com/docs） |
| J-2 | 可搬形式の SKILL.md の行（2 行目）を休眠行として残すか、削るか | claude.ai の Organization 配布で Plugin の skill に 6 項目の制限がかかるかは未確認（org-sync は未読）。かかるなら休眠ではなく現役の行になる |
| J-3 | 「挙動の正本は手元の版の実挙動」とする原則と、食い違ったときの扱い（文書化されていない挙動に依存しない）の承認 | Fable の暫定見解（「docs の反映遅れとして扱う」）より狭い。1-2 を参照 |
| J-4 | 方針の段落（3 節）と §4 の表の恒久的な置き場所 | `.claude/work/` は作業記録の場所。`.claude/CLAUDE.md` に方針を置き、表は別ファイルにするかどうか。設計・統制の正本である cc-relative-info 側にも置くかどうか（ルートの CLAUDE.md） |
| J-5 | 食い違いの記録（4-4）の置き場所と様式 | 版・環境・観測手段・docs の箇所・CHANGELOG の確認結果の 5 項目を想定 |
| J-6 | 軽量版の定期棚卸しの周期と、手順書の置き場所 | 本リポジトリにメンテナンスの手順書があるかは本作業の範囲外で未確認（auto-memory の索引に、skill のメンテナンス設計の記録 `.claude/workspace/skill-maintenance/` がある） |
| J-7 | mod の行（4 行目）で d.ts を正本に上げるか、mod を書くときに判定し直すか | d.ts（516 KB）は未読（草稿 12 節） |

---

作業の記録: WebFetch 1 回（https://agentskills.io/specification）。llms-full.txt は Grep ツールで行を特定し、該当行だけを sed / awk の行指定で取り出した（全文は読んでいない。指示の「Grep ツールのみ」からの逸脱として記録する）。指定外のファイルは読んでいない。
