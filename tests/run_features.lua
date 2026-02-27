#!/usr/bin/env lua
-- Run all .feature files with byfeature-style output (Feature:/Scenario:/steps with ✓/✗ and colors).
-- Usage: from repo root, lua tests/run_features.lua
-- Step definitions must be required before running (they register with the runner).

local repo_root = os.getenv('DOTFILES_HOME') or (os.getenv('HOME') and (os.getenv('HOME') .. '/.dotfiles')) or '.'
package.path = package.path .. ';' .. repo_root .. '/?.lua;' .. repo_root .. '/tests/?.lua'

local runner = require('tests.runner.feature_runner')
local lfs = require('lfs')
local colors = require('tests.runner.colors')

-- Load step definitions (they register with runner when required)
local step_dir = repo_root .. '/tests/step_definitions'
for name in lfs.dir(step_dir) do
  if name:match('%.lua$') then
    local mod = name:gsub('%.lua$', '')
    pcall(require, 'tests.step_definitions.' .. mod)
  end
end

local features_dir = repo_root .. '/tests/features'
local total_passed, total_failed = 0, 0
local all_errors = {}

-- Skip feature files that have no step definitions yet (e.g. nvim_keymaps)
local skip_features = { ['nvim_keymaps.feature'] = true }

print(colors.blue('=== RUN   Lua/Features'))
print('')

for name in lfs.dir(features_dir) do
  if name:match('%.feature$') and not skip_features[name] then
    local path = features_dir .. '/' .. name
    local p, f, errs = runner.run_feature_file_byfeature(path, {})
    total_passed = total_passed + p
    total_failed = total_failed + f
    for _, e in ipairs(errs or {}) do table.insert(all_errors, e) end
  end
end

-- Summary
print('')
if #all_errors > 0 then
  print('--- ' .. colors.red('Failed steps:') .. '')
  print('')
  for _, e in ipairs(all_errors) do
    print('  ' .. e)
  end
  print('')
end

print('--- Summary')
local total = total_passed + total_failed
if total == 0 then
  print('No scenarios')
else
  local parts = {}
  if total_passed > 0 then table.insert(parts, colors.green(total_passed .. ' passed')) end
  if total_failed > 0 then table.insert(parts, colors.red(total_failed .. ' failed')) end
  print(total .. ' scenarios (' .. table.concat(parts, ', ') .. ')')
end

if total_failed > 0 then
  os.exit(1)
end
os.exit(0)
