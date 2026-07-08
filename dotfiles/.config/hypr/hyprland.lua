-- =============================================================================
-- HYPRLAND MAIN CONFIGURATION
-- =============================================================================

-- 1. General Settings
hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 5,
        border_size = 2,
        col = {
            active_border = {
                colors = {"rgba(33ccffee)", "rgba(00ff99ee)"},
                angle = 45,
            },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "master",
    },
    decoration = {
        rounding = 6,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 0.97,
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

-- Curves and Animations
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "easeOutQuint", style = "popin 33%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "linear", style = "popin 10%" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3, bezier = "easeOutQuint" })

-- Per-device settings
hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- Additional config (dwindle, misc, input)
hl.config({
    group = {
        groupbar = {
            enabled = true,
            height = 24,
            text_color = "rgba(eeeeeeff)",
            text_color_inactive = "rgba(aaaaaaff)",
            rounding = 6,
            font_size = 16,
        },
    },
    dwindle = {
        preserve_split = true,
    },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },
    input = {
        kb_layout = "us,fr",
        kb_variant = "intl",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})

-- 2. Environment
hl.env("XCURSOR_SIZE", "48")
hl.env("HYPRCURSOR_SIZE", "48")
hl.env("QT_QPA_PLATFORMTHEME", "kde")

-- 3. Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("kitty")
    hl.exec_cmd("waybar")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hyprctl setcursor Oxygen_Blue 48")
    hl.exec_cmd("hypridle &")
    hl.exec_cmd("wl-paste --primary --watch wl-copy &")
end)

-- 4. Keybindings
local mainMod = "SUPER"
local terminal = "kitty"
local fileManager = "dolphin"
local ws = require("workspace")

-- Special Actions
hl.bind(mainMod .. " + ALT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + ALT + Delete", hl.dsp.exec_cmd("~/.config/hypr/lock.sh"))
hl.bind(mainMod .. " + ALT + U", hl.dsp.exec_cmd("~/.config/hypr/change-kbd.sh"))
hl.bind(mainMod .. " + ALT + S", hl.dsp.exec_cmd("~/.config/hypr/switch-monitor.py -e 0 && sleep 2 && systemctl suspend"))
hl.bind(mainMod .. " + ALT + P", hl.dsp.exec_cmd("kitty --title popup hyprmon --profiles"))

-- Workspaces
hl.bind(mainMod .. " + BackSpace", hl.dsp.focus({ workspace = "previous" }))

for i = 1, 10 do
    local idx = i
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, function() ws.toggle(idx) end)
end

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + M", function() ws.toggle(9) end)
hl.bind(mainMod .. " + Z", function() ws.toggle(1) end)

-- Zoom / Glass Magnifier
local ZOOM_FACTOR = 1.5

local function toggle_zoom()
    local current = hl.get_config("cursor.zoom_factor")
    if current ~= 1 then
        hl.config({ cursor = { zoom_factor = 1 } })
    else
        hl.config({ cursor = { zoom_factor = ZOOM_FACTOR } })
    end
end

hl.bind(mainMod .. " + Escape", toggle_zoom)

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + H", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind("CTRL + " .. mainMod .. "+right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("CTRL + " .. mainMod .. "+left",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind("CTRL + " .. mainMod .. "+l",     hl.dsp.focus({ workspace = "e+1" }))
hl.bind("CTRL + " .. mainMod .. "+j",     hl.dsp.focus({ workspace = "e-1" }))

-- Group/tab management
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + ALT + G", hl.dsp.group.lock())
hl.bind(mainMod .. " + period", hl.dsp.group.next())
hl.bind(mainMod .. " + comma", hl.dsp.group.prev())

-- Window Focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + i", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "d" }))

-- Swap Windows
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "r" }))
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.swap({ direction = "d" }))
hl.bind(mainMod .. " + ALT + j", hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + ALT + l", hl.dsp.window.swap({ direction = "r" }))
hl.bind(mainMod .. " + ALT + i", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + ALT + k", hl.dsp.window.swap({ direction = "d" }))

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + ALT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + ALT + BackSpace", hl.dsp.window.close())
hl.bind(mainMod .. " + ALT + N", hl.dsp.focus({ workspace = "empty" }))

-- Resize Submap
hl.bind(mainMod .. " + R", hl.dsp.submap("resizemode"))
hl.define_submap("resizemode", function()
    hl.bind("left", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
    hl.bind("right", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
    hl.bind("up", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
    hl.bind("down", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Group bar colors
hl.config({
    ["group.groupbar.col.active"] = 0xee2a2a3a,
    ["group.groupbar.col.inactive"] = 0x881a1a2a,
    ["group.groupbar.render_titles"] = true,
    ["group.groupbar.gradients"] = false,
})

-- Mouse binds
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Tools & Apps
hl.bind(mainMod .. " + ALT + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + ALT + Return", hl.dsp.exec_cmd("kitty --title popup"))

hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("rofi -show drun -terminal " .. terminal))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("rofi -show ssh -terminal " .. terminal))
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("rofi -show window"))

hl.bind("Print", hl.dsp.exec_cmd("hyprshot -o ~/Pictures/Screenshots/ -m window"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot -o ~/Pictures/Screenshots/ -m region"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot -o ~/Pictures/Screenshots/ -m region"))

hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))

-- Media Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Media keyboard shortcuts
hl.bind(mainMod .. "+Prior", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind(mainMod .. "+Next", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind(mainMod .. "+End", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

-- 5. Window Rules

-- Maximized windows get a cyan-to-violet gradient border
hl.window_rule({
    name = "maximize_border",
    match = { fullscreen = 1 },
    border_color = { colors = {"rgba(cc55ffee)", "rgba(33ccffee)"}, angle = 45 },
})

hl.layer_rule({ name = "rofi-dim", match = { namespace = "rofi" }, dim_around = true })

hl.window_rule({
    name = "mixer",
    match = { class = "pavucontrol-qt" },
    float = true,
    size = "monitor_w*0.3 monitor_h*0.8",
    move = "monitor_w-monitor_w*0.3-7 monitor_h-monitor_h*0.8-35",
})

hl.window_rule({
    name = "kitty-popup",
    match = { class = "kitty", title = "popup" },
    float = true,
    center = true,
    size = "monitor_w*0.5 monitor_h*0.8",
})

hl.window_rule({
    name = "browser-fake-fullscreen",
    match = { class = "chromium" },
    fullscreen_state = "0 0",
})

-- 6. Load Local Overrides
pcall(require, "local")

-- hyprmon: managed monitor profile include
require("hyprmon")
