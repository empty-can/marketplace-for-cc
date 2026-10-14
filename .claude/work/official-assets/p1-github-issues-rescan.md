# P1-G3 GitHub issues 再走査 2（G-5r: 著者条件の差し替え）

- claude --version: 2.1.296 (Claude Code)（開始時、2026-10-13T02:36:34+09:00）／2.1.296 (Claude Code)（終了時、2026-10-13T03:17:39+09:00）。版のずれ: 無し
- 入力: 計画書（1-1、1-2、2-5、2-6 G-5、4-4）、p1-github-structure.jsonl（対象 repo と既知 URL の抽出のみ）、p1-github-content.md（G-5 の節・別表 1・件数表）、p1-changelog-registry.md（maintainer 名の表）。出力: 本ファイルと p1-github-issues-rescan.jsonl（11 行）
- 一時ファイル: scratchpad の p1-g3/（取得 JSON、スクリプト）。gh は GET と読み取り GraphQL のみ使用
- 要点: (1) 初回の「OWNER / MEMBER / COLLABORATOR が 0 件」はラベル絞りの副作用。全 issue 101,247 件を列挙すると COLLABORATOR は 25 件（7 名）あり、OWNER / MEMBER は 0 件。社員の issue は NONE / CONTRIBUTOR / COLLABORATOR のいずれかで現れる。(2) docs に先行する告知は claude-code#91870「Mods」スレッド 1 件（投稿者 user-72 は CONTRIBUTOR 表示）。リンク先 anthropics/claude-code/mods が L1 の資産候補（P1-G3-001）。(3) 社員の issue は大半が test 投稿で、本文リンクはほぼ無い

## 一覧（status が candidate と boundary の行）

| ID | 名称 | URL（最終 URL） | 種別 / 権威 | 権威の対象 | 活動と範囲判定 | 発見チャネル（G-5r） | 一次確認（取得日、issue 番号） |
|---|---|---|---|---|---|---|---|
| P1-G3-001 | claude-code の mods ディレクトリ（組み込み mod 4 種のソース） | https://github.com/anthropics/claude-code/tree/main/mods | 資産 / L1 | 形式・挙動・参照実装 | 開発・テスト / 内（暫定） | G-5r（著者 user-72 の告知 issue 本文） | 2026-10-13、claude-code#91870、tree sha 0aea12a、main 3deb873 |
| P1-G3-002 | Claude Code docs: plugin-dependencies | https://code.claude.com/docs/en/plugin-dependencies | 情報源 / L1（ドメイン） | 挙動・形式 | 開発・配布 / 内（暫定） | G-5r（CONTRIBUTOR 再取得） | 2026-10-13、claude-code#64457・#63986（リンク抽出のみ。リンク先未取得） |
| P1-G3-003 | claude-agent-sdk-python の examples/streaming_mode.py（c4384ea。旧 claude-code-sdk-python） | https://github.com/anthropics/claude-agent-sdk-python/blob/c4384ead710e2c264f13524ce63a985a31b43e3c/examples/streaming_mode.py | 資産 / L1 | 参照実装 | 開発 / 境界（agent-sdk） | G-5r（COLLABORATOR user-15 の issue 本文） | 2026-10-13、claude-agent-sdk-python#78、blob 73eb410 |
| P1-G3-004 | Function Hooks 技術アーキテクチャ文書（PDF） | https://github.com/user-attachments/files/31802150/EXTERNAL.Function.Hooks.Core.Architecture.pdf | 情報源 / L3 | 挙動 | 開発 / 境界 | G-5r（著者 user-72 の告知 issue 本文） | 2026-10-13、claude-code#91870（リンク抽出のみ。リンク先未取得） |

## 件数表

| 項目 | 件数 | 内訳 |
|---|---|---|
| 著者集合の人数 | 71 | 主（A ∪ B ∪ C）54、B* のみ 2（user-23、user-73）、D のみ 2（user-10、user-45）、E のみ 9、D+E 2（user-41、user-59）、X のみ 2（user-16、user-44）。別表 1 |
| 走査した issue 数（本文のリンクを抽出） | 60 | 著者集合の search ヒット 50（本文あり 42）+ CONTRIBUTOR 再取得 11 のうち未重複 10。ほかに権限判定のため GraphQL で 101,247 件の著者と association を列挙（本文は読まない） |
| 抽出したリンク数（対象 5 ホスト） | 16 | 正規化後の重複なし |
| 未知の数 | 10 | 既知 repo のルート 3、issue/PR 相互参照 3 を除く、パス単位の未知。さらに指定ホスト外の PDF 1（別表 2） |
| JSONL の行 | 11 | candidate 2、boundary 2、excluded 7 |

## 走査の記録

### 再走査 2（Fable 指示、2026-10-13）
- 変えた変数 = 著者条件のみ。OWNER / MEMBER / COLLABORATOR の association 条件とラベル絞りを外し、著者集合（別表 1）で絞った。期間は created >= 2025-06-30、対象は is:issue のみ（PR は対象外）
- 対象 repo: p1-github-structure.jsonl で in / boundary の candidate 32 件。GraphQL hasIssuesEnabled=false は commerce-agents と github-mcp-server の 2 件（走査 30 repo）。org 横断クエリ `author:{login} org:anthropics` と `repo:agentskills/agentskills` を login ごとに実行し、結果を 32 repo で絞った（repo ごとの個別クエリより少ない回数で同じ集合を得る。集合外の anthropics repo のヒットは全 login で 0 件）
- 著者集合の作り方: A = claude-code の Release 241 件（author は user-07 のみ）、claude-code-action 312 件（github-actions[bot] 290、user-07 14、user-54 8）、sandbox-runtime 42 件（8 名）。B = 5 repo の contributors 上位 30（計 106 行。bot 型は commit 確認の対象外）の login ごとに commits?author={login}&per_page=5。C = claude-code の updated 降順 200 件の LABELED / CLOSED（first:10）の actor 620 件のうち bot 577、著者本人 34、それ以外の User 9 件（user-09 8、user-68 1）。D = npm maintainer 17 名のうち同名の GitHub login が存在するのは 5（user-10、user-90、user-59、user-41、user-45）。E = 上記の login と、全 issue 著者 70,727 名のうち末尾が -ant / -anthropic のもの 14 名
- B の判定: author.email が @anthropic.com の commit が 1 件でもあれば「確認」。noreply@anthropic.com（login `claude` が使う汎用アドレス）は社員の証拠にしない。users.noreply.github.com は「不明」。メール文字列は記録せずドメイン区分だけ残した
- 各 login のヒット数（search）: user-07 11、user-64 6、user-33 5、user-73 5、user-44 3、user-13 2、user-72 2、user-38 2、user-16 2、user-15 / user-34 / user-81 / user-83 / user-84 / user-12 / user-23 / user-48 / user-56 / user-74 / user-85 / user-93 各 1、ほかの 50 名は 0（別表 1 の列）。search と GraphQL 全件列挙の件数は全 login で一致
- 未走査（レート制限）: 無し。search の 422（「listed users cannot be searched」）で org クエリが失敗したのは user-35、user-52、user-55、user-68、user-77 の 5 名。GraphQL 全件列挙では 5 名とも対象 repo の issue が 0 件
- 未走査の範囲: 社員の PR と issue コメント（#91870 は 254 コメント）、Discussions の投稿者、npm maintainer のうち同名 login が無い 12 名、contributors 31 位以下、claude-plugins-official / skills 以外の repo の contributors、本文が空の 8 件、リンク先の取得（docs と support は未取得）、E のみの 9 名と D のみの 2 名が社員かどうかの確認
- rate_limit: 開始時 core 5000 / search 30 / graphql 4972 / code_search 10。終了時（2026-10-13T03:17:39+09:00）core 5000 / search 30 / graphql 4899 / code_search 10。20 回ごとの記録は scratchpad の ratelog.txt。停止閾値 500 に未到達、secondary rate limit（403 / 429）は発生なし
- 呼び出し数: ツール呼び出し約 40 回（上限 120）。API はスクリプト経由の概算で REST 約 350、GraphQL 約 1,040（全 issue 列挙が大半）、search 約 150
- 全 issue の association 内訳（created >= 2025-06-30、32 repo）: NONE 101,051、CONTRIBUTOR 171（login `claude` の Bot 15 件を含む）、COLLABORATOR 25、OWNER / MEMBER 0。COLLABORATOR の 7 名: user-07 11、user-64 6、user-44 3、user-16 2、user-15、user-34、user-23 各 1。社員でも NONE（user-13、user-83 等）や CONTRIBUTOR（user-72、user-84、user-81、user-73）と表示される

## 別表 1. 著者集合（login / 根拠 / メールの確認 / 対象 repo の issue 数）

根拠: A = Release author、B = commit メール @anthropic.com（contributors 上位 30）、B* = contributors 外。commits?author= の直接確認で @anthropic.com、C = issue timeline の非著者 actor、D = npm maintainer と同名、E = 接尾辞 -ant / -anthropic、X = 本再走査で COLLABORATOR を観測（A〜E 外の参考）。F（プロフィールの company）は全員 null で不使用。D・E のみは補助（同名別人・命名一致の可能性）で、社員の確証ではない。

| login | 根拠 | メールの確認 | issue 数（search） |
|---|---|---|---|
| user-01 | B,E | 確認 | 0 |
| user-02 | B,E | 確認 | 0 |
| user-05 | B | 確認 | 0 |
| user-06 | B | 確認 | 0 |
| user-07 | A,B,E,X | 確認 | 11 |
| user-09 | B,C | 確認 | 0 |
| user-13 | B,E | 確認 | 2 |
| user-15 | B,X | 確認 | 1 |
| user-18 | B | 確認 | 0 |
| user-19 | B | 確認 | 0 |
| user-20 | B,E | 確認 | 0 |
| user-24 | A,B | 確認 | 0 |
| user-25 | B | 確認 | 0 |
| user-26 | B | 確認 | 0 |
| user-27 | A | 他ドメイン | 0 |
| user-30 | A,B* | 確認 | 0 |
| user-32 | B | 確認 | 0 |
| user-34 | B,E,X | 確認 | 1 |
| user-35 | A,E,B* | 確認 | 検索不可(422)・scan 0 |
| user-36 | B | 確認 | 0 |
| user-37 | B,E | 確認 | 0 |
| user-42 | B,E | 確認 | 0 |
| user-43 | B,E | 確認 | 0 |
| user-47 | B | 確認 | 0 |
| user-49 | B | 確認 | 0 |
| user-50 | B | 確認 | 0 |
| user-51 | B,E | 確認 | 0 |
| user-52 | B | 確認 | 検索不可(422)・scan 0 |
| user-54 | A,B | 確認 | 0 |
| user-55 | B | 確認 | 検索不可(422)・scan 0 |
| user-57 | A,B* | 確認 | 0 |
| user-58 | B,E | 確認 | 0 |
| user-60 | B | 確認 | 0 |
| user-61 | B,E | 確認 | 0 |
| user-64 | B,X | 確認 | 6 |
| user-65 | B,E | 確認 | 0 |
| user-66 | B | 確認 | 0 |
| user-68 | C,E | commit 無し | 検索不可(422)・scan 0 |
| user-70 | B,E | 確認 | 0 |
| user-72 | A,B* | 確認 | 2 |
| user-75 | B,E | 確認 | 0 |
| user-76 | B | 確認 | 0 |
| user-77 | A,E,B* | 確認 | 検索不可(422)・scan 0 |
| user-78 | B,E | 確認 | 0 |
| user-79 | B | 確認 | 0 |
| user-80 | B | 確認 | 0 |
| user-81 | B | 確認 | 1 |
| user-83 | A,E,B* | 確認 | 1 |
| user-84 | B | 確認 | 1 |
| user-86 | B | 確認 | 0 |
| user-87 | B | 確認 | 0 |
| user-89 | B | 確認 | 0 |
| user-90 | B,D | 確認 | 0 |
| user-91 | B,E | 確認 | 0 |
| user-23 | E,B*,X | 確認 | 1 |
| user-73 | E,B* | 確認 | 5 |
| user-10 | D | commit 無し | 0 |
| user-41 | D,E | commit 無し | 0 |
| user-45 | D | commit 無し | 0 |
| user-59 | D,E | commit 無し | 0 |
| user-12 | E | commit 無し | 1 |
| user-16 | X | 不明(noreply) | 2 |
| user-17 | E | 不明(noreply) | 0 |
| user-33 | E | commit 無し | 5 |
| user-38 | E | commit 無し | 2 |
| user-44 | X | 不明(noreply) | 3 |
| user-48 | E | commit 無し | 1 |
| user-56 | E | commit 無し | 1 |
| user-74 | E | commit 無し | 1 |
| user-85 | E | commit 無し | 1 |
| user-93 | E | commit 無し | 1 |
| claude | （除外） | 汎用 noreply@anthropic.com のみ | 集合に入れない（Bot 型の GitHub アプリ。15 件の CONTRIBUTOR issue あり） |

## 別表 2. 未知のリンク先（既知集合に無いもの。全件の JSONL 行は P1-G3-001〜011）

既知集合 = p1-github-structure.jsonl の URL（repo 単位）+ 計画書 1-1 の L1 ドメイン。docs / support のパス単位は p1-docs が入力外のため P2-R が照合する。

| リンク先 | 出現 | 元 | 判定 |
|---|---|---|---|
| https://github.com/anthropics/claude-code/tree/main/mods | 1 | claude-code#91870（user-72、CONTRIBUTOR） | 未知（パス単位）。candidate（P1-G3-001） |
| https://code.claude.com/docs/en/plugin-dependencies | 3（断片 1 を含む） | claude-code#64457・#63986（stbenjam） | known=null。candidate（P1-G3-002）。P2-R が照合 |
| https://github.com/anthropics/claude-agent-sdk-python/blob/c4384ea…/examples/streaming_mode.py（本文の URL は旧名 claude-code-sdk-python。最終 URL に正規化し旧 URL は別名） | 1 | claude-agent-sdk-python#78（user-15、COLLABORATOR） | 未知（パス単位）。boundary（P1-G3-003）。repo は known |
| https://github.com/user-attachments/files/31802150/EXTERNAL.Function.Hooks.Core.Architecture.pdf | 1 | claude-code#91870 | 指定ホスト外。boundary（P1-G3-004） |
| https://www.anthropic.com/legal/aup | 1 | claude-code#92886（user-33） | excluded（P1-G3-005）。利用規約 |
| https://support.claude.com/en/articles/16049681 | 1 | claude-code#92886 | excluded（P1-G3-006）。内容未取得 |
| claude-code-action の blob 5 本（d721746… と v1.0.169 の src / action.yml） | 延べ 7 | claude-code-action#1665・#1510・#1509 | excluded（P1-G3-007〜011）。ソース行参照 |
| 既知: claude-agent-sdk-typescript の root・/issues・.git（#328）、issue/PR 相互参照 3（claude-code#1399、claude-agent-sdk-python#175、issues?q= の検索 URL） | 6 | 各 issue | 既知 repo 内。行にしない |

## 別表 3. CONTRIBUTOR 13 件の内容の要旨

P1-G2 の「13 件」は label × issue の延べ数。実体は 11 issue（claude-code 5 = 延べ 7、claude-code-action 6 = 延べ 6）。ID が md に無いため、GraphQL 全件列挙（association と label）で再構成し、REST で本文を読んだ。件数は P1-G2 の記録と一致。全期間の CONTRIBUTOR は 171 件。

| issue | 著者（社員か） | label（一致分） | 状態 | 要旨 | 本文の対象リンク |
|---|---|---|---|---|---|
| claude-code#94815 | rquintino（非社員） | area:agents, area:agent-view | open | バグ: バックグラウンドセッションごとの job-dir パスがシステムプロンプトに入り、cacheScope:"org" のキャッシュが毎回外れる（11,092 文字） | 無し（検索 URL のみ） |
| claude-code#91870 | user-72（社員: A、B*） | area:hooks, area:plugins | open | 「Mods - make Claude 10x more extensible」。function hooks を Claude Mods として出す告知・意見募集（2026-09-03 初出、09-09 追記、10-01「We are live」）。mod は function hooks を使う plugin。CLAUDE_CODE_ENABLE_FUNCTION_HOOKS=1 で試用可。254 コメント | mods ディレクトリ（001）、設計 PDF（004） |
| claude-code#65337 | stbenjam（非社員） | area:plugins | closed | ローカルフォルダの Marketplace で、依存 plugin の固定 version（=0.5.0）が無視され最新が入る（#64457 の続き） | 無し |
| claude-code#64457 | stbenjam | area:plugins | closed | plugin 依存の version 解決（git タグ {name}--v{version}）が v2.1.159 で動かない | plugin-dependencies（002） |
| claude-code#63986 | stbenjam | area:plugins | open | `plugin install` と settings.json で version を固定できない要望 | plugin-dependencies#tag-plugin-releases-for-version-resolution（002） |
| claude-code-action#1665 | GautamSharma99（非社員） | mcp | closed | tag-mode のプロンプトが delete_files に `files` を指示するが、スキーマは `paths` | ソース blob 3 本（excluded） |
| claude-code-action#1510 | AlexanderBartash（非社員） | area:permissions | closed | actions/checkout v6 以降、configureGitAuth の credential 削除が no-op | ソース blob 1 本 |
| claude-code-action#1509 | AlexanderBartash | area:permissions | open | 失効済み app token が origin の URL に残り、後続の git 操作が失敗 | ソース blob 2 本 |
| claude-code-action#1156 | qozle（非社員） | mcp | open | retryWithBackoff が「non-retryable」を強制せず 3 回再試行する | 無し |
| claude-code-action#1010 | chyipin（非社員） | area:permissions | closed | id-token: write で Claude セッションが OIDC トークン要求用の環境変数を継承し、新規トークンを発行できる | 無し |
| claude-code-action#800 | AlexanderBartash | mcp | closed | parseAllowedTools() が最初の --allowed-tools だけ解析し、github_inline_comment 等の MCP が起動しない | 無し |
