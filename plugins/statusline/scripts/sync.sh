#!/usr/bin/env bash
# SessionStart hook: copy statusline.sh to ${CLAUDE_PLUGIN_DATA}.
#
# The plugin cache path changes on every update, so settings.json points at the
# data directory instead, which survives updates.
#
# Must stay silent and always exit 0: SessionStart stdout is added to Claude's
# context, and a failure here must not disturb the session. On failure the
# previously synced copy keeps working.

src="${CLAUDE_PLUGIN_ROOT:-}/scripts/statusline.sh"
dst_dir="${CLAUDE_PLUGIN_DATA:-}"

if [ -z "${CLAUDE_PLUGIN_ROOT:-}" ] || [ -z "$dst_dir" ] || [ ! -f "$src" ]; then
    exit 0
fi

dst="$dst_dir/statusline.sh"

# Skip the write when nothing changed (cmp missing also falls through to the copy)
if cmp -s "$src" "$dst" 2>/dev/null; then
    exit 0
fi

# Write to a temp file and rename, so a status line refresh running at the same
# moment never reads a half-written script
mkdir -p "$dst_dir" 2>/dev/null \
    && cp "$src" "$dst.tmp.$$" 2>/dev/null \
    && mv -f "$dst.tmp.$$" "$dst" 2>/dev/null
rm -f "$dst.tmp.$$" 2>/dev/null

exit 0
