-- clean stale packages/plugins
local function pack_complete(arg_lead)
  arg_lead = arg_lead or ''

  return vim
    .iter(vim.pack.get())
    :map(function(pack)
      return pack.spec.name
    end)
    :filter(function(name)
      return vim.startswith(name, arg_lead)
    end)
    :totable()
end

vim.api.nvim_create_user_command('PackDelete', function(opts)
  if opts.args == '' then
    vim.notify('Usage: :PackDelete plugin-name', vim.log.levels.WARN)
    return
  end

  vim.pack.del({ opts.args }, { force = opts.bang })
end, {
  desc = 'Delete one vim.pack plugin',
  nargs = 1,
  bang = true,
  complete = pack_complete,
})

vim.api.nvim_create_user_command('PackClean', function(opts)
  local inactive = vim
    .iter(vim.pack.get())
    :filter(function(pack)
      return not pack.active
    end)
    :map(function(pack)
      return pack.spec.name
    end)
    :totable()

  if #inactive == 0 then
    vim.notify('No inactive vim.pack plugins to remove.', vim.log.levels.INFO)
    return
  end

  if opts.bang then
    vim.pack.del(inactive, { force = true })
    vim.notify('Removed: ' .. table.concat(inactive, ', '), vim.log.levels.INFO)
    return
  end

  local msg = 'Remove inactive plugins?\n\n- ' .. table.concat(inactive, '\n- ')
  local choice = vim.fn.confirm(msg, '&Yes\n&No', 2)

  if choice == 1 then
    vim.pack.del(inactive)
    vim.notify('Removed: ' .. table.concat(inactive, ', '), vim.log.levels.INFO)
  else
    vim.notify('PackClean aborted.', vim.log.levels.WARN)
  end
end, {
  desc = 'Delete inactive vim.pack plugins from disk',
  bang = true,
})
