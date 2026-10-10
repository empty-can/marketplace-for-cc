# 変更履歴

## 0.9.0

- 初版（実運用での確認前のため 0.x としてリリース）
- 移植元: `cc-relative-info` リポジトリ `feature/LLMs` ブランチの `.claude/skills/pre-compact/SKILL.md`（commit `000b3f4`、`/compact` と `/clear` の二分岐対応版）
- 移植元からの変更点
  - `disable-model-invocation: true` を付け、Claude が自分の判断で起動しないようにした。作業指示者がメッセージ中に `/pre-compact:pre-compact` と書いたターンに限り、Claude が実行できる
  - 「起動方法」の節を追加し、呼び出し名と起動条件を本文に明記した
  - `/clear` 提示時に、`/clear <名前>` で前の会話に名前を付けて `/resume` から戻れることを補足した
