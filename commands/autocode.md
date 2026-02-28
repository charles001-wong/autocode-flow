---
description: Fully autonomous development pipeline. Give it a feature description or PRD file and it will plan, write tests, implement code, run tests, and verify — all automatically with zero human intervention.
---

# /autocode — Autonomous Development Pipeline

Execute the full development pipeline automatically: **Plan → TDD → Code → Test → Verify**.

No human intervention required. Just describe what you want or point to a PRD file.

## Input

$ARGUMENTS — One of:
- A feature description in natural language: `/autocode 新增用户登录注册功能`
- A PRD file reference: `/autocode prd @docs/user-auth-prd.md`
- A GitHub issue URL: `/autocode issue https://github.com/org/repo/issues/42`

## Orchestration Flow

Execute these phases **sequentially and automatically**. Do NOT stop to ask the user
between phases. Each phase's output feeds directly into the next phase.

```
┌─────────────────────────────────────────────────────────────────────┐
│                    /autocode Pipeline                                │
│                                                                      │
│  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────────┐   │
│  │  PLAN  │─►│  TDD   │─►│  CODE  │─►│  TEST  │─►│   VERIFY   │   │
│  │        │  │per step │  │per step│  │  full  │  │lint+review │   │
│  └────────┘  └────────┘  └────────┘  └────────┘  └────────────┘   │
│                                                                      │
│  Optional (if enabled):                                              │
│  ┌────────┐  ┌────────────┐                                         │
│  │  E2E   │─►│  SUMMARY   │                                        │
│  └────────┘  └────────────┘                                         │
└─────────────────────────────────────────────────────────────────────┘
```

---

### Phase 1: PLAN (需求分析 & 任务拆解)

**Goal**: Convert the requirement into an ordered list of atomic implementation steps.

1. If input is a PRD file, read and parse it.
2. Search the codebase for related existing code, types, and patterns.
3. Produce a structured plan:

```json
{
  "feature": "User login and registration",
  "steps": [
    {
      "id": 1,
      "title": "Create user model and database schema",
      "files": ["internal/model/user.go", "internal/model/user_test.go"],
      "test_spec": "TestUserModel_Validate: valid/invalid email, password length",
      "depends_on": []
    },
    {
      "id": 2,
      "title": "Implement registration logic",
      "files": ["internal/logic/register_logic.go", "internal/logic/register_logic_test.go"],
      "test_spec": "TestRegisterLogic: success, duplicate email, weak password",
      "depends_on": [1]
    }
  ]
}
```

4. Print the plan summary (for the user to see in the log) but do NOT wait for confirmation.
   Proceed immediately to Phase 2.

**Output**: `plan` object with ordered steps.

---

### Phase 2: TDD — Write Tests First (逐步编写测试)

**Goal**: For EACH step in the plan, write the test file FIRST.

For each `plan.steps[i]`:

1. Read the `test_spec` from the plan.
2. Write the complete test file with all test cases.
   - Tests MUST be concrete (real assertions, not `// TODO`).
   - Tests MUST fail initially (the implementation doesn't exist yet).
3. Run the test to confirm it fails (RED phase):
   ```bash
   {{test_runner_cmd}}
   ```
   - If it fails with compilation/import errors, that's expected — note it and proceed.
   - If it passes unexpectedly, the test is wrong — rewrite it.

After ALL step tests are written, move to Phase 3.

**Output**: All test files written and confirmed to be in RED state.

---

### Phase 3: CODE — Implement Step by Step (逐步实现代码)

**Goal**: For EACH step in the plan (in order), implement the minimum code to pass its tests.

For each `plan.steps[i]`:

1. Read the corresponding test file to understand the expected behavior.
2. Write the implementation code — minimum to pass the tests.
3. Run the specific test:
   ```bash
   {{test_single_cmd}} {{test_pattern}}
   ```
4. If tests fail: analyze the failure, fix the code, re-run. Repeat until GREEN.
5. Quick refactor: clean up any obvious issues while tests stay green.
6. Move to the next step.

After ALL steps are implemented and passing, move to Phase 4.

**Output**: All implementation files written, all step-level tests GREEN.

---

### Phase 4: TEST — Full Suite & Coverage (完整测试 & 覆盖率)

**Goal**: Run the complete test suite and verify coverage meets the target.

1. Run the full test suite:
   ```bash
   {{test_runner_cmd}}
   ```

2. Run coverage analysis:
   ```bash
   {{coverage_cmd}}
   ```

3. If coverage < {{coverage_target}}%:
   - Identify uncovered lines/branches.
   - Write additional tests to cover them.
   - Re-run until coverage target is met.

4. If any tests fail:
   - Analyze and fix the failures.
   - Re-run until all tests pass.

**Output**: All tests GREEN, coverage ≥ {{coverage_target}}%.

---

### Phase 5: VERIFY — Lint & Self-Review (质量验证)

**Goal**: Ensure code quality meets project standards.

1. Run linter:
   ```bash
   {{lint_cmd}}
   ```
   - If lint errors: fix them automatically, re-run.

2. Self code review — check for:
   - [ ] No hardcoded secrets or credentials
   - [ ] Proper error handling on all paths
   - [ ] No debug/print statements
   - [ ] No commented-out code
   - [ ] Files within length limits
   - [ ] Functions focused and under 50 lines

3. Fix any issues found, re-run tests to confirm nothing broke.

**Output**: Lint clean, all quality checks passed.

---

### Phase 6: E2E (端到端测试, if enabled)

**Skip this phase if E2E is disabled in config.**

1. Write E2E test(s) covering the new feature's user-facing flow.
2. Run E2E tests:
   ```bash
   {{e2e_run_cmd}}
   ```
3. If failures: fix and re-run.

**Output**: E2E tests passing.

---

### Phase 7: SUMMARY (完成报告)

Print a final report:

```
═══════════════════════════════════════════════════
  autocode complete: {feature_name}
═══════════════════════════════════════════════════

  Plan:     {N} steps decomposed
  Tests:    {N} test cases written
  Code:     {N} files created/modified
  Coverage: {XX}% (target: {YY}%)
  Lint:     ✅ clean
  E2E:      ✅ passed / ⏭ skipped

  Files changed:
    + internal/model/user.go
    + internal/model/user_test.go
    + internal/logic/register_logic.go
    + internal/logic/register_logic_test.go
    ...

  Ready to commit. Suggest:
    git add -A && git commit -m "feat: {feature_name}"
═══════════════════════════════════════════════════
```

---

## Error Recovery

If any phase fails repeatedly (3+ attempts):
1. Log the error details.
2. Print what was accomplished so far.
3. Print the specific failure and which phase it occurred in.
4. Suggest the user run the individual phase command to debug.

## Critical Rules

- **NEVER stop to ask the user** between phases. The entire pipeline is autonomous.
- **ALWAYS run tests** after writing code. Never assume code is correct.
- **FIX failures inline** — if a test fails, debug and fix immediately, don't skip.
- **Coverage is mandatory** — keep writing tests until the target is met.
- **Use project conventions** from the autocode config, not generic patterns.
