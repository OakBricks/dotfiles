#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

run xsettingsd
run picom -b
run nitrogen --restore
run /usr/lib/mate-polkit/polkit-mate-authentication-agent-1
run conky -d
run blueman-applet
