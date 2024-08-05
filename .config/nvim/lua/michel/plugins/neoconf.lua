local function config()
  require("neoconf").setup({
      import = {
        vscode = false, -- Set to false to ignore .vscode/settings.json
        coc = false,
        nlsp = false,
      },
      -- Add any other neoconf settings here
    })
end

return {
  'folke/neoconf.nvim',
  config = config
}

