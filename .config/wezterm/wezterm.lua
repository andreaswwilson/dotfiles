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
config.font_size = 11

config.window_padding = {
  left = 20,
  right = 0,
  top = 0,
  bottom = 30,
}

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

  -- tabs
  {
    key = "h",
    mods = "ALT|SHIFT",
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = "l",
    mods = "ALT|SHIFT",
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = "t",
    mods = "ALT|SHIFT",
    action = wezterm.action.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = "w",
    mods = "ALT|SHIFT",
    action = wezterm.action.CloseCurrentPane({ confirm = false }),
  },
}

return config
