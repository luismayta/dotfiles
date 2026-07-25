-- LSP configuration using nvim 0.12's native vim.lsp.config()/vim.lsp.enable()
-- No nvim-lspconfig plugin needed.

-- Keymaps on LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = function(desc)
      return { buffer = ev.buf, desc = "LSP: " .. desc }
    end

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts "Hover documentation")
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts "Workspace symbol")
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts "Line diagnostics")
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts "Previous diagnostic")
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts "Next diagnostic")
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts "Code action")
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts "References")
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts "Rename")
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts "Signature help")

    -- Inlay hints toggle
    vim.keymap.set("n", "<leader>uh", function()
      vim.lsp.inlay_hint.enable(ev.buf, not vim.lsp.inlay_hint.is_enabled(ev.buf))
    end, opts "Toggle inlay hints")
  end,
})

-- Server configurations using vim.lsp.config (nvim 0.12 native)
local servers = {
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_dir = function(bufnr, on_dir)
      local root = vim.fs.root(bufnr, { ".luarc.json", ".luarc.jsonc", ".stylua.toml", ".git" })
      if root then
        on_dir(root)
      end
    end,
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME },
        },
        diagnostics = { globals = { "vim" } },
        completion = { callSnippet = "Replace" },
        hint = { enable = true },
      },
    },
  },
  vtsls = {
    cmd = { "vtsls", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_dir = function(bufnr, on_dir)
      local root = vim.fs.root(bufnr, { "tsconfig.json", "package.json", ".git" })
      if root then
        on_dir(root)
      end
    end,
  },
  gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_dir = function(bufnr, on_dir)
      local root = vim.fs.root(bufnr, { "go.work", "go.mod", ".git" })
      if root then
        on_dir(root)
      end
    end,
    settings = {
      gopls = {
        analyses = { unusedparams = true, shadow = true },
        hints = {
          assignVariablesTypes = true,
          compositeLiteralFields = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
      },
    },
  },
  rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_dir = function(bufnr, on_dir)
      local root = vim.fs.root(bufnr, { "Cargo.toml", ".git" })
      if root then
        on_dir(root)
      end
    end,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = { command = "clippy" },
      },
    },
  },
  pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_dir = function(bufnr, on_dir)
      local root = vim.fs.root(bufnr, { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" })
      if root then
        on_dir(root)
      end
    end,
  },
  yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yml" },
    root_dir = function(bufnr, on_dir)
      local root = vim.fs.root(bufnr, { ".git" })
      if root then
        on_dir(root)
      end
    end,
    settings = {
      yaml = {
        validate = true,
        schemaStore = {
          enable = true,
          url = "https://www.schemastore.org/api/json/catalog.json",
        },
        schemas = {
          ["https://raw.githubusercontent.com/compose-spec/compose-spec/main/compose-spec.json"] = "docker-compose*.{yml,yaml}",
          ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
          ["https://json.schemastore.org/gitlab-ci.json"] = ".gitlab-ci.yml",
        },
      },
    },
  },
  dockerls = {
    cmd = { "docker-langserver", "--stdio" },
    filetypes = { "dockerfile" },
    root_dir = function(bufnr, on_dir)
      local root = vim.fs.root(bufnr, { "Dockerfile", ".dockerignore", ".git" })
      if root then
        on_dir(root)
      end
    end,
  },
  terraformls = {
    cmd = { "terraform-ls", "serve" },
    filetypes = { "tf", "terraform-vars", "hcl" },
    root_dir = function(bufnr, on_dir)
      local root = vim.fs.root(bufnr, { ".terraform", ".git" })
      if root then
        on_dir(root)
      end
    end,
  },
}

-- Get blink.cmp capabilities for LSP completion
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Configure and enable each server
for server, config in pairs(servers) do
  config.capabilities = vim.tbl_deep_extend("force", capabilities, config.capabilities or {})
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

-- Bruno LSP (filetype-based, not in main servers loop)
vim.lsp.config("bruno_ls", {
  cmd = { "bruno-language-server", "--stdio" },
  filetypes = { "bru" },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "bru",
  callback = function()
    vim.lsp.enable "bruno_ls"
  end,
})
