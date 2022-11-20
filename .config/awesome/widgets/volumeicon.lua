local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local volume_icon = wibox.widget.textbox()
volume_icon:set_align("center")

local volume_text = wibox.widget.textbox()
volume_text:set_align("right")

local volume_icon_widget = wibox.widget {
    {
        volume_icon,
        volume_text,
        spacing = 6,
        layout  = wibox.layout.fixed.horizontal
    },
    shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
    widget = wibox.container.background
}

function status_to_icon(input)
    local out = "null"
    if input == "muted" then
        out = "婢"
    elseif string.find(input, "%d") then
	out = "墳"
    end

    return out
end

function update_volume(icon_widget, text_widget)
    local fd = io.popen("pamixer --get-volume-human")
    local status = fd:read()
    icon_widget:set_markup("<b>"..status_to_icon(status).."</b>")
    text_widget:set_markup(status)
end

update_volume(volume_icon, volume_text)


mytimer = timer({ timeout = 0.2 })
mytimer:connect_signal("timeout", function() 
    update_volume(volume_icon, volume_text)
end)
mytimer:start()

return volume_icon_widget
