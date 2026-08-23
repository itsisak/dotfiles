local wezterm = require 'wezterm'
local utils = require 'utils'

-- Globals
wezterm.GLOBAL.color_scheme = "Catppuccin Mocha" -- "Night Owl (Gogh)"
-- wezterm.GLOBAL.color_scheme = 'Night Owl (Gogh)'

-- Generic config
local config = wezterm.config_builder()

config.color_scheme = wezterm.GLOBAL.color_scheme
config.line_height = 1.00

config.font_size = 16
config.font = wezterm.font {
    family = 'JetBrainsMono Nerd Font Propo',
    weight = 600,
    harfbuzz_features = { 'zero' }
}

config.scrollback_lines = 10000
config.audible_bell = "Disabled"

local padding = 30
config.window_padding = {
    left = 1.5 * padding,
    right = 1.5 * padding,
    top = padding,
    bottom = padding,
}
config.window_decorations = "RESIZE"
config.adjust_window_size_when_changing_font_size = false
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

wezterm.on('gui-startup', function(cmd)
    local _, _, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

-- Keybindings
config.keys = {
    { key = 'L', mods = 'CTRL', action = wezterm.action.ShowDebugOverlay },

    utils.KeyAction {
        wezterm.action.DisableDefaultAssignment,
        { key = '_', mods = 'CTRL' },
        { key = '_', mods = 'SHIFT|CTRL' },
        { key = '-', mods = 'SHIFT|CTRL' }
    },
}

-- Merge config modules
return utils.merge_config {
    options = { merge = { "keys" } },
    config,
    require "sessionizer".config,
}
