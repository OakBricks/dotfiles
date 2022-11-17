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
    widget = wibox.container.background
}
