---
name: autocode-flow
description: >
  Meta-skill that generates a project-specific autonomous development pipeline.
  Two commands: /autocode-new (setup wizard) and /autocode (run full pipeline).
  User says "autocode-new", "setup autocode", or "generate dev pipeline" to configure.
  Then uses "/autocode <feature>" to auto-execute plan → tdd → code → test → verify.
version: 1.0.0
---

# autocode-flow — Autonomous Development Pipeline Generator

## What This Does

Two commands, one workflow:

1. **`/autocode-new`** — One-time setup. Scans project, asks preferences, generates pipeline config.
2. **`/autocode <requirement>`** — Runs the full dev pipeline autonomously. Zero human interaction.

```
/autocode-new                          (run once per project)
    ↓
/autocode 新增用户登录注册功能           (run per feature)
    ↓
Plan → TDD → Code → Test → Verify     (all automatic)
    ↓
Done. Ready to commit.
```

---

## Command: /autocode-new (Setup)

### Phase 1: Scan

Run: `bash "${CLAUDE_PLUGIN_ROOT}/scripts/scan-project.sh" "$(pwd)"`

Detects: language, framework, package manager, test framework, linter, CI/CD, Docker.

Present results and ask: "Correct? Any fixes?"

### Phase 2: Interview (one stage at a time)

| Stage   | Key Questions                                           |
|---------|---------------------------------------------------------|
| **TDD** | Strict TDD? Coverage target? Language-specific tools?   |
| **Code**| Max file lines? Error handling pattern? Linter confirm? |
| **Test**| File location? Integration strategy? Auto-run?          |
| **E2E** | Enabled? Tool? Scope? Environment?                      |
| **CI/CD**| Manage configs? Deploy target? Pre-merge checks?       |

### Phase 3: Generate

Read templates from `${CLAUDE_PLUGIN_ROOT}/templates/` and write project-specific files:

```
{project}/
├── .claude/
│   ├── commands/
│   │   └── autocode.md          ← THE main command
│   └── agents/
│       ├── planner.md
│       ├── tdd-guide.md
│       ├── code-reviewer.md
│       └── e2e-runner.md        (if E2E enabled)
├── .cursor/
│   ├── rules/
│   │   ├── autocode-workflow.mdc
│   │   ├── coding-style.mdc
│   │   └── testing.mdc
│   └── skills/
│       └── autocode/
│           ├── SKILL.md
│           └── config.json
└── docs/autocode/pipeline.md
```

---

## Command: /autocode (Execute)

### Usage

```
/autocode 新增用户登录注册功能
/autocode prd @docs/feature-x-prd.md
/autocode Fix the race condition in order processing
```

### Pipeline Phases (all automatic, no human intervention)

#### Phase 1: PLAN
- Parse requirement (text or PRD file)
- Scan codebase for related code
- Decompose into ordered atomic steps (max 8)
- Each step has: files, test_spec, implementation description, dependencies
- Print plan, proceed immediately (no waiting)

#### Phase 2: TDD (per step)
- Write COMPLETE test files (real assertions, not stubs)
- Run tests to confirm FAIL (RED)
- If unexpectedly PASS → rewrite tests stricter
- All test files created before any implementation

#### Phase 3: CODE (per step)
- For each step: read test → write minimum implementation → run test
- If FAIL → fix → re-run (loop until GREEN)
- Quick refactor while tests stay green

#### Phase 4: TEST (full suite)
- Run all tests: `{test_runner_cmd}`
- Check coverage: `{coverage_cmd}`
- If coverage < target → write additional tests → re-run
- Loop until: all GREEN + coverage ≥ target

#### Phase 5: VERIFY
- Run linter → auto-fix → re-run
- Self-review: no secrets, no debug prints, proper error handling
- Fix issues → re-run tests

#### Phase 6: E2E (if enabled)
- Write E2E test for the feature's critical path
- Run → fix if needed

#### Phase 7: SUMMARY
- Print report: steps, tests, files, coverage, lint status
- Suggest git commit command

### Critical Rules

- **NEVER stop to ask the user** between phases
- **ALWAYS run tests** after writing code
- **FIX failures inline** — don't skip broken tests
- **LOOP until coverage** target met

---

## Template Variable Reference

Templates use `{{variable}}` placeholders replaced during generation.

### From Scanner
`project_name`, `language`, `framework`, `package_manager`, `test_framework`,
`test_runner_cmd`, `linter`, `ci_cd`, `has_docker`, `source_dirs`

### From Interview
`coverage_target`, `tdd_style`, `code_max_file_lines`, `code_error_handling`,
`test_file_location`, `test_integration_strategy`, `e2e_enabled`, `e2e_tool`,
`cicd_deploy_target`

### Derived
`source_glob`, `test_glob`, `lint_cmd`, `coverage_cmd`, `test_single_cmd`,
`test_file_naming`, `e2e_run_cmd`

---

## Error Recovery

If a phase fails 3+ times:
1. Log error details
2. Print accomplished work so far
3. Print failure and phase name
4. Continue to next phase if possible, or stop gracefully
