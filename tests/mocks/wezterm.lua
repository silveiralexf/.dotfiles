-- Minimal wezterm mock for testing config and extensions without WezTerm binary.
local M = {
  GLOBAL = {},
  config_dir = '/mock/wezterm/config',
  log_warn = function(...) end,
  log_error = function(...) end,
  read_dir = function(_) return {} end,
  on = function(_, _) end,
}
return M
