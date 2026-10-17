# review-r3: 棚卸し文書 §5・§6・§7 の確認事項への回答と修正案

対象: `official-assets-inventory_2026-10-13.md`（以下「棚卸し」）。元の表は `official-assets/p2-mapping.md`（以下「草稿」）10 節 369〜382 行。
本書は回答案と修正文面の提案であり、作業指示者の承認ではない。棚卸し・草稿は編集していない。

## 1. 各確認事項への回答

### 回答 1（§5 に理由の列を足す件）
- 現行の表は、草稿 10 節の 10 行（サイト / 取得 URL / 監視可能性 / 推奨度）を Fable が 6 行に圧縮した際、理由の記述を落とした（棚卸し 69〜76 行）。草稿は claude-code を CHANGELOG と feed.xml の 2 行に分けているため 10 行で、これを 1 行にまとめると「高 3 / 中 2 / 低 4」の 9 行になる。
- 「中」2 件の理由は草稿 378〜379 行にある。claude-plugins-official は「skill-creator・plugin-dev の更新と新しい開発用 Plugin の検出」、anthropics/skills は「skill-creator の T2 と spec の移動」。取得はローカル clone の自動更新で足りる（草稿 378 行）。
- 「低」の理由は草稿 380〜382 行の推奨度列にある。
  - platform.claude.com は「API 全般で X-4 の範囲外が大半」。
  - claude.com の articles は「背景の情報源」。
  - academy は「B6 は範囲外側で確定済み」。
  - Releases の Atom は「CHANGELOG と重複」。
- 裏付けとなる事実は以下。
  - platform.claude.com の llms.txt は 761 行（en 760 ページ）。title / URL に skill / claude code を含むのは 33 件で、24 件が API エンドポイント参照のため除外、9 件が境界扱い（`p1-docs.md` 115, 124 行）。
  - claude.com の `/sitemap.xml` は 3,648 URL で、marketplace/ が 1,299、resources/ が 525。/blog/ は 0 件で、記事は /resources/articles/ に正規化される（`p1-blog-support.md` 146〜150 行）。
  - Academy の catalog.json は 308 件（courses 27 / tutorials 124 / useCases 157）。Claude Code の Plugin 教材は 0（`p1-blog-support.md` 163 行、棚卸し 85 行）。
  - Releases は 241 件だが v2.0.73（2025-12-19）以降のみ。CHANGELOG は 1.0.38（2025-06-30）まで遡れるため、CHANGELOG の方が古い版まで追える（`p1-changelog-registry.md` 34, 41 行）。
- 修正は 2 節で、列「推奨度の理由」を追加し、9 行に戻した。「高」3 件にも 1 文ずつ理由を付けた（自明でも、観点を表で揃えるため）。
- 注: 作業指示者の依頼文は「草稿 10 節と同じ粒度の 9 行」だった。実際の草稿は 10 行（claude-code が 2 行）なので、claude-code を 1 行にして 9 行とした。10 行に戻す場合は claude-code を CHANGELOG と feed.xml の 2 行に分ける。

### 回答 2（「低」の「範囲外が大半、または CHANGELOG と重複」の問題）
- 作業指示者の指摘のとおり、理由を「方式」列に入れたのが不適当だった。「方式」は取得・差分検出の手段だけにして、理由を新列へ移す。
- 「範囲外」は、棚卸しの範囲（Claude Code の Plugin の開発・テスト・配布）の外、という意味だった。草稿の「X-4」は計画書の除外基準で、API エンドポイント参照を指す。
- 修正後は「範囲外」の一語で済ませない。次のように書く。
  - 「Plugin に関する情報がほとんど無く、差分を取る手間に見合わない」
  - 「CHANGELOG に含まれ、追加の情報が無い」

### 回答 3（「—」の意味）
- 意味は「圧縮により割愛」。「低」の 4 サイトを 1 行にまとめた際、サイトごとに URL が違うため、1 つのセルに入らず「—」にした。アクセスすべき URL が無い、という意味ではない。
- 実際は 4 サイトとも URL を持つ。ただし草稿には次の弱点があった。
  - claude.com の articles は、草稿に「sitemap（URL は P1-B の W-6 の記録に依存。本書では未取得）」とあった。今回 `p1-blog-support.md` 73〜74, 146 行で `https://claude.com/sitemap.xml` と確認できたので、URL を書ける。
  - Releases の Atom は、URL（`https://github.com/anthropics/claude-code/releases.atom`）はあるが、P0-B の WebFetch が robots で拒否された（`p2-coverage.md` 36 行）。取得できるかは未確認。
- 修正後の表では「—」を使わない。URL が無い場合は「無し（理由）」と書く規則にした。今回の 9 行には「無し」に当たる行は無い。

## 2. §5 の差し替え案（そのまま貼れる Markdown）

```markdown
## 5. 監視対象の追加案（D3。LLMs リポジトリ側のバックログ。本活動では実装しない）

「本棚卸しの範囲」は Claude Code の Plugin の開発・テスト・配布。推奨度の理由は、Plugin 開発に関係する情報の量、既存の監視との重複、取得のしやすさ、監視コストの観点で書く。

| 推奨 | サイト | 取得 URL | 方式 | 推奨度の理由 |
|---|---|---|---|---|
| 高 | claude.com/docs | https://claude.com/docs/llms.txt | llms.txt（262〜266 ページ）の差分 | Plugin・Skill の仕様が面をまたいで載り、新ページが増えやすい。llms.txt が sitemap と差 0 で全ページを網羅し、小さいので差分が安い。現状は未監視 |
| 高 | agentskills.io | https://agentskills.io/llms.txt | llms.txt（9 ページ）の差分 | SKILL.md 形式の正本。9 ページと小さく、差分のコストはほぼ無い。llms.txt が sitemap と差 0 |
| 高 | anthropics/claude-code | https://raw.githubusercontent.com/anthropics/claude-code/main/feed.xml（二者択一: https://raw.githubusercontent.com/anthropics/claude-code/refs/heads/main/CHANGELOG.md） | Atom（1 版 1 entry、日付あり）。CHANGELOG.md は raw の差分 | 新機能は docs より先に CHANGELOG に出る。feed.xml は P2-M が取得して Atom と確認済みで、最新 v2.1.296。1 版 1 entry で差分が取りやすい |
| 中 | anthropics/claude-plugins-official | https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json（ローカル clone の同名ファイルでも可） | marketplace.json（約 190 KB）の差分。`./plugins/*` の author = Anthropic に絞る | skill-creator・plugin-dev の更新と、新しい開発用 Plugin を検出できる。ローカル clone が自動更新されるので取得コストは低いが、第三者の Plugin が大半でノイズが多く、絞り込みが要る |
| 中 | anthropics/skills | https://raw.githubusercontent.com/anthropics/skills/main/.claude-plugin/marketplace.json（ローカル clone の同名ファイルでも可） | marketplace.json（約 2 KB）の差分 | skill-creator の更新と spec の移動を検出できる。2 KB で取得は安いが、変更頻度が低く Plugin 開発への影響は限られる |
| 低 | platform.claude.com/docs | https://platform.claude.com/llms.txt | llms.txt（760 ページ）の差分。skill 関連ページに絞る必要あり | API 全般の docs で、title / URL に skill / claude code を含むのは 33 件だけ。うち 24 件は API エンドポイント参照で、Plugin に関する情報がほとんど存在せず、760 ページを差分で追う手間に見合わない |
| 低 | claude.com（resources/articles） | https://claude.com/sitemap.xml（/resources/articles/ に絞る） | sitemap の lastmod 差分 | 記事は背景の情報源で、挙動・形式の根拠に使わない（4 節）。sitemap は 3,648 URL で、marketplace/ の 1,299 件などが混ざり絞り込みの手間が大きく、監視コストが見合わない |
| 低 | academy.claude.com | https://academy.claude.com/assets/data/catalog.json | JSON（308 件）の差分 | 現時点で Claude Code の Plugin 教材は 0 件で、監視しても検出対象が無い。取得は JSON 1 本で安いが、Plugin 教材が現れるまで価値が無い |
| 低 | anthropics/claude-code Releases | https://github.com/anthropics/claude-code/releases.atom | Atom（取得は未確認。P0-B の WebFetch は robots で拒否） | CHANGELOG（feed.xml）と内容が重複する。Releases は v2.0.73（2025-12-19）以降しか無く、CHANGELOG より新しい情報も古い情報も無い |
```

注: 現行の「低」4 サイト群の方式欄にあった「範囲外が大半、または CHANGELOG と重複」は、上の理由欄に分解して移した。

## 3. §6・§7 の条件付き修正案

形式: 条件 → 箇所 → 文面。(a) は §5 の確定が前提。(b)(c) は別担当の §2〜§4 の確定文面に依存するため、条件が成り立つ場合だけ適用する。

### 3-a. §5 の修正の反映

**a-1**
- 条件: §5 を 2 節の案（高 3 / 中 2 / 低 4、理由列つき）に差し替える。
- 箇所: §6「監視への移行」行（棚卸し 92 行）。
- 文面: 「監視への移行: 5 節の案（高 3 / 中 2 / 低 4。作業指示者が LLMs リポジトリのバックログへ。D3）。低 4 件は Plugin 情報が少なく監視コストが見合わないため、積まない候補として理由つきで記録した」

**a-2**
- 条件: §5 で低 4 件を「積まない候補」にする（a-1 と同じ）。
- 箇所: §1 結論 4（棚卸し 18 行）の「監視対象の追加案（5 節）を LLMs リポジトリのバックログに積む」。
- 文面: 「監視対象の追加案（5 節。高 3 / 中 2 を推奨、低 4 は積まない候補）を LLMs リポジトリのバックログに積む」

**a-3**
- 条件: 低 4 件を監視しない案を採る。
- 箇所: §1 結論 5（19 行）の「言えないのは残存リスク 12 項目の範囲…で、これは監視に委ねる」。
- 問題: 監視案は docs の新ページと claude-code の新版しか捕まえない。SNS だけの告知、リンクも名前も無い資産、深さ 3 以降のリンク、第三者 org の中身は、監視案では補えない。「監視に委ねる」と書くと言い過ぎになる。
- 文面: 「言えないのは残存リスク 12 項目の範囲…で、このうち監視（5 節）で補えるのは新ページ・新版の検出に限られる。SNS だけの告知など他の項目は、監視ではなく受容の対象である」

**a-4**
- 条件: Releases の Atom の取得可否を、LLMs 側で実際に試すまで確定しない。
- 箇所: §6 E3 の記述（87 行）の「GitHub の Atom = 監視案」。
- 文面: 「GitHub の Atom（feed.xml は取得確認済み。releases.atom は robots により WebFetch が拒否され未確認）= 監視案」

### 3-b. §4 が 3 段（正本 / 準正本 / 参考）になり、挙動の正本を実挙動、文書の正本を docs とする場合

**b-1**
- 条件: §4 で「正本 / 準正本 / 参考」を導入する。
- 箇所: §6「定義」行（81〜82 行）。
- 問題: L1 / L2 / L3（範囲に入るかの分類）と、正本 / 準正本 / 参考（根拠に使う強さの分類）は別の軸だが、読者が混同しやすい。
- 文面（定義行の末尾に追記）: 「なお L1 / L2 / L3 は範囲に入るかの分類であり、4 節の正本 / 準正本 / 参考は根拠に使う強さの分類で、別の軸である」

**b-2**
- 条件: 形式の正本が「docs の項目表」だけでなく、挙動の正本として `claude plugin validate` の実測も使う構成になる。
- 箇所: §6 残存リスク（個別）(1)（棚卸し 91 行）の「形式の正本は docs の項目表と validate」。
- 文面: 「(1) 公式の JSON Schema が取得できない（404）。形式の文書上の正本は docs の項目表、挙動の正本は `claude plugin validate` の実測で、機械可読な schema は無い」

**b-3**
- 条件: 版の事実の正本を CHANGELOG とし、挙動は実挙動を優先する（草稿 9 節 366 行の解消案が採用される）。
- 箇所: §6 残存リスク（個別）(11)（91 行）と、§2 Fable 判定 `/skill-doctor`（33 行）。
- 文面: 「(11) docs と CHANGELOG の版記述の食い違い（/skill-doctor の導入版）。版の事実は CHANGELOG を正本とするため、この食い違いでは docs 側を準正本として扱う。実測で確認できるまでは未確認として残す」
- 補足: `/skill-doctor` の導入版は docs が v2.1.252 以降、CHANGELOG が 2.1.261 の初出。CHANGELOG を正本にすれば解消に近づくが、実挙動の確認は別途必要。

**b-4**
- 条件: 実挙動が挙動の正本になる。
- 箇所: §7 の 4（棚卸し 102 行。草稿 11-4）。
- 問題: 草稿にあった「dry-run の有無は未確認」が棚卸しで落ちている。実挙動が正本なら、tag の挙動は `claude plugin tag --help` の実測で確かめるべき事項になる。
- 文面（影響欄）: 「`claude plugin tag` が validate・版一致・clean tree を確かめる（docs の記述。手元の版の `--help` と実測は未確認で、dry-run の有無も未確認）」

**b-5**
- 条件: 版の事実は CHANGELOG が正本、実挙動は手元の版が正本。
- 箇所: §7 の 5（103 行。草稿 11-5）。
- 文面（推奨対応欄）: 「`meta.json` に、手元で実測した Claude Code の版（`claude --version`）と配布チャネル（stable / latest）を残す。CHANGELOG / feed.xml は版の事実の根拠として併記する」

**b-6**
- 条件: 実挙動が正本になる（任意の波及）。
- 箇所: §7 の 3（101 行。草稿 11-3）。
- 問題: 草稿には「statusline の hook はこちらの見込み（未検証）」とあるが、棚卸しでは落ちている。実挙動の原則に照らすと、未検証と明記すべき。
- 文面（影響欄に追記）: 「statusline の hook が command hook 側に当たる見込みは未検証」

### 3-c. §2・§3 の指摘（「条件付き」のケース分け、手法名の注記、表の見出し）の波及

**c-1**
- 条件: §2 で「条件付き」14 件を、成立するケース（mod を書く / CI を導入する / 参照）別に書き分ける。
- 箇所: §7 の 3（101 行）の「mod 化する場合の雛形は `mods/agents-md`」、§7 の 7（105 行）の「sec-default」、§6 E6 行（89 行）の「対応先の無い資産 2 件」。
- 文面:
  - §7 の 3 と 7 の推奨対応の先頭に「（§2 の条件付き: mod を書く場合のみ）」を付ける。
  - E6 行に「（条件付きの 14 件は、条件が成立した場合の対応先を含めない）」を追記する。

**c-2**
- 条件: §3 の表で手法名（A、B、C、probe など）に注記を付ける。
- 箇所: §6 E6 行（89 行）の「A × 配布」「probe × 開発・テスト」「発火 × 配布」「利用実績の観測 × 3」、§7 の 1・3 の「M4」「M7」「手法整理 2-6」「7-5（C）」。
- 文面:
  - E6 行の手法名を、§3 の注記と同じ表記（例「A（skill-creator）× 配布」「発火テスト × 配布」）に揃える。
  - §7 の表の見出し直下に 1 行足す: 「M＝手法整理文書の手法 ID、7-n＝設計書の節、11-n＝草稿の節」

**c-3**
- 条件: §3 の表の見出しが変わる（例「手法 × 開発 / テスト / 配布」の明示）。
- 箇所: §6 E6 行の「9 手法 × 3 活動のセル埋め率 74%」。
- 文面: §3 の見出しと同じ語に揃える。20 / 27 と空の 7 セルの数字は変えない。

**c-4**
- 条件: なし（現行の棚卸し内の不整合。§7 の番号付けに関わる）。
- 箇所: §2「Fable が草稿に加えた判定」の 34 行「影響 11-4」。
- 問題: §7 の表では同じ項目が「4」になっている。11-4 は草稿の番号で、棚卸しの読者には通じない。
- 文面: 「影響 11-4」を「影響 §7 の 4」に直す。§7 の表の見出しに「（草稿 11 節の 11-n に対応）」と注記する。

## 4. 作業指示者に決めてもらう点

1. **「低」4 件を、バックログに積まない候補として記録するか、積むが優先度低にするか。** 2 節の案は前者（a-1 の文面）。後者なら a-1・a-2 の「積まない」を「積む（優先度低）」に直す。
2. **Releases の Atom（`releases.atom`）の取得可否。** LLMs リポジトリ側で試すまで未確認。3-a の a-4 のとおり未確認と明記して残すか、確認してから載せるか。
3. **claude-code の監視で feed.xml と CHANGELOG のどちらを一次にするか。** 草稿は二者択一としつつ feed.xml を「差分が取りやすい」とする。2 節の案は feed.xml を一次、CHANGELOG を代替とした。
4. **§7 の番号表記。** 「4」と「11-4」のどちらで統一するか（c-4）。
5. **§1 結論 5 の「監視に委ねる」の言い過ぎ（a-3）。** 文面を直すか、現行のままにするか。
6. **(b)(c) の文面は、R2 の §4 確定文面と §2・§3 の修正結果が決まってから適用する。** それまでは条件付き。
