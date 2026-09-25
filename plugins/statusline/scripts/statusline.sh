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
import re
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

parts = []   # 1行目: 識別 + 実行状況（version/vim/agent/session/model/style/thinking/effort/Ctx/limits）
loc = []     # 2行目: 作業場所（cwd/proj/branch/git-wt/repo/wt/PR）
added = []   # 3行目: added（added）

# ── App version ───────────────────────────────────────────────────────────────
version = data.get("version") or ""
if version:
    parts.append(f"v{version}")

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
# "Opus 5.5 (1M context)" → "Opus 5.5 [1M]"
model_display = re.sub(r"\s*\(([^()]+) context\)", r" [\1]", model_display)
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
EFFORT_ABBR = {
    "low": "L",
    "medium": "M",
    "high": "H",
    "xhigh": "xH",
    "max": "Max",
    "ultracode": "Ult",
}
if effort_level:
    parts.append(f"effort:{EFFORT_ABBR.get(str(effort_level).lower(), effort_level)}")

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

# ── remote ────────────────────────────────────────────────────────────────────
# 通常は Claude Code が origin を解析した workspace.repo を使う。
# 自前ホストの GitLab のサブグループ配下等では workspace.repo が渡されないため、
# その場合は git からリモート URL を取得して表示する（取れなければ "-"）
def git_out(*args):
    try:
        r = subprocess.run(
            ["git", "-C", cwd, *args],
            capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=2,
        )
        return r.stdout.strip() if r.returncode == 0 else ""
    except Exception:
        return ""

def remote_url_for_display(url):
    url = url.strip()
    # scp 形式（git@host:group/sub/proj.git）
    web_scheme = "https"
    m = re.match(r"^[^/@:]+@([^/:]+):(?!/)(.+)$", url)
    if m:
        host, path = m.group(1), m.group(2)
    else:
        m = re.match(r"^([a-zA-Z][a-zA-Z0-9+.-]*)://(?:[^/@]*@)?([^/]+)(/.*)?$", url)
        if not m:
            return url
        scheme, host, path = m.group(1).lower(), m.group(2), (m.group(3) or "").lstrip("/")
        # ssh のポートは Web のポートと異なるため捨てる
        if scheme == "http":
            web_scheme = "http"
        elif scheme != "https":
            host = host.split(":")[0]
    # 認証情報（user:token@）は上の正規表現で除去済み
    if path.endswith(".git"):
        path = path[:-4]
    return f"{web_scheme}://{host}/{path}".rstrip("/")

repo = workspace.get("repo") or {}
repo_owner = repo.get("owner") or ""
repo_name  = repo.get("name") or ""
remote_disp = ""
if repo_owner and repo_name:
    repo_host = repo.get("host") or "github.com"
    remote_disp = f"https://{repo_host}/{repo_owner}/{repo_name}"
elif cwd:
    remote_url = git_out("remote", "get-url", "origin")
    if not remote_url:
        remotes = git_out("remote").splitlines()
        if remotes:
            remote_url = git_out("remote", "get-url", remotes[0])
    if remote_url:
        remote_disp = remote_url_for_display(remote_url)
loc.append(f"remote {remote_disp or '-'}")

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

    ctx_size = ctx.get("context_window_size")
    if ctx_size:
        ctx_str += f" [{fmt_tokens(ctx_size)}]"

    parts.append(ctx_str)
else:
    parts.append("Ctx:--")

# ── Rate limits ───────────────────────────────────────────────────────────────
# rate_limits はプラン・認証方式によっては存在しないため、欠落や想定外の値でも落とさない
def fmt_rate(window, suffix, with_reset):
    if not isinstance(window, dict):
        return ""
    try:
        label = f"{int(round(float(window['used_percentage'])))}%/{suffix}"
    except (KeyError, TypeError, ValueError):
        return ""
    if with_reset and window.get("resets_at"):
        try:
            dt = datetime.datetime.fromtimestamp(float(window["resets_at"]))
            label += f"(rst@{dt.strftime('%H:%M')})"
        except (TypeError, ValueError, OverflowError, OSError):
            pass
    return label

rate_limits = data.get("rate_limits")
if not isinstance(rate_limits, dict):
    rate_limits = {}
rate_parts = [
    p for p in (
        fmt_rate(rate_limits.get("five_hour"), "5h", True),
        fmt_rate(rate_limits.get("seven_day"), "7d", False),
    ) if p
]
parts.append("limits:" + ",".join(rate_parts) if rate_parts else "limits: -")


print(" | ".join(parts))   # 1行目
if loc:
    print(" | ".join(loc))  # 2行目（作業場所が空ならスキップ）
if added_dirs:
    print(",".join(added))  # 3行目（addedが空ならスキップ）
PYEOF
