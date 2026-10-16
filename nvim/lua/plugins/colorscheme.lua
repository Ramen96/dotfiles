-- Follow the terminal's light/dark appearance (Ghostty: light:Belafonte Day, dark:TokyoNight).
-- Neovim sets 'background' from the terminal and updates it when the OS appearance changes,
-- so we only need to (re)load the matching colorscheme whenever 'background' changes.

-- Gruvbox Material (soft) with its backgrounds shifted to Belafonte Day (#d5ccba) so the
-- editor blends into the terminal and stays easy on the eyes instead of a bright cream.
local function pair(hex)
  return { hex, "NONE" }
end

local belafonte_light = {
  bg_dim = pair("#cbc2b0"),
  bg0 = pair("#d5ccba"), -- Normal background, same as Ghostty's Belafonte Day
  bg1 = pair("#cec5b3"),
  bg2 = pair("#c8bfad"),
  bg3 = pair("#c2b9a7"),
  bg4 = pair("#b9b0a0"),
  bg5 = pair("#afa697"),
  bg_statusline1 = pair("#c8bfad"),
  bg_statusline2 = pair("#c8bfad"),
  bg_statusline3 = pair("#b9b0a0"),
  bg_visual_red = pair("#d4bfaa"),
  bg_visual_yellow = pair("#dccb9f"),
  bg_visual_green = pair("#cdcaa4"),
  bg_visual_blue = pair("#c4c6b4"),
  bg_visual_purple = pair("#d0c0b4"),
  bg_diff_red = pair("#dcc2ae"),
  bg_diff_green = pair("#cccca6"),
  bg_diff_blue = pair("#c3c8b6"),
  bg_current_word = pair("#c8bfad"),
  fg0 = pair("#45373c"), -- Belafonte Day foreground
  fg1 = pair("#45373c"),
  -- Accents: more saturated than gruvbox's defaults but dark enough for ~3.7-4.1:1 contrast on #d5ccba
  red = pair("#b81c20"),
  orange = pair("#a84408"),
  yellow = pair("#8a5a0a"),
  green = pair("#62680f"),
  aqua = pair("#1a7040"),
  blue = pair("#14688c"),
  purple = pair("#a03a84"),
  -- comments and other dim text
  grey0 = pair("#6b5f54"),
  grey1 = pair("#5f564d"),
  grey2 = pair("#534848"),
}

local function apply_colorscheme()
  if vim.o.background == "light" then
    vim.g.gruvbox_material_background = "soft"
    vim.g.gruvbox_material_foreground = "mix"
    vim.g.gruvbox_material_colors_override = belafonte_light
    vim.cmd.colorscheme("gruvbox-material")
  else
    vim.cmd.colorscheme("tokyonight")
  end
end

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = apply_colorscheme,
    },
    init = function()
      -- Neovim itself re-sources the current colorscheme when 'background' changes (and does
      -- not fire OptionSet for it), so watch ColorScheme and swap if the wrong family loaded.
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("auto_colorscheme", { clear = true }),
        callback = function()
          -- LSP inlay hints (e.g. TypeScript inferred types) default to a faint grey; make them readable
          if vim.startswith(vim.g.colors_name or "", "gruvbox-material") then
            vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#5c5878", bg = "#cbc2b0", italic = true })
          end
          local wanted = vim.o.background == "light" and "gruvbox-material" or "tokyonight"
          if not vim.startswith(vim.g.colors_name or "", wanted) then
            vim.schedule(apply_colorscheme)
          end
        end,
      })
    end,
  },
}
