local view = {
  float = {
    enable = true,
  },
}

local renderer = {
  highlight_opened_files = "name"
}

local function config()
  local nvimtree = require("nvim-tree")
  nvimtree.setup(
    { view = view
    , renderer = renderer
    }
  )

  -- recommended settings from nvim-tree documentation
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
end

return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = config
}
