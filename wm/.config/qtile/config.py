# [[file:configbkp.org::*Imports][Imports:1]]
import os, subprocess
from libqtile import layout, hook, bar, widget
from libqtile.config import EzConfig, EzKey as Key, KeyChord, Group, Match, EzClick as Click, EzDrag as Drag, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
# Imports:1 ends here

# [[file:configbkp.org::*Terminal][Terminal:1]]
# alac = "alacritty"
st = "st"
shelter = "emacsclient -c -a ''"
# I keep this one to do the same with st using scratchpad group.
# nuclear_shelter = alac + " -t tmux -e tmux new-session -A"
nuclear_shelter = st
# Terminal:1 ends here

# [[file:configbkp.org::*Emacs][Emacs:1]]
vterm = shelter + " --eval '(+vterm/here nil)'"
eshell = shelter + " --eval '(eshell)'"
fileManager = shelter + " --eval '(dired nil)'"
dotGit = shelter + " --eval '(me/magit-status-dotfiles)'"
orgGit = shelter + " --eval '(me/magit-status-org)'"
Magit = shelter + " --eval '(me/magit-status)'"
bufferManager = shelter + " --eval '(ibuffer)'"
forLife = "emacsclient --eval '(emacs-everywhere)'"
# I need to resolve vifm probleme even if dired is better in many ways.
# As I'm not an expert elips programmer there is some time vifm is just better/simpler.
# vifm = alac + " -e ./$HOME/.config/vifm/scripts/vifmrun"
# Emacs:1 ends here

# [[file:configbkp.org::*General Applications][General Applications:1]]
screenshot = "flameshot gui"
refManager = "zotero"
browser = "firefox"
remoteDesktop = "remmina"
proxyFreemium = "burpsuite"
proxyOpenSource = "zaproxy"
networkAnalyser = "sudo wireshark"
metasploit = st + " -c app -n st-metasploit -e msfconsole"
helpDeskApp = "anydesk"
discord = "discord"
# utilityViewer = st + " -n bottom -e sudo btm"
# diskSpace = st + " -n ncdu -e sudo ncdu"
# General Applications:1 ends here

# [[file:configbkp.org::*Zellij][Zellij:1]]
# TODO script this to attach if session already exists
adminView = st + " -c zellij -n zellij-admin -e zellij -s admin options --default-layout sys"
sshView = st + " -c zellij -n zellij-ssh -e zellij -s ssh options --default-layout ssh"
hackSetup = st + " -c zellij -n zellij-hack -e zellij -s hack options --default-layout hack"
# Zellij:1 ends here

# [[file:configbkp.org::*Keys][Keys:1]]
mod = "mod4"
# Keys:1 ends here

# [[file:configbkp.org::*Keybinds][Keybinds:1]]
keys = [
        KeyChord([mod], "q", [
            Key("c", lazy.reload_config()),
            Key("r", lazy.restart()),
            Key("q", lazy.shutdown()),
        ]),
        Key("M-h", lazy.layout.left()),
        Key("M-j", lazy.layout.down(),),
        Key("M-k", lazy.layout.up()),
        Key("M-l", lazy.layout.right()),
    
        # Key("M-j", lazy.group.next_window()),
        # Key("M-k", lazy.group.prev_window()),
    
        Key("M-S-h", lazy.layout.shuffle_left()),
        Key("M-S-j", lazy.layout.shuffle_down()),
        Key("M-S-k", lazy.layout.shuffle_up()),
        Key("M-S-l", lazy.layout.shuffle_right()),
        Key("M-<Tab>", lazy.next_layout()),
        Key("M-S-<Tab>", lazy.prev_layout()),
        Key("M-C-h",
            lazy.layout.grow_left(),
            lazy.layout.shrink(),
            lazy.layout.decrease_ratio(),
            lazy.layout.add(),
            ),
    
        Key("M-C-j",
            lazy.layout.grow_down(),
            lazy.layout.shrink(),
            lazy.layout.increase_nmaster(),
            ),
    
        Key("M-C-k",
            lazy.layout.grow_up(),
            lazy.layout.grow(),
            lazy.layout.decrease_nmaster(),
            ),
    
        Key("M-C-l",
            lazy.layout.grow_right(),
            lazy.layout.grow(),
            lazy.layout.increase_ratio(),
            lazy.layout.delete(),
            ),
        Key("M-S-i", lazy.layout.grow()),
        Key("M-S-m", lazy.layout.shrink()),
        Key("M-<BackSpace>", lazy.layout.normalize()),
        Key("M-o", lazy.layout.maximize()),
        Key("M-S-C-h", lazy.layout.swap_column_left()),
        Key("M-S-C-l", lazy.layout.swap_column_right()),
    
        Key("M-<Delete>", lazy.layout.toggle_split()),
        Key("M-S-<Delete>", lazy.layout.flip()),
        Key("M-c", lazy.window.kill()),
        Key("M-<space>", lazy.window.toggle_fullscreen()),
        Key("M-S-<space>", lazy.window.toggle_minimize()),
        Key("M-<Return>", lazy.spawn(nuclear_shelter)),
        Key("M-C-<Return>", lazy.spawn(eshell)),
        Key("M-e", lazy.spawn(shelter)),
        KeyChord([mod], "m", [
            Key("d", lazy.spawn(dotGit)),
            Key("o", lazy.spawn(orgGit)),
            Key("m", lazy.spawn(Magit)),
        ]),
        Key("M-s", lazy.spawn(screenshot)),
        Key("M-w", lazy.spawn(browser)),
        # Key("M-v", lazy.spawn(vifm)),
        KeyChord([mod], "a", [
            Key("r", lazy.spawn(remoteDesktop)),
            Key("i", lazy.spawn(bufferManager)),
            Key("a", lazy.spawn(forLife)),
            Key("o", lazy.spawn(refManager)),
            # Key("t", lazy.spawn(utilityViewer)),
            # Key("n", lazy.spawn(diskSpace)),
            Key("b", lazy.spawn(proxyFreemium)),
            Key("z", lazy.spawn(proxyOpenSource)),
            Key("w", lazy.spawn(networkAnalyser)),
            Key("m", lazy.spawn(metasploit)),
            Key("l", lazy.spawn(helpDeskApp)),
            Key("d", lazy.spawn(discord)),
        ]),
        KeyChord([mod], "z", [
            Key("a", lazy.spawn(adminView)),
            Key("s", lazy.spawn(sshView)),
        ]),
        Key("<XF86ScreenSaver>", lazy.spawn(st + " -c slock -e unimatrix.sh")),
        Key("<XF86Display>", lazy.spawn("xset dpms force off")),
        Key("<Pause>", lazy.spawn("systemctl hibernate")),
        Key("<XF86MonBrightnessUp>", lazy.spawn("xbacklight -inc 5 -time 100")),
        Key("<XF86MonBrightnessDown>", lazy.spawn("xbacklight -dec 5 -time 100")),
        Key("<XF86AudioLowerVolume>", lazy.spawn("amixer set Master 5%- unmute")),
        Key("<XF86AudioRaiseVolume>", lazy.spawn("amixer set Master 5%+ unmute")),
        Key("<XF86AudioMute>", lazy.spawn("amixer set Master toggle")),
        Key("<XF86AudioMicMute>", lazy.spawn("amixer set Capture toggle")),
    
]
# Keybinds:1 ends here

# [[file:configbkp.org::*Mouse][Mouse:1]]
mouse = [
    Drag("M-1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag("M-3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click("M-2", lazy.window.bring_to_front()),
    Click("M-S-1", lazy.window.toggle_floating()),
]
# Mouse:1 ends here

# [[file:configbkp.org::*Colors][Colors:1]]
colors = []
cache= os.path.expanduser("~/.cache/wal/colors")
def load_colors(cache):
    with open(cache, 'r') as file:
        for i in range(8):
            colors.append(file.readline().strip())
    colors.append('#ffffff')
    lazy.reload()
load_colors(cache)
# Colors:1 ends here

# [[file:configbkp.org::*Layouts][Layouts:1]]
def init_layout_theme():
    return {
        "margin": 2,
        "border_width": 2,
        "border_focus": colors[1],
        "border_focus_stack": colors[2],
        "border_normal": colors[6],
        "border_normal_stack": colors[0],
    }
layout_theme = init_layout_theme()

layouts = [
    # layout.Bsp(**layout_theme),
    layout.Columns(**layout_theme),
    layout.Max(**layout_theme),
    # layout.MonadTall(ratio=0.65, **layout_theme),
    # layout.MonadThreeCol(**layout_theme),
    # layout.MonadWide(**layout_theme),
]
# Layouts:1 ends here

# [[file:configbkp.org::*Floating Layouts][Floating Layouts:1]]
floating_layout = layout.Floating(float_rules=[
    # Run 'xprop' to see wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class="confirmreset"),  # gitk
    Match(wm_class="makebranch"),  # gitk
    Match(wm_class="maketag"),  # gitk
    Match(wm_class="ssh-askpass"),  # ssh-askpass
    Match(title="branchdialog"),  # gitk
    Match(title="pinentry"),  # GPG key password entry
    Match(role="GtkFileChooserDialog"),
    ])

floating_types = [
    "notification",
    "toolbar",
    "splash",
    "dialog"
    ]
# Floating Layouts:1 ends here

# [[file:configbkp.org::*Themes][Themes:1]]
barTheme = {
    'background': colors[2],
    'opacity': 1,
}

widgetTheme = {
    'font': 'FiraCode Nerd Font',
    'border_width': 0,
    'fill_color': colors[7],
    'graph_color': colors[3],
    'update_interval': 1,
    'distro': 'Arch',
    'highlight_method': 'block',
    'interface': 'wlan0',
    'foreground': colors[7],
    'scale': 0.9,
    'border': colors[0],
    'active': colors[6],
    'inactive': colors[4],
    'other_current_screen_border': colors[0],
    'other_screen_border': colors[1],
    'this_current_screen_border': colors[0],
    'this_screen_border': colors[1],
}
# Themes:1 ends here

# [[file:configbkp.org::*Decorations][Decorations:1]]
soft_sep = {
    'linewidth': 2,
    'size_percent': 70,
    'foreground': colors[7],
    'padding': 10,
}
# Decorations:1 ends here

# [[file:configbkp.org::*Bar configuration][Bar configuration:1]]
AGroupBoxTheme = {
}
mainBar = bar.Bar(
    [
        widget.CurrentLayoutIcon(**widgetTheme),
        widget.GroupBox(**widgetTheme),
        widget.Sep(**soft_sep),
        widget.Prompt(),
        widget.TaskList(**widgetTheme),
        widget.Sep(**soft_sep),
        widget.CPUGraph(**widgetTheme),
        widget.Sep(**soft_sep),
        widget.ThermalSensor(**widgetTheme),
        widget.Sep(**soft_sep),
        widget.NetGraph(**widgetTheme),
        widget.Sep(**soft_sep),
        widget.Battery(**widgetTheme),
        widget.Sep(**soft_sep),
        widget.Clock(format='%Y/%m/%d %a %H:%M:%S', **widgetTheme),
    ], 25, **barTheme)

mediaBar = bar.Bar(
    [
        widget.CurrentLayoutIcon(**widgetTheme),
        widget.GroupBox(**widgetTheme),
        widget.Sep(**soft_sep),
        widget.Prompt(),
        widget.TaskList(**widgetTheme),
        widget.Sep(**soft_sep),
        widget.Memory(**widgetTheme),
        widget.Sep(**soft_sep),
        widget.Volume(**widgetTheme),
        widget.Sep(**soft_sep),
        widget.Clock(format='%Y/%m/%d %a %H:%M:%S', **widgetTheme),
    ], 30, **barTheme)

mainScreen = Screen(top=mainBar)
mediaScreen = Screen(top=mediaBar)
screens = [mainScreen, mediaScreen]
# Bar configuration:1 ends here

# [[file:configbkp.org::*Groups][Groups:1]]
groups = [
    Group("h3ck"),
    Group("www", layout="max"),
    Group("GUI", layout="max"),
    Group("shell"),
    Group("ssh", spawn=[sshView], layout="max"),
    Group("fm"),
    Group("misc", spawn="zotero", layout="max"),
    Group("etc"),
    Group("dev/null", spawn=[adminView], layout="max"),
]
# g = [0, 1, 0, 0, 1, 0, 1, 1, 1] # mons -e top
# g = [1, 0, 1, 1, 0, 1, 0, 0, 0] # mons -e left
g = [0, 0, 0, 0, 0, 0, 0, 0, 0]
# Investigate why after M-3 and M-4 I need to release M otherwise input are broken
k = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
for index, group in enumerate(groups):
    keys.append(Key("M-"+(k[index]), lazy.group[group.name].toscreen(g[index]), lazy.to_screen(g[index])))
    keys.append(Key("M-S-"+(k[index]), lazy.window.togroup(group.name)))
# Groups:1 ends here

# [[file:configbkp.org::*Groups][Groups:2]]
# groups.append(ScratchPad("scratchpad", [
#     DropDown("term", "st -c scratch", width=0.8, height=0.8, x=0.1, y=0.1, opacity=1),
#     DropDown("term2", "st -c scratch", width=0.8, height=0.8, x=0.1, y=0.1, opacity=1),
# ]))

# keys.extend([
#     # Key("M-d", lazy.spawn(fileManager)),
#     Key("M-n", lazy.group['scratchpad'].dropdown_toggle('term')),
#     Key("M-S-n", lazy.group['scratchpad'].dropdown_toggle('term2')),
# ])
# Groups:2 ends here

# [[file:configbkp.org::*dgroups][dgroups:1]]
dgroup_key_binder = None
# dgroups:1 ends here

# [[file:configbkp.org::*dgroups][dgroups:2]]
dgroups_app_rules = [] # type: List
# dgroups:2 ends here

# [[file:configbkp.org::*Mouse][Mouse:1]]
follow_mouse_focus = False
# Mouse:1 ends here

# [[file:configbkp.org::*Mouse][Mouse:2]]
bring_front_click = False
# Mouse:2 ends here

# [[file:configbkp.org::*Mouse][Mouse:3]]
cursor_wrap = False
# Mouse:3 ends here

# [[file:configbkp.org::*Mouse][Mouse:4]]
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

auto_minimize = True
wmname = "LG3D"
# Mouse:4 ends here

# [[file:configbkp.org::*Startup][Startup:1]]
@hook.subscribe.startup_once
def autostart():
    startOnce = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([startOnce])
# Startup:1 ends here
