#!/bin/bash

# 1. Handle the --status flag for Waybar
if [ "$1" == "--status" ]; then
  echo "󰐥"
  exit 0
fi

# 2. Define Rofi menu options
# NOTE: You can change the icons here
shutdown="󰐥  Shutdown"
reboot="󰜉  Reboot"
lock="󰌾  Lock"
suspend="󰒲  Suspend"
logout="Log Out"

# Rofi command to show the menu
rofi_command="rofi -dmenu -i -p Power"

# 3. Show the menu and get the chosen option
options="$lock\n$reboot\n$suspend\n$shutdown\n$logout"
chosen=$(echo -e "$options" | $rofi_command)

# 4. Handle the user's choice
case "$chosen" in
"$shutdown")
  systemctl poweroff
  ;;
"$reboot")
  systemctl reboot
  ;;
"$lock")
  # Use 'hyprlock' or 'swaylock' or any other locker
  swaylock
  ;;
"$suspend")
  systemctl suspend
  ;;
"$logout")
  swaymsg exit
  ;;
esac
