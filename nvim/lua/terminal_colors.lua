-- Asks the host terminal for its colors: OSC 10/11 for the foreground/background and OSC 4 for
-- the 16-color palette. The terminal answers wherever Neovim runs (locally, over SSH, ...), so
-- unlike reading Ghostty's config files this doesn't need the files on the same machine. The
-- last answer is cached so the colorscheme can be applied at startup before the terminal replies.

local M = {}

local cache_path = vim.fn.stdpath("cache") .. "/terminal_colors.lua"
local querying = false

-- The colors the colorscheme is currently built from (set by colors/ghostty.lua)
M.applied = nil

local function complete(colors)
  if type(colors) ~= "table" or not (colors.foreground and colors.background and colors.palette) then
    return false
  end
  for i = 0, 15 do
    if not colors.palette[i] then
      return false
    end
  end
  return true
end

-- "rgb:RRRR/GGGG/BBBB" (1 to 4 hex digits per channel) to "#rrggbb"
local function parse_rgb(spec)
  local channels = { spec:match("rgb:(%x+)/(%x+)/(%x+)") }
  if #channels ~= 3 then
    return
  end
  for i, channel in ipairs(channels) do
    channels[i] = math.floor(tonumber(channel, 16) / (16 ^ #channel - 1) * 255 + 0.5)
  end
  return string.format("#%02x%02x%02x", channels[1], channels[2], channels[3])
end

function M.cached()
  local ok, colors = pcall(dofile, cache_path)
  return ok and complete(colors) and colors or nil
end

-- Queries the terminal and calls `on_change(colors)` if its answer differs from M.applied.
-- Terminals that don't answer are given up on after a second.
function M.query(on_change)
  if querying or #vim.api.nvim_list_uis() == 0 then
    return
  end
  querying = true

  local colors = { palette = {} }
  local autocmd
  local function finish()
    if not querying then
      return
    end
    querying = false
    pcall(vim.api.nvim_del_autocmd, autocmd)
    if complete(colors) and not vim.deep_equal(colors, M.applied) then
      local f = io.open(cache_path, "w")
      if f then
        f:write("return " .. vim.inspect(colors) .. "\n")
        f:close()
      end
      on_change(colors)
    end
  end

  autocmd = vim.api.nvim_create_autocmd("TermResponse", {
    callback = function(ev)
      local sequence = ev.data.sequence
      local index, spec = sequence:match("\027%]4;(%d+);(rgb:[%x/]+)")
      if index and tonumber(index) < 16 then
        colors.palette[tonumber(index)] = parse_rgb(spec)
      end
      local code
      code, spec = sequence:match("\027%](1[01]);(rgb:[%x/]+)")
      if code then
        colors[code == "10" and "foreground" or "background"] = parse_rgb(spec)
      end
      if complete(colors) then
        vim.schedule(finish)
      end
    end,
  })

  local request = "\027]10;?\027\\\027]11;?\027\\"
  for i = 0, 15 do
    request = request .. "\027]4;" .. i .. ";?\027\\"
  end
  vim.api.nvim_ui_send(request)
  vim.defer_fn(finish, 1000)
end

return M
