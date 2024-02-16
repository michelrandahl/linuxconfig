function align_text(char)
  -- Get the current visual selection range
  local line_start = vim.fn.line("'<")
  local line_end = vim.fn.line("'>")

  -- Initialize the maximum column index of the aligning character
  local max_col = 0

  -- Find the maximum column index for the aligning character in the selection
  for line_num = line_start, line_end do
    local line = vim.fn.getline(line_num)
    local char_col = string.find(line, char)
    if char_col and char_col > max_col then
      max_col = char_col
    end
  end

  -- Align the text based on the maximum column index
  for line_num = line_start, line_end do
    local line = vim.fn.getline(line_num)
    local char_col = string.find(line, char)
    if char_col then
      local spaces_needed = max_col - char_col
      local line_new = string.gsub(line, char, string.rep(" ", spaces_needed) .. char, 1)
      vim.fn.setline(line_num, line_new)
    end
  end
end

