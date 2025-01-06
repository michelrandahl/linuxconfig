-- Create a global stack for window layouts
_G.temp_window_layout_stack = _G.temp_window_layout_stack or {}
_G.temp_layout_counter = _G.layout_counter or 0

local function get_next_layout_file()
    _G.temp_layout_counter = _G.temp_layout_counter + 1
    return string.format('.win_layout_temp_%d.vim', _G.temp_layout_counter)
end

local function cleanup_old_layouts()
    local handle = io.popen('ls .win_layout_temp_*.vim 2>/dev/null')
    if handle then
        for file in handle:lines() do
            vim.fn.delete(file)
        end
        handle:close()
    end
    _G.temp_layout_counter = 0
end

vim.api.nvim_create_user_command('CenterMain', function()
    --local temp_file = ".win_center_layout_temp.vim"
    local temp_file = get_next_layout_file()
    -- Save current session to temp file
    vim.cmd('mksession! ' .. temp_file)
    table.insert(_G.temp_window_layout_stack, temp_file)
    
    -- Store current buffer ID to keep
    local curr_buf = vim.api.nvim_get_current_buf()
    
    -- Close all other windows
    vim.cmd('only')
    
    -- Create new window and set it up
    vim.cmd('leftabove vnew')
    vim.cmd('set nu!')
    vim.cmd('vertical resize 60%')
    
    -- Return to original buffer window
    vim.api.nvim_set_current_win(vim.fn.bufwinid(curr_buf))
end, {})

vim.api.nvim_create_user_command('FocusMain', function()
    --local temp_file = ".win_focus_layout_temp.vim"
    local temp_file = get_next_layout_file()
    -- Save current session to temp file
    vim.cmd('mksession! ' .. temp_file)
    table.insert(_G.temp_window_layout_stack, temp_file)
    -- Close all other windows
    vim.cmd('only')
end, {})

vim.api.nvim_create_user_command('UnfocusMain', function()
    local temp_file = table.remove(_G.temp_window_layout_stack)
    
    if not temp_file then
        cleanup_old_layouts()
        return
    end
    
    if vim.fn.filereadable(temp_file) == 1 then
        vim.cmd('source ' .. temp_file)
        vim.fn.delete(temp_file)
        _G.temp_layout_counter = _G.temp_layout_counter - 1
    end
end, {})
