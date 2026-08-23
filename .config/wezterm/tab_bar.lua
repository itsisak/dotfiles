local wezterm = require "wezterm"
local scheme = require "utils".get_color_scheme()
local module = {}
module.config = {}

module.config.enable_tab_bar = true
module.config.use_fancy_tab_bar = false 
module.config.tab_bar_at_bottom = true
module.config.show_new_tab_button_in_tab_bar = false
module.config.hide_tab_bar_if_only_one_tab = false
module.config.status_update_interval = 1000

local LEFT_HALF_CIRCLE = wezterm.nerdfonts.ple_left_half_circle_thick
local RIGHT_HALF_CIRCLE = wezterm.nerdfonts.ple_right_half_circle_thick

local function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
end

wezterm.on(
  'format-tab-title',
  function(tab, _, _, config, _, _)
    local background = scheme.background
    local foreground = scheme.foreground
    if tab.is_active then
      background = scheme.foreground
      foreground = scheme.background
    end

    local title = tab_title(tab)
    -- title = wezterm.truncate_right(title, max_width - 2)

    return {
      { Background = { Color = scheme.background } },
      { Foreground = { Color = background } },
      { Text = LEFT_HALF_CIRCLE },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = scheme.background } },
      { Foreground = { Color = background } },
      { Text = RIGHT_HALF_CIRCLE },
    }
  end
)

local function left_status(window, pane)
    local cells = {}
    table.insert(cells, { Text = " -- " })
    return cells
end

local function right_status(window, pane)
    local workspaces = wezterm.mux.get_workspace_names()
    local active = window:active_workspace()

    table.sort(workspaces)

    local cells = {}
    for _, name in ipairs(workspaces) do
        if name == active then
            table.insert(cells, { Foreground = { Color = scheme.brights[5] } })
            table.insert(cells, { Background = { Color = scheme.background } })
            table.insert(cells, { Text = LEFT_HALF_CIRCLE })
            table.insert(cells, { Foreground = { Color = scheme.background } })
            table.insert(cells, { Background = { Color = scheme.brights[5] } })
            table.insert(cells, { Text = " " .. name:gsub(wezterm.home_dir, "~") .. " " })
            table.insert(cells, { Foreground = { Color = scheme.brights[5] } })
            table.insert(cells, { Background = { Color = scheme.background } })
            table.insert(cells, { Text = RIGHT_HALF_CIRCLE })
        else
            table.insert(cells, { Foreground = { Color = scheme.foreground } })
            table.insert(cells, { Background = { Color = scheme.background } })
            table.insert(cells, { Text = "  " .. name:gsub(wezterm.home_dir, "~") .. "  " })
        end
    end
    table.insert(cells, { Foreground = { Color = scheme.foreground } })
    table.insert(cells, { Background = { Color = scheme.background } })
    table.insert(cells, { Text = " -- " })
    return cells
end

wezterm.on("update-status", function(window, pane)
    local left_cells = left_status(window, pane)
    window:set_left_status(wezterm.format(left_cells))
    local right_cells = right_status(window, pane)
    window:set_right_status(wezterm.format(right_cells))
end)


module.config.colors = {
    tab_bar = {
        background = scheme.background,
    },
}

module.config.keys = {
    { key = "n", mods = "CTRL|SHIFT", action = wezterm.action.SwitchWorkspaceRelative(1) },
    { key = "p", mods = "CTRL|SHIFT", action = wezterm.action.SwitchWorkspaceRelative(-1) }
}

return module
