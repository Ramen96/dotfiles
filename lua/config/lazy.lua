local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- 1. LazyVim Core
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        -- Set to nil or remove to let background detection work
        colorscheme = function()
          if vim.o.background == "light" then
            vim.cmd("colorscheme onelight")
          else
            vim.cmd("colorscheme onedark_dark")
          end
        end,
      },
    },

    -- 2. LANGUAGES
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.cmake" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.angular" },
    { import = "lazyvim.plugins.extras.lang.docker" },

    -- 3. THEMES
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "rebelot/kanagawa.nvim", name = "kanagawa", priority = 1000 },
    { "folke/tokyonight.nvim", name = "tokyonight", priority = 1000 },
    { "rose-pine/neovim", name = "rose-pine", priority = 1000 },
    { "sainnhe/gruvbox-material", name = "gruvbox-material", priority = 1000 },
    { "Shatur/neovim-ayu", name = "ayu", priority = 1000 },

    -- ONEDARK PRO CONFIG
    {
      "olimorris/onedarkpro.nvim",
      name = "onedark",
      priority = 1000,
      config = function()
        require("onedarkpro").setup({
          dark_theme = "onedark_dark",
          light_theme = "onelight",
          options = {
            transparency = false,
            cursorline = true,
          },
        })
      end,
    },

    -- 4. EDITOR TOOLS
    { import = "lazyvim.plugins.extras.editor.aerial" },
    { import = "lazyvim.plugins.extras.editor.outline" },

    -- 5. AUTO TAG
    {
      "windwp/nvim-ts-autotag",
      event = { "BufReadPre", "BufNewFile" },
      opts = {},
    },

    { import = "plugins" },
  },
  install = { colorscheme = { "onedark_dark", "onelight" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
