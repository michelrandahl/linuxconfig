import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.FadeWindows
import XMonad.Hooks.FadeInactive
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Actions.Volume
import XMonad.Util.Dzen
import XMonad.Layout.NoBorders
import Data.Map (fromList)
import Data.Monoid (mappend)
import System.IO
import XMonad.Actions.CycleWS

xK_XF86AudioLowerVolume = 0x1008ff11
xK_XF86AudioRaiseVolume = 0x1008ff13
xK_XF86AudioMute = 0x1008ff12

myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 0.5

myFadeHook = composeAll [isUnfocused --> transparency 0.2, opaque]

main = do
    xmproc <- spawnPipe "xmobar"

    xmonad $ defaultConfig {
		borderWidth = 4,
        keys = keys defaultConfig `mappend` \c -> fromList [
                ((0, xK_XF86AudioLowerVolume), lowerVolume 4 >> return ()),
                ((0, xK_XF86AudioRaiseVolume), raiseVolume 4 >> return ()),
                ((0, xK_XF86AudioMute), toggleMute >> return ())
        ],
        manageHook = manageDocks <+> manageHook defaultConfig,
        terminal = "gnome-terminal",
        layoutHook = avoidStruts  $  layoutHook defaultConfig,
		logHook = fadeWindowsLogHook myFadeHook <+> dynamicLogWithPP xmobarPP {
          ppOutput = hPutStrLn xmproc,
          ppTitle = xmobarColor "red" "" . shorten 50
        },
		handleEventHook = fadeWindowsEventHook,
        modMask = mod4Mask     -- Rebind Mod to the Windows key
      }
      `additionalKeys` [ ((mod4Mask .|. shiftMask, xK_w), spawn "slock")
                       , ((mod4Mask .|. shiftMask, xK_s), spawn "sudo pm-suspend")
                       , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
                       , ((mod4Mask .|. shiftMask, xK_u), spawn "setxkbmap -layout us")
                       , ((mod4Mask .|. shiftMask, xK_i), spawn "setxkbmap -layout dk")
                       , ((0, xK_Print), spawn "scrot")
                       , ((mod4Mask, xK_Right), nextWS)
                       , ((mod4Mask, xK_Left), prevWS)
                       , ((mod4Mask .|. shiftMask, xK_l), nextWS)
                       , ((mod4Mask .|. shiftMask, xK_h), prevWS) ]
