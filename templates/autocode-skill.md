---
name: autocode
description: >
  Autonomous development pipeline for {{project_name}}.
  Run "/autocode <feature description>" to auto-execute the full
  plan → tdd → code → test → verify pipeline. No human intervention needed.
version: 1.0.0
generated_by: autocode-flow
---

# autocode — {{project_name}}

Run `/autocode <what you want to build>` and the entire pipeline executes automatically.

## Usage

```
/autocode 新增用户登录注册功能
/autocode prd @docs/feature-x.md
/autocode Fix the N+1 query in order listing
```

## What Happens

```
PLAN ──► TDD ──► CODE ──► TEST ──► VERIFY{{#if e2e_enabled}} ──► E2E{{/if}} ──► DONE
```

1. **PLAN** — Decomposes your requirement into atomic steps
2. **TDD** — Writes all test files first (RED phase)
3. **CODE** — Implements minimum code per step until tests pass (GREEN)
4. **TEST** — Runs full suite, ensures {{coverage_target}}% coverage
5. **VERIFY** — Lints, self-reviews, fixes quality issues
{{#if e2e_enabled}}6. **E2E** — Writes and runs end-to-end tests{{/if}}
7. **SUMMARY** — Reports results, suggests commit

## Project Config

| Property         | Value                        |
|------------------|------------------------------|
| Language         | {{language}}                 |
| Framework        | {{framework}}                |
| Test runner      | `{{test_runner_cmd}}`        |
| Coverage cmd     | `{{coverage_cmd}}`           |
| Coverage target  | {{coverage_target}}%         |
| Linter           | `{{lint_cmd}}`               |

Full config: [config.json](config.json)
