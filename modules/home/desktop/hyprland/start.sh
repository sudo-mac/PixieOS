#!/usr/bin/env bash

# Wallpaper Startup
swww-daemon &

# Network-Manager Startup
nm-applet --indicator &

# Waybar Startup
waybar &
iio-hyprland &

dunst
