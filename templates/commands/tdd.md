# /tdd — Test-Driven Development

Read the `tdd-guide` agent definition from `.claude/agents/tdd-guide.md` and follow the
RED → GREEN → REFACTOR cycle.

## Input

$ARGUMENTS — The feature or function to implement via TDD. Optionally, a path to a plan file.

## Steps

1. Load project config from `.cursor/skills/autocode/config.json`.
2. If a plan exists, read the next unimplemented step.
3. **RED**: Write a failing test for the target behavior.
   - Test command: `{{test_runner_cmd}}`
   - Confirm the test fails before proceeding.
4. **GREEN**: Write the minimum implementation to pass the test.
   - Run the test again to confirm it passes.
5. **REFACTOR**: Clean up implementation and test code.
   - Run full test suite to ensure nothing broke.
6. Repeat for the next behavior until the feature is complete.

## Constraints

- NEVER skip the RED phase. The test must fail first.
- Coverage target: {{coverage_target}}%.
- After completion, run: `{{coverage_cmd}}`
