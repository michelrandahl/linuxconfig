local function config()
  require("ibl").setup {
    exclude = {
      -- Exclude Neorg files
      filetypes = { "norg" }
    }
  }
end

return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = config
}
