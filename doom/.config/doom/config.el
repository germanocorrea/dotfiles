;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function.

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-laserwave)
;; (setq doom-theme 'doom-horizon)
;;(setq doom-theme 'doom-manegarm)
;;(setq doom-theme 'doom-opera)
;; (setq doom-theme 'doom-sourcerer)
;; (setq doom-theme 'doom-rose-pine)

(setq user-full-name "Germano Bruscato Corrêa"
      user-mail-address "germanobruscato@gmail.com")

;; LAYOUT & STYLE
(setq display-line-numbers-type t)
(add-to-list 'default-frame-alist '(alpha-background . 85))
(setq doom-theme 'doom-jetbrains-islands-dark)
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14))
(setq doom-variable-pitch-font (font-spec :family "Faculty Glyphic" :size 16))
(add-hook 'org-mode-hook #'variable-pitch-mode)
(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode -1)))
(use-package mixed-pitch
  :hook
  ;; If you want it in all text modes:
  (text-mode . mixed-pitch-mode))
(custom-set-faces! ;; Line spacing in org titles
  '(org-level-1 :height 1.35 :line-spacing 0.2)
  '(org-level-2 :height 1.2  :line-spacing 0.15)
  '(org-level-3 :height 1.1  :line-spacing 0.1))

;; TABS - workspace & buffer bar
(after! tab-bar
  (setq tab-bar-show t
        tab-bar-new-tab-to-last t
        tab-bar-tab-hints nil
        tab-bar-close-button-show nil
        tab-bar-new-tab nil))


;; ORGMODE
(setq org-directory "~/org/")
(setq org-roam-directory "~/org/roam")
(org-roam-db-autosync-mode)
(add-to-list 'display-buffer-alist
             '("\\*org-roam\\*"
               (display-buffer-in-direction)
               (direction . right)
               (window-width . 0.33)
               (window-height . fit-window-to-buffer)))
(require 'org-roam-protocol)
(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam ;; or :after org
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(setq org-log-done 'note)
(setq org-icalendar-include-todo 'y)
(setq org-agenda-files (directory-files-recursively org-directory "org$"))
(setq org-icalendar-combined-agenda-file (concat org-directory "public/orgmode.ics"))
(setq org-icalendar-use-deadline '(event-if-todo-not-done))
(setq org-icalendar-use-scheduled '(event-if-todo-not-done))
;;(setq org-icalendar-after-save-hook )
(setq org-agenda-span 30)
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))
;; (setq org-agenda-include-diary t)

;;(setq org-latex-image-default-scale 0.5)
(setq org-format-latex-options '(:foreground default :background "Transparent" :scale 1))
(setq org-export-with-broken-links 'y)
(setq org-pad-client 'web)
(after! org-roam
  (add-hook 'org-mode-hook
            (lambda ()
              (when (org-roam-file-p)
                (unless (get-buffer-window org-roam-buffer)
                  (org-roam-buffer-toggle))))))


;; SPELLCHECK
;; (setq ispell-program-name "hunspell")
;; (setq ispell-dictionary "pt_BR,en_US")
;; (with-eval-after-load "ispell"
;;   (setq ispell-hunspell-dict-map-alist nil)
;;   (setq ispell-local-dictionary "pt_BR,en_US")
;;   (add-to-list 'ispell-local-dictionary-alist
;;                '("pt_BR,en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "pt_BR,en_US") nil utf-8)))

;; NVM
;; (let ((nvm-bin (car (last (sort (file-expand-wildcards "~/.nvm/versions/node/*/bin") #'string<)))))
;;   (when nvm-bin
;;     (add-to-list 'exec-path nvm-bin)))
(let ((path-from-nvm
       (string-trim
        (shell-command-to-string
         "zsh -c 'export NVM_DIR=$HOME/.nvm; source $NVM_DIR/nvm.sh; nvm use default >/dev/null 2>&1; echo $PATH'"))))
  (when (and path-from-nvm (not (string-empty-p path-from-nvm)))
    (setenv "PATH" path-from-nvm)
    (setq exec-path (append (split-string path-from-nvm ":") exec-path))))

;; LSP - PHPantom (PHP language server)
(after! lsp-mode
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("phpantom_lsp"))
    :activation-fn (lsp-activate-on "php")
    :server-id 'phpantom-ls)))

(use-package! phscroll
  :defer t
  :config
  (setq org-startup-truncated nil)
  (with-eval-after-load "org"
    (require 'org-phscroll)))

(autoload 'jflex-mode "jflex-mode" nil t)
(setq auto-mode-alist (cons '("\\(\\.flex\\|\\.jflex\\)\\'" . jflex-mode) auto-mode-alist))

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.node_modules\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.libs\\'")
  ;; (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]\\.my-files\\'"))
  )

;; MAGIT CONFIG
(after! magit
  (setq magit-diff-refine-hunk 'all)
  (setq magit-diff-refine-ignore-whitespace t)
  (setq magit-diff-fontify-hunk 'all))

;; EDIFF
(after! ediff
  (setq ediff-split-window-function 'split-window-horizontally)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  (setq ediff-auto-refine 'on)
  )
(custom-set-faces!
  '(ediff-current-diff-A :inherit magit-diff-removed-highlight :foreground unspecified)
  '(ediff-current-diff-B :inherit magit-diff-added-highlight :foreground unspecified)
  '(ediff-fine-diff-A :inherit diff-refine-removed :foreground unspecified)
  '(ediff-fine-diff-B :inherit diff-refine-added :foreground unspecified))
(add-hook 'ediff-startup-hook #'scroll-all-mode)
(add-hook 'ediff-quit-hook (lambda () (scroll-all-mode -1)))

;; INDENT BARS
(setq
 indent-bars-color '(highlight :face-bg t :blend 0.15)
 indent-bars-pattern "."
 indent-bars-width-frac 0.1
 indent-bars-pad-frac 0.1
 indent-bars-zigzag nil
 indent-bars-color-by-depth '(:regexp "outline-\\([0-9]+\\)" :blend 1) ; blend=1: blend with BG only
 indent-bars-highlight-current-depth '(:blend 0.5) ; pump up the BG blend on current
 indent-bars-display-on-blank-lines t)

;; AUTO CHANGE KEYBOARD LAYOUT ON INSERT MODE
;; Keyboard layouts:
;;      0 Portuguese (Brazil, IBM/Lenovo ThinkPad)
;;      1 English (US)
;;      2 English (US, intl., with dead keys)
(defun niri-set-layout (idx) (shell-command-to-string (concat "niri msg action switch-layout " idx)))
(defun niri-get-layout () (string-trim (shell-command-to-string "niri msg -j keyboard-layouts | jq .current_idx")))
(defvar niri-current-idx nil)
(add-hook
 'evil-insert-state-entry-hook
 (lambda ()
   (when (string-equal "2" (setq niri-current-idx (niri-get-layout)))
     (niri-set-layout "1"))
   )
 )

(add-hook
 'evil-insert-state-exit-hook
 (lambda ()
   (when niri-current-idx
     (niri-set-layout niri-current-idx))
   )
 )
