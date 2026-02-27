return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      linters_by_ft = {
        make = { 'cmakelint' },
        cmake = { 'cmakelint' },
      },
      setup = {
        make = {},
        neocmake = {
          settings = {
            filetypes = {
              '*.mk',
              '*akefile*',
              'Makefile',
              'makefile',
              'Cmake',
              'cmake',
              'CMakeLists.txt',
            },
          },
        },
      },
    },
  },
}
