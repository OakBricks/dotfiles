local awful = require('awful')
local gears = require('gears')


globalKeys = gears.table.join(
    awful.key({ "Mod4", }, "space", 
        function() awful.spawn('rofi -show drun') end, {desciprtion = 'Show run menu',group='launcher'}
    )
)

return globalKeys
