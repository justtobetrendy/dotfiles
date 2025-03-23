local wezterm = require("wezterm")

local config = wezterm.config_builder()

--config.font = wezterm.font("MesloLGS Nerd Font Mono")
-- config.font = wezterm.font("FiraCode Nerd Font")
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
-- config.font = wezterm.font_with_fallback {
--     'JetBrainsMono Nerd Font Mono',
--     'VictorMono Nerd Font'
-- }

config.font_rules = {
    -- {
    --     italic = true,
    --     font = wezterm.font {
    --         family = 'VictorMono Nerd Font',
    --         style = 'Italic',
    --         weight = 'Bold'
    --     },
    -- },
    {
        intensity = 'Bold',
        font = wezterm.font {
            family = 'JetBrainsMono Nerd Font Mono',
            weight = 'DemiBold'
        },
    },
}
config.font_size = 16

config.enable_tab_bar = false
config.window_decorations = "TITLE | RESIZE"
config.color_scheme = "Catppuccin Macchiato"
-- config.color_scheme = "Catppuccin Mocha"

return config
