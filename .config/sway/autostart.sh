#!/usr/bin/env bash
set -u

count_chrome() {
  swaymsg -t get_tree | grep -c '"app_id": "google-chrome"'
}

wait_chrome_count() {
  local target=$1
  for _ in $(seq 1 20); do
    [ "$(count_chrome)" -ge "$target" ] && return 0
    sleep 0.5
  done
}

count_1password() {
  swaymsg -t get_tree | grep -c '"app_id": "1password"'
}

wait_1password_window() {
  for _ in $(seq 1 40); do
    [ "$(count_1password)" -ge 1 ] && return 0
    sleep 0.25
  done
  return 1
}

# 1. Apps placed by assign rules in workspaces.conf.
alacritty &
evolution &
slack &
spotify &
1password &
(
  wait_1password_window || exit 0
  swaymsg '[app_id="1password"] focus' >/dev/null
  pass show 1password | head -1 | wtype -s 50 -
  wtype -k Return
) &

# 2. Default profile → WS1; poll until window maps.
swaymsg 'workspace number 1; exec google-chrome --restore-last-session --profile-directory="Default"' >/dev/null
wait_chrome_count 1

# 3. CPA profile → WS3; poll until 2nd chrome window maps.
swaymsg 'workspace number 3; exec google-chrome --restore-last-session --profile-directory="Profile 1"' >/dev/null
wait_chrome_count 2

# 4. Land focus on WS2 (terminal).
swaymsg 'workspace number 2' >/dev/null
