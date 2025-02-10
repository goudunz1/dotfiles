local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'OneDark (base16)'
config.font = wezterm.font_with_fallback {
    { family='Monaspace Neon', weight='Regular' },
    -- { family='JetBrains Mono', weight='Regular' },
    { family='Noto Sans Mono CJK SC', weight='Regular' }
}

config.font_size = 13
config.cell_width = 0.90
config.line_height = 1.10
config.enable_scroll_bar = false
config.enable_tab_bar = false
config.window_background_opacity = 0.90

wezterm.on('gui-startup', function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config
