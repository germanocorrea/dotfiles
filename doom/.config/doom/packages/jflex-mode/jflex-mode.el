                                        ; -*- Mode: Emacs-Lisp; -*-

;;;  jflex-mode

;;; Copyright 2015, Gerwin Klein <lsf@jflex.de>
;;; SPDX-License-Identifier: BSD-3-Clause

(require 'derived)
(require 'font-lock)
(require 'cc-mode)
(require 'cc-fonts)

(define-derived-mode jflex-mode java-mode "JFlex"
  "Major mode for editing JFlex files"

  ;; set the indentation
  (setq-local c-basic-offset 2)

  (c-set-offset 'knr-argdecl-intro 0)
  (c-set-offset 'topmost-intro-cont 0)

  ;; remove auto and hungry anything
  (c-toggle-auto-hungry-state -1)
  (c-toggle-auto-newline -1)
  (c-toggle-hungry-state -1)

  (use-local-map jflex-mode-map)

  ;; get rid of that damn electric-brace
  (define-key jflex-mode-map "{"	'self-insert-command)
  (define-key jflex-mode-map "}"	'self-insert-command)

  (define-key jflex-mode-map [tab] 'jflex-indent-command)

  (setq-local indent-line-function #'jflex-indent-line)

  (set (make-local-variable 'font-lock-defaults)
       '(jflex-font-lock-keywords
         nil nil ((?_ . "w")) beginning-of-defun)))

(defun jflex-indent-command (&optional arg)
  "Indent the current line like `c-indent-command' would.

cc-mode cannot always determine the syntactic context of a JFlex
line (e.g. top-level Java code, `%directives` and macro/rule
lines), in which case `c-guess-basic-syntax' signals
`wrong-type-argument'.  When that happens, just insert whitespace
up to the next tab stop instead of erroring out."
  (interactive "P")
  (condition-case-unless-debug _
      (c-indent-command arg)
    (error
     (insert-tab arg))))

(defun jflex-indent-line ()
  "Indent current line/region as JFlex/Java, never erroring.

cc-mode's syntactic parser (`c-guess-basic-syntax') fails on
lines that only make sense in a JFlex specification, such as
`%directives`, macro definitions, rule patterns and top-level
Java without a class wrapper.  Run cc-mode's indentation when we
can, and leave the buffer alone otherwise."
  (interactive)
  (condition-case-unless-debug _
      (c-indent-line-or-region)
    (error
     nil)))

(defconst jflex-font-lock-keywords
  (append
   '(
     ("^%%" . font-lock-constant-face)
     "^%{"
     "^%init{"
     "^%initthrow{"
     "^%eof{"
     "^%eofthrow{"
     "^%yylexthrow{"
     "^%eofval{"
     "^%}"
     "^%init}"
     "^%initthrow}"
     "^%eof}"
     "^%eofthrow}"
     "^%yylexthrow}"
     "^%eofval}"
     "^%standalone"
     "^%scanerror"
     "^%states" ; fixme: state identifiers
     "^%state"
     "^%s"
     "^%xstates"
     "^%xstate"
     "^%x"
     "^%char"
     "^%line"
     "^%column"
     "^%byaccj"
     "^%cupsym"
     "^%cupdebug"
     "^%cup"
     "^%eofclose"
     "^%class"
     "^%function"
     "^%type"
     "^%integer"
     "^%intwrap"
     "^%int"
     "^%yyeof"
     "^%notunix"
     "^%7bit"
     "^%full"
     "^%8bit"
     "^%unicode"
     "^%16bit"
     "^%caseless"
     "^%ignorecase"
     "^%implements"
     "^%extends"
     "^%public"
     "^%apiprivate"
     "^%final"
     "^%abstract"
     "^%debug"
     "^%pack"
     "^%include"
     "^%buffer"
     "^%initthrow"
     "^%eofthrow"
     "^%yylexthrow"
     "^%throws"
     "^%warn"
     "^%no-warn"
     "^%suppress"
     "^%no_suppress_warnings"
     "^%token_size_limit"
     ("%[%{}0-9a-zA-Z]+" . font-lock-warning-face) ; errors
     ("{[ \t]*[a-zA-Z][0-9a-zA-Z_]+[ \t]*}" . font-lock-variable-name-face) ; macro uses
     "<<EOF>>" ; special <<EOF>> symbol
     ("<[ \t]*[a-zA-Z][0-9a-zA-Z_]+[ \t]*\\(,[ \t]*[a-zA-Z][0-9a-zA-Z_]+[ \t]*\\)*>" . font-lock-type-face) ; lex state list
     )
   java-font-lock-keywords-2)
  "JFlex keywords for font-lock mode")

(provide 'jflex-mode)
