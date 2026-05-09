return {
  {
    "frankroeder/parrot.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
      require("parrot").setup({
        providers = {
          ollama = {
            name = "ollama",
            endpoint = "http://127.0.0.1:11434/api/chat",
            model_endpoint = "http://127.0.0.1:11434/api/tags",
            api_key = "ollama",
            models = { "qwen2.5-coder:7b" },
            params = {
              chat = { temperature = 1.5, top_p = 1, num_ctx = 8192 },
              command = { temperature = 1.5, top_p = 1, num_ctx = 8192 },
            },
          },
        },
      })
    end,
    keys = {
      { "<leader>pc", "<cmd>PrtChatNew<cr>", desc = "New Ollama Chat" },
      { "<leader>pr", "<cmd>PrtRewrite<cr>", desc = "Ollama Rewrite" },
    },
  },

  -- Collama for ghost-text completions
  {
    "yuys13/collama.nvim",
    lazy = false,
    config = function()
      require("collama.preset.example").setup({
        model = "qwen2.5-coder:1.5b",
      })
      vim.keymap.set("i", "<M-j>", require("collama.copilot").accept)
    end,
  },
}
