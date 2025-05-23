local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "michel.plugins" },

  -- CSV plugin
  -- to arrange, visually select everything and run the command `:CSVArrangeColumn`
  -- to delete a column run the command `:DeleteColumn`
  'chrisbra/csv.vim',

  'michelrandahl/simple-vim-surround',
}, {
  change_detection = {
    enabled = false, -- or false if you want to fully disable watching
    notify = false, -- this disables the annoying popups
  }
})
