--- LSP: nvim-lspconfig, mason, mason-lspconfig, fidget. Servers from lua/lsp/servers (registered in pack_after).
return {
  specs = {
    { src = 'https://github.com/neovim/nvim-lspconfig', name = 'nvim-lspconfig' },
    { src = 'https://github.com/j-hui/fidget.nvim', name = 'fidget.nvim' },
    { src = 'https://github.com/mason-org/mason.nvim', name = 'mason.nvim' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim', name = 'mason-lspconfig.nvim' },
  },
  config = function()
    local mason_ok, mason = pcall(require, 'mason')
    if mason_ok and mason then
      mason.setup({})
    end
    local mlsp_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
    if mlsp_ok and mason_lspconfig then
      mason_lspconfig.setup({
        ensure_installed = {
          'clangd', 'cmake', 'gopls', 'helm_ls', 'jdtls', 'jsonls', 'marksman', 'pylsp', 'taplo',
        },
      })
    end
    local fidget_ok, fidget = pcall(require, 'fidget')
    if fidget_ok and fidget then
      fidget.setup({})
    end
  end,
}
