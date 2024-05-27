-- Define the theme table
local theme = {}

-- Set the wallpaper (optional)
-- theme.wallpaper = "/path/to/your/wallpaper.jpg"

-- Set the window gaps
theme.useless_gap = 10

-- Define other theme settings as needed
theme.font          = "sans 10"
theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 2
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- taglist fonts
theme.taglist_bg_focus = "#ff0000"
theme.taglist_fg_focus = "#ffffff"
theme.taglist_bg_normal = "#000000"
theme.taglist_fg_normal = "#aaaaaa"
theme.taglist_font = "sans 12"

-- Define paths to SVG icons
local close_icon_path = "~/.config/awesome/icons/close.svg"
local maximize_icon_path = "~/.config/awesome/icons/maximize.svg"
local minimize_icon_path = "~/.config/awesome/icons/minimize.svg"

-- Load SVG icons as Cairo surfaces
local close_icon = gears.surface.load(close_icon_path)
local maximize_icon = gears.surface.load(maximize_icon_path)
local minimize_icon = gears.surface.load(minimize_icon_path)

-- Add icons to the theme table
theme.icons = {
    close = close_icon,
    maximize = maximize_icon,
    minimize = minimize_icon
}

-- Return the theme table to be used by Awesome WM
return theme
