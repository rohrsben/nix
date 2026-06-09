hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 12,
        border_size = 2,
        col = {
            active_border = "#5c845f",
            inactive_border = "#b3b3b3"
        }
    },
    decoration = {
        rounding = 6,
        shadow = { enabled = false },
        blur = { enabled = false },
    },
    input = {
        sensitivity = -0.7,
        numlock_by_default = true,
        repeat_delay = 300,
    },
    group = {
        merge_groups_on_drag = false,
        col = {
            border_active = '#5c845f',
            border_inactive = '#b3b3b3',
            border_locked_active = '#c67b6c',
            border_locked_inactive = '#b3b3b3',
        },
        groupbar = {
            font_family = 'JetBrainsMono Nerd Font',
            font_size = 12,
            text_color = '#000000',
            height = 18,
            gradients = true,
            gradient_rounding = 6,
            indicator_height = 0,
            col = {
                active = '#5c845f',
                inactive = '#d1d0c780',
                locked_active = '#c67b6c',
                locked_inactive = '#c67b6c80'
            }
        },
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        font_family = 'JetBrainsMono Nerd Font',
    },
})

-- autostarts
hl.on('hyprland.start', function ()
    hl.exec_cmd('runapp waybar')
    hl.exec_cmd('runapp udiskie --tray')
    hl.exec_cmd('runapp hypridle')
    hl.exec_cmd('hyprctl dispatch workspace 6')
    hl.exec_cmd('runapp wayland-pipewire-idle-inhibit')
    hl.exec_cmd('systemctl --user start hyprpolkitagent')
end)


-- envvars
-- hl.env('LIBVA_DRIVER_NAME', 'nvidia')
-- hl.env('XDG_CURRENT_DESKTOP', 'Hyprland') 
-- hl.env('XDG_SESSION_DESKTOP', 'Hyprland')
-- hl.env('XDG_SESSION_TYPE',    'wayland')
-- hl.env('QT_QPA_PLATFORM', 'wayland')
-- hl.env('QT_QPA_PLATFORMTHEME', 'qt6ct')
-- hl.env('QT_WAYLAND_DISABLE_WINDOWDECORATION', '1')


-- exec binds
local exec_binds = {
    {'SUPER + Return',       'runapp kitty'},
    {'SUPER + SHIFT + M',    'hyprshutdown'},
    {'SUPER + Space',        'runapp $(tofi-drun)'},
    {'SUPER + P',            '~/.scripts/powermenu.sh'},
    {'SUPER + L',            'runapp hyprlock'},
    {'XF86AudioMute',        'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'},
    {'XF86AudioPlay',        'playerctl play'},
    {'XF86AudioPause',       'playerctl pause'},
    {'XF86AudioPrev',        'playerctl previous'},
    {'XF86AudioNext',        'playerctl next'},
    {'XF86AudioLowerVolume', 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-'},
    {'XF86AudioRaiseVolume', 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+'},
    {'code:172',             'playerctl play-pause'},
    {'Print',                "grimblast --notify save area $XDG_PICTURES_DIR/screenshots/$(date +'%b%d-%T.png')"},
    {'SHIFT + Print',        "grimblast --notify --freeze save area $XDG_PICTURES_DIR/screenshots/$(date +'%b%d-%T.png')"}
}
for _, val in ipairs(exec_binds) do
    hl.bind(val[1], hl.dsp.exec_cmd(val[2]))
end

-- window
hl.bind('SUPER + Q', hl.dsp.window.close())
hl.bind('SUPER + SHIFT + F', hl.dsp.window.float({action = 'toggle'}))
hl.bind('SUPER + F', hl.dsp.window.fullscreen({action = 'toggle'}))

-- group
hl.bind('SUPER + G', hl.dsp.group.toggle())
hl.bind('SUPER + SHIFT + G', hl.dsp.group.lock_active())
hl.bind('SUPER + R', hl.dsp.window.move({out_of_group = true}))
hl.bind('SUPER + Tab', hl.dsp.group.next())

-- focus movement
hl.bind('SUPER + left', hl.dsp.focus({direction = 'l'}))
hl.bind('SUPER + right', hl.dsp.focus({direction = 'r'}))
hl.bind('SUPER + up', hl.dsp.focus({direction = 'u'}))
hl.bind('SUPER + down', hl.dsp.focus({direction = 'd'}))

-- mouse
hl.bind('SUPER + mouse:272', hl.dsp.window.drag(), { mouse = true })
hl.bind('SUPER + mouse:273', hl.dsp.window.resize(), { mouse = true })

-- workspace
local hs = require('hyprsplit')
for i = 1, 5 do
    hl.bind('SUPER + ' .. i, hs.dsp.focus({workspace = i}))
    hl.bind('SUPER + SHIFT + ' .. i, hs.dsp.window.move({workspace = i}))
end
hl.bind('SUPER + S', hl.dsp.workspace.toggle_special('special'))


-- hyprsplit
hs.config({
    num_workspaces = 5,
    persistent_workspaces = true,
})

local monitors = {
    {
        output = 'DP-3',
        mode = '2560x1440@144',
        position = '0x0',
        scale = 1,
    },
    {
        output = 'DP-1',
        mode = '2560x1440@144',
        position = '2560x-745',
        scale = 1,
        transform = 3,
    },
    {
        output = '',
        mode = 'preferred',
        position = 'auto',
    }
}

for _, val in ipairs(monitors) do
    hl.monitor(val)
end

hl.window_rule({
    match = { class = '(firefox)', title = '(Library)' },
    float = true,
    center = true,
    size = {1000, 800},
})

hl.curve("primary", {
    type = 'bezier',
    points = {
        {0.02, 0.14},
        {0.51, 0.97}
    }
})

local animations = {
    workspaces = { enabled = true, speed = 3, bezier = 'primary', style = 'slidevert'},
    windows = { enabled = false },
    layers = { enabled = false },
    fade = { enabled = false },
    border = { enabled = false },
    borderangle = { enabled = false },
    zoomFactor = { enabled = false },
    monitorAdded = { enabled = false },
}

for name, args in pairs(animations) do
    args.leaf = name
    hl.animation(args)
end
