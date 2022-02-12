module Custom.MyScratchpads where

import Custom.MyVariables

import XMonad
import qualified XMonad.StackSet as W

import XMonad.Util.NamedScratchpad

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
