local awful = require("awful")
local gears = require("gears")

modkey = "Mod4"

clientKeys = gears.table.join(
    awful.key({ modkey, }, "q", function (c) c:kill() end,
              {description = "close", group = "client"})
)

return clientKeys
