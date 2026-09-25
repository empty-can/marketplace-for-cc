#!/usr/bin/env bash
# Claude Code statusLine command — all available elements

input=$(cat)

# python3 が無い、または Windows の Microsoft Store スタブ（起動できない）環境があるため、実際に起動できるものを使う
py=""
for cand in python3 python; do
    if "$cand" -c "" >/dev/null 2>&1; then
        py="$cand"
        break
    fi
done
if [ -z "$py" ]; then
    echo "statusLine: python not found"
    exit 0
fi

"$py" - <<'PYEOF' "$input"
import sys
import json
import datetime
import subprocess

# Windows の Python はパイプへ ANSI コードページ（日本語環境では cp932）で書くため、
# PYTHONIOENCODING 未設定の環境でも日本語パス等が化けないよう UTF-8 に固定する
for _stream in (sys.stdout, sys.stderr):
    try:
        _stream.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

data_str = sys.argv[1] if len(sys.argv) > 1 else "{}"

try:
    data = json.loads(data_str)
except Exception:
    print("statusLine: (parse error)")
    sys.exit(0)

parts = []   # 1行目: 識別 + 実行状況（vim/agent/session/model/style/thinking/effort/Ctx/limits/version）
loc = []     # 2行目: 作業場所（cwd/proj/branch/git-wt/repo/wt/PR）
added = []   # 3行目: added（added）

# ── Vim mode ──────────────────────────────────────────────────────────────────
vim = data.get("vim")
if vim:
    parts.append(f"[{vim.get('mode', 'NORMAL')}]")

# ── Agent ──────────────────────────────────────────────────────────────────────
agent = data.get("agent")
if agent:
    agent_label = agent.get("name") or agent.get("type") or "agent"
    agent_type = agent.get("type")
    if agent_type and agent_type != agent_label:
        agent_label = f"{agent_label}({agent_type})"
    parts.append(f"agent:{agent_label}")

# ── Session ───────────────────────────────────────────────────────────────────
session_name = data.get("session_name") or ""
session_id   = data.get("session_id") or ""
short_id     = session_id[:8] if session_id else ""
if session_name:
    MAX_NAME = 30
    if len(session_name) > MAX_NAME:
        parts.append(f"session:{session_name[:MAX_NAME - 1]}…")
    else:
        id_part = f"({short_id})" if short_id else ""
        parts.append(f"session:{session_name}{id_part}")
elif short_id:
    parts.append(f"session:{short_id}")

# ── Model ─────────────────────────────────────────────────────────────────────
model = data.get("model") or {}
model_display = model.get("display_name") or model.get("id") or ""
if model_display:
    parts.append(f"{model_display}")

# ── Output style ──────────────────────────────────────────────────────────────
output_style = data.get("output_style") or {}
style_name = output_style.get("name") or ""
if style_name and style_name.lower() != "default":
    parts.append(f"style:{style_name}")

# ── Thinking / reasoning ──────────────────────────────────────────────────────
thinking = data.get("thinking") or {}
if thinking.get("enabled"):
    parts.append("thinking:on")

effort = data.get("effort") or {}
effort_level = effort.get("level") or ""
if effort_level:
    parts.append(f"effort:{effort_level}")

# ── Workspace / directory / git repo ─────────────────────────────────────────
workspace = data.get("workspace") or {}
cwd         = workspace.get("current_dir") or data.get("cwd") or ""
project_dir = workspace.get("project_dir") or ""
added_dirs  = workspace.get("added_dirs") or []
git_wt      = workspace.get("git_worktree") or ""

if project_dir:
    loc.append(f"prj: {project_dir}")
if cwd and project_dir != cwd:
    loc.append(f"pwd: {cwd}")

# ── git branch（stdin JSON に一般ケース用フィールドが無いため git 実行で取得）──
# 非 git リポジトリ・detached HEAD 等でブランチが定まらない場合は "-" を表示する
branch = ""
if cwd:
    try:
        result = subprocess.run(
            ["git", "-C", cwd, "branch", "--show-current"],
            # text=True だけだと Windows では cp932 でデコードされ、UTF-8 のパスを含む出力で例外になる
            capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=2,
        )
        if result.returncode == 0:
            branch = result.stdout.strip()
    except Exception:
        branch = ""
loc.append(f"branch:{branch or '-'}")

if git_wt:
    loc.append(f"git-wt:{git_wt}")
if added_dirs:
    added.append(f"added:[{'; '.join(added_dirs)}]")

# ── remote（非 git リポジトリ・origin 未設定はいずれも workspace.repo 不在で "-" になる）──
repo = workspace.get("repo") or {}
repo_owner = repo.get("owner") or ""
repo_name  = repo.get("name") or ""
if repo_owner and repo_name:
    repo_host = repo.get("host") or "github.com"
    loc.append(f"remote https://{repo_host}/{repo_owner}/{repo_name}")
else:
    loc.append("remote -")

# ── Worktree session ──────────────────────────────────────────────────────────
worktree = data.get("worktree") or {}
if worktree:
    wt_name   = worktree.get("name") or ""
    wt_branch = worktree.get("branch") or ""
    wt_label  = wt_name or wt_branch or "worktree"
    if wt_branch and wt_branch != wt_name:
        wt_label = f"{wt_name}({wt_branch})"
    loc.append(f"wt:{wt_label}")

# ── Open PR ───────────────────────────────────────────────────────────────────
pr = data.get("pr") or {}
if pr and pr.get("number") is not None:
    pr_state = pr.get("review_state") or "open"
    loc.append(f"PR#{pr['number']}({pr_state})")

# ── Context window ────────────────────────────────────────────────────────────
def fmt_tokens(n):
    n = int(n)
    if n >= 1_000_000:
        return f"{round(n / 1_000_000, 1):g}m"
    return f"{round(n / 1000, 1):g}k"

ctx = data.get("context_window") or {}
used_pct = ctx.get("used_percentage")
if used_pct is not None:
    used_i = int(round(used_pct))
    ctx_str = f"Ctx:{used_i}%"

    ctx_size  = ctx.get("context_window_size")
    total_in  = ctx.get("total_input_tokens")
    total_out = ctx.get("total_output_tokens")

    if ctx_size:
        ctx_str += f" [{fmt_tokens(ctx_size)}]"
    if total_in is not None or total_out is not None:
        in_str  = fmt_tokens(total_in)  if total_in  is not None else "0"
        out_str = fmt_tokens(total_out) if total_out is not None else "0"
        ctx_str += f" I/O:({in_str}/{out_str})"

    cu = ctx.get("current_usage") or {}
    cache_w = cu.get("cache_creation_input_tokens") or 0
    cache_r = cu.get("cache_read_input_tokens") or 0
    if cache_w or cache_r:
        ctx_str += f" R/W:({fmt_tokens(cache_r)}/{fmt_tokens(cache_w)})"

    parts.append(ctx_str)
else:
    parts.append("Ctx:--")

# ── Rate limits ───────────────────────────────────────────────────────────────
rate_limits = data.get("rate_limits") or {}
rate_parts = []
five_h = rate_limits.get("five_hour") or {}
if five_h and five_h.get("used_percentage") is not None:
    label = f"{int(round(five_h['used_percentage']))}%/5h"
    if five_h.get("resets_at"):
        dt = datetime.datetime.fromtimestamp(five_h["resets_at"])
        label += f"(rst@{dt.strftime('%H:%M')})"
    rate_parts.append(label)
seven_d = rate_limits.get("seven_day") or {}
if seven_d and seven_d.get("used_percentage") is not None:
    rate_parts.append(f"{int(round(seven_d['used_percentage']))}%/7d")
if rate_parts:
    parts.append("limits:" + ",".join(rate_parts))

# ── App version ───────────────────────────────────────────────────────────────
version = data.get("version") or ""
if version:
    parts.append(f"v{version}")

print(" | ".join(parts))   # 1行目
if loc:
    print(" | ".join(loc))  # 2行目（作業場所が空ならスキップ）
if added_dirs:
    print(",".join(added))  # 3行目（addedが空ならスキップ）
PYEOF
