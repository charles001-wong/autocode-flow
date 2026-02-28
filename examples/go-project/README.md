# Example Output: Go + go-zero Project

This directory shows what `autocode-flow` generates for a Go project using
the go-zero framework. It demonstrates the complete file tree with all
placeholders resolved to concrete, project-specific values.

## Assumed Scan Result

```json
{
  "project_name": "order-service",
  "language": "go",
  "framework": "go-zero",
  "package_manager": "go mod",
  "test_framework": "go test",
  "test_runner_cmd": "go test ./...",
  "linter": "golangci-lint",
  "ci_cd": "github-actions",
  "has_docker": true,
  "has_monorepo": false,
  "source_dirs": ["cmd/", "internal/", "pkg/"]
}
```

## Assumed Interview Answers

- Plan: Yes, lightweight outlines in `docs/plans/`
- TDD: Strict TDD, 80% coverage, table-driven tests, testify
- Code: 400 lines max, explicit error returns, golangci-lint
- Test: Co-located `*_test.go`, testcontainers for integration
- E2E: Not needed
- CI/CD: Read-only check, Docker deploy, lint + test pre-merge
