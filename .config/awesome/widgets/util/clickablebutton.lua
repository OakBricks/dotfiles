local wibox = require("wibox")

function create(widget)
    local container = wibox.widget {
        widget,
        bg = "#444a58",
        widget = wibox.container.background
    }

    local old_cur, old_wibox

    container:connect_signal("mouse::enter", function ()
        container.bg = "#505666"
        local w = _G.mouse.current_wibox
        if w then
            old_cur, old_wibox = w.cursor, w
            w.cursor = "hand1"
        end
    end)

    container:connect_signal("mouse::leave", function ()
        container.bg = "#444a58"
        if old_wibox then
            old_wibox.cursor = old_cur
            old_wibox = nil
        end
    end)

    container:connect_signal("button::press", function ()
        container.bg = "#5294e2"
    end)

    container:connect_signal("button::release", function ()
        container.bg = "#444a58"
    end)

    return container
end

return create
