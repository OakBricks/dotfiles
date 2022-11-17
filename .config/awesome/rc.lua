-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

require("widgets.volume")
require("widgets.powerbutton")

local freedesktop = require("freedesktop")

modkey = "Mod4"

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/arc-dark/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

-- mymainmenu = awful.menu({ items = { { "WM", myawesomemenu, beautiful.awesome_icon },
--                                    { "Terminal", terminal }
--                                  }
--                        })

mymainmenu = freedesktop.menu.build({
    before = { {"WM", myawesomemenu} },
    sub_menu = "Apps",
    after = {
        { "Terminal", terminal }
    },
    skip_items = { "Avahi", "xfce4" }
})

mylauncher = awful.widget.launcher({ image = beautiful.menu_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%I:%M %p")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
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
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 64 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
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

    s.mysystray = wibox.widget.systray()
    s.mysystray:set_base_size(24)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, ontop = true })

    -- Add widgets to the wibox
    -- oh my goodness gracious what have i done
    s.mywibox:setup {
        expand = "none",
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            {
                {
                    mylauncher,
                    margins = 4,
                    widget = wibox.container.margin
                },
                shape = function (cr, w, h)
                    gears.shape.rounded_rect(cr, w, h, 6)
                end,
                bg = beautiful.bg_normal,
                widget = wibox.container.background,
            },
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = 6,
            {
                {
                    {
                        {
                            layout = wibox.layout.fixed.horizontal,
                            {
                                s.mysystray,
                                top = 3,
                                right = 12,
                                widget = wibox.container.margin,
                            }
                        },
                        left = 6,
                        widget = wibox.container.margin
                    },
                    bg = beautiful.bg_normal,
                    shape = function (cr, w, h)
                        gears.shape.partially_rounded_rect(cr, w, h, true, false, false, true, 6)
                    end,
                    widget = wibox.container.background
                },
                {
                    {
	                    spacing = 6,
                        layout = wibox.layout.fixed.horizontal,
                        mykeyboardlayout,
	                    volume_icon_widget,
                        mytextclock,
                        {
                            right = 4,
                            widget = wibox.container.margin
                        }
                    },
                    id = "sysinfo_widget",
                    bg = beautiful.bg_normal,
                    shape = function (cr, w, h)
                        gears.shape.partially_rounded_rect(cr, w, h, false, true, true, false, 6)
                    end,
                    widget = wibox.container.background,
                },
                layout = wibox.layout.fixed.horizontal,
                spacing = 2
            },
            {
                {
                    panel_power_button,
                    margins = 4,
                    widget = wibox.container.margin
                },
                bg = beautiful.bg_normal,
                shape = function (cr, w, h)
                    gears.shape.rounded_rect(cr, w, h, 6)
                end,
                widget = wibox.container.background
            }
        }
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local globalkeys = require("config.keybindings")

root.keys(globalkeys)

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- }}}

-- Shorter function name because why not
-- and also hard coded class names because why not
tb_trnsprncy_hlpr = function (client, color)
    if client.class == "kitty" then
        return color.."D8"
    elseif client.class == "firefox" and client.type == "normal" then
        return color.."BF"
    else
        return color
    end
end

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, { bg_normal = tb_trnsprncy_hlpr(c, beautiful.bg_normal), bg_focus = tb_trnsprncy_hlpr(c, beautiful.bg_focus) ,font = "Noto Sans", size = 32, }) : setup {
        { -- Left
            wibox.container.margin(),
            awful.titlebar.widget.titlewidget(c),
            spacing = 4,
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            {
                {
                    awful.titlebar.widget.maximizedbutton(c),
                    awful.titlebar.widget.closebutton(c),
                    spacing = 4,
                    layout = wibox.layout.fixed.horizontal()
                },
                margins = 4,
                widget = wibox.container.margin
            },
            spacing = 4,
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Set preferred icon size
awesome.set_preferred_icon_size(512)

require("rules")
require("autostart")
require("widgets")
-- }}}
