return {
  -- Rainbow CSV (Matches mechatroner.rainbow-csv)
  {
    "mechatroner/rainbow_csv",
    ft = { "csv", "tsv", "csv_semicolon", "csv_whitespace", "csv_pipe" },
  },

  -- Symbols Outline (The sidebar on the right)
  {
    "stevearc/aerial.nvim",
    opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = { min_width = 28 },
    },
    keys = {
      { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
    },
  },

  -- Customizing Blink.cmp for "VS Code Intellisense" feel
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        ghost_text = { enabled = false }, -- Shows gray text like Copilot/Intellicode
        documentation = { auto_show = false }, -- Shows the doc popup automatically
      },
    },
  },
}
