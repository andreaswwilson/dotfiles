local wezterm = require("wezterm")

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- smart-splits.nvim
-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end
local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",

	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end
config.color_scheme = "Tokyo Night"
config.font_size = 14

local longest_workspace_name_length = 0
wezterm.on("update-status", function(window, _)
	local workspace = window:active_workspace()

	-- Update longest_workspace_name_length if necessary
	if #workspace > longest_workspace_name_length then
		longest_workspace_name_length = #workspace
	end

	-- Calculate padding based on the longest workspace name
	local padded_workspace = string.format("%-" .. (longest_workspace_name_length + 2) .. "s", " " .. workspace)

	window:set_left_status(wezterm.format({
		{ Background = { Color = "#7aa2f7" } },
		{ Foreground = { Color = "#1f2335" } },
		{ Text = padded_workspace },
	}))
end)

-- Optional: Handle workspace creation/rename events to update longest_workspace_name_length more accurately
wezterm.on("workspace-created", function(window, workspace)
	if #workspace > longest_workspace_name_length then
		longest_workspace_name_length = #workspace
		window:perform_action(wezterm.action.ReloadConfiguration, window:active_pane())
	end
end)

wezterm.on("workspace-renamed", function(window, old_name, new_name)
	if #new_name > longest_workspace_name_length then
		longest_workspace_name_length = #new_name
		window:perform_action(wezterm.action.ReloadConfiguration, window:active_pane())
	elseif #old_name == longest_workspace_name_length then
		-- Recalculate the longest name if the longest one was renamed
		longest_workspace_name_length = 0
		for _, ws in ipairs(window:workspace_list()) do
			if #ws > longest_workspace_name_length then
				longest_workspace_name_length = #ws
			end
		end
		window:perform_action(wezterm.action.ReloadConfiguration, window:active_pane())
	end
end)
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = false

config.keys = {
	-- Splitting
	{
		mods = "CMD|SHIFT",
		key = "v",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	{
		mods = "CMD|SHIFT",
		key = "h",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- show the pane selection mode, but have it swap the active and selected panes
	{
		mods = "CMD|SHIFT",
		key = "s",
		action = wezterm.action.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
	-- Prompt for a name to use for a new workspace and switch to it.
	{
		key = "w",
		mods = "CMD|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						wezterm.action.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	-- Show the launcher in fuzzy selection mode and have it list all workspaces
	-- and allow activating one.
	{
		key = "e",
		mods = "CMD|SHIFT",
		action = wezterm.action.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
	-- Switch workspace
	{ key = "n", mods = "CMD|SHIFT", action = wezterm.action.SwitchWorkspaceRelative(1) },
	{ key = "p", mods = "CMD|SHIFT", action = wezterm.action.SwitchWorkspaceRelative(-1) },
	-- Rename workspace
	{
		key = "r",
		mods = "CMD|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Rename current workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line), pane)
				end
			end),
		}),
	},
	-- change tabs
	{
		key = "h",
		mods = "SUPER",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "l",
		mods = "SUPER",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	-- smart-splits.nvim
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
}

return config
