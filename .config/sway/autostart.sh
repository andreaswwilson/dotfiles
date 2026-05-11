#!/usr/bin/env bash
set -u

LOCK_OK=0
WATCHDOG_PID=""

wait_sway_ready() {
  for _ in $(seq 1 50); do
    swaymsg -t get_version >/dev/null 2>&1 && return 0
    sleep 0.1
  done
  return 1
}

lock_input() {
  swaymsg 'input type:keyboard events disabled' >/dev/null 2>&1 || return 1
  swaymsg 'input type:pointer events disabled'  >/dev/null 2>&1 || return 1
  swaymsg 'input type:touchpad events disabled' >/dev/null 2>&1 || return 1
  LOCK_OK=1
}

unlock_input() {
  swaymsg 'input type:keyboard events enabled' >/dev/null 2>&1
  swaymsg 'input type:pointer events enabled'  >/dev/null 2>&1
  swaymsg 'input type:touchpad events enabled' >/dev/null 2>&1
}

cleanup() {
  unlock_input
  [ -n "$WATCHDOG_PID" ] && kill "$WATCHDOG_PID" 2>/dev/null
}

count_chrome() {
  swaymsg -t get_tree | grep -c '"app_id": "google-chrome"'
}

wait_chrome_count() {
  local target=$1
  for _ in $(seq 1 60); do
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

wait_unlock_done() {
  local pid=$1
  for _ in $(seq 1 60); do
    kill -0 "$pid" 2>/dev/null || return 0
    sleep 0.5
  done
}

trap cleanup EXIT INT TERM HUP
wait_sway_ready || exit 1
lock_input
setsid bash -c "sleep 20; \
  swaymsg 'input type:keyboard events enabled' >/dev/null 2>&1; \
  swaymsg 'input type:pointer events enabled'  >/dev/null 2>&1; \
  swaymsg 'input type:touchpad events enabled' >/dev/null 2>&1" \
  </dev/null >/dev/null 2>&1 &
WATCHDOG_PID=$!
disown

# 1. Apps placed by assign rules in workspaces.conf.
ghostty &
evolution &
slack --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations &
spotify &
1password &
(
  wait_1password_window || exit 0
  # Wait for both chromes before touching focus — prevents 2nd chrome mapping onto WS8.
  wait_chrome_count 2
  # Resolve GPG first — pinentry steals focus; wtype must not run until pinentry closes.
  PW=$(pass show 1password | head -1)
  [ -n "$PW" ] || exit 0
  [ "$LOCK_OK" = 1 ] || exit 0
  swaymsg '[app_id="1password"] focus' >/dev/null
  sleep 0.2
  printf '%s' "$PW" | wtype -s 50 -
  # Re-focus before Return: Chrome window may have mapped mid-type.
  swaymsg '[app_id="1password"] focus' >/dev/null
  wtype -k Return
) &
UNLOCK_PID=$!

# 2. Default profile → WS1; poll until window maps.
swaymsg 'workspace number 1; exec google-chrome --restore-last-session --profile-directory="Default"' >/dev/null
wait_chrome_count 1

# 3. CPA profile → WS3; poll until 2nd chrome window maps.
swaymsg 'workspace number 3; exec google-chrome --restore-last-session --profile-directory="Profile 1"' >/dev/null
wait_chrome_count 2

# 4. Wait for unlock to finish before switching to WS2 — prevents workspace switch
#    from stealing focus off 1Password mid-wtype.
wait_unlock_done "$UNLOCK_PID"
swaymsg 'workspace number 2' >/dev/null
