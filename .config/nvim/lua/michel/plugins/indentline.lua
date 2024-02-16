local function config()
  vim.keymap.set("n", '<leader>i', ':IndentLinesToggle<CR>')
end

return {
  'Yggdroot/indentLine',
  config = config
}
