local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local widgets = require("widgets")

local M = {}

local tasklist_action_menu = awful.menu({
    items = {
        { "Close", function() end }
    }
})

local taglist_buttons = gears.table.join()

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function(c)
        if c == client.focus then
	    c.minimized = true
	else
	    c:emit_signal(
                "request::activate",
		"tasklist",
		{raise = true}
	    )
        end
    end),
    awful.button({ }, 3, function() tasklist_action_menu.show() end)
)

function M.create_wibar(scr, btu)
    scr.barprompt = awful.widget.prompt()
    scr.bartaglist = awful.widget.taglist {
        screen = scr,
	filter = awful.widget.taglist.filter.all,
	buttons = taglist_buttons
    }
    scr.bartasklist = awful.widget.tasklist {
        screen  = scr,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout = {
            spacing = 10,
            layout = wibox.layout.flex.horizontal,
        },
        widget_template = {
            {
                {
                    {
                        id     = 'icon_role',
                        widget = wibox.widget.imagebox
                    },
                    layout = wibox.layout.flex.horizontal
                },
                left  = 10,
                right = 10,
                widget = wibox.container.margin
            },
            id = "background_role",
            widget = wibox.container.background
        }
    }
    scr.barsystray = wibox.widget.systray()
    scr.barsystray:set_base_size(24)

    scr.topbar = awful.wibar({ position = "top", screen = scr, ontop = true })
    scr.topbar:setup {
	expand = "none",
	layout = wibox.layout.align.horizontal,
	{
	    layout = wibox.layout.fixed.horizontal,
	    scr.bartaglist
	}, -- left widgets
	scr.bartasklist,
	{
	    layout = wibox.layout.fixed.horizontal,
	    spacing = 6,
	    {
		{
		    {
			layout = wibox.layout.fixed.horizontal,
			{
			    scr.barsystray,
			    top = 4,
			    right = 8,
			    widget = wibox.container.margin
			},
			{
			    shape = function(cr, w, h)
				gears.shape.partially_rounded_rect(cr, w, h, true, false, false, true, 6)
			    end,
			    bg = "#262b33",
			    widget = wibox.container.background,
			    {
			        {
				    layout = wibox.layout.fixed.horizontal,
				    widgets.panel_power_button,
			    	},
				margins = 4,
				widget = wibox.container.margin
		    	    }
		    	}
		    },
		    left = 6,
		    widget = wibox.container.margin
		},
		shape_clip = true,
		bg = btu.bg_normal,
		shape = function (cr, w, h)
		    gears.shape.rounded_rect(cr, w, h, 6)
	    	end,
		widget = wibox.container.background
	    }
	}
    }
end

return M
