{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
module Config where

import Custom.MyLayouts
import Custom.MyManageHook
import Custom.MyWorkspaces
import Custom.MyVariables
import Custom.MyKeys
import Custom.MyScratchpads
import Custom.MyStartupHook

import XMonad
import XMonad.Actions.FloatKeys
import XMonad.Actions.FloatSnap
import XMonad.Actions.Navigation2D
import XMonad.Actions.Submap
import XMonad.Hooks.EwmhDesktops (fullscreenEventHook)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Place
import qualified XMonad.Layout.BoringWindows as B
import XMonad.Layout.IM
import XMonad.Layout.LayoutModifier (ModifiedLayout(..))
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Minimize
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.Tabbed
import XMonad.Util.NamedScratchpad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.SpawnOnce
import System.Exit
import Graphics.X11.ExtraTypes.XF86

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.Ratio ((%))

import qualified Codec.Binary.UTF8.String as UTF8


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
