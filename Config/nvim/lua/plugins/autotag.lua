return {
  "windwp/nvim-ts-autotag",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = true,
    },
    per_filetype = {
      ["html"] = {
        enable_close = true,
      },
      ["javascript"] = {
        enable_close = true,
      },
      ["typescript"] = {
        enable_close = true,
      },
      ["javascriptreact"] = {
        enable_close = true,
      },
      ["typescriptreact"] = {
        enable_close = true,
      },
      ["tsx"] = {
        enable_close = true,
      },
      ["jsx"] = {
        enable_close = true,
      },
    },
  },
}
