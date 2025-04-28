require("michel.custom.align")
require("michel.custom.cycle_conceal")
require("michel.custom.autocenter")
require("michel.custom.hover_handling.core")
require("michel.custom.layout_mgmt")

-- Set Neovim's shell to use the Bash shell provided by NixOS at a stable path.
-- This ensures consistent behavior and compatibility when running commands or
-- using the :terminal within Neovim, especially important in Nix develop environments
-- where the default shell path might not align with Nix's environment isolation,
-- potentially resolving issues related to command execution or terminal rendering.
vim.o.shell = "/run/current-system/sw/bin/bash"

vim.o.winborder = 'single'

-- keep terminal buffers open in background
vim.cmd [[
  augroup custom_term
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber bufhidden=hide
  augroup END
]]

vim.g.mapleader = " "
vim.g.maplocalleader = ";"

vim.opt.cursorline = true
vim.opt.cursorcolumn = true

vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.cindent = false
vim.opt.syntax = 'on'
-- enable copy paste from vim to the outside world
vim.opt.clipboard = 'unnamed,unnamedplus'

-- make `vi(` and `%` treat '\(' as normal '(', as in haskell style lambda (\(x,y) -> ...)
-- if this flag is not set, then vim will treat it as escaped '(' and ignore them
vim.opt.cpoptions = vim.opt.cpoptions._value .. "M"

-- make it possible to load huge json files and still get folding...
vim.opt.maxmempattern = 2000000

-- Enable folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

vim.opt.conceallevel = 0 --if not set, quotes will be hidden in json files
vim.opt.splitbelow = true
vim.opt.splitright = true

-- don't show inline warning and error messages
vim.diagnostic.config({virtual_text = false})

-- Automatically create directories when saving a file in a directory that does not exist yet.
-- (especially useful when working with Neorg)
--vim.api.nvim_create_autocmd("BufWritePre", {
--  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
--  callback = function(event)
--    local file = vim.loop.fs_realpath(event.match) or event.match
--    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
--  end
--})
