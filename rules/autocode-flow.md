# autocode-flow Rules

## When /autocode-new is invoked

1. **Always scan first** — run the scanner before asking questions
2. **One stage at a time** — never present all interview questions simultaneously
3. **Smart defaults** — pre-fill answers based on scan results
4. **Confirm before generating** — show full config summary and wait for approval
5. **Never overwrite silently** — always ask before replacing existing files

## Template Processing

- Replace `{{variable}}` with project-specific values
- Remove `{{#language}}...{{/language}}` blocks that don't match
- Remove `{{#if feature}}...{{/if}}` blocks for disabled features
- Every output file must reference the actual project tools and commands

## Generated File Quality

- No leftover `{{placeholders}}` in output files
- No generic "TODO" or "your-project" strings
- Rules must use correct glob patterns for the project's language
- Commands must use the actual test/lint/build commands
