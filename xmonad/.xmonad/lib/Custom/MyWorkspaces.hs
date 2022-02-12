module Custom.MyWorkspaces where 

import XMonad

import qualified XMonad.StackSet as W

switchWorkspaceToWindow :: Window -> X ()
switchWorkspaceToWindow w = windows $ do
    tag <- W.currentTag
    W.focusWindow w . W.greedyView tag . W.focusWindow w

workspaces' = ["\xf015", "\xf120", "\xf27d", "\xf07b", "\xf269", "\xf1c0", "7", "\xf186", "\xf26c"]
