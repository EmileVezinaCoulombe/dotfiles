-- Pull in the wezterm API
local wezterm = require("wezterm")
local wezterm = require("wezterm")

local config = {
	check_for_updates = false,
	font = wezterm.font("JetBrainsMono Nerd Font"),
	-- color_scheme = "Builtin Solarized Dark",
	color_scheme = "AdventureTime",
	inactive_pane_hsb = {
		hue = 1.0,
		saturation = 1.0,
		brightness = 1.0,
	},
	default_prog = { "/bin/bash", "-l" },
	font_size = 13.0,
	launch_menu = {},
	-- 	leader = { key = "a", mods = "CTRL" },
	-- 	disable_default_key_bindings = true,
	-- 	keys = {
	-- 		-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	-- 		{ key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
	-- 		{ key = "-", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	-- 		{
	-- 			key = "\\",
	-- 			mods = "LEADER",
	-- 			action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
	-- 		},
	-- 		{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
	-- 		{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	-- 		{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	-- 		{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	-- 		{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	-- 		{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	-- 		{ key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
	-- 		{ key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
	-- 		{ key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
	-- 		{ key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
	-- 		{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
	-- 		{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
	-- 		{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
	-- 		{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
	-- 		{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
	-- 		{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
	-- 		{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
	-- 		{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
	-- 		{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
	-- 		{ key = "&", mods = "LEADER|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
	-- 		{ key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
	--
	-- 		{ key = "n", mods = "SHIFT|CTRL", action = "ToggleFullScreen" },
	-- 		-- { key = "v", mods = "SHIFT|CTRL", action = "Paste" },
	-- 		-- { key = "c", mods = "SHIFT|CTRL", action = "Copy" },
	-- 	},
	-- 	set_environment_variables = {},
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.front_end = "Software" -- OpenGL doesn't work quite well with RDP.
	config.term = "" -- Set to empty so FZF works on windows
	config.default_prog = { "powershell.exe" }
	table.insert(config.launch_menu, { label = "Command", args = { "cmd.exe", "-NoLogo" } })

	-- Find installed visual studio version(s) and add their compilation
	-- environment command prompts to the menu
	for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
		local year = vsvers:gsub("Microsoft Visual Studio/", "")
		table.insert(config.launch_menu, {
			label = "x64 Native Tools VS " .. year,
			args = {
				"cmd.exe",
				"/k",
				"C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
			},
		})
	end
else
	table.insert(config.launch_menu, { label = "bash", args = { "bash", "-l" } })
	table.insert(config.launch_menu, { label = "fish", args = { "fish", "-l" } })
end

return config
