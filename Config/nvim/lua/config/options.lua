-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local hl_groups = {
      "Normal",
      "NormalFloat",
      "FloatBorder",
      "LineNr",
      "CursorLineNr",
      "SignColumn",
      "EndOfBuffer",
      "MsgArea", -- Makes the command line area at the very bottom transparent too
    }
    for _, group in ipairs(hl_groups) do
      vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
    end
  end,
})
