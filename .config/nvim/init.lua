require('plugins')

local let = vim.g

require'lspconfig'.tsserver.setup {
    compilerOptions = { checkJs = false },
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" }
}
require'lspconfig'.clojure_lsp.setup{}
-- require'lspconfig'.fsautocomplete.setup{
--   -- TODO do these really work?... else remove them...
--   ts=2;
--   sw=2;
-- }

--require'lspconfig'.fsautocomplete.setup{
--  settings = {
--    FSharp = {
--      RecordStubGeneration = true;
--    };
--  };
--}
  --"fsautocomplete", "--background-service-enabled"
  --"fsautocomplete", "--adaptive-lsp-server-enabled", "-v", " --log-file", "~/fsauto.log"
require'lspconfig'.fsautocomplete.setup{
  cmd = { "fsautocomplete", "--adaptive-lsp-server-enabled" }
}
  --fsautocomplete_command = {"fsautocomplete", "--background-service-enabled"}
--require'ionide'.setup{
--  fsautocomplete_command = {"fsautocomplete", "--adaptive-lsp-server-enabled", "--debug"},
--  cmd = { "fsautocomplete", "--adaptive-lsp-server-enabled" }
--}
--vim.cmd [[
--  let g:fsharp#lsp_codelens = 0
-- 
--]]
 --let g:fsharp#fsautocomplete_command = ['fsautocomplete', '--adaptive-lsp-server-enabled']
--vim.cmd [[
--let g:fsharp#fsautocomplete_command =
--    \ [ 'dotnet',
--    \   'fsautocomplete',
--    \   '--background-service-enabled'
--    \ ]
--]]

--vim.cmd [[
--  let g:fsharp#lsp_recommended_colorscheme = 0
--  let g:fsharp#lsp_codelens = 0
--  let g:fsharp#backend = "disable"
--]]

require'lspconfig'.omnisharp.setup {
  cmd = { "dotnet", "/nix/store/jn0dqn562xxxh0v4c6k6c5g9xr0b6zp5-omnisharp-roslyn-1.39.4/lib/omnisharp-roslyn/OmniSharp.dll" }
	--cmd = { "omnisharp", "--languageserver" , "--hostPID", tostring(pid) },
	--cmd = { "OmniSharp", "--languageserver" , "--hostPID", tostring(pid) },
  --enable_roslyn_analyzers = true,
  --enable_import_completion = true,
  --enable_ms_build_load_projects_on_demand = true,
}
-- let g:OmniSharp_popup_mappings = {
-- \ 'sigNext': '<C-n>',
-- \ 'sigPrev': '<C-p>',
-- \ 'lineDown': ['<C-e>', 'j'],
-- \ 'lineUp': ['<C-y>', 'k']
-- \}
-- vim.cmd [[
--   let g:OmniSharp_popup_mappings = {
--   \ 'sigNext': '<C-n>',
--   \ 'sigPrev': '<C-p>',
--   \ 'lineDown': ['<C-e>', 'j'],
--   \ 'lineUp': ['<C-y>', 'k']
--   \}
-- ]]

require'lspconfig'.purescriptls.setup{}
require'lspconfig'.elmls.setup{}
require'lspconfig'.ghcide.setup{}
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
    { name = "nvim_lsp", keyword_length = 1},
    { name = "nvim_lsp_signature_help" },
    { name = "buffer" },
    { name = "path" }
  }
}
--[[
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
--]]
--require('lspsaga').init_lsp_saga({})



local telescope = require('telescope')
local telescopeConfig = require("telescope.config")
--
-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup{
  defaults = {
    vimgrep_arguments = vimgrep_arguments,
    -- pseudo transparency
    -- winblend = 20;
    -- borderchars = {
    --   prompt = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
    --   results = {' ', '▐', '▄', '▌', '▌', '▐', '▟', '▙' };
    --   preview = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
    -- };
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = {
      vertical = { mirror = true },
    },
  },
  pickers = {
    find_files = {
      find_command = {'rg', '--files', '--hidden', '--glob', '!**/.git/*'}
    }
  }
}
--telescope.load_extension("git_worktree")
--require("telescope").load_extension("git_worktree")

--require("git-worktree").setup({})

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
                     --, "c_sharp"
                     , "clojure"
                     , "css"
                     , "dockerfile"
                     , "elixir"
                     , "erlang"
                     , "fennel"
                     , "graphql"
                     , "html"
                     , "java"
                     , "javascript"
                     , "json"
                     , "jsonc"
                     , "lua"
                     , "make"
                     , "nix"
                     , "ocaml"
                     , "python"
                     , "rust"
                     , "typescript"
                     , "vim"
                     , "yaml"
                   }
}

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    float = { enable = true },
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = false,
      }
    }
  },
  filters = {
    dotfiles = true,
  },
  actions = {
    change_dir = { enable = true }
  }
})

-- show git branch name in statusline
vim.cmd [[
  let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'inactive': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'FugitiveHead'
    \ },
    \ }
]]

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

-- make `vi(` and `%` treat '\(' as normal '(', as in haskell style lambda (\(x,y) -> ...)
-- if this flag is not set, then vim will treat it as escaped '(' and ignore them
set.cpoptions = set.cpoptions._value .. "M"

-- enable copy paste from vim to the outside world
-- clipboard acts weird with windows wsl?
set.clipboard = 'unnamed,unnamedplus'
-- following behaves wierd with copy paste between vim sessions
--vim.cmd [[
--  autocmd TextYankPost * call system('echo '.shellescape(join(v:event.regcontents, "\<CR>")).' |  clip.exe')
--]]

-- make it possible to load huge json files and still get folding...
set.maxmempattern=2000000
set.conceallevel=0 --if not set, quotes will be hidden in json files

set.splitbelow = true
set.splitright = true

local nnoremap = function(keyseq, command)
  vim.api.nvim_set_keymap('n', keyseq, command, {noremap = true})
end

local vnoremap = function(keyseq, command)
  vim.api.nvim_set_keymap('v', keyseq, command, {noremap = true})
end

local xnoremap = function(keyseq, command)
  vim.api.nvim_set_keymap('x', keyseq, command, {noremap = true})
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

nnoremap('<leader>h', ':set winfixheight<CR>')
nnoremap('<leader>w', ':set winfixwidth<CR>')

-- remap visual selection to not include leading whitespace when selecting strings...
nnoremap("va'", "v2i'")
nnoremap('va"', 'v2i"')
nnoremap('va`', 'v2i`')

-- Disable triggering of annoying 'Ex mode'
nnoremap('Q','<nop>')

-- more convinient matching parens navigation
nnoremap('<tab>','%')
vnoremap('<tab>','%')

-- the tab remapping above will also affect <C-i> (go to newer cursor position)
-- we solve this issue with following remappings
nnoremap('<leader>,', '<C-o>')
nnoremap('<leader>.', '<C-i>')

-- 'neovim/nvim-lspconfig'
-- TODO: how to get the same docs as the one that comes with autocompletion?
nnoremap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
--keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
--nnoremap('K', '<cmd>Lspsaga hover_doc<CR>')

nnoremap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')

nnoremap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
--keymap("n", "gd", "<cmd>Lspsaga preview_definition<CR>", { silent = true })
--nnoremap('gd', '<cmd>Lspsaga preview_definition<CR>')

--nnoremap('<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
nnoremap('<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
nnoremap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
nnoremap('<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
nnoremap('<localleader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
vnoremap('<localleader>f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>')

-- 'nvim-telescope/telescope.nvim'
nnoremap('<leader>f', '<cmd>Telescope find_files<cr>')
nnoremap('<leader>gg', '<cmd>Telescope live_grep<cr>')
nnoremap('<leader>b', '<cmd>Telescope buffers<cr>')
nnoremap('<leader>r', "<cmd>lua require'telescope.builtin'.lsp_references{}<CR>")
--nnoremap('<leader>ri', "<cmd>lua require'telescope.builtin'.lsp_incoming_calls{}<CR>")
--nnoremap('<leader>ro', "<cmd>lua require'telescope.builtin'.lsp_outgoing_calls{}<CR>")

nnoremap('<leader>gws', '<cmd>Telescope git_worktree git_worktrees<cr>')

-- yank to windows clip.exe
vnoremap('<leader>y', ":'<,'>w !clip.exe<cr><cr>")
xnoremap('<leader>y', ":'<,'>w !clip.exe<cr><cr>")

-- yank current file path
nnoremap('<leader>d', ':let @+ = expand("%")<cr>')

-- 'hrsh7th/nvim-compe'
--inoremap('<silent><expr> <C-Space>', 'compe#complete()')

-- 'preservim/nerdtree'
--nnoremap('<C-n>', ':NERDTreeToggle<CR>')
nnoremap('<C-n>', ':NvimTreeToggle<CR>')

-- 'rhysd/git-messenger.vim'
nnoremap('<leader>m', ':GitMessenger<CR>')

-- 'pgr0ss/vim-github-url'
nnoremap('<leader>u', ':GitHubURL<CR>')
vnoremap('<leader>u', ':GitHubURL<CR>')

-- 'Yggdroot/indentLine'
nnoremap('<leader>i', ':IndentLinesToggle<CR>')

let.jsonpath_register = '*'
vim.cmd [[
  au FileType json setl foldmethod=expr
  au FileType json setl foldexpr=nvim_treesitter#foldexpr()
  au FileType json noremap <buffer> <silent> <localleader>d :call jsonpath#echo()<CR>
  au FileType json noremap <buffer> <silent> <localleader>g :call jsonpath#goto()<CR>
]]

--vim.cmd [[
--  au FileType purescript setl indentexpr=""
--]]
-- purescript plugin has some annoying indentation rules
let.purescript_disable_indent = 1

-- keep terminal buffers open in background
vim.cmd [[
  augroup custom_term
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber bufhidden=hide
  augroup END
]]

vim.cmd [[
  augroup fsharp_filetypes
    autocmd!
    autocmd BufNewFile,BufRead .fs,.fsx,*.fsi set filetype=fsharp
  augroup END
  au FileType fsharp setl tabstop=4
  au FileType fsharp setl shiftwidth=4
]]

--let.nd_themes = { {"sunrise+1/3", "gruvbox", "light" }
--                , {"sunset+0", "gruvbox", "dark" } }
--let.nd_latitude = 55

set.background = "dark"
vim.opt.termguicolors = true
vim.cmd([[colorscheme gruvbox]])

_G.switch_colorscheme = function()
  if(set.background._value == "dark") then
    set.background = "light"
    vim.cmd([[colorscheme gruvbox]])
  else
    set.background = "dark"
    --vim.cmd([[colorscheme gruvbox]])
  end
end
nnoremap('<leader>c', '<cmd>lua switch_colorscheme()<CR>')


vim.cmd [[
let g:send_multiline = {
\    'fsharp': {'begin':"", 'end':";;\n", 'newline':"\n"}
\}
]]
