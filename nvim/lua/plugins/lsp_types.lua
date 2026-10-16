return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load LazyVim types
        { name = "LazyVim", words = { "LazyVim" } },
        -- Load nvim-lspconfig types
        { path = "nvim-lspconfig", words = { "lspconfig" } },
        -- Load nvim-cmp types (to fix your first error)
        { name = "nvim-cmp" },
      },
    },
  },
}
