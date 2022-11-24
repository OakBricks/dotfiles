local awful = require('awful')
local gears = require('gears')


local scripts_dir = os.getenv("HOME").."/.scripts"

local globalKeys = gears.table.join(
    awful.key({ "Mod4", }, "space",
        function()
	awful.spawn('rofi -show drun') end, {description = 'Show run menu',group='launcher'}
    ),
    awful.key({ "Mod4", "Shift", "Mod1" }, "Escape",
        function() awesome.restart() end, {description = 'Reload awesomewm',group='wm'}
    ),
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn("sh -c \""..scripts_dir.."/volctl.sh d\"", false) end),
    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn("sh -c \""..scripts_dir.."/volctl.sh u\"", false) end),
    awful.key({}, "XF86AudioMute", function()
        awful.spawn("sh -c \""..scripts_dir.."/volctl.sh m\"", false) end),
    awful.key({}, "XF86MonBrightnessDown", function()
    	awful.spawn("sh -c \""..scripts_dir.."/backlightctl.sh d\"", false) end),
    awful.key({}, "XF86MonBrightnessUp", function()
    	awful.spawn("sh -c \""..scripts_dir.."/backlightctl.sh u\"", false) end)
)

return globalKeys
