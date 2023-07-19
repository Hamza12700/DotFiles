import os
import subprocess

from libqtile import bar, hook, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen, hook
from libqtile.lazy import lazy

mod = "mod4"
terminal = "alacritty"

keys = [
    #  D E F A U L T
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(),
        desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key(
        [mod, "control"],
        "h",
        lazy.layout.shuffle_left(),
        desc="Move window to the left",
    ),
    Key(
        [mod, "control"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "control"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "control"], "k", lazy.layout.shuffle_up(),
        desc="Move window up"),
    Key([mod, "shift"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "shift"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "shift"], "j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "shift"], "k", lazy.layout.grow_up(),
        desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(),
        desc="Reset all window sizes"),
    Key([mod], "f", lazy.window.toggle_fullscreen()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # C U S T O M
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "e", lazy.spawn("thunar"), desc="file manager"),
    Key([mod], "h", lazy.spawn("copyq show"), desc="clipboard"),
    Key([mod], "w", lazy.spawn("firefox"), desc="FireFox"),
    Key(
        [mod],
        "space",
        lazy.spawn("rofi -show drun -show-icons"),
        desc="App Launcher",
    ),
]

groups = [Group(f"{i+1}", label="󰏃") for i in range(8)]

for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(
                    i.name),
            ),
        ]
    )

# https://docs.qtile.org/en/latest/manual/ref/layouts.html
layouts = [
    layout.MonadTall(
        border_focus="#1F1D2E",
        border_normal="#1F1D2E",
        margin=5,
        border_width=0,
    ),
]


widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = [widget_defaults.copy()]

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Spacer(
                    length=8,
                    background="#232A2E",
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/launch_Icon.png",
                    margin=2,
                    background="#232A2E",
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/6.png",
                ),
                widget.GroupBox(
                    fontsize=15,
                    borderwidth=3,
                    highlight_method="block",
                    active="#86918A",
                    block_highlight_text_color="#D3C6AA",
                    highlight_color="#4B427E",
                    inactive="#232A2E",
                    foreground="#4B427E",
                    background="#343F44",
                    this_current_screen_border="#343F44",
                    this_screen_border="#343F44",
                    other_current_screen_border="#343F44",
                    other_screen_border="#343F44",
                    urgent_border="#343F44",
                    rounded=True,
                    disable_drag=True,
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/1.png",
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/layout.png", background="#343F44"
                ),
                widget.CurrentLayout(
                    background="#343F44",
                    foreground="#86918A",
                    fmt="{}",
                    font="JetBrains Mono Bold",
                    fontsize=13,
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/1.png",
                ),
                widget.WindowName(
                    background="#343F44",
                    format="{name}",
                    font="JetBrains Mono Bold",
                    fontsize=13,
                    foreground="#86918A",
                    empty_group_string="Desktop",
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/3.png",
                ),
                widget.Systray(
                    background="#232A2E",
                    fontsize=2,
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/6.png",
                    background="#343F44",
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/Misc/ram.png",
                    background="#343F44",
                ),
                widget.Spacer(
                    length=-7,
                    background="#343F44",
                ),
                widget.Memory(
                    background="#343F44",
                    format="{MemUsed: .0f}{mm}",
                    foreground="#86918A",
                    font="JetBrains Mono Bold",
                    fontsize=13,
                    update_interval=5,
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/5.png",
                    background="#343F44",
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/Misc/clock.png",
                    background="#232A2E",
                    margin_y=6,
                    margin_x=5,
                ),
                widget.Clock(
                    format="%I:%M %p",
                    background="#232A2E",
                    foreground="#86918A",
                    font="JetBrains Mono Bold",
                    fontsize=13,
                ),
                widget.Spacer(
                    length=13,
                    background="#232A2E",
                ),
            ],
            30,
            border_color="#232A2E",
            border_width=[0, 0, 0, 0],
            margin=[8, 6, 5, 6],
        ),
    ),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    border_focus="#1F1D2E",
    border_normal="#1F1D2E",
    border_width=0,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        # GPG key password entry
        Match(title="pinentry"),
    ],
)


# AutoStart
@hook.subscribe.startup_once
def autostart():
    subprocess.call([os.path.expanduser("~/.config/qtile/autostart.sh")])


auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

wmname = "Anonymous"
