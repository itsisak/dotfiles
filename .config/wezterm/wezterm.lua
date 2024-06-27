local wezterm = require 'wezterm'
-- local act = require 'wezterm.action'
local utils = require 'utils'
local config = {}

config.color_scheme = "Catppuccin Macchiato" -- "Night Owl (Gogh)"
config.line_height = 1.20

config.font_size = 20
config.font = wezterm.font {
    family = 'JetBrainsMono Nerd Font Propo',
    weight = 600,
    harfbuzz_features = { 'zero' }
}

config.scrollback_lines = 10000
config.audible_bell = "Disabled"

local padding = 50
config.window_padding = {
    left = 1.5 * padding,
    right = 1.5 * padding,
    top = padding, 
    bottom = padding,
}
config.window_decorations = "RESIZE"
config.adjust_window_size_when_changing_font_size = false
config.enable_tab_bar = false

config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

local keysToDisable = {
    { key = '_', mods = 'CTRL' },
    { key = '_', mods = 'SHIFT|CTRL' },
    { key = '-', mods = 'SHIFT|CTRL' }
}

local customKeyBindings = {
    -- {
        -- key = '.',
        -- mods = 'CTRL',
        -- action = act.DecreaseFontSize
    -- },
}

config.keys = utils.disableKeys(keysToDisable)

return config
