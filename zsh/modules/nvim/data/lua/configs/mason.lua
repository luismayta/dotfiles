local M = {}

M.ui = { border = "rounded" }
M.ensure_installed = {
  -- DevOps / SRE
  "ansible-language-server",
  -- Terraform
  "terraform-ls",
  "tflint",
  -- Docker
  "dockerfile-language-server",
  "hadolint",

  -- Lua
  "lua-language-server",
  "luacheck",
  "luaformatter",
  "stylua",

  -- web dev stuff
  "css-lsp",
  "html-lsp",
  "cssmodules-language-server",
  "typescript-language-server",
  "tailwindcss-language-server",
  "prettier",
  "prettierd",
  "deno",
  "emmet-ls",

  -- JSON
  "fixjson",
  "json-lsp",
  "json-to-struct",

  -- shell
  "shfmt",
  "shellcheck",
  "bash-language-server",

  -- Python
  "black",
  "debugpy",
  "mypy",
  "ruff",
  "pyright",
  "flake8",
  "isort",
  "djlint",

  -- Markdown / Text
  "texlab", -- testing
  "alex",
  "grammarly-languageserver",
  "markdownlint",
  "marksman",
  "proselint",
  "prosemd-lsp",
  "remark-language-server",

  -- solidity
  "solidity",
  "solidity-ls",

  -- rust
  "rust-analyzer",

  -- C++
  "clangd",
  "clang-format",

  -- YAML
  "yaml-language-server",
  "yamllint",

  -- TOML
  "taplo",

  -- latex and md
  "ltex-ls",

  -- Go
  "delve",
  "go-debug-adapter",
  "gofumpt",
  "goimports",
  "goimports-reviser",
  "golangci-lint",
  "golines",
  "gomodifytags",
  "gopls",
  "gotests",
  "impl",
  "revive",
  "staticcheck",

  -- sql

  "sqls",
  "sqlls",
  "sql-formatter",

  -- Additional
  "intelephense",

  -- Others
  "jq",
  "jq-lsp",
  "vls",
  -- vim
  "vim-language-server",
  "vint",
}

return M
