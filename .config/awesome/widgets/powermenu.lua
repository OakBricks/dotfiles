local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local button = require("widgets.util.clickablebutton")
local common = require("widgets.common")

local settings = {
    icon_size = 96,
    reboot_cmd = "systemctl reboot",
    shutdown_cmd = "systemctl shutdown",
    lock_cmd = "notify-send \"no locker present\""
}

local powermenu_window = wibox {
    ontop = true
}

local create_button = function (icon)
    local button = wibox.widget {
        {
            {
                {
                    image = icon,
                    widget = wibox.widget.imagebox
                },
                margins = 8,
                widget = wibox.container.margin
            },
            shape = function (cr, w, h)
                gears.shape.rounded_rect(cr, w, h)
            end,
            forced_width = settings.icon_size,
            forced_height = settings.icon_size,
            widget = button
        },
        margins = 6,
        widget = wibox.container.margin
    }

    return button
end

local reboot_button = create_button(common.assets_dir.."/reboot.svg")
reboot_button:connect_signal("button::release", function ()
awful.spawn.with_shell(settings.reboot_cmd)
end)

powermenu_window:setup {
    layout = wibox.layout.fixed.horizontal,
}
