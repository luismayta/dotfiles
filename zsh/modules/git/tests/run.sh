#!/usr/bin/env bash
# Test runner for git scripts

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTS_DIR="$SCRIPT_DIR"

echo "Running git scripts tests..."
echo ""

# Find all test files
test_files=("$TESTS_DIR"/*.bats)

if [[ ${#test_files[@]} -eq 0 ]]; then
  echo "No test files found in $TESTS_DIR"
  exit 1
fi

# Run all tests
bats "${test_files[@]}"