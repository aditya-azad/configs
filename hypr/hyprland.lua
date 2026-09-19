-- ─────────────────────────────────────────────────────────────────────────────
-- hyprland.lua — Hyprland config for legion7i (Ubuntu 26.04, via hyprbuntu).
--
-- Mirrors the GNOME + pop-shell bindings/settings from tasks/gnome.yml and
-- tasks/popshell.yml:
--   • 10 static workspaces; Super+1..9 / Super+0 switch (ws 10 = key 0),
--     Super+Shift+1..9 / Super+Shift+0 move window to workspace (silent).
--   • Tiling gaps 2/2, active-window border, rounding 0, animations off, dwindle.
--   • caps:none, keyboard repeat delay 150.
--   • Light theme (Adwaita/Yaru/prefer-light set via gsettings in the task),
--     light wallpaper via swaybg, night light 19:00→06:00 via wlsunset.
--
-- Uses the hypr* ecosystem that hyprbuntu.sh builds from source:
--   hyprlauncher (app launcher), hyprlock (screen locker), hyprshot (screenshots),
--   waybar (status bar). hypridle/hyprpolkitagent/swaync start as systemd user
--   services via uwsm's graphical-session.target.
--
-- Mod is Super (matches GNOME/pop-shell Super-based bindings).
-- Lua API: https://wiki.hypr.land/configuring/  (hl.* — example/hyprland.lua)
-- ─────────────────────────────────────────────────────────────────────────────

local mainMod     = "SUPER"
local terminal    = "kitty"
local fileManager = "nautilus"
local browser     = "brave"
local launcher    = "hyprlauncher"  -- hyprbuntu's launcher

-- ── Monitors ────────────────────────────────────────────────────────────────
-- Auto: preferred mode, auto position, auto scale. GNOME's
-- workspaces-only-on-primary has no direct Hyprland equivalent.
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- ── Environment ──────────────────────────────────────────────────────────────
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- ── Autostart ────────────────────────────────────────────────────────────────
-- Wallpaper: handled by hyprpaper (systemd user service, started via uwsm's
-- graphical-session.target). Its config ~/.config/hypr/hyprpaper.conf is written
-- by the `st` theme-switch setter, so the wallpaper follows your dark/light
-- toggle — do NOT launch a wallpaper daemon here.
-- Night light: 19:00 sunset → 06:00 sunrise (GNOME night-light schedule).
-- waybar: status bar (installed by hyprbuntu, not a service → launch here).
hl.on("hyprland.start", function()
    hl.exec_cmd("wlsunset -s 19:00 -S 06:00")
    hl.exec_cmd("waybar")
end)

-- ── Look and feel ───────────────────────────────────────────────────────────
-- pop-shell: gap-outer 2 / gap-inner 2 → gaps_out / gaps_in.
-- active-hint true → visible active border (border_size 2).
-- active-hint-border-radius 0 → rounding 0. enable-animations false → animations off.
hl.config({
    general = {
        gaps_in     = 2,
        gaps_out    = 2,
        border_size = 2,
        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
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
        enabled = false,
    },
})

-- ── Layout: dwindle (pop-shell-like bsp tiling) ────────────────────────────
hl.config({
    dwindle = {
        pseudotile    = true,  -- pop-shell-ish; window keeps size when tiled
        preserve_split = true,
    },
})

-- ── Misc ─────────────────────────────────────────────────────────────────────
hl.config({
    misc = {
        force_default_wallpaper  = 0,    -- no anime mascot wallpaper
        disable_hyprland_logo    = true,
        disable_splash           = true,
        suppress_portal_warnings = true,  -- recommended for source-built Hyprland
    },
})

-- ── Input ────────────────────────────────────────────────────────────────────
-- xkb-options caps:none; keyboard delay 150 (GNOME peripherals.keyboard delay).
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

-- ─────────────────────────────────────────────────────────────────────────────
-- Keybindings
-- ─────────────────────────────────────────────────────────────────────────────

-- Launchers & apps ────────────────────────────────────────────────────────────
-- Super+Return → terminal (pop-shell default; GNOME default terminal = kitty).
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
-- Super+/ → launcher (pop-shell search; hyprbuntu's hyprlauncher).
hl.bind(mainMod .. " + Slash", hl.dsp.exec_cmd(launcher))
-- Super+B → browser (GNOME www keybinding; default browser = brave).
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
-- Super+E → files (GNOME home keybinding).
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
-- Super+, → toggle floating/tiling (pop-shell toggle-tiling).
hl.bind(mainMod .. " + Comma", hl.dsp.window.float({ action = "toggle" }))

-- Window ops ──────────────────────────────────────────────────────────────────
-- Super+Shift+Q → close window (GNOME wm.keybindings close).
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
-- Super+F → toggle maximize (GNOME toggle-maximized).
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle", mode = "maximized" }))
-- Super+Shift+Colon → lock screen (GNOME screensaver). hyprlock from hyprbuntu.
hl.bind(mainMod .. " + SHIFT + Colon", hl.dsp.exec_cmd("hyprlock"))
-- Super+Shift+S → screenshot (GNOME show-screenshot-ui). hyprshot region capture.
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region"))

-- Power ────────────────────────────────────────────────────────────────────────
-- Super+Ctrl+Alt+Q → shutdown (GNOME custom0).
hl.bind(mainMod .. " + CTRL + ALT + Q", hl.dsp.exec_cmd("systemctl poweroff"))
-- Super+Ctrl+Alt+R → restart (GNOME custom1).
hl.bind(mainMod .. " + CTRL + ALT + R", hl.dsp.exec_cmd("systemctl reboot"))

-- Focus — Super+hjkl (pop-shell default) ─────────────────────────────────────
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Move window — Super+Shift+hjkl (GNOME move-to-monitor-*).
-- Uses the valid `direction` move form; in multi-monitor setups this moves the
-- window toward the adjacent monitor when at the edge (closest Hyprland
-- equivalent to GNOME's move-to-monitor).
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- Resize — Super+Ctrl+hjkl (pop-shell resize). repeating for held-key resize.
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0,  y = 20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0,  y = -20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })

-- Switch workspace — Super+1..9 / Super+0 (GNOME switch-to-workspace-N, ws10=0)
-- Move window to workspace (silent) — Super+Shift+1..9 / Super+Shift+0
-- (GNOME move-to-workspace-N). follow=false keeps focus on current workspace.
for i = 1, 10 do
    local key = i % 10  -- workspace 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,            hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,    hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Mouse binds (Hyprland defaults) ─────────────────────────────────────────────
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })