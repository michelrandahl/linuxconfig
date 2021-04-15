let mapleader=' '
let maplocalleader='\'

" make it possible to load huge json files and still get folding...
set maxmempattern=2000000

"" enable global copy/paste/cut
if has('unnamedplus')
	set clipboard=unnamed,unnamedplus
endif


"" plugins
call plug#begin()

Plug 'preservim/nerdtree'
" vim-plug uses: Rust tool 'cargo' and grep tool called ripgrep
"" Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' } " TODO: install stuff doesnt seem to work with nixos
Plug 'liuchengxu/vim-clap'


Plug 'idris-hackers/idris-vim'


"Plug 'kien/rainbow_parentheses.vim' " better one might exists
Plug 'rafi/awesome-vim-colorschemes'


Plug 'michelrandahl/simple-vim-surround'


Plug 'mtikekar/nvim-send-to-term'


Plug 'elmcast/elm-vim'


Plug 'neoclide/coc.nvim', {'branch': 'release'}


Plug 'nightsense/night-and-day'


Plug 'LnL7/vim-nix'


Plug 'purescript-contrib/purescript-vim'


Plug 'mogelbrod/vim-jsonpath'


Plug 'Yggdroot/indentLine'


Plug 'elixir-editors/vim-elixir'


Plug 'neovimhaskell/haskell-vim'


Plug 'ruanyl/vim-gh-line'


" database IDE in vim
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

call plug#end()

let g:coc_global_extensions = ['coc-json', 'coc-vimlsp', 'coc-css', 'coc-html', 'coc-git']

"" rainbow parens
"au VimEnter * RainbowParenthesesToggle
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces

""colorscheme gruvbox 
""if system('date +%H') > 18 || system('date +%H') < 9
""    colorscheme gruvbox
""else
""    colorscheme github
""endif

let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_enabled = 0
map <leader>i :IndentLinesToggle<CR>


" automatic colorscheme changer based on sun hours
let g:nd_themes = [
  \ ['sunrise+0', 'github', 'light' ],
  \ ['sunset+0', 'gruvbox', 'dark' ],
  \ ]
let g:nd_latitude = '55'

" save file without triggering autocommands (... and cljfmt)
nnoremap <leader>w :noa w<CR>

" Clojure
let g:clojure_align_multiline_strings = 1
let g:clojure_align_subforms = 1

syntax on
""filetype plugin indent on
set number
set tabstop=2 shiftwidth=2 expandtab
set nocindent

" make `vi(` and `%` ignore '\(', as in (\(x,y) -> ...)
set cpoptions+=M " read existing cpoptions with `:set cpoptions?`

au FileType json setl fdm=syntax
au FileType ndjson setl fdm=syntax

inoremap " ""<esc>i
inoremap ' ''<esc>i
inoremap ( ()<esc>i
inoremap [ []<esc>i
inoremap { {}<esc>i
inoremap ` ``<esc>i

"" plugin mappings
map <C-n> :NERDTreeToggle<CR>
map <leader>n :NERDTreeToggle<CR>

map <leader>s :Clap blines<CR>
map <leader>g :Clap grep<CR>
" NOTE: if the commits list navigation is buggy, then install plugin through nix, and symlink the plugin....
map <leader>cb :Clap bcommits<CR>
map <leader>co :Clap commits<CR>
map <leader>b :Clap buffers<CR>
map <leader>f :Clap files<CR>


function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

xmap <localleader>f <Plug>(coc-format-selected)
nmap <localleader>f <Plug>(coc-format-selected)<CR>
nmap <localleader>r <Plug>(coc-rename)

" json path plugin
let g:jsonpath_register = '*'
au FileType json noremap <buffer> <silent> <leader>d :call jsonpath#echo()<CR>
au FileType json noremap <buffer> <silent> <leader>g :call jsonpath#goto()<CR>

" keep terminals open in background
augroup custom_term
	autocmd!
	autocmd TermOpen * setlocal nonumber norelativenumber bufhidden=hide
augroup END

function! s:switch_colorscheme()
  if g:colors_name ==# 'gruvbox'
    set background=light
    execute 'colorscheme github'
  else
    set background=dark
    execute 'colorscheme gruvbox'
  endif
endfunction
nnoremap <leader>c :call <SID>switch_colorscheme()<CR>

" change split position defaults
set splitbelow
set splitright

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" remap selection to not include leading whitespace when selecting strings...
nnoremap va' v2i'
nnoremap va" v2i"
nnoremap va` v2i`

" Disable triggering annoying 'Ex mode'
nnoremap Q <nop>

function! s:reload_all_buffers()
  set noconfirm
  bufdo e
  set confirm
endfunction
nnoremap <leader>rb :call <SID>reload_all_buffers()<CR>

nnoremap <leader>rv :source $MYVIMRC<CR>

" lock the height of a window
nnoremap <leader>fh :set winfixheight<CR>

" more convinient matching parens navigation
nnoremap <tab> %
vnoremap <tab> %
