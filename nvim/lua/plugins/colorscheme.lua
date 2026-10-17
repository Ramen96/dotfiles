-- Neovim takes its colors from the terminal (see colors/ghostty.lua): the terminal's palette
-- for syntax and a transparent background. The previous Belafonte + Gruvbox Material setup is
-- saved in colorscheme.belafonte-gruvbox.lua.bak at the root of this config.

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "ghostty",
    },
    init = function()
      -- Light/dark switches are handled by Neovim re-sourcing the colorscheme. Changing the
      -- Ghostty theme itself is picked up by asking the terminal again when Neovim regains focus.
      vim.api.nvim_create_autocmd("FocusGained", {
        group = vim.api.nvim_create_augroup("ghostty_colorscheme", { clear = true }),
        callback = function()
          if vim.g.colors_name == "ghostty" then
            require("terminal_colors").query(function()
              vim.cmd.colorscheme("ghostty")
            end)
          end
        end,
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "ghostty" -- lua/lualine/themes/ghostty.lua, transparent
    end,
  },
}
