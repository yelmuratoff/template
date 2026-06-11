# Contributing

## Branching

Work happens in short-lived branches off `main`, merged back via pull request.
`main` stays releasable at all times — required checks must be green before
merge.

Branch names are descriptive and prefixed by intent:

```
feat/<slug>        new functionality
fix/<slug>         bug fix
refactor/<slug>    behavior-preserving restructuring
chore/<slug>       tooling, deps, config
docs/<slug>        documentation only
```

Rebase onto `main` before opening the PR.

## Commits

[Conventional Commits](https://www.conventionalcommits.org): `<type>: <subject>`
with `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `style`.

- One logical change per commit — split unrelated work.
- Subject in imperative mood, ≤ 72 characters.
- Body explains *why*; skip it when the subject says enough.

```
feat: add session restore on app start
fix: prevent double refresh on concurrent 401s
refactor: wire AppDatabase into the composition root
```

## Pull requests

- Keep PRs small and focused on one change objective.
- Describe the problem, the approach, and the verification evidence (tests,
  screenshots, logs when relevant).
- CI (`.github/workflows/code-analysis.yml`) runs formatting, analysis, and
  tests on every PR and push to `main` — fix failures at the source, never
  bypass checks.

## Before you push

```bash
dart format .
dart analyze
flutter test
```

These are the same gates CI enforces; running them locally keeps the feedback
loop short.
