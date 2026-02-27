return {
  { 'simrat39/rust-tools.nvim', enabled = false },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        rust_analyzer = {},
        taplo = {
          keys = {
            {
              'K',
              function()
                if vim.fn.expand('%:t') == 'Cargo.toml' and require('crates').popup_available() then
                  require('crates').show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = 'Show Crate Documentation',
            },
          },
        },
      },
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },
  {
    'Saecki/crates.nvim',
    init = function()
      local augroup = vim.api.nvim_create_augroup('CargoCrates', { clear = true })
      vim.api.nvim_create_autocmd('BufRead', {
        group = augroup,
        pattern = 'Cargo.toml',
        callback = function()
          local crates = require('crates')
          require('which-key').register({ ['<localleader>'] = { name = 'crates ' } }, {})

          vim.keymap.set('n', '<localleader>t', crates.toggle, { desc = 'toggle' })
          vim.keymap.set('n', '<localleader>r', crates.reload, { desc = 'reload' })
          vim.keymap.set('n', '<localleader>v', crates.show_versions_popup, { desc = 'show version popup' })
          vim.keymap.set('n', '<localleader>k', crates.show_popup, { desc = 'show crate popup' })
          vim.keymap.set('n', '<localleader>f', crates.show_features_popup, { desc = 'show features popup' })
          vim.keymap.set('n', '<localleader>d', crates.show_dependencies_popup, { desc = 'show dependencies popup' })
          vim.keymap.set('n', '<localleader>u', crates.update_crate, { desc = 'update' })
          vim.keymap.set('v', '<localleader>u', crates.update_crates, { desc = 'update' })
          vim.keymap.set('n', '<localleader>a', crates.update_all_crates, { desc = 'update all' })
          vim.keymap.set('n', '<localleader>U', crates.upgrade_crate, { desc = 'upgrade' })
          vim.keymap.set('v', '<localleader>U', crates.upgrade_crates, { desc = 'upgrade' })
          vim.keymap.set('n', '<localleader>A', crates.upgrade_all_crates, { desc = 'upgrade all' })
          vim.keymap.set('n', '<localleader>H', crates.open_homepage, { desc = 'open homepage' })
          vim.keymap.set('n', '<localleader>R', crates.open_repository, { desc = 'open repository' })
          vim.keymap.set('n', '<localleader>D', crates.open_documentation, { desc = 'open documentation' })
          vim.keymap.set('n', '<localleader>C', crates.open_crates_io, { desc = 'open crates.io' })
        end,
      })
    end,
    opts = {
      popup = {
        autofocus = true,
        border = 'rounded',
      },
    },
  },
}
