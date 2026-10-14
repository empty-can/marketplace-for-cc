# 対話セッションでの確認手順（作業指示者向け）

作成: 2026-10-10 / 改訂: 2026-10-11（実行シェルを PowerShell に変更）/ 対象: `test-repo-design-review-fable.md` の「残る未確認事項」のうち、対話セッションが必要な 2 件

| # | 確認事項 | 必要な理由 | 所要 |
|---|---|---|---|
| 1 | 文中起動の対話セッションでの挙動 | `disable-model-invocation` skill を指示文の途中の `/skill名` で起動できるかは、対話セッションでしか試せない（非対話では拒否済み） | 約 10 分、プラン使用量は 1〜2 ターン分 |
| 2 | `/cd` 後の auto memory の保存先 | `/cd` はセッション内コマンドで、`claude -p` からは実行できない | 約 5 分、プラン使用量は 1 ターン分 |

共通の注意:

- **すべて PowerShell で実行する。** Windows Terminal の PowerShell タブか、PowerShell コンソール（ISE は不可）を使う。Git Bash 標準のターミナル（mintty）では、ネイティブ Windows プログラムから見た標準出力がパイプになるため、素の `claude` が非対話モードに入り `Input must be provided ... when using --print` で止まる（公式 docs「Input must be provided when using `--print`」の節）
- 判別方法: そのターミナルで `python -c "import sys;print(sys.stdout.isatty())"` を実行し、`True` なら起動できる
- パスは `C:/...` 形式のスラッシュ区切りで書く。PowerShell と Claude Code のどちらもこの形式を受け付ける
- `--settings` には JSON 文字列ではなく設定ファイルを渡す。引用符の扱いの違いで JSON が壊れるのを避けるため
- 結果は、手順の最後にある「記録すること」をそのまま返信に貼るか、`/export` でセッションを保存する

## 確認 1: 文中起動の対話セッションでの挙動

### 準備

Git Bash で `2026-10-11_midmsg/repo` を作成済みなら、最初のブロックは飛ばして「設定ファイルの作成」だけ行う。

```powershell
$S = "C:/cc-workspace/marketplace-for-cc-evals/sandbox/2026-10-11_midmsg"
New-Item -ItemType Directory -Force -Path "$S/repo", "$S/memory" | Out-Null
Set-Location "$S/repo"
git init -q
git config user.name test
git config user.email test@example.com
Set-Content -Path a.txt -Value hello -Encoding Ascii
git add . ; git commit -qm init
Add-Content -Path a.txt -Value wip -Encoding Ascii   # 未コミット変更を 1 つ残す（skill のステップ 2 を動かすため）
```

設定ファイルの作成（memory の保存先をこのテスト専用にする）:

```powershell
$S = "C:/cc-workspace/marketplace-for-cc-evals/sandbox/2026-10-11_midmsg"
Set-Content -Path "$S/settings.json" -Value "{`"autoMemoryDirectory`":`"$S/memory`"}" -Encoding Ascii
Get-Content "$S/settings.json"     # {"autoMemoryDirectory":"C:/cc-workspace/.../memory"} と表示されること
```

`-Encoding Ascii` にしているのは、Windows PowerShell 5.1 の `utf8` が BOM 付きで書くため。パスは ASCII だけなので問題ない。

### 起動

`repo` の中から Plugin を直接読み込んで起動する。レビューで推奨した権限設定（`acceptEdits` と memory の `--add-dir`）を付ける。

```powershell
$S = "C:/cc-workspace/marketplace-for-cc-evals/sandbox/2026-10-11_midmsg"
Set-Location "$S/repo"
claude --plugin-dir C:/cc-workspace/marketplace-for-cc/plugins/pre-compact `
  --permission-mode acceptEdits `
  --add-dir "$S/memory" `
  --settings "$S/settings.json"
```

ワークスペースの信頼を聞かれたら許可する。

### 事前確認

1. `/memory` を開く。一覧にはパスが表示されないので、**Open auto-memory folder** を選んでフォルダを開き、場所が `$S/memory` であることを確認する（設定ファイルが正しく渡っている証拠）。開いたら閉じて Esc で戻る
2. `/plugin` を開き、**Installed** タブに `pre-compact` が **Plugin inline** として載っていることを確認する。`inline` は `--plugin-dir` で読み込んだ Plugin の表示名。**Marketplaces** タブには出ない（Marketplace 経由ではないため）。無ければ `--plugin-dir` のパスを見直す
3. `/pre-compact:` と途中まで入力し、補完に `pre-compact:pre-compact (pre-compact) ...` が出ることを確認する。先頭の `(pre-compact)` が Plugin 由来の印。出たら **Esc で入力を消す**（実行しない）
4. statusline の 3 行目に `added:[...\memory]` が出ていれば `--add-dir` も効いている

### 試験 A（名前空間付き・文中）

次の 1 行をそのまま送る。スラッシュの前後に半角スペースを入れる。

```text
動作確認です。/pre-compact:pre-compact を実行してください
```

結果の見方:

| 観察された応答 | 判定 |
|---|---|
| 「未コミットの変更」「終了方式」などの見出しで、コミット案と `/clear` または `/compact` の提案が出た | 文中起動は**有効**。skill 本文が実行された |
| 「`disable-model-invocation` のため起動できない」「`/pre-compact:pre-compact` を直接入力してください」という趣旨の応答 | 文中起動は**無効**（非対話モードと同じ） |
| 「そのような skill は無い」という趣旨の応答 | Plugin が読み込まれていない。事前確認に戻る |

### 試験 B（短い名前・文中）

試験 A の結果にかかわらず、`/clear` で会話を空にしてから次を送る。短い形の `/pre-compact` でも起動の許可になるかを見る。

```text
動作確認です。/pre-compact を実行してください
```

判定は試験 A と同じ表で行う。

### 試験 C（先頭起動・対照）

試験 A と B の両方が無効だった場合だけ行う。`/clear` の後、メッセージの先頭に置く形で送り、skill 自体は動くことを確かめる。

```text
/pre-compact:pre-compact
```

### 記録すること

- `claude --version` の出力
- 試験 A・B（必要なら C）それぞれについて、送った文面と、応答の最初の 3〜5 行
- 試験 A または B で skill が実行された場合、`$S/memory` に何かファイルが増えたか

```powershell
Get-ChildItem "C:/cc-workspace/marketplace-for-cc-evals/sandbox/2026-10-11_midmsg/memory"
```

### 後片付け

```powershell
Remove-Item -Recurse -Force "C:/cc-workspace/marketplace-for-cc-evals/sandbox/2026-10-11_midmsg"
Get-ChildItem "$HOME/.claude/projects" -Directory -Filter "*2026-10-11-midmsg*"   # 何も出なければ残骸なし
```

プロジェクトディレクトリの名前は、パスの `\` と `_` を `-` に置き換えて作られる（例: `C--cc-workspace-marketplace-for-cc-evals-sandbox-2026-10-11-midmsg-repo`）。フィルタはアンダースコアではなくハイフンで書く。

`autoMemoryDirectory` を指定しているので、通常は `~/.claude/projects/` に何も残らない。2 行目で何か出た場合は、設定ファイルを渡さずに起動した試行の残骸なので、表示されたディレクトリを `Remove-Item -Recurse -Force` で消す。

### 結果の使い道

- 有効だった場合: pre-compact の README・CHANGELOG・SKILL.md の「起動方法」は現状のままでよい。非対話モード限定の制約として、テスト用リポジトリの設計書に注記する
- 無効だった場合: 3 か所の「指示文の途中に書けば実行できる」という記述を直す。運用を先頭起動に限るか、`disable-model-invocation` を外して description と本文で起動条件を絞るかを決める

## 確認 2: `/cd` 後の auto memory の保存先

`autoMemoryDirectory` を**指定せずに**起動し、既定の保存先が `/cd` でどう変わるかを見る。

### 準備

```powershell
$S = "C:/cc-workspace/marketplace-for-cc-evals/sandbox/2026-10-11_cd"
foreach ($d in "repoA", "repoB") {
  New-Item -ItemType Directory -Force -Path "$S/$d" | Out-Null
  Set-Location "$S/$d"
  git init -q
  git config user.name test
  git config user.email test@example.com
  Set-Content -Path name.txt -Value $d -Encoding Ascii
  git add . ; git commit -qm init
}
```

### 手順

1. `repoA` に移動して起動する。Plugin は不要

   ```powershell
   Set-Location "C:/cc-workspace/marketplace-for-cc-evals/sandbox/2026-10-11_cd/repoA"
   claude
   ```

2. `/memory` を開き、auto memory フォルダのパスを控える（`~/.claude/projects/<repoA に対応する名前>/memory/` のはず）。Esc で閉じる
3. 次を送り、memory ファイルを 1 つ書かせる

   ```text
   覚えておいてください: この確認の合言葉は ALPHA です。auto memory に保存してください。
   ```

4. `/cd` で `repoB` へ移る。信頼を聞かれたら許可する

   ```text
   /cd C:/cc-workspace/marketplace-for-cc-evals/sandbox/2026-10-11_cd/repoB
   ```

5. もう一度 `/memory` を開き、auto memory フォルダのパスを控える
6. 次を送り、もう 1 つ書かせる

   ```text
   覚えておいてください: 移動後の合言葉は BRAVO です。auto memory に保存してください。
   ```

7. セッションを終了し、PowerShell で保存先を確認する

   ```powershell
   Get-ChildItem "$HOME/.claude/projects" -Directory -Filter "*2026-10-11-cd*" |
     Get-ChildItem -Recurse -File |
     Select-String -Pattern "ALPHA|BRAVO" -List |
     Select-Object Path, Line
   ```

   フィルタはハイフンで書く。プロジェクトディレクトリの名前はパスの `_` も `-` に置き換えられる（`...-2026-10-11-cd-repoA`）。

### 結果の見方

| `/memory` のパス | BRAVO の保存先 | 判定 |
|---|---|---|
| 手順 5 で repoB 側に変わった | repoB 側 | `/cd` で memory も切り替わる。テスト用リポジトリで `/cd` を使う流れに支障なし |
| 手順 5 でも repoA 側のまま | repoA 側 | `/cd` では memory は切り替わらない。設計書 5 節に「`/cd` 先での memory 書き込みは元のプロジェクトに入る」と注記する |
| 上記が食い違う | どちらか | `/memory` の表示と実際の書き込み先が一致しない。両方の結果を記録する |

### 記録すること

- 手順 2 と 5 で控えたパス
- 手順 7 の出力

### 後片付け

```powershell
Remove-Item -Recurse -Force "C:/cc-workspace/marketplace-for-cc-evals/sandbox/2026-10-11_cd"
Get-ChildItem "$HOME/.claude/projects" -Directory -Filter "*2026-10-11-cd*"   # 対象が 2 件だけであることを確認してから次を実行
Get-ChildItem "$HOME/.claude/projects" -Directory -Filter "*2026-10-11-cd*" | Remove-Item -Recurse -Force
```

### 結果（2026-10-11 実施、v2.1.296）

- `/memory` の一覧には前後ともパスが出なかった（表示仕様）
- ALPHA は repoA 側の `memory/` に保存された
- `/cd` 後、Claude は「システム側の案内には移動前の repoA のパスが残っていた」と述べた上で、自分の判断で repoB 側のパスを組み立てて BRAVO を書いた。つまり **`/cd` では auto memory の保存先（システムが Claude に案内するパス）は切り替わらない**。書き込み先は Claude の判断に依存する
- セッションの記録（`.jsonl`）は repoB 側のプロジェクトディレクトリへ移った（docs「/cd は移動先のプロジェクト保存領域へセッションを移す」のとおり）
- 判定: `/cd` 先での memory 書き込みは保存先が不定になるため、`/cd` したセッションでは memory に依存する作業（pre-compact の実行を含む）を行わない。設計書 5 節に注記する

## 参考: Claude 側で確認した 3 件（2026-10-10 解決済み）

- `tool_used: Skill` grader はユーザー起動（prompt 先頭のスラッシュ）を数えない。skill 本文は実行される
- B の run 内では auto memory は読めず、Bash ツールも無い
- パスルールが効かなかった原因は `Write(path)` を書いていたこと（参照されない。`Edit(path)` を使う）と、Windows で `//C:/` 形式が一致しないこと。正式な形式は `//c/Users/...`（docs 77806 行。ドライブ文字を小文字にしコロンを外す）。`~/...` も効く

詳細は `test-repo-design-review-fable.md` の「追加検証」。

## 補足: テスト用リポジトリの設計への影響

設計書 `test-repo-design.md` の 6 節は、作業指示者が実行するスクリプトを bash（Git Bash）で書く前提になっている。対話セッションを起動する `launch-sandbox.sh` は、mintty から起動すると上記の理由で動かない。採用時は、作業指示者が実行するスクリプトを PowerShell（`.ps1`）に揃えるか、Windows Terminal からの実行を前提にする必要がある。`.ps1` の文字コードは本リポジトリの規約（UTF-8 BOM + CRLF）に従う。
