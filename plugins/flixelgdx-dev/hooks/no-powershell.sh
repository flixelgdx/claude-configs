#!/usr/bin/env bash
# Blocks PowerShell so every command runs through Git Bash instead.
#
# Two cases are caught:
# 1. Any call to Claude Code's PowerShell tool.
# 2. A Bash command that launches PowerShell (powershell, powershell.exe, or pwsh)
#    as a command, including by full path. Merely mentioning the word, such as
#    grep -r powershell ., is allowed.
#
# Claude Code sends the pending tool call as JSON on stdin. Plain grep is used
# instead of jq so the hook works anywhere Git Bash or a POSIX shell exists.

input="$(cat)"

if printf '%s' "$input" | grep -qE '"tool_name" *: *"PowerShell"'; then
  echo "Blocked: PowerShell is not allowed in FlixelGDX repositories. Run the command with the Bash tool (Git Bash on Windows) instead." >&2
  exit 2
fi

# A PowerShell launch at the start of the command, after a separator, or at the end of a path.
launch='("command" *: *"|[;&|(`] *|[\\/])(powershell|pwsh)(\.exe)?([ "\\]|$)'
if printf '%s' "$input" | grep -qiE "$launch"; then
  echo "Blocked: launching PowerShell from Bash is not allowed in FlixelGDX repositories. Write the command for Git Bash instead." >&2
  exit 2
fi

exit 0
