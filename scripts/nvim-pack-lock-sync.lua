-- Sync nvim-pack-lock.json revisions to full SHAs from installed plugin dirs.
-- Run headlessly: nvim -l scripts/nvim-pack-lock-sync.lua

local pack_dir = (os.getenv('XDG_DATA_HOME') or (os.getenv('HOME') .. '/.local/share'))
  .. '/nvim/site/pack/core/opt'

local script_dir = debug.getinfo(1, 'S').source:match('^@(.+)/[^/]+$') or '.'
local lockfile = script_dir .. '/../nvim/nvim-pack-lock.json'

local f = io.open(lockfile, 'r')
if not f then
  io.stderr:write('Lockfile not found: ' .. lockfile .. '\n')
  os.exit(1)
end
local raw = f:read('*a')
f:close()

local data = vim.fn.json_decode(raw)
if type(data) ~= 'table' or type(data.plugins) ~= 'table' then
  io.stderr:write('Invalid lockfile format\n')
  os.exit(1)
end

-- Normalize a remote URL to SSH (preferred), stripping .git suffix.
local function normalize_url(url)
  url = url:gsub('%s+$', '')
  url = url:gsub('^https://github%.com/', 'ssh://git@github.com/')
  url = url:gsub('^git@github%.com:', 'ssh://git@github.com/')
  url = url:gsub('%.git$', '')
  return url
end

local updated = 0
for name, entry in pairs(data.plugins) do
  local plugin_dir = pack_dir .. '/' .. name

  local sha = vim.fn.system({ 'git', '-C', plugin_dir, 'rev-parse', 'HEAD' })
  sha = sha:gsub('%s+$', '')
  if vim.v.shell_error == 0 and sha ~= '' and entry.rev ~= sha then
    entry.rev = sha
    updated = updated + 1
  end

  local remote = vim.fn.system({ 'git', '-C', plugin_dir, 'remote', 'get-url', 'origin' })
  if vim.v.shell_error == 0 then
    local normalized = normalize_url(remote)
    if normalized ~= '' and entry.src ~= normalized then
      entry.src = normalized
      updated = updated + 1
    end
  end
end

local out = vim.fn.json_encode(data)
-- json_encode produces compact JSON; pretty-print with 2-space indent via gsub is fragile,
-- so write then reformat with a second pass using vim.fn.
-- Simpler: write compact and let the file be compact (lockfiles don't need to be pretty).
-- But to keep the existing style, use a basic pretty-printer.
local function pretty(val, indent)
  indent = indent or 0
  local pad = string.rep('  ', indent)
  local t = type(val)
  if t == 'string' then
    return vim.fn.json_encode(val)
  elseif t == 'number' or t == 'boolean' then
    return tostring(val)
  elseif t == 'table' then
    local is_array = #val > 0
    local items = {}
    if is_array then
      for _, v in ipairs(val) do
        table.insert(items, pad .. '  ' .. pretty(v, indent + 1))
      end
      return '[\n' .. table.concat(items, ',\n') .. '\n' .. pad .. ']'
    else
      local keys = {}
      for k in pairs(val) do table.insert(keys, k) end
      table.sort(keys)
      for _, k in ipairs(keys) do
        table.insert(items, pad .. '  ' .. vim.fn.json_encode(k) .. ': ' .. pretty(val[k], indent + 1))
      end
      return '{\n' .. table.concat(items, ',\n') .. '\n' .. pad .. '}'
    end
  end
  return 'null'
end

local result = pretty(data) .. '\n'
local wf = io.open(lockfile, 'w')
if not wf then
  io.stderr:write('Cannot write lockfile: ' .. lockfile .. '\n')
  os.exit(1)
end
wf:write(result)
wf:close()

print(string.format('Done. Updated %d plugin revisions in %s', updated, lockfile))
