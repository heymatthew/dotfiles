local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font("M+ 2m", { weight = "Bold" })
config.automatically_reload_config = true
config.adjust_window_size_when_changing_font_size = false
config.font_size = 14.0
config.scrollback_lines = 500000
config.enable_scroll_bar = true

-- Mimic OSX behaviour
config.quit_when_all_windows_are_closed = false

-- Rose pine: Classy minimalist
-- https://github.com/neapsix/wezterm
-- local theme = wezterm.plugin.require('https://github.com/neapsix/wezterm').main
local theme = wezterm.plugin.require('https://github.com/neapsix/wezterm').dawn
config.window_frame = theme.window_frame()
config.colors = theme.colors()

-- and finally, return the configuration to wezterm
return config
