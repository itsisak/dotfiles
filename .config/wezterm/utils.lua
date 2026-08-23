local wezterm = require 'wezterm'
local module = {}

-- For local plugin development
function module.local_plugin_require(name)
    local abs_path = "file://" .. os.getenv "HOME" .. "/.config/wezterm/plugins/" .. name
    return wezterm.plugin.require(abs_path)
end

function module.toggle_tab_bar(window)
    local overrides = window:get_config_overrides() or {}
    overrides.enable_tab_bar = not overrides.enable_tab_bar
    window:set_config_overrides(overrides)
end

-- Helper function for applying same action to multiple bindings
function module.KeyAction(spec)
  local action = spec[1]
  local bindings = {}

  for i = 2, #spec do
    local value = spec[i]
    table.insert(bindings, {
      key = value.key,
      mods = value.mods,
      action = action,
    })
  end

  return table.unpack(bindings)
end

-- Merges tables
-- If options.merge is defined, those keys will be merged, not overwritten
function module.merge_config(spec)
    local ret = {}
    for key, value in ipairs(spec) do
        if key == "options" then goto continue end
        for k, v in pairs(value) do
            if ret[k] and spec.options and spec.options.merge and spec.options.merge ~= k then
                for _, item in ipairs(v) do
                    table.insert(ret[k], item)
                end
            else
                ret[k] = v
            end
        end
        ::continue::
    end
    return ret
end

function module.get_color_scheme()
    return wezterm.color.get_builtin_schemes()[wezterm.GLOBAL.color_scheme]
end

return module
