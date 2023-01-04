return require('packer').startup(function()
  -- plugin package manager, which can manage itself
  use 'wbthomason/packer.nvim'

  -- simple file tree viewer
  --use 'preservim/nerdtree'
  use {
    'nvim-tree/nvim-tree.lua',
    --requires = {
    --  'nvim-tree/nvim-web-devicons', -- optional, for file icons
    --},
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  -- fuzzy finder for code, files and more...
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- simple utility using git for marking which lines that has been, added, changed or removed
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    }
  }

  -- modern colorschemes (they integrate with lsp, but I had some problems making them work properly, and the modern github theme was too harsh on the eyes and behaves weird)
  --use 'projekt0n/github-nvim-theme'
  use {"ellisonleao/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}
  -- nightfox is too pale and thin...
  -- use 'EdenEast/nightfox.nvim'
  
  -- oldschool colorschemes (lacks proper lsp integration...)
  --use 'morhetz/gruvbox'
  use 'endel/vim-github-colorscheme'

  -- alternative to the old vim-surround (old vim-surround does not behave well with Elm code...)
  use 'michelrandahl/simple-vim-surround'

  -- easily send code from a buffer to neovim terminal (must have for REPL workflows)
  use 'mtikekar/nvim-send-to-term'

  -- to arrange, visually select everything and run the command `:CSVArrangeColumn`
  -- to delete a column run the command `:DeleteColumn`
  use 'chrisbra/csv.vim'

  --[[
    Use vim as DB-IDE with 'tpope/vim-dadbod'.
    Create a vim file with db-connection strings and db-ui configuration.
    Example:
      file: my-db.vim
      ```
      let g:dbs = {
      \ 'db1': 'somedb://url-encoded-connection-string-with-pw-and-username',
      \ 'db2': 'somedb://url-encoded-connection-string-with-pw-and-username'
      \ }
      let g:db_ui_auto_execute_table_helpers = 0
      autocmd VimEnter * DBUI
      ```
      start neovim with:
      $ nvim -S my-db.vim

      You can also specify the connection string in an environment variable
      ```
      export DBUI_URL="somedb://url-encoded-connection-string-with-pw-and-username"
      ```
  --]]
  use 'tpope/vim-dadbod'
  use 'kristijanhusak/vim-dadbod-ui'

  -- easily get the path of some specific field in some big json file
  use 'mogelbrod/vim-jsonpath'

  -- neovim Language Server Protocol, for better syntax highlightning etc...
  use 'neovim/nvim-lspconfig'
  --use { 'nvim-treesitter/nvim-treesitter'
  --    , run = ':TSUpdate'
  --    , commit = '668de0951a36ef17016074f1120b6aacbe6c4515'}
  use { 'nvim-treesitter/nvim-treesitter'
      --, run = ':TSUpdate'
      --, commit = '668de0951a36ef17016074f1120b6aacbe6c4515'
    }

  -- automatic colour theme switcher based on the sun
  -- use 'nightsense/night-and-day'

  -- view commit message and git-blame for specific lines
  use 'rhysd/git-messenger.vim'

  -- copy current line as github link
  use 'pgr0ss/vim-github-url'

  -- visualize indentations
  use 'Yggdroot/indentLine'

  -- Idris language support
  use 'idris-hackers/idris-vim'

  -- Hy-lang language support
  use 'hylang/vim-hy'

  -- F# language support
  use 'PhilT/vim-fsharp'
  --use 'adelarsq/neofsharp.vim'
  --Ionide basically just provide syntax highlightning
  --use 'ionide/Ionide-vim'

  -- Purescript language support
  use 'purescript-contrib/purescript-vim'

  -- intellisense/autocompletion
  -- TODO deprecated but functional, replace with 'hrsh7th/nvim-cmp' after some time
  --use 'hrsh7th/nvim-compe'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp'

  --use 'ThePrimeagen/git-worktree.nvim'
  -- show git branch information in statusline
  use 'itchyny/lightline.vim'
  use 'tpope/vim-fugitive'

  use 'carlsmedstad/vim-bicep'

  --use 'glepnir/lspsaga.nvim'

  -- terraform syntax
  -- use 'hashivim/vim-terraform'
end)
