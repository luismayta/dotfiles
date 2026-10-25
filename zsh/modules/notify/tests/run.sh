#!/usr/bin/env bash
# Test runner for the notify module bats suite.
#
# Four anti-vacuous guards, in this order:
#   1. zero *.bats files under the tests dir  -> exit 1 with an explicit message
#   2. bats not on PATH                       -> exit 1 with install hints (never skip)
#   3. zero @test blocks across all files     -> exit 1 (empty .bats files pass plain bats)
#   4. run bats and propagate its exit code   -> no `|| true`, no `set +e`

set -e

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTS_PATH="$SCRIPT_PATH"

echo "Running notify module tests..."
echo ""

# Guard 1: the glob must be able to match nothing, and zero matches must fail.
shopt -s nullglob
test_files=("$TESTS_PATH"/*.bats)
shopt -u nullglob

if [[ ${#test_files[@]} -eq 0 ]]; then
  echo "ERROR: No test files (*.bats) found in $TESTS_PATH" >&2
  exit 1
fi

# Guard 2: bats must be installed — never skip, never fake a pass.
if ! command -v bats >/dev/null 2>&1; then
  echo "ERROR: bats is not installed (not found on PATH)." >&2
  echo "Install it with one of:" >&2
  echo "  apt install bats" >&2
  echo "  brew install bats-core" >&2
  echo "  npm install -g bats" >&2
  echo "  nix-env -iA nixpkgs.bats" >&2
  exit 1
fi

# Guard 3: a .bats file with no @test blocks makes plain bats exit 0
# (zero tests is reported as success) — fail loudly instead. The pattern is
# anchored so a comment merely *mentioning* @test cannot fake a test block.
if ! grep -qE '^[[:space:]]*@test' "${test_files[@]}"; then
  echo "ERROR: No @test blocks found in the ${#test_files[@]} test file(s) under $TESTS_PATH" >&2
  exit 1
fi

# Guard 4: run the suite; bats' exit code becomes this script's exit code.
bats "${test_files[@]}"
