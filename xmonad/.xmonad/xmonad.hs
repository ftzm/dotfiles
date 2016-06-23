import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Tabbed
import XMonad.Layout.Named
import XMonad.Actions.GroupNavigation
import XMonad.Layout.NoBorders
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FloatNext
import XMonad.Hooks.ManageDocks

bg="#002B36"
fg="#93A1A1"
yellow="#B58900"
orange="#CB4B16"
red="#DC322F"
magenta="#D33682"
violet="#6C71C4"
blue="#268BD2"
cyan="#2AA198"
green="#859900"

main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

myBar = "~/bin/xmobar_outputfeed.sh"

myPP = xmobarPP { ppCurrent = wrap ("%{B" ++ blue ++ "}%{F" ++ bg ++ "} ") (" %{F-}%{B-}")
                , ppHidden = wrap ("%{B" ++ bg ++ "}%{F" ++ fg ++ "} ") (" %{F-}%{B-}")
                , ppWsSep = ""
                , ppSep = " / "
                --, ppOrder = (:[]) . head
                , ppOrder = take 2
                , ppLayout = layoutRenamer
                }

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

myConfig = defaultConfig
    { terminal    = myTerminal
    , modMask     = myModMask
    , borderWidth = myBorderWidth
    , focusedBorderColor = "#268bd2"
    , normalBorderColor = "#002b36"
    , keys = myKeys
    --, logHook = myLogHook xmobars >> historyHook
    , logHook = dynamicLog >> historyHook
    , layoutHook = myLayouts
    , manageHook = myManageHook <+> manageDocks
    , workspaces = myWorkspaces
    }

myTabsTheme = defaultTheme
  { fontName = "xft:lemon:medium:pixelsize=10"
  , activeColor = "#268bd2"
  , inactiveColor = "#002b36"
  , activeBorderColor = "#268bd2"
  , inactiveBorderColor = "#002b36"
  , decoHeight = 0
  }

myWorkspaces = ["main","web","dev","term","mus","6","7","8","9"]

myTerminal    = "urxvt"
myModMask     = mod4Mask -- Win key or Super_L
myBorderWidth = 5

--spacing 2 adds 2px spacing around all windows in all layouts
myLayouts = avoidStruts $ (smartBorders $ smartSpacing 2 $ rT ||| Mirror rT ||| Full ||| emptyBSP) ||| tabbed shrinkText myTabsTheme
--myLayouts = rT ||| Mirror rT ||| Full ||| emptyBSP ||| tabbed shrinkText myTabsTheme
  where
     rT = ResizableTall 1 (6/100) (1/2) []
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

layoutRenamer :: String -> String
layoutRenamer x = case x of
  "SmartSpacing 2 ResizableTall" -> "Side"
  "SmartSpacing 2 Mirror ResizableTall" -> "Top"
  "SmartSpacing 2 Full" -> "Full"
  "SmartSpacing 2 BSP" -> "BSP"
  "Tabbed Simplest" -> "Tabbed"
  x -> x

myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@XConfig {XMonad.modMask = modMask} = M.fromList $
    -- launching and killing programs
    [ ((modMask,               xK_Return), spawn $ XMonad.terminal conf) -- %! Launch terminal
    , ((modMask,               xK_space     ), spawn "myrofi") -- %! Launch dmenu
    , ((modMask,               xK_f     ), spawn "rofiles") -- %! Launch dmenu
    , ((modMask,               xK_c     ),
    kill) -- %! Close the focused window

    , ((modMask,               xK_Tab ), sendMessage NextLayout) -- %! Rotate through the available layout algorithms
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf) -- %!  Reset the layouts on the current workspace to default

    , ((modMask,               xK_n     ), refresh) -- %! Resize viewed windows to the correct size

    -- move focus up or down the window stack
    , ((modMask,               xK_j     ), do { windows W.focusDown } ) -- %! Move focus to the next window
    , ((modMask,               xK_k     ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_m     ), windows W.focusMaster  ) -- %! Move focus to the master window

    -- modifying the window order
    , ((modMask .|. mod1Mask, xK_m), windows W.swapMaster) -- %! Swap the focused window and the master window
    , ((modMask .|. mod1Mask, xK_j     ), windows W.swapDown  ) -- %! Swap the focused window with the next window
    , ((modMask .|. mod1Mask, xK_k     ), windows W.swapUp    ) -- %! Swap the focused window with the previous window

    -- resizing the master/slave ratio
    , ((modMask,               xK_h     ), sendMessage Shrink) -- %! Shrink the master area
    , ((modMask,               xK_l     ), sendMessage Expand) -- %! Expand the master area

    -- floating layer support
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink) -- %! Push window back into tiling

    -- increase or decrease number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1)) -- %! Increment the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1))) -- %! Deincrement the number of windows in the master area

    -- quit, or restart
    , ((modMask .|. shiftMask, xK_e     ), io exitSuccess) -- %! Quit xmonad
    , ((modMask              , xK_q     ), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- %! Restart xmonad

    --ResizableTile keys
    , ((modMask,               xK_a), sendMessage MirrorShrink)
    , ((modMask,               xK_z), sendMessage MirrorExpand)

    , ((modMask,               xK_semicolon), nextMatch History (return True))

    --My desktop keys
    , ((modMask,               xK_Down     ), spawn "panel_volume -") -- %! Launch dmenu
    , ((modMask,               xK_Up     ), spawn "panel_volume +") -- %! Launch dmenu
    , ((modMask .|. mod1Mask,  xK_b     ), spawn "kbds") -- %! Launch dmenu
    , ((modMask .|. mod1Mask,  xK_h     ), spawn "systemctl hibernate") -- %! Launch dmenu
    , ((modMask,               xK_F7     ), spawn "mpc toggle") -- %! Launch dmenu
    , ((modMask .|. mod1Mask,  xK_t     ), spawn "toggle_mouse.sh") -- %! Launch dmenu
    , ((modMask .|. mod1Mask,  xK_r     ), spawn "urxvt -e ranger") -- %! Launch dmenu

    , ((modMask .|. shiftMask,               xK_l     ), sendMessage $ ExpandTowards R)
    , ((modMask .|. shiftMask,               xK_h     ), sendMessage $ ExpandTowards L)
    , ((modMask .|. shiftMask,               xK_j     ), sendMessage $ ExpandTowards D)
    , ((modMask .|. shiftMask,               xK_k     ), sendMessage $ ExpandTowards U)
    , ((modMask .|. shiftMask .|.  mod1Mask, xK_l     ), sendMessage $ ShrinkFrom R)
    , ((modMask .|. shiftMask .|.  mod1Mask, xK_h     ), sendMessage $ ShrinkFrom L)
    , ((modMask .|. shiftMask .|.  mod1Mask, xK_j     ), sendMessage $ ShrinkFrom D)
    , ((modMask .|. shiftMask .|.  mod1Mask, xK_k     ), sendMessage $ ShrinkFrom U)
    , ((modMask .|. shiftMask,               xK_p     ), sendMessage FocusParent)
    , ((modMask .|. shiftMask,               xK_s     ), sendMessage Swap)
    , ((modMask .|. shiftMask,               xK_r     ), sendMessage Rotate)
    , ((modMask .|. shiftMask,               xK_n     ), sendMessage SelectNode)

    --experimental
    , ((modMask, xK_F6     ), spawn "urxvt -e ncmpcpp")
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- mod-['u','i','o','p','['] %! Switch to workspace N
    -- mod-alt-['u','i','o','p','['] %! move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_u,xK_i,xK_o,xK_p,xK_bracketleft]
        , (f, m) <- [(W.greedyView, 0), (W.shift, mod1Mask)]]
    -- ++
    -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
    --[((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --    | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myManageHook = composeAll
                 [ className =? "URxvt" --> doF W.swapDown]

