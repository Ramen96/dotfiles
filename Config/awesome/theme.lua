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

-- Return the theme table to be used by Awesome WM
return theme
