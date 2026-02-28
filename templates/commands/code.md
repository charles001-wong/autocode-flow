# /code — Implement with Standards

Implement a feature or fix following project coding standards.

## Input

$ARGUMENTS — Description of what to implement, or a reference to a plan step.

## Steps

1. Load project config from `.cursor/skills/autocode/config.json`.
2. Read coding standards from `.cursor/rules/coding-style.mdc`.
3. Search for related existing code to understand patterns and conventions.
4. Implement the change following these constraints:
   - Max file length: {{code_max_file_lines}} lines
   - Error handling: {{code_error_handling}} pattern
   - Run linter after changes: `{{lint_cmd}}`
5. If TDD is active, ensure all tests still pass: `{{test_runner_cmd}}`
6. Trigger the `code-reviewer` agent for a self-review before presenting to the user.

## Constraints

- Follow {{language}} idioms and {{framework}} conventions.
- No dead code, no commented-out blocks, no debug statements.
- Every public API must have corresponding tests.
