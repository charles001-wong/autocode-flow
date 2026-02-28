# autocode-flow — Architecture Reference

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    autocode-flow (Meta-Skill)                │
│                                                              │
│  ┌──────────┐    ┌──────────────┐    ┌──────────────────┐   │
│  │  Scanner  │───►│  Interviewer  │───►│    Generator     │   │
│  │ Phase 1   │    │   Phase 2     │    │    Phase 3       │   │
│  └──────────┘    └──────────────┘    └──────────────────┘   │
│       │                 │                      │             │
│  scan-project.sh   AskQuestion          templates/ → files   │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                  autocode (Generated Skill)                   │
│                                                               │
│  ┌─────────┐  ┌────────┐  ┌───────┐  ┌───────┐  ┌───────┐  │
│  │  Rules   │  │ Agents │  │ Cmds  │  │ Hooks │  │ Skill │  │
│  │ .cursor/ │  │.claude/│  │.claude│  │.claude│  │.cursor│  │
│  │ rules/   │  │agents/ │  │cmds/  │  │hooks/ │  │skills/│  │
│  └─────────┘  └────────┘  └───────┘  └───────┘  └───────┘  │
│       │            │           │          │          │        │
│       ▼            ▼           ▼          ▼          ▼        │
│  coding-style  planner    /plan      post-edit  SKILL.md     │
│  testing       tdd-guide  /tdd       pre-commit config.json  │
│  workflow      reviewer   /code                              │
│                e2e-runner /test                               │
│                           /e2e                                │
│                           /deploy                             │
└─────────────────────────────────────────────────────────────┘
```

## Component Responsibilities

### Rules (`.cursor/rules/`)

Rules are always-on or file-scoped instructions that the AI follows during every
interaction. They enforce coding standards without the user needing to remember them.

| File                    | Scope        | Purpose                          |
|-------------------------|--------------|----------------------------------|
| `autocode-workflow.mdc` | Always       | Pipeline discipline              |
| `coding-style.mdc`     | Source files | Language-specific conventions    |
| `testing.mdc`          | Test files   | Test structure and coverage      |

### Agents (`.claude/agents/`)

Agents are specialized personas the AI can invoke for specific tasks. Each agent
has a single responsibility and a defined output format.

| Agent           | Responsibility                              |
|-----------------|---------------------------------------------|
| `planner`       | Task decomposition → implementation plan    |
| `tdd-guide`     | RED/GREEN/REFACTOR cycle enforcement        |
| `code-reviewer` | Quality, security, and style review         |
| `e2e-runner`    | End-to-end test creation and execution      |

### Commands (`.claude/commands/`)

Commands are user-invocable shortcuts (e.g., `/plan`) that orchestrate agent
workflows with predefined steps.

### Hooks (`.claude/hooks/`)

Hooks are automatic triggers that fire on specific events (file save, pre-commit,
session start/end). They enforce quality gates without manual intervention.

### Skill (`.cursor/skills/autocode/`)

The generated skill is the entry point that ties everything together. It contains:
- `SKILL.md` — pipeline documentation and quick start
- `config.json` — serialized configuration from the interview

## Template Variable Reference

Templates use `{{variable}}` syntax. The generator replaces these with project-specific
values during Phase 3.

### Project Variables (from scanner)

| Variable           | Source                 | Example                |
|--------------------|------------------------|------------------------|
| `project_name`     | Directory/package name | `my-api`               |
| `language`         | File detection         | `go`                   |
| `framework`        | Dependency analysis    | `gin`                  |
| `package_manager`  | Lock file detection    | `go mod`               |
| `test_framework`   | Config file detection  | `go test`              |
| `test_runner_cmd`  | Derived from above     | `go test ./...`        |
| `linter`           | Config file detection  | `golangci-lint`        |
| `ci_cd`            | Workflow dir detection | `github-actions`       |
| `has_docker`       | Dockerfile presence    | `true`                 |
| `has_monorepo`     | Workspace file check   | `false`                |
| `source_dirs`      | Directory scan         | `["cmd/", "internal/"]`|

### Interview Variables (from user)

| Variable                 | Phase  | Example                   |
|--------------------------|--------|---------------------------|
| `plan_enabled`           | Plan   | `true`                    |
| `plan_generate_docs`     | Plan   | `"lightweight"`           |
| `plan_docs_location`     | Plan   | `"docs/plans"`            |
| `plan_auto_decompose`    | Plan   | `true`                    |
| `tdd_enabled`            | TDD    | `true`                    |
| `tdd_style`              | TDD    | `"strict"`                |
| `coverage_target`        | TDD    | `80`                      |
| `code_max_file_lines`    | Code   | `400`                     |
| `code_error_handling`    | Code   | `"explicit returns"`      |
| `code_comments`          | Code   | `"critical paths only"`   |
| `test_file_location`     | Test   | `"co-located"`            |
| `test_integration_strategy` | Test | `"testcontainers"`     |
| `test_auto_run`          | Test   | `true`                    |
| `e2e_enabled`            | E2E    | `true`                    |
| `e2e_tool`               | E2E    | `"playwright"`            |
| `e2e_scope`              | E2E    | `"critical paths"`        |
| `e2e_environment`        | E2E    | `"local"`                 |
| `cicd_manage_config`     | CI/CD  | `"read-only"`             |
| `cicd_deploy_target`     | CI/CD  | `"docker"`                |
| `cicd_pre_merge_checks`  | CI/CD  | `"lint + test"`           |

### Derived Variables

These are computed from project + interview variables:

| Variable            | Derivation Logic                                        |
|---------------------|---------------------------------------------------------|
| `source_glob`       | Go: `**/*.go`, TS: `**/*.{ts,tsx}`, Py: `**/*.py`      |
| `test_glob`         | Go: `**/*_test.go`, TS: `**/*.test.{ts,tsx}`, Py: `**/test_*.py` |
| `lint_cmd`          | Go: `golangci-lint run`, TS: `eslint .`, Py: `ruff check .` |
| `coverage_cmd`      | Go: `go test ./... -coverprofile=cover.out`, etc.       |
| `test_file_naming`  | Go: `*_test.go`, TS: `*.test.ts`, Py: `test_*.py`      |
| `e2e_run_cmd`       | Playwright: `npx playwright test`, Cypress: `npx cypress run` |
| `e2e_config_file`   | Playwright: `playwright.config.ts`, Cypress: `cypress.config.ts` |

## Conditional Sections

Templates use Handlebars-like conditionals for language-specific blocks:

```
{{#go}}     ... Go-specific content ...     {{/go}}
{{#typescript}} ... TS-specific content ... {{/typescript}}
{{#python}} ... Python-specific content ... {{/python}}
{{#if e2e_enabled}} ... only if E2E enabled ... {{/if}}
```

The generator agent reads these and keeps only the sections matching the detected
language and enabled features.

## Extending autocode

### Adding a New Pipeline Stage

1. Create a command template in `templates/commands/`
2. Create an agent template in `templates/agents/` (if needed)
3. Add the stage to the `autocode-workflow.mdc` rule template
4. Update the interview flow in `SKILL.md` Phase 2
5. Add configuration fields to `config.json` template

### Adding Language Support

1. Add detection logic to `scripts/scan-project.sh`
2. Add language-specific conditional blocks (`{{#lang}}...{{/lang}}`) to:
   - `templates/rules/coding-style.mdc`
   - `templates/rules/testing.mdc`
   - `templates/agents/tdd-guide.md`
3. Define derived variables (globs, commands) for the language

### Customizing for a Framework

1. Detect the framework in the scanner
2. Add framework conventions to the coding-style rule template
3. Add framework-specific patterns to agent templates
4. Update the interview to ask framework-specific questions

## Design Principles

1. **Project-bound**: Every generated artifact references the specific project's
   tools, commands, and conventions. No generic fallbacks.
2. **Single responsibility**: Each agent, rule, and command does one thing well.
3. **Progressive**: The interview asks one stage at a time; the pipeline supports
   partial adoption (skip stages that don't apply).
4. **Idempotent**: Running autocode-flow again on the same project updates existing
   files without losing manual customizations (with user confirmation).
5. **Transparent**: `config.json` captures all decisions; `pipeline.md` documents
   the workflow in human-readable form.
