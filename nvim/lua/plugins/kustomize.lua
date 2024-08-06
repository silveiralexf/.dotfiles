-- requires kubent to be installed
-- https://github.com/doitintl/kube-no-trouble
return {
  {
    'allaman/kustomize.nvim',
    requires = 'nvim-lua/plenary.nvim',
    ft = 'yaml',
    opts = {
      enable_key_mappings = false,
      enable_lua_snip = false,
      validate = {
        kubeconform_args = { '--strict', '--ignore-missing-schemas' },
      },
      build = {
        additional_args = {
          '--enable-helm',
          '--load-restrictor=LoadRestrictionsNone',
        },
      },
    },
    keys = {
      {
        '<leader>Kb',
        function()
          require('kustomize').build()
        end,
        desc = 'build (kustomize)',
      },
      {
        '<leader>Kk',
        function()
          require('kustomize').kinds()
        end,
        desc = 'Kinds (kustomize)',
      },
      {
        '<leader>Kl',
        function()
          require('kustomize').list_resources()
        end,
        desc = 'list resources (kustomize)',
      },
      {
        '<leader>Kp',
        function()
          require('kustomize').print_resources()
        end,
        desc = 'print resources (kustomize)',
      },
      {
        '<leader>Kv',
        function()
          require('kustomize').validate()
        end,
        desc = 'validate resources (kustomize)',
      },
      {
        '<leader>Kd',
        function()
          require('kustomize').deprecations()
        end,
        desc = 'deprecations (kustomize)',
      },
    },
    config = function(_, opts)
      require('kustomize').setup(opts)
    end,
  },
}

--
