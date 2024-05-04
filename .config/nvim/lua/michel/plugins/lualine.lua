local bright_theme = {
  normal = {
    a = { bg = '#0077cc', fg = '#ffffff', gui = 'bold' },  -- Vibrant blue with white text
    b = { bg = '#0099ff', fg = '#000000' },              -- Brighter blue with black text
    c = { bg = '#e0e0e0', fg = '#000000' },              -- Light gray with black text
  },
  inactive = {
    a = { bg = '#cccccc', fg = '#333333', gui = 'bold' }, -- Darker gray with dark gray text
    b = { bg = '#dddddd', fg = '#444444' },              -- Medium gray with slightly lighter gray text
    c = { bg = '#eeeeee', fg = '#555555' },              -- Light gray with light gray text
  },
}

local dark_theme = {
  normal = {
    --a = { bg = '#00135E', fg = '#ffffff', gui = 'bold' },  -- Dark green with white text, stands out clearly
    a = 'auto',
    b = { bg = '#120099', fg = '#ffffff' },              -- Slightly brighter green with white text
    c = { bg = '#004F99', fg = '#ffffff' },              -- Dark gray with light gray text, for less crucial info
  },
  inactive = {
    a = { bg = '#333333', fg = '#bbbbbb', gui = 'bold' }, -- Very dark gray with darker text
    b = { bg = '#2a2a2a', fg = '#777777' },              -- Darker gray with medium gray text
    c = { bg = '#222222', fg = '#cccccc' },              -- Even darker gray with slightly lighter text
  },
}

_G.setup_lualine = function()
  local colorscheme = vim.api.nvim_get_option('background')

  local lualine_theme
  if colorscheme == 'dark' then
    lualine_theme = 'material'-- dark_theme
  else
    lualine_theme = bright_theme
  end

  require('lualine').setup {
    -- Detect the colorscheme to decide the lualine theme
    options = {
      theme = lualine_theme,                     -- Automatically chooses the theme based on your current color scheme
      section_separators = {'', ''},
      component_separators = {'|', '|'},
      icons_enabled = false,              -- Disable icons entirely
    },
    sections = {
      lualine_a = {'mode'},               -- Display mode only
      lualine_b = {'branch', 'diff', 'diagnostics'},   -- Keep branch, diff, and diagnostics
      lualine_c = {{
          'filename',
          file_status = true,             -- Displays file status (readonly status, modified status)
          path = 1                        -- 0 = just filename, 1 = relative path, 2 = absolute path
      }},
      lualine_x = {'progress'},           -- Display progress only
      lualine_y = {'location'},           -- Display cursor location only
      lualine_z = {}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {{
          'filename',
          file_status = false,            -- Possibly omit the file status in inactive windows
          path = 1                        -- Show relative path, similar to active windows
      }},
      lualine_x = {},
      lualine_y = {'location'},           -- Could still show cursor location or omit for cleaner look
      lualine_z = {}
    },
    extensions = {'fugitive'}             -- Extension for git features
  }
end

vim.cmd([[
  autocmd Colorscheme * lua setup_lualine()
]])

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'tpope/vim-fugitive' },
  config = setup_lualine
}
