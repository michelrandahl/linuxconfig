local function config()
end

local function init()
  -- support sending data to fsharp repl (fsi)
  vim.cmd [[
    let g:send_multiline = {
      \ 'fsharp': {'begin':"", 'end':";;\n", 'newline':"\n"}
      \ }
  ]]
end

return {
  'mtikekar/nvim-send-to-term',
  config = config,
  init = init
}
