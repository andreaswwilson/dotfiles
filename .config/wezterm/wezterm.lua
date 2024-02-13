local wezterm = require("wezterm")
return {
	color_scheme = "Catppuccin Mocha",
	enable_tab_bar = false,
	font_size = 14.0,
	macos_window_background_blur = 30,

	initial_rows = 40,
	initial_cols = 120,
	window_background_opacity = 1.0,
	-- window_decorations = "RESIZE",
	native_macos_fullscreen_mode = true,
	keys = {
		{
			key = "f",
			mods = "CTRL",
			action = wezterm.action.ToggleFullScreen,
		},
	},
	mouse_bindings = {
		-- Ctrl-click will open the link under the mouse cursor
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},
	wezterm.on("gui-startup", function(cmd)
		local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
		window:gui_window():maximize()
	end),

	-- needed for zen-mode 	https://github.com/folke/zen-mode.nvim
	wezterm.on("user-var-changed", function(window, pane, name, value)
		local overrides = window:get_config_overrides() or {}
		if name == "ZEN_MODE" then
			local incremental = value:find("+")
			local number_value = tonumber(value)
			if incremental ~= nil then
				while number_value > 0 do
					window:perform_action(wezterm.action.IncreaseFontSize, pane)
					number_value = number_value - 1
				end
				overrides.enable_tab_bar = false
			elseif number_value < 0 then
				window:perform_action(wezterm.action.ResetFontSize, pane)
				overrides.font_size = nil
				overrides.enable_tab_bar = true
			else
				overrides.font_size = number_value
				overrides.enable_tab_bar = false
			end
		end
		window:set_config_overrides(overrides)
	end),
}
