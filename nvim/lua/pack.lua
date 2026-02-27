--- Pack aggregator: collect vim.pack.Spec from lua/plugins/*.lua and register lazy triggers.
--- Requires Neovim 0.12+ (vim.pack). Preserves keybindings; plugins in pack/core/opt.

local M = {}

--- Directory for vim.pack-style plugin modules (return { specs = {...}, lazy = {...} }).
--- Use plugins_pack/ during migration; can merge into plugins/ when done.
local PACK_PLUGIN_DIR = 'plugins_pack'

local function collect_plugin_modules()
  local config = vim.fn.stdpath('config')
  local plugin_dir = config .. '/lua/' .. PACK_PLUGIN_DIR
  local pattern = plugin_dir .. '/*.lua'
  local files = vim.fn.glob(pattern, true, true) or {}
  local modules = {}
  for _, path in ipairs(files) do
    local basename = vim.fn.fnamemodify(path, ':t:r')
    if basename and basename ~= '' then
      table.insert(modules, PACK_PLUGIN_DIR .. '.' .. basename)
    end
  end
  return modules
end

local function load_module_specs(module_name)
  local ok, mod = pcall(require, module_name)
  if not ok or type(mod) ~= 'table' then
    return nil, nil
  end
  local specs = mod.specs or mod
  if type(specs) ~= 'table' then
    specs = {}
  end
  -- Allow single spec: { src = '...', name = '...' }
  if specs.src then
    specs = { specs }
  end
  local lazy = type(mod.lazy) == 'table' and mod.lazy or nil
  return specs, lazy
end

local function register_lazy_trigger(name, trigger)
  if trigger.ft and #trigger.ft > 0 then
    vim.api.nvim_create_autocmd('FileType', {
      pattern = trigger.ft,
      callback = function()
        vim.cmd.packadd(name)
      end,
      once = true,
    })
  end
  if trigger.cmd and #trigger.cmd > 0 then
    for _, cmd in ipairs(trigger.cmd) do
      -- When user runs :Foo, load plugin then re-dispatch (once: after packadd, command exists)
      vim.api.nvim_create_autocmd('CmdUndefined', {
        pattern = cmd,
        callback = function(info)
          vim.cmd.packadd(name)
          vim.schedule(function()
            vim.cmd(('%s'):format(info.match))
          end)
        end,
        once = true,
      })
    end
  end
  if trigger.keys and #trigger.keys > 0 then
    for _, key in ipairs(trigger.keys) do
      local mode = 'n'
      local key_str = key
      if type(key) == 'table' then
        mode = key[1] or 'n'
        key_str = key[2] or key[1]
      end
      vim.keymap.set(mode, key_str, function()
        vim.cmd.packadd(name)
        vim.keymap.del(mode, key_str)
        vim.schedule(function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key_str, true, false, true), mode, false)
        end)
      end, { desc = 'packadd ' .. name })
    end
  end
end

function M.setup()
  if not vim.pack or not vim.pack.add then
    vim.notify('vim.pack not available (Neovim 0.12+ required)', vim.log.levels.WARN)
    return
  end

  local all_specs = {}
  local lazy_specs = {} -- { { names = { ... }, lazy = {...} }, ... }

  for _, module_name in ipairs(collect_plugin_modules()) do
    local specs, lazy = load_module_specs(module_name)
    if specs and #specs > 0 then
      if lazy and (lazy.ft or lazy.cmd or lazy.keys) then
        local names = {}
        for _, s in ipairs(specs) do
          local n = s.name or (s.src and vim.fn.fnamemodify(s.src:gsub('%.git$', ''), ':t') or nil)
          if n then
            table.insert(names, n)
          end
        end
        if #names > 0 then
          table.insert(lazy_specs, { names = names, lazy = lazy })
          for _, s in ipairs(specs) do
            table.insert(all_specs, s)
          end
        else
          for _, s in ipairs(specs) do
            table.insert(all_specs, s)
          end
        end
      else
        for _, s in ipairs(specs) do
          table.insert(all_specs, s)
        end
      end
    end
  end

  -- Install all; load eager (no lazy) now; lazy ones stay opt until trigger
  local eager_specs = {}
  for _, s in ipairs(all_specs) do
    local is_lazy = false
    for _, entry in ipairs(lazy_specs) do
      local n = s.name or (s.src and vim.fn.fnamemodify(s.src:gsub('%.git$', ''), ':t') or nil)
      for _, name in ipairs(entry.names) do
        if name == n then
          is_lazy = true
          break
        end
      end
      if is_lazy then break end
    end
    if not is_lazy then
      table.insert(eager_specs, s)
    end
  end

  if #eager_specs > 0 then
    vim.pack.add(eager_specs, { load = true, confirm = false })
  end

  local lazy_names_set = {}
  for _, entry in ipairs(lazy_specs) do
    for _, name in ipairs(entry.names) do
      lazy_names_set[name] = true
    end
  end
  local lazy_only_specs = {}
  for _, spec in ipairs(all_specs) do
    local n = spec.name or (spec.src and vim.fn.fnamemodify(spec.src:gsub('%.git$', ''), ':t') or nil)
    if n and lazy_names_set[n] then
      table.insert(lazy_only_specs, spec)
    end
  end
  if #lazy_only_specs > 0 then
    vim.pack.add(lazy_only_specs, { load = false, confirm = false })
  end
  for _, entry in ipairs(lazy_specs) do
    for _, name in ipairs(entry.names) do
      register_lazy_trigger(name, entry.lazy)
    end
  end

  -- PackChanged: notify on update for critical plugins (optional hook)
  local critical_plugins = { ['noice.nvim'] = true, ['yazi.nvim'] = true, ['nvim-treesitter'] = true }
  vim.api.nvim_create_autocmd('User', {
    pattern = 'PackChanged',
    callback = function(data)
      local ev = type(data) == 'table' and data or {}
      if ev.kind == 'update' and ev.spec and critical_plugins[ev.spec.name] then
        vim.notify(('Pack updated: %s'):format(ev.spec.name), vim.log.levels.INFO)
      end
    end,
  })
end

return M
