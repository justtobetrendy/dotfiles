local wezterm = require("wezterm")

local config = wezterm.config_builder()

--config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.font_size = 16

config.enable_tab_bar = false
config.window_decorations = "TITLE | RESIZE"
--config.color_scheme = "Nord (Gogh)"
config.color_scheme = "Catppuccin Macchiato"

return config
