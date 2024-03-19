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
vim.keymap.set("x", 'p', '\"_dP')

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
vim.keymap.set("n", '<localleader>e', ":tabedit %<cr>")
vim.keymap.set("n", '<localleader>c', ":tabclose<cr>")

-- saving current session
vim.keymap.set("n", '<leader>s', ":mksession!<cr>")
-- loading current session
vim.keymap.set("n", '<leader>l', ":so Session.vim<cr>")
