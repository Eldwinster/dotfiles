module Custom.MyKeys where

import Custom.MyVariables
import Custom.MyScratchpads

import XMonad
import Data.Maybe (isJust)
import System.Exit (exitSuccess)
import XMonad.Actions.CopyWindow (kill1, killAllOtherCopies)
import XMonad.Actions.CycleWS (moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.ResizableTile
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)

import qualified XMonad.Actions.Search as S
import qualified XMonad.Actions.TreeSelect as TS
import qualified XMonad.StackSet as W
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))


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
        , ("M1-s", spawn ("rofi-courses.py"))
        , ("M1-S-s", spawn ("rofi-courses-tds.py"))
        , ("M1-v", spawn ("rofi-lectures-view.py"))
        , ("M1-S-v", spawn ("rofi-lectures-tds-view.py"))
        , ("M1-l", spawn ("rofi-lectures.py"))
        , ("M1-S-l", spawn ("rofi-lectures-tds.py"))
        , ("M1-a", spawn ("compile-all-masters.py"))
        , ("M1-f", spawn ("inkscape-figures edit ~/university/current_course/figures"))
        , ("M1-o", spawn ("zathura ~/university/current_course/master.pdf"))
        , ("M1-r", spawn (terminal' ++ " -e ./.config/vifm/scripts/vifmrun ~/university/current_course ~"))
        , ("M1-j", spawn (terminal' ++ " --working-directory ~/university/current_course"))
        , ("M1-m", spawn (terminal' ++ " -e vim ~/university/current_course/master.tex"))
        , ("M1-t", spawn (terminal' ++ " -e vim ~/university/current_course/UltiSnips/tex.snippets"))
    
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
