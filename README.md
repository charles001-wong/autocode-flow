# autocode-flow

A Claude Code plugin that generates **project-specific** automated development pipelines.

Scan your project → answer a few questions → get a complete `autocode` system with agents, commands, rules, and hooks tailored to your exact tech stack.

## What It Does

```
/autocode-new
    │
    ├─ Phase 1: Scan ──── detects language, framework, test tools, CI, linter
    ├─ Phase 2: Interview ── asks your preferences (TDD, coverage, E2E, deploy)
    └─ Phase 3: Generate ─── writes project-specific pipeline files
```

### Generated Output

```
your-project/
├── .cursor/
│   ├── rules/
│   │   ├── autocode-workflow.mdc    # Pipeline discipline
│   │   ├── coding-style.mdc        # Language-specific standards
│   │   └── testing.mdc             # TDD & coverage enforcement
│   └── skills/
│       └── autocode/
│           ├── SKILL.md             # Pipeline entry point
│           └── config.json          # Your pipeline configuration
├── .claude/
│   ├── agents/
│   │   ├── planner.md              # Task decomposition
│   │   ├── tdd-guide.md            # RED→GREEN→REFACTOR
│   │   ├── code-reviewer.md        # Quality & security review
│   │   └── e2e-runner.md           # E2E test management
│   ├── commands/
│   │   ├── plan.md                 # /plan command
│   │   ├── tdd.md                  # /tdd command
│   │   ├── code.md                 # /code command
│   │   ├── test.md                 # /test command
│   │   ├── e2e.md                  # /e2e command (if enabled)
│   │   └── deploy.md              # /deploy command (if enabled)
│   └── hooks/
│       └── hooks.json              # Auto-lint, coverage reminders
└── docs/
    └── autocode/
        └── pipeline.md             # Human-readable pipeline docs
```

## Installation

### Option 1: From GitHub (recommended)

```bash
# Add the marketplace (one-time)
claude plugin marketplace add github:charles001-wong/autocode-flow

# Install the plugin
claude plugin install autocode-flow@autocode-flow
```

### Option 2: From local directory

```bash
# Clone or download to any location
git clone https://github.com/charles001-wong/autocode-flow.git ~/autocode-flow

# Install from local path
claude plugin install --path ~/autocode-flow
```

### Option 3: Manual copy

```bash
# Copy to Claude's plugin cache directly
mkdir -p ~/.claude/plugins/cache/autocode-flow/autocode-flow/1.0.0
cp -r . ~/.claude/plugins/cache/autocode-flow/autocode-flow/1.0.0/
```

Then enable in `~/.claude/settings.json`:
```json
{
  "enabledPlugins": {
    "autocode-flow@autocode-flow": true
  }
}
```

## Usage

Navigate to any project and run:

```
/autocode-new
```

The wizard will:
1. **Scan** your project and show detected tech stack
2. **Interview** you about each pipeline stage (Plan, TDD, Code, Test, E2E, CI/CD)
3. **Generate** all pipeline files customized to your project

After generation, use the pipeline commands:

| Command   | Description                          |
|-----------|--------------------------------------|
| `/plan`   | Analyze requirements, create plan    |
| `/tdd`    | Start TDD cycle (RED→GREEN→REFACTOR)|
| `/code`   | Implement following coding standards |
| `/test`   | Run tests and check coverage         |
| `/e2e`    | Run end-to-end tests (if enabled)    |
| `/deploy` | Check deployment readiness           |

## Supported Tech Stacks

| Language   | Frameworks                    | Test Tools                |
|------------|-------------------------------|---------------------------|
| Go         | go-zero, Gin, Echo, Fiber    | go test, testify          |
| TypeScript | Next.js, Vite, Angular       | vitest, jest, Playwright  |
| JavaScript | Express, React, Vue          | jest, vitest, Cypress     |
| Python     | FastAPI, Django, Flask        | pytest, hypothesis        |
| Rust       | Actix, Axum                  | cargo test                |

## Customization

After generation, you can:
- Edit `config.json` to adjust settings
- Modify individual agent/command/rule files
- Re-run `/autocode-new` to regenerate (with overwrite protection)

## Architecture

```
autocode-flow plugin
├── commands/autocode-new.md     ← Entry point (/autocode-new)
├── agents/
│   ├── autocode-scanner.md      ← Phase 1: detect tech stack
│   ├── autocode-interviewer.md  ← Phase 2: collect preferences
│   └── autocode-generator.md   ← Phase 3: write pipeline files
├── skills/autocode-flow/
│   └── SKILL.md                 ← Full workflow reference
├── templates/                   ← Templates for generated files
├── scripts/scan-project.sh     ← Bash scanner
└── rules/autocode-flow.md      ← Generation quality rules
```

## License

MIT
