let mapleader=' '
let maplocalleader='\'

"" enable global copy/paste/cut
if has('unnamedplus')
	set clipboard=unnamed,unnamedplus
endif


"" plugins
call plug#begin()

Plug 'preservim/nerdtree'
" vim-plug uses: Rust tool 'cargo' and grep tool called ripgrep
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }


"Plug 'kien/rainbow_parentheses.vim' " better one might exists
Plug 'rafi/awesome-vim-colorschemes'


Plug 'michelrandahl/simple-vim-surround'


Plug 'mtikekar/nvim-send-to-term'


Plug 'elmcast/elm-vim'


Plug 'neoclide/coc.nvim', {'branch': 'release'}


Plug 'nightsense/night-and-day'


Plug 'LnL7/vim-nix'



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

let g:nd_themes = [
  \ ['sunrise+0', 'github', 'light' ],
  \ ['sunset+0', 'gruvbox', 'dark' ],
  \ ]
let g:nd_latitude = '55'


let g:clj_fmt_autosave = 0

syntax on
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
map <leader>ft :NERDTreeToggle<CR>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

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
