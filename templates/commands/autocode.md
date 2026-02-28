---
description: Fully autonomous development pipeline for {{project_name}}. Describe a feature or pass a PRD and it auto-executes plan → tdd → code → test → verify.
---

# /autocode — {{project_name}} Autonomous Pipeline

Fully automated: Plan → TDD → Code → Test → Verify. Zero human intervention.

## Input

$ARGUMENTS — Feature description or PRD file:
- `/autocode 新增用户登录注册功能`
- `/autocode prd @docs/login-prd.md`

## Pipeline Config

Load from `.cursor/skills/autocode/config.json` (or `.claude/skills/autocode/config.json`).

| Setting          | Value                     |
|------------------|---------------------------|
| Language         | {{language}}               |
| Framework        | {{framework}}              |
| Test runner      | `{{test_runner_cmd}}`      |
| Coverage cmd     | `{{coverage_cmd}}`         |
| Coverage target  | {{coverage_target}}%       |
| Linter           | `{{lint_cmd}}`             |
| E2E enabled      | {{e2e_enabled}}            |

---

## Phase 1: PLAN

1. Parse the requirement from $ARGUMENTS (text or file content).
2. Search codebase for related code: `{{source_dirs}}`.
3. Decompose into ordered atomic steps. Each step must define:
   - `title` — what to build
   - `files` — source + test file paths
   - `test_spec` — concrete test scenarios (not vague descriptions)
   - `depends_on` — which steps must be done first
4. Print plan summary. **Do NOT wait for approval.** Proceed immediately.

## Phase 2: TDD (per step)

For each step in the plan, in dependency order:

1. Write the **complete test file** based on `test_spec`.
{{#go}}
   - Use table-driven tests with `t.Run`.
   {{#if tdd_extra.use_testify}}- Use `testify/assert` for assertions.{{/if}}
   - File pattern: `*_test.go` co-located with source.
{{/go}}
{{#typescript}}
   - Use `{{test_framework}}` with `describe`/`it` blocks.
   - File pattern: `*.test.ts` or `*.spec.ts`.
{{/typescript}}
{{#python}}
   - Use `pytest` with descriptive function names.
   - File pattern: `test_*.py` in `tests/` directory.
{{/python}}
2. Run to confirm FAIL: `{{test_runner_cmd}}`
   Compilation errors = expected. Unexpected PASS = rewrite test.

## Phase 3: CODE (per step)

For each step, in the same order:

1. Read the test file to understand expected behavior.
2. Write minimum implementation to pass.
3. Run step test: `{{test_single_cmd}}`
4. If FAIL → fix → re-run. Loop until GREEN.
5. Quick refactor while tests stay green.

## Phase 4: TEST (full suite)

1. Run: `{{test_runner_cmd}}`
2. Run: `{{coverage_cmd}}`
3. If coverage < {{coverage_target}}%: write more tests → re-run.
4. If any test fails: fix → re-run.
5. Loop until: all GREEN + coverage ≥ {{coverage_target}}%.

## Phase 5: VERIFY

1. Lint: `{{lint_cmd}}` → auto-fix if possible → re-run.
2. Self-review checklist:
   - No secrets, no debug prints, no commented-out code
   - Proper error handling, files within size limits
3. Fix issues → re-run tests to confirm.

{{#if e2e_enabled}}
## Phase 6: E2E

1. Write E2E test for the new feature's user flow.
2. Run: `{{e2e_run_cmd}}`
3. Fix failures → re-run.
{{/if}}

## Phase 7: SUMMARY

Print final report with: steps completed, tests written, files changed,
coverage percentage, lint status. Suggest git commit command.

## Rules

- **NEVER** stop to ask the user between phases.
- **ALWAYS** run tests after writing code.
- **FIX** failures inline, don't skip.
- **LOOP** until coverage target met.
