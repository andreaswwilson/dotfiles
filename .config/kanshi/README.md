# kanshi: monitor stays dark after plugging in

## Symptom

The monitor is plugged in and the kernel sees it (`/sys/class/drm/card1-DP-3/status` reads `connected`). kanshi logs `configuration for profile '…' applied`, but `swaymsg -t get_outputs` shows the output with `active: false`, and it never came on at all. When an output really does come on, waybar logs `Bar configured … for output: <name>` and swaybg logs `Found config * for output <name>`. If neither line shows up, sway never turned the output on.

The Philips and the Samsung's USB-C cable connect through a USB-C hub, and they show up as DP-1 or DP-3 depending on which laptop port is used.

## Cause

Found on 24 Sep 2026 and fixed in `bb410e3`. It takes two behaviours together:

- **Sway saves output rules by connector name.** Sway 1.11 stores every change kanshi applies as a rule for the connector (`DP-3`), not the monitor. The rule stays until sway exits or reloads. When `samsung-usbc` turns off the Samsung's USB-C copy, sway remembers "DP-3 off", and the next monitor on that port comes up off. Typing `swaymsg output DP-3 disable` by hand leaves the same kind of rule behind.
- **kanshi leaves an output as it is unless the profile says otherwise.** A profile line with neither `enable` nor `disable` keeps the output's current state (`enabled = head->enabled` in kanshi's `apply_profile`). So kanshi asks sway for "off", sway agrees, and kanshi logs success.

That's why every output line that should be on says `enable`. New profiles need it too.

Ruled out: the mode (sway accepts 3440x1440@59.973 when asked directly) and a timing race after resume from suspend.

## If it happens again

1. Check that the monitor's line in the active profile says `enable`.
2. See which profile and connector kanshi picked: `journalctl --user -u kanshi -b | tail -20`.
3. Compare with what sway actually did: `swaymsg -t get_outputs -r | jq '.[] | {name, model, active}'`, plus the waybar and swaybg lines from the Symptom section.
4. To bring the screen back, run `kanshictl reload`, which re-applies the profile even if it is already active. `kanshictl switch <active profile>` does nothing, because kanshi skips a switch to the profile it already has. `swaymsg output <name> enable` also works, but it leaves a sway rule for that connector behind.

Sway only logs errors, because it runs without `-d`. So finding no error in `journalctl --user _COMM=sway` doesn't show that nothing failed.
