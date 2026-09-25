local mainMod     = "SUPER"
local terminal    = "kitty"
local fileManager = "thunar"
local browser     = "firefox"
local launcher    = "qs ipc call launcherWindow toggle"

-- ── Monitors ────────────────────────────────────────────────────────────────
-- Use kanshi instead
-- The leftmost output (position 0,0) is treated as primary by Hyprland.

-- ── Environment ──────────────────────────────────────────────────────────────
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- ── Autostart ────────────────────────────────────────────────────────────────
hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE && systemctl --user start graphical-session.target")
    hl.exec_cmd("wlsunset -s 19:00 -S 06:00")
    hl.exec_cmd("quickshell")
    hl.exec_cmd("kanshi")
end)

-- ── Look and feel ────────────────────────────────────────────────────────────
hl.config({
    general = {
        gaps_in     = 3,
        gaps_out    = 8,
        border_size = 2,
        col = {
            active_border   = "rgba(33ccffee)",
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing   = false,
        layout          = "dwindle",
    },
    decoration = {
        rounding       = 0,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = false,
        },
        blur = {
            enabled = false,
        },
    },
    animations = {
        enabled = true,
    },
})

hl.animation({ leaf = "global", enabled = true, speed = 4, bezier = "default" })

-- ── Layout: dwindle ──────────────────────────────────────────────────────────
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    group = {
        auto_group = false,
    },
})

hl.window_rule({
    name = "kitty-no-auto-fullscreen",
    match = { class = "kitty" },
    suppress_event = "fullscreen",
})

hl.window_rule({
    name = "kitty-no-auto-maximize",
    match = { class = "kitty" },
    suppress_event = "maximize",
})

-- ── Misc ─────────────────────────────────────────────────────────────────────
hl.config({
    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
    },
})

-- ── Input ────────────────────────────────────────────────────────────────────
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "caps:none",
        kb_rules   = "",
        repeat_delay = 150,
        repeat_rate  = 50,
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.config({
    cursor = {
        warp_on_change_workspace = 1,
    },
})

-- Launchers & apps

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Slash", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("nwg-displays"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Comma", hl.dsp.window.float({ action = "toggle" }))

-- Window ops
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle", mode = "maximized" }))
hl.bind(mainMod .. " + Semicolon", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region"))

-- Power
hl.bind(mainMod .. " + CTRL + ALT + Q", hl.dsp.exec_cmd("systemctl poweroff"))
hl.bind(mainMod .. " + CTRL + ALT + R", hl.dsp.exec_cmd("systemctl reboot"))

-- Focus — Super+hjkl
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Move window — Super+Shift+hjkl
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- Resize — Super+Ctrl+hjkl repeating for held-key resize ──────────────────────
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0,  y = 20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0,  y = -20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })

-- Switch workspace — Super+1..9 / Super+0 ─────────────────────────────────────
local function split_workspace(n)
    local monitors = hl.get_monitors()
    if #monitors == 0 then return end
    local active = hl.get_active_monitor() or monitors[1]
    local aidx = 0
    for i, m in ipairs(monitors) do
        if m.id == active.id then aidx = i - 1 end
    end
    for i, m in ipairs(monitors) do
        if m.id ~= active.id then
            local target = n + (i - 1) * 10
            if hl.get_workspace(target) then
                m:set_workspace({ workspace = target })
            else
                hl.dispatch(hl.dsp.focus({ monitor = m }))
                hl.dispatch(hl.dsp.focus({ workspace = target }))
            end
        end
    end
    hl.dispatch(hl.dsp.focus({ monitor = active }))
    hl.dispatch(hl.dsp.focus({ workspace = n + aidx * 10 }))
end

local function split_move_to_workspace(n)
    local active = hl.get_active_monitor()
    if not active then return end
    local aidx = 0
    for i, m in ipairs(hl.get_monitors()) do
        if m.id == active.id then aidx = i - 1 end
    end
    hl.dispatch(hl.dsp.window.move({ workspace = n + aidx * 10, follow = false }))
end

for i = 1, 10 do
    local key = i % 10
    local n = i
    hl.bind(mainMod .. " + " .. key,         function() split_workspace(n) end)
    hl.bind(mainMod .. " + SHIFT + " .. key, function() split_move_to_workspace(n) end)
end

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd('wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && notify-send -t 2000 Volume "$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"'), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd('wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify-send -t 2000 Volume "$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"'), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send -t 2000 Mute toggled'), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd('brightnessctl set +5% && notify-send -t 2000 Brightness +'), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd('brightnessctl set 5%- && notify-send -t 2000 Brightness -'), { locked = true, repeating = true })

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
