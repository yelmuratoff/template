---
description: >-
  Run the project's verification gates (format, analyze, test) and triage any failures
---

Run the same gates CI enforces (`.github/workflows/code-analysis.yml`), in order:

1. `fvm dart format .` — then check `git status`; reformatted files mean the change wasn't formatted.
2. `fvm dart analyze` — treat warnings as failures.
3. `fvm flutter test` — run the full suite; if a change is localized, run the mirrored `test/` path first for fast feedback.

If a gate fails, fix the cause at the source rather than suppressing it (no `// ignore:` without justification, no skipping tests). Re-run the failed gate after each fix until all three pass, then summarize: what ran, what failed, what was fixed.

If Drift tables, `env.dart`, or assets changed, run `fvm dart run build_runner build --delete-conflicting-outputs` before the gates. If ARB files changed, confirm `untranslated_messages.txt` is empty.
