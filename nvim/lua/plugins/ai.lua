-- AI plugins, enabled as LazyVim extras in lua/config/lazy.lua:
--   claudecode.nvim  <leader>a…  Claude Code in a split, edits shown as diffs (LazyVim defaults)
--   avante.nvim      <leader>v…  Cursor-style chat sidebar, driven by Claude Code through ACP
-- Both extras default to <leader>a, so Avante's keymaps are moved to <leader>v here.
return {
  {
    "yetone/avante.nvim",
    -- Download prebuilt libraries instead of compiling them (`make` needs a newer Rust)
    build = "bash build.sh",
    -- Required by current Avante but not yet listed in LazyVim's extra
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
    },
    opts = {
      -- Uses the installed Claude Code and its login (needs `npm i -g @zed-industries/claude-agent-acp`)
      provider = "claude-code",
      acp_providers = {
        ["claude-code"] = {
          env = {
            -- Ask before editing files or running commands (Avante defaults to bypassPermissions)
            ACP_PERMISSION_MODE = "default",
          },
        },
      },
    },
    keys = function()
      return {
        { "<leader>v", "", desc = "+avante", mode = { "n", "v" } },
        { "<leader>va", "<cmd>AvanteAsk<CR>", desc = "Ask Avante", mode = { "n", "v" } },
        { "<leader>vc", "<cmd>AvanteChat<CR>", desc = "Chat with Avante" },
        { "<leader>ve", "<cmd>AvanteEdit<CR>", desc = "Edit with Avante", mode = "v" },
        { "<leader>vf", "<cmd>AvanteFocus<CR>", desc = "Focus Avante" },
        { "<leader>vh", "<cmd>AvanteHistory<CR>", desc = "Avante History" },
        { "<leader>vm", "<cmd>AvanteModels<CR>", desc = "Select Avante Model" },
        { "<leader>vn", "<cmd>AvanteChatNew<CR>", desc = "New Avante Chat" },
        { "<leader>vp", "<cmd>AvanteSwitchProvider<CR>", desc = "Switch Avante Provider" },
        { "<leader>vr", "<cmd>AvanteRefresh<CR>", desc = "Refresh Avante" },
        { "<leader>vs", "<cmd>AvanteStop<CR>", desc = "Stop Avante" },
        { "<leader>vt", "<cmd>AvanteToggle<CR>", desc = "Toggle Avante" },
      }
    end,
  },
}
