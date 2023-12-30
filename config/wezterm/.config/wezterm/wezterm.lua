-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- For example, changing the color scheme:
config.color_scheme = 'Classic Dark (base16)'
config.font = wezterm.font 'JetBrains Mono'
config.window_background_opacity = 0.6
config.window_close_confirmation = 'NeverPrompt'
config.font_size = 9
config.hide_tab_bar_if_only_one_tab = true

--- Keybinds
config.keys = {
  {
    key = "w",
    mods = "ALT",
    action = wezterm.action.CloseCurrentPane { confirm = true }
  },
}

return config
