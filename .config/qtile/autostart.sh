#!/bin/bash

picom & # Default picom
xrandr -s 1680x1050 # Vm issue
nitrogen --restore
nm-applet &
unclutter -root & # Hide the curse when it's not moving
dunst &
copyq &
flameshot &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
