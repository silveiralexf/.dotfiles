# GitHub Actions

- **pre-commit** (`.github/workflows/pre-commit.yaml`): runs on **pull requests** and on **push to `main` or `master`**. Runs pre-commit hooks and Lua tests.
- **changelog** (`.github/workflows/changelog.yaml`): runs on **push to `main` or `master`**, and can be triggered manually via **Actions → changelog → Run workflow**.

If the changelog workflow does not run when you push to `master`, check:

1. **Default branch**: GitHub only uses workflow files from the **default branch**. If your repo default is `main`, push or merge these workflows to `main` so they are active.
2. **Settings → Actions**: Ensure "Actions permissions" allow workflows to run.
