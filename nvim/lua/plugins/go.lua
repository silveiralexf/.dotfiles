--- Go: go.nvim + DAP (dlv, dap-ui, dap-go). Build once: :lua require("go.install").update_all_sync()
return {
  specs = {
    { src = 'https://github.com/ray-x/go.nvim', name = 'go.nvim' },
    { src = 'https://github.com/ray-x/guihua.lua', name = 'guihua.lua' },
    { src = 'https://github.com/mfussenegger/nvim-dap', name = 'nvim-dap' },
    { src = 'https://github.com/leoluz/nvim-dap-go', name = 'nvim-dap-go' },
    { src = 'https://github.com/rcarriga/nvim-dap-ui', name = 'nvim-dap-ui' },
  },
  config = function()
    local go_ok, go = pcall(require, 'go')
    if go_ok and type(go) == 'table' and go.setup then
      go.setup({
        lsp_cfg = false,    -- gopls managed by lsp/servers/go.lua, not go.nvim
        lsp_codelens = true,
        diagnostic = {
          hdlr = true,
          underline = true,
          virtual_text = { spacing = 2, prefix = '' },
          signs = { '', '', '', '' },
          update_in_insert = false,
        },
        lsp_inlay_hints = { enable = false },
      })
    end

    local dap_ok, dap = pcall(require, 'dap')
    local dapui_ok, dapui = pcall(require, 'dapui')
    local dap_go_ok, dap_go = pcall(require, 'dap-go')
    if not dap_ok or not dap then
      return
    end

    if dap_go_ok and dap_go and dap_go.setup then
      dap_go.setup()
    end
    if dapui_ok and dapui and dapui.setup then
      ---@diagnostic disable: missing-fields
      dapui.setup({})
    end

    dap.adapters.go = {
      type = 'server',
      port = '${port}',
      executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
      },
    }

    if dapui and dapui.open and dapui.close then
      local open, close = function()
        dapui.open({})
      end, function()
        dapui.close({})
      end
      dap.listeners.before.attach['dapui_config'] = open
      dap.listeners.before.launch['dapui_config'] = open
      dap.listeners.after.event_initialized['dapui_config'] = open
      dap.listeners.before.event_terminated['dapui_config'] = close
      dap.listeners.before.event_exited['dapui_config'] = close
    end

    vim.keymap.set('n', '<leader>du', function()
      pcall(require('dapui').toggle, {})
    end, { desc = '[d]ap [u]i' })
    vim.keymap.set('n', '<leader>de', function()
      pcall(require('dapui').eval)
    end, { desc = '[d]ap [e]val' })
    vim.keymap.set('n', '<leader>db', function()
      require('dap').toggle_breakpoint()
    end, { desc = 'toggle [d]ebug [b]reakpoint' })
    vim.keymap.set('n', '<leader>dB', function()
      require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end, { desc = '[d]ebug [B]reakpoint' })
    vim.keymap.set('n', '<leader>dc', function()
      require('dap').continue()
    end, { desc = '[d]ebug [c]ontinue' })
    vim.keymap.set('n', '<leader>di', function()
      require('dap').step_into()
    end, { desc = '[d]ebug [i]nto' })
    vim.keymap.set('n', '<leader>do', function()
      require('dap').step_over()
    end, { desc = '[d]ebug step [o]ver' })
    vim.keymap.set('n', '<leader>dO', function()
      require('dap').step_out()
    end, { desc = '[d]ebug step [O]ut' })
    vim.keymap.set('n', '<leader>dh', function()
      require('dap').step_back()
    end, { desc = '[d]ebug step back [h]' })
    vim.keymap.set('n', '<leader>dx', function()
      require('dap').restart()
    end, { desc = '[d]ebug restart [x]' })
    vim.keymap.set('n', '<leader>dC', function()
      require('dap').run_to_cursor()
    end, { desc = '[d]ebug [C]ursor' })
    vim.keymap.set('n', '<leader>dg', function()
      require('dap').goto_()
    end, { desc = '[d]ebug [g]o to line' })
    vim.keymap.set('n', '<leader>dj', function()
      require('dap').down()
    end, { desc = '[d]ebug [j]ump down' })
    vim.keymap.set('n', '<leader>dk', function()
      require('dap').up()
    end, { desc = '[d]ebug [k]ump up' })
    vim.keymap.set('n', '<leader>dl', function()
      require('dap').run_last()
    end, { desc = '[d]ebug [l]ast' })
    vim.keymap.set('n', '<leader>dp', function()
      require('dap').pause()
    end, { desc = '[d]ebug [p]ause' })
    vim.keymap.set('n', '<leader>dr', function()
      require('dap').repl.toggle()
    end, { desc = '[d]ebug [r]epl' })
    vim.keymap.set('n', '<leader>dR', function()
      require('dap').clear_breakpoints()
    end, { desc = '[d]ebug [R]emove breakpoints' })
    vim.keymap.set('n', '<leader>ds', function()
      require('dap').session()
    end, { desc = '[d]ebug [s]ession' })
    vim.keymap.set('n', '<leader>dt', function()
      require('dap').terminate()
    end, { desc = '[d]ebug [t]erminate' })
    vim.keymap.set('n', '<leader>dw', function()
      pcall(require('dap.ui.widgets').hover)
    end, { desc = '[d]ebug [w]idgets' })
  end,
}
