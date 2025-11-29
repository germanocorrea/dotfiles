-- Necessário para a barra não ser coberta
-- Necessário para enviar infos para a barra

import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe)

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $
    docks $
      def
        { modMask = mod4Mask,
          terminal = "kitty",
          -- LayoutHook: avoidStruts faz as janelas respeitarem o espaço da barra
          layoutHook = avoidStruts $ layoutHook def,
          -- LogHook: Envia as informações dos workspaces para o xmobar
          logHook =
            dynamicLogWithPP $
              xmobarPP
                { ppOutput = hPutStrLn xmproc,
                  ppTitle = xmobarColor "green" "" . shorten 50
                }
        }
