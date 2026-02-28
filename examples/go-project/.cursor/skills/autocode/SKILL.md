---
name: autocode
description: >
  Project-specific automated development pipeline for order-service.
  Orchestrates plan → tdd → code → test → deploy workflow using
  Go / go-zero conventions. Use when the user starts a new feature,
  fixes a bug, or asks to follow the dev workflow.
version: 1.0.0
generated_by: autocode-flow
---

# autocode — order-service Development Pipeline

Automated development workflow tailored for this **Go** project using **go-zero**.

## Pipeline Stages

```
/plan → /tdd → /code → /test → /deploy
```

## Quick Start

1. **Start a feature**: Run `/plan` with a description of what you want to build
2. **Write tests first**: Run `/tdd` to create test stubs based on the plan
3. **Implement**: Run `/code` or start coding — the agent follows project conventions
4. **Verify**: Run `/test` to execute tests and check coverage
5. **Deploy**: Run `/deploy` to check deployment readiness

## Project Context

| Property         | Value                        |
|------------------|------------------------------|
| Language         | Go                           |
| Framework        | go-zero                      |
| Package Manager  | go mod                       |
| Test Framework   | go test                      |
| Test Command     | `go test ./...`              |
| Linter           | golangci-lint                |
| CI/CD            | github-actions               |
| Coverage Target  | 80%                          |

## Configuration

Full pipeline configuration is stored in [config.json](config.json).
To reconfigure, run `/autocode-new` again or edit `config.json` directly.
