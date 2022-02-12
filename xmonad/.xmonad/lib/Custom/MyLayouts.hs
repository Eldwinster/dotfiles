module Custom.MyLayouts where

import Custom.MyVariables

import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Layout.LayoutModifier (ModifiedLayout(..))
import XMonad.Layout.Minimize
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.Tabbed

import qualified XMonad.Layout.BoringWindows as B

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
