local awful = require("awful")

awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    'dex --environment Awesome --autostart --search-paths "$HOME/.config/autostart:/etc/xdg/autostart"' -- https://github.com/jceb/dex
)

awful.spawn.with_shell("~/.config/awesome/autostart.sh")

awful.mouse.snap.edge_enabled = false
