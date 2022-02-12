import XMonad

-- Action
import XMonad.Actions.FloatKeys
import XMonad.Actions.FloatSnap
import XMonad.Actions.Navigation2D
import XMonad.Actions.Submap
import XMonad.Actions.Navigation2D
import XMonad.Actions.CopyWindow (kill1, killAllOtherCopies)
import XMonad.Actions.CycleWS (moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)

-- Hook
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.DynamicLog (dynamicLogWithPP)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.EwmhDesktops (fullscreenEventHook)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Place
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ServerMode


-- Layout
import XMonad.Layout.IM
import XMonad.Layout.LayoutModifier (ModifiedLayout(..))
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Minimize
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.Tabbed
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.ResizableTile
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))

-- Util
import XMonad.Util.Run
import XMonad.Util.NamedScratchpad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)


import System.Exit
import Graphics.X11.ExtraTypes.XF86
import Data.Ratio ((%))

import qualified XMonad.Layout.BoringWindows as B
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified XMonad.Layout.BoringWindows as B
import qualified Codec.Binary.UTF8.String as UTF8
import qualified XMonad.Actions.Search as S
import qualified XMonad.Actions.TreeSelect as TS
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

-- Polybar
import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

-- Customs
import Colors

myModMask :: KeyMask
myModMask = mod4Mask

terminal' :: String
terminal' = "alacritty"

myTerm :: String
myTerm = "st"

browser' :: String
browser' = "vivaldi-stable"

-- myEmacs :: String
-- myEmacs =
myEditor :: String
myEditor = "vim"

-- archwiki, reddit :: S.SearchEngine

-- archwiki = S.searchEngine "archwiki" "https://wiki.archlinux.org/index.php?search="
-- reddit   = S.searchEngine "reddit" "https://www.reddit.com/search/?q="

-- -- This is the list of search engines that I want to use. Some are from
-- -- XMonad.Actions.Search, and some are the ones that I added above.
-- searchList :: [(String, S.SearchEngine)]
-- searchList = [ ("a", archwiki)
--              , ("d", S.duckduckgo)
--              , ("g", S.google)
--              , ("i", S.images)
--              , ("r", reddit)
--              , ("s", S.stackage)
--              , ("w", S.wikipedia)
--              , ("y", S.youtube)
--              ]

myStartupHook :: X ()
myStartupHook = do
        spawnOnce "picom &"
        spawnOnce "xbanish &"
        spawnOnce "clight &"
        spawnOnce "inkscape-figures watch"
        spawnOnce "python3 ~/.scripts/inkscape-shortcut-manager/main.py &"
        spawnOnce "setxkbmap us qwerty-fr &"
        spawnOnce "wallpaper.sh random auto 30m &"
        spawn "$HOME/.config/polybar/polybar-restart"

scratchpads = [ NS "terminal" spawnTerm findTerm manageTerm
                -- , NS "timer" spawnTimer findTimer manageTimer
                -- , NS "notes" spawnNotes findNotes manageNotes
                , NS "browser" spawnBrowser findBrowser manageBrowser
                , NS "vifm" spawnVifm findVifm manageVifm
                , NS "music" spawnMusic findMusic manageMusic
                , NS "task" spawnTask findTask manageTask
                , NS "obs" spawnObs findObs manageObs
                ]

    where
    spawnTerm       = myTerm ++ " -n scratchpad 'tmuxdd'"
    findTerm        = resource =? "scratchpad"
    manageTerm      = customFloating $ W.RationalRect x y w h
                where
                 x = 0
                 y = 0.023
                 w = 1
                 h = 0.978
    -- spawnTimer      = "pomotroid"
    -- findTimer       = resource =? "pomotroid"
    -- manageTimer     = doFloat
    -- spawnNotes      = myTerm ++ " -n notes -e vim ~/.notes.txt"
    -- findNotes       = resource =? "notes"
    -- manageNotes     = customFloating $ W.RationalRect x y w h
    --             where
    --              x = 0.25
    --              y = 0.25
    --              w = 0.5
    --              h = 0.5
    spawnBrowser    = "qutebrowser"
    findBrowser     = resource =? "qutebrowser"
    manageBrowser   = doFloat
    -- spawnVifm       = myTerm ++ " -n vifm -e sh $HOME/.config/vifm/scripts/vifmrun ~/ ~/"
    spawnVifm       = myTerm ++ " -n vifm -e vifm.sh"
    findVifm        = resource =? "vifm"
    manageVifm      = customFloating $ W.RationalRect x y w h
                where
                x = 0.95 -h
                y = 0.95 -w
                w = 0.9
                h = 0.9
    spawnMusic      = "sublime-music"
    findMusic       = resource =? "sublime-music"
    manageMusic     = customFloating $ W.RationalRect x y w h
                where
                x = 0.95 -h
                y = 0.95 -w
                w = 0.9
                h = 0.9
    spawnTask       = myTerm ++ " -n task -e tmuxattach.sh"
    findTask        = resource =? "task"
    manageTask      = customFloating $ W.RationalRect x y w h
                where
                x = 0.95 -h
                y = 0.95 -w
                w = 0.9
                h = 0.9
    spawnObs    = "obs"
    findObs     = resource =? "obs"
    manageObs      = customFloating $ W.RationalRect x y w h
                where
                 x = 0
                 y = 0.023
                 w = 1
                 h = 0.978

myLayouts = fullscreenToggle
    $ tiled ||| tabs
  where
    fullscreenToggle = mkToggle (single NBFULL)
    tiled = renamed [Replace "\xf036"]
        $ avoidStruts
        $ smartBorders
        $ minimize
        $ B.boringWindows
        $ Tall 1 (3 / 100) (1 / 2)
    tabs = renamed [Replace "\xf2d1"]
        $ avoidStruts
        $ smartBorders
        $ minimize
        $ B.boringWindows
        $ tabbedBottom shrinkText defTabbed
    defTabbed = def
        { activeColor = color2
        , urgentColor = red_a4
        , inactiveColor = color1
        , activeBorderColor = color1
        , inactiveBorderColor = color1
        , urgentBorderColor = red_a4
        , inactiveTextColor = color0
        , activeTextColor = color0
        , urgentTextColor = "#ffffff"
        , fontName = "xft:Iosevka:size=10" }

switchWorkspaceToWindow :: Window -> X ()
switchWorkspaceToWindow w = windows $ do
    tag <- W.currentTag
    W.focusWindow w . W.greedyView tag . W.focusWindow w

workspaces' = ["\xf015", "\xf120", "\xf27d", "\xf07b", "\xf269", "\xf1c0", "7", "\xf186", "\xf26c"]

myManageHook :: ManageHook
myManageHook =
    manageSpecific
    <+> namedScratchpadManageHook scratchpads
  where
    manageSpecific = composeAll
        [ isFullscreen                      --> doFullFloat
        , className =? "Inkscape"           --> doRectFloat (W.RationalRect 0 0.02 1 0.98)
        , className =? "XTerm"              --> doRectFloat (W.RationalRect 0.25 0.75 0.55 0.25)
        , className =? "Vivaldi-stable"     --> doShift ( workspaces' !! 4 )
        , className =? "discord"            --> doShift ( workspaces' !! 5 )
        , resource =? "bashtop"             --> doShift ( workspaces' !! 8 )
        , resource =? "vifm"                --> doShift ( workspaces' !! 8 )
        , resource =? "ssh"                 --> doShift ( workspaces' !! 5 )
        -- Used by Chromium developer tools, maybe other apps as well
        , role =? "pop-up"                --> doFloat
        , transience' ]
    role = stringProperty "WM_WINDOW_ROLE"

myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [ ("M-C-q", spawn "xmonad --recompile")      -- Recompiles xmonad
        , ("M-q", spawn "xmonad --restart")          -- Restarts xmonad
        , ("M-S-q", io exitSuccess)                  -- Quits xmonad

    -- Open my preferred terminal
        , ("M-<Return>", spawn terminal')
        , ("M-S-<Return>", spawn (terminal' ++ " -e tmuxdd"))

    -- Windows
        , ("M-c", kill1)                           -- Kill the currently focused client
        , ("M-S-a", killAll)                         -- Kill all windows on current workspace

    -- Floating windows
        , ("M-f", sendMessage (T.Toggle "floats"))       -- Toggles my 'floats' layout
        , ("M-<Delete>", withFocused $ windows . W.sink) -- Push floating window back to tile
        , ("M-S-<Delete>", sinkAll)                      -- Push ALL floating windows to tile

    -- Windows navigation
        , ("M-m", windows W.focusMaster)     -- Move focus to the master window
        , ("M-j", windows W.focusDown)       -- Move focus to the next window
        , ("M1-<Tab>", windows W.focusDown)   -- Move focus to the next window
        , ("M-k", windows W.focusUp)         -- Move focus to the prev window
        , ("M1-S-<Tab>", windows W.focusUp)   -- Move focus to the prev window
        , ("M-S-m", windows W.swapMaster)    -- Swap the focused window and the master window
        , ("M-S-j", windows W.swapDown)      -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)        -- Swap focused window with prev window
        , ("M-<Backspace>", promote)         -- Moves focused window to master, others maintain order
        -- , ("M1-S-<Tab>", rotSlavesDown)      -- Rotate all windows except master and keep focus in place
        -- , ("M1-C-<Tab>", rotAllDown)         -- Rotate all the windows in the current stack
        , ("M1-S-<Space>", rotSlavesDown)      -- Rotate all windows except master and keep focus in place
        , ("M1-C-<Space>", rotAllDown)         -- Rotate all the windows in the current stack
        , ("M-C-s", killAllOtherCopies)

        -- Layouts
        , ("M-<Space>", sendMessage NextLayout)                -- Switch to next layout
        , ("M-C-M1-<Up>", sendMessage Arrange)
        , ("M-C-M1-<Down>", sendMessage DeArrange)
        , ("M-S-n", sendMessage $ MT.Toggle NOBORDERS)      -- Toggles noborder
        , ("M-<KP_Multiply>", sendMessage (IncMasterN 1))   -- Increase number of clients in master pane
        , ("M-<KP_Divide>", sendMessage (IncMasterN (-1)))  -- Decrease number of clients in master pane
        , ("M-S-<KP_Multiply>", increaseLimit)              -- Increase number of windows
        , ("M-S-<KP_Divide>", decreaseLimit)                -- Decrease number of windows

        , ("M-h", sendMessage Shrink)                       -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                       -- Expand horiz window width
        , ("M-C-j", sendMessage MirrorShrink)               -- Shrink vert window width
        , ("M-C-k", sendMessage MirrorExpand)               -- Exoand vert window width

    -- Scratchpads
        , ("M1-1", namedScratchpadAction scratchpads "terminal")
        -- , ("M1-2", namedScratchpadAction scratchpads "notes")
        -- , ("M1-3", namedScratchpadAction scratchpads "timer")
        , ("M1-2", namedScratchpadAction scratchpads "browser")
        , ("M1-3", namedScratchpadAction scratchpads "vifm")
        , ("M1-4", namedScratchpadAction scratchpads "music")
        , ("M1-5", namedScratchpadAction scratchpads "task")
        , ("M1-6", namedScratchpadAction scratchpads "obs")

    -- Rofi
        , ("M-r", spawn ("rofi -show run -switchers 'run,window' -no-levenshtein-sort"))
        , ("M-S-r", spawn ("rofi -show window -switchers 'run,window' -no-levenshtein-sort"))

    -- My Applications
        , ("M1-u", spawn (terminal' ++ " -e matrix.sh"))
        , ("M-M1-n", spawn (terminal' ++ " -e newsboat"))
        , ("M-w", spawn browser')
        , ("M-b", spawn (myTerm ++ " -n bashtop -e bashtop"))
        , ("M-n", spawn (myTerm ++ " -n ncdu -e ncdu"))
        , ("M-v", spawn (terminal' ++ " -e ./.config/vifm/scripts/vifmrun ~/ ~/"))
        , ("M-d", spawn "discord")

    -- University setup
        -- , ("M1-s", spawn ("rofi-courses.py"))
        -- , ("M1-S-s", spawn ("rofi-courses-tds.py"))
        -- , ("M1-v", spawn ("rofi-lectures-view.py"))
        -- , ("M1-S-v", spawn ("rofi-lectures-tds-view.py"))
        -- , ("M1-l", spawn ("rofi-lectures.py"))
        -- , ("M1-S-l", spawn ("rofi-lectures-tds.py"))
        -- , ("M1-a", spawn ("compile-all-masters.py"))
        -- , ("M1-f", spawn ("inkscape-figures edit ~/university/current_course/figures"))
        -- , ("M1-o", spawn ("zathura ~/university/current_course/master.pdf"))
        -- , ("M1-r", spawn (terminal' ++ " -e ./.config/vifm/scripts/vifmrun ~/university/current_course ~"))
        -- , ("M1-j", spawn (terminal' ++ " --working-directory ~/university/current_course"))
        -- , ("M1-m", spawn (terminal' ++ " -e vim ~/university/current_course/master.tex"))
        -- , ("M1-t", spawn (terminal' ++ " -e vim ~/university/current_course/UltiSnips/tex.snippets"))

    -- My Configs

    -- My script
        , ("M-a", spawn ("st -n ssh -e tmux-ssh.sh"))
        , ("M1-w", spawn "wallpaper.sh random auto 30m &")

    -- Multimedia Keys
        , ("<XF86ScreenSaver>", spawn (terminal' ++ " -e unimatrix.sh"))
        , ("<Pause>", spawn (terminal' ++ " -e doas systemctl hibernate"))
        , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5 -time 100")
        , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5 -time 100")
        , ("<XF86AudioPlay>", spawn "cmus toggle")
        , ("<XF86AudioPrev>", spawn "cmus prev")
        , ("<XF86AudioNext>", spawn "cmus next")
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
        , ("<XF86AudioMute>", spawn "amixer set Master toggle")
        , ("<XF86AudioMicMute>", spawn "amixer set Capture toggle")
        , ("<XF86Mail>", runOrRaise "geary" (resource =? "thunderbird"))
        , ("<XF86Calculator>", runOrRaise "gcalctool" (resource =? "gcalctool"))
        , ("<XF86Eject>", spawn "toggleeject")
        , ("<Print>", spawn "scrotd 0")
        ]

        -- Appending search engine prompts to keybindings list.
        -- Look at "search engines" section of this config for values for "k".
        -- ++ [("M-s " ++ k, S.promptSearch dtXPConfig' f) | (k,f) <- searchList ]
        -- ++ [("M-S-s " ++ k, S.selectSearch f) | (k,f) <- searchList ]

-- Override the PP values as you would otherwise, adding colors etc depending
-- on the statusbar used
myLogHook :: D.Client -> PP
myLogHook dbus = def
    { ppOutput  = dbusOutput dbus
    , ppCurrent = wrap ("%{F" ++ color0 ++ "} ") "%{F-}"
    , ppVisible = wrap ("%{F" ++ color0 ++ "} ") "%{F-}"
    , ppUrgent  = wrap ("%{F" ++ color0 ++ "} ") "%{F-}"
    , ppHidden  = wrap ("%{F" ++ color0 ++ "} ") "%{F-}"
    , ppTitle   = wrap ("%{F" ++ color0 ++ "}")"%{F-}"
    , ppSep     = "  |  "
    -- , ppTitle = shorten 40
    }

myConfig = def
    { terminal = terminal'
    , layoutHook = myLayouts
    , manageHook = myManageHook
    , startupHook = myStartupHook
    , handleEventHook = fullscreenEventHook
    -- Don't be stupid with focus
    , focusFollowsMouse = False
    , clickJustFocuses = False
    , borderWidth = 2
    , normalBorderColor = grey_9
    , focusedBorderColor = pink_a2
    , workspaces = workspaces'
    , modMask = myModMask } `additionalKeysP` myKeys

main :: IO ()
main = do
    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
    -- The xmonad, ya know...what the window manager is named after.
    xmonad $ ewmh $ docks $ myConfig { logHook = dynamicLogWithPP (myLogHook dbus) }

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ UTF8.decodeString str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"

defaults = def
    { handleEventHook     = serverModeEventHookCmd
                            <+> serverModeEventHook
                            <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                            <+> docksEventHook
    } `additionalKeysP` myKeys
