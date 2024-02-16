require("michel.core.align")
require("michel.core.autocenter")

-- Set Neovim's shell to use the Bash shell provided by NixOS at a stable path.
-- This ensures consistent behavior and compatibility when running commands or
-- using the :terminal within Neovim, especially important in Nix develop environments
-- where the default shell path might not align with Nix's environment isolation,
-- potentially resolving issues related to command execution or terminal rendering.
vim.o.shell = "/run/current-system/sw/bin/bash"

-- keep terminal buffers open in background
vim.cmd [[
  augroup custom_term
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber bufhidden=hide
  augroup END
]]

vim.g.mapleader = " "
vim.g.maplocalleader = ","

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

vim.opt.conceallevel = 0 --if not set, quotes will be hidden in json files
vim.opt.splitbelow = true
vim.opt.splitright = true
