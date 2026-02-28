#!/usr/bin/env bash
# scan-project.sh — Detects project tech stack and outputs a JSON report.
# Usage: bash scan-project.sh [project-root]
set -euo pipefail

PROJECT_ROOT="${1:-.}"
cd "$PROJECT_ROOT"

language="unknown"
framework="unknown"
package_manager="unknown"
test_framework="unknown"
test_runner_cmd="unknown"
linter="unknown"
ci_cd="none"
has_docker=false
has_monorepo=false
project_name="$(basename "$(pwd)")"
source_dirs="[]"

# --- Language & Package Manager Detection ---

if [ -f "go.mod" ]; then
  language="go"
  package_manager="go mod"
  test_framework="go test"
  test_runner_cmd="go test ./..."
  module_name=$(head -1 go.mod | awk '{print $2}')
  project_name="${module_name##*/}"

  if [ -f "go.sum" ]; then
    if grep -q "github.com/zeromicro/go-zero" go.sum 2>/dev/null; then
      framework="go-zero"
    elif grep -q "github.com/gin-gonic/gin" go.sum 2>/dev/null; then
      framework="gin"
    elif grep -q "github.com/labstack/echo" go.sum 2>/dev/null; then
      framework="echo"
    elif grep -q "github.com/gofiber/fiber" go.sum 2>/dev/null; then
      framework="fiber"
    elif grep -q "github.com/gorilla/mux" go.sum 2>/dev/null; then
      framework="gorilla-mux"
    fi
  fi

  dirs="[]"
  for d in cmd internal pkg api service; do
    [ -d "$d" ] && dirs=$(echo "$dirs" | sed "s/]/, \"$d\/\"]/" | sed 's/\[, /[/')
  done
  source_dirs="$dirs"
fi

if [ -f "package.json" ]; then
  [ "$language" = "unknown" ] && language="javascript"
  if [ -f "tsconfig.json" ]; then
    language="typescript"
  fi

  if [ -f "pnpm-lock.yaml" ]; then
    package_manager="pnpm"
  elif [ -f "yarn.lock" ]; then
    package_manager="yarn"
  elif [ -f "bun.lockb" ]; then
    package_manager="bun"
  else
    package_manager="npm"
  fi

  if [ -f "next.config.js" ] || [ -f "next.config.mjs" ] || [ -f "next.config.ts" ]; then
    framework="next.js"
  elif [ -f "nuxt.config.ts" ] || [ -f "nuxt.config.js" ]; then
    framework="nuxt"
  elif [ -f "vite.config.ts" ] || [ -f "vite.config.js" ]; then
    framework="vite"
  elif [ -f "angular.json" ]; then
    framework="angular"
  elif [ -f "svelte.config.js" ]; then
    framework="svelte"
  fi

  if [ -f "vitest.config.ts" ] || [ -f "vitest.config.js" ]; then
    test_framework="vitest"
    test_runner_cmd="${package_manager} run test"
  elif [ -f "jest.config.js" ] || [ -f "jest.config.ts" ] || [ -f "jest.config.cjs" ]; then
    test_framework="jest"
    test_runner_cmd="${package_manager} run test"
  fi

  if [ -d "src" ]; then
    source_dirs='["src/"]'
  fi

  name_from_pkg=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' package.json 2>/dev/null | head -1 | sed 's/.*"name"[[:space:]]*:[[:space:]]*"//' | sed 's/"//')
  [ -n "$name_from_pkg" ] && project_name="$name_from_pkg"
fi

if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "setup.cfg" ]; then
  [ "$language" = "unknown" ] && language="python"
  if [ -f "poetry.lock" ]; then
    package_manager="poetry"
  elif [ -f "Pipfile.lock" ]; then
    package_manager="pipenv"
  elif [ -f "uv.lock" ]; then
    package_manager="uv"
  else
    package_manager="pip"
  fi

  if [ -f "pyproject.toml" ]; then
    if grep -q "fastapi" pyproject.toml 2>/dev/null; then
      framework="fastapi"
    elif grep -q "django" pyproject.toml 2>/dev/null; then
      framework="django"
    elif grep -q "flask" pyproject.toml 2>/dev/null; then
      framework="flask"
    fi
  fi

  if [ -f "pytest.ini" ] || [ -f "conftest.py" ] || [ -d "tests" ]; then
    test_framework="pytest"
    test_runner_cmd="pytest"
  fi

  source_dirs='["src/"]'
  [ -d "app" ] && source_dirs='["app/"]'
fi

if [ -f "Cargo.toml" ]; then
  [ "$language" = "unknown" ] && language="rust"
  package_manager="cargo"
  test_framework="cargo test"
  test_runner_cmd="cargo test"
  source_dirs='["src/"]'
fi

# --- Linter Detection ---

if [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] || [ -f ".eslintrc.yml" ] || [ -f "eslint.config.js" ] || [ -f "eslint.config.mjs" ]; then
  linter="eslint"
fi
if [ -f "biome.json" ] || [ -f "biome.jsonc" ]; then
  linter="biome"
fi
if [ -f ".golangci.yml" ] || [ -f ".golangci.yaml" ]; then
  linter="golangci-lint"
fi
if [ -f "ruff.toml" ] || [ -f ".ruff.toml" ]; then
  linter="ruff"
elif [ -f "pyproject.toml" ] && grep -q "ruff" pyproject.toml 2>/dev/null; then
  linter="ruff"
fi

# --- CI/CD Detection ---

if [ -d ".github/workflows" ]; then
  ci_cd="github-actions"
elif [ -f ".gitlab-ci.yml" ]; then
  ci_cd="gitlab-ci"
elif [ -f "Jenkinsfile" ]; then
  ci_cd="jenkins"
elif [ -f ".circleci/config.yml" ]; then
  ci_cd="circleci"
fi

# --- Docker Detection ---

if [ -f "Dockerfile" ] || [ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ] || [ -f "compose.yml" ] || [ -f "compose.yaml" ]; then
  has_docker=true
fi

# --- Monorepo Detection ---

if [ -f "pnpm-workspace.yaml" ] || [ -f "lerna.json" ] || [ -d "packages" ]; then
  has_monorepo=true
fi
if [ -f "go.work" ]; then
  has_monorepo=true
fi

# --- Mixed Language Detection ---

lang_count=0
[ -f "go.mod" ] && lang_count=$((lang_count + 1))
[ -f "package.json" ] && lang_count=$((lang_count + 1))
([ -f "requirements.txt" ] || [ -f "pyproject.toml" ]) && lang_count=$((lang_count + 1))
[ -f "Cargo.toml" ] && lang_count=$((lang_count + 1))
[ "$lang_count" -gt 1 ] && language="mixed"

# --- Output JSON ---

cat <<EOF
{
  "project_name": "${project_name}",
  "language": "${language}",
  "framework": "${framework}",
  "package_manager": "${package_manager}",
  "test_framework": "${test_framework}",
  "test_runner_cmd": "${test_runner_cmd}",
  "linter": "${linter}",
  "ci_cd": "${ci_cd}",
  "has_docker": ${has_docker},
  "has_monorepo": ${has_monorepo},
  "source_dirs": ${source_dirs}
}
EOF
