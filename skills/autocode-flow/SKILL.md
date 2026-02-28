---
name: autocode-flow
description: >
  Meta-skill that generates a project-specific automated development workflow (autocode).
  Scans the project, interviews the user about their dev pipeline preferences, and outputs
  a complete skill/agent/hook/rule system tailored to the codebase. Use when the user says
  "autocode-new", "generate autocode", "setup dev workflow", "create autocode", or wants to
  bootstrap an automated coding pipeline for their project.
version: 1.0.0
---

# autocode-flow — Generative Meta-Skill

Generate a **project-bound** `autocode` development pipeline by scanning the codebase and
interviewing the developer. The output is a complete skill + agent + rule + command + hook
system that enforces the team's workflow inside the AI coding assistant.

## Activation

Trigger when the user runs `/autocode-new` or asks to "generate autocode / create autocode /
setup dev workflow".

## Workflow Overview

```
Phase 1: Scan ──► Phase 2: Interview ──► Phase 3: Generate
  (auto)            (interactive)           (auto)
```

---

## Phase 1 — Project Context Scan

Run the scanner script and capture the JSON output:

```bash
bash "<path-to-this-skill>/scripts/scan-project.sh" "<target-project-root>"
```

If the script is unavailable, perform manual detection by checking these files:

| Signal File                  | Detects                          |
|------------------------------|----------------------------------|
| `go.mod`                     | Go module (read module name)     |
| `package.json`               | Node.js / frontend project       |
| `requirements.txt` / `pyproject.toml` / `setup.py` | Python project      |
| `Cargo.toml`                 | Rust project                     |
| `pom.xml` / `build.gradle`   | Java / Kotlin project            |
| `Makefile`                   | Build automation                 |
| `.github/workflows/`         | GitHub Actions CI/CD             |
| `.gitlab-ci.yml`             | GitLab CI/CD                     |
| `Dockerfile` / `docker-compose.yml` | Container usage           |
| `jest.config.*` / `vitest.config.*`  | JS test framework         |
| `*_test.go`                  | Go test files                    |
| `pytest.ini` / `conftest.py` | Pytest                           |
| `.eslintrc*` / `biome.json`  | Linter config                    |
| `tsconfig.json`              | TypeScript                       |
| `tailwind.config.*`          | Tailwind CSS                     |
| `next.config.*`              | Next.js                          |
| `.env` / `.env.example`      | Environment config               |

Build a `scan_result` object with these fields:

```json
{
  "language": "go | typescript | javascript | python | rust | java | mixed",
  "framework": "next.js | gin | echo | go-zero | fastapi | express | ...",
  "package_manager": "go mod | npm | pnpm | yarn | pip | poetry | cargo",
  "test_framework": "go test | jest | vitest | pytest | cargo test | ...",
  "test_runner_cmd": "go test ./... | npx vitest | pytest | ...",
  "linter": "golangci-lint | eslint | biome | ruff | ...",
  "ci_cd": "github-actions | gitlab-ci | none",
  "has_docker": true,
  "has_monorepo": false,
  "existing_test_coverage": "unknown | low | medium | high",
  "source_dirs": ["src/", "internal/", "cmd/", "pkg/"],
  "project_name": "my-project"
}
```

Present the scan results to the user in a readable summary before proceeding.

---

## Phase 2 — Interactive Interview

Ask **one pipeline stage at a time**. Use the `AskQuestion` tool when available;
otherwise ask conversationally. After each answer, confirm and move to the next stage.

### Stage 1: Plan (需求分析)

> Based on scan: {language} project using {framework}

Questions:
- Do you want the `autocode` workflow to generate design documents before coding? (Yes / No / Lightweight outline only)
- Where should plans be stored? (docs/plans/ / Notion / GitHub Issues / other)
- Should the planner agent break tasks into sub-issues automatically?

Capture → `config.plan`

### Stage 2: TDD (测试驱动开发)

> Detected test framework: {test_framework}

Questions:
- Do you follow TDD (write tests first)? (Strict TDD / Tests alongside code / Tests after code)
- Minimum test coverage target? (80% / 90% / Custom)
- **Go-specific**: Use `testify` assertions? Use table-driven tests?
- **JS/TS-specific**: Use `vitest` or `jest`? Mock strategy (msw / manual)?
- **Python-specific**: Use `pytest` fixtures? Use `hypothesis` for property testing?

Capture → `config.tdd`

### Stage 3: Code (编码规范)

Questions:
- Max file length (lines)? (200 / 400 / 800 / no limit)
- Preferred error handling pattern? (explicit returns / exceptions / Result type)
- Code style enforcement tool? (detected: {linter}, confirm or change)
- Do you want auto-generated code comments? (No / Critical paths only / All public APIs)

Capture → `config.code`

### Stage 4: Test (单元测试)

Questions:
- Test file location convention? (co-located / separate `__tests__/` / `*_test.go` pattern)
- Integration test strategy? (docker-compose / testcontainers / mock services / none)
- Should the workflow auto-run tests after code changes? (Yes / No)

Capture → `config.test`

### Stage 5: E2E (端到端测试)

Questions:
- Do you need E2E testing? (Yes / No / Future plan)
- If yes: preferred tool? (Playwright / Cypress / none)
- E2E scope? (Critical paths only / Full coverage)
- E2E environment? (local / staging URL / docker-compose)

Capture → `config.e2e`

### Stage 6: CI/CD (持续集成/部署)

> Detected CI: {ci_cd}

Questions:
- Should `autocode` generate/update CI pipeline configs? (Yes / Read-only check / No)
- Deploy target? (Docker / Kubernetes / Serverless / VM / none)
- Pre-merge checks required? (lint + test / lint + test + e2e / custom)

Capture → `config.cicd`

### Final Confirmation

Display the full configuration summary and ask:
> "Does this look correct? Any adjustments before I generate the autocode system?"

---

## Phase 3 — Generate the `autocode` System

Based on the collected `scan_result` + `config`, generate files in the target project.
Read the templates from `<path-to-this-skill>/templates/` and adapt them using the
project context. **Every generated file MUST be project-specific** — no generic placeholders.

### Output Directory Structure

```
<project-root>/
├── .cursor/
│   ├── rules/
│   │   ├── autocode-workflow.mdc       # Master workflow rule
│   │   ├── coding-style.mdc            # Language-specific coding standards
│   │   └── testing.mdc                 # Testing standards & TDD enforcement
│   └── skills/
│       └── autocode/
│           ├── SKILL.md                # Generated autocode skill entry point
│           └── config.json             # Serialized pipeline configuration
├── .claude/
│   ├── commands/
│   │   ├── plan.md                     # /plan command
│   │   ├── code.md                     # /code command
│   │   ├── tdd.md                      # /tdd command
│   │   ├── test.md                     # /test command
│   │   ├── e2e.md                      # /e2e command (if enabled)
│   │   └── deploy.md                   # /deploy command (if enabled)
│   ├── agents/
│   │   ├── planner.md                  # Planning & decomposition agent
│   │   ├── tdd-guide.md               # TDD enforcement agent
│   │   ├── code-reviewer.md           # Code quality review agent
│   │   └── e2e-runner.md              # E2E test agent (if enabled)
│   └── hooks/
│       └── hooks.json                  # Automated hook triggers
└── docs/
    └── autocode/
        └── pipeline.md                 # Human-readable pipeline documentation
```

### Generation Rules

1. **Language binding**: Every template must be filled with the detected language's
   commands, conventions, and tooling. For example:
   - Go: `go test ./... -cover`, `golangci-lint run`, table-driven tests
   - TypeScript: `npx vitest --coverage`, `eslint .`, component testing
   - Python: `pytest --cov`, `ruff check .`, fixture-based tests

2. **Framework binding**: If a framework is detected, include framework-specific patterns.
   For example:
   - go-zero: Handler/Logic/Context architecture, goctl commands
   - Next.js: App Router conventions, server components, API routes
   - FastAPI: Dependency injection, Pydantic models, async patterns

3. **Config serialization**: Write `config.json` with the full interview results so the
   skill can be re-invoked or updated later.

4. **Idempotent generation**: If files already exist, ask the user whether to overwrite,
   merge, or skip each file.

### Template Adaptation Process

For each template file in `templates/`:

1. Read the template
2. Replace all `{{variable}}` placeholders with actual project values
3. Remove any conditional sections that don't apply (e.g., remove E2E sections if disabled)
4. Write the adapted file to the correct location
5. Verify the file is syntactically valid

---

## Post-Generation

After all files are generated:

1. Display a summary of all created files
2. Show the user how to use the new commands:
   ```
   /plan  — Analyze requirements and create a development plan
   /tdd   — Start TDD workflow for a feature
   /test  — Run tests and check coverage
   /e2e   — Run end-to-end tests (if enabled)
   /deploy — Check deployment readiness (if enabled)
   ```
3. Suggest running `/plan` on their next feature to try the workflow

---

## Error Handling

- If scan finds no recognizable project files → ask user to specify language and framework manually
- If user skips an interview stage → use sensible defaults and note them
- If file generation fails → report the error, continue with remaining files, summarize failures at the end
