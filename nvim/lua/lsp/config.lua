return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'j-hui/fidget.nvim',
      'neovim/nvim-lspconfig',
      'mason.nvim',
      'williamboman/mason-lspconfig',
      'williamboman/mason.nvim',
    },

    opts = function()
      local client_cap = vim.lsp.protocol.make_client_capabilities
      local capabilities = vim.tbl_deep_extend('force', {}, client_cap())
      require('fidget').setup({})
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'angularls',
          'bashls',
          'bzl',
          'clangd',
          'cmake',
          'docker_compose_language_service',
          'dockerls',
          'eslint',
          'golangci_lint_ls',
          'gopls',
          'groovyls',
          'helm_ls',
          'html',
          'htmx',
          'jdtls',
          'jsonls',
          'lua_ls',
          'marksman',
          'pylsp',
          'rust_analyzer',
          'svelte',
          'taplo',
          'terraformls',
          'tflint',
          'ts_ls',
          'vuels',
          'yamlls',
          'zls',
        },
        handlers = {
          function(server_name) -- default handler (optional)
            require('lspconfig')[server_name].setup({
              capabilities = capabilities,
            })
            -- HACK: directly forcing install while not yet supported by mason-lspconfig
            -- ref to: https://github.com/williamboman/mason-lspconfig.nvim/pull/461
            require('lspconfig').kcl.setup({})
            require('lspconfig').dagger.setup({})
          end,
        },
      })
      vim.filetype.add({
        filename = {
          ['.kube/config'] = 'yaml',
          ['gitconfig'] = 'gitconfig',
        },
        extension = {
          bzl = 'bzl',
          gohtexttmpl = 'gotmpl',
          gohtml = 'gotmpl',
          gohtmltmpl = 'gotmpl',
          gohtxttmpl = 'gotmpl',
          gotmpl = 'gotmpl',
          rasi = 'rasi',
          templ = 'templ',
        },
        pattern = {
          ['.*.hcl'] = 'terraformls',
          ['.*.tf'] = 'hcl',
          ['.*Tiltfile.*'] = 'bzl',
          ['.gohtml'] = 'gohtmltmpl',
          ['.monokle'] = 'json',
          ['PROJECT'] = 'yaml',
          ['Tiltfile'] = 'bzl',
          ['commit-msg'] = 'bash',
          ['pre-commit'] = 'bash',
          ['.*/templates/.*%.tpl'] = 'helm',
          ['.*/templates/.*%.ya?ml'] = 'helm',
          ['helmfile.*%.ya?ml'] = 'helm',
        },
      })
      ---@class PluginLspOpts
      vim.diagnostic.config({
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = 'if_many',
            prefix = '●',
            -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
            -- prefix = "icons",
          },
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
          },
        },
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      LazyVim.extend(opts.servers.vtsls, 'settings.vtsls.tsserver.globalPlugins', {
        {
          name = 'typescript-svelte-plugin',
          location = LazyVim.get_pkg_path('svelte-language-server', '/node_modules/typescript-svelte-plugin'),
          enableForWorkspaceTypeScriptVersions = true,
        },
      })
    end,
  },
}
