return {
  'purescript-contrib/purescript-vim',
  init = function()
    vim.g.purescript_disable_indent = 1
    vim.g.purescript_unicode_conceal_enable = 0

    -- following is required for Telescope to properly show syntax highlighting
    vim.filetype.add({
      extension = {
        purs = "purescript",
      },
    })
  end
}
