# Web 検索結果（二次情報）2026-10-10

WebSearch ツール（mode: standard）で 1 回検索した結果を、返ってきたままの形で記録する。二次情報（claudeissues.com は GitHub issue のミラーサイト）なので、判断には GitHub 原文（`github-issue-*.json`）と実測を使った。

## クエリ

```
Claude Code .claude/rules paths frontmatter not loaded when reading file with Bash cat instead of Read tool
```

## 返ってきたリンク

| タイトル | URL |
|---|---|
| [BUG] Subdirectory `CLAUDE.md` loads only via the `Read` tool — every other file access path silently skips it | https://claudeissues.com/issue/90449-bug-subdirectory-claude-md-loads-only-via-the-read-tool-every-other-file-access |
| 79984 bug | https://claudeissues.com/issue/79984-bug |
| [BUG] Path-scoped rules in `.claude/rules/` not automatically loaded when working with matching files | https://claudeissues.com/issue/16853-bug-path-scoped-rules-in-claude-rules-not-automatically-loaded-when-working-with |
| github.com (#17204) | https://github.com/anthropics/claude-code/issues/17204 |
| github.com (#22170) | https://github.com/anthropics/claude-code/issues/22170 |
| github.com (#45200) | https://github.com/anthropics/claude-code/issues/45200 |
| paths field in ~/.claude/rules/ frontmatter not working - rules with paths are not loaded | https://claudeissues.com/issue/22170-paths-field-in-claude-rules-frontmatter-not-working-rules-with-paths-are-not-loa |
| Documentation: .claude/rules/ frontmatter format incorrect - globs works, paths with quotes/YAML list does not | https://claudeissues.com/issue/17204-documentation-claude-rules-frontmatter-format-incorrect-globs-works-paths-with-q |
| Documentation/Feature: paths frontmatter in .claude/rules/ does not enable lazy loading | https://claudeissues.com/issue/15710-documentation-feature-paths-frontmatter-in-claude-rules-does-not-enable-lazy-loa |

## 検索ツールが付けた要約（原文のまま）

> The search turned up several open or recent user bug reports that match your symptom, though none is official documentation or a confirmed fix.
>
> - **Shell reads don't trigger loading:** One report (issue 79984, filed against v2.1.216) says a path-scoped rule in `.claude/rules/` loads only when a matching file is opened with the Read tool. Bash-based reads such as `cat`, `grep`, and `git show` didn't inject it, and Write didn't either. The reporter also notes there is no diagnostic showing that a matching rule existed but wasn't applied. A `.claude/rules/*.md` file with `paths:` frontmatter is injected into context only when a matching file is opened with the Read tool. It is not injected when the agent touches a matching file any other way.
> - **Same pattern for CLAUDE.md:** A separate report (issue 90449) says subdirectory CLAUDE.md files are triggered by the Read tool only, not by shell commands. It also says the path-scoped `.claude/rules/` behavior matches this, and that the failure is silent. A second Read of a different file in an already-loaded directory injects nothing, so a single early shell read costs that directory's memory for the whole session.
> - **Frontmatter format issues:** Other reports describe `paths:` not loading at all in some formats. Issue 17204 says quoted `paths:` values and YAML lists failed in that user's testing, while an unquoted `paths:` value and `globs:` loaded. Issue 15710 says all rule files load at startup regardless of `paths:`, which is a different complaint about lazy loading.
> - **Status:** Issue 17204 is marked resolved (May 2026), issue 22170 is closed, and issue 16853 (opened January 2026) is still open. I did not find an official Anthropic statement on whether shell-read injection is intended.

## 扱い

- 要約の「none is … a confirmed fix」は検索時点の二次情報の見え方。実際には changelog 2.1.288 / 2.1.293 に修正が記載されており、実測でも確認した（`検証/発火テスト結果_2026-10-10.md`）
- issue のステータス（open / closed）は対応状況を表さない（作業指示者の指摘。`03` §3 参照）
