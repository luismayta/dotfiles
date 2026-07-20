[scm]
provider = "github"
flow = "github-flow"

# Examples (derive issue id from branch name)
#
# Jira:
# - Branch: feature/<PROJECTKEY>-123
# - Commit: feat (core): <PROJECTKEY>-123 add mcp docs
#
# GitHub:
# - Branch: feature/123-add-mcp-docs
# - Commit: fix (core): handle missing env var (#123)
# - Optional body: Fixes #123
#
# GitLab:
# - Branch: feature/123-add-mcp-docs
# - Commit: chore (core): bump tooling (#123)
# - Optional body: Closes #123

[monorepo]
enabled = false
tool = ""
markers = ["turbo.json", "pnpm-workspace.yaml", "nx.json"]
domains = ["apps/*", "packages/*", "services/*"]

[source]
extensions = [".ts", ".tsx", ".js", ".jsx", ".mjs", ".cjs", ".py", ".go", ".java", ".rs", ".rb", ".php", ".cs", ".kt", ".swift", ".scala", ".sh"]

[detect]
presets = true
excludes = ["**/*.test.*", "**/*.spec.*", "node_modules/**", "dist/**", "build/**", "target/**", "coverage/**", "venv/**", ".venv/**"]

[issueTracking]
provider = "jira"
projectKey = "AR"

# Optional. If omitted, agents should derive as: ^<projectKey>-[0-9]+$
# keyRegexOverride = "^AR-[0-9]+$"

[issueTracking.branch]
source = "branch"
jiraKeyFromProjectKey = true
jiraKeyRegexOverride = ""
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
