#!/usr/bin/env bash
# Blocks any git commit whose command carries a co-author trailer.
# FlixelGDX commits must never credit a co-author, human or AI.
#
# Claude Code sends the pending tool call as JSON on stdin. Plain grep is used
# instead of jq so the hook works anywhere Git Bash or a POSIX shell exists.

input="$(cat)"

if printf '%s' "$input" | grep -qE 'git[^"]*commit' \
  && printf '%s' "$input" | grep -qiE 'co-authored-by'; then
  echo "Blocked: FlixelGDX commits must not include a Co-Authored-By trailer (or any other co-author tag). Remove it and commit again." >&2
  exit 2
fi

exit 0
