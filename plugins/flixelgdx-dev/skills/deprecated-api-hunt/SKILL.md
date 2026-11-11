---
name: deprecated-api-hunt
description: Search the codebase for deprecated or outdated APIs (JDK, Gradle, Android, TeaVM, .NET, Kotlin, and libraries) and fact-check every suspicious finding against official sources before reporting it. Use when asked to find deprecated APIs, modernize code, or audit for outdated calls.
argument-hint: "[path or module] (defaults to the whole repository)"
model: opus
context: fork
agent: general-purpose
---

# Deprecated API hunt

Find uses of deprecated or outdated APIs in `$ARGUMENTS` (or the whole repository when empty), then prove each finding before reporting it.

## 1. Gather candidates

Look in every kind of source the repository has: Java, Kotlin, C#, Gradle scripts (`*.gradle.kts`, `build-logic/`), `gradle/libs.versions.toml`, GitHub workflow files, and `.csproj`/`Directory.*.props`.

Useful signals:
- Compiler output. Run a compile with deprecation warnings when it is cheap, for example `./gradlew compileJava -Pargs=-Xlint:deprecation` or check whether the build already passes `-Xlint:deprecation`; for .NET, `dotnet build` warnings such as `CS0618`; for Kotlin, `w: ... is deprecated` lines. This machine is slow, so run at most one build at a time.
- Usages of anything marked `@Deprecated`, `[Obsolete]`, or `@Deprecated(...)` in the project's own code.
- Known-legacy patterns: `new Integer(...)`-style boxing constructors, `Thread.stop`, `finalize()`, `Runtime.exec(String)`, `URL(String)` constructors, `Locale` constructors, `Gradle` `project.buildDir`, `convention` APIs, `tasks.create` instead of `tasks.register`, `jcenter()`, GitHub Actions pinned to old major versions, and so on.
- Library versions far behind their current release, when an API used from them was removed or replaced since.

## 2. Fact-check each suspicious finding

A finding is only reported as deprecated if an official source confirms it. For each one:
- Find the official documentation: the JDK Javadoc for the project's Java version, Gradle's upgrade guides and DSL reference, Android developer docs, the library's own release notes or Javadoc, or Microsoft Learn for .NET.
- Confirm three things: that it is deprecated (or removed, or discouraged), since which version, and what replaces it.
- If you cannot find an official source, put it under "Unverified" instead of calling it deprecated.

Remember the repository's own rules: in code that runs on Android, some modern JDK replacements are not available (see `AGENTS.md`). Never recommend a replacement that breaks that rule.

## 3. Report

Group the results:

1. **Confirmed deprecated**: `file:line`, the API, deprecated since which version, the recommended replacement, and the source link.
2. **Unverified**: what looked suspicious and why it could not be confirmed.
3. **Checked and fine**: anything that looked old but turned out to be current, with a one-line reason.

Do not change any code unless you were asked to.
