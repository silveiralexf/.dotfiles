return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').setup({
        opts = {
          setup = {
            marksman = function()
              require('lazyvim.util').lsp.on_attach(function(client, _)
                if client.config.capabilities == nil then
                  client.config.capabilities = {
                    workspace = {
                      didChangeWatchedFiles = {
                        dynamicRegistration = true,
                      },
                    },
                  }
                end
              end)
            end,
          },
        },
      })
    end,
  },
}
