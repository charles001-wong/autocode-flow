---
name: autocode
description: >
  Project-specific automated development pipeline for {{project_name}}.
  Orchestrates plan → tdd → code → test → e2e → deploy workflow using
  {{language}} / {{framework}} conventions. Use when the user starts a new feature,
  fixes a bug, or asks to follow the dev workflow.
version: 1.0.0
generated_by: autocode-flow
---

# autocode — {{project_name}} Development Pipeline

Automated development workflow tailored for this **{{language}}** project
{{#if framework}}using **{{framework}}**{{/if}}.

## Pipeline Stages

```
/plan → /tdd → /code → /test{{#if e2e_enabled}} → /e2e{{/if}}{{#if deploy_enabled}} → /deploy{{/if}}
```

## Quick Start

1. **Start a feature**: Run `/plan` with a description of what you want to build
2. **Write tests first**: Run `/tdd` to create test stubs based on the plan
3. **Implement**: Run `/code` or start coding — the agent follows project conventions
4. **Verify**: Run `/test` to execute tests and check coverage
{{#if e2e_enabled}}5. **E2E**: Run `/e2e` to run end-to-end tests{{/if}}
{{#if deploy_enabled}}6. **Deploy**: Run `/deploy` to check deployment readiness{{/if}}

## Project Context

| Property         | Value                        |
|------------------|------------------------------|
| Language         | {{language}}                 |
| Framework        | {{framework}}                |
| Package Manager  | {{package_manager}}          |
| Test Framework   | {{test_framework}}           |
| Test Command     | `{{test_runner_cmd}}`        |
| Linter           | {{linter}}                   |
| CI/CD            | {{ci_cd}}                    |
| Coverage Target  | {{coverage_target}}%         |

## Configuration

Full pipeline configuration is stored in [config.json](config.json).
To reconfigure, run `/autocode-new` again or edit `config.json` directly.

## Agents

| Agent            | Purpose                                        |
|------------------|-------------------------------------------------|
| `planner`        | Decomposes features into implementation steps   |
| `tdd-guide`      | Enforces test-first development                 |
| `code-reviewer`  | Reviews code quality, security, style           |
{{#if e2e_enabled}}| `e2e-runner`     | Manages end-to-end test execution               |{{/if}}

## Rules

| Rule               | Scope                                         |
|--------------------|-----------------------------------------------|
| `autocode-workflow` | Always — enforces pipeline discipline          |
| `coding-style`     | `{{source_glob}}` — language-specific style    |
| `testing`          | `{{test_glob}}` — test conventions             |
