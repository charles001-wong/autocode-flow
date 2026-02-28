---
description: Fully autonomous development pipeline for order-service. Describe a feature or pass a PRD and it auto-executes plan → tdd → code → test → verify.
---

# /autocode — order-service Autonomous Pipeline

Fully automated: Plan → TDD → Code → Test → Verify. Zero human intervention.

## Input

$ARGUMENTS — Feature description or PRD file:
- `/autocode 新增订单创建功能`
- `/autocode prd @docs/order-create-prd.md`

## Pipeline Config

| Setting          | Value                     |
|------------------|---------------------------|
| Language         | Go                        |
| Framework        | go-zero                   |
| Test runner      | `go test ./...`           |
| Coverage cmd     | `go test ./... -coverprofile=cover.out` |
| Coverage target  | 80%                       |
| Linter           | `golangci-lint run`       |
| E2E enabled      | false                     |

---

## Phase 1: PLAN

1. Parse the requirement from $ARGUMENTS.
2. Search codebase: `cmd/`, `internal/`, `pkg/`.
3. Decompose into ordered atomic steps (max 8). Each step:
   - `title`, `files` (source + test), `test_spec` (concrete scenarios), `depends_on`
4. Follow go-zero architecture: Handler → Logic → Model.
5. Print plan summary. **Do NOT wait.** Proceed immediately.

## Phase 2: TDD (per step)

For each step:
1. Write complete test file using table-driven tests with `testify/assert`.
2. File pattern: `*_test.go` co-located with source.
3. Run: `go test ./...` → confirm FAIL.

## Phase 3: CODE (per step)

For each step:
1. Read test → write minimum implementation → run test.
2. If FAIL → fix → re-run. Loop until GREEN.
3. Follow go-zero Handler/Logic/Model pattern.

## Phase 4: TEST (full suite)

1. `go test ./...`
2. `go test ./... -coverprofile=cover.out && go tool cover -func=cover.out`
3. If coverage < 80% → write more tests → re-run.
4. Loop until: all GREEN + coverage ≥ 80%.

## Phase 5: VERIFY

1. `golangci-lint run` → fix → re-run.
2. Self-review: no secrets, no fmt.Println, proper error wrapping with `%w`.
3. Fix issues → re-run tests.

## Phase 6: SUMMARY

Print report: steps, tests, files, coverage, lint status. Suggest commit.

## Rules

- **NEVER** stop to ask the user between phases.
- **ALWAYS** run `go test` after writing code.
- **FIX** failures inline, don't skip.
