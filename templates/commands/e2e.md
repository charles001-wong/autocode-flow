# /e2e — End-to-End Tests

Read the `e2e-runner` agent definition from `.claude/agents/e2e-runner.md` and execute
end-to-end tests.

## Input

$ARGUMENTS — Optional: specific test file or test name to run.

## Steps

1. Load project config from `.cursor/skills/autocode/config.json`.
2. Verify the E2E environment is ready:
   - {{e2e_environment}} must be accessible
   - Required services must be running
3. Execute tests:
   - Full suite: `{{e2e_run_cmd}}`
   - Single test: `{{e2e_run_single_cmd}} $ARGUMENTS`
4. Collect results, screenshots, and traces.
5. Report pass/fail summary with links to failure artifacts.

## Constraints

- E2E tests run against: {{e2e_environment}}
- Tool: {{e2e_tool}}
- Keep test runtime under 5 minutes for the full suite.
