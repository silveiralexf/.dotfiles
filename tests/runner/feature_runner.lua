-- Minimal Gherkin runner: parses .feature files and runs registered step definitions.
-- Usage: lua tests/runner/feature_runner.lua [tests/features/*.feature]
-- Step defs are loaded from tests/step_definitions/*.lua (they register with Given/When/Then).

local M = {}

local STEP_KEYWORDS = { 'Given', 'When', 'Then', 'And' }
local step_registry = { Given = {}, When = {}, Then = {}, And = {} }

function M.register(kind, pattern, fn)
  if not step_registry[kind] then step_registry[kind] = {} end
  table.insert(step_registry[kind], { pattern = pattern, fn = fn })
end

-- Parse step text to extract a Lua table if present (e.g. { "a.png", "b.png" } or { font_size = 12 })
function M.parse_table_in_step(step_text)
  local s, e = step_text:find('{.*}')
  if not s then return nil end
  local tbl_str = step_text:sub(s, e)
  local fn, err = load('return ' .. tbl_str)
  if not fn then return nil end
  return fn()
end

-- Parse quoted string from step (e.g. Then key "K" ... -> "K")
function M.parse_quoted(step_text)
  local q = step_text:match('"([^"]*)"')
  if q then return q end
  return step_text:match("'([^']*)'")
end

function M.parse_number(step_text)
  return tonumber(step_text:match('%d+'))
end

-- Find step definition for step line (e.g. "Given backdrops with files { \"a.png\" }")
function M.find_step(kind, step_text)
  local registry
  if kind == 'And' then
    registry = {}
    for _, r in ipairs(step_registry.And or {}) do table.insert(registry, r) end
    for _, r in ipairs(step_registry.Given or {}) do table.insert(registry, r) end
    for _, r in ipairs(step_registry.When or {}) do table.insert(registry, r) end
    for _, r in ipairs(step_registry.Then or {}) do table.insert(registry, r) end
  else
    registry = step_registry[kind] or {}
  end
  -- Prefer exact match, then prefix/substring match (longer patterns first to avoid "current index is 1" matching "current index is 3")
  local exact_match
  local prefix_matches = {}
  for _, def in ipairs(registry) do
    if type(def.pattern) == 'string' then
      if step_text == def.pattern then exact_match = def.fn break end
      if step_text:find(def.pattern, 1, true) then table.insert(prefix_matches, { len = #def.pattern, fn = def.fn }) end
    elseif type(def.pattern) == 'function' and def.pattern(step_text) then
      return def.fn
    end
  end
  if exact_match then return exact_match end
  table.sort(prefix_matches, function(a, b) return a.len > b.len end)
  if prefix_matches[1] then return prefix_matches[1].fn end
  return nil
end

-- Simple .feature parser: yield (feature_name, feature_description, scenario_name, steps[])
-- feature_description is a table of trimmed lines (the paragraph under Feature:).
function M.parse_feature_file(path)
  local content = io.open(path, 'r')
  if not content then return nil, 'cannot open ' .. path end
  content = content:read('*a')
  local lines = {}
  for line in content:gmatch('[^\r\n]+') do
    table.insert(lines, line)
  end
  local feature_name, feature_description, scenario_name, steps, in_scenario
  local function emit_scenario()
    if scenario_name and #steps > 0 then
      coroutine.yield(feature_name, feature_description or {}, scenario_name, steps)
    end
  end
  return coroutine.wrap(function()
    for _, line in ipairs(lines) do
      local trimmed = line:match('^%s*(.-)%s*$')
      if trimmed:match('^Feature:') then
        emit_scenario()
        feature_name = trimmed:gsub('^Feature:%s*', '')
        feature_description = {}
        steps = {}
        in_scenario = false
      elseif trimmed:match('^Scenario:') then
        emit_scenario()
        scenario_name = trimmed:gsub('^Scenario:%s*', '')
        steps = {}
        in_scenario = true
      elseif in_scenario then
        for _, kw in ipairs(STEP_KEYWORDS) do
          local prefix = kw .. ' '
          if trimmed:sub(1, #prefix) == prefix then
            table.insert(steps, { kind = kw, text = trimmed:sub(#prefix + 1):match('^%s*(.-)%s*$') })
            break
          end
        end
      else
        -- Description line (under Feature:, before first Scenario:)
        if feature_name and trimmed ~= '' and not trimmed:match('^Scenario:') then
          table.insert(feature_description, trimmed)
        end
      end
    end
    emit_scenario()
  end)
end

-- Run one feature file; return pass count, fail count, errors
function M.run_feature_file(path, world, tap_output)
  world = world or {}
  tap_output = tap_output or false
  local parser, err = M.parse_feature_file(path)
  if not parser then return 0, 0, { err } end
  local passed, failed = 0, 0
  local errors = {}
  local test_num = 0
  for feature_name, _fd, scenario_name, steps in parser do
    test_num = test_num + 1
    local ok, err_msg = pcall(function()
      local w = setmetatable({}, { __index = world })
      for _, step in ipairs(steps) do
        local fn = M.find_step(step.kind, step.text)
        if not fn then
          error('Undefined step: ' .. step.kind .. ' ' .. step.text)
        end
        fn(w, step.text)
      end
    end)
    if ok then
      passed = passed + 1
      if tap_output then
        print(('ok %d - %s / %s'):format(test_num, feature_name, scenario_name))
      end
    else
      failed = failed + 1
      table.insert(errors, path .. ': ' .. scenario_name .. ': ' .. tostring(err_msg))
      if tap_output then
        print(('not ok %d - %s / %s # %s'):format(test_num, feature_name, scenario_name, tostring(err_msg):gsub('\n', ' ')))
      end
    end
  end
  return passed, failed, errors
end

-- Byfeature-style formatter: Feature:/Scenario: in bold white, steps with ✓ (green) / ✗ (red) / cyan (setup).
local function is_assertion_step(kind, in_then)
  if kind == 'Then' then return true end
  if kind == 'And' and in_then then return true end
  return false
end

function M.run_feature_file_byfeature(path, world)
  world = world or {}
  local colors = require('tests.runner.colors')
  local parser, err = M.parse_feature_file(path)
  if not parser then
    print(colors.red('Error: ' .. tostring(err)))
    return 0, 0, { tostring(err) }
  end
  local passed, failed = 0, 0
  local errors = {}
  local last_feature_name
  for feature_name, feature_description, scenario_name, steps in parser do
    if last_feature_name ~= feature_name then
      print('')
      print(colors.bold_white('Feature: ' .. feature_name))
      for _, desc in ipairs(feature_description) do
        local t = desc:match('^%s*(.-)%s*$')
        if t ~= '' then print('  ' .. t) end
      end
      last_feature_name = feature_name
    end
    print('')
    print('  ' .. colors.bold_white('Scenario') .. ': ' .. scenario_name)
    local w = setmetatable({}, { __index = world })
    local scenario_ok = true
    local in_then = false  -- true after we've seen a Then (so And = assertion)
    for _, step in ipairs(steps) do
      local line = '    ' .. step.kind .. ' ' .. step.text
      local fn = M.find_step(step.kind, step.text)
      if not fn then
        print(colors.red(line .. ' ✗'))
        print(colors.red('      Error: Undefined step'))
        scenario_ok = false
        failed = failed + 1
        table.insert(errors, path .. ': ' .. scenario_name .. ': Undefined step ' .. step.kind .. ' ' .. step.text)
        break
      end
      local ok, err_msg = pcall(fn, w, step.text)
      if not ok then
        print(colors.red(line .. ' ✗'))
        if err_msg and tostring(err_msg) ~= '' then
          print(colors.red('      Error: ' .. tostring(err_msg):gsub('\n', ' ')))
        end
        scenario_ok = false
        failed = failed + 1
        table.insert(errors, path .. ': ' .. scenario_name .. ': ' .. tostring(err_msg))
        break
      end
      if is_assertion_step(step.kind, in_then) then
        print(colors.green(line .. ' ✓'))
      else
        print(colors.cyan(line))
      end
      if step.kind == 'Then' then in_then = true
      elseif step.kind == 'Given' or step.kind == 'When' then in_then = false
      end
    end
    if scenario_ok then passed = passed + 1 end
  end
  return passed, failed, errors
end

-- Run all .feature files in dir; return total passed, failed, errors
function M.run_features_dir(dir, tap_output)
  dir = dir or (arg[0] and arg[0]:match('^(.+)/') or '.') .. '/../features'
  if not dir:match('/$') then dir = dir .. '/' end
  local passed, failed = 0, 0
  local all_errors = {}
  local lfs = require('lfs')
  for name in lfs.dir(dir) do
    if name:match('%.feature$') then
      local p, f, errs = M.run_feature_file(dir .. name, {}, tap_output)
      passed, failed = passed + p, failed + f
      for _, e in ipairs(errs or {}) do table.insert(all_errors, e) end
    end
  end
  return passed, failed, all_errors
end

return M
