## ADDED Requirements

### Requirement: Issue and PR workflow management
The Issues module SHALL provide issue creation, PR management, and provider abstraction (GitHub/GitLab) with git workflow detection.

#### Scenario: Module loads on zsh start
- **WHEN** zsh starts and sources `zsh/modules/issues/plugin.zsh`
- **THEN** the module SHALL set `ISSUES_PATH` and SHALL source `config/main.zsh`, `internal/main.zsh`, `provider/main.zsh`, `workflow/main.zsh`, and `pkg/main.zsh`
- **THEN** the module SHALL define `__ZSH_ISSUES_LOADED=1` to prevent double-loading

#### Scenario: Environment variables are set
- **WHEN** the module loads
- **THEN** `ISSUES_PACKAGE_NAME` SHALL be `issues`
- **AND** `ISSUES_RESOURCES_PATH` SHALL be `$ISSUES_PATH/resources`
- **AND** `ISSUES_TEMPLATES_PATH` SHALL be derived from `$ISSUES_RESOURCES_PATH`

#### Scenario: git remote detection
- **WHEN** the module loads in a git repository
- **THEN** `GIT_REMOTE` SHALL be detected from `git remote get-url origin`
- **AND** the provider (github/gitlab) SHALL be determined from the remote URL

#### Scenario: chpwd hook
- **WHEN** the current working directory changes
- **THEN** `issues::provider::factory` SHALL be triggered via chpwd hook
- **AND** SHALL re-detect the git provider based on the new directory's remote

#### Scenario: Issue dispatcher
- **WHEN** user runs `issues` with no arguments
- **THEN** the module SHALL present an fzf list of available issues
- **WHEN** user runs `issues create`
- **THEN** the module SHALL create a new issue using the detected provider (gh or glab)

#### Scenario: Task creation
- **WHEN** user runs `issues::task::create`
- **THEN** the module SHALL create a new issue with type detection
- **WHEN** user runs `issues::task::feat`
- **THEN** the module SHALL create a feature issue
- **WHEN** user runs `issues::task::fix`
- **THEN** the module SHALL create a bug fix issue
- **WHEN** user runs `issues::task::perf`
- **THEN** the module SHALL create a performance issue
- **WHEN** user runs `issues::task::docs`
- **THEN** the module SHALL create a documentation issue
- **WHEN** user runs `issues::task::refactor`
- **THEN** the module SHALL create a refactor issue
- **WHEN** user runs `issues::task::chore`
- **THEN** the module SHALL create a chore issue

#### Scenario: Provider detection
- **WHEN** the remote URL contains `github.com`
- **THEN** the module SHALL source `provider/github.zsh` and use `gh` CLI
- **WHEN** the remote URL contains `gitlab.com` or a GitLab instance
- **THEN** the module SHALL source `provider/gitlab.zsh` and use `glab` CLI

#### Scenario: PR creation
- **WHEN** user runs `issues::pr` or uses the `pullrequest` alias
- **THEN** the module SHALL create a pull request using the detected provider

#### Scenario: PR body generation
- **WHEN** generating a PR body
- **THEN** the module SHALL use `issues::pr::body` to format git log output into a markdown PR template

#### Scenario: PR branch base detection
- **WHEN** using githubflow workflow
- **THEN** `issues::pr::branch::base` SHALL return `main`
- **WHEN** using gitflow workflow
- **THEN** `issues::pr::branch::base` SHALL return `develop` or `master` based on branch kind

#### Scenario: Workflow detection
- **WHEN** the module loads
- **THEN** it SHALL detect the git workflow (githubflow or gitflow) from git config or branch conventions

#### Scenario: Issue search
- **WHEN** user runs `issues::search`
- **THEN** the module SHALL present an fzf list of issues from the detected provider

#### Scenario: PR reviews
- **WHEN** user runs `issues::pr::reviews`
- **THEN** the module SHALL list pending PR reviews

#### Scenario: Dependency check
- **WHEN** the module loads
- **THEN** it SHALL ensure `rsync`, `gh` (or `glab`), `less`, and `fzf` are installed

#### Scenario: Resources directory exists
- **WHEN** the module loads
- **THEN** `$ISSUES_RESOURCES_PATH/github/templates/` SHALL contain `ISSUE_TEMPLATE.md` and `PULL_REQUEST_TEMPLATE.md`
- **AND** `$ISSUES_RESOURCES_PATH/gitlab/templates/` SHALL contain `MERGE_REQUEST_TEMPLATE.md`