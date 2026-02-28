# /deploy — Deployment Readiness Check

Verify the project is ready for deployment.

## Steps

1. Run pre-deploy checklist:
   - [ ] All tests pass: `go test ./...`
   - [ ] Linter clean: `golangci-lint run`
   - [ ] No uncommitted changes: `git status --porcelain`
   - [ ] Branch is up to date with main
2. Check Docker build: `docker build -t order-service:test .`
3. Report readiness:
   - ✅ All checks pass → ready to deploy
   - ❌ Checks failed → list failures and suggest fixes

## Constraints

- NEVER auto-deploy to production without explicit user confirmation.
- Deploy target: Docker
- Required checks: lint + test
