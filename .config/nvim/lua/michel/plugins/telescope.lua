local function config()
  local telescope = require('telescope')
  telescope.setup{
    defaults = {
      sorting_strategy = "ascending",
      layout_strategy = "vertical",
      layout_config = {
        vertical = { mirror = true },
      },
    }
  }

  local telescope_builtin = require('telescope.builtin')
  vim.keymap.set("n", '<leader>f', telescope_builtin.find_files, {})
  vim.keymap.set("n", '<leader>gg', telescope_builtin.live_grep, {})
  vim.keymap.set("n", '<leader>b', telescope_builtin.buffers, {})

  vim.keymap.set("n", '<leader>d', telescope_builtin.lsp_document_symbols, {})
  vim.keymap.set("n", '<leader>q', telescope_builtin.lsp_dynamic_workspace_symbols, {})
  vim.keymap.set("n", '<leader>l', telescope_builtin.git_commits, {})
end

return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = config
}
