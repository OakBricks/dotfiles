#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

run xfsettingsd
run picom -b
run nitrogen --restore
run /usr/lib/mate-polkit/polkit-mate-authentication-agent-1
run /usr/lib/xfce4/notifyd/xfce4-notifyd
run conky -d
