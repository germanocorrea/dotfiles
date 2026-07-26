;;; doom-jetbrains-islands-dark-theme.el --- Ported from Zed theme

(require 'doom-themes)

(def-doom-theme doom-jetbrains-islands-dark
  "JetBrains Islands Dark theme (ported from Zed)"

  ((bg         '("#191A1CFF" "#191A1CFF" "black"))
   (fg         '("#bcbec4ff" "#bcbec4ff" "brightwhite"))
   (comments   '("#7a7e85ff" "#7a7e85ff" "brightblack"))
   (keywords   '("#cf8e6dff" "#cf8e6dff" "magenta"))
   (strings    '("#6aab73" "#6aab73" "green"))
   (functions  '("#56A8F5" "#56A8F5" "blue"))
   (variables  '("#bcbec4ff" "#bcbec4ff" "red"))
   (types      '("#86985DFF" "#86985DFF" "yellow"))
   (constants  '("#c77dbbff" "#c77dbbff" "brightmagenta")))

  ((font-lock-comment-face       :foreground comments)
   (font-lock-keyword-face       :foreground keywords)
   (font-lock-string-face        :foreground strings)
   (font-lock-function-name-face :foreground functions)
   (font-lock-variable-name-face :foreground variables)
   (font-lock-type-face          :foreground types)
   (font-lock-constant-face      :foreground constants)
   (default                      :foreground fg :background bg)))

(provide 'doom-jetbrains-islands-dark-theme)
