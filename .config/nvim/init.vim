let mapleader=','

"" enable copy/paste/cut
if has('unnamedplus')
	set clipboard=unnamed,unnamedplus
endif


"" plugins
call plug#begin()

" TODO fzf-vim
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'kien/rainbow_parentheses.vim' " better one exists
Plug 'rafi/awesome-vim-colorschemes'
Plug 'venantius/vim-cljfmt'
" Plug 'vim-syntastic/syntastic'
" Plug 'venantius/vim-eastwood'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-salve'
" Plug 'jebberjeb/clojure-socketrepl.nvim'

call plug#end()


"" plugin mappings
map <C-n> :NERDTreeToggle<CR>

"" rainbow parens
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

colorscheme flatcolor 

let g:clj_fmt_autosave = 0

syntax on
set number

set tabstop=4
set softtabstop=0
set shiftwidth=4

au FileType json setl fdm=syntax
au FileType ndjson setl fdm=syntax
