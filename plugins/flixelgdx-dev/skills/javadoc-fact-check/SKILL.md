---
name: javadoc-fact-check
description: Check that Javadoc and other doc comments say what the code actually does - parameters, return values, exceptions, nullability, thread and frame behavior, links, and usage examples. Use when asked to verify, audit, or fact-check documentation, or after a change that may have left docs stale.
argument-hint: "[path, class, or PR number] (defaults to files changed on the current branch)"
model: opus
context: fork
agent: general-purpose
---

# Javadoc fact-check

Verify that the doc comments in `$ARGUMENTS` match the code. When no argument is given, check the files changed in `git diff master...HEAD`.

Doc comments come in two styles, and both are in scope: classic `/** ... */` comments and Markdown `///` comments. In Kotlin repositories the same check applies to KDoc; in C# repositories, to XML doc comments.

## For each documented class, method, and field

Read the comment, then read the code it describes, including any methods it calls when the comment makes claims about them.

Check that:
1. **The summary is true.** The first sentence describes what the code does now, not what it used to do.
2. **Parameters match.** Every parameter has a tag, the names are right, and the description matches how the code uses it (units, ranges, whether it may be `null`, whether it is copied or kept).
3. **The return value matches,** including special cases such as returning `null`, an empty value, or the same instance.
4. **Exceptions match.** Each documented exception can really be thrown, and exceptions the code can throw on purpose are documented.
5. **Nullability is consistent.** `@Nullable`/`@NotNull` annotations agree with both the comment and the code.
6. **Behavior claims hold.** Claims like "does not allocate", "safe to call every frame", "thread-safe", "returns a copy", or "default is 1.0" are true. Check the default values in the code.
7. **Links resolve.** Every `{@link}` and `@see` points at something that exists, with the right signature.
8. **Examples work.** Usage examples use real method names and signatures and would compile.
9. **Rules from `AGENTS.md`** are followed: one summary sentence first, ASCII only, American English, backend-neutral wording, and imported short names in links.

## Report

List each problem as `file:line`, what the comment claims, what the code actually does, and a corrected sentence. Put the most misleading problems first, since a wrong claim is worse than a missing one. Do not edit files unless you were asked to fix them.
