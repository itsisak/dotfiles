local wezterm = require "wezterm"
local module = {}

local schemes = wezterm.color.get_builtin_schemes()
local colors = schemes["Catppuccin Macchiato"]

local LEFT_HALF_CIRCLE = wezterm.nerdfonts.ple_left_half_circle_thick
local RIGHT_HALF_CIRCLE = wezterm.nerdfonts.ple_right_half_circle_thick

local bg = colors.background
local fg = colors.foreground
local active_tab_bg = colors.cursor_bg
local active_tab_fg = colors.cursor_fg

local function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
end

-- wezterm.on(
--   'format-tab-title',
--   function(tab, _, _, config, _, _)
--     local palette = config.resolved_palette
--     local edge_background = bg
--     local background = colors.background
--     local foreground = colors.foreground

--     if tab.is_active then
--       background = colors.foreground
--       foreground = colors.background
--     end

--     local edge_foreground = background

--     local title = tab_title(tab)
--     -- title = wezterm.truncate_right(title, max_width - 2)

--     return {
--       { Background = { Color = edge_background } },
--       { Foreground = { Color = edge_foreground } },
--       { Text = LEFT_HALF_CIRCLE },
--       { Background = { Color = background } },
--       { Foreground = { Color = foreground } },
--       { Text = title },
--       { Background = { Color = edge_background } },
--       { Foreground = { Color = edge_foreground } },
--       { Text = RIGHT_HALF_CIRCLE },
--     }
--   end
-- )
    
return module
