vim.opt.termguicolors = true

vim.cmd [[
  hi Normal guibg=NONE ctermbg=NONE
  hi NonText guibg=NONE ctermbg=NONE
]]

local current_time = os.date("*t")
local morning = { hour = 8, min = 0, sec = 0 }
local evening = { hour = 16, min = 0, sec = 0 }

-- Function to compare two times
local function is_after(time1, time2)
  if time1.hour > time2.hour then
    return true
  elseif time1.hour == time2.hour then
    if time1.min > time2.min then
      return true
    elseif time1.min == time2.min then
      return time1.sec >= time2.sec
    end
  end
  return false
end

-- Function to check if the current time is between two times
local function is_between(time, start_time, end_time)
  return is_after(time, start_time) and not is_after(time, end_time)
end

if is_between(current_time, morning, evening) then
  vim.opt.background = "light"
  vim.cmd('colorscheme daylight')
else
  vim.opt.background = "dark"
  vim.cmd('colorscheme monokai-nightasty')
end

_G.switch_colorscheme = function()
  if(vim.opt.background._value == "dark") then
    vim.opt.background = "light"
    vim.cmd('colorscheme daylight')
  else
    vim.opt.background = "dark"
    vim.cmd([[colorscheme monokai-nightasty]])
  end
end
vim.keymap.set("n", '<leader>c', switch_colorscheme, {})
