return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
        tsserver = {},
        clangd = {
          mason = false,
        },
      },
    },
  },
}
