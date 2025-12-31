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
    -- add LazyVim and import its plugins
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        colorscheme = "everforest",
      },
    },

    -- 1. LANGUAGES
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.cmake" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.angular" },
    { import = "lazyvim.plugins.extras.lang.docker" },

    -- 2. Themes
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "rebelot/kanagawa.nvim", name = "kanagawa", priority = 1000 },
    { "folke/tokyonight.nvim", name = "tokyonight", priority = 1000 },
    { "rose-pine/neovim", name = "rose-pine", priority = 1000 },
    { "sainnhe/gruvbox-material", name = "gruvbox-material", priority = 1000 },
    { "EdenEast/nightfox.nvim", name = "nightfox", priority = 1000 },
    { "shaunsingh/nord.nvim", name = "nord", priority = 1000 },
    { "Shatur/neovim-ayu", name = "ayu", priority = 1000 },
    { "sainnhe/everforest", name = "everforest", priority = 1000 },
    { "olimorris/onedarkpro.nvim", name = "onedark", priority = 1000 },
    { "savq/melange-nvim", name = "melange", priority = 1000 },
    { "mcchrish/zenbones.nvim", name = "zenbones", dependencies = { "rktjmp/lush.nvim" }, priority = 1000 },

    -- 3. EDITOR TOOLS
    -- { import = "lazyvim.plugins.extras.linting.cspell" },
    { import = "lazyvim.plugins.extras.editor.aerial" },
    { import = "lazyvim.plugins.extras.editor.outline" },

    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
