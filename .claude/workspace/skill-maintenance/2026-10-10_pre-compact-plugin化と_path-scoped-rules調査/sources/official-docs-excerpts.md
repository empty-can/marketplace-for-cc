# 公式 docs 抜粋（根拠箇所の原文）

- 取得元: `/c/cc-workspace/LLMs/official-llms-txts/code.claude.com/docs/llms-full.txt`
- ミラーの更新日時: 2026-10-10 15:00:04.085164800 +0900
- ミラーの行数: 120369
- 抽出日時: 2026-10-10 18:50:51 +0900
- 抽出スクリプト: `scripts/extract-doc-excerpts.sh`（見出しを起点に抽出。行番号はミラー更新でずれる）

各ブロックの行頭の数字は、抽出時点の llms-full.txt の行番号。

---

## best-practices: /compact の指示例と CLAUDE.md の圧縮指示（pre-compact skill が引用する公式情報）（2450-2452 行、起点: `For more control, run `/compact <instructions>`` #1）

```text
  2450: * For more control, run `/compact <instructions>`, like `/compact Focus on the API changes`
  2451: * To compact only part of the conversation, use `Esc + Esc` or `/rewind`, select a message checkpoint, and choose **Summarize from here** or **Summarize up to here**. The first condenses messages from that point forward while keeping earlier context intact; the second condenses earlier messages while keeping recent ones in full. See [the rewind menu's summarize options](/docs/en/checkpointing#rewind-and-summarize).
  2452: * Customize compaction behavior in CLAUDE.md with instructions like `"When compacting, always preserve the full list of modified files and any test commands"` to ensure critical context survives summarization
```

---

## context-window: What survives compaction（16444-16489 行、起点: `## What survives compaction` #1）

```text
 16444: ## What survives compaction
 16445: 
 16446: When a long session compacts, Claude Code summarizes the conversation history to fit the context window. As of v2.1.198, the summarization request inherits your session's [extended thinking](/docs/en/model-config#extended-thinking) configuration, so it reasons with thinking enabled when your session has it enabled and stays off otherwise. Thinking affects only how the summary is produced; your session settings are unchanged afterward. What happens to each kind of content depends on how it was loaded:
 16447: 
 16448: | Mechanism | After compaction |
 16449: | :- | :- |
 16450: | System prompt and output style | Both still apply |
 16451: | Project-root CLAUDE.md and unscoped rules | Re-injected from disk |
 16452: | Auto memory | Re-injected from disk |
 16453: | [Git status snapshot](/docs/en/settings-reference#includegitinstructions) | Claude Code reads a fresh one from your repository |
 16454: | The plan Claude wrote in [plan mode](/docs/en/permission-modes#analyze-before-you-edit-with-plan-mode) | Re-injected from disk |
 16455: | Rules with `paths:` frontmatter | Claude Code reloads them [on demand](/docs/en/memory#path-specific-rules) |
 16456: | Nested CLAUDE.md in subdirectories | Claude Code reloads them [on demand](/docs/en/memory#how-claude-md-files-load) |
 16457: | Files Claude read or edited | Claude Code re-reads up to five, most recently modified first |
 16458: | Invoked skill bodies | Re-injected, capped at 5,000 tokens per skill and 25,000 tokens total; oldest dropped first |
 16459: | [Background commands](/docs/en/interactive-mode#background-bash-commands) and background [subagents](/docs/en/sub-agents#run-subagents-in-foreground-or-background) | Keep running. Claude Code reminds Claude which ones are still running so it doesn't start a duplicate |
 16460: | Context that hooks added earlier | Summarized with the rest of the conversation |
 16461: | [SessionStart hooks](/docs/en/hooks-guide#re-inject-context-after-compaction) that match the `compact` source | Claude Code runs them and adds their output to the compacted context |
 16462: 
 16463: Right after compaction, Claude Code re-reads up to five of the files Claude has read or edited in the session, choosing the ones modified most recently. A file over 5,000 tokens comes back as a path reference without its content, shown as `Referenced file` instead of `Read`.
 16464: 
 16465: Path-scoped rules and nested CLAUDE.md files load into message history when Claude reads, writes, or edits their trigger file, so compaction summarizes them away with everything else. If a rule must persist across compaction, drop the `paths:` frontmatter or move it to the project-root CLAUDE.md.
 16466: 
 16467: Skill bodies are re-injected after compaction, but large skills are truncated to fit the per-skill cap, and the oldest invoked skills are dropped once the total budget is exceeded. Truncation keeps the start of the file, so put the most important instructions near the top of `SKILL.md`.
 16468: 
 16469: ## When your context fills up
 16470: 
 16471: Claude Code compacts automatically as you approach the limit, so a full context window doesn't end your session. The automatic pass works the same way as the `/compact` step in the timeline. See [When context fills up](/docs/en/how-claude-code-works#when-context-fills-up) for what it preserves.
 16472: 
 16473: You can also act before the automatic pass runs:
 16474: 
 16475: * **Compact with a focus**: run `/compact` with instructions, like `/compact focus on the auth bug fix`, before starting a long new task. The summary keeps what you choose instead of what the automatic pass guesses is important.
 16476: * **Compact part of the conversation**: run `/rewind`, select a message, and choose **Summarize from here** or **Summarize up to here**. See [Rewind and summarize](/docs/en/checkpointing#rewind-and-summarize) for what each option keeps and how to guide the summary.
 16477: * **Compact earlier**: run [`/autocompact`](/docs/en/commands#all-commands) with a token count, like `/autocompact 500k`, to set how full the context window gets before the automatic pass runs. See [Set the auto-compact window](/docs/en/model-config#set-the-auto-compact-window) for accepted values and overrides.
 16478: * **Clear between tasks**: run `/clear` when switching to unrelated work. Old conversation crowds out the files you need next and costs tokens on every message.
 16479: * **Delegate large reads**: send research to a [subagent](/docs/en/sub-agents) so the file contents stay in its context window, not yours.
 16480: 
 16481: If you need a larger window rather than a smaller conversation, Fable models, Sonnet 5 and later, Haiku 5.5, Opus 4.6 and later, and Sonnet 4.6 support a 1 million token context window. See [Extended context](/docs/en/model-config#extended-context) for availability by plan and how to select a `[1m]` model variant. Compaction works the same way at the larger limit.
 16482: 
 16483: The point where automatic compaction runs depends on your model and configuration. See [Default auto-compact thresholds](/docs/en/model-config#default-auto-compact-thresholds) for the boundaries per model, and [Correct the window for a gateway or custom model ID](/docs/en/model-config#correct-the-window-for-a-gateway-or-custom-model-id) if Claude Code assumes the wrong window for your model ID, such as an [LLM gateway](/docs/en/llm-gateway) alias.
 16484: 
 16485: ## Check your own session
 16486: 
 16487: The visualization uses representative numbers. To see your actual context usage at any point, run `/context` for a live breakdown by category with optimization suggestions, including which CLAUDE.md and auto memory files loaded. Run `/memory` to open and edit those files.
 16488: 
 16489: ## Related resources
```

---

## commands: /clear と /compact の行（61440-61444 行、起点: `| `/clear [name]`` #1）

```text
 61440: | `/clear [name]` | Start a new conversation with empty context. Pass a name to label the previous conversation in the `/resume` picker. To free up context while continuing the same conversation, use `/compact` instead. Resume the previous conversation with `/resume`, or, in the same Claude Code process, restore it from [the rewind menu's previous-session entry](/docs/en/checkpointing#rewind-past-a-cleared-conversation). Aliases: `/reset`, `/new` |
 61441: | `/code-review [low\|medium\|high\|xhigh\|max\|ultra] [--fix] [--comment] [--max-findings n\|all\|default] [pr#\|branch\|path]` | **[Skill](/docs/en/skills#bundled-skills).** Review the current diff, or a PR number, branch, or path you pass, for correctness bugs. Depending on your model and effort level, the review also covers cleanup opportunities. Pass `--fix` to apply findings, `--comment` to post them on the GitHub PR or GitLab merge request, or `ultra` to run a deep [cloud review](/docs/en/ultrareview). Posting to a GitLab merge request requires Claude Code v2.1.257 or later. With `ultra` on a `github.com` PR target, pass `--post` to preselect [posting the finished findings to the PR](/docs/en/ultrareview#post-findings-to-the-pull-request) in the launch dialog; `--post` requires Claude Code v2.1.227 or later. See [Review a diff locally](/docs/en/code-review#review-a-diff-locally) for the effort levels, targeting, and how it relates to `/simplify`. Alias: `/review` |
 61442: | `/color [color\|default]` | Set the prompt bar color for the current session. Available colors: `red`, `blue`, `green`, `yellow`, `purple`, `orange`, `pink`, `cyan`. Use `default` to reset, or run with no argument to pick a random color. When [Remote Control](/docs/en/remote-control) is connected, the color syncs to claude.ai/code. Also available in non-interactive mode (`-p`); requires Claude Code v2.1.205 or later |
 61443: | `/compact [instructions]` | Free up context by summarizing the conversation so far. Optionally pass focus instructions for the summary. See [how compaction handles rules, skills, and memory files](/docs/en/context-window#what-survives-compaction) |
 61444: | `/config [key=value ...]` | Open the [Settings](/docs/en/settings) interface to adjust theme, model, [output style](/docs/en/output-styles), and other preferences. Pass one or more `key=value` pairs to set a setting directly without opening the interface, for example `/config thinking=false`, `/config theme=dark`, or `/config model=sonnet`. The `key=value` form also works in non-interactive mode (`-p`) and from the Claude mobile app via [Remote Control](/docs/en/remote-control). The `key=value` form can't turn on a setting that needs your confirmation in the panel, such as [`autoContinueAtUsageLimit`](/docs/en/interactive-mode#turn-automatic-continue-off), though it can turn one off. Run `/config --help` to list the keys it accepts. Alias: `/settings` |
```

---

## commands: /reload-plugins /reload-skills（61497-61499 行、起点: `| `/reload-plugins [--force]`` #1）

```text
 61497: | `/reload-plugins [--force]` | Reload all active [plugins](/docs/en/plugins/overview) to apply pending changes without restarting. Reports counts for each reloaded component and flags any load errors. When the reload would change which MCP tools are loaded and invalidate the prompt cache, the command warns and skips unless you pass `--force`. Also available in non-interactive mode (`-p`), the Agent SDK, and the desktop app, where it runs only on input typed directly into the session and doesn't apply plugin MCP server changes; requires Claude Code v2.1.260 or later. See [Apply plugin changes without restarting](/docs/en/plugins/cli-reference#reload-plugins) |
 61498: | `/reload-skills` | Re-scan [skill](/docs/en/skills) and command directories so skills added or changed on disk during the session become available without restarting. Reports how many skills are available and how many were added or removed |
 61499: | `/remote-control` | Make this session available for [Remote Control](/docs/en/remote-control) from claude.ai. Running it while signed out prints that Remote Control requires a claude.ai subscription and tells you how to sign in; before v2.1.206 it reported `Unknown command: /remote-control`. Alias: `/rc` |
```

---

## memory: Instructions seem lost after /compact（31170-31177 行、起点: `### Instructions seem lost after `/compact`` #1）

```text
 31170: ### Instructions seem lost after `/compact`
 31171: 
 31172: Project-root CLAUDE.md survives compaction: after `/compact`, Claude re-reads it from disk and re-injects it into the session. Nested CLAUDE.md files in subdirectories and rules with [`paths:` frontmatter](#path-specific-rules) load again on demand.
 31173: 
 31174: If an instruction disappeared after compaction, it was given only in conversation, lives in a nested CLAUDE.md that hasn't reloaded yet, or is a path-scoped rule that hasn't matched a file since. Add conversation-only instructions to CLAUDE.md to make them persist. See [What survives compaction](/docs/en/context-window#what-survives-compaction) for the full breakdown.
 31175: 
 31176: See [Write effective instructions](#write-effective-instructions) for guidance on size, structure, and specificity.
 31177: 
```

---

## checkpointing: Rewind and summarize（56511-56540 行、起点: `### Rewind and summarize` #1）

```text
 56511: ### Rewind and summarize
 56512: 
 56513: Run `/rewind`, or press `Esc` twice when the prompt input is empty, to open the rewind menu.
 56514: 
 56515: <Note>
 56516:   If the prompt input contains text, double `Esc` clears it instead of opening the menu. The cleared text is saved to your input history, so press `Up` to recall it after you finish in the rewind menu.
 56517: </Note>
 56518: 
 56519: The rewind menu lists the prompts you sent during the session. Select the point you want to act on, then choose an action:
 56520: 
 56521: * **Restore code and conversation**: revert both code and conversation to that point
 56522: * **Restore conversation**: rewind to that message while keeping current code
 56523: * **Restore code**: revert file changes while keeping the conversation
 56524: * **Summarize from here**: compress the conversation from this point forward into a summary, freeing context window space
 56525: * **Summarize up to here**: compress the conversation before this point into a summary, keeping later messages intact
 56526: * **Never mind**: return to the message list without making changes
 56527: 
 56528: The two code restore options appear only when the selected checkpoint has tracked file changes to revert. If no file edits were captured after that point, the menu offers only **Restore conversation**, the summarize options, and **Never mind**.
 56529: 
 56530: After restoring the conversation or choosing Summarize from here, the original prompt from the selected message is restored into the input field so you can re-send or edit it.
 56531: 
 56532: Choosing Summarize up to here leaves you at the end of the conversation with the input empty. With either summarize option, a **Summarized conversation** marker appears in the conversation where the compressed messages were.
 56533: 
 56534: #### Rewind past a cleared conversation
 56535: 
 56536: If you ran `/clear` earlier in the same Claude Code process, the rewind menu shows an additional entry at the top of the list labeled `/resume <session-id> (previous session)`. Select it to resume the conversation that was active before `/clear` ran. The entry is available until you exit Claude Code or resume a different session.
 56537: 
 56538: #### Guide a summary
 56539: 
 56540: Summarizing doesn't change files on disk, and the original messages stay in the session transcript, so Claude can still reference the details. To guide what the summary focuses on, highlight a **Summarize** option with the arrow keys and type instructions where the row reads **add context (optional)**, then press `Enter`. Selecting the option with its number key summarizes immediately without instructions.
```

---

## agent-sdk: /compact（SDK からの実行）（107989-107994 行、起点: `### Compact history with `/compact`` #1）

```text
107989: ### Compact history with `/compact`
107990: 
107991: The `/compact` command reduces the size of your conversation history by summarizing older messages while preserving important context. Compaction needs an existing conversation with enough prior messages to summarize. This example has a conversation first, then compacts it and reads the `compact_boundary` system message that reports the result:
107992: 
107993: <CodeGroup>
107994:   ```typescript TypeScript theme={null}
```

---

## agent-sdk: /clear（108072-108077 行、起点: `### Reset context with `/clear`` #1）

```text
108072: ### Reset context with `/clear`
108073: 
108074: The `/clear` command resets the conversation to an empty context, so subsequent prompts start with no prior conversation history. The previous conversation remains on disk. You can return to that conversation by passing its session ID to the [`resume` option](/docs/en/agent-sdk/sessions#resume-by-id).
108075: 
108076: `/clear` is useful in [streaming input mode](/docs/en/agent-sdk/streaming-vs-single-mode), where you send multiple prompts over a single connection. For one-shot `query()` calls, each call already starts with empty context, so sending `/clear` has no practical effect. Start a new `query()` instead.
108077: 
```

---

## memory: CLAUDE.md vs auto memory（30571-30586 行、起点: `## CLAUDE.md vs auto memory` #1）

```text
 30571: ## CLAUDE.md vs auto memory
 30572: 
 30573: Claude Code has two complementary memory systems. Both are loaded at the start of every conversation. Claude treats them as context, not enforced configuration. To block an action regardless of what Claude decides, use a [PreToolUse hook](/docs/en/hooks-guide) instead. The more specific and concise your instructions, the more consistently Claude follows them.
 30574: 
 30575: | | CLAUDE.md files | Auto memory |
 30576: | :- | :- | :- |
 30577: | **Who writes it** | You | Claude |
 30578: | **What it contains** | Instructions and rules | Learnings and patterns |
 30579: | **Scope** | Project, user, or org | Per repository, shared across worktrees |
 30580: | **Loaded into** | Every session | Every session (first 200 lines or 25KB) |
 30581: | **Use for** | Coding standards, workflows, project architecture | Your preferences, corrections you give Claude, project context Claude can't derive from the code |
 30582: 
 30583: Use CLAUDE.md files when you want to guide Claude's behavior. Auto memory lets Claude learn from your corrections without manual effort.
 30584: 
 30585: Subagents can also maintain their own auto memory. See [subagent configuration](/docs/en/sub-agents#enable-persistent-memory) for details.
 30586: 
```

---

## memory: nested CLAUDE.md の読み込み条件（30695-30700 行、起点: `Claude also discovers `CLAUDE.md` and `CLAUDE.local.md` files in subdirectories` #1）

```text
 30695: Claude also discovers `CLAUDE.md` and `CLAUDE.local.md` files in subdirectories under your current working directory. Instead of loading them at launch, Claude Code loads each one once Claude reads, writes, or edits another file in that subdirectory. Reading includes viewing the file with a Bash command that [counts as a read](/docs/en/tools-reference#edit-tool-behavior), such as `cat` or `head` on a single file. For files inside a worktree under `.claude/worktrees/`, see [Isolate subagents with worktrees](/docs/en/worktrees#isolate-subagents-with-worktrees).
 30696: 
 30697: If you work in a large monorepo where other teams' CLAUDE.md files get picked up, use [`claudeMdExcludes`](#exclude-specific-claude-md-files) to skip them. For the full layout of root and per-directory CLAUDE.md files and rules, see [Monorepos and large repos](/docs/en/large-codebases).
 30698: 
 30699: Block-level HTML comments (`<!-- maintainer notes -->`) in CLAUDE.md files are stripped before the content is injected into Claude's context. Use them to leave notes for human maintainers without spending context tokens on them. Comments inside code blocks are preserved. When you open a CLAUDE.md file directly with the Read tool, comments remain visible.
 30700: 
```

---

## memory: Path-specific rules と Rule frontmatter reference（30741-30800 行、起点: `#### Path-specific rules` #1）

```text
 30741: #### Path-specific rules
 30742: 
 30743: Rules can be scoped to specific files using YAML frontmatter with the `paths` field. These conditional rules only apply when Claude is working with files matching the specified patterns.
 30744: 
 30745: ```markdown theme={null}
 30746: ---
 30747: paths:
 30748:   - "src/api/**/*.ts"
 30749: ---
 30750: 
 30751: # API Development Rules
 30752: 
 30753: - All API endpoints must include input validation
 30754: - Use the standard error response format
 30755: - Include OpenAPI documentation comments
 30756: ```
 30757: 
 30758: Rules without a `paths` field are loaded unconditionally and apply to all files. A path-scoped rule loads when Claude uses the Read, Write, or Edit tool on a matching file. It also loads when Claude views a matching file with a Bash command that [counts as a read](/docs/en/tools-reference#edit-tool-behavior), such as `cat` or `head` on a single file. Matching also works when Claude reaches a file through a symlinked path to the project directory, for example in a symlinked checkout.
 30759: 
 30760: Use glob patterns in the `paths` field to match files by extension, directory, or any combination:
 30761: 
 30762: | Pattern | Matches |
 30763: | - | - |
 30764: | `**/*.ts` | All TypeScript files in any directory |
 30765: | `src/**/*` | All files under `src/` directory |
 30766: | `*.md` | Markdown files in the project root |
 30767: | `src/components/*.tsx` | React components in a specific directory |
 30768: 
 30769: You can specify multiple patterns and use brace expansion to match multiple extensions in one pattern:
 30770: 
 30771: ```markdown theme={null}
 30772: ---
 30773: paths:
 30774:   - "src/**/*.{ts,tsx}"
 30775:   - "lib/**/*.ts"
 30776:   - "tests/**/*.test.ts"
 30777: ---
 30778: ```
 30779: 
 30780: Each brace group multiplies the number of expanded patterns: `src/*.{ts,tsx}` expands to two patterns, and `{a,b}/{c,d}/*.{ts,tsx}` to eight. To keep expansion bounded, a rule's whole `paths` list shares one budget of 1,000 expanded patterns and 4 MiB, and patterns without braces don't count against it.
 30781: 
 30782: Claude Code uses any pattern that would exceed the budget unexpanded, and its literal braces match no files. Before v2.1.217, a `paths` value with many brace groups stalled or crashed the CLI at startup.
 30783: 
 30784: Glob syntax treats `[` as the start of a bracket expression such as `[abc]`. A pattern with a `[` that can't be read as a bracket expression, such as `photos [2024/**`, is invalid: it matches nothing, and the rule's other patterns keep working. To match a literal `[` in a file name, escape it as `photos \[2024/**`. Before v2.1.207, one invalid pattern made the Read tool fail for every file the rule was evaluated against, instead of matching nothing.
 30785: 
 30786: #### Rule frontmatter reference
 30787: 
 30788: Configure a rule with YAML [frontmatter](/docs/en/glossary#frontmatter) between `---` markers at the top of the file. `paths` is the only field Claude Code reads from a rule; any other field is ignored without an error. Claude Code removes the frontmatter before loading the rule into context.
 30789: 
 30790: | Field | Required | Description |
 30791: | :- | :- | :- |
 30792: | `paths` | No | Glob patterns that [scope the rule to matching files](#path-specific-rules). Accepts a YAML list or a comma-separated string |
 30793: 
 30794: If the YAML between the markers doesn't parse, Claude Code ignores the frontmatter and loads the rule as if it had no `paths`. Run `claude --debug` to see the parse error.
 30795: 
 30796: #### Share rules across projects with symlinks
 30797: 
 30798: The `.claude/rules/` directory supports symlinks, so you can maintain a shared set of rules and link them into multiple projects. Circular symlinks are detected and handled gracefully.
 30799: 
 30800: Claude Code treats a symlink whose target is outside your working directory like an [external import](#import-additional-files). The linked rules don't load until you approve external imports for the project, and after that only the ones without a [`paths` field](#path-specific-rules) load.
```

---

## memory: Auto memory（保存先・MEMORY.md の制限）（31021-31110 行、起点: `## Auto memory` #1）

```text
 31021: ## Auto memory
 31022: 
 31023: Auto memory lets Claude accumulate knowledge across sessions without you writing anything. As it works, Claude saves four kinds of notes for itself. Claude records the kind as a `type` field in the memory file's frontmatter:
 31024: 
 31025: * `user`: your role, expertise, and working preferences
 31026: * `feedback`: corrections you give Claude and approaches you confirm
 31027: * `project`: ongoing work, deadlines, and decisions that Claude can't derive from the code or git history
 31028: * `reference`: where to find information outside the project, such as an issue tracker or dashboard
 31029: 
 31030: Claude skips anything it can derive from the codebase, such as architecture, file paths, or debugging fixes. It also skips anything your CLAUDE.md files already say.
 31031: 
 31032: Claude doesn't save something every session. It decides what's worth remembering based on whether the information would be useful in a future conversation.
 31033: 
 31034: ### Enable or disable auto memory
 31035: 
 31036: Auto memory is on by default in local sessions. Outside [Claude Tag](https://claude.com/docs/claude-tag/overview) sessions, a session in a [self-hosted environment](/docs/en/self-hosted-environments-configuration#how-each-session’s-config-is-assembled) runs with auto memory off by default.
 31037: 
 31038: To toggle it, open `/memory` in a session and use the auto memory toggle, which saves `autoMemoryEnabled` to your user settings at `~/.claude/settings.json`.
 31039: 
 31040: The toggle turns auto memory off but doesn't turn it back on in these sessions:
 31041: 
 31042: * A [background session](/docs/en/agent-view)
 31043: * A session that another Claude Code session started, such as when Claude runs `claude` through its Bash tool
 31044: 
 31045: While auto memory is off there, the toggle reads `off · can't be turned on here; use a session started outside Claude Code`. To turn auto memory back on, run `claude` directly in your terminal and use the `/memory` toggle in that session.
 31046: 
 31047: To turn it off for a single project, set `autoMemoryEnabled` in that project's settings:
 31048: 
 31049: ```json theme={null}
 31050: {
 31051:   "autoMemoryEnabled": false
 31052: }
 31053: ```
 31054: 
 31055: To disable auto memory via environment variable, set `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`.
 31056: 
 31057: ### Storage location
 31058: 
 31059: Each project gets its own memory directory at `~/.claude/projects/<project>/memory/`. The `<project>` path is derived from the git repository, so all worktrees and subdirectories within the same repo share one auto memory directory. Outside a git repo, the project root is used instead.
 31060: 
 31061: If you set [`CLAUDE_CODE_PROJECT_DIR_NAME`](/docs/en/sessions#name-the-project-directory-yourself) beside `CLAUDE_CONFIG_DIR`, Claude Code uses that name as the `<project>` directory under `<config dir>/projects/` instead, whichever repository you launch it in, so projects launched with that config directory share one auto memory directory. Requires Claude Code v2.1.234 or later.
 31062: 
 31063: To store auto memory in a different location, set `autoMemoryDirectory` in your `settings.json`. It is read from any [settings scope](/docs/en/settings#settings-precedence): user, project, local, policy, or `--settings`.
 31064: 
 31065: ```json theme={null}
 31066: {
 31067:   "autoMemoryDirectory": "~/my-custom-memory-dir"
 31068: }
 31069: ```
 31070: 
 31071: The value must be an absolute path or start with `~/`.
 31072: 
 31073: When you set it in a project's `.claude/settings.json` or `.claude/settings.local.json`, Claude Code honors it under the same [workspace trust rule as hooks in settings files](/docs/en/permissions#what-runs-before-you-trust-a-folder). While [`permissions.blockReadsOutsideWorkingDirectories`](/docs/en/settings-reference#permissions-blockreadsoutsideworkingdirectories) is on, Claude Code loads no auto memory from a directory that a [repository-supplied settings file](/docs/en/permissions#when-your-local-settings-file-needs-trust) chooses and saves none to it, wherever that directory sits.
 31074: 
 31075: The directory contains a `MEMORY.md` index and one topic file per memory:
 31076: 
 31077: ```text theme={null}
 31078: ~/.claude/projects/<project>/memory/
 31079: ├── MEMORY.md           # Index, one line per memory, loaded into every session
 31080: ├── user_role.md        # One memory
 31081: ├── feedback_testing.md # One memory
 31082: └── ...                 # Any other topic files Claude creates
 31083: ```
 31084: 
 31085: `MEMORY.md` acts as an index of the memory directory. Claude reads and writes files in this directory throughout your session, using `MEMORY.md` to keep track of what's stored where.
 31086: 
 31087: Auto memory is machine-local. All worktrees and subdirectories within the same git repository share one auto memory directory. Files are not shared across machines or cloud environments.
 31088: 
 31089: Claude Code deletes old session transcripts after the [`cleanupPeriodDays`](/docs/en/settings-reference#cleanupperioddays) retention period, but excludes the memory files in the memory directory from that [retention sweep](/docs/en/claude-directory#cleaned-up-automatically). `MEMORY.md` and topic files stay until you or Claude edits or deletes them.
 31090: 
 31091: ### How it works
 31092: 
 31093: The first 200 lines of `MEMORY.md`, or the first 25KB, whichever comes first, are loaded at the start of every conversation. Content beyond that threshold is not loaded at session start. Claude keeps `MEMORY.md` concise by moving detailed notes into separate topic files.
 31094: 
 31095: After Claude writes to `MEMORY.md`, Claude Code measures the file against the 200-line and 25KB read limits. If the file is near a limit, Claude Code reminds Claude to shorten it: keep one line per entry, move detail into topic files, and merge or drop stale entries. If the file is over a limit, the write still succeeds, but Claude Code returns an [error telling Claude to rewrite the index](/docs/en/errors#memory-index-is-over-its-read-limit), because everything past the limit is dropped on the next load.
 31096: 
 31097: This limit applies only to `MEMORY.md`. Claude Code loads a CLAUDE.md file of up to 4 MiB in full and skips a larger file. Shorter files produce better adherence.
 31098: 
 31099: Claude Code doesn't load topic files such as `user_role.md` or `feedback_testing.md` at startup. Claude reads them on demand using its standard file tools when it needs the information.
 31100: 
 31101: The main conversation's auto memory isn't loaded into [subagents](/docs/en/sub-agents#what-loads-at-startup); the exception is a [fork](/docs/en/sub-agents#fork-the-current-conversation), which inherits the parent conversation and system prompt. A subagent's own auto memory, enabled with the subagent `memory` field, is a separate directory.
 31102: 
 31103: Claude reads and writes memory files during your session. When you see messages like "Saved 2 memories" or "Recalled 2 memories" in the Claude Code interface, Claude is actively updating or reading from `~/.claude/projects/<project>/memory/`.
 31104: 
 31105: When Claude writes a memory file that begins with YAML frontmatter, Claude Code records the write time in a `modified` frontmatter field as an ISO 8601 timestamp. The timestamp shows how current the fact is, both to you and to Claude when it reads the memory back. Any file that has frontmatter gets the field the next time Claude writes it, including files created on earlier versions; Claude Code never adds frontmatter to a file that has none. The `modified` field requires Claude Code v2.1.214 or later.
 31106: 
 31107: ### Audit and edit your memory
 31108: 
 31109: Auto memory files are plain markdown you can edit or delete at any time. Run [`/memory`](#view-and-edit-with-%2Fmemory) to browse and open memory files from within a session.
 31110: 
```

---

## tools-reference: Edit tool の read-before-edit と Bash で読み取り扱いになるコマンド（96627-96642 行、起点: `## Edit tool behavior` #1）

```text
 96627: ## Edit tool behavior
 96628: 
 96629: The Edit tool performs exact string replacement. It takes an `old_string` and a `new_string` and replaces the first with the second. It doesn't use regex or fuzzy matching.
 96630: 
 96631: Three checks must pass for an edit to apply. Before any of them, a path matched by a [`Read` deny rule](/docs/en/permissions#tool-specific-permission-rules) is refused, including creating a new file there. The refusal requires Claude Code v2.1.208 or later.
 96632: 
 96633: * **Read-before-edit**: Claude reads the file in the current conversation before editing it, and a read cut short with a [`PARTIAL view` notice](#read-tool-behavior) doesn't count. Claude Opus 4.6, Claude Haiku 4.5, and older models always require the read. Newer models can edit an unread file when reading it wouldn't need a permission prompt and the Read tool is available.
 96634: * **Match**: `old_string` must appear in the file exactly as written. A single character of whitespace or indentation difference is enough to miss.
 96635: * **Uniqueness**: `old_string` must appear exactly once. When it appears more than once, Claude either supplies a longer string with enough surrounding context to pin down one occurrence, or sets `replace_all: true` to replace them all.
 96636: 
 96637: A file that changed on disk after Claude last read it can still be edited when `old_string` matches the current content exactly and unambiguously and Claude Code can read the file without prompting. Matching against the file's current content keeps this safe, and the result notes that the file carries other changes so Claude re-reads it before edits that depend on surrounding content. In any other case, such as a stale `old_string` or one that matches more than once without `replace_all`, Claude reads the file again before editing. The relaxed handling of unread and changed files requires Claude Code v2.1.208 or later; before that, Claude Code refused any edit to a file it hadn't read in the conversation or that changed on disk after the read.
 96638: 
 96639: Viewing a file with Bash also satisfies the read-before-edit requirement when the command is `cat`, `nl`, `bat`, `batcat`, `head`, `tail`, `sed -n 'X,Yp'`, `grep`, `egrep`, `fgrep`, or `rg` on a single file with no pipes or redirects. Piped output and other Bash commands don't count toward the read-before-edit check.
 96640: 
 96641: When Claude views a file this way, Claude Code also loads any [subdirectory `CLAUDE.md`](/docs/en/memory#how-claude-md-files-load) and [path-scoped rules](/docs/en/memory#path-specific-rules) that apply to that file. See [Read and Edit permission rules](/docs/en/permissions#read-and-edit) for which Bash commands your `Read` and `Edit` deny rules cover.
 96642: 
```

---

## tools-reference: Glob / Grep ツールの既定の有無（96673-96684 行、起点: `## Glob tool behavior` #1）

```text
 96673: ## Glob tool behavior
 96674: 
 96675: The Glob tool finds files by name pattern. On Windows, it's part of the default tool set. On macOS, Linux, and WSL, Claude Code leaves Glob and [Grep](#grep-tool-behavior) out of the default tool set, and Claude searches with `find` and `grep` through the Bash tool instead. In Claude's shell those two commands run embedded versions of `bfs` and `ugrep`, and the searches reach your hooks and permission rules as `Bash` calls.
 96676: 
 96677: On macOS, Linux, and WSL, you get the Glob and Grep tools back in these cases:
 96678: 
 96679: * You name `Glob` or `Grep` in [`--tools` or `--allowedTools`](/docs/en/cli-reference#cli-flags) when you start the session, or in the equivalent [Agent SDK](/docs/en/agent-sdk/overview) options. With `--tools` you get the ones you list, and naming either tool in `--allowedTools` restores both. An allow rule in a settings file doesn't have this effect.
 96680: * A permissions [deny rule](/docs/en/permissions#match-all-uses-of-a-tool), the `--disallowedTools` flag, or [`--restricted`](/docs/en/cli-reference#cli-flags) removes `Bash` from the session.
 96681: * A [subagent](/docs/en/sub-agents#available-tools) lists `Glob` or `Grep` in its `tools` field and leaves out `Bash`. The listed tools come back for that subagent only, or for the whole session when it runs as the main session agent through [`--agent`](/docs/en/sub-agents#invoke-subagents-explicitly) or the `agent` setting.
 96682: 
 96683: Glob supports standard glob syntax including `**` for recursive directory matching:
 96684: 
```

---

## hooks: InstructionsLoaded（66803-66852 行、起点: `### InstructionsLoaded` #1）

```text
 66803: ### InstructionsLoaded
 66804: 
 66805: Fires when a `CLAUDE.md` or `.claude/rules/*.md` file is loaded into context. This event fires at session start for eagerly loaded files and again later when files are lazily loaded, for example when Claude accesses a subdirectory that contains a nested `CLAUDE.md` or when conditional rules with `paths:` frontmatter match. The hook doesn't support blocking or decision control. It runs asynchronously for observability purposes.
 66806: 
 66807: This event doesn't fire when Claude [reads `AGENTS.md` directly](/docs/en/memory#agents-md) through the **Project instructions** setting. It does fire when a `CLAUDE.md` imports your `AGENTS.md`, with `load_reason` set to `include` as for any other imported file, and when `CLAUDE.md` is a symlink to it, as a normal `CLAUDE.md` load.
 66808: 
 66809: The matcher runs against `load_reason`. For example, use `"matcher": "session_start"` to fire only for files loaded at session start, or `"matcher": "path_glob_match|nested_traversal"` to fire only for lazy loads.
 66810: 
 66811: #### InstructionsLoaded input
 66812: 
 66813: In addition to the [common input fields](#common-input-fields), InstructionsLoaded hooks receive these fields:
 66814: 
 66815: | Field | Description |
 66816: | :- | :- |
 66817: | `file_path` | Absolute path to the instruction file that was loaded |
 66818: | `memory_type` | Scope of the file: `"User"`, `"Project"`, `"Local"`, or `"Managed"` |
 66819: | `load_reason` | Why the file was loaded: `"session_start"`, `"nested_traversal"`, `"path_glob_match"`, `"include"`, or `"compact"`. The `"compact"` value fires when instruction files are re-loaded after a compaction event |
 66820: | `globs` | Path glob patterns from the file's `paths:` frontmatter, if any. Present only for `path_glob_match` loads |
 66821: | `trigger_file_path` | Path to the file whose access triggered this load, for lazy loads |
 66822: | `parent_file_path` | Path to the parent instruction file that included this one, for `include` loads |
 66823: 
 66824: ```json theme={null}
 66825: {
 66826:   "session_id": "abc123",
 66827:   "transcript_path": "/Users/.../.claude/projects/.../transcript.jsonl",
 66828:   "cwd": "/Users/my-project",
 66829:   "hook_event_name": "InstructionsLoaded",
 66830:   "file_path": "/Users/my-project/CLAUDE.md",
 66831:   "memory_type": "Project",
 66832:   "load_reason": "session_start"
 66833: }
 66834: ```
 66835: 
 66836: #### InstructionsLoaded decision control
 66837: 
 66838: InstructionsLoaded hooks have no decision control. They can't block or modify instruction loading. Claude Code discards their [JSON output fields](#json-output), such as `systemMessage` and `continue`. Use this event for audit logging, compliance tracking, or observability.
 66839: 
 66840: ### UserPromptSubmit
 66841: 
 66842: Runs when a prompt is submitted, before Claude processes it. This allows you
 66843: to add additional context based on the prompt/conversation, validate prompts, or
 66844: block certain types of prompts.
 66845: 
 66846: `UserPromptSubmit` hooks don't fire only on prompts you type. Claude Code also runs them on:
 66847: 
 66848: * A [scheduled task](/docs/en/scheduled-tasks) firing, including a `/loop` iteration
 66849: * A [background subagent](/docs/en/sub-agents#run-subagents-in-foreground-or-background) reporting back to the session that started it
 66850: * A [message another session sends](/docs/en/cross-session-messaging) to your main conversation
 66851: 
 66852: `UserPromptSubmit` hooks have a default timeout of 30 seconds for `command`, `http`, and `mcp_tool` types, shorter than the 600-second default for those types on most other events. Because this hook runs before every prompt and blocks model processing until it completes, a stuck hook stalls the session. If your hook needs more time, set the `timeout` field in the hook entry.
```

---

## hooks: hook の制約（/ コマンドやツール呼び出しは起動できない）（27498-27503 行、起点: `Keep these constraints in mind when designing hooks` #1）

```text
 27498: Keep these constraints in mind when designing hooks:
 27499: 
 27500: * Command hooks communicate through stdout, stderr, and exit codes only. They can't trigger `/` commands or tool calls. Text returned via `additionalContext` is injected as a [system reminder](/docs/en/glossary#system-reminder) that Claude reads as plain text. HTTP hooks communicate through the response body instead.
 27501: * Hook timeouts vary by type. Override per hook with the `timeout` field in seconds.
 27502:   * `command`, `http`, `mcp_tool`: 10 minutes. Claude Code lowers this default to 30 seconds for `UserPromptSubmit`, `PreModelSwitch`, and `PostModelSwitch` hooks, and to 10 seconds for `MessageDisplay`.
 27503:   * `prompt`: 30 seconds.
```

---

## hooks: PreCompact（68608-68637 行、起点: `### PreCompact` #1）

```text
 68608: ### PreCompact
 68609: 
 68610: Runs before Claude Code is about to run a compact operation.
 68611: 
 68612: The matcher value indicates whether compaction was triggered manually or automatically:
 68613: 
 68614: | Matcher | When it fires |
 68615: | :- | :- |
 68616: | `manual` | `/compact` |
 68617: | `auto` | Auto-compact when the conversation reaches the [auto-compact window](/docs/en/model-config#set-the-auto-compact-window) |
 68618: 
 68619: Exit with code 2 to block compaction. For a manual `/compact`, the stderr message is shown to the user. You can also block by returning JSON with `"decision": "block"`.
 68620: 
 68621: Blocking automatic compaction has different effects depending on when it fires. If compaction was triggered proactively before the context limit, Claude Code skips it and the conversation continues uncompacted. If compaction was triggered to recover from a context-limit error already returned by the API, the underlying error surfaces and the current request fails.
 68622: 
 68623: Claude Code discards a PreCompact hook's `systemMessage` and `continue` fields.
 68624: 
 68625: #### PreCompact input
 68626: 
 68627: In addition to the [common input fields](#common-input-fields), PreCompact hooks receive `trigger` and `custom_instructions`. For `manual`, `custom_instructions` contains what the user passes into `/compact` and is `null` when they pass nothing. For `auto`, `custom_instructions` is `null`.
 68628: 
 68629: ```json theme={null}
 68630: {
 68631:   "session_id": "abc123",
 68632:   "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
 68633:   "cwd": "/Users/...",
 68634:   "hook_event_name": "PreCompact",
 68635:   "trigger": "manual",
 68636:   "custom_instructions": null
 68637: }
```

---

## skills: Frontmatter reference（paths / disable-model-invocation / user-invocable 等）（44572-44631 行、起点: `### Frontmatter reference` #1）

```text
 44572: ### Frontmatter reference
 44573: 
 44574: Configure a skill with YAML [frontmatter](/docs/en/glossary#frontmatter) between `---` markers at the top of `SKILL.md`, and write the skill's instructions as Markdown after the closing `---`. Field names use lowercase words separated by hyphens, except `when_to_use`. A [command file](#where-skills-live) in `.claude/commands/` accepts the same fields except `name` and `paths`. This example sets four fields:
 44575: 
 44576: ```yaml theme={null}
 44577: ---
 44578: name: my-skill
 44579: description: What this skill does
 44580: disable-model-invocation: true
 44581: allowed-tools: Read Grep
 44582: ---
 44583: 
 44584: Your skill instructions here...
 44585: ```
 44586: 
 44587: All fields are optional. Only `description` is recommended so Claude knows when to use the skill. A field name must match the table exactly, hyphens included: Claude Code ignores a field it doesn't recognize without reporting an error.
 44588: 
 44589: Claude Code reads the frontmatter only when the opening `---` is the file's first line. Otherwise it treats the whole file, `---` markers included, as skill content. If the YAML between the markers doesn't parse, the skill still loads with no fields set; see [Skill not triggering](#skill-not-triggering) to find and fix the error.
 44590: 
 44591: Boolean fields accept `yes`, `no`, `on`, `off`, `1`, and `0` in any letter case, in addition to `true` and `false`. Before v2.1.218, Claude Code recognized only `true` and `false`.
 44592: 
 44593: | Field | Required | Description |
 44594: | :- | :- | :- |
 44595: | `name` | No | Command name shown in the `/` menu. Defaults to the directory name. See [How a skill gets its command name](#how-a-skill-gets-its-command-name) for how the field interacts with the name you type to invoke the skill. |
 44596: | `description` | Recommended | What the skill does and when to use it. Claude uses this to decide when to apply the skill. If omitted, uses the first non-empty line of the markdown content. Put the key use case first: the combined `description` and `when_to_use` text is truncated at 1,536 characters in the skill listing to reduce context usage. |
 44597: | `when_to_use` | No | Additional context for when Claude should invoke the skill, such as trigger phrases or example requests. Appended to `description` in the skill listing and counts toward the 1,536-character cap. |
 44598: | `argument-hint` | No | Hint shown during autocomplete to indicate expected arguments. Example: `[issue-number]` or `[filename] [format]`. |
 44599: | `arguments` | No | Named positional arguments for [`$name` substitution](#available-string-substitutions) in the skill content. Accepts a space-separated string or a YAML list. Names map to argument positions in order. |
 44600: | `disable-model-invocation` | No | Set to `true` to prevent Claude from automatically loading this skill. Use for workflows you want to trigger manually with `/name`. Also prevents the skill from being [preloaded into subagents](/docs/en/sub-agents#preload-skills-into-subagents). As of v2.1.196, also prevents the skill from running when a [scheduled task](/docs/en/scheduled-tasks) fires with the skill as its prompt. Default: `false`. |
 44601: | `user-invocable` | No | Set to `false` when only Claude should invoke the skill: Claude Code hides it from the `/` menu and doesn't run it when you type `/name`. Use for background knowledge users shouldn't invoke directly. Default: `true`. |
 44602: | `allowed-tools` | No | Tools Claude can use without asking permission during the turn that invokes this skill. The grant clears when you send your next message. Accepts a space- or comma-separated string, or a YAML list. See [Pre-approve tools for a skill](#pre-approve-tools-for-a-skill). |
 44603: | `disallowed-tools` | No | Tools removed from Claude's available pool while this skill is active. Use for autonomous skills that should never call certain tools, such as `AskUserQuestion` for a background loop. Accepts a space- or comma-separated string, or a YAML list. The restriction clears when you send your next message. Like deny rules, the field can't remove [`EndConversation`](/docs/en/tools-reference#endconversation-tool-behavior) while any other tool remains. |
 44604: | `model` | No | Model to use when this skill is active. The override applies for the rest of the current turn and isn't saved to settings. The session model resumes when you send your next prompt. Accepts the same values as [`/model`](/docs/en/model-config), or `inherit` to keep the active model. A value excluded by your organization's [`availableModels`](/docs/en/model-config#restrict-model-selection) allowlist isn't used, and the session keeps its current model. In [auto mode](/docs/en/permission-modes#eliminate-prompts-with-auto-mode), and in [plan mode while the classifier reviews commands](/docs/en/permission-modes#analyze-before-you-edit-with-plan-mode), a model that auto mode doesn't support also isn't used, and the session keeps its current model. With `context: fork`, the value sets the [forked subagent's model](#run-skills-in-a-subagent) instead, and an excluded value follows the [same rules as a subagent model override](/docs/en/model-config#restrict-model-selection). |
 44605: | `effort` | No | [Effort level](/docs/en/model-config#adjust-effort-level) when this skill is active. Overrides the session effort level. When you omit it, the level comes from the [effort resolution order](/docs/en/model-config#adjust-effort-level). Options: `low`, `medium`, `high`, `xhigh`, `max`; available levels depend on the model. |
 44606: | `context` | No | Set to `fork` to run in a forked subagent context. See [Run skills in a subagent](#run-skills-in-a-subagent). |
 44607: | `agent` | No | Which subagent type to use when `context: fork` is set. |
 44608: | `background` | No | Only applies with `context: fork`. Set to `false` to wait for the forked subagent's result in the turn that invoked the skill, instead of [running it in the background](#run-skills-in-a-subagent). Default: `true`. Requires Claude Code v2.1.218 or later. |
 44609: | `hooks` | No | Hooks that Claude Code registers when the skill is invoked and keeps running for the rest of the session. See [Hooks in skills and agents](/docs/en/hooks#hooks-in-skills-and-agents) for the configuration format and the `once` option. |
 44610: | `paths` | No | Glob patterns that limit when this skill is activated. Accepts a comma-separated string or a YAML list. When set, Claude loads the skill automatically only when working with files matching the patterns. Uses the same format as [path-specific rules](/docs/en/memory#path-specific-rules). |
 44611: | `shell` | No | Shell to use for `` !`command` `` and ` ```! ` blocks in this skill. Accepts `bash` (default) or `powershell`. Setting `powershell` runs inline shell commands via PowerShell when the [PowerShell tool](/docs/en/tools-reference#powershell-tool) is enabled: it's on by default on Windows without Git Bash, on by default with Git Bash for claude.ai and Console accounts, and needs `CLAUDE_CODE_USE_POWERSHELL_TOOL=1` in Amazon Bedrock, Google Cloud's Agent Platform, and Microsoft Foundry sessions and on macOS, Linux, and WSL. Set it to `0` to turn the tool off. |
 44612: | `metadata` | No | Free-form YAML map for your own key-value data, such as entitlement or catalog fields, read by your own tooling from `SKILL.md`. Claude Code doesn't act on its contents, and drops a value that isn't a map. Don't reuse frontmatter field names such as `paths` as keys. |
 44613: | `license` | No | License covering the skill. Part of the [Agent Skills](https://agentskills.io) spec; see [Using skill frontmatter outside Claude Code](#using-skill-frontmatter-outside-claude-code). Claude Code accepts the field but doesn't act on it. |
 44614: | `compatibility` | No | Environment requirements for the skill, such as intended products or system prerequisites, as defined by the [Agent Skills](https://agentskills.io) spec; see [Using skill frontmatter outside Claude Code](#using-skill-frontmatter-outside-claude-code). Accepts a string of up to 500 characters. Claude Code accepts the field but doesn't act on it. |
 44615: 
 44616: #### Using skill frontmatter outside Claude Code
 44617: 
 44618: Claude Code accepts every field in the table above. Outside Claude Code, you can use only the fields in the [Agent Skills](https://agentskills.io) spec:
 44619: 
 44620: | Distribution path | Frontmatter fields you can use |
 44621: | :- | :- |
 44622: | Claude Code skills at [any level](#where-skills-live), including [plugin](/docs/en/plugins/overview) skills | Every field in the table above |
 44623: | claude.ai skill uploads, the Skills API, and packaging with `package_skill.py` from [anthropics/skills](https://github.com/anthropics/skills) | `name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools` |
 44624: 
 44625: When you enable a personal skill for your claude.ai account, for example to use it in [Cowork and cloud sessions](#skills-in-cowork-and-cloud-sessions) and routines, you upload it to claude.ai, so the same rules apply.
 44626: 
 44627: If you include any field the spec doesn't allow, packaging or upload fails with a hard error instead of ignoring the field:
 44628: 
 44629: ```
 44630: Unexpected key(s) in SKILL.md frontmatter: argument-hint. Allowed properties are: allowed-tools, compatibility, description, license, metadata, name
 44631: ```
```

---

## skills: How a skill gets its command name（Plugin 名前空間と bare 名）（44635-44659 行、起点: `#### How a skill gets its command name` #1）

```text
 44635: #### How a skill gets its command name
 44636: 
 44637: The command you type to invoke a skill comes from where the skill file lives and, for skill directories and plugin skills, from the frontmatter `name` field. In a personal or project skill directory, `name` sets the command that the `/` menu shows and that you type, unless another command already uses that name. The directory name also invokes the skill. In a plugin skill, `name` sets the last segment of the command and the plugin prefix stays in place.
 44638: 
 44639: The table below shows where the command name comes from for each layout:
 44640: 
 44641: | Skill location | Command name source | Example |
 44642: | :- | :- | :- |
 44643: | Skill directory under `~/.claude/skills/` or `.claude/skills/` | Frontmatter `name` or the directory name | `.claude/skills/deploy-staging/SKILL.md` → `/deploy-staging`, or `/deploy` with `name: deploy` |
 44644: | [Nested](#where-skills-live) `.claude/skills/` directory, when the directory name clashes with another skill | Subdirectory path relative to the working directory, then the skill directory name | `apps/web/.claude/skills/deploy/SKILL.md` → `/apps/web:deploy` |
 44645: | File under `.claude/commands/` | File name without extension | `.claude/commands/deploy.md` → `/deploy` |
 44646: | File in a subdirectory of `.claude/commands/` | Subdirectory path relative to `commands/` with each `/` replaced by `:`, then the file name without extension | `.claude/commands/frontend/component.md` → `/frontend:component` |
 44647: | Plugin `skills/` subdirectory | Frontmatter `name` or the directory name, namespaced by plugin | `my-plugin/skills/review/SKILL.md` → `/my-plugin:review`, or `/my-plugin:fancy` with `name: fancy` |
 44648: | Plugin root `SKILL.md` | Frontmatter `name`, with the plugin directory name as a fallback | `my-plugin/SKILL.md` with `name: review` → `/my-plugin:review`. See [a single skill at the plugin root](/docs/en/plugins/components#skills) |
 44649: | Skill [synced from claude.ai](#how-synced-skills-behave) | The skill's name on your claude.ai account, prefixed with `anthropic-skills:` | Account skill `deploy` → `/anthropic-skills:deploy`, or `/deploy` while no other command uses that name |
 44650: 
 44651: In a plugin skill, the frontmatter `name` replaces the directory name in the last segment of the command, so `my-plugin/skills/review/SKILL.md` with `name: fancy` becomes `/my-plugin:fancy`. The bare `/fancy` also invokes the skill unless another command already uses that name. If the `name` you write already starts with the plugin's own prefix, Claude Code doesn't add the prefix again on v2.1.246 or later. For example, `name: my-plugin:fancy` still becomes `/my-plugin:fancy`. From v2.1.216 through v2.1.245, Claude Code doubled the prefix when the `name` already carried it.
 44652: 
 44653: In [non-interactive sessions](/docs/en/headless), the names `help` and `feedback` aren't reserved for their terminal-only built-in commands, so a plugin skill with one of those names keeps its bare command there. Every other terminal-only built-in's name, such as `/login`, stays reserved even though the command can't run in those sessions.
 44654: 
 44655: For a plugin-root `SKILL.md`, there is no skill directory to take the name from, so `name` supplies the whole final segment. Without a `name` field, Claude Code falls back to the plugin's directory name.
 44656: 
 44657: #### Available string substitutions
 44658: 
 44659: Skills support string substitution for dynamic values in the skill content:
```

---

## skills: Control who invokes a skill / Where you write the skill's name（44735-44784 行、起点: `### Control who invokes a skill` #1）

```text
 44735: ### Control who invokes a skill
 44736: 
 44737: By default, both you and Claude can invoke any skill. You can type `/skill-name` to invoke it directly, and Claude can load it automatically when relevant to your conversation. Two frontmatter fields let you restrict this:
 44738: 
 44739: * **`disable-model-invocation: true`**: Claude can't invoke the skill on its own. Use this for workflows with side effects or that you want to control timing, like `/commit`, `/deploy`, or `/send-slack-message`. You don't want Claude deciding to deploy because your code looks ready.
 44740: 
 44741: * **`user-invocable: false`**: Only Claude can invoke the skill. Use this for background knowledge that isn't actionable as a command. A `legacy-system-context` skill explains how an old system works. Claude should know this when relevant, but `/legacy-system-context` isn't a meaningful action for users to take.
 44742: 
 44743: This example creates a deploy skill. If you set `disable-model-invocation: true`, Claude can't run the skill automatically:
 44744: 
 44745: ```yaml theme={null}
 44746: ---
 44747: name: deploy
 44748: description: Deploy the application to production
 44749: disable-model-invocation: true
 44750: ---
 44751: 
 44752: Deploy $ARGUMENTS to production:
 44753: 
 44754: 1. Run the test suite
 44755: 2. Build the application
 44756: 3. Push to the deployment target
 44757: 4. Verify the deployment succeeded
 44758: ```
 44759: 
 44760: If Claude tries anyway, Claude Code blocks the call and instructs it not to reproduce the deploy steps another way, so expect Claude to suggest running `/deploy` yourself.
 44761: 
 44762: Here's how the two fields affect invocation and context loading:
 44763: 
 44764: | Frontmatter | You can invoke | Claude can invoke | When loaded into context |
 44765: | :- | :- | :- | :- |
 44766: | (default) | Yes | Yes | Description always in context, full skill loads when invoked |
 44767: | `disable-model-invocation: true` | Yes | Not on its own | Description not in context, full skill loads when invoked |
 44768: | `user-invocable: false` | No | Yes | Description always in context, full skill loads when invoked |
 44769: 
 44770: <Note>
 44771:   In a regular session, skill descriptions are loaded into context so Claude knows what's available, but full skill content only loads when invoked. [Subagents with preloaded skills](/docs/en/sub-agents#preload-skills-into-subagents) work differently: the full skill content is injected at startup.
 44772: </Note>
 44773: 
 44774: #### Where you write the skill's name
 44775: 
 44776: To run a skill directly, put its name at the start of your message. After plain text, the name gives Claude permission to run the skill but doesn't run it:
 44777: 
 44778: | Where | Example | What happens |
 44779: | :- | :- | :- |
 44780: | At the start of your message | `/deploy staging` | Claude Code runs the skill directly |
 44781: | After plain text, as a separate word with no punctuation attached | `go ahead and /deploy to staging` | Nothing runs directly. The name counts as your permission for that message: Claude can run the skill while it responds, and judges from your wording whether you asked it to |
 44782: 
 44783: To write about the skill without permitting a run, leave off the slash.
 44784: 
```

---

## skills: Skill content lifecycle（圧縮後の再注入上限）（44785-44796 行、起点: `### Skill content lifecycle` #1）

```text
 44785: ### Skill content lifecycle
 44786: 
 44787: When you or Claude invoke a skill, the rendered `SKILL.md` content enters the conversation as a single message and stays there across later turns. This persistence applies to the skill's instructions, not its permissions: an [`allowed-tools`](#pre-approve-tools-for-a-skill) grant clears when you send your next message. Claude Code does not re-read the skill file on later turns, so write guidance that should apply throughout a task as standing instructions rather than one-time steps.
 44788: 
 44789: When Claude re-invokes a skill whose rendered content is identical to the copy already in context, Claude Code adds a short note that the skill is already loaded rather than a second copy of the content. When the rendered content differs, because the arguments changed or a [dynamic context](#inject-dynamic-context) command produced new output, Claude Code appends the full content again.
 44790: 
 44791: [Auto-compaction](/docs/en/how-claude-code-works#when-context-fills-up) carries invoked skills forward within a token budget. When the conversation is summarized to free context, Claude Code re-attaches the most recent invocation of each skill after the summary, keeping the first 5,000 tokens of each. Re-attached skills share a combined budget of 25,000 tokens. Claude Code fills this budget starting from the most recently invoked skill, so older skills can be dropped entirely after compaction if you have invoked many in one session.
 44792: 
 44793: If Claude stops following a skill partway through a session, see [Claude stops following a skill](#claude-stops-following-a-skill).
 44794: 
 44795: ### Pre-approve tools for a skill
 44796: 
```

---

## skills: Resolve skills that share a name（44403-44420 行、起点: `### Resolve skills that share a name` #1）

```text
 44403: ### Resolve skills that share a name
 44404: 
 44405: When two skills share a directory or file name, where each one came from decides which one `/name` runs. For a name set by the frontmatter `name` field, see [How a skill gets its command name](#how-a-skill-gets-its-command-name). The table covers the enterprise, personal, project, nested, plugin, and claude.ai locations, bundled skills, built-in commands, and command files:
 44406: 
 44407: | Same name in | Which one runs |
 44408: | :- | :- |
 44409: | Two of enterprise, personal, and project | Enterprise over personal, and personal over project. With `deploy` in both `~/.claude/skills/` and the project's `.claude/skills/`, `/deploy` runs the personal one |
 44410: | Any of those locations and a [bundled skill](#bundled-skills) | Your skill replaces the bundled command, but not its aliases. A project `code-review` skill replaces `/code-review`, and the bundled alias `/review` never runs your skill |
 44411: | Any of those locations and a [built-in command](/docs/en/commands) | In a local terminal session, your skill replaces the built-in command, but not its aliases. A project `usage` skill replaces `/usage`, and the built-in alias `/cost` still runs the built-in command |
 44412: | A skill and a file in `.claude/commands/` | The skill |
 44413: | A project-root skill and a nested skill | Both load. See [monorepos and subdirectories](#discovery-from-parent-and-nested-directories) |
 44414: | A plugin skill and a skill at any of the locations above | Both load, because plugin skills are namespaced as `/plugin-name:skill-name` |
 44415: | Any of the above and the short name of a skill [synced from your claude.ai account](#how-synced-skills-behave) | The other skill or command. The synced skill is then listed and runs only under its full name. See [When a synced skill name matches another command](#when-a-synced-skill-name-matches-another-command) |
 44416: 
 44417: ### Use skills in Cowork and cloud sessions
 44418: 
 44419: [Cowork](https://claude.com/product/cowork) sessions and [cloud sessions](/docs/en/cloud-environments#what-carries-over-from-your-setup), including [routines](/docs/en/routines), don't read `~/.claude/skills/` on your machine. Both interactive and scheduled Cowork sessions load the skills enabled for your claude.ai account, synced at session start; manage them from **Customize** in the Desktop app sidebar or from the skills settings on claude.ai. Cloud sessions additionally load project skills committed to the cloned repository's `.claude/skills/`.
 44420: 
```

---

## skills: Edit a skill during a session（ライブ変更検知）（44512-44521 行、起点: `### Edit a skill during a session` #1）

```text
 44512: ### Edit a skill during a session
 44513: 
 44514: Claude Code watches skill directories for file changes, except in [bare mode](/docs/en/headless#start-faster-with-bare-mode). When you add, edit, or remove a skill under `~/.claude/skills/`, the project `.claude/skills/`, or a `.claude/skills/` inside an `--add-dir` directory, Claude Code picks up the change within the current session, without a restart.
 44515: 
 44516: If you create a top-level skills directory that didn't exist when the session started, run [`/reload-skills`](/docs/en/commands#all-commands) to pick up the skills you put there. Claude Code isn't watching that directory yet, so run `/reload-skills` again after each later change there.
 44517: 
 44518: Live change detection covers `SKILL.md` text only. For a skill folder that is also a [plugin](/docs/en/plugins/loading#plugins-shared-through-a-repository), changes to `hooks/`, `.mcp.json`, `agents/`, and `output-styles/` need `/reload-plugins` to take effect.
 44519: 
 44520: ### Remove a skill
 44521: 
```

---

## skills: Evaluate and iterate on a skill / Run evals with skill-creator（45114-45143 行、起点: `## Evaluate and iterate on a skill` #1）

```text
 45114: ## Evaluate and iterate on a skill
 45115: 
 45116: Seeing a skill trigger tells you Claude found it, not that it did what you intended. To know a skill is working, measure separately whether Claude invokes it on the prompts it should, and whether the output matches what you expect when it does.
 45117: 
 45118: The check for both is a baseline comparison. Collect a few realistic prompts, run each one in a fresh session with the skill available and again with it turned off, and compare the results. A fresh session matters because leftover context from authoring the skill will mask gaps in the written instructions.
 45119: 
 45120: How you turn the skill off for the second run depends on where it comes from:
 45121: 
 45122: * **Personal or project skill**: set it to `"off"` in [`skillOverrides`](#override-skill-visibility-from-settings).
 45123: * **Skill that a plugin provides**: `skillOverrides` doesn't apply to plugin skills. Use [`claude plugin eval`](/docs/en/plugin-evals#the-no-plugin-baseline) instead, which repeats each run with no plugin loaded.
 45124: 
 45125: Two tools automate the baseline comparison. For a skill that ships in a [plugin](/docs/en/plugins/overview), [`claude plugin eval`](/docs/en/plugin-evals) runs each prompt in an isolated session with and without the plugin, scores it with graders you define or that it writes for you, and exits non-zero below a threshold so you can gate CI on it. For iterating on a single skill inside a Claude Code conversation, the skill-creator plugin below runs a similar loop with its own `evals/evals.json` format. The two formats aren't interchangeable.
 45126: 
 45127: ### Run evals with skill-creator
 45128: 
 45129: The [`skill-creator` plugin](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator) automates the comparison loop inside Claude Code. In the VS Code extension or the desktop app, install it from the official marketplace by following [Install a plugin](/docs/en/plugins/install#install-a-plugin). In a terminal, start Claude Code by running `claude`, then enter this at its prompt:
 45130: 
 45131: ```text theme={null}
 45132: /plugin install skill-creator@claude-plugins-official
 45133: ```
 45134: 
 45135: If the install fails, match the message Claude Code reports:
 45136: 
 45137: * `Marketplace "claude-plugins-official" not found`: add the marketplace with `/plugin marketplace add anthropics/claude-plugins-official`, then retry the install.
 45138: * The plugin is [not found in the marketplace](/docs/en/plugins/install#install-a-plugin): check the plugin name.
 45139: 
 45140: If the install summary reports `Run /reload-plugins to apply.`, Claude Code then runs that reload for you. If the reload warns that your next message would re-read the conversation, run `/reload-plugins --force` to make the plugin's skills available in the current session. Then ask Claude to evaluate an existing skill, for example `evaluate my summarize-changes skill with skill-creator`. The plugin walks you through writing test cases and runs the loop:
 45141: 
 45142: * **Test cases**: stores prompts, input files, and expected behavior in `evals/evals.json` inside the skill directory
 45143: * **Isolated runs**: spawns a [subagent](/docs/en/sub-agents) per test case so each run starts with a clean context, and records token count and duration
```

---

## skills: Skill not triggering / too often / stops following / descriptions cut short（45353-45390 行、起点: `### Skill not triggering` #1）

```text
 45353: ### Skill not triggering
 45354: 
 45355: If Claude doesn't use your skill when expected:
 45356: 
 45357: 1. Check the description includes keywords users would naturally say
 45358: 2. Verify the skill appears in `What skills are available?`
 45359: 3. Try rephrasing your request to match the description more closely
 45360: 4. Invoke it directly with `/skill-name` if the skill is user-invocable
 45361: 
 45362: If the frontmatter YAML is malformed, Claude Code loads the skill body with empty metadata, so `/skill-name` still works but Claude can't match against your `description`. Run with `--debug` to see the parse error.
 45363: 
 45364: If the skill ships in a plugin, you can measure how often it triggers across realistic prompts rather than checking one at a time: write an eval case with a [`tool_used: Skill` grader](/docs/en/plugin-evals#create-your-first-eval-suite) and run it with `claude plugin eval` after each description change.
 45365: 
 45366: To find `SKILL.md` files whose frontmatter doesn't parse, run [`claude plugin validate`](/docs/en/plugins/cli-reference#validate-a-directory) on the skills directory, for example `claude plugin validate .claude/skills` for project skills or `claude plugin validate ~/.claude/skills` for personal skills. Requires Claude Code v2.1.233 or later.
 45367: 
 45368: ### Skill triggers too often
 45369: 
 45370: If Claude uses your skill when you don't want it:
 45371: 
 45372: 1. Make the description more specific
 45373: 2. Add `disable-model-invocation: true` if you only want manual invocation
 45374: 
 45375: ### Claude stops following a skill
 45376: 
 45377: If Claude follows a skill in its first response and stops following it later, start with whichever of these cases matches:
 45378: 
 45379: * **Claude skipped a rule that must hold every time**: move the rule into a [hook](/docs/en/hooks-guide). Claude Code runs a hook every time its event occurs, such as before each file edit, whether or not Claude is following the skill. To keep the rule with the skill, define the hook in the skill's [`hooks` frontmatter](/docs/en/hooks#hooks-in-skills-and-agents). That hook applies from the time the skill is invoked until the session ends.
 45380: * **Claude skipped guidance it should apply with judgment**: word the guidance so it applies to the whole task, for example "Run the tests after every edit" rather than "Run the tests". Claude Code adds the skill's content to the conversation when the skill is invoked and [doesn't re-read the file](#skill-content-lifecycle) on later turns.
 45381: * **The conversation was compacted**: invoke the skill again to restore its full content. After [compaction](/docs/en/how-claude-code-works#when-context-fills-up), Claude Code [can keep only the start of an invoked skill](#skill-content-lifecycle), so put the most important instructions near the top of `SKILL.md`.
 45382: 
 45383: ### Skill descriptions are cut short
 45384: 
 45385: Claude Code loads a listing of skill names and descriptions into context so Claude knows what's available. The listing always contains every skill name, but if you have many skills, Claude Code drops some descriptions to fit the listing's character budget, which removes the keywords Claude needs to match your request. The budget scales at 1% of the model's context window. When the listing overflows, Claude Code drops descriptions starting with the skills you invoke least, so the skills you use most keep their full text.
 45386: 
 45387: Run `/doctor` for an estimate of the listing's context cost and its biggest contributors. To find skills worth turning off, run [`/skill-doctor`](#find-unused-skills). When the listing exceeds its budget, Claude Code also writes a warning to the debug log, visible with [`--debug`](/docs/en/cli-reference#cli-flags).
 45388: 
 45389: The Skills row in `/context` reports the size of the listing after the budget is applied, so it matches what the model receives. Before v2.1.196, the row counted the full text of every description and could show a value several times larger than the configured budget.
 45390: 
```

---

## sub-agents: preload skills と disable-model-invocation（46283-46286 行、起点: `You can't preload skills that set` #1）

```text
 46283: You can't preload skills that set [`disable-model-invocation: true`](/docs/en/skills#control-who-invokes-a-skill), since preloading draws from the same set of skills Claude can invoke. This includes the bundled `/verify` skill, which Claude can't run on its own.
 46284: 
 46285: If a listed skill is missing or disabled, for example by your organization's policy, Claude Code skips it and logs a warning to the debug log.
 46286: 
```

---

## plugins/create: 冒頭〜Create your first plugin（名前空間・disable-model-invocation）（33364-33463 行、起点: `# Create a Claude Code plugin` #1）

```text
 33364: # Create a Claude Code plugin
 33365: Source: https://code.claude.com/docs/en/plugins/create
 33366: 
 33367: Build your first Claude Code plugin from an empty directory, test it without a marketplace, and convert an existing .claude/ setup.
 33368: 
 33369: A plugin is a directory of skills, agents, hooks, and MCP servers, plus a `plugin.json` file, called the manifest, that names the plugin. Claude Code loads the directory as one unit, so you can share it with teammates, install it in several projects, or publish it to a marketplace.
 33370: 
 33371: This page is for people writing their own plugins.
 33372: 
 33373: <Note>
 33374:   These cases are covered on other pages:
 33375: 
 33376:   * **Installing someone else's plugin**: see [Install plugins](/docs/en/plugins/install)
 33377:   * **Not sure you need a plugin**: see [Decide whether you need a plugin](/docs/en/plugins/overview#decide-whether-you-need-a-plugin) on the overview
 33378:   * **Your plugin's users are on claude.ai or in Cowork**: the same folder installs there with a different subset of components. See [Plugin structure and testing](https://claude.com/docs/plugins/build) and the [component support table](https://claude.com/docs/plugins/platform-support#compare-component-support-by-app)
 33379: </Note>
 33380: 
 33381: Start from the section that matches what you already have:
 33382: 
 33383: * **Nothing yet**: follow [Create your first plugin](#create-your-first-plugin), then [Develop without a marketplace](#develop-without-a-marketplace) and [Test and debug](#test-and-debug).
 33384: * **Files under `.claude/` already**: do the first-plugin walkthrough once to learn the layout, then follow [Convert an existing `.claude/` setup](#convert-an-existing-claude-setup).
 33385: 
 33386: ## Decide when to use a plugin
 33387: 
 33388: Skills, agents, hooks, and MCP servers all work standalone in your project or home directory. Keep that standalone setup while it serves one project or only you. Make a plugin when you want to share the setup with teammates, install it in several projects, or publish versioned releases.
 33389: 
 33390: When you move standalone skills, agents, hooks, and MCP config into a plugin, their location and names change:
 33391: 
 33392: * **Where the files go**: under the plugin's own directory, called the plugin root, as `skills/`, `agents/`, `hooks/hooks.json`, and `.mcp.json`.
 33393: * **How they're named**: plugin skills and agents get the plugin name as a prefix, such as `/my-plugin:hello`, so two plugins can each provide a `hello` skill without colliding.
 33394: 
 33395: To move an existing setup into a plugin, see [Convert an existing `.claude/` setup](#convert-an-existing-claude-setup).
 33396: 
 33397: ## Create your first plugin
 33398: 
 33399: In this walkthrough, you create a plugin whose only component is one skill, a greeting, and run it with `--plugin-dir`, which loads a plugin for one session without installing it. A plugin can hold any mix of [components](/docs/en/plugins/components), such as skills, agents, hooks, and MCP servers, and none is required; one skill is the smallest example that shows the layout.
 33400: 
 33401: You need Claude Code [installed and signed in](/docs/en/quickstart#step-1-install-claude-code).
 33402: 
 33403: Open a terminal in the directory where you want to keep the plugin, such as `~/projects`, and run the commands in these steps from it. You can keep a plugin anywhere, because you pass its path to Claude Code when you start a session.
 33404: 
 33405: <Steps>
 33406:   <Step title="Create the plugin directory">
 33407:     Create the plugin directory, with a `.claude-plugin/` folder inside it to hold the manifest:
 33408: 
 33409:     ```bash theme={null}
 33410:     mkdir -p my-first-plugin/.claude-plugin
 33411:     ```
 33412:   </Step>
 33413: 
 33414:   <Step title="Write the manifest">
 33415:     The [manifest](/docs/en/plugins/manifest-reference) is a JSON file named `plugin.json` that tells Claude Code the plugin's name and describes it. Save this one as `my-first-plugin/.claude-plugin/plugin.json`:
 33416: 
 33417:     ```json my-first-plugin/.claude-plugin/plugin.json theme={null}
 33418:     {
 33419:       "name": "my-first-plugin",
 33420:       "description": "A greeting plugin to learn the basics",
 33421:       "version": "1.0.0",
 33422:       "author": {
 33423:         "name": "Your Name"
 33424:       }
 33425:     }
 33426:     ```
 33427: 
 33428:     The four fields do this:
 33429: 
 33430:     * **`name`**: required. It identifies the plugin and becomes the prefix on every skill and agent the plugin provides. Don't put spaces in it.
 33431:     * **`description`**: the text users see for the plugin in `/plugin`.
 33432:     * **`version`**: optional. Setting it keeps users on that version until you change it; [Release a new version](/docs/en/plugins/host-marketplace#release-a-new-version) says when to set or omit it.
 33433:     * **`author`**: who to credit. `name` is required inside it; `email` and `url` are optional.
 33434: 
 33435:     Every other field is on the [manifest reference](/docs/en/plugins/manifest-reference#fields).
 33436: 
 33437:     Only `plugin.json` goes inside `.claude-plugin/`. The skill you add next goes directly under `my-first-plugin/`, next to that folder.
 33438:   </Step>
 33439: 
 33440:   <Step title="Add a skill">
 33441:     This plugin's one component is a skill. Each skill is a directory under `skills/` that contains a `SKILL.md` file. Create the skill's directory:
 33442: 
 33443:     ```bash theme={null}
 33444:     mkdir -p my-first-plugin/skills/hello
 33445:     ```
 33446: 
 33447:     Then create `my-first-plugin/skills/hello/SKILL.md` with this content:
 33448: 
 33449:     ```markdown my-first-plugin/skills/hello/SKILL.md theme={null}
 33450:     ---
 33451:     name: hello
 33452:     description: Greet the user with a friendly message
 33453:     disable-model-invocation: true
 33454:     ---
 33455: 
 33456:     Greet the user warmly and ask how you can help them today.
 33457:     ```
 33458: 
 33459:     The `disable-model-invocation: true` line means Claude doesn't run the skill on its own. Remove that line from a skill you want Claude to run on its own. The skill's command combines the plugin name and the skill's name, so you run this one as `/my-first-plugin:hello`. For the other frontmatter fields, see the [skill frontmatter reference](/docs/en/skills#frontmatter-reference).
 33460:   </Step>
 33461: 
 33462:   <Step title="Validate the plugin">
 33463:     Check the manifest and the skill's frontmatter before you run anything:
```

---

## plugins/create: Plugin layout の注意（.claude-plugin には plugin.json だけ）（33501-33522 行、起点: `### Plugin layout` #1）

```text
 33501: ### Plugin layout
 33502: 
 33503: Each kind of [component](/docs/en/plugins/components), such as skills, agents, hooks, and MCP servers, goes in a fixed directory under the plugin root, which is the directory you pass to `--plugin-dir`. Add only the directories you use. To click through a complete plugin directory and read what each file does, open the [plugin explorer](/docs/en/plugins/components#explore-the-plugin-directory).
 33504: 
 33505: The table lists the directories most plugins start with, and the [full layout](/docs/en/plugins/manifest-reference#standard-layout) lists the rest.
 33506: 
 33507: | Location | Contents |
 33508: | :- | :- |
 33509: | `.claude-plugin/plugin.json` | The manifest. When you load a plugin with `--plugin-dir` and it has no manifest, Claude Code names the plugin after its directory |
 33510: | `skills/` | One `<name>/SKILL.md` directory per skill |
 33511: | `commands/` | Flat Markdown files, the older form of skills. Use `skills/` for new plugins |
 33512: | `agents/` | One Markdown file per subagent |
 33513: | `hooks/hooks.json` | Hook configuration: a top-level `"hooks"` key whose value has the same shape as `hooks` in a settings file |
 33514: | `.mcp.json` | MCP server definitions |
 33515: 
 33516: <Warning>
 33517:   Only `plugin.json` goes inside `.claude-plugin/`. Components saved there don't load.
 33518: 
 33519:   The plugin root is the plugin's own directory, not `~/.claude/` itself. A `.mcp.json` saved at `~/.claude/.mcp.json` doesn't load.
 33520: </Warning>
 33521: 
 33522: ## Develop without a marketplace
```

---

## plugins/create: skills-dir plugin とルート SKILL.md の呼び名（33585-33612 行、起点: `### Make a plugin load in every session` #1）

```text
 33585: ### Make a plugin load in every session
 33586: 
 33587: Your personal skills directory is `~/.claude/skills/`. Claude Code loads any folder there that contains a `.claude-plugin/plugin.json` as a plugin in every session, with no flag and no install step. `claude plugin init` scaffolds one of these plugins for you.
 33588: 
 33589: #### Scaffold the plugin with `claude plugin init`
 33590: 
 33591: `claude plugin init` writes a starter plugin under `~/.claude/skills/`. Scaffold one from your shell:
 33592: 
 33593: ```bash theme={null}
 33594: claude plugin init my-tool
 33595: ```
 33596: 
 33597: The command creates `~/.claude/skills/my-tool/` with a `.claude-plugin/plugin.json` and a root `SKILL.md`. It prints `✔ Created plugin "my-tool" at ~/.claude/skills/my-tool` followed by `It will auto-load next session as my-tool@skills-dir. Run /reload-plugins to load it now.`
 33598: 
 33599: Pass `--with skills` to have `claude plugin init` scaffold a skill under `skills/` for you. The other `--with` values are on the [plugin commands reference](/docs/en/plugins/cli-reference#plugin-init).
 33600: 
 33601: #### Name the plugin's skills
 33602: 
 33603: The root skill at `~/.claude/skills/my-tool/SKILL.md` is also a personal skill, so you invoke it as `/my-tool`, not `/my-tool:my-tool`. Skills you add under `skills/` inside the plugin get the plugin-name prefix, such as `/my-tool:example`.
 33604: 
 33605: #### Stop loading the plugin
 33606: 
 33607: To stop loading a scaffolded plugin, delete its directory, or run `claude plugin disable my-tool@skills-dir` in your shell with the `my-tool@skills-dir` name that `claude plugin init` printed. In the ID `my-tool@skills-dir`, `skills-dir` stands where a marketplace name would, because the plugin loads from your skills directory rather than from a marketplace.
 33608: 
 33609: #### Share the plugin through a repository
 33610: 
 33611: `claude plugin init` writes the plugin to your personal skills directory at `~/.claude/skills/`, so it loads for you in every project. To make a plugin load for everyone in one repository, create the same layout yourself at `<project>/.claude/skills/<name>/`, including its `.claude-plugin/plugin.json`. See [Plugins shared through a repository](/docs/en/plugins/loading#plugins-shared-through-a-repository) for the conditions under which Claude Code loads it.
 33612: 
```

---

## plugins/create: Test and debug（33613-33630 行、起点: `## Test and debug` #1）

```text
 33613: ## Test and debug
 33614: 
 33615: When a change to your plugin doesn't show up, work through these checks in order. Each one tells you what Claude Code did with the plugin:
 33616: 
 33617: 1. In your shell, run `claude plugin validate <path>`. It checks the manifest and the frontmatter of every skill, agent, and command file, and exits `0` on `Validation passed`. Add `--strict` to fail on warnings too. Exit codes and directory handling are on the [plugin commands reference](/docs/en/plugins/cli-reference#plugin-validate).
 33618: 2. In the running session, run `/reload-plugins` to apply edits you made on disk. It prints one `Reloaded:` line with counts. Then confirm a skill loaded by typing its `/plugin-name:skill` command, or by finding the plugin in the `/plugin` **Installed** tab.
 33619: 3. In the same session, run `/plugin`. The **Installed** tab lists your plugin and, in the plugin's details, the components Claude Code found. The **Errors** tab lists what failed to load and why, such as a path in your manifest that doesn't exist.
 33620: 4. Back in your shell, run `claude plugin list`. It prints session-only and skills-directory plugins in their own sections with `Status: ✔ loaded` or the load error. To include the plugin you're developing, pass `--plugin-dir` with its path before `plugin list`.
 33621: 
 33622: To check an MCP server, run `/mcp` in the session to see the server's status. When the server is healthy, `/mcp` lists it as connected. If it isn't, see [MCP servers that don't start](/docs/en/plugins/troubleshooting#invalid-mcp-server-config-for-and-mcp-servers-that-dont-start).
 33623: 
 33624: To check a hook, trigger the event it matches. For example, ask Claude to edit a file to trigger a `PostToolUse` hook. Then read the [debug log](/docs/en/hooks#debug-hooks), which shows which hooks matched, their exit codes, and their output.
 33625: 
 33626: The next sections cover the failures you're most likely to hit while developing, and the [troubleshooting page](/docs/en/plugins/troubleshooting#build-a-plugin) has the full entry for each.
 33627: 
 33628: ### A component path isn't found
 33629: 
 33630: The **Errors** tab of `/plugin` shows `<component> path not found: <path>`, for example `commands path not found`. A component path in your manifest, such as `commands`, `skills`, `agents`, or `hooks`, points at nothing. Fix the path or create the directory, then run `/reload-plugins` in the session. See [`commands path not found`](/docs/en/plugins/troubleshooting#commands-path-not-found).
```

---

## plugins/components: Skills（ルート SKILL.md・CLAUDE.md は読まれない）（32906-32947 行、起点: `### Skills` #1）

```text
 32906: ### Skills
 32907: 
 32908: A [skill](/docs/en/skills) is a `SKILL.md` file that Claude can load when its description matches the task. The user can also run it as a command. Save each skill in its own directory under `skills/`:
 32909: 
 32910: ```text theme={null}
 32911: my-plugin/
 32912: ├── .claude-plugin/
 32913: │   └── plugin.json
 32914: └── skills/
 32915:     └── review/
 32916:         └── SKILL.md
 32917: ```
 32918: 
 32919: Give the `SKILL.md` a `description` so Claude knows when to use it:
 32920: 
 32921: ```markdown skills/review/SKILL.md theme={null}
 32922: ---
 32923: description: Reviews a pull request for style and test coverage. Use when asked to review code.
 32924: ---
 32925: 
 32926: Review the changed files. Report style problems first, then missing tests.
 32927: ```
 32928: 
 32929: After you load the plugin, `/my-plugin:review` runs the skill. The command name and who can invoke it follow these rules:
 32930: 
 32931: * **Command name**: `/<plugin>:<directory>`, so `skills/review/SKILL.md` in `my-plugin` is `/my-plugin:review`. If you set `name` in the frontmatter, it replaces the last segment and the plugin prefix stays. See [how a skill gets its command name](/docs/en/skills#how-a-skill-gets-its-command-name)
 32932: * **Who invokes it**: Claude, the user, or both, controlled by frontmatter. See [Control who invokes a skill](/docs/en/skills#control-who-invokes-a-skill)
 32933: 
 32934: You can also place skills outside the default `skills/` directory:
 32935: 
 32936: * **Additional directories**: list them in the `skills` manifest key. They add to the default `skills/` scan rather than replacing it, unlike `commands` and `agents`
 32937: * **A single skill at the plugin root**: with no `skills/` directory and no `skills` manifest key, a `SKILL.md` at the plugin root loads as one skill. Set `name` in its frontmatter, because otherwise a marketplace install names the skill after its [cache directory](/docs/en/plugins/loading#find-plugins-on-disk) rather than your plugin
 32938: 
 32939: To include instructions in a plugin, write them as a skill. Claude Code doesn't load a `CLAUDE.md` at the plugin root, and `claude plugin validate` warns `CLAUDE.md at the plugin root is not loaded as project context`.
 32940: 
 32941: If a rule must hold every time, such as [blocking edits to protected files](/docs/en/hooks-guide#block-edits-to-protected-files), add it to the plugin as a [hook](#hooks) rather than a skill. To choose between the two, see the Hook vs Skill tab under [Compare similar features](/docs/en/features-overview#compare-similar-features).
 32942: 
 32943: For frontmatter fields and supporting files, see [Skills](/docs/en/skills).
 32944: 
 32945: ### Commands
 32946: 
 32947: A command is a single Markdown file the user runs by name, such as `/my-plugin:about`.
```

---

## plugins/create-marketplace: entry 名と manifest 名 / Validate and test（33891-33962 行、起点: `### Keep the entry name and the manifest name the same` #1）

```text
 33891: ### Keep the entry name and the manifest name the same
 33892: 
 33893: A marketplace plugin has an entry `name` in `marketplace.json` and a `name` in its own `plugin.json`, called the manifest name. Each name appears in different places:
 33894: 
 33895: * **Entry name**: the install id, `<entry-name>@<marketplace>`. It's what people type to install, what `claude plugin list` shows, and the key Claude Code writes under [`enabledPlugins`](/docs/en/settings-reference#enabledplugins) in their settings file.
 33896: * **Manifest name**: the prefix on the plugin's skills, and the name `claude plugin details` takes.
 33897: 
 33898: When the two names differ and someone installs by the manifest name, Claude Code reports `Plugin "<manifest-name>" not found in marketplace "<marketplace>"`. Keep the two names the same. For more on how Claude Code uses the two names, see [Plugin loading reference](/docs/en/plugins/loading#find-where-a-plugin-came-from).
 33899: 
 33900: ## Choose a plugin source
 33901: 
 33902: Each plugin entry in `marketplace.json` has a `source` that tells Claude Code where to fetch that one plugin. Pick the source by where the plugin's files are stored. The table lists the sources most marketplace owners use.
 33903: 
 33904: | Source | Use it when | Minimal `source` value |
 33905: | :- | :- | :- |
 33906: | Relative path | The plugin's files are inside the marketplace directory itself | `"./plugins/my-first-plugin"` |
 33907: | `github` | The plugin is a GitHub repository of its own | `{ "source": "github", "repo": "your-org/my-first-plugin" }` |
 33908: | `git-subdir` | The plugin is a subdirectory of some other repository, such as a monorepo | `{ "source": "git-subdir", "url": "your-org/monorepo", "path": "tools/my-first-plugin" }` |
 33909: 
 33910: In a `git-subdir` source, `url` takes a git URL or an `owner/repo` GitHub shorthand.
 33911: 
 33912: A plugin can also come from one of these source types:
 33913: 
 33914: * `url`: a git repository by URL, on any host
 33915: * `archive`: a zip file downloaded over HTTPS
 33916: * `npm`: an npm package
 33917: * `command`: a directory produced by running a command on the machine where the plugin is installed
 33918: 
 33919: For the fields of every source type, and for pinning a git-based source to a `ref` or `sha`, see [Plugin sources](/docs/en/plugins/marketplace-reference#plugin-sources).
 33920: 
 33921: ## Validate and test
 33922: 
 33923: As you add plugins, run `claude plugin validate ./my-marketplace` in your shell after every edit, and install from the marketplace on your own machine before you share it. Validation and installation catch different problems.
 33924: 
 33925: ### Problems that validation reports
 33926: 
 33927: `claude plugin validate` reads only files inside the marketplace directory. It reports:
 33928: 
 33929: * JSON syntax errors, as `json: Invalid JSON syntax: <reason>`
 33930: * Missing required fields, such as `owner: Invalid input`
 33931: * A marketplace or plugin name that breaks the naming rules in the [marketplace reference](/docs/en/plugins/marketplace-reference#top-level-fields)
 33932: * A relative `source` that contains `..`
 33933: * Unknown fields at the top level or in a plugin entry, as warnings
 33934: * Problems in the `plugin.json` of each relative-path plugin, as `plugins[N] plugin.json → <field>: <message>`
 33935: 
 33936: For every message `validate` can print, see [Validation messages](/docs/en/plugins/marketplace-reference#validation-messages). For its flags and exit codes, see [`plugin validate`](/docs/en/plugins/cli-reference#plugin-validate).
 33937: 
 33938: ### Problems that surface when you add or install
 33939: 
 33940: Problems that `claude plugin validate` doesn't report appear when you add the marketplace or install from it:
 33941: 
 33942: * **When you add the marketplace**: the exact [official marketplace names](/docs/en/plugins/marketplace-reference#reserved-names), such as `claude-plugins-official`, pass validation. When you add a marketplace with one of those names, Claude Code refuses it with a message that starts `The name '<name>' is reserved for official Anthropic marketplaces`.
 33943: * **When you install a plugin**:
 33944:   * Claude Code first fetches a `github`, `git-subdir`, or other remote source when you install the plugin, so a wrong `repo` or `path` appears then.
 33945:   * A relative `source` whose directory doesn't exist also fails at install, with `Source path does not exist: <path>`.
 33946: 
 33947: ### Test an edit to a plugin
 33948: 
 33949: In [the walkthrough](#create-a-marketplace), you added `my-marketplace` from a local directory with a relative-path `source`. With that setup, Claude Code reads the plugin's files directly from `my-marketplace/plugins/`. Your edits take effect at the next session start or when you run `/reload-plugins` in a session, with no change to the plugin's `version`.
 33950: 
 33951: People who install from your hosted marketplace get a copy in the plugin cache instead. For how they receive a new version, see [Keep users up to date](/docs/en/plugins/host-marketplace#keep-users-up-to-date).
 33952: 
 33953: ### Remove the marketplace to start over
 33954: 
 33955: To remove everything and start over, run `claude plugin marketplace remove my-marketplace` in your shell. The command removes the marketplace and uninstalls its plugins.
 33956: 
 33957: ## Host your marketplace
 33958: 
 33959: Once you can install a plugin from the marketplace on your own machine, as in [Create a marketplace](#create-a-marketplace), push the marketplace directory to a git host.
 33960: 
 33961: Your teammates then run `claude plugin marketplace add <owner>/<repo>` in their shell for a GitHub repository, or the same command with the repository URL. They then install a plugin by name as in [the walkthrough](#create-a-marketplace).
 33962: 
```

---

## plugins/publish: Prepare your plugin for release（40064-40103 行、起点: `## Prepare your plugin for release` #1）

```text
 40064: ## Prepare your plugin for release
 40065: 
 40066: The name, the version, validation, and an install from a marketplace decide whether a release works for the people who install it. Check them before the first release and again before each later one.
 40067: 
 40068: <Steps>
 40069:   <Step title="Choose a permanent name">
 40070:     Users install, enable, and configure your plugin by `name@marketplace`, so a renamed plugin is a different plugin to every existing install. Choose a kebab-case name such as `deploy-helper`, because `claude plugin validate` warns on other forms, and treat it as permanent. Set `displayName` in `plugin.json` for the label users see.
 40071:   </Step>
 40072: 
 40073:   <Step title="Decide how you'll version">
 40074:     If you set `version` in `plugin.json` and later push commits without changing it, `claude plugin update` prints `<name> is already at the latest version (1.0.0).` and users keep the old copy. Either increment `version` on every release, or omit it in a git-hosted marketplace so Claude Code uses the commit SHA instead. See [Versions and updates](/docs/en/plugins/loading#versions-and-updates).
 40075:   </Step>
 40076: 
 40077:   <Step title="Validate">
 40078:     In your shell, run `claude plugin validate --strict ./your-plugin`. A clean run prints `✔ Validation passed`.
 40079: 
 40080:     * **In CI**: keep `--strict`, which also fails the run with exit code 1 on warnings such as an unknown manifest field or a missing `version`. Drop `--strict` if you chose to omit `version` in the previous step.
 40081:     * **Paths**: validation reports component paths that don't start with `./`. Inside hook commands and MCP server configs, refer to files as `${CLAUDE_PLUGIN_ROOT}/...`. See [path rules](/docs/en/plugins/manifest-reference#path-rules).
 40082:   </Step>
 40083: 
 40084:   <Step title="Install it from a local marketplace">
 40085:     In your shell, add a local marketplace that lists the plugin with `claude plugin marketplace add ./path-to-marketplace`, install the plugin from it, and start a session to confirm it loads.
 40086: 
 40087:     * For the smallest marketplace that works, see [Create a marketplace](/docs/en/plugins/create-marketplace).
 40088:     * To know whether an install loads your source directory or a cached copy, see [In-place and copied plugins](/docs/en/plugins/loading#in-place-and-copied-plugins).
 40089:   </Step>
 40090: 
 40091:   <Step title="Fill in the metadata users see">
 40092:     Set `description`, `author`, `homepage`, and `repository` in `plugin.json`, and add a `README.md` at the plugin root. `homepage` must parse as a URL. The [manifest reference](/docs/en/plugins/manifest-reference#fields) lists every field.
 40093:   </Step>
 40094: 
 40095:   <Step title="Run your eval suite">
 40096:     If you have an eval suite, run `claude plugin eval` in your shell. It runs the plugin's test cases and scores the results, which catches regressions when you change the plugin. See [Test plugins with evals](/docs/en/plugin-evals).
 40097:   </Step>
 40098: </Steps>
 40099: 
 40100: ## Share a plugin without a marketplace
 40101: 
 40102: If the plugin is in a git repository, people can clone it and load the checkout, or start Claude Code from their shell with `--plugin-url` pointed at a `.zip` you attach to a release. To get your next version they pull or download again. If it isn't in a repository, send them the directory or a `.zip` of it. They load it in one of two ways:
 40103: 
```

---

## plugins/publish: Ship updates, renames, and removals（40196-40217 行、起点: `## Ship updates, renames, and removals` #1）

```text
 40196: ## Ship updates, renames, and removals
 40197: 
 40198: ### Release a new version
 40199: 
 40200: If you publish through your own marketplace and your `plugin.json` sets `version`, increment it and push. Users who run `claude plugin update` or have auto-update on then receive the new version, as described under [Ship updates to users](#ship-updates-to-users). For a directory listing, see [Update a published plugin](https://claude.com/docs/plugins/submit#update-a-published-plugin).
 40201: 
 40202: ### Tag a release
 40203: 
 40204: Tag the release in git when other plugins declare a version range on yours, because those ranges resolve against tags. Otherwise you don't need a tag.
 40205: 
 40206: To tag, run `claude plugin tag` in your shell from the plugin directory. It creates a `{name}--v{version}` tag. Add `--push` to send the tag to `origin`. The [`plugin tag` reference](/docs/en/plugins/cli-reference#plugin-tag) lists its flags.
 40207: 
 40208: ### Rename or remove a plugin
 40209: 
 40210: Never change a published plugin's `name`. After a rename, users who already installed it lose the plugin, because their install is recorded under the old name. A `renames` entry in your marketplace file migrates them instead. Change `displayName` when you want a different label.
 40211: 
 40212: If a rename is unavoidable, use the marketplace file's `renames` map so that existing installs migrate instead of failing with [`Plugin "<name>" not found in marketplace`](/docs/en/plugins/troubleshooting#plugin-not-found-in-marketplace). To remove a plugin from the marketplace, or for the full `renames` details, see [Rename or remove a plugin](/docs/en/plugins/host-marketplace#rename-or-remove-a-plugin) on the hosting page. The [marketplace reference](/docs/en/plugins/marketplace-reference#top-level-fields) has the field.
 40213: 
 40214: ## Declare dependencies
 40215: 
 40216: If your plugin needs another plugin from the same marketplace to be enabled, list it in the `dependencies` array of `plugin.json`. Each entry is a bare name or an object with a semver `version` range. When a user installs your plugin, Claude Code installs and enables the dependency too.
 40217: 
```

---

## plugins/host-marketplace: Release a new version / Hold users on one version（34371-34406 行、起点: `### Release a new version` #1）

```text
 34371: ### Release a new version
 34372: 
 34373: To release a new version to users, change the plugin's `version`. Users get a new copy only when the plugin's computed version differs from the one they have. That version comes from `plugin.json` first, then from the marketplace entry, per [Versions and updates](/docs/en/plugins/loading#versions-and-updates).
 34374: 
 34375: A plugin that users [load in place](/docs/en/plugins/loading#find-plugins-on-disk) from a marketplace they added from a local path isn't controlled by `version`. It loads your current files at every session start, whatever its version string says.
 34376: 
 34377: For every install other than an in-place load or one from a `command` source, either increase `version` on each release or omit it:
 34378: 
 34379: * **Bump `version` on each release**: users stay on their cached copy until the string changes. If you set `"version": "1.0.0"` and push new commits without changing it, users don't receive them.
 34380: * **Omit `version`**: users track your commits instead. Leave `version` out of both `plugin.json` and the marketplace entry.
 34381: 
 34382: Don't set `version` in both `plugin.json` and the marketplace entry. If you do, Claude Code uses the `plugin.json` value without warning, and `claude plugin validate` reports the mismatch as `Entry declares version "<a>" but <path>/plugin.json says "<b>"`.
 34383: 
 34384: ### Hold users on one version
 34385: 
 34386: One marketplace serves one version of each plugin at a time, so you hold users on a version by choosing what each entry points at:
 34387: 
 34388: * **`ref` and `sha` on the plugin entry**: `ref` names a branch or tag and `sha` names a commit for a `github`, `url`, or `git-subdir` source. See [Plugin sources](/docs/en/plugins/marketplace-reference#plugin-sources).
 34389: * **`#<ref>` on the add command**: users who add `your-org/your-marketplace#stable` get that branch or tag of the catalog. For two release lines at once, see [Run release channels](#run-release-channels).
 34390: * **`<plugin>--v<version>` tags**: a dependency's version range resolves against these tags. See [Release a plugin that others depend on](/docs/en/plugins/dependencies#tag-plugin-releases-for-version-resolution).
 34391: 
 34392: [Release a new version](#release-a-new-version) says when a changed entry reaches users.
 34393: 
 34394: ### Change the command of a command source
 34395: 
 34396: If you change the `command` of a [`command` source](/docs/en/plugins/marketplace-reference#command-plugin-source), or switch its `mode`, each user has to accept the new command before Claude Code runs it. Claude Code runs only the exact command a user accepted when they installed or last updated the plugin.
 34397: 
 34398: After a user's copy of your marketplace picks up the change, that user sees the following:
 34399: 
 34400: * **No more background runs**: the [once-per-session run](/docs/en/plugins/loading#when-a-command-source-re-runs) of the command stops for that user, so the tool's new output doesn't reach them.
 34401: * **An entry in the `/plugin` Errors tab**: the entry shows the new command and the `claude plugin update` command to run.
 34402: 
 34403: Tell users to run the `claude plugin update` command that entry shows, in a terminal. Claude Code shows them the new command and asks them to accept it.
 34404: 
 34405: ## Run release channels
 34406: 
```

---

## plugins/loading: Versions and updates（35271-35306 行、起点: `## Versions and updates` #1）

```text
 35271: ## Versions and updates
 35272: 
 35273: If a plugin's author pushed new commits and `claude plugin update` prints `<name> is already at the latest version (<version>).`, the version Claude Code computes for the plugin is unchanged, so the plugin's files on disk don't change.
 35274: 
 35275: Claude Code computes a version for every plugin it installs, and that version is how it detects an update. `claude plugin update` and background auto-update compute the version again and don't replace the cached copy when it matches what `installed_plugins.json` records. An update that you start can still [retry an unfinished dependency install](/docs/en/plugins/troubleshooting#the-packages-it-lists-are-not-installed) in that copy.
 35276: 
 35277: The version also names the plugin's cache directory.
 35278: 
 35279: A manifest that pins `"version"` is one way the computed version stays the same across commits. See [How Claude Code computes the version](#how-claude-code-computes-the-version) for the resolution order.
 35280: 
 35281: A plugin [loaded in place](#in-place-and-copied-plugins) from a marketplace you added from a local path loads its current source files at every session start, whatever its version string says. For a plugin from a [marketplace hosted on claude.ai](/docs/en/plugins/install#add-from-claude-ai), the version claude.ai records for the plugin is its version, and the manifest's `version` isn't read.
 35282: 
 35283: ### How Claude Code computes the version
 35284: 
 35285: For a marketplace you added by source, Claude Code picks the rule by the `source` type of the plugin's marketplace entry. The [marketplace reference](/docs/en/plugins/marketplace-reference#plugin-sources) lists the source types. For every source type in that list except `command`:
 35286: 
 35287: 1. The `version` field in the plugin's manifest comes first
 35288: 2. Then the `version` field in the plugin's marketplace entry
 35289: 3. When neither is set, the version comes from the source type:
 35290: 
 35291: | Source type | Version when no `version` field is set |
 35292: | :- | :- |
 35293: | `github`, `url`, or `git-subdir` | The commit SHA of the source, shortened to 12 characters. A `git-subdir` version also carries a hash of the subdirectory path |
 35294: | `archive` | The SHA-256 digest, shortened to 12 characters: the `sha256` pin in the marketplace entry, or the digest of the downloaded file when there is no pin |
 35295: | Relative path inside a Git-hosted marketplace | The commit SHA of the installed directory |
 35296: | Local directory, when neither the plugin directory nor its marketplace is a git repository | `unknown` |
 35297: | `npm` | `unknown` |
 35298: 
 35299: Claude Code doesn't take the version from a repository that encloses the install path, such as a git-managed `~/.claude`.
 35300: 
 35301: For a `command` source, Claude Code always derives the version from what the command produced: a 12-character hash on its own, or `<manifest version>-<hash>` when the manifest sets one. The marketplace entry's `version` is ignored for command sources. For what the hash covers, see [Copy mode and link mode](/docs/en/plugins/marketplace-reference#copy-mode-and-link-mode).
 35302: 
 35303: Because the manifest comes first, a manifest that pins `"version": "1.0.0"` keeps every user on the cached copy until its author changes the string, however many commits they push. To let users track commits instead, leave `version` out of both the manifest and the entry. [Host a marketplace](/docs/en/plugins/host-marketplace) covers which choice fits which release setup.
 35304: 
 35305: ### When Claude Code refreshes a marketplace before an install
 35306: 
```

---

## plugins/loading: Name conflicts（35361-35382 行、起点: `## Name conflicts` #1）

```text
 35361: ## Name conflicts
 35362: 
 35363: When enabled plugins from different origins share a manifest name, this order decides which one loads, from highest precedence to lowest:
 35364: 
 35365: 1. A plugin whose id appears in managed settings `enabledPlugins`, as `true` or `false`. A `--plugin-dir` copy whose manifest name matches the id's name part isn't loaded, and you see `--plugin-dir copy of "<name>" ignored: plugin is locked by managed settings`
 35366: 2. An enabled `--plugin-dir`, `--plugin-url`, or `CLAUDE_CODE_PLUGIN_DIRS` plugin. It replaces a same-named installed marketplace plugin or skills-directory plugin:
 35367:    * **An installed marketplace plugin**: replaced silently. `claude plugin list` still shows the marketplace row as enabled, because that row reflects your settings. Only the log Claude Code writes under `~/.claude/debug/` when you start with `--debug` records `Plugin "<name>" from --plugin-dir overrides installed version`
 35368:    * **A skills-directory plugin**: replaced with a `/plugin` **Errors** tab row that reads `Not loaded — the name "<name>" is already taken by a session-only plugin (--plugin-dir / --plugin-url), which takes precedence`
 35369: 3. An installed marketplace plugin. A skills-directory plugin of the same name gets the same `Not loaded` row, naming the installed plugin
 35370: 4. A skills-directory plugin. Between two of these, the copy under `~/.claude/skills/` loads and the project's `.claude/skills/` copy is dropped, with a row that says which path shadowed it
 35371: 5. A plugin [synced from claude.ai](#synced-plugins). When an enabled plugin from any other origin matches its name, Claude Code loads that plugin and reports the synced copy as not loaded. To use the claude.ai copy instead, disable your own copy
 35372: 
 35373: Because the order compares manifest names, a `--plugin-dir` plugin named `hello-plugin` replaces `hello@example-marketplace` when that plugin's manifest also says `"name": "hello-plugin"`.
 35374: 
 35375: ### Keep a session-only plugin from loading
 35376: 
 35377: To keep a `--plugin-dir` plugin from shadowing anything, or to turn one off when a parent process passes the flag for you, set its id to `false` in any settings file. For a plugin whose manifest name is `hello-plugin`, the entry is `"enabledPlugins": {"hello-plugin@inline": false}`. A disabled session-only plugin doesn't shadow, so the marketplace or skills-directory copy loads instead.
 35378: 
 35379: ## Next steps
 35380: 
 35381: * [Install and manage plugins](/docs/en/plugins/install): the install, enable, disable, and update steps themselves
 35382: * [Troubleshoot plugins](/docs/en/plugins/troubleshooting): error messages by the stage that produces them
```

---

## plugins/manifest-reference: Fields 表（name / displayName / version 等）（80180-80239 行、起点: `The table lists the top-level keys in `plugin.json`` #1）

```text
 80180: The table lists the top-level keys in `plugin.json`. `name` is the only required key. Where a field name is a link, the linked section has its full rules.
 80181: 
 80182: For component keys such as `commands` and `hooks`, [Component path forms](#component-path-forms) shows each accepted shape with an example, and every path follows the [path rules](#path-rules) for the `./` prefix, extensions, and containment.
 80183: 
 80184: | Field | Type | Description |
 80185: | :- | :- | :- |
 80186: | `$schema` | String | JSON Schema URL for editor autocomplete. Claude Code ignores it at load time |
 80187: | [`name`](#name) | String | Plugin identifier, required. Use kebab-case. Every component is namespaced under it |
 80188: | [`displayName`](#displayname) | String | Name shown in UI in place of `name` |
 80189: | [`version`](#version) | String | Version string. Setting it keeps users on that version until you change it |
 80190: | `description` | String | Short explanation of what the plugin provides |
 80191: | `author` | Object | `name`, which is required, plus optional `email` and `url` |
 80192: | `homepage` | String | Documentation URL. Must parse as a URL, or the plugin fails to load |
 80193: | `repository` | String | Source repository URL. Not validated |
 80194: | `license` | String | SPDX identifier such as `MIT` or `Apache-2.0` |
 80195: | `keywords` | Array of strings | Discovery tags |
 80196: | [`metadata`](#metadata) | Object | Free-form object for your own data. Claude Code doesn't read it |
 80197: | [`icon`](#directory-listing-fields) | String | Icon for the plugin's listing in Anthropic's directory. Claude Code doesn't read it |
 80198: | [`documentationUrl`](#directory-listing-fields) | String | Documentation link for the plugin's listing in Anthropic's directory. Claude Code doesn't read it |
 80199: | [`supportUrl`](#directory-listing-fields) | String | Support link for the plugin's listing in Anthropic's directory. Claude Code doesn't read it |
 80200: | [`privacyPolicyUrl`](#directory-listing-fields) | String | Privacy policy link for the plugin's listing in Anthropic's directory. Claude Code doesn't read it |
 80201: | [`termsOfServiceUrl`](#directory-listing-fields) | String | Terms of service link for the plugin's listing in Anthropic's directory. Claude Code doesn't read it |
 80202: | [`defaultEnabled`](#defaultenabled) | Boolean | Whether the plugin starts enabled when the user hasn't set it. Defaults to `true` |
 80203: | [`dependencies`](#dependencies) | Array of strings or objects | Plugins that must be enabled for this one to work |
 80204: | [`settings`](#settings) | Object | Settings Claude Code applies while the plugin is enabled. Only `agent` and `subagentStatusLine` take effect |
 80205: | [`userConfig`](#user-configuration) | Object | Values Claude Code prompts the user for when the plugin is enabled |
 80206: | `types` | Path | A `.d.ts` file that declares the `$.state` values and `$` nouns of a [mod](/docs/en/plugins/mods/reference#files) |
 80207: | [`channels`](#channels) | Array of objects | Message channels the plugin provides, each bound to one of its MCP servers |
 80208: | `skills` | Path, or array of paths | Directories to scan for skills, each a directory of `<name>/SKILL.md` folders or one folder holding `SKILL.md` directly. `"."` names the plugin root. Adds to the default `skills/` scan |
 80209: | [`commands`](#commands) | Path, array of paths, or object | Flat `.md` command files, directories of them, or an object map of command name to `source` or `content`. Replaces the default `commands/` scan |
 80210: | `agents` | Path, or array of paths | Agent `.md` files. Directories aren't accepted. Replaces the default `agents/` scan |
 80211: | [`hooks`](#hooks) | Path, object, or array of either | `.json` hook files or inline hook config. Loaded together with `hooks/hooks.json` |
 80212: | [`mcpServers`](#mcpservers) | Path, object, or array of either | `.json` MCP config files, `.mcpb` or `.dxt` bundles, or inline server configs keyed by name. Loaded together with `.mcp.json`; a server name declared later replaces an earlier one |
 80213: | [`lspServers`](#lspservers) | Path, object, or array of either | `.json` LSP config files or inline server configs keyed by name. Loaded together with `.lsp.json` |
 80214: | `outputStyles` | Path, or array of paths | Output style files or directories. Replaces the default `output-styles/` scan |
 80215: | `workflows` | Path, or array of paths | [Workflow](/docs/en/workflows#distribute-a-workflow-in-a-plugin) `.js` files or directories. Replaces the default `workflows/` scan |
 80216: | `experimental` | Object | Container for `themes`, `monitors`, and `evals`, whose manifest shape may still change |
 80217: | `experimental.themes` | Path, or array of paths | Theme files or directories. Replaces the default `themes/` scan. A top-level `themes` key still loads, with a `claude plugin validate` warning |
 80218: | [`experimental.monitors`](#monitors) | Path, or inline array | A `.json` file holding the monitors array, or the array itself. Defaults to `monitors/monitors.json`. A top-level `monitors` key still loads, with a `claude plugin validate` warning. Monitors run only in interactive sessions, and not on Amazon Bedrock, Google Cloud's Agent Platform, or Microsoft Foundry |
 80219: | `experimental.evals` | Path, or array of paths | Directory that holds the plugin's [eval cases](/docs/en/plugin-evals#use-a-different-eval-directory) when it isn't the default `evals/`. `claude plugin eval --eval-dir` overrides it |
 80220: 
 80221: In the Type column, a path is a string relative to the plugin root, such as `"./custom/commands"`.
 80222: 
 80223: ### `name`
 80224: 
 80225: The plugin identifier. It must be non-empty, with no spaces, `@`, `:`, path separators, control characters, or bidirectional-formatting characters; use kebab-case.
 80226: 
 80227: Claude Code namespaces every component under it, so an agent `reviewer` in plugin `deploy-tools` appears as `deploy-tools:reviewer`.
 80228: 
 80229: `claude plugin validate` also checks that the name doesn't pass as one of Anthropic's own plugins. The check ignores case and treats any run of separators as one:
 80230: 
 80231: | Name | Result |
 80232: | :- | :- |
 80233: | Starts with `claude-`, `anthropic-`, `anthropics-`, or `cc-plugin-` | Error |
 80234: | Is `claude`, `anthropic`, `anthropics`, `claude-code`, or `claude-mods` | Error |
 80235: | Puts `official` beside `claude` or `anthropic`, such as `official-claude-tools` | Error |
 80236: | Has `claude`, `anthropic`, or `anthropics` as a whole word anywhere else, such as `mcp-for-claude` | Warning |
 80237: 
 80238: The error reads `Plugin name "<name>" is reserved: it passes as one of Anthropic's own`, and the warning reads `Plugin name "<name>" reads as one of Anthropic's own`. `claude plugin init` and `claude plugin tag` refuse a name that draws the error. Claude Code still installs and loads a plugin whose name they refuse.
 80239: 
```

---

## plugins/manifest-reference: version（80246-80251 行、起点: `### `version`` #1）

```text
 80246: ### `version`
 80247: 
 80248: A version string, not checked against semver. Setting it pins the plugin to that version until you change it; see [Versions and updates](/docs/en/plugins/loading#versions-and-updates). A plugin with a [`command` source](/docs/en/plugins/marketplace-reference), a plugin from a [marketplace hosted on claude.ai](/docs/en/plugins/install#add-from-claude-ai), and a plugin [loaded in place](/docs/en/plugins/loading#find-plugins-on-disk) from a marketplace added from a local path aren't pinned by this field.
 80249: 
 80250: ### `metadata`
 80251: 
```

---

## plugins/manifest-reference: Standard layout（rules というコンポーネントは無い）（80669-80690 行、起点: `## Standard layout` #1）

```text
 80669: ## Standard layout
 80670: 
 80671: Each component type has a default location under the plugin root, used when the manifest doesn't point elsewhere.
 80672: 
 80673: | Component | Default location | Contents |
 80674: | :- | :- | :- |
 80675: | Manifest | `.claude-plugin/plugin.json` | Plugin metadata and configuration. Optional |
 80676: | Skills | `skills/` | One `<name>/SKILL.md` per skill. A plugin with `SKILL.md` at its root, no `skills/`, and no `skills` key loads as a single skill |
 80677: | Commands | `commands/` | Flat Markdown command files. Prefer `skills/` for new plugins |
 80678: | Agents | `agents/` | Agent Markdown files. Subfolders are part of the [agent name](/docs/en/plugins/components#agents) |
 80679: | Hooks | `hooks/hooks.json` | Hook configuration |
 80680: | MCP servers | `.mcp.json` | MCP server definitions |
 80681: | LSP servers | `.lsp.json` | LSP server configurations |
 80682: | Output styles | `output-styles/` | Output style Markdown files |
 80683: | Workflows | `workflows/` | Workflow `.js` files |
 80684: | Themes | `themes/` | Theme JSON files |
 80685: | Monitors | `monitors/monitors.json` | The monitors array |
 80686: | Executables | `bin/` | Files here are on the Bash tool's `PATH` while the plugin is enabled, so Claude runs them as bare commands. claude.ai and Cowork don't install a plugin that has this directory, including one you [distribute through claude.ai organization settings](https://claude.com/docs/plugins/org-sync#keep-executables-out-of-the-top-level-bin-directory) |
 80687: | Settings | `settings.json` | `agent` and `subagentStatusLine` defaults applied while the plugin is enabled |
 80688: 
 80689: A plugin that uses every default location, plus a `scripts/` folder that its hooks call, is laid out like this:
 80690: 
```

---

## plugins/marketplace-reference: Plugin entries（80828-80857 行、起点: `## Plugin entries` #1）

```text
 80828: ## Plugin entries
 80829: 
 80830: Each object in the top-level `plugins` array of `marketplace.json` names a plugin and says where to fetch it. `name` and `source` are required.
 80831: 
 80832: Apart from the [directory listing fields](/docs/en/plugins/manifest-reference#directory-listing-fields), an entry also accepts every [`plugin.json` field](/docs/en/plugins/manifest-reference), such as `description`, `version`, `author`, `commands`, and `hooks`. For when those fields apply, see [How an entry combines with plugin.json](#entry-and-plugin-json).
 80833: 
 80834: The table lists the entry's own fields and the manifest fields whose meaning changes in an entry.
 80835: 
 80836: | Field | Type | Description |
 80837: | :- | :- | :- |
 80838: | `name` | string | Plugin identifier: letters, digits, `.`, `_`, and `-`, starting with a letter or digit. `claude plugin validate` fails other names, which Claude Code can't install. Users type it before `@` when they install, even when the plugin's own `plugin.json` sets a different `name` |
 80839: | `source` | string or object | Where to fetch the plugin. See [Plugin sources](#plugin-sources) |
 80840: | `description` | string | Shown in [`/plugin`](/docs/en/plugins/install) listings and details |
 80841: | `version` | string | Version string for the plugin. When `plugin.json` also sets `version`, `plugin.json` takes precedence and `claude plugin validate` warns. See [Plugin loading reference](/docs/en/plugins/loading) |
 80842: | `category` | string | Free-form category for organizing the catalog |
 80843: | `tags` | array of strings | Free-form tags for search |
 80844: | `strict` | boolean | Default `true`. Whether `plugin.json` is the definitive source for the plugin's components. See [Strict mode](#strict-mode) |
 80845: | `relevance` | object | Signals that tell Claude Code when to suggest the plugin. See [Recommend plugins for your org](/docs/en/plugins/relevance) |
 80846: | `dependencies` | array | Plugins that must be enabled for this one to work. Each item is `"name"`, `"name@marketplace"`, or an object. See [Plugin dependencies](/docs/en/plugins/dependencies) |
 80847: | `defaultEnabled` | boolean | Default `true`. Whether the plugin starts enabled when the user hasn't set it in [`enabledPlugins`](/docs/en/settings-reference#enabledplugins). The entry value takes precedence over `plugin.json` |
 80848: | `displayName` | string | Human-readable name shown in the UI. When neither the entry nor the plugin's `plugin.json` sets one, users see the plugin's `name` |
 80849: | `metadata` | object | Free-form object for your own fields. Claude Code doesn't read it. Requires Claude Code v2.1.222 or later |
 80850: | `headers` | object | HTTP headers Claude Code sends when it downloads this entry's [archive](#archive-plugin-source). A header set here replaces a header of the same name from the marketplace source's [`headers`](#fields-by-type). Requires Claude Code v2.1.238 or later |
 80851: | `headersHelper` | string | Command that prints this entry's archive-download headers as one JSON object, for a credential that expires. The entry must also set [`"strict": false`](#strict-mode). Requires Claude Code v2.1.238 or later. See [Authenticate archive downloads](/docs/en/plugins/host-marketplace#authenticate-archive-downloads) |
 80852: 
 80853: ### How an entry combines with plugin.json
 80854: 
 80855: The entry's fields apply differently to a fetched plugin that has its own `.claude-plugin/plugin.json` and to one that doesn't:
 80856: 
 80857: * **No `plugin.json`**: the entry is the manifest regardless of `strict`. Every manifest field that the entry accepts applies, including [`mcpServers`, `lspServers`, `userConfig`, and `channels`](/docs/en/plugins/manifest-reference).
```

---

## plugins/cli-reference: plugin eval（2 番目の出現が cli-reference）（78610-78689 行、起点: `### plugin eval` #2）

```text
 78610: ### plugin eval
 78611: 
 78612: Run a plugin's [eval cases](/docs/en/plugin-evals) and report scored results. Requires Claude Code v2.1.269 or later.
 78613: 
 78614: Each case is a prompt plus graders. Claude Code runs it several times in an isolated session with only the target plugin loaded, and by default also without the plugin so the report shows the difference.
 78615: 
 78616: See [Test plugins with evals](/docs/en/plugin-evals) for the case format, graders, results, and CI usage.
 78617: 
 78618: ```bash theme={null}
 78619: claude plugin eval [target] [options]
 78620: ```
 78621: 
 78622: The optional `target` defaults to the current directory and takes any of these forms:
 78623: 
 78624: * A plugin directory
 78625: * A single `prompt.md` or `case.yaml` file
 78626: * An installed plugin as `name` or `name@marketplace`
 78627: * `name@skills-dir`
 78628: 
 78629: Put the target before `--tag`, `--allow-tools`, and `--json`. Each of these options takes the words that follow it as its value, so a target written after one of them is read as a tag, a tool name, or the JSON output path instead of as the target.
 78630: 
 78631: This table lists the options most runs use. Run `claude plugin eval --help` for the complete set, including `--case`, `--tag`, `--output-dir`, `--report`, `--allow-real-servers`, `--keep-temp`, and `--verbose`.
 78632: 
 78633: | Option | Description | Default |
 78634: | :- | :- | :- |
 78635: | `--runs <n>` | Runs per case in each [arm](/docs/en/plugin-evals#compare-against-a-no-plugin-baseline) | Each case's `runs`, else 3 |
 78636: | `-j, --concurrency <n>` | Agent sessions to run at once, 1 to 8. They share your rate limit | `1` |
 78637: | `--model <model>` | Model for the agent under test | Each case's `model`, else `ANTHROPIC_MODEL` if set, else Claude Code's default |
 78638: | `--judge-model <model>` | Model for `llm` and `baseline` graders | The model for [background tasks](/docs/en/plugin-evals#grade-the-result) |
 78639: | `--ablation <mode>` | `none` or `with-without`. See [Score against the no-plugin baseline](/docs/en/plugin-evals#compare-against-a-no-plugin-baseline) | Decided per case, as that section describes |
 78640: | `--threshold <0..1>` | Exit 1 if any case scores below this | `1.0` |
 78641: | `--max-cost-usd <usd>` | Stop before the next run once spend reaches this, exit 2, and report partial results | No limit |
 78642: | `--allow-tools <tools...>` | Grant tools beyond the read-only set, such as `Bash`, `Write`, `Edit`, or `"mcp__plugin_<plugin>_<server>__*"`. See [Grant tools](/docs/en/plugin-evals#grant-tools) | |
 78643: | `--scaffold` | Run each case's [`scaffold_script`](/docs/en/plugin-evals#add-setup-or-history-with-case-yaml) | Off |
 78644: | `--trust-plugin` | Skip the first-run trust prompt, for CI. See [What a run can access](/docs/en/plugin-evals#security) | Off |
 78645: | `--mocks <mode>` | `record` or `off`. See [Mock MCP servers](/docs/en/plugin-evals#mock-mcp-servers) | `record` |
 78646: | `--eval-dir <dir>` | Directory below the plugin that holds the cases | The manifest's `experimental.evals`, else `evals` |
 78647: | `--json [path]` | Print the [result document](/docs/en/plugin-evals#json-result) to stdout, or write it to a `.json` path | |
 78648: | `--no-publish` | Keep the HTML report local | |
 78649: 
 78650: The exit code reports how the run ended. To act on it in a pipeline, see [Run evals in CI](/docs/en/plugin-evals#run-evals-in-ci).
 78651: 
 78652: | Exit code | Meaning |
 78653: | :- | :- |
 78654: | `0` | Every case meets the threshold |
 78655: | `1` | A failing case, a load error, or an untrusted plugin directory |
 78656: | `2` | A partial run |
 78657: | `130` | Interrupted |
 78658: | `143` | Terminated |
 78659: 
 78660: ### plugin eval init
 78661: 
 78662: Create an eval suite for the plugin in the current directory. Requires Claude Code v2.1.269 or later. See [Create your first eval suite](/docs/en/plugin-evals#create-your-first-eval-suite).
 78663: 
 78664: ```bash theme={null}
 78665: claude plugin eval init [name] [options]
 78666: ```
 78667: 
 78668: Run the command from the plugin's root folder, the directory that holds `.claude-plugin/plugin.json` or the skill's `SKILL.md`. To scaffold the suite in another directory on purpose, pass `--eval-dir`.
 78669: 
 78670: In a terminal, the command opens an interactive Claude Code session for an authoring interview. In the interview, Claude does the following:
 78671: 
 78672: 1. Reads the plugin
 78673: 2. Asks you what it should do well
 78674: 3. Proposes cases and graders
 78675: 4. Writes the case files
 78676: 5. Runs the cases and reviews the grades with you to check that the graders score the way you would
 78677: 
 78678: With `--bare`, or without a terminal, the command writes a blank single-case template instead. When Claude runs the command from inside a Claude Code session, the command prints the interview instructions for that session to follow rather than writing a template.
 78679: 
 78680: The optional `name` is a case name. It's required with `--bare` or without a terminal, because the command writes the blank template for that case. A case name starts with a letter or digit and contains only letters, digits, `.`, `_`, and `-`. On every platform, the command also refuses names that Windows can't store, such as `con` or a name ending in `.`.
 78681: 
 78682: The command accepts these options:
 78683: 
 78684: | Option | Description | Default |
 78685: | :- | :- | :- |
 78686: | `--bare` | Write a blank `prompt.md` and `graders/criteria.md` for `<name>` instead of running the interview | |
 78687: | `-i, --interactive` | Require the interview. Fails without a terminal instead of writing a template | |
 78688: | `--eval-dir <dir>` | Directory below the current directory to write cases into | The manifest's `experimental.evals`, else `evals` |
 78689: 
```

---

## plugins/cli-reference: plugin tag（78690-78733 行、起点: `### plugin tag` #1）

```text
 78690: ### plugin tag
 78691: 
 78692: Create an annotated git tag named `<name>--v<version>` for a plugin release. Before tagging, the command checks that the plugin's `plugin.json` and any marketplace entry that lists it agree on the version.
 78693: 
 78694: For when to tag a release, see [Publish a plugin](/docs/en/plugins/publish).
 78695: 
 78696: ```bash theme={null}
 78697: claude plugin tag [path] [options]
 78698: ```
 78699: 
 78700: The `[path]` is the plugin directory, defaulting to the current directory. The command finds the marketplace entry by walking up from that directory to a `.claude-plugin/marketplace.json` that lists the plugin.
 78701: 
 78702: | Flag | Description |
 78703: | :- | :- |
 78704: | `--push` | Push the tag to `--remote` after creating it |
 78705: | `--dry-run` | Print what would be tagged without creating the tag |
 78706: | `-f, --force` | Skip the dirty-working-tree and tag-already-exists checks |
 78707: | `-m, --message <msg>` | Tag annotation message. `%s` stands for the version. Defaults to `<name> <version>` |
 78708: | `--remote <name>` | Remote to push to with `--push`. Defaults to `origin` |
 78709: 
 78710: Preview the tag for a plugin in a marketplace checkout:
 78711: 
 78712: ```bash theme={null}
 78713: claude plugin tag plugins/formatter --dry-run
 78714: ```
 78715: 
 78716: Claude Code prints the plan:
 78717: 
 78718: * The plugin name
 78719: * The version and which file it came from
 78720: * The matching marketplace entry, when there is one
 78721: * The tag name
 78722: * The `git tag` and `git push` commands it would run
 78723: 
 78724: Without `--dry-run`, Claude Code prints `Created tag formatter--v1.0.0` and either `Pushed to origin` or the push command to run yourself. If the push fails, the tag is still created locally and the command exits with an error.
 78725: 
 78726: The command exits `1` and prints the reason when it can't tag safely. Common reasons are:
 78727: 
 78728: * No `version` in `plugin.json` or the marketplace entry
 78729: * The tag already exists
 78730: * The working tree is dirty
 78731: 
 78732: ### plugin test
 78733: 
```

---

## plugins/cli-reference: plugin validate（78748-78807 行、起点: `### plugin validate` #1）

```text
 78748: ### plugin validate
 78749: 
 78750: Validate a plugin manifest, a marketplace manifest, or the skills, agents, and commands in a directory, and exit with a code a CI job can act on. For the create, test, and edit workflow, see [Create a plugin](/docs/en/plugins/create). For what the validator checks in each manifest, see the [plugin manifest reference](/docs/en/plugins/manifest-reference) and the [marketplace reference](/docs/en/plugins/marketplace-reference).
 78751: 
 78752: ```bash theme={null}
 78753: claude plugin validate <path> [options]
 78754: ```
 78755: 
 78756: | Flag | Description |
 78757: | :- | :- |
 78758: | `--strict` | Treat warnings as errors, so unrecognized fields and missing metadata that the runtime tolerates fail the run |
 78759: | `--json` | Output the validation report as one JSON object with the same exit codes. Requires Claude Code v2.1.259 or later |
 78760: 
 78761: Validate a plugin before committing it:
 78762: 
 78763: ```bash theme={null}
 78764: claude plugin validate ./my-plugin --strict
 78765: ```
 78766: 
 78767: #### Validate a directory
 78768: 
 78769: The `<path>` is a manifest file or a directory. Given a directory, Claude Code picks what to validate by what it finds there:
 78770: 
 78771: * `.claude-plugin/marketplace.json`, when it exists
 78772: * Otherwise `.claude-plugin/plugin.json`
 78773: * Otherwise the component files, chosen by the directory's name. Validating component files without a manifest requires Claude Code v2.1.233 or later:
 78774:   * A directory named `skills`, `agents`, or `commands`: the files inside it
 78775:   * A directory named `.claude`: the `skills`, `agents`, and `commands` directories inside it
 78776:   * Any other directory: those three directories under its `.claude`
 78777: 
 78778: When the directory holds both a `.claude-plugin/marketplace.json` and a `.claude-plugin/plugin.json`, Claude Code validates the marketplace and also the plugin's manifest and component files. This requires Claude Code v2.1.289 or later.
 78779: 
 78780: Claude Code doesn't follow symlinks inside the directory you name. What it does depends on where the link is:
 78781: 
 78782: * **A linked `skills`, `agents`, or `commands` directory under the plugin or `.claude` root**: Claude Code warns that nothing in it was read.
 78783: * **A linked entry inside a `skills`, `agents`, or `commands` directory**: Claude Code skips it and warns, per directory, how many entries it skipped that a session would load.
 78784: * **The `skills`, `agents`, or `commands` directory you name is itself a symlink, or its parent `.claude` directory is**: Claude Code reports an error and checks nothing in it. Name the real directory instead.
 78785: 
 78786: A few files are not read by a validation run:
 78787: 
 78788: * **A `SKILL.md` at the plugin root**: when you run `claude plugin validate` against a plugin directory, Claude Code doesn't check a `SKILL.md` at the plugin root
 78789: * **A `CLAUDE.md` at the plugin root**: in a plugin run, Claude Code also warns about a `CLAUDE.md` at the plugin root
 78790: * **Plugin files in a marketplace run**: from a marketplace directory, Claude Code doesn't open the skill, agent, command, or hook files of plugins the marketplace lists in other directories, or the MCP server files they bundle. To find errors in those files, validate each plugin directory
 78791: 
 78792: #### Output and exit codes
 78793: 
 78794: Claude Code prints the file it validated, any errors and warnings with their paths, and a verdict line. The exit code follows the verdict:
 78795: 
 78796: | Exit code | Verdict line | Meaning |
 78797: | :- | :- | :- |
 78798: | `0` | `Validation passed` or `Validation passed with warnings` | The manifest loads. With `--strict`, no warnings either |
 78799: | `1` | `Validation failed` or `Validation failed (--strict treats warnings as errors)` | An error, or a warning under `--strict` |
 78800: | `2` | `Unexpected error during validation: <reason>` | The validator itself failed, such as on an unreadable path |
 78801: 
 78802: With `--json`, Claude Code writes the report to stdout as one JSON object with these top-level fields:
 78803: 
 78804: * `success`: the same verdict the exit code gives
 78805: * `strict`: whether the run treated warnings as errors
 78806: * `target`: the resolved path Claude Code validated
 78807: * `manifest`: the manifest's own result, or `null` for a run without a manifest
```

---

## plugins/troubleshooting: Skill loads but Claude never invokes the skill（41545-41556 行、起点: `### Skill loads but Claude never invokes the skill` #1）

```text
 41545: ### Skill loads but Claude never invokes the skill
 41546: 
 41547: Your plugin's skill runs when you type its `/<plugin>:<skill>` command, but Claude never invokes it in response to a plain request.
 41548: 
 41549: Check these causes in order:
 41550: 
 41551: * **The skill sets `disable-model-invocation: true`**: the template skill in [Create your first plugin](/docs/en/plugins/create#create-your-first-plugin) sets it. Remove the line from a skill you want Claude to invoke on its own. [Control who invokes a skill](/docs/en/skills#control-who-invokes-a-skill) covers the field
 41552: * **The description doesn't match how people ask**: work through the checks in [Skill not triggering](/docs/en/skills#skill-not-triggering)
 41553: * **The description is truncated**: when many skills are installed, Claude Code shortens descriptions to fit the listing's character budget, which can strip the keywords Claude needs to match a request. See [Skill descriptions are cut short](/docs/en/skills#skill-descriptions-are-cut-short)
 41554: 
 41555: To measure how often the skill triggers across realistic prompts rather than checking one at a time, write an eval case with a [`tool_used: Skill` grader](/docs/en/plugin-evals#create-your-first-eval-suite) and run it with `claude plugin eval` after each description change.
 41556: 
```

---

## plugin-evals: 冒頭〜Requirements〜How an eval run works（31609-31658 行、起点: `# Test plugins with evals` #1）

```text
 31609: # Test plugins with evals
 31610: Source: https://code.claude.com/docs/en/plugin-evals
 31611: 
 31612: Write eval cases for your Claude Code plugin, run them with claude plugin eval, grade the results, compare against a no-plugin baseline, and gate CI on the score.
 31613: 
 31614: The `claude plugin eval` shell command runs your [plugin](/docs/en/plugins/overview) against a suite of test cases and scores the results. Each case is a realistic prompt plus one or more graders. A grader is a pass/fail check on what Claude produced, such as a regex over the reply, whether a particular tool was called, or a rubric that a second model judges the reply against.
 31615: 
 31616: You don't have to write the suite manually. `claude plugin eval init` asks you about your plugin, proposes the cases and graders, tries them, and writes the files. You can also ask Claude to do the same from a session you already have open.
 31617: 
 31618: Use evals to:
 31619: 
 31620: * Measure how reliably your plugin leads Claude to produce the right outcome
 31621: * Catch regressions when you change the plugin or a new model is released
 31622: * See what the plugin contributes compared with no plugin
 31623: 
 31624: This page is for plugin and skill authors who have a working plugin and want to test its behavior, and for teams that gate plugin changes in CI. For iterating on one skill inside a Claude Code conversation, the [skill-creator plugin](/docs/en/skills#run-evals-with-skill-creator) runs a similar comparison with its own `evals/evals.json` format, and neither tool reads the other's case files. To create a plugin, see [Create a plugin](/docs/en/plugins/create); to check a plugin's files for syntax and schema errors rather than its behavior, use [`claude plugin validate`](/docs/en/plugins/cli-reference#plugin-validate).
 31625: 
 31626: <Note>
 31627:   Every eval run and every judge grader is a real model call on your account, counted against your plan's usage or your API bill, so check the [requirements](#requirements) first. Then [create your first eval suite](#create-your-first-eval-suite), or go to [Run evals in CI](#run-evals-in-ci) if you already have one.
 31628: </Note>
 31629: 
 31630: ## Requirements
 31631: 
 31632: To run plugin evals you need:
 31633: 
 31634: * Claude Code v2.1.269 or later. Run `claude --version` to check and `claude update` to upgrade.
 31635: * Git 2.31 or later, if git is installed. Run `git --version` to check. With an older git, `claude plugin eval` [stops before running any case](#git-is-too-old-for-claude-plugin-eval). Without git, it runs normally.
 31636: * A plugin directory with a `plugin.json` or `.claude-plugin/plugin.json` manifest, or a [skills-directory plugin](/docs/en/plugins/loading#plugins-shared-through-a-repository).
 31637: * The same authentication and model provider your normal Claude Code sessions use. Eval runs, judge-scored graders, and `claude plugin eval init` call the model with your credentials, so they count against your plan's usage limits or your API bill. When the command reports a cost, the figure is a [list-price estimate](/docs/en/costs) of those calls. If you run Claude Code on Amazon Bedrock, Google Cloud's Agent Platform, or Microsoft Foundry, run the suite from a shell that exports the same provider variables as your normal sessions, because each run inherits them from that shell as the [`env` field](#prompt-md-fields) describes.
 31638: 
 31639: ## How an eval run works
 31640: 
 31641: An eval suite lives in a directory called `evals/` inside your plugin, laid out as [Write and refine cases](#write-and-refine-cases) shows. Each case is its own subdirectory with a [prompt](#set-run-limits-and-tools-in-prompt-md) and one or more [graders](#grade-the-result). The prompt is something a person using your plugin might type, such as a request one of its skills should handle.
 31642: 
 31643: ### What happens in a run
 31644: 
 31645: For each run of a case, Claude Code starts a fresh, [isolated](#how-runs-are-isolated) [non-interactive session](/docs/en/headless) with only your plugin loaded, sends the prompt, and lets Claude work until it finishes or hits the case's turn or time limit. Each grader then checks the final reply, the transcript, or a file Claude created, and passes or fails.
 31646: 
 31647: ### How a case is scored
 31648: 
 31649: One run of a non-deterministic agent tells you little, so each case runs three times by default. A run's score is the fraction of its graders that passed, weighted if you set weights, and the case's score is the mean across its runs. A case passes when its score meets the [`--threshold`](#command-options), `1.0` by default.
 31650: 
 31651: In model calls, a suite makes roughly cases × runs agent runs with the plugin and the same number again for the [no-plugin baseline](#the-no-plugin-baseline), plus three short judge calls per `llm` or `baseline` grader per run.
 31652: 
 31653: ### The no-plugin baseline
 31654: 
 31655: A high score on its own doesn't tell you the plugin helped, because Claude might do as well without it. To separate the two, a case's runs are repeated with no plugin loaded, and you get two scores, `WITH` and `W/OUT`. Their difference, `Δ`, is what the plugin contributed. If a case scores 1.0 both with and without the plugin, the plugin isn't what made it pass.
 31656: 
 31657: The two sets of runs are called the with-arm and the without-arm; [Score against the no-plugin baseline](#compare-against-a-no-plugin-baseline) covers which cases run the with-arm only and how graders are scored across the two arms.
 31658: 
```

---

## plugin-evals: Seed the workspace or conversation（31867-31890 行、起点: `### Seed the workspace or conversation` #1）

```text
 31867: ### Seed the workspace or conversation
 31868: 
 31869: Each run starts in an empty workspace. When a case needs more than the prompt, add a `case.yaml` beside `prompt.md` with a `context` block:
 31870: 
 31871: * **Fixture files or a git repository**: write a Bash script in the case directory and name it in `context.scaffold_script`. The script runs as you, outside the agent's sandbox, and only when you pass `--scaffold`, so pass that flag only for suites you or your organization wrote.
 31872: * **An earlier conversation to continue**: save the transcript as a `.jsonl` file and name it in `context.history_file`, and the case's prompt becomes the next user turn. When the target is a path, such a case runs [without a baseline arm](#compare-against-a-no-plugin-baseline) by default.
 31873: * **Fixture directories Claude can read during the run**: list them in `context.add_dirs`.
 31874: 
 31875: A `case.yaml` also needs `schema_version: "1.1"` and `name`; the [case.yaml fields](#case-yaml-fields) reference has the full list.
 31876: 
 31877: This `case.yaml` seeds a workspace from a script and lets Claude read fixtures from a `resources/` directory:
 31878: 
 31879: ```yaml theme={null}
 31880: schema_version: "1.1"
 31881: name: changelog-from-diff
 31882: tags: [smoke]
 31883: context:
 31884:   scaffold_script: fixture.sh
 31885:   add_dirs: [resources]
 31886: ```
 31887: 
 31888: A scaffold script starts in the empty workspace with a small fixed environment: your shell's `PATH`, `HOME` set to the run's temporary home directory, `TMPDIR`, and a few constants such as `TERM=dumb`. Nothing else from your shell reaches it, and neither do the case's `EVAL_*` variables. If the script exits non-zero or runs longer than 120 seconds, that run scores 0 with a `scaffold failed` error. Use the script for files and git state only, since project configuration it writes [isn't loaded](#how-runs-are-isolated).
 31889: 
 31890: ### Mock MCP servers
```

---

## plugin-evals: How runs are isolated（32086-32096 行、起点: `### How runs are isolated` #1）

```text
 32086: ### How runs are isolated
 32087: 
 32088: Each run gets a temporary home directory, working directory, and Claude Code configuration, and the agent under test runs there as a `claude -p` child process with only your plugin loaded. Keep these consequences in mind when you write cases:
 32089: 
 32090: * **Nothing personal or project-level loads.** Your user settings, hooks, `CLAUDE.md` files, MCP servers, other installed plugins, memory, and skills are absent. Project-scoped configuration isn't read anywhere either: no `.claude/` directory, `CLAUDE.md`, or `.mcp.json` loads from above the workspace or inside it, even one a `scaffold_script` wrote, and `add_dirs` directories grant read access only. Most of your shell environment is withheld too; only an [allowlist](#prompt-md-fields) and `EVAL_*` variables reach the run. Ship any skills, agents, hooks, or MCP servers a case depends on in the plugin under test, since a [`scaffold_script`](#add-setup-or-history-with-case-yaml) can supply only files and git state.
 32091: * **Managed policy can still restrict a run.** Restrictions in [managed settings](/docs/en/managed-settings) an administrator deployed to the machine apply inside a run, so results on a managed machine can differ from an unmanaged one by that policy.
 32092: * **The Artifact tool is off.** A skill that publishes an [artifact](/docs/en/artifacts) can be graded only on what it produces before that step.
 32093: * **The case definitions are hidden from the agent.** A run can't read the eval directory, so Claude can't see the case's prompt, its graders, or sibling cases.
 32094: * **No network sandbox outside shell commands.** Shell commands you grant run under the sandbox's network rules. A `WebFetch(domain:…)` grant reaches that domain directly, and the plugin's own hooks and any real MCP servers you start can reach any host.
 32095: 
 32096: ## Eval suite reference
```

---

## plugins/measure: Measure what a plugin costs（35405-35434 行、起点: `## Measure what a plugin costs` #1）

```text
 35405: ## Measure what a plugin costs
 35406: 
 35407: To see what a plugin adds to Claude's context, run [`claude plugin details`](/docs/en/plugins/cli-reference#plugin-details) with the plugin's name. You run it in your shell, not at the prompt of a running Claude Code session. The plugin has to be loaded: installed, in a skills directory, or passed with `--plugin-dir` in the same command, as in `claude --plugin-dir ./formatter plugin details formatter`.
 35408: 
 35409: This example reads an installed plugin named `formatter` that has two skills, a command, an agent, a hook, and an MCP server:
 35410: 
 35411: ```bash theme={null}
 35412: claude plugin details formatter
 35413: ```
 35414: 
 35415: ```text theme={null}
 35416: formatter 1.0.0
 35417:   Description: Formats and lints code on save
 35418:   Source: formatter@my-marketplace
 35419: 
 35420: Component inventory
 35421:   Skills (3)  format-all, format-code, lint-fix
 35422:   Agents (1)  style-reviewer
 35423:   Hooks (1)  PostToolUse  (harness-only — no model context cost)
 35424:   MCP servers (1)  formatter-tools  (tool schemas resolved at runtime; not counted)
 35425:   LSP servers (0)
 35426: 
 35427: Projected token cost
 35428:   Always-on:   ~146 tok   added to every session
 35429: 
 35430: Per-component (rounded)
 35431:   component       always-on  on-invoke
 35432:   format-code           ~40        ~30
 35433:   lint-fix              ~50        ~30
 35434:   style-reviewer        ~40        ~40
```

---

## changelog 抜粋（grep 結果）

### path-scoped rules / nested CLAUDE.md / paths: 関連

```text
2.1.293:     * Fixed path-scoped rules and nested CLAUDE.md files not loading when Claude views a file with a single-file cat, head, tail, sed -n or grep command in the Bash tool instead of the Read tool
2.1.288:     * Fixed path-scoped `.claude/rules` and nested CLAUDE.md files not loading when Write or Edit creates or changes a file in their scope (previously only Read loaded them)
2.1.269:     * Fixed `permission_denials` in `--output-format stream-json` results omitting Read, Edit and Write calls blocked by a path-scoped deny rule
2.1.261:     * Fixed Claude in Chrome `file_upload` failing with "paths: expected array, received undefined" in local Cowork sessions run from the Claude Desktop app
2.1.211:     - Fixed nested `.claude/rules/*.md` files loading even when setting sources exclude project settings
2.1.198:     - Fixed `.claude/rules/` conditional rules not loading when the target file is reached via a symlinked path
2.1.176:     - Fixed hook `if` conditions for Read/Edit/Write tool paths: documented patterns like `Edit(src/**)`, `Read(~/.ssh/**)`, and `Read(.env)` now match correctly
2.1.84:   * Rules and skills `paths:` frontmatter now accepts a YAML list of globs
2.1.69:   * Added `InstructionsLoaded` hook event that fires when CLAUDE.md or `.claude/rules/*.md` files are loaded into context
2.1.69:     * Fixed conditional `.claude/rules/*.md` files (with `paths:` frontmatter) and nested CLAUDE.md files not loading in print mode (`claude -p`)
2.0.64:   * Added support for .claude/rules/\`.  See [https://code.claude.com/docs/en/memory](https://code.claude.com/docs/en/memory) for details.
```

### disable-model-invocation と文中 /skill 言及

```text
: disable-model-invocation: true
: Run `/fix-issue 1234` to invoke it. Use `disable-model-invocation: true` for workflows with side effects that you want to trigger manually.
2.1.287:     - Improved `/skill` names typed mid-message: Claude is now told they are skills, including `disable-model-invocation` ones
2.1.222:   * Improved the refusal when Claude tries to invoke a skill with `disable-model-invocation`: Claude is now told to ask you to run the skill instead of replicating its workflow
2.1.110:     - Fixed skills with `disable-model-invocation: true` failing when invoked via `/<skill>` mid-message
```

### compact / clear 関連（2.1.285 以降。上限行はミラーにより調整）

```text
2.1.296:   * Added `autoCompactWindow` to subagent frontmatter and `--agents` definitions, so a subagent can auto-compact earlier than the main conversation's window
2.1.296:   * Updated the bundled dataviz skill: lighter violet for the seventh series in light mode, softer primary text in dark mode, and compact y-axis labels like 1K
2.1.296:     * Fixed a late-loading plugin's SessionStart hook output reaching the new conversation after `/clear` in headless sessions
2.1.295:     * Fixed a stopped scheduled task coming back on resume after a rewind, and a scheduled task being lost on resume after Esc or a rewind following a compaction
2.1.293:     * Fixed Claude sometimes treating its own last actions before a context compaction as done after it, and retracting or redoing finished work
2.1.293:     * Fixed a claude.ai-synced skill's edited description sometimes not reaching the model until a new conversation or `/clear`
2.1.292:     * Fixed saved scheduled tasks created after `/resume`, `/branch` or `/clear` never firing, and saved tasks ignoring later creates and deletes after two writes to the tasks file milliseconds apart
2.1.292:     * Fixed a compaction summary that repeated `/name` letting Claude invoke a skill that is reserved for the user
2.1.290:     * Fixed scheduled tasks (`/loop` with an interval, reminders) silently not coming back on resume once the conversation was compacted; covers compactions made from this version on
2.1.290:     * Fixed conversation compaction sometimes failing with a "null is not an object" error
2.1.290:     * Fixed agent view's `/loop` run count freezing and its countdown disappearing after `/clear`; the count now restarts with the new conversation
2.1.290:     * Fixed automatic compaction giving up with "Prompt is too long" when a Mac went to sleep while it was running
2.1.288:   * Changed `/autocompact` to save the auto-compact window per model, so each model keeps its own setting when you switch
2.1.288:     - Improved auto mode: when a conversation grows too long for the client-side safety classifier to review, it is now compacted instead of prompting for, or failing, every tool call
2.1.288:     * Fixed long conversations failing with "Prompt is too long" instead of auto-compacting when the last reply reported zero token usage
2.1.288:     * Fixed `--resume` sometimes dropping files and other context that a compaction had just restored
2.1.288:     * Fixed Edit and Retry in Cowork cloud sessions refusing a message sent before `/compact` even though its history was still saved
2.1.288:     * Fixed the first request in a fresh environment or after a model switch using the built-in output limit and auto-compact window, not the server's; that request may now wait up to 1.5 seconds
2.1.287:     * Fixed a folder's CLAUDE.md being attached a second time after resuming a session or after a compaction
2.1.287:     * Fixed the commit attribution reminder being delivered inside a tool result after a compaction
2.1.287:     * Fixed cloud sessions sometimes losing the earlier conversation when the session restarted while it was being compacted
2.1.286:     - Improved the model fallback notice and the autocompact-thrashing error to say when a fallback dropped the context window from 1M to 200K tokens
2.1.286:     * Fixed `/compact`, `/clear`, and `/rewind` typed while viewing a background agent's or teammate's transcript silently acting on the main conversation: a dialog now names the target and asks first
2.1.285:   * Changed sessions behind a custom `ANTHROPIC_BASE_URL` to use the 1M context window of models that have one (Opus 4.7+, Sonnet 5+, Fable); run `/autocompact 200k` if your gateway stops at 200K
2.1.285:     * Fixed cloud sessions that restarted after their conversation was compacted refusing the next update to an artifact the session had already read or published
2.1.285:     * Fixed switching models mid-session with a `set_model` request (such as the Agent SDK's `setModel`) leaving the new model on the built-in output-token limit and auto-compact window until restart
2.1.285:     * Fixed compacting or resuming a session failing, opening without its history, or crashing when its saved transcript holds a compaction marker or loop wakeup entry with missing or malformed fields
2.1.285:     * Fixed a brief freeze (up to a second) partway through long sessions outside fullscreen mode, which came back after `/clear` or `/compact`
```

### 各 Update のリリース日（本調査で参照した版）

```text
2658:<Update label="2.1.296" description="October 9, 2026"
2751:<Update label="2.1.295" description="October 8, 2026"
2908:<Update label="2.1.294" description="October 8, 2026"
2913:<Update label="2.1.293" description="October 7, 2026"
3339:<Update label="2.1.288" description="October 2, 2026"
3442:<Update label="2.1.287" description="October 1, 2026"
4992:<Update label="2.1.269" description="September 11, 2026"
7440:<Update label="2.1.198" description="July 1, 2026"
7836:<Update label="2.1.176" description="June 12, 2026"
9507:<Update label="2.1.110" description="April 15, 2026"
```

