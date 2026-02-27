# GitHub Actions

- **pre-commit** (`.github/workflows/pre-commit.yaml`): runs on **pull requests** and on **push to `main` or `master`**. Runs pre-commit hooks and Lua tests.
- **release** (`.github/workflows/release.yaml`): runs on **tag push `v*`** (e.g. `v1.0.0`). Creates a GitHub Release with release notes (from git-cliff) and updates `CHANGELOG.md` on the default branch.

## Releases and semver

Releases are created by pushing a **tag**:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Use **semver** (`vMAJOR.MINOR.PATCH`). The next version is computed from conventional commits since the last `v*` tag:

- **Major**: commit subject contains `!` (e.g. `feat!:`) or body contains `BREAKING CHANGE`.
- **Minor**: at least one `feat` commit.
- **Patch**: at least one `fix`, `docs`, `chore`, `ci`, etc., or any other commit (defaults to patch when there are commits).

To see the suggested next version before tagging, run from the repo root:

```bash
task version:next
```

Then create and push the tag (e.g. `v0.0.1`):

```bash
V=$(scripts/calc-next-version.sh)
git tag "$V"
git push origin "$V"
```

The release workflow runs `scripts/calc-next-version.sh` (needs only **git** and **bash**; no jq) to validate that the pushed tag matches the version calculated from conventional commits. It then:

1. Generates release notes (commits since the previous tag) with git-cliff.
2. Creates a GitHub Release with that body.
3. Regenerates the full `CHANGELOG.md` and commits it to the default branch.

All release steps use **devbox** in CI so the same tooling (git-cliff, task, etc.) is available; the version script itself does not require jq or any devbox packages.

If the release workflow does not run when you push a tag, ensure workflow files are on the default branch and Actions are enabled (Settings → Actions).
