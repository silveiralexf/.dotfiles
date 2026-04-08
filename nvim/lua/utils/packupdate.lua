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

vim.api.nvim_create_user_command('PackUpdate', function(opts)
  if opts.bang then
    vim.pack.update(nil, { force = true })
    vim.notify('All plugins updated.', vim.log.levels.INFO)
    return
  end

  if opts.args == '' then
    vim.pack.update()
  else
    local names = vim.split(opts.args, '%s+')
    vim.pack.update(names)
  end
end, {
  desc = 'Update all vim.pack plugins (or specified ones)',
  nargs = '*',
  bang = true,
  complete = pack_complete,
})
