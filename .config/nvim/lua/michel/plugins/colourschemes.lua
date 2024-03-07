return {
--  {
--    "folke/tokyonight.nvim",
--    --priority = 1000,
--    config = function()
--      require("tokyonight").setup { style = "moon" }
--      --vim.cmd([[colorscheme tokyonight]])
--
--      -- Function to convert hex color to RGB
--      local function hex_to_rgb(hex)
--        hex = hex:gsub("#","")
--        return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
--      end
--
--      -- Function to make a color slightly darker
--      local function darken_color(hex, amount)
--        local r, g, b = hex_to_rgb(hex)
--        r = math.max(0, r - amount)
--        g = math.max(0, g - amount)
--        b = math.max(0, b - amount)
--        return string.format("#%02x%02x%02x", r, g, b)
--      end
--
--      -- Get the current background color of NormalFloat
--      local normal_float_bg = vim.api.nvim_get_hl_by_name("NormalFloat", true).background
--      -- Convert the background color from decimal to hex
--      local normal_float_bg_hex = string.format("#%06x", normal_float_bg)
--      -- Darken the background color
--      local darker_bg = darken_color(normal_float_bg_hex, 10) -- Adjust the amount to make it darker or lighter
--
--      -- Apply the darker background color to NormalFloat and FloatBorder
--      --vim.api.nvim_set_hl(0, "NormalFloat", { bg = darker_bg })
--      --vim.api.nvim_set_hl(0, "FloatBorder", { bg = darker_bg })
--    end,
--  },
--  {
--    "ellisonleao/gruvbox.nvim",
--    --priority = 1000,
--    dependencies = { "rktjmp/lush.nvim" },
--    config = function()
--      --vim.cmd([[colorscheme gruvbox]])
--
--      _G.switch_colorscheme = function()
--        if(vim.opt.background._value == "dark") then
--          vim.opt.background = "light"
--          vim.cmd([[colorscheme gruvbox]])
--        else
--          vim.opt.background = "dark"
--          --vim.cmd([[colorscheme gruvbox]])
--        end
--      end
--      vim.keymap.set("n", '<leader>c', switch_colorscheme, {})
--
--    end,
--  },
  --{
  --  "tanvirtin/monokai.nvim",
  --  --config = function()
  --  --  vim.cmd([[colorscheme monokai]])
  --  --end
  --},

  {
    'rktjmp/lush.nvim',
    --lazy = true
  },

  {
      "polirritmico/monokai-nightasty.nvim",
      --lazy = true,
      --priority = 1000,
      opts = {
        dark_style_background = "transparent", -- default, dark, transparent, #color
      }
  },

  {
    'projekt0n/github-nvim-theme',
    --lazy = true
  },

  {
    dir = '/home/michel/Code/daylight_resistant_colourscheme/daylight',
    dependencies = { "rktjmp/lush.nvim" },
    --priority = 1000,
    --lazy = false,
    --init = function()
    --  require('lush')(require('lush_theme.daylight'))
    --end
  },
  --{
  --    'michelrandahl/daylight',
  --    dependencies = { "rktjmp/lush.nvim" },
  --},
}
