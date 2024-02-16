local function config()
  require("neoconf").setup()
end

return {
  'folke/neoconf.nvim',
  config = config
}

