# /deploy — Deployment Readiness Check

Verify the project is ready for deployment and optionally trigger the pipeline.

## Input

$ARGUMENTS — Optional: target environment (staging / production).

## Steps

1. Load project config from `.cursor/skills/autocode/config.json`.
2. Run pre-deploy checklist:
   - [ ] All tests pass: `{{test_runner_cmd}}`
   - [ ] Linter clean: `{{lint_cmd}}`
   {{#if e2e_enabled}}- [ ] E2E tests pass: `{{e2e_run_cmd}}`{{/if}}
   - [ ] No uncommitted changes: `git status --porcelain`
   - [ ] Branch is up to date with main: `git fetch && git status`
3. If CI/CD is configured ({{ci_cd}}):
   - {{cicd_manage_config}} mode: generate/update pipeline config if needed
   - Show the user what will be deployed and to where
4. Report readiness:
   - ✅ All checks pass → ready to deploy
   - ❌ Checks failed → list failures and suggest fixes

## Constraints

- NEVER auto-deploy to production without explicit user confirmation.
- Deploy target: {{cicd_deploy_target}}
- Required checks: {{cicd_pre_merge_checks}}
