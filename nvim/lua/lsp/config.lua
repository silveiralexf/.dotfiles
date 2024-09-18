return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/nvim-cmp',
      'j-hui/fidget.nvim',
      'neovim/nvim-lspconfig',
      'saadparwaiz1/cmp_luasnip',
      'williamboman/mason-lspconfig',
      'williamboman/mason.nvim',
    },

    config = function()
      local cmp = require('cmp')
      local cmp_defaults = require('cmp_nvim_lsp').default_capabilities
      local client_cap = vim.lsp.protocol.make_client_capabilities
      local capabilities = vim.tbl_deep_extend('force', {}, client_cap(), cmp_defaults())
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
          end,
        },
      })

      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- For luasnip users.
        }, { { name = 'buffer' } }),
      })

      vim.diagnostic.config({
        update_in_insert = true,
        float = {
          border = 'rounded',
          focusable = false,
          header = '',
          prefix = '',
          source = 'if_many',
          style = 'minimal',
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
