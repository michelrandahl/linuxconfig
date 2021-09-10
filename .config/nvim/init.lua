require('plugins')

require'lspconfig'.clojure_lsp.setup{}
--require'lspconfig'.fsautocomplete.setup{on_attach=require'completion'.on_attach}
require'lspconfig'.fsautocomplete.setup{
  -- TODO do these really work?... else remove them...
  ts=2;
  sw=2;
}
require'lspconfig'.purescriptls.setup{}
require'lspconfig'.elmls.setup{}
require'lspconfig'.ghcide.setup{}
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;
  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    treesitter = true;
  };
}

require('telescope').setup{
  defaults = {
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = {
      vertical = { mirror = true },
    },
  }
}

require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '>', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '>', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = false,
  numhl      = true,
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false
    })

require'nvim-treesitter.configs'.setup {
  -- Modules and its options go here
  highlight = { enable = true },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
  ensure_installed = { "bash"
                     , "c"
                     , "c_sharp"
                     , "clojure"
                     , "css"
                     , "dockerfile"
                     , "elm"
                     , "fennel"
                     , "haskell"
                     , "html"
                     , "java"
                     , "javascript"
                     , "json"
                     , "jsonc"
                     , "lua"
                     , "nix"
                     , "python"
                     , "vim"
                     , "yaml" }
}

local let = vim.g
let.mapleader = ' '
let.maplocalleader = '\\'

-- 'Yggdroot/indentLine'
let.indentLine_char_list = {'|', '¦', '┆', '┊'}
let.indentLine_enabled = 0

local set = vim.opt 
set.number = true
set.tabstop = 2
set.shiftwidth = 2
set.expandtab = true
set.cindent = false
set.syntax = 'on'

-- make `vi(` and `%` ignore '\(', as in haskell style lambda (\(x,y) -> ...)
set.cpoptions = set.cpoptions._value .. "M"

-- enable copy paste from vim to the outside world
set.clipboard = 'unnamed,unnamedplus'

-- make it possible to load huge json files and still get folding...
set.maxmempattern=2000000

set.splitbelow = true
set.splitright = true

local nnoremap = function(keyseq, command)
  vim.api.nvim_set_keymap('n', keyseq, command, {noremap = true})
end

local vnoremap = function(keyseq, command)
  vim.api.nvim_set_keymap('v', keyseq, command, {noremap = true})
end

local inoremap = function(keyseq, command)
  vim.api.nvim_set_keymap('i', keyseq, command, {noremap = true})
end

-- autocomplete string quotes and parens
inoremap('"', '""<esc>i')
inoremap("'", "''<esc>i")
inoremap('(', '()<esc>i')
inoremap('[', '[]<esc>i')
inoremap('{', '{}<esc>i')
inoremap('`', '``<esc>i')

-- easier movement between windows
nnoremap('<C-J>', '<C-W><C-J>')
nnoremap('<C-K>', '<C-W><C-K>')
nnoremap('<C-L>', '<C-W><C-L>')
nnoremap('<C-H>', '<C-W><C-H>')

nnoremap('<leader>fh', ':set winfixheight<CR>')

-- remap visual selection to not include leading whitespace when selecting strings...
nnoremap("va'", "v2i'")
nnoremap('va"', 'v2i"')
nnoremap('va`', 'v2i`')

-- Disable triggering of annoying 'Ex mode'
nnoremap('Q','<nop>')

-- more convinient matching parens navigation
nnoremap('<tab>','%')
vnoremap('<tab>','%')

-- 'neovim/nvim-lspconfig'
nnoremap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
nnoremap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
nnoremap('<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
nnoremap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
nnoremap('<localleader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
vnoremap('<localleader>f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>')

-- 'nvim-telescope/telescope.nvim'
nnoremap('<leader>f', '<cmd>Telescope find_files<cr>')
nnoremap('<leader>g', '<cmd>Telescope live_grep<cr>')
nnoremap('<leader>b', '<cmd>Telescope buffers<cr>')

-- 'hrsh7th/nvim-compe'
--inoremap('<silent><expr> <C-Space>', 'compe#complete()')

-- 'preservim/nerdtree'
nnoremap('<C-n>', ':NERDTreeToggle<CR>')

-- 'rhysd/git-messenger.vim'
nnoremap('<leader>gm', ':GitMessenger<CR>')

-- 'Yggdroot/indentLine'
nnoremap('<leader>i', ':IndentLinesToggle<CR>')

let.jsonpath_register = '*'
vim.cmd [[
  au FileType json setl foldmethod=expr
  au FileType json setl foldexpr=nvim_treesitter#foldexpr()
  au FileType json noremap <buffer> <silent> <leader>d :call jsonpath#echo()<CR>
  au FileType json noremap <buffer> <silent> <leader>g :call jsonpath#goto()<CR>
]]

-- keep terminal buffers open in background
vim.cmd [[
  augroup custom_term
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber bufhidden=hide
  augroup END
]]

let.nd_themes = { {'sunrise+1/3', 'github', 'light' }
                , {'sunset+0', 'gruvbox', 'dark' } }
let.nd_latitude = 55

_G.switch_colorscheme = function()
  if(vim.g.colors_name == "gruvbox") then
    set.background = 'light'
    vim.cmd('colorscheme github')
  else
    set.background = 'dark'
    vim.cmd('colorscheme gruvbox')
  end
end
nnoremap('<leader>c', '<cmd>lua switch_colorscheme()<CR>')
