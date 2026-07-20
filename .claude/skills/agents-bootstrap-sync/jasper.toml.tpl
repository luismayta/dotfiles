[scm]
provider = "auto"
flow = "auto"

# Examples (derive issue id from branch name)
#
# Jira:
# - Branch: feature/<PROJECTKEY>-123
# - Commit: ✨ feat(core): <PROJECTKEY>-123 add mcp docs
#
# GitHub:
# - Branch: feature/123-add-mcp-docs
# - Commit: fix 🐛 (core): handle missing env var (#123)
# - Optional body: Fixes #123
#
# GitLab:
# - Branch: feature/123-add-mcp-docs
# - Commit: chore 🧹 (core): bump tooling (#123)
# - Optional body: Closes #123

[issueTracking]
provider = "jira"
projectKey = "AR"

# Optional. If omitted, agents should derive as: ^<projectKey>-[0-9]+$
# keyRegexOverride = "^AR-[0-9]+$"

[issueTracking.branch]
# Source for deriving the issue id/key. Agents should use the current git branch name.
# Example command: git rev-parse --abbrev-ref HEAD
source = "branch"

# Jira: extract the first Jira key found in the branch name.
# This must be derived dynamically from `[issueTracking].projectKey`.
# If you need a custom pattern, set `jiraKeyRegexOverride`.
jiraKeyFromProjectKey = true
jiraKeyRegexOverride = ""

# GitHub/GitLab: extract the first issue number found in the branch name.
# Recommended branch patterns:
# - feature/123-short-desc
# - bugfix/123-short-desc
githubIssueNumberRegex = "(?:^|/)([0-9]+)(?:-|$)"
gitlabIssueNumberRegex = "(?:^|/)([0-9]+)(?:-|$)"

[commit]
tool = "goji"
format = "<type> <emoji> (<scope>): <subject>"
style = "jira"
signoff = true
subjectMaxLength = 100

[commit.providers.github]
issueRegex = "\\(#[0-9]+\\)$"
closingBodyLine = "Fixes #<number>"

[commit.providers.gitlab]
issueRegex = "\\(#[0-9]+\\)$"
closingBodyLine = "Closes #<number>"

[commit.providers.jira]
# Optional. If omitted, agents should derive as: ^<projectKey>-[0-9]+$
# keyRegexOverride = "^AR-[0-9]+$"
