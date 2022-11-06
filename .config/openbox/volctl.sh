#!/bin/sh

VOLUME_STEPS=2

if [[ $1 = "u" ]]
then
    pamixer -i $VOLUME_STEPS
elif [[ $1 = "d" ]]
then
    pamixer -d $VOLUME_STEPS
elif [[ $1 = "m" ]]
then
    pamixer -m
fi
