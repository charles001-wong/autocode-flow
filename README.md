# autocode-flow

**One command, fully autonomous development.** Describe a feature, get working tested code.

```
/autocode add user login & registration
```

```
PLAN ──► TDD ──► CODE ──► TEST ──► VERIFY ──► DONE
 (all automatic, zero human intervention)
```

## How It Works

### Step 1: Setup (once per project)

```
/autocode-new
```

Scans your project, asks a few questions, generates a project-specific pipeline config.

### Step 2: Build features (every time)

```
/autocode add user login & registration
/autocode prd @docs/user-auth-prd.md
/autocode Fix the race condition in order processing
```

The pipeline runs **fully automatically**:

| Phase     | What Happens                                         |
|-----------|------------------------------------------------------|
| **PLAN**  | Decomposes requirement into ordered atomic steps     |
| **TDD**   | Writes all test files first (RED phase)              |
| **CODE**  | Implements minimum code per step until GREEN         |
| **TEST**  | Runs full suite, loops until coverage target met     |
| **VERIFY**| Lints, self-reviews, auto-fixes quality issues       |
| **E2E**   | Writes & runs E2E tests (if enabled)                 |
| **DONE**  | Reports results, suggests `git commit`               |

**No human intervention between phases.** It plans, codes, tests, and verifies in one shot.

## Installation

### Option 1: From GitHub

```bash
claude plugin marketplace add github:charles001-wong/autocode-flow
claude plugin install autocode-flow@autocode-flow
```

### Option 2: From local directory

```bash
claude plugin install --path ~/autocode-flow
```

### Option 3: Manual

```bash
mkdir -p ~/.claude/plugins/cache/autocode-flow/autocode-flow/1.0.0
cp -r . ~/.claude/plugins/cache/autocode-flow/autocode-flow/1.0.0/
```

Add to `~/.claude/settings.json`:
```json
{
  "enabledPlugins": {
    "autocode-flow@autocode-flow": true
  }
}
```

## What Gets Generated

After `/autocode-new`, your project gets:

```
your-project/
├── .claude/
│   ├── commands/
│   │   └── autocode.md          ← /autocode <feature> entry point
│   └── agents/
│       ├── planner.md           ← Task decomposition
│       ├── tdd-guide.md         ← Test-first enforcement
│       ├── code-reviewer.md     ← Quality verification
│       └── e2e-runner.md        ← E2E tests (if enabled)
├── .cursor/
│   ├── rules/
│   │   ├── autocode-workflow.mdc
│   │   ├── coding-style.mdc
│   │   └── testing.mdc
│   └── skills/
│       └── autocode/
│           ├── SKILL.md
│           └── config.json      ← Your pipeline settings
└── docs/autocode/pipeline.md
```

All files are **project-specific** — generated with your actual language, framework,
test commands, and linter.

## Supported Stacks

| Language   | Frameworks                    | Test Tools                |
|------------|-------------------------------|---------------------------|
| Go         | go-zero, Gin, Echo, Fiber    | go test, testify          |
| TypeScript | Next.js, Vite, Angular       | vitest, jest, Playwright  |
| JavaScript | Express, React, Vue          | jest, vitest, Cypress     |
| Python     | FastAPI, Django, Flask        | pytest, hypothesis        |
| Rust       | Actix, Axum                  | cargo test                |

## Example: Go + go-zero

```
> /autocode-new
📋 Detected: Go / go-zero / golangci-lint / GitHub Actions
... (answers a few questions) ...
✅ Pipeline generated!

> /autocode 新增用户注册功能

═══ Phase 1: PLAN ═══
  4 steps: model → logic → handler → integration test

═══ Phase 2: TDD ═══
  Writing tests... 12 test cases across 4 files
  Running: go test ./... → FAIL (expected)

═══ Phase 3: CODE ═══
  Step 1/4: user model ✅
  Step 2/4: register logic ✅
  Step 3/4: register handler ✅
  Step 4/4: integration wiring ✅

═══ Phase 4: TEST ═══
  go test ./... → PASS (12/12)
  Coverage: 87% (target: 80%) ✅

═══ Phase 5: VERIFY ═══
  golangci-lint run → clean ✅
  Self-review → no issues ✅

═══════════════════════════════════════
  autocode complete: 用户注册功能
  Tests: 12 cases, Coverage: 87%
  Files: 8 created
  Ready: git add -A && git commit -m "feat: add user registration"
═══════════════════════════════════════
```

## Architecture

```
autocode-flow (plugin)
├── /autocode-new ──── scan → interview → generate config
├── /autocode ──────── load config → plan → tdd → code → test → verify
├── agents/ ────────── scanner, interviewer, generator
├── templates/ ─────── project-specific file templates
└── scripts/ ──────── scan-project.sh (tech stack detection)
```

## License

MIT
