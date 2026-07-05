# shellcheck shell=bash
ZSH_NODEJS_ENABLED="${ZSH_NODEJS_ENABLED:-true}"
export NODEJS_TOOL_NAME=fnm
export BUN_PATH="${HOME}/.bun"
export FNM_PATH="${HOME}/.local/share/fnm"
export NODEJS_VERSIONS=(
  24.11.1
)
export FNM_VERSION="${JASPER_FNM_VERSION:-0.39.5}"
export NODEJS_VERSION_GLOBAL=24.11.1
export NODEJS_PACKAGES=(
    npm
    pnpm
    pake-cli
    prettier
    localtunnel
    typescript
    next
    webpack
    standardx
    javascript-typescript-langserver
    typescript-language-server
    npm-check-updates
    js-to-ts-converter
    @compare/github
    codesandbox
    commitizen
    @compare/github
    get-graphql-schema
    surge
    markdown-link-check
    nativefier
    @vscode/vsce
    vercel
    turbo
    @changesets/cli
    @fission-ai/openspec@latest
)

export FNM_INSTALL_URL="https://fnm.vercel.app/install"

export BUN_INSTALL="${HOME}/.bun"