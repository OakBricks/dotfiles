#!/bin/sh

# Settings
VOLUME_STEPS=2

if [[ $1 = "u" ]]
then
    amixer set Master $VOLUME_STEPS%+
elif [[ $1 = "d" ]]
then
    amixer set Master $VOLUME_STEPS%-
elif [[ $1 = "m" ]]
then
    amixer set Master toggle
fi
