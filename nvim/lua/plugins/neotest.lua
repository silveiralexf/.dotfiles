--- Neotest: <leader>tn run nearest, <leader>tf file, <leader>ts summary, etc. (nvim-nio, plenary, treesitter from other plugins)
return {
  specs = {
    { src = 'https://github.com/nvim-neotest/neotest', name = 'neotest' },
    { src = 'https://github.com/antoinemadec/FixCursorHold.nvim', name = 'FixCursorHold.nvim' },
    { src = 'https://github.com/nvim-neotest/neotest-plenary', name = 'neotest-plenary' },
    { src = 'https://github.com/nvim-neotest/neotest-vim-test', name = 'neotest-vim-test' },
    { src = 'https://github.com/fredrikaverpil/neotest-golang', name = 'neotest-golang' },
  },
  config = function()
    local neotest = require('neotest')
    if type(neotest) ~= 'table' or not neotest.setup then
      return
    end
    local adapters = {}
    local adapter_ok, golang = pcall(require, 'neotest-golang')
    if adapter_ok and golang then
      local cfg = {
        go_test_args = {
          '-v',
          '-race',
          '-count=1',
          '-timeout=60s',
          '-coverprofile=' .. vim.fn.getcwd() .. '/coverage.out',
        },
        dap_go_enabled = true,
      }
      if type(golang.setup) == 'function' then
        golang.setup(cfg)
      end
      adapters[#adapters + 1] = golang
    end
    local plenary_ok, plenary = pcall(require, 'neotest-plenary')
    if plenary_ok and plenary then
      adapters[#adapters + 1] = plenary
    end
    local vimtest_ok, vimtest = pcall(require, 'neotest-vim-test')
    if vimtest_ok and vimtest then
      adapters[#adapters + 1] = vimtest
    end
    neotest.setup({ adapters = adapters })
    vim.keymap.set('n', '<leader>ta', function()
      neotest.run.attach()
    end, { desc = '[t]est [a]ttach' })
    vim.keymap.set('n', '<leader>tf', function()
      neotest.run.run(vim.fn.expand('%'))
    end, { desc = '[t]est run [f]ile' })
    vim.keymap.set('n', '<leader>tA', function()
      neotest.run.run(vim.uv.cwd())
    end, { desc = '[t]est [A]ll files' })
    vim.keymap.set('n', '<leader>tS', function()
      neotest.run.run({ suite = true })
    end, { desc = '[t]est [S]uite' })
    vim.keymap.set('n', '<leader>tn', function()
      neotest.run.run()
    end, { desc = '[t]est [n]earest' })
    vim.keymap.set('n', '<leader>tl', function()
      neotest.run.run_last()
    end, { desc = '[t]est [l]ast' })
    vim.keymap.set('n', '<leader>ts', function()
      neotest.summary.toggle()
    end, { desc = '[t]est [s]ummary' })
    vim.keymap.set('n', '<leader>to', function()
      neotest.output.open({ enter = true, auto_close = true })
    end, { desc = '[t]est [o]utput' })
    vim.keymap.set('n', '<leader>tO', function()
      neotest.output_panel.toggle()
    end, { desc = '[t]est [O]utput panel' })
    vim.keymap.set('n', '<leader>tt', function()
      neotest.run.stop()
    end, { desc = '[t]est [t]erminate' })
    vim.keymap.set('n', '<leader>td', function()
      neotest.run.run({ suite = false, strategy = 'dap' })
    end, { desc = 'Debug nearest test' })
  end,
}
