---
name: perf-review
description: Review a FlixelGDX pull request or diff against the framework's biggest performance rules - no allocations in loops or per-frame code, no reflection, no java.util collections, indexed loops, Java 25 features, and Android-safe APIs. Use for reviewing Java changes in the framework or a Java extension. Not for Kotlin or C# code.
argument-hint: "[PR number, branch, or path] (defaults to the current branch against master)"
model: opus
context: fork
agent: general-purpose
---

# FlixelGDX performance review

Review the Java changes in `$ARGUMENTS` against FlixelGDX's performance rules.

## 1. Get the diff

- A PR number: `gh pr diff <number>`.
- A branch: `git diff master...<branch>`.
- A path: review those files in full.
- Nothing given: `git diff master...HEAD` plus uncommitted changes.

Only Java files are in scope. If the diff has no Java changes, say so and stop. Read each changed file in full, not just the diff hunks, so you know whether a method runs every frame.

## 2. Load the rules

Read the repository's `AGENTS.md`. It is the source of truth; the checklist below is a focused summary. When they disagree, `AGENTS.md` wins.

## 3. Checklist

**Allocations**
- No `new`, autoboxing, string concatenation, lambdas or method references that capture variables, varargs calls, or iterator creation inside loops or inside anything called from `update(...)`, `draw(...)`, layout, hit-testing, or other per-frame paths. Trace calls: a helper called from `update(...)` is per-frame too.
- Short-lived objects use `FlixelPool`; text building uses `FlixelString`.

**Collections and loops**
- No `java.util` collections (`ArrayList`, `HashMap`, `HashSet`, and the rest), including as fields, parameters, or return types. Use `org.flixelgdx.collections`.
- Loops over FlixelGDX collections use an indexed `for`. An enhanced `for` over a raw Java array is fine, because it compiles to an indexed loop without an iterator.
- No streams in runtime code.

**Platform safety**
- No reflection (`Class.forName`, `getDeclaredMethod`, `Field.set`, and so on).
- No deprecated APIs.
- Code that can run on Android must not use the Java library APIs `AGENTS.md` bans there (for example `getFirst()`, `Math.clamp`, `StringBuilder.repeat`, `java.lang.foreign`, virtual threads).

**Modern Java**
- Prefer Java 25 features where they make code clearer: records, pattern matching `switch`, `instanceof` patterns, unnamed variables `_`, text blocks. Flag legacy patterns that a modern form would replace cleanly, but never at the cost of an allocation in a hot path.

**Layout**
- Field order follows the size tiers in `AGENTS.md`, since that affects object padding.

## 4. Report

For each finding give `file:line`, the rule it breaks, why it matters at runtime (for example "allocates a lambda every frame, 60 times a second"), and a concrete fix. Order findings from most to least costly. Mark any finding you are not sure about as "Possible" and say what would confirm it.

End with a one-line verdict. Do not edit files unless you were asked to fix the findings.
