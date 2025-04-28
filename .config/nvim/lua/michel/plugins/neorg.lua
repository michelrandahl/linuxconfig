local function config()

  require("neorg").setup({
      load = {
        ["core.defaults"] = {},

        ["core.journal"] = {
          config = {
            workspace      = "journal",
            journal_folder = "",
            strategy       = "nested",
            template_name  = "template.norg",
            use_template   = true,
          }
        },

        ["core.dirman"] = {
          config = {
            workspaces = {
                notes   = "~/neorg/notes",
                journal = "~/neorg/journal",
                neorg   = "~/neorg"
            },
            default_workspace = "neorg",
          },
        },

        ["core.concealer"] = {
          config = {
            icon_preset = "diamond",
            icons = {
              todo = {
                urgent    = false,
                uncertain = false,
                cancelled = { icon = "⊘" }
              },
            },
          }
        },

        ["core.tempus"] = {},
        ["core.esupports.metagen"] = {
          config = {
            type = "auto",  -- Generate metadata if not present
            update_date = true,  -- Update the "updated" field on save

            template = {
              --{ "title" },
              { "description" },
              { "created", function() return os.date("%Y-%m-%d %H:%M") end },
              { "updated", function() return os.date("%Y-%m-%d %H:%M") end },
            },

          },
        },

      }
  })

  -- Custom colour overrides
  local function override_colours()
    -- NOTE: use `:Inspect` with the cursor on an item to know its highlight name
    vim.api.nvim_set_hl(0, "@neorg.todo_items.cancelled.norg", { link = "PreProc" })
    vim.api.nvim_set_hl(0, "@neorg.todo_items.urgent.norg", { link = "Constant" })

    vim.api.nvim_set_hl(0, "@neorg.links.file.norg", { link = "MatchParen" })
    vim.api.nvim_set_hl(0, "@neorg.links.file.delimiter.norg", { link = "MatchParen" })

    vim.api.nvim_set_hl(0, "@neorg.links.location.generic.norg", { link = "Todo" })
    vim.api.nvim_set_hl(0, "@neorg.links.location.generic.prefix.norg", { link = "Todo" })

    vim.api.nvim_set_hl(0, "@neorg.headings.1.title.norg", { link = "Type" })
    vim.api.nvim_set_hl(0, "@neorg.links.location.heading.1.norg", { link = "Type" })
    vim.api.nvim_set_hl(0, "@neorg.links.location.heading.1.prefix.norg", { link = "Type" })

    vim.api.nvim_set_hl(0, "@neorg.anchors.declaration.delimiter.norg", { link = "Text" })
    vim.api.nvim_set_hl(0, "@neorg.anchors.definition.delimiter.norg", { link = "Text" })
    vim.api.nvim_set_hl(0, "@neorg.links.description.delimiter.norg", { link = "Text" })
    vim.api.nvim_set_hl(0, "@neorg.markup.bold.delimiter.norg", { link = "Text" })
  end

  -- Create an autocommand group for Neorg highlights
  vim.api.nvim_create_augroup("NeorgHighlights", { clear = true })

  -- Set up highlights whenever a colorscheme changes or when Neorg loads
  vim.api.nvim_create_autocmd({"ColorScheme", "FileType"}, {
    group = "NeorgHighlights",
    pattern = {"*", "norg"},
    callback = function()
      override_colours()
    end,
  })

  -- Set custom highlight colors after Neorg is loaded
  override_colours()
end

return {
    "nvim-neorg/neorg",
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    config = config,
}
