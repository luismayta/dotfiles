#!/usr/bin/env bash
# Test helper functions for git scripts tests

# Create a temporary git repo for testing
setup_git_repo() {
  local test_dir
  test_dir=$(mktemp -d)
  cd "$test_dir" || return 1
  git init
  git config user.email "test@example.com"
  git config user.name "Test User"
  echo "test" > test.txt
  git add .
  git commit -m "Initial commit"
  echo "$test_dir"
}

# Cleanup test repo
cleanup_git_repo() {
  local test_dir="$1"
  if [[ -d "$test_dir" ]]; then
    rm -rf "$test_dir"
  fi
}

# Add remote to test repo
add_test_remote() {
  local test_dir="$1"
  local remote_name="${2:-origin}"
  local remote_url="${3:-/tmp/fake-remote.git}"
  
  cd "$test_dir" || return 1
  git remote add "$remote_name" "$remote_url"
}

# Create a bare remote repo for testing
setup_bare_remote() {
  local remote_dir
  remote_dir=$(mktemp -d)
  git init --bare "$remote_dir"
  echo "$remote_dir"
}

# Get the path to git scripts bin directory
get_scripts_dir() {
  echo "/home/lucho/.dotfiles/zsh/modules/git/bin"
}