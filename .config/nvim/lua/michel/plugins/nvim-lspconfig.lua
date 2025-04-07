-- File: lua/michel/plugins/nvim-lspconfig.lua

local on_attach = function(client, bufnr)
  local telescope_builtin = require('telescope.builtin')
  
  -- Keep your custom telescope keybindings
  vim.keymap.set("n", 'gr', function() telescope_builtin.lsp_references() end, { buffer = bufnr })
  vim.keymap.set("n", '<leader>d', telescope_builtin.lsp_document_symbols, { buffer = bufnr })
  vim.keymap.set("n", '<leader>q', telescope_builtin.lsp_dynamic_workspace_symbols, { buffer = bufnr })
    
  -- Add custom bindings that aren't covered by defaults
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { buffer = bufnr })
  vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, { buffer = bufnr })
  vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, { buffer = bufnr })
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { buffer = bufnr })
    
  -- Use the new format() function for formatting
  vim.keymap.set("n", '<localleader>f', function() vim.lsp.buf.format() end, { buffer = bufnr })
  vim.keymap.set("v", '<localleader>f', function() vim.lsp.buf.range_formatting() end, opts)
  vim.keymap.set("n", '<localleader>a', vim.lsp.buf.code_action, keymap_opts)

  
  -- Enable built-in autocompletion
  if client:supports_method('textDocument/completion') then
    vim.lsp.completion.enable(true, client.id, bufnr, { 
      autotrigger = true,
    })
    -- Simpler keybinding for omnifunc completion
    --vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { buffer = bufnr })
    --vim.keymap.set("i", "<C-j>", "<C-x><C-o>", { buffer = bufnr })

    vim.keymap.set("i", "<C-j>", function()
      if vim.fn.pumvisible() == 1 then
        return "<C-n>"  -- Navigate to next item if completion menu is visible
      else
        return "<C-x><C-o>"  -- Trigger completion if menu isn't visible
      end
    end, { buffer = bufnr, expr = true })

  end
end

-- Define capabilities - START WITH DEFAULT CAPABILITIES
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Only modify the snippet support
capabilities.textDocument.completion.completionItem.snippetSupport = false

local function config()
  -- Configure diagnostics
  vim.diagnostic.config({
    virtual_lines = true,
    virtual_text = false,
    signs = true,
    underline = true,
    severity_sort = true,
    update_in_insert = false,
  })

  -- Set the border for floating windows
  vim.o.winborder = 'rounded'

  -- Make sure neoconf loads BEFORE lspconfig
  require("neoconf").setup({
    import = {
      vscode = false,
      coc = false,
      nlsp = false,
    },
  })

  -- Use the traditional lspconfig approach
  local lspconfig = require('lspconfig')
  
  -- Set up rust-analyzer with capabilities
  if vim.fn.executable("rust-analyzer") == 1 then
    lspconfig.rust_analyzer.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            runBuildScripts = false,
          },
          checkOnSave = {
            enable = true,
          },
          procMacro = {
            enable = true
          }
        }
      }
    })
  end

  -- Set up other language servers
  if vim.fn.executable("clojure-lsp") == 1 then
    lspconfig.clojure_lsp.setup({ 
      on_attach = on_attach,
      capabilities = capabilities 
    })
  end

  if vim.fn.executable("purescript-language-server") == 1 then
    lspconfig.purescriptls.setup({ 
      on_attach = on_attach,
      capabilities = capabilities 
    })
  end

  if vim.fn.executable("elm-language-server") == 1 then
    lspconfig.elmls.setup({ 
      on_attach = on_attach,
      capabilities = capabilities 
    })
  end

  if vim.fn.executable("ghcide") == 1 then
    lspconfig.haskell.setup({ 
      on_attach = on_attach,
      capabilities = capabilities 
    })
  end

  if vim.fn.executable("pyright-langserver") == 1 then
    lspconfig.pyright.setup({ 
      on_attach = on_attach,
      capabilities = capabilities 
    })
  end
  
  -- Register the LspAttach event handler
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      on_attach(client, ev.buf)
    end,
  })
end

return {
  'neovim/nvim-lspconfig',
  dependencies = { 'nvim-telescope/telescope.nvim', 'folke/neoconf.nvim' },
  config = config
}
