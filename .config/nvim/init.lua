require("michel.core")
require("michel.lazy")


-- ===== Remapping after everything else is loaded to avoid plugins to mess up my remappings =====

-- remap visual selection to not include leading whitespace when selecting strings...
vim.keymap.set("n", "va'", "v2i'")
vim.keymap.set("n", 'va"', 'v2i"')
vim.keymap.set("n", 'va`', 'v2i`')

-- easier movement between windows
vim.keymap.set("n", '<C-J>', '<C-W><C-J>')
vim.keymap.set("n", '<C-K>', '<C-W><C-K>')
vim.keymap.set("n", '<C-L>', '<C-W><C-L>')
vim.keymap.set("n", '<C-H>', '<C-W><C-H>')

-- automatically insert closing parens
vim.keymap.set("i", '"', '""<esc>i')
vim.keymap.set("i", '(', '()<esc>i')
vim.keymap.set("i", '[', '[]<esc>i')
vim.keymap.set("i", '{', '{}<esc>i')
vim.keymap.set("i", '`', '``<esc>i')

-- locking window sizes
vim.keymap.set("n", '<leader>h', ':set winfixheight!<CR>')
vim.keymap.set("n", '<leader>w', ':set winfixwidth!<CR>')

-- keep the yank buffer intact while pasting over existing content
-- Keymap command: '\"_dP' breaks down as follows:
-- '\"_': Use the black hole register for the next delete operation, effectively ignoring it.
-- 'd': Delete the current selection in visual mode.
-- 'P': Paste the content of the unnamed register before the cursor position.
-- NOTE: seems to be buggy, it will sometimes swap place with the char in front
--vim.keymap.set("x", 'p', '\"_dP')

-- print file path
vim.keymap.set("n", '<localleader>y', ":echo expand('%:p')<cr>", {})
-- copy file path to copy-paste buffer
vim.keymap.set("n", '<localleader>yy', ":let @+=expand('%:p')<cr>", {})

-- terminate a line with ';' (useful when working with C-syntax derivative languages such as Rust)
vim.keymap.set("n", '<localleader>;', "A;<esc>")
vim.keymap.set("i", '<M-;>', "<esc>A;<esc>")
-- terminate a line with '?;' (useful when working with Rust)
vim.keymap.set("n", '<M-/>', "A?;<esc>")
vim.keymap.set("i", '<M-/>', "<esc>A?;<esc>")

vim.api.nvim_set_keymap('v', '<localleader>a', ':lua align_text(vim.fn.input("Align by character: "))<CR>', { noremap = true, silent = true })

-- `Q` in neovim repeats the last macro.
-- With some keyboards (for example my laptop keyboard), shift acts a bit sluggish at times
-- which accidentially can result in triggering this functionality.
-- Note that the old behavior of `Q` was to enter something called `Ex mode`
vim.keymap.set("n", 'Q','<nop>')

vim.keymap.set("n", '<localleader>e', '<cmd>lua vim.diagnostic.open_float()<CR>')

vim.keymap.set("n", '<localleader>z', '<cmd>ToggleAutoCenter<CR>')

-- handling tabs
vim.keymap.set("n", '<tab>', ":tabnext<cr>")
vim.keymap.set("n", '<s-tab>', ":tabprev<cr>")
vim.keymap.set("n", '<localleader>te', ":tabedit %<cr>")
vim.keymap.set("n", '<localleader>tc', ":tabclose<cr>")
vim.keymap.set("n", '<localleader>tn', ":tabnew<cr>")

-- saving current session
vim.keymap.set("n", '<leader>s', ":mksession!<cr>")
-- loading current session
vim.keymap.set("n", '<leader>l', ":so Session.vim<cr>")


local function copy_messages_to_clipboard()
  local messages = vim.api.nvim_exec("messages", true)
  vim.fn.setreg('+', messages)
  print("Messages copied to clipboard.")
end

vim.keymap.set("n", '<leader>x', copy_messages_to_clipboard)

function format_purs_declaration(s)
  local charCount = #s:gsub("⇒", "."):gsub("→", "."):gsub("∀", ".")
  if charCount > 100 then
    return s
      :gsub("::", "\n ::", 1)
      :gsub("%.", "\n  .", 1)
      :gsub("⇒",  "\n  ⇒")
      :gsub("→",  "\n  →")
      -- fix situations where we have added a newline inside a function from previous step
      -- for example `(a →\n    b)`
      :gsub("%(([^%)]-)\n[ ]+", "(%1")
  else
    return s
  end
end

local function format_purescript_hover_text(hover_text)
    -- Split the hover text into signature and description
    local signature_block, description = hover_text:match("```purescript\n(.-)\n```\n(.*)")
    if not signature_block then
        return hover_text -- Return original if pattern doesn't match
    end

    -- Split the signature block into individual declarations
    local declarations = {}
    for declaration in signature_block:gmatch("[^\n]+") do
        table.insert(declarations, declaration)
    end

    -- Check if we have at least one declaration to format
    if #declarations == 0 then
        return hover_text
    end

    local first_declaration = format_purs_declaration(declarations[1])

    -- Preparing the formatted signature, now only including the first declaration
    local formatted_signature_lines = {
      "```purescript",
      first_declaration,
      "```",
    }

    -- Adding a separation line
    if #description > 0 then
      table.insert(formatted_signature_lines, "--------------------")
      table.insert(formatted_signature_lines, description)
    end

    -- Concatenate the formatted first signature with the description
    local formatted_hover_text = table.concat(formatted_signature_lines, "\n")

    return formatted_hover_text
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  function(...)
    local args = {...}

    local ctx = args[3]
    local bufnr = ctx.bufnr or 0
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

    if filetype == "purescript" and args[2] and args[2].contents then
        args[2].contents.value = format_purescript_hover_text(args[2].contents.value)
    end

    --print(vim.inspect(args))

    --vim.lsp.handlers.hover(table.unpack(args))
    vim.lsp.handlers.hover(args[1], args[2], args[3], args[4])
  end,
  { border = "single" }
)
