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
--vim.keymap.set("n", '<leader>h', ':set winfixheight!<CR>')
--vim.keymap.set("n", '<leader>w', ':set winfixwidth!<CR>')

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

-- NOTE `conceallevel` means hiding of characters or transforming characters to fancy unicode characters
vim.api.nvim_set_keymap('n', '<leader>i', ':lua cycle_conceallevel()<CR>', { noremap = true, silent = true })
vim.opt.conceallevel = 3

vim.api.nvim_set_keymap('n', '<leader><TAB>', '<cmd>CenterMain<CR>',  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader><CR>', '<cmd>FocusMain<CR>',    { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader><BS>', '<cmd>UnfocusMain<CR>', { noremap = true, silent = true })

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

-- Stay at the original word when highlighting with *
vim.keymap.set("n", '<leader>w', "#N", { silent = true })

-- saving current session
vim.keymap.set("n", '<leader>s', ":mksession!<cr>")
-- loading current session
vim.keymap.set("n", '<leader>l', ":so Session.vim<cr>")

-- history cursor navigation with , and . instead of o and i
-- (<C-i> maps to Tab, which we are using for chaning tabs in neovim)
-- also re-center the screen to the historical navigation
vim.keymap.set("n", '<C-,>', "<C-o>zz")
vim.keymap.set("n", '<C-.>', "<C-i>zz")

-- utility function, especially useful when working on nvim plugins or config
local function copy_messages_to_clipboard()
  local messages = vim.api.nvim_exec("messages", true)
  vim.fn.setreg('+', messages)
  print("Messages copied to clipboard.")
end
vim.keymap.set("n", '<leader>x', copy_messages_to_clipboard)

-- Define a keybinding to paste over the current word while preserving the default copy buffer
vim.api.nvim_set_keymap('n', '<leader>p', 'ciw<c-r>0<esc>', { noremap = true, silent = true })

-- remapping original word completion to alt-n (because blink-cmp gets in the way)
vim.keymap.set('i', '<M-n>', '<C-n>', { noremap = true })
vim.keymap.set('i', '<M-p>', '<C-p>', { noremap = true })

-- Remap } in visual line mode to go to the last line of the paragraph
vim.keymap.set('v', '}', function()
    if vim.fn.mode() == 'V' then
        return '}k'
    else
        return '}'
    end
end, { expr = true })

-- Remap { in visual line mode to go to the last line of the paragraph
vim.keymap.set('v', '{', function()
    if vim.fn.mode() == 'V' then
        return '{j'
    else
        return '}'
    end
end, { expr = true })

-- Don't save folding information in sessions (they cause issues with treesitter when trying to reload a saved session)
vim.opt.sessionoptions:remove("folds")

-- This autocommand will run after a session is loaded and:
-- 1. Make sure treesitter is enabled for syntax highlighting (which often initializes the parsers)
-- 2. Loop through all valid, non-special buffers
-- 3. Reset the fold method and fold expression
-- 4. Force recomputation of folds with zx
vim.api.nvim_create_autocmd("SessionLoadPost", {
  callback = function()
    vim.cmd("TSBufEnable highlight")

    -- Add a delay to give treesitter time to initialize
    vim.defer_fn(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
          vim.api.nvim_buf_call(buf, function()
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
            vim.cmd("normal! zx")
          end)
        end
      end
    end, 3000) -- 3seconds delay
  end
})
