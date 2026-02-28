# /test — Run Tests & Check Coverage

Execute the project's test suite and report results.

## Input

$ARGUMENTS — Optional: specific package or test function to run.

## Steps

1. Determine scope:
   - No arguments → run full suite: `go test ./...`
   - With package → `go test ./$ARGUMENTS/...`
   - With function → `go test ./... -run $ARGUMENTS`
2. Execute the tests and capture output.
3. Run coverage report: `go test ./... -coverprofile=cover.out && go tool cover -func=cover.out`
4. Compare coverage to target (80%).
5. Report results:
   - ✅ All tests pass + coverage met → ready to proceed
   - ⚠️ Tests pass but coverage below 80% → suggest additional tests
   - ❌ Tests fail → show failures and suggest fixes
