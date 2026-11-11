---
name: bump-framework
description: Update a FlixelGDX extension to a newer FlixelGDX framework version, build it, and fix or report what the new version broke. Use in an extension repository (flixelgdx-ui, flixelgdx-video, flixelgdx-ktx, and so on) after a framework release.
argument-hint: "[version] (defaults to the latest framework release)"
---

# Bump the FlixelGDX framework version

Move this extension onto FlixelGDX `$ARGUMENTS` (or the newest release when empty).

## Steps

1. **Find the target version.** If none was given, run `gh release list --repo flixelgdx/flixelgdx --limit 5` and pick the newest non-prerelease. Ask before moving to a prerelease.
2. **Find where the version lives.** Search `gradle/libs.versions.toml`, `gradle.properties`, `build.gradle.kts`, `settings.gradle.kts`, and `build-logic/` for the current FlixelGDX version string. Change every place that pins it, and nothing else.
3. **Read what changed.** Read the release notes between the old and new versions (`gh release view <tag> --repo flixelgdx/flixelgdx`). Note anything marked as removed, renamed, or changed.
4. **Build.** Run the repository's finishing checks from its `AGENTS.md`, one build at a time because this machine is slow. Start with the compile step.
5. **Fix what broke.** For each error, find the new API in the framework source (at `../flixelgdx` when it exists) and update the extension to it. Keep each fix as small as possible and follow the extension's `AGENTS.md`. Do not work around a framework change with reflection or by copying framework code.
6. **Check docs.** Update the extension's README or guides if they mention the old version or an API that changed.

## Report

Give the old and new versions, every file changed, each breakage with how it was fixed, and anything that needs a framework change or a decision instead of a fix. Do not commit or open a pull request unless you were asked to.
