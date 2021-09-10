return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'preservim/nerdtree'

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    }
  }

  use 'dracula/vim'
  use 'rafi/awesome-vim-colorschemes'

  use 'michelrandahl/simple-vim-surround'
  use 'mtikekar/nvim-send-to-term'

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

  use 'mogelbrod/vim-jsonpath'

  use 'neovim/nvim-lspconfig'
  use { 'nvim-treesitter/nvim-treesitter'
      , run = ':TSUpdate' }

  use 'nightsense/night-and-day'

  use 'rhysd/git-messenger.vim'

  use 'Yggdroot/indentLine'

  use 'idris-hackers/idris-vim'

  use 'hylang/vim-hy'

  use 'PhilT/vim-fsharp'
  --use 'adelarsq/neofsharp.vim'

  use 'purescript-contrib/purescript-vim'

  -- TODO deprecated but functional, replace with 'hrsh7th/nvim-cmp' after some time
  use 'hrsh7th/nvim-compe'
  --use 'hrsh7th/nvim-cmp'
end)
