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
;; (add-to-list 'default-frame-alist '(alpha-background . 80))
(setq doom-theme 'doom-jetbrains-islands-dark)
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14))
(use-package mixed-pitch
  :hook
  ;; If you want it in all text modes:
  (text-mode . mixed-pitch-mode))

;; TABS - workspace & buffer bar
(after! tab-bar
  (setq tab-bar-show t
        tab-bar-new-tab-to-last t
        tab-bar-tab-hints nil
        tab-bar-close-button-show nil
        tab-bar-new-tab nil))

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

(defun my/disable-line-numbers (&optional dummy)
  (display-line-numbers-mode -1))
(add-hook 'neo-after-create-hook 'my/disable-line-numbers)
(with-eval-after-load 'lsp-mode
  (dolist (re '("[/\\\\]\\.git\\'"
                "[/\\\\]node_modules\\'"
                "[/\\\\]vendor\\'"
                "[/\\\\]libs[/\\\\]vendor\\'"
                "[/\\\\]\\.claude[/\\\\]worktrees\\'"
                "[/\\\\]build\\'"
                "[/\\\\]tmp\\'"
                "[/\\\\]tmp_ai_docs\\'"
                "[/\\\\]downloads\\'"
                "[/\\\\]\\.codegen[/\\\\]generated\\'"
                "[/\\\\]coverage\\'"
                "[/\\\\]tests-coverage\\'"
                "[/\\\\]\\.jest-cache\\'"
                "[/\\\\]images\\'"
                "[/\\\\]spikes\\'"
                "[/\\\\]\\.opencode\\'"
                "[/\\\\]\\.\\(idea\\|vscode\\|cursor\\|windsurf\\|devin\\|gemini\\)\\'"))
    (add-to-list 'lsp-file-watch-ignored-directories re)))

(setq lsp-file-watch-threshold 15000)

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

(add-to-list 'default-frame-alist '(undecorated . t))
