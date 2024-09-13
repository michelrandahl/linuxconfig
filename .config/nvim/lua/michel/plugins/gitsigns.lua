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
  }
end

return {
  'lewis6991/gitsigns.nvim',
  dependencies = { "nvim-lua/plenary.nvim" },
  config = config
}
