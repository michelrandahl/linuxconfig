
local on_attach = function(client, bufnr)
  local telescope_builtin = require('telescope.builtin')
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  -- goto declaration is for example relevant in Rust if you want to navigate to the trait definition of a function
  vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
  vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", 'gi', function() vim.lsp.buf.implementation() end, opts)
  vim.keymap.set("n", 'gr', function() telescope_builtin.lsp_references() end, opts)
  vim.keymap.set("n", '<leader>rn', function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", '<localleader>f', function() vim.lsp.buf.formatting() end, opts)
  vim.keymap.set("v", '<localleader>f', function() vim.lsp.buf.range_formatting() end, opts)
  vim.keymap.set("n", '<localleader>a', vim.lsp.buf.code_action, keymap_opts)
end

local function config()
  local config = require'lspconfig'

  config.clojure_lsp.setup{ on_attach = on_attach }

  config.elmls.setup{ on_attach = on_attach }

  config.ghcide.setup{ on_attach = on_attach }

  config.purescriptls.setup{
    on_attach = on_attach,
  }

  --config.tsserver.setup { on_attach = on_attach, compilerOptions = { checkJs = true }, filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript" } }

  config.rust_analyzer.setup{
    on_attach = on_attach,
    cmd = { "rust-analyzer" }
  }

  -- Python LSP configuration
  -- config.pyright.setup{}
  config.pyright.setup{
    on_attach = on_attach,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
        },
        pythonPath = ".venv/bin/python",
      },
    },
  }
end

return {
  'neovim/nvim-lspconfig',
  dependencies = { 'nvim-telescope/telescope.nvim', 'folke/neoconf.nvim' },
  config = config
}
