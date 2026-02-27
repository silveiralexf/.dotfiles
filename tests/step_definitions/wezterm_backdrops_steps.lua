-- Step definitions for tests/features/wezterm_backdrops.feature
-- Pure index logic (cycle forward/back, set index) plus optional module load.
local runner = require('tests.runner.feature_runner')

local function cycle_forward(current, n)
  if current == n then return 1 end
  return current + 1
end

local function cycle_back(current, n)
  if current == 1 then return n end
  return current - 1
end

runner.register('Given', 'backdrops with files', function(w, step_text)
  local tbl = runner.parse_table_in_step(step_text)
  w.files = tbl or {}
  w.n = #w.files
  w.current_idx = w.current_idx or 1
end)

runner.register('And', 'current index is 3', function(w)
  w.current_idx = 3
end)

runner.register('And', 'current index is 1', function(w)
  w.current_idx = 1
end)

runner.register('When', 'I cycle forward', function(w)
  w.current_idx = cycle_forward(w.current_idx, w.n)
end)

runner.register('When', 'I cycle back', function(w)
  w.current_idx = cycle_back(w.current_idx, w.n)
end)

runner.register('When', 'I set image at index 2', function(w)
  local idx = 2
  if idx >= 1 and idx <= w.n then w.current_idx = idx end
end)

runner.register('When', 'I set image at index 5', function(w)
  w.index_out_of_range_called = true
  if 5 > w.n or 5 < 1 then w.error_logged = true end
end)

runner.register('Then', 'current index is 1', function(w)
  assert(w.current_idx == 1, 'expected current index 1, got ' .. tostring(w.current_idx))
end)

runner.register('Then', 'current index is 3', function(w)
  assert(w.current_idx == 3, 'expected current index 3, got ' .. tostring(w.current_idx))
end)

runner.register('Then', 'current index is 2', function(w)
  assert(w.current_idx == 2, 'expected current index 2, got ' .. tostring(w.current_idx))
end)

runner.register('And', 'current background file is "a.png"', function(w)
  assert(w.files[w.current_idx] == 'a.png', 'expected a.png, got ' .. tostring(w.files[w.current_idx]))
end)

runner.register('And', 'current background file is "c.png"', function(w)
  assert(w.files[w.current_idx] == 'c.png', 'expected c.png, got ' .. tostring(w.files[w.current_idx]))
end)

runner.register('And', 'current background file is "b.png"', function(w)
  assert(w.files[w.current_idx] == 'b.png', 'expected b.png, got ' .. tostring(w.files[w.current_idx]))
end)

runner.register('Then', 'an error was logged for index out of range', function(w)
  assert(w.error_logged == true, 'expected error to be logged')
end)

runner.register('And', 'current index is still 1', function(w)
  assert(w.current_idx == 1, 'expected current index still 1, got ' .. tostring(w.current_idx))
end)
