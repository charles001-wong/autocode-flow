# /plan — Analyze & Decompose

Read the `planner` agent definition from `.claude/agents/planner.md` and follow its workflow.

## Input

$ARGUMENTS — Feature description, bug report, or refactoring goal.

## Steps

1. Load project context from `.cursor/skills/autocode/config.json`.
2. Search the codebase for files related to the request.
3. Create a structured implementation plan following the planner agent's output format.
4. Save the plan to `docs/plans/plan-$(date +%Y%m%d-%H%M).md`.
5. Present the plan to the user and ask for approval before proceeding.

## Constraints

- Plans must include testable acceptance criteria for each step.
- Break large features into increments of ≤ 3 files changed per step.
- Flag any steps that require database migrations or breaking API changes.
