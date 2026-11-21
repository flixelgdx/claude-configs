# claude-configs

The single source of truth for the Claude Code skills, agents, hooks, and MCP servers used across the FlixelGDX
repositories. Instead of copying them into every repository, they live here once and each repository loads them
through the `flixelgdx-dev` plugin.

## How a repository uses it

Each repository commits a `.claude/settings.json` that points at this marketplace and turns the plugin on:

```json
{
  "extraKnownMarketplaces": {
    "flixelgdx": {
      "source": {
        "source": "github",
        "repo": "flixelgdx/claude-configs"
      }
    }
  },
  "enabledPlugins": {
    "flixelgdx-dev@flixelgdx": true
  },
  "attribution": {
    "commit": "",
    "pr": ""
  },
  "env": {
    "CLAUDE_CODE_USE_POWERSHELL_TOOL": "0"
  }
}
```

`attribution` stops Claude Code from adding its own co-author trailer, and `CLAUDE_CODE_USE_POWERSHELL_TOOL` turns off
the PowerShell tool on Windows so Claude uses Git Bash. Windows contributors need
[Git for Windows](https://gitforwindows.org/) installed.

When someone trusts the repository folder for the first time, Claude Code asks them to install the plugin. If the
folder was already trusted, the prompt does not appear, so install it once by hand inside Claude Code:

```
/plugin install flixelgdx-dev --marketplace flixelgdx/claude-configs
```

After that, updates pushed here reach every repository.

The debugger MCP server shows as failed in sessions where the debugger is not running. That is expected and
harmless.

## Adding something

- Only add things most repositories need. A skill or agent that only one repository uses belongs in that
  repository's own `.claude/` folder.
- Keep it project-neutral where you can, since every repository loads it.
- Run `claude plugin validate .` before pushing.
