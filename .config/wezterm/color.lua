local wezterm = require "wezterm"

local scheme = wezterm.color.get_builtin_schemes()[wezterm.GLOBAL.color_scheme]

return {
    scheme      = scheme,

    foreground  = scheme.foreground,
    background  = scheme.background,

    red         = scheme.brights[2],
    green       = scheme.brights[3],
    yellow      = scheme.brights[4],
    blue        = scheme.brights[5],
    pink        = scheme.brights[6],
    teal        = scheme.brights[7],
    surface1    = scheme.brights[8],
    surface2    = scheme.brights[9],
}
