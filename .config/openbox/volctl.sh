#!/bin/sh

if [[ $1 = "u" ]]
then
    pamixer -i 5
elif [[ $1 = "d" ]]
then
    pamixer -d 5
elif [[ $1 = "m" ]]
then
    pamixer -m
fi
