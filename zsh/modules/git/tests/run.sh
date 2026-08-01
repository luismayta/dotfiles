#!/usr/bin/env bash
# Test runner for git scripts

set -e

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTS_PATH="$SCRIPT_PATH"

echo "Running git scripts tests..."
echo ""

# Find all test files
test_files=("$TESTS_PATH"/*.bats)

if [[ ${#test_files[@]} -eq 0 ]]; then
  echo "No test files found in $TESTS_PATH"
  exit 1
fi

# Run all tests
bats "${test_files[@]}"