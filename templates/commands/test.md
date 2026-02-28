# /test — Run Tests & Check Coverage

Execute the project's test suite and report results.

## Input

$ARGUMENTS — Optional: specific test file, function, or package to test.

## Steps

1. Load project config from `.cursor/skills/autocode/config.json`.
2. Determine scope:
   - No arguments → run full suite: `{{test_runner_cmd}}`
   - With arguments → run targeted: `{{test_single_cmd}} $ARGUMENTS`
3. Execute the tests and capture output.
4. Run coverage report: `{{coverage_cmd}}`
5. Compare coverage to target ({{coverage_target}}%).
6. Report results:
   - ✅ All tests pass + coverage met → ready to proceed
   - ⚠️ Tests pass but coverage below target → suggest additional tests
   - ❌ Tests fail → show failures and suggest fixes

## Output Format

```
Test Results: ✅ PASS / ❌ FAIL
  Total:    N tests
  Passed:   N
  Failed:   N
  Skipped:  N
Coverage:   XX.X% (target: {{coverage_target}}%)
  Status:   ✅ Met / ⚠️ Below target
```
