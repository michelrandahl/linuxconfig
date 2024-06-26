function ToggleAutoCenter()
    -- Check if the buffer-local variable is set and true
    if vim.b.auto_center_enabled then
        -- Auto-centering is currently enabled, so disable it
        -- Clear the autocmds for this buffer
        vim.opt_local.scrolloff = 0
        -- Set the buffer-local variable to false to indicate auto-centering is disabled
        vim.b.auto_center_enabled = false
    else
        -- Auto-centering is currently disabled, so enable it
        -- Define the autocmds for this buffer
        vim.opt_local.scrolloff = 999
        -- Set the buffer-local variable to true to indicate auto-centering is enabled
        vim.b.auto_center_enabled = true
    end
end

-- Create a command to easily toggle auto-centering
vim.api.nvim_create_user_command('ToggleAutoCenter', ToggleAutoCenter, {})
