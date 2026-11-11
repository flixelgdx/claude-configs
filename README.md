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

## What the plugin contains

| Kind | Name | What it does |
|---|---|---|
| Skill | `/flixelgdx-dev:release-notes` | Summarizes the pull requests in a tag into release notes. |
| Skill | `/flixelgdx-dev:perf-review` | Reviews Java changes against the framework's performance rules (runs on Opus). |
| Skill | `/flixelgdx-dev:javadoc-fact-check` | Checks that doc comments match what the code does (runs on Opus). |
| Skill | `/flixelgdx-dev:deprecated-api-hunt` | Finds deprecated APIs and confirms each one against official docs (runs on Opus). |
| Skill | `/flixelgdx-dev:bump-framework` | Moves an extension onto a newer framework version and fixes what broke. |
| Agent | `flixelgdx-core` | Implements changes that touch core APIs, looking up the current source first (Sonnet). |
| Agent | `docs-sync` | Finds documentation left stale by a public API change (Sonnet). |
| Hook | `no-coauthor` | Blocks any `git commit` that carries a `Co-Authored-By` trailer. |
| Hook | `no-powershell` | Blocks Claude Code's PowerShell tool and any Bash command that launches PowerShell, so commands run through Git Bash. |
| MCP | `flixelgdx-debugger` | Connects to the remote debugger at `127.0.0.1:6511` while it is running. |

The debugger MCP server shows as failed in sessions where the debugger is not running. That is expected and
harmless.

## Layout

```
.claude-plugin/marketplace.json            the marketplace, listing every plugin
plugins/flixelgdx-dev/.claude-plugin/      the plugin's manifest
plugins/flixelgdx-dev/skills/<name>/       one folder per skill
plugins/flixelgdx-dev/agents/              one file per agent
plugins/flixelgdx-dev/hooks/               hooks.json and the scripts it runs
plugins/flixelgdx-dev/.mcp.json            MCP servers
```

## Adding something

- Only add things most repositories need. A skill or agent that only one repository uses belongs in that
  repository's own `.claude/` folder.
- Keep it project-neutral where you can, since every repository loads it.
- Run `claude plugin validate .` before pushing.
