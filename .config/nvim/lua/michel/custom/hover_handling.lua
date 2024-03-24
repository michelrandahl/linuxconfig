function format_purs_declaration(s)
  -- the special chars used by purescript for type signatures will count for multiple chars, so we reduce them to `.` before counting
  local charCount = #s:gsub("⇒", "."):gsub("→", "."):gsub("∀", ".")
  -- we only unfold the type signature if it takes up more than 100 chars in width
  if charCount > 100 then
    return s
      :gsub("::", "\n ::", 1)
      :gsub("%.", "\n  .", 1)
      :gsub("⇒",  "\n  ⇒")
      :gsub("→",  "\n  →")
      -- fix situations where the previous step has added a newline inside a function signature
      -- for example `(a →\n    b)` which we correct to `(a → b)`
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
