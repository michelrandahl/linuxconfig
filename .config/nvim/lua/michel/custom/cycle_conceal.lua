function cycle_conceallevel()
  local current_level = vim.opt.conceallevel:get()
  local next_level = (current_level + 1) % 4
  vim.opt.conceallevel = next_level
  
  local messages = {
    [0] = "Conceallevel: 0 (No concealing)",
    [1] = "Conceallevel: 1 (Replaced with one character)",
    [2] = "Conceallevel: 2 (Hidden unless custom replacement)",
    [3] = "Conceallevel: 3 (Completely hidden)"
  }

  vim.notify(messages[next_level])
end
