-- Neovim takes its colors from Ghostty (see colors/ghostty.lua): the terminal's palette for
-- syntax and a transparent background. The previous Belafonte + Gruvbox Material setup is
-- saved in colorscheme.belafonte-gruvbox.lua.bak at the root of this config.

local ghostty_files = {
  vim.env.HOME .. "/.config/ghostty/config",
  vim.env.HOME .. "/.config/ghostty/themes",
}

-- Modification times of the Ghostty config and custom themes, to notice edits
local function ghostty_mtimes()
  local stamp = ""
  for _, path in ipairs(ghostty_files) do
    local stat = vim.uv.fs_stat(path)
    stamp = stamp .. (stat and stat.mtime.sec or 0) .. ":"
  end
  return stamp
end

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "ghostty",
    },
    init = function()
      -- Light/dark switches are handled by Neovim re-sourcing the colorscheme. Changing the
      -- Ghostty theme itself is picked up when Neovim regains focus.
      local last = ghostty_mtimes()
      vim.api.nvim_create_autocmd("FocusGained", {
        group = vim.api.nvim_create_augroup("ghostty_colorscheme", { clear = true }),
        callback = function()
          local now = ghostty_mtimes()
          if now ~= last and vim.g.colors_name == "ghostty" then
            last = now
            vim.cmd.colorscheme("ghostty")
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
