local function config()
  local cmp = require'cmp'
  cmp.setup {
    mapping = {
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.confirm({ select = true }),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-p>"] = cmp.mapping.select_prev_item()
    },
    sources = {
      { name = "nvim_lsp", keyword_length = 0},
      { name = "nvim_lsp_signature_help" },
      { name = "buffer" },
      { name = "path" },
    }
  }
end

return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-nvim-lsp'
  },
  config = config
}
