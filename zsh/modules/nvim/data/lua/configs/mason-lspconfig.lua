local M = {}

M.ensure_installed = {
  -- DevOps / SRE
  "ansiblels",
  -- Terraform
  "terraformls",
  "tflint",
  -- Docker
  "dockerls",

  -- web dev stuff
  -- "denols",

  -- shell
  "bashls",

  -- Python
  "ruff",
  "pyright",

  -- Markdown / Text
  "texlab", -- testing
  "marksman",

  -- solidity
  "solidity",

  -- C++
  "clangd",

  -- TOML
  "taplo",

  -- Go
  "gopls",

  -- sql

  "sqls",
  "sqlls",

  -- Additional
  "intelephense",

  -- Others
  "vls",
}

return M