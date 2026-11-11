# claude-configs

The single source of truth for the Claude Code skills, agents, and hooks used across the FlixelGDX repositories.
Instead of copying a skill into every repository, it lives here once and each repository loads it as a plugin.

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
    "flixelgdx@flixelgdx": true
  }
}
```

When someone opens the repository in Claude Code and trusts the folder, Claude Code asks them to install the
plugin. After that, updates pushed here reach every repository.

To install it by hand instead, run this inside Claude Code:

```
/plugin install flixelgdx --marketplace flixelgdx/claude-configs
```

## Layout

```
.claude-plugin/marketplace.json        the marketplace, listing every plugin
plugins/flixelgdx/.claude-plugin/      the shared plugin's manifest
plugins/flixelgdx/skills/<name>/       one folder per skill
```

## Adding a skill

1. Create `plugins/flixelgdx/skills/<skill-name>/SKILL.md`.
2. Keep it project-neutral, since every repository loads it.
3. Push to `master`. Skills are invoked as `/flixelgdx:<skill-name>`.
