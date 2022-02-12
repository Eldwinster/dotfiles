module DbusHook where

import XMonad
import XMonad.Hooks.DynamicLog

import qualified Codec.Binary.UTF8.String as UTF8
import qualified XMonad.DBus as D
import qualified XMonad.DBus.Client as D

myDbusHook :: D.Client -> PP
myDbusHook dbus = def
    { ppOutput = dbusOutput dbus
    -- , ppCurrent = wrap ("%{u" ++ pink_a2 ++ " B" ++ pink_a2 ++ " +u}  ") "  %{B- u- -u}"
    -- , ppVisible = wrap ("%{u" ++ green_a4 ++ " +u}  ") "  %{u- -u}"
    -- , ppUrgent = wrap ("%{u" ++ red_a7 ++ " +u}  ") "  %{u- -u}"
    -- , ppHidden = wrap "  " "  "
    -- , ppWsSep = ""
    , ppSep = " : "
    , ppTitle = shorten 40
    }

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
