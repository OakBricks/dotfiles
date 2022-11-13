#!/bin/sh

# CONFIGURATION
BRIGHTNESS_STEPS=5
FADING_STEPS=0
FADING_FPS=0
FADING_TIME=0
FADING_ENABLED=0

raise_brightness() {
    xbacklight -get | grep "^100" &> /dev/null
    if [[ $? == 0 ]]
    then
        canberra-gtk-play -i dialog-error
    else
        xbacklight -inc 5
    fi
}

reduce_brightness() {
    xbacklight -get | grep "^0" &> /dev/null
    if [[ $? == 0 ]]
    then
        canberra-gtk-play -i dialog-error
    else
        xbacklight -dec 5
    fi
}

if [[ $1 = "u" ]]
then
    raise_brightness
elif [[ $1 = "d" ]]
then
    reduce_brightness
fi
