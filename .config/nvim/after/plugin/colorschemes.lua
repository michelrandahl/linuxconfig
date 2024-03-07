vim.opt.termguicolors = true

vim.cmd [[
  hi Normal guibg=NONE ctermbg=NONE
  hi NonText guibg=NONE ctermbg=NONE
]]

vim.opt.background = "dark"
vim.cmd('colorscheme monokai-nightasty')

_G.switch_colorscheme = function()
  if(vim.opt.background._value == "dark") then
    vim.opt.background = "light"
    vim.cmd('colorscheme daylight')
  else
    vim.opt.background = "dark"
    vim.cmd([[colorscheme monokai-nightasty]])
  end
end
vim.keymap.set("n", '<leader>c', switch_colorscheme, {})
