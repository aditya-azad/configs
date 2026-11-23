-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")
--

-- close window
hl.unbind("SUPER + SHIFT + Q")
o.bind("SUPER + SHIFT + Q", "Close window", hl.dsp.window.close())

-- focusing window
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
hl.unbind("SUPER + L")
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))
hl.unbind("SUPER + K")
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
hl.unbind("SUPER + J")
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))

-- move window to monitor in that direction
o.bind("SUPER + SHIFT + H", "Move window to left monitor", o.workspaces.move_window_to_monitor("l"))
o.bind("SUPER + SHIFT + J", "Move window to down monitor", o.workspaces.move_window_to_monitor("d"))
o.bind("SUPER + SHIFT + K", "Move window to up monitor", o.workspaces.move_window_to_monitor("u"))
o.bind("SUPER + SHIFT + L", "Move window to right monitor", o.workspaces.move_window_to_monitor("r"))

-- applications
o.bind("SUPER + B", "Browser", { omarchy = "browser" })
o.bind("SUPER + E", "File manager", { omarchy = "nautilus" })

-- screenshot
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Screenshot", "omarchy-capture-screenshot")

-- lock screen
hl.unbind("SUPER + CTRL + L")
o.bind("SUPER + SHIFT + SEMICOLON", "Lock system", "omarchy-system-lock")
