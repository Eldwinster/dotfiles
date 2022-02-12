module Custom.MyManageHook where

import Custom.MyScratchpads
import Custom.MyWorkspaces

import XMonad
import XMonad.Hooks.ManageHelpers
import XMonad.Util.NamedScratchpad

import qualified XMonad.StackSet as W

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
