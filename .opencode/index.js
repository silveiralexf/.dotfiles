// WARNING: GENERATED -- DO NOT EDIT DIRECTLY
// Source: .agents/
// Regenerate: ./scripts/generate-agents.sh

// Commands registered from .agents/commands/
const COMMANDS = {
  &quot;kickoff&quot;: &quot;@planner: Task: [Describe your change, e.g. \&quot;Add wezterm keybinding for X\&quot; or \&quot;Add new task to Taskfile\&quot;]\n\nFollow dotfiles workflow from .cursor/rules/dotfiles-core.mdc. Plan with bite-sized tasks → implement (config or taskfile) → @code-reviewer after each task. At completion: run &#x60;task precommit&#x60; then finish-branch options.&quot;,
  &quot;brainstorm&quot;: &quot;@planner: Requirements are unclear. Run a brainstorm.\n\nFollow .cursor/rules/dotfiles-brainstorm.mdc: explore context (etc/, nvim/, wezterm/, tasks/, scripts/); ask clarifying questions one at a time; propose 1-2 approaches with trade-offs; get user approval; then transition to writing the implementation plan (.cursor/rules/dotfiles-plan.mdc). Do not edit config or taskfiles until the approach is approved and the plan exists.&quot;,
  &quot;write-plan&quot;: &quot;@planner: Write the implementation plan for the current task/request.\n\nFollow .cursor/rules/dotfiles-plan.mdc: break work into small tasks (2-5 min each) with exact paths (etc/, nvim/, wezterm/, tasks/, scripts/) and commands. Save plan to .agents/plans/ with naming YYYY-MM-DD_&lt;username&gt;_&lt;slug&gt;.plan.md. Do not implement yet; next step is execute-plan or delegate per task. Rule reference: dotfiles-plan.mdc.&quot;,
  &quot;execute-plan&quot;: &quot;@planner: Execute the current plan in .agents/plans/.\n\nFollow .cursor/rules/dotfiles-core.mdc (execute flow): read the plan; for each task delegate to @config or @taskfile with the full task text; after each task confirm work matches the plan, then @code-reviewer (what implemented, plan ref, BASE_SHA, HEAD_SHA). After all tasks: run @pre-commit-run (e.g. task precommit), then follow .cursor/rules/dotfiles-git.mdc for finish-branch options.&quot;,
  &quot;systematic-debugging&quot;: &quot;@planner: We have a bug or broken behavior. Run systematic debugging.\n\nFollow .cursor/rules/dotfiles-debug.mdc: Phase 1 (root cause) - read errors/logs; reproduce; check recent changes (git diff, config in etc/nvim/wezterm/tasks, env); narrow where it fails. Phase 2 (pattern) - compare with working examples. Phase 3 (hypothesis) - one clear hypothesis; test minimally. Phase 4 (fix) - only after root cause: minimal fix; verify. Do not suggest fixes before Phase 1 is complete. Rule reference: dotfiles-debug.mdc.&quot;,
  &quot;finish-branch&quot;: &quot;@planner: Finish the current branch.\n\nFollow .cursor/rules/dotfiles-git.mdc: (1) Run @pre-commit-run (e.g. &#x60;task precommit&#x60; or scripts/hooks/pre-commit); if it fails, show failures and fix first. (2) Determine base branch. (3) Present exactly four options: merge locally, push and create PR, keep branch as-is, discard (require explicit confirmation for discard). (4) Execute the user&#x27;s choice; clean up worktree if merging or discarding. Rule reference: dotfiles-git.mdc. Skill: pre-commit-run.&quot;,
  &quot;request-code-review&quot;: &quot;@code-reviewer: Review the current changes.\n\nProvide: **What was implemented** (brief description), **Plan reference** (e.g. .agents/plans/YYYY-MM-DD_user_slug.plan.md Task N), **BASE_SHA**, **HEAD_SHA**. Code Reviewer will check style and plan adherence; may suggest @pre-commit-run (e.g. task precommit). See .agents/agents/code-reviewer.md for request template.&quot;,
};

export default async (_ctx) => ({
  "command.execute.before": async (input, output) => {
    const content = COMMANDS[input.command];
    if (content) {
      output.parts.push({ type: "text", text: content });
    }
  },
  "experimental.session.compacting": async (_input, output) => {
    output.context.push(
      "Gate check: before continuing, validate all work against the active plan in .agents/plans/ or .cursor/plans/. " +
        "Every implementation task must be plan-aligned. Invoke @planner to validate if unsure."
    );
  },
});
