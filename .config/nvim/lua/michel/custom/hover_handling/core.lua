require("michel.custom.hover_handling.utils")

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
  {} --{ border = "single" } -- TODO this prob doesn't work anymore, instead see `vim.o.winborder = 'rounded'` in `michel/core/init.lua`
)
