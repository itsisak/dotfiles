local wezterm = require "wezterm"
local scheme = require "utils".get_color_scheme()

local sessionizer = wezterm.plugin.require "https://github.com/mikkasendke/sessionizer.wezterm"
-- local sessionizer = wezterm.plugin.require "file://" .. wezterm.home_dir .. "/.config/wezterm/plugins/sessionizer.wezterm"
local history = wezterm.plugin.require "https://github.com/mikkasendke/sessionizer-history"

local module = {}
module.config = {}

local helpers = {}
helpers.processing = {}

function helpers.processing.color(c)
    return sessionizer.for_each_entry(function(entry)
        entry.label = wezterm.format {
            { Foreground = { Color = c or scheme.foreground } },
            { Text = entry.label },
        }
    end)
end

function helpers.processing.padding(size)
    local padding = string.rep(" ", size or 2)
    return sessionizer.for_each_entry(function(entry)
        entry.label = padding .. entry.label .. padding
    end)
end

function helpers.CurrentWorkspace(opts)
    return function()
        local curr = wezterm.mux.get_active_workspace()
        return { { label = "Current (" .. curr .. ")", id = curr } }
    end
end

function helpers.directory(opts)
    return {
        opts[1],
        sessionizer.FdSearch {
            opts[1],
            fd_path = "/opt/homebrew/bin/fd",
        },
    }
end

-- init function required if async work will be done on initialization
-- function module.init()
--     <async initialization>
--     return module
-- end

local schema = {
    options = { callback = history.Wrapper(sessionizer.DefaultCallback) },

    {
        helpers.CurrentWorkspace {},
        history.MostRecentWorkspace {},
        processing = {
            helpers.processing.padding(),
            helpers.processing.color(scheme.brights[5]),
        }
    },
    {
        sessionizer.AllActiveWorkspaces { filter_default=false },
        processing = {
            sessionizer.for_each_entry(function(entry)
                entry.label = "󱂬 : " .. entry.label
            end),
            helpers.processing.padding(),
            helpers.processing.color(scheme.brights[3])
        }
    },
    {
        helpers.directory { wezterm.home_dir .. "/code/webkom" },
        helpers.directory { wezterm.home_dir .. "/code/subjects" },
        helpers.directory { wezterm.home_dir .. "/dotfiles" },
        helpers.directory { wezterm.home_dir .. "/media" },
        helpers.directory { wezterm.home_dir .. "/code/subjects" },

        wezterm.home_dir .. "/code",
        wezterm.home_dir .. "/code/it",
        wezterm.home_dir .. "/.config",

        { label = "NTNU server", id = "/Volumes/isakben/" },

        processing = helpers.processing.padding()
    },

    processing = sessionizer.for_each_entry(function(entry)
        entry.label = entry.label:gsub(wezterm.home_dir, "~")
    end)
}

module.config.keys = {
    { key = 's', mods = 'CTRL', action = sessionizer.show(schema) },
    { key = "m", mods = "CTRL", action = history.switch_to_most_recent_workspace }
}

return module
