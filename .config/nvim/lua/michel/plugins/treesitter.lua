local function config()
  require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the four listed parsers should always be installed)
    ensure_installed =
      { "bash"
      , "c"
      , "clojure"
      , "css"
      , "elixir"
      , "fennel"
      , "graphql"
      , "html"
      , "javascript"
      , "json"
      , "jsonc"
      , "lua"
      , "make"
      , "nix"
      , "norg"
      , "purescript"
      , "python"
      , "rust"
      , "typescript"
      , "vim"
      , "yaml"
      },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (for "all")
    --ignore_install = { "javascript" },

    highlight = {
      enable = true,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },

    fold = {
      enable = true
    },

    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ab"] = "@block.outer",
          ["ib"] = "@block.inner",
        },
      },
    },
  }
end

local function init()
  vim.cmd([[
    autocmd VimEnter * TSUpdate
  ]])
end

return {
  { 'nvim-treesitter/nvim-treesitter',
    config = config,
    init = init
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = {'nvim-treesitter/nvim-treesitter'}
  }
}
