;; ############################################################################
;; Change Emacs internal settings
;; ############################################################################

;; ----------------------------------------------------------------------------
;; Set plugin-independent gui settings early to avoid ugliness
;; ----------------------------------------------------------------------------

(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;;Set font
(set-default-font "Fira Mono-10")

(blink-cursor-mode 0)
(setq inhibit-startup-screen t)
(setq initial-scratch-message ";; Welcome")

(savehist-mode 1)

;; ----------------------------------------------------------------------------
;; Setup the getting of packages from melpa, etc.
;; ----------------------------------------------------------------------------

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org"         . "http://orgmode.org/elpa/"))
(package-initialize)

;; Install use-package if not installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
(require 'use-package))
(require 'diminish)
(require 'bind-key)

;; ############################################################################
;; Configuration of Packages
;; ############################################################################


;; ############################################################################
;; General UI
;; ############################################################################


;; ----------------------------------------------------------------------------
;; Evildoing
;; ----------------------------------------------------------------------------

(use-package evil-leader
  :init
  (setq evil-leader/no-prefix-mode-rx '("org-.*-mode" "magit-.*-mode"))
  (global-evil-leader-mode)
  :config
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key "SPC" 'counsel-M-x)
  )

(use-package evil
  :init
  (evil-mode t)
  :config

  (define-key evil-normal-state-map "L" 'evil-end-of-line)
  (define-key evil-visual-state-map "L" 'evil-last-non-blank)
  (define-key evil-normal-state-map "H" 'evil-beginning-of-visual-line)
  (define-key evil-visual-state-map "H" 'evil-beginning-of-visual-line)

  (define-prefix-command 'ftzm/window-map)
  (evil-leader/set-key "w" 'ftzm/window-map)
  (define-key ftzm/window-map "v" 'split-window-right)
  (define-key ftzm/window-map "s" 'split-window-below)
  (define-key ftzm/window-map "h" 'evil-window-left)
  (define-key ftzm/window-map "j" 'evil-window-down)
  (define-key ftzm/window-map "k" 'evil-window-up)
  (define-key ftzm/window-map "l" 'evil-window-right)
  (define-key ftzm/window-map "d" 'delete-window)

  (define-prefix-command 'ftzm/buffer-map)
  (evil-leader/set-key "b" 'ftzm/buffer-map)
  (define-key ftzm/buffer-map "d" 'evil-delete-buffer)
  (define-key ftzm/buffer-map "e" 'eval-buffer)

  (define-prefix-command 'ftzm/file-map)
  (evil-leader/set-key "f" 'ftzm/file-map)
  (define-key ftzm/file-map "s" 'save-buffer)
  (define-key ftzm/file-map "f" 'counsel-find-file)
  )

;; keeps a list of recently visisted files
(use-package recentf
  :init
  (recentf-mode 1)
  :config
  (setq recentf-max-menu-items 25)
  )

;; ----------------------------------------------------------------------------
;; Perspectives
;; ----------------------------------------------------------------------------

(use-package persp-mode
  :diminish persp-mode
  :config
  (setq persp-nil-name "Default")
  ;;(setq persp-autokill-buffer-on-remove 'kill-weak)
  (setq persp-autokill-buffer-on-remove nil) ;; kill-weak was causing problems
  (setq persp-autokill-persp-when-removed-last-buffer nil)
  (add-hook 'after-init-hook #'(lambda () (persp-mode 1)))

  (define-prefix-command 'ftzm/persp-mode-map)
  (evil-leader/set-key "s" 'ftzm/persp-mode-map)
  (define-key ftzm/persp-mode-map "s" 'persp-switch)
  (define-key ftzm/persp-mode-map "a" 'persp-add-buffer)
  (define-key ftzm/persp-mode-map "k" 'persp-prev)
  (define-key ftzm/persp-mode-map "j" 'persp-next)

  (with-eval-after-load "ivy"
    (add-hook 'ivy-ignore-buffers
              #'(lambda (b)
                  (when persp-mode
                    (let ((persp (get-current-persp)))
                      (if persp
                          (not (persp-contain-buffer-p b persp))
                        nil)))))

    (setq ivy-sort-functions-alist
          (append ivy-sort-functions-alist
                  '((persp-kill-buffer   . nil)
                    (persp-remove-buffer . nil)
                    (persp-add-buffer    . nil)
                    (persp-switch        . nil)
                    (persp-window-switch . nil)
                    (persp-frame-switch  . nil))))

  )
  )

;; ----------------------------------------------------------------------------
;; Motion Enhancement
;; ----------------------------------------------------------------------------

(use-package avy
  :config
  (define-key evil-normal-state-map "s" 'avy-goto-char-timer)
  (setq avy-timeout-seconds 0.2)
  )

;; ----------------------------------------------------------------------------
;; Undoing and redoing
;; ----------------------------------------------------------------------------

(use-package undo-tree
  :diminish undo-tree-mode
  )

;; ----------------------------------------------------------------------------
;; Parentheses improvement
;; ----------------------------------------------------------------------------

(use-package highlight-parentheses
  :diminish highlight-parentheses-mode
  :config
  (add-hook 'prog-mode-hook 'highlight-parentheses-mode)
  (set-face-attribute 'hl-paren-face nil :bold t)
  )

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  )

;; ----------------------------------------------------------------------------
;; Fuzzy file navigation
;; ----------------------------------------------------------------------------

(use-package smex) ;; makes ivy-M-x better, reorders function candidates

(use-package ivy
  :diminish ivy-mode
  :init
  (ivy-mode 1)
  :config
  (setq ivy-count-format "%d/%d - ")
  (evil-leader/set-key "bb" 'ivy-switch-buffer)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq counsel-find-file-ignore-regexp
        (concat
         ;; File names beginning with # or .
         "\\(?:\\`[#.]\\)"
         ;; File names ending with # or ~
         "\\|\\(?:\\`.+?[#~]\\'\\)"))

  ;;function to collect most recent 7 files, relies on recentf
  (defun recent-seven-files ()
    (cl-loop for item in recentf-list
             for i from 1 to 7
             collect item))

  (ivy-set-sources
   'counsel-find-file
   '((recent-seven-files)
     (original-source)))


    (with-eval-after-load 'org
      (define-key org-mode-map (kbd "C-c C-q") #'counsel-org-tag))
    (with-eval-after-load 'org-agenda
      (define-key org-agenda-mode-map (kbd "C-c C-q") #'counsel-org-tag-agenda))

  )

(use-package ivy-rich ;; This may eventually be merged into Ivy Master
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer 'ivy-rich-switch-buffer-transformer)
  (setq ivy-virtual-abbreviate 'full
      ivy-rich-switch-buffer-align-virtual-buffer t)
  (setq ivy-rich-abbreviate-paths t)
  )



;; ############################################################################
;; Language Specific Configuration
;; ############################################################################

;; ----------------------------------------------------------------------------
;; yaml
;; ----------------------------------------------------------------------------

(use-package yaml-mode)

;; ----------------------------------------------------------------------------
;; json
;; ----------------------------------------------------------------------------

(add-hook 'json-mode-hook #'flycheck-mode)


;; ----------------------------------------------------------------------------
;; haskell
;; ----------------------------------------------------------------------------

(use-package haskell-mode
  :mode "\\.hs\\'"
  )

(use-package intero
  :diminish "\\"
  :config
  (add-hook 'haskell-mode-hook 'intero-mode)
  )

;; ----------------------------------------------------------------------------
;; python
;; ----------------------------------------------------------------------------

(use-package anaconda-mode
  :diminish "A"
  :config
  (add-hook 'python-mode-hook 'anaconda-mode)
  )

;; ----------------------------------------------------------------------------
;; Dockerfile
;; ----------------------------------------------------------------------------


(use-package dockerfile-mode
  :config
  (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
  )

;; ----------------------------------------------------------------------------
;; Prose
;; ----------------------------------------------------------------------------

;; just to make visual line mode available and diminished
(use-package simple
  :diminish visual-line-mode
  )

;; Camel Case recognition, works with evil mode movement
(use-package subword
  :diminish subword-mode
  :config
  (add-hook 'prog-mode-hook 'subword-mode)
  )

(use-package olivetti
  :diminish "O"
  )

;; ----------------------------------------------------------------------------
;; Autocompletion
;; ----------------------------------------------------------------------------

(use-package company
  :diminish company-mode
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-idle-delay .1)
  (setq company-minimum-prefix-length 1)

  ;; make <tab> cycle & <backtab> cycle back
  (define-key company-active-map [tab] 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
  (define-key company-active-map [backtab] 'company-select-previous)

  ;; set default `company-backends'
  (setq company-backends
    '((company-files          ; files & directory
     company-keywords       ; keywords
     company-capf
     ;;company-yasnippet ;;not using atm
     )
    (company-abbrev company-dabbrev)
    ))

  (add-hook 'python-mode-hook
            (lambda ()
              (add-to-list (make-local-variable 'company-backends)
                           'company-anaconda)))
  (add-hook 'elisp-mode-hook
            (lambda ()
              (add-to-list (make-local-variable 'company-backends)
                           'company-elisp)))

;; Below: more involved specification of backends that I may employ later

;;(dolist (hook '(js-mode-hook
;;                js2-mode-hook
;;                js3-mode-hook
;;                inferior-js-mode-hook
;;                ))
;;  (add-hook hook
;;            (lambda ()
;;              (tern-mode t)
;;
;;              (add-to-list (make-local-variable 'company-backends)
;;                           'company-tern)
;;              )))

;;;;;_. company-mode support like auto-complete in web-mode
;;
;;;; Enable CSS completion between <style>...</style>
;;(defadvice company-css (before web-mode-set-up-ac-sources activate)
;;  "Set CSS completion based on current language before running `company-css'."
;;  (if (equal major-mode 'web-mode)
;;      (let ((web-mode-cur-language (web-mode-language-at-pos)))
;;        (if (string= web-mode-cur-language "css")
;;            (unless css-mode (css-mode))))))
;;
;;;; Enable JavaScript completion between <script>...</script> etc.
;;(defadvice company-tern (before web-mode-set-up-ac-sources activate)
;;  "Set `tern-mode' based on current language before running `company-tern'."
;;  (if (equal major-mode 'web-mode)
;;      (let ((web-mode-cur-language (web-mode-language-at-pos)))
;;        (if (or (string= web-mode-cur-language "javascript")
;;               (string= web-mode-cur-language "jsx"))
;;            (unless tern-mode (tern-mode))
;;          ;; (if tern-mode (tern-mode))
;;          ))))


  )

;; ############################################################################
;; Syntax
;; ############################################################################

(use-package flycheck
  :diminish "S"
  :config
  (setq flycheck-check-syntax-automatically '(mode-enabled save))
  )

(use-package projectile
  :diminish projectile-mode
  :init
  (projectile-mode)
  :config
  (setq projectile-completion-system 'ivy) ;;requires ivy

  (define-prefix-command 'ftzm/projectile-map)
  (evil-leader/set-key "p" 'ftzm/projectile-map)
  (define-key ftzm/projectile-map "f" 'counsel-projectile)
  (define-key ftzm/projectile-map "p" 'counsel-projectile-switch-project)
  )

(use-package spaceline-config
  ;;:ensure spaceline
  :config
  (setq powerline-default-separator 'wave)
  (spaceline-toggle-buffer-size-off)
  (spaceline-toggle-hud-off)
  (spaceline-toggle-buffer-position-off)
  (spaceline-toggle-buffer-encoding-abbrev-off)
  (spaceline-toggle-version-control-off)
  (spaceline-toggle-evil-state-off)
  (spaceline-toggle-persp-name-on)
  (spaceline-spacemacs-theme))

;; ############################################################################
;; Org
;; ############################################################################

(use-package org-indent
  :diminish org-indent-mode
  )


(use-package org
  :mode (("\\.org$" . org-mode))
  ;;:ensure org-plus-contrib
  :config
  (progn
    (setq org-directory "~/org")
    (add-hook 'org-mode-hook 'org-indent-mode)
    (add-hook 'org-mode-hook 'olivetti-mode)

    ;; apply CLOSED property on done
    (setq org-log-done 'time)

    (define-prefix-command 'ftzm/org-mode-map)
    (evil-leader/set-key "o" 'ftzm/org-mode-map)
    (define-key ftzm/org-mode-map "c" 'org-capture)
    (define-key ftzm/org-mode-map "a" 'org-agenda)
    (define-key ftzm/org-mode-map "l" 'org-agenda-list)
    (define-key ftzm/org-mode-map "t" 'org-todo-list)

    ;;;; org-capture setting
    ;; Start capture mode in evil insert state

    ;; Map for my custom ',' prefix in capture mode
    (define-prefix-command 'ftzm/capture-mode-map)
    (evil-define-key 'normal org-capture-mode-map "," 'ftzm/capture-mode-map)
    (define-key ftzm/capture-mode-map "k" 'org-capture-kill)
    (define-key ftzm/capture-mode-map "r" 'org-capture-refile)
    (define-key ftzm/capture-mode-map "c" 'org-capture-finalize)


    (add-hook 'org-capture-mode-hook 'evil-insert-state)

    (setq org-capture-templates
        (quote (("t" "todo" entry (file+headline "~/org/refile.org" "Tasks")
                "* TODO %?\n  SCHEDULED: %t")
                ("n" "note" entry (file+headline "~/org/refile.org" "Notes")
                "* %?")
                ;;"* TODO %?\n%U\n%a\n")
    )))
    (setq org-default-notes-file "~/org/refile.org")
    (evil-leader/set-key "oc" 'org-capture)



    ;; Exclude DONE state tasks from refile targets
    (defun bh/verify-refile-target ()
    "Exclude todo keywords with a done state from refile targets"
    (not (member (nth 2 (org-heading-components)) org-done-keywords)))

    (setq org-refile-target-verify-function 'bh/verify-refile-target)

    ;; allow refiling 9 levels deep
    (setq org-refile-targets '((nil :maxlevel . 9)
                                  (org-agenda-files :maxlevel . 9)))

    ;; Refile in a single go
    (setq org-outline-path-complete-in-steps nil)

    ;; show full path for refiling, preceeded by the filename.
    (setq org-refile-use-outline-path 'file)
    ;; config stuff

    ;; Agenda Mode Settings
    (setq org-deadline-warning-days 7)


    (setq org-agenda-prefix-format '(
      ;;(agenda  . " %i %-12:c%?-12t% s") ;; file name + org-agenda-entry-type
      (agenda  . " %i %?-12t% s") ;; remove file name (And hopefully just that)
      (timeline  . "  % s")
      (todo  . " %i %-12:c")
      (tags  . " %i %-12:c")
      (search . " %i %-12:c")))

    ;; Custom sorting in agenda mode
    (setq org-agenda-sorting-strategy
      '((agenda time-up todo-state-down scheduled-up priority-down)
      ;; Original value of above:
      ;;(agenda habit-down time-up priority-down category-keep)
        (todo priority-down category-up)
        (tags priority-down category-keep)
        (search category-keep)))

    ;; VI keybinds for agenda mode stolen from abandonware "evil-rebellion"
    ;; Now has been customized a fair bit actually
    (evil-set-initial-state 'org-agenda-mode 'normal)


    (defun ftzm/agenda-remove-schedule ()
      (interactive)
      (org-agenda-schedule '(4))
      )

    ;; Map for my custom ',' prefix.
    (define-prefix-command 'ftzm/agenda-mode-map)
    (define-key ftzm/agenda-mode-map "w" 'org-agenda-week-view)
    (define-key ftzm/agenda-mode-map "D" 'org-agenda-day-view)
    (define-key ftzm/agenda-mode-map "d" 'org-agenda-deadline)
    (define-key ftzm/agenda-mode-map "r" 'org-agenda-refile)
    (define-key ftzm/agenda-mode-map "s" 'org-agenda-schedule)
    (define-key ftzm/agenda-mode-map "p" 'org-agenda-priority)
    (define-key ftzm/agenda-mode-map "f" 'org-agenda-filter-by-tag)
    (define-key ftzm/agenda-mode-map "cs" 'ftzm/agenda-remove-schedule)

    (evil-define-key 'normal org-agenda-mode-map
      (kbd "<DEL>") 'org-agenda-show-scroll-down
      (kbd "<RET>") 'org-agenda-switch-to
      (kbd "\t") 'org-agenda-goto
      "\C-n" 'org-agenda-next-line
      "\C-p" 'org-agenda-previous-line
      "\C-r" 'org-agenda-redo
      "a" 'org-agenda-archive-default-with-confirmation
      ;b
      "c" 'org-agenda-goto-calendar
      "d" 'org-agenda-day-view
      "e" 'org-agenda-set-effort
      "f"  'org-agenda-later
      "g " 'org-agenda-show-and-scroll-up
      "gG" 'org-agenda-toggle-time-grid
      "gh" 'org-agenda-holidays
      "gj" 'org-agenda-goto-date
      "gJ" 'org-agenda-clock-goto
      "gk" 'org-agenda-action
      "gm" 'org-agenda-bulk-mark
      "go" 'org-agenda-open-link
      "gO" 'delete-other-windows
      "gr" 'org-agenda-redo
      "gv" 'org-agenda-view-mode-dispatch
      "gw" 'org-agenda-week-view
      "g/" 'org-agenda-filter-by-tag
      ;"h"  'org-agenda-earlier
      "b"  'org-agenda-earlier
      "i"  'org-agenda-diary-entry
      "j"  'org-agenda-next-line
      "k"  'org-agenda-previous-line
      ;"l"  'org-agenda-later
      "m" 'org-agenda-bulk-mark
      ;"n" nil                           ; evil-search-next
      "o" 'delete-other-windows
      ;p
      "q" 'org-agenda-quit
      "r" 'org-agenda-redo
      ;;"s" 'org-agenda-schedule ;;conflicts with avy
      "t" 'org-agenda-todo
      "u" 'org-agenda-bulk-unmark
      ;v
      "W" 'org-agenda-week-view
      "x" 'org-agenda-exit
      "y" 'org-agenda-year-view
      "z" 'org-agenda-add-note
      "{" 'org-agenda-manipulate-query-add-re
      "}" 'org-agenda-manipulate-query-subtract-re
      "$" 'org-agenda-archive
      "%" 'org-agenda-bulk-mark-regexp
      "+" 'org-agenda-priority-up
      ;"," 'org-agenda-priority
      "-" 'org-agenda-priority-down
      "." 'org-agenda-goto-today
      "0" 'evil-digit-argument-or-evil-beginning-of-line
      ":" 'org-agenda-set-tags
      ";" 'org-timer-set-timer
      "<" 'org-agenda-filter-by-category
      ">" 'org-agenda-date-prompt
      "?" 'org-agenda-show-the-flagging-note
      "A" 'org-agenda-append-agenda
      "B" 'org-agenda-bulk-action
      "C" 'org-agenda-convert-date
      ;;"D" 'org-agenda-toggle-diary
      "D" 'org-agenda-day-view
      "E" 'org-agenda-entry-text-mode
      "F" 'org-agenda-follow-mode
      ;G
      "H" 'org-agenda-holidays
      "I" 'org-agenda-clock-in
      "J" 'org-agenda-next-date-line
      "K" 'org-agenda-previous-date-line
      "L" 'org-agenda-recenter
      "M" 'org-agenda-phases-of-moon
      ;N
      "O" 'org-agenda-clock-out
      "P" 'org-agenda-show-priority
      ;Q
      "R" 'org-agenda-refile
      ;;"R" 'org-agenda-clockreport-mode ;; Maybe reassign if I learn what do
      ;;"S" 'org-save-all-org-buffers
      "S" 'org-agenda-schedule
      "T" 'org-agenda-show-tags
      ;U
      ;V
      ;W
      "X" 'org-agenda-clock-cancel
      ;Y
      ;Z
      "[" 'org-agenda-manipulate-query-add
      "g\\" 'org-agenda-filter-by-tag-refine
      "]" 'org-agenda-manipulate-query-subtract

      ;; prefix for my custom map
      "," 'ftzm/agenda-mode-map


      ))

    )

;;(use-package org-habit) ;; I can never get this to work

(use-package evil-org
  :diminish evil-org-mode
  ;; Personal edits avoiding keybind collision
  :load-path "plugins/evil-org-mode/"
  :config
  )

;; ############################################################################
;; Global Key Binds
;; ############################################################################
(global-set-key (kbd "<escape>")      'keyboard-escape-quit)


;; ############################################################################
;; Configure gui that may rely on plugins being intialized
;; ############################################################################

;; load syntax coloring theme. Applied also to some other gui.
(load-theme 'gruvbox t)

;; disable fringe
(set-fringe-mode 0)

;; ############################################################################
;; Beware: here be custom-set-variables. Best don't touch.
;; ############################################################################

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(custom-safe-themes
   (quote
    ("fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" default)))
 '(org-agenda-files
   (quote
    ("~/dev/hnefatafl/hnefatafl.org" "~/org/refile.org" "~/org/tasks.org")))
 '(package-selected-packages
   (quote
    (yaml-mode flymake-yaml workgroups2 company-anaconda dockerfile-mode spacemacs-theme persp-mode eyebrowse highlight-parentheses rainbow-delimiters company-ghc haskell-mode helm gruvbox-theme evil-visual-mark-mode evil-leader smex)))
 '(safe-local-variable-values (quote ((eval progn (pp-buffer) (indent-buffer))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ivy-current-match ((t (:foreground "#8ec07c" :underline nil :weight normal))))
 '(success ((t (:foreground "#b8bb26" :weight normal))))
 '(warning ((t (:foreground "#fe8019" :weight normal)))))
