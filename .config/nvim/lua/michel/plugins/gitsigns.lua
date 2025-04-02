local function config()
  require('gitsigns').setup {
    signs = {
      add          = { text = '>' },
      change       = { text = '>' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
    },
    signcolumn = false,
    numhl      = true,
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      -- View current line diff
      vim.keymap.set('n', '<leader>gd', gs.preview_hunk, {buffer=bufnr})
    end
  }
end

return {
  'lewis6991/gitsigns.nvim',
  dependencies = { "nvim-lua/plenary.nvim" },
  config = config
}
