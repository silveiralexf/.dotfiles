-- ANSI color helpers for terminal output (byfeature-style: blue/cyan/green/red).
-- Use no colors when stdout is not a TTY so CI logs stay plain.

local M = {}

local function use_color()
  if os.getenv('NO_COLOR') then return false end
  -- Assume color when TERM suggests a terminal; set NO_COLOR=1 in CI to disable
  return os.getenv('TERM') and os.getenv('TERM') ~= '' or false
end

local tty = use_color()

-- ANSI codes
local RESET = '\27[0m'
local BOLD = '\27[1m'
local RED = '\27[31m'
local GREEN = '\27[32m'
local CYAN = '\27[36m'
local BLUE = '\27[34m'
local WHITE = '\27[37m'

function M.reset()
  return tty and RESET or ''
end

function M.bold_white(s)
  return tty and (BOLD .. WHITE .. tostring(s) .. RESET) or tostring(s)
end

function M.cyan(s)
  return tty and (CYAN .. tostring(s) .. RESET) or tostring(s)
end

function M.green(s)
  return tty and (GREEN .. tostring(s) .. RESET) or tostring(s)
end

function M.red(s)
  return tty and (RED .. tostring(s) .. RESET) or tostring(s)
end

function M.blue(s)
  return tty and (BLUE .. tostring(s) .. RESET) or tostring(s)
end

return M
