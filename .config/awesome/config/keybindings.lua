local awful = require('awful')
local gears = require('gears')


globalKeys = gears.table.join(
    awful.key({ "Mod4", }, "space", 
        function() awful.spawn('rofi -show drun') end, {desciprtion = 'Show run menu',group='launcher'}
    ),
    awful.key({}, "XF86AudioLowerVolume", function ()
        awful.util.spawn("bash -c \"\"", false) end),
    awful.key({}, "XF86AudioRaiseVolume", function ()
        awful.util.spawn("pamixer -i 5", false) end),
    awful.key({}, "XF86AudioMute", function ()
        awful.util.spawn("amixer -D pulse set Master 1+ toggle", false) end)
)

return globalKeys
