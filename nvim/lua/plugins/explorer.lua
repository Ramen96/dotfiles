-- Snacks explorer (<leader>e): make `H` show/hide ALL dotfiles and dot-directories.
-- By default `H` only toggles "hidden" files, while anything matched by .gitignore
-- (e.g. .env, .DS_Store) is "ignored" and needs `I`. This toggles both together.
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            actions = {
              toggle_all_hidden = function(picker)
                local show = not (picker.opts.hidden and picker.opts.ignored)
                picker.opts.hidden = show
                picker.opts.ignored = show
                picker.list:set_target()
                picker:find()
              end,
            },
            win = {
              list = {
                keys = {
                  ["H"] = "toggle_all_hidden",
                },
              },
            },
          },
        },
      },
    },
  },
}
