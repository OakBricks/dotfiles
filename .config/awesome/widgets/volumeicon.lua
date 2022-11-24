local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local config = {
    high = "墳 ",
    medium = "奔 ",
    low = "奄 ",
    muted = "婢 ",
    unknown = " "
}

local volume_icon = wibox.widget.textbox()
volume_icon:set_align("right")

local volume_text = wibox.widget.textbox()
volume_text:set_align("right")

local volume_icon_widget = wibox.widget {
    {
        volume_icon,
        volume_text,
        spacing = 4,
        layout  = wibox.layout.fixed.horizontal
    },
    shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
    widget = wibox.container.background
}

local function volume_to_icon(input)
    local out = config.unknown
    if input == "muted" then
        out = config.muted
    else
        if tonumber(input) > 50 then
	    out = config.high
        elseif tonumber(input) <= 50 then
            out = config.medium
        elseif tonumber(input) <= 25 then
            out = config.low
        end
    end

    return out
end

local function update_volume(icon_widget, text_widget)
    awful.spawn.easy_async_with_shell("amixer sget Master", function (out)
        local volume = string.match(out, "(%d?%d?%d)%%")
        local status = string.match(out, "%[(o[^%]]*)%]")
        if status == "off" then
            volume = "muted"
        end
        icon_widget:set_markup("<b>"..volume_to_icon(volume).."</b>")
        text_widget:set_markup(volume)
    end)
end

update_volume(volume_icon, volume_text)

volume_update_timer = gears.timer({ timeout = 0.5 })
volume_update_timer:connect_signal("timeout", function() 
    update_volume(volume_icon, volume_text)
end)
volume_update_timer:start()

return volume_icon_widget
