local wibox = require("wibox")
local assets = os.getenv("HOME").."/.config/awesome/widgets/assets/"

local widget = wibox.widget {
    {
        id = "powericon",
        widget = wibox.widget.imagebox,
        resize = true
    },
    layout = wibox.layout.align.horizontal
}

local widget_button = 
