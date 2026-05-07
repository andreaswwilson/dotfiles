#!/usr/bin/env bash
# Ordered launch — apps that share app_id are placed by switching to the
# target workspace first, then exec'ing the app inside that workspace.

set -u

# 1. Apps routed by assign rules. Fire concurrently so they map in parallel.
alacritty &
evolution &
1password &
slack &

# 2. Spotify — snap assign is unreliable; force into WS9 via pre-switch.
swaymsg 'workspace number 9; exec spotify' >/dev/null

# 3. Chrome work profile → WS1.
swaymsg 'workspace number 1; exec google-chrome --profile-directory="Default"' >/dev/null

# 4. Wait for the first Chrome window to map (poll up to 10 s) before
#    switching to WS3, so the second profile's window doesn't land on WS1.
for _ in $(seq 1 20); do
  if swaymsg -t get_tree | grep -q '"app_id": "google-chrome"'; then
    break
  fi
  sleep 0.5
done

# 5. Chrome personal profile → WS3.
swaymsg 'workspace number 3; exec google-chrome --profile-directory="Profile 1"' >/dev/null

# 6. Land focus on WS2 (terminal) as daily-driver default.
swaymsg 'workspace number 2' >/dev/null
