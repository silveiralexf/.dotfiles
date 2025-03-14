return {
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup({
        lsp_codelens = true,
        diagnostic = {
          hdlr = true,
          underline = true,
          virtual_text = { spacing = 2, prefix = '' },
          signs = { '', '', '', '' },
          update_in_insert = false,
        },
        lsp_inlay_hints = {
          enable = false,
        },
      })
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod', 'gowork', 'gosum', 'gotmpl', 'gohtmltmpl', 'gotexttmpl' },

    -- if you need to install/update all binaries
    build = ':lua require("go.install").update_all_sync()',
  },
  -- DAP settings for Go debugging
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    dependencies = {
      {
        'leoluz/nvim-dap-go',
        'nvim-neotest/nvim-nio',
        'williamboman/mason.nvim',
        'rcarriga/nvim-dap-ui',
        dependencies = {
          'nvim-neotest/nvim-nio',
        },
        opts = {},
        config = function(_, opts)
          local dap = require('dap')
          local dapui = require('dapui')

          require('dapui').setup()
          require('dap-go').setup()

          -- Adapters customizations
          dap.adapters.go = {
            type = 'server',
            port = '${port}',
            executable = {
              command = 'dlv',
              args = { 'dap', '-l', '127.0.0.1:${port}' },
            },
          }

          -- Events and listeners settings
          dapui.setup(opts)
          dap.listeners.before.attach['dapui_config'] = function()
            dapui.open({})
          end
          dap.listeners.before.launch['dapui_config'] = function()
            dapui.open({})
          end
          dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close({})
          end
        end,
        keys = {
          {
            '<leader>du',
            function()
              require('dapui').toggle({})
            end,
            desc = '[d]ap [u]i',
          },
          {
            '<leader>de',
            function()
              require('dapui').eval()
            end,
            desc = '[d]ap [e]val',
          },
        },
      },
    },
    keys = {
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'toggle [d]ebug [b]reakpoint',
      },
      {
        '<leader>dB',
        function()
          require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
        end,
        desc = '[d]ebug [B]reakpoint',
      },
      {
        '<leader>dc',
        function()
          require('dap').continue()
        end,
        desc = '[d]ebug [c]ontinue (start here)',
      },
      {
        '<leader>di',
        function()
          require('dap').step_into()
        end,
        desc = '[d]ebug [i]nto',
      },
      {
        '<leader>do',
        function()
          require('dap').step_over()
        end,
        desc = '[d]ebug step [o]ver',
      },
      {
        '<leader>dO',
        function()
          require('dap').step_out()
        end,
        desc = '[d]ebug step [O]ut',
      },
      {
        '<leader>dh',
        function()
          require('dap').step_back()
        end,
        desc = '[d]ebug step back [h]',
      },
      {
        '<leader>dx',
        function()
          require('dap').restart()
        end,
        desc = '[d]ebug restart [x]',
      },
      {
        '<leader>dC',
        function()
          require('dap').run_to_cursor()
        end,
        desc = '[d]ebug [C]ursor',
      },
      {
        '<leader>dg',
        function()
          require('dap').goto_()
        end,
        desc = '[d]ebug [g]o to line',
      },
      {
        '<leader>dj',
        function()
          require('dap').down()
        end,
        desc = '[d]ebug [j]ump down',
      },
      {
        '<leader>dk',
        function()
          require('dap').up()
        end,
        desc = '[d]ebug [k]ump up',
      },
      {
        '<leader>dl',
        function()
          require('dap').run_last()
        end,
        desc = '[d]ebug [l]ast',
      },
      {
        '<leader>dp',
        function()
          require('dap').pause()
        end,
        desc = '[d]ebug [p]ause',
      },
      {
        '<leader>dr',
        function()
          require('dap').repl.toggle()
        end,
        desc = '[d]ebug [r]epl',
      },
      {
        '<leader>dR',
        function()
          require('dap').clear_breakpoints()
        end,
        desc = '[d]ebug [R]emove breakpoints',
      },
      {
        '<leader>ds',
        function()
          require('dap').session()
        end,
        desc = '[d]ebug [s]ession',
      },
      {
        '<leader>dt',
        function()
          require('dap').terminate()
        end,
        desc = '[d]ebug [t]erminate',
      },
      {
        '<leader>dw',
        function()
          require('dap.ui.widgets').hover()
        end,
        desc = '[d]ebug [w]idgets',
      },
    },
  },
}
