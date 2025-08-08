-- Pull in the wezterm API
local wezterm = require("wezterm")
local kanso = require("kanso-ink")
-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action
local mux = wezterm.mux

-- font and color-scheme
config.font_size = 13.0
config.font = wezterm.font("JetBrainsMonoNL NF")
config.color_scheme = "Arthur"

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- tab bar settings
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 32
config.colors = kanso.colors

-- make inactive pain be less visible
config.inactive_pane_hsb = {
	saturation = 0.6,
	brightness = 0.5,
}
-- set background image + make it darker for better visibility
config.window_background_image = "C:\\Users\\elias\\Pictures\\Hintergründe\\island-night.png"
config.window_background_image_hsb = {

	brightness = 0.02,
	saturation = 0.85,
	hue = 0.97,
}

-- config.window_decorations = "NONE | RESIZE"

config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 3000 }
config.keys = {
	-- open neovim in G:/Programming
	{
		key = "v",
		mods = "LEADER",
		action = act.SwitchToWorkspace({
			spawn = {
				args = { "nvim", "G:\\Programming" },
			},
		}),
	},
	-- activate CopyMode for wezterm
	{
		key = "y",
		mods = "LEADER",
		action = act.ActivateCopyMode,
	},
	-- make current pane fullscreen
	{
		key = "f",
		mods = "LEADER",
		action = act.TogglePaneZoomState,
	},
	-- create a new Tab
	{
		mods = "LEADER",
		key = "c",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	-- close current Pane
	{
		mods = "LEADER",
		key = "x",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	-- add new terminal horizontally
	{
		mods = "LEADER",
		key = "#",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- add new terminal vertically
	{
		mods = "LEADER",
		key = "-",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- activate resize mode - in that mode you can use hjkl to resize the current pane
	-- ESC to exit this mode
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},
	-- switch between panes with <LEADER> + hjkl
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },

	-- set name for current tab
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- Attach to muxer
	{
		key = "a",
		mods = "LEADER",
		action = act.AttachDomain("unix"),
	},

	-- Detach from muxer
	{
		key = "d",
		mods = "LEADER",
		action = act.DetachDomain({ DomainName = "unix" }),
	},
	-- show a list of current workspaces
	{
		key = "s",
		mods = "LEADER",
		action = act.ShowLauncherArgs({ flags = "WORKSPACES" }),
	},
	-- rename current workspace
	{
		key = "$",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for workspace",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					mux.rename_workspace(window:mux_window():get_workspace(), line)
				end
			end),
		}),
	},
}

-- display what key-table is currently active
wezterm.on("update-right-status", function(window)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

-- add possible keytables
config.key_tables = {
	resize_pane = {
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 5 }) },

		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 5 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 5 }) },

		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 5 }) },

		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 5 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 5 }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},
}

-- bind LEADER + number to switch between tabs
for i = 1, 8 do
	-- leader + number to activate that tab
	table.insert(config.keys, {
		mods = "LEADER",
		key = tostring(i),
		action = act.ActivateTab(i - 1),
	})
end

--  adds wave icon when leader is active
wezterm.on("update-right-status", function(window, _)
	local SOLID_LEFT_ARROW = ""
	local ARROW_FOREGROUND = { Foreground = { Color = "#a0a0a0" } }
	local prefix = ""

	if window:leader_is_active() then
		prefix = " " .. utf8.char(0x1f30a) -- ocean wave
		SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	end

	if window:active_tab():tab_id() ~= 0 then
		ARROW_FOREGROUND = { Foreground = { Color = "#a0a0a0" } }
	end -- arrow color based on if tab is first pane

	window:set_left_status(wezterm.format({
		{ Background = { Color = "#595959" } },
		{ Text = prefix },
		ARROW_FOREGROUND,
		{ Text = SOLID_LEFT_ARROW },
	}))
end)
-- start wezterm in maximized mode
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- automatically reload the config on changes
config.automatically_reload_config = true

-- adjust line height to remove the gap above the wezterm tabs when neovim is open for example
config.line_height = 1
-- and finally, return the configuration to wezterm
return config
