return {
  {
    "nvim-mini/mini.hipatterns",
    event = "BufReadPre",
    opts = function()
      local hi = require("mini.hipatterns")
      return {
        highlighters = {
          -- 1. Hex Colors (#abcdef)
          hex_color = hi.gen_highlighter.hex_color({
            style = "inline",
            inline_symbol = " [■] ",
          }),

          -- 2. Tailwind CSS Colors (e.g., bg-blue-500, text-red-200)
          -- This mimics the VSCode Tailwind extension behavior
          tailwind = hi.gen_highlighter.hex_color({
            pattern = "()%-([%w%-]+)%-(%d+)%s*",
            style = "inline",
            inline_symbol = " [■] ",
          }),

          -- 3. CSS Variables (e.g., var(--my-color))
          -- This looks for the variable usage and tries to find its hex value
          css_var = {
            pattern = "var%s*%(%s*%-%-[%w%-]+%s*%)",
            group = function(_, _, data)
              -- This finds the hex color associated with the variable if it's in the same buffer
              local var_name = data.full_match:match("var%s*%(%s*(%-%-[%w%-]+)%s*%)")
              local res = vim.api.nvim_buf_get_lines(0, 0, -1, false)
              for _, line in ipairs(res) do
                local hex = line:match(var_name .. "%s*:%s*(#[%da-fA-F]+)")
                if hex then
                  return hi.gen_highlighter
                    .hex_color({ style = "inline", inline_symbol = " [■] " })
                    .group(_, _, { full_match = hex })
                end
              end
            end,
          },
        },
      }
    end,
  },
}
