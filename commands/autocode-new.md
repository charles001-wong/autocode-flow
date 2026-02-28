---
description: Scan current project and generate a project-specific autocode development pipeline (agents, commands, rules, hooks). Interactive setup wizard.
---

# /autocode-flow:autocode-new — Generate Project-Specific Dev Pipeline

This command bootstraps a complete `autocode` development pipeline for the current project
through a 3-phase workflow: **Scan → Interview → Generate**.

## Execution Flow

### Step 1: Scan the Project

Run the scanner to detect the project's tech stack:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/scan-project.sh" "$(pwd)"
```

Parse the JSON output and present a summary to the user:

```
📋 Project Scan Results
━━━━━━━━━━━━━━━━━━━━━━
  Project:    {project_name}
  Language:   {language}
  Framework:  {framework}
  Pkg Mgr:    {package_manager}
  Tests:      {test_framework}
  Linter:     {linter}
  CI/CD:      {ci_cd}
  Docker:     {has_docker}
```

Ask: "Does this look correct? Any corrections before we proceed?"

### Step 2: Interview — Collect Pipeline Preferences

Walk through each stage **one at a time**. Use the collected scan data to provide
smart defaults. For each stage, present the question, wait for an answer, confirm,
then move to the next.

**Stage order**: Plan → TDD → Code → Test → E2E → CI/CD

Read the `autocode-interviewer` agent at `${CLAUDE_PLUGIN_ROOT}/agents/autocode-interviewer.md`
for the detailed question set per stage.

### Step 3: Generate the autocode System

Read the `autocode-generator` agent at `${CLAUDE_PLUGIN_ROOT}/agents/autocode-generator.md`
and follow its workflow.

For each file to generate:
1. Read the corresponding template from `${CLAUDE_PLUGIN_ROOT}/templates/`
2. Replace `{{variables}}` with project-specific values
3. Remove conditional sections that don't apply
4. Write the file to the correct path in the user's project
5. If the file already exists, ask user: overwrite / merge / skip

### Step 4: Summary

After generation, display:
1. List of all created files
2. Available commands: `/plan`, `/tdd`, `/code`, `/test`, `/e2e`, `/deploy`
3. Suggest: "Try `/plan <your next feature>` to test the pipeline!"

## Important

- ALWAYS present scan results before interviewing
- ALWAYS ask ONE stage at a time during the interview
- ALWAYS confirm the full config before generating
- NEVER overwrite existing files without asking
