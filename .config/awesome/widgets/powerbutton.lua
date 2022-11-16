local wibox = require("wibox")
local assets = os.getenv("HOME").."/.config/awesome/widgets/assets/"


panel_power_button = wibox.widget {
    {
        {
            id = "powericon",
            image = assets.."powerbutton.svg",
            widget = wibox.widget.imagebox,
            resize = true
        },
        layout = wibox.layout.fixed.horizontal
    },
    shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
    widget = wibox.container.background
}
