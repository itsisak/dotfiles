local wezterm = require 'wezterm'
local module = {}

function module.disableKeys(keys)
    for _, key in ipairs(keys) do
        key.action = wezterm.action.DisableDefaultAssignment
    end
    return keys
end

return module

