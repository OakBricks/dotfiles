local wibox = require("wibox")

local bg = wibox.container.background()
bg:set_bg("#000000")

local textbox1 = wibox.widget.textbox("penis balls")

local l = wibox.layout.fixed.vertical()
l:add(textbox1)

bg:set_widget(l)
