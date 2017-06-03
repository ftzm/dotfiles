;; ############################################################################
;; Change Emacs internal settings
;; ############################################################################

;; ----------------------------------------------------------------------------
;; Set plugin-independent gui settings early to avoid ugliness
;; ----------------------------------------------------------------------------

(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;Set font
(add-to-list 'default-frame-alist '(font . "Fira Code-16" ))

(set-fontset-font t 'japanese-jisx0208
                  (font-spec :family "IPAGothic" :size 24))

(blink-cursor-mode 0)
(setq visible-cursor nil) ;; no blink in term

(setq inhibit-startup-screen t)
(setq initial-scratch-message ";; Welcome")

(savehist-mode 1)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq vc-follow-symlinks t)

;; ############################################################################
;; Setup the getting of packages from melpa, etc.
;; ############################################################################

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
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
;; Default Text Scale
;; ----------------------------------------------------------------------------

(use-package default-text-scale
  :config
  (setq default-text-scale-amount 60)
  )

;; ----------------------------------------------------------------------------
;; Spaceline
;; ----------------------------------------------------------------------------

(use-package spaceline :demand t)
(use-package spaceline-config
  :ensure spaceline
  :config
  (if (display-graphic-p)
      (progn
  	(setq powerline-default-separator 'slant)
  	)
    (progn
      (setq powerline-default-separator nil)
      )
    )
  (spaceline-spacemacs-theme)
  (spaceline-toggle-buffer-size-off)
  (spaceline-toggle-hud-off)
  ;(spaceline-toggle-buffer-position-off)
  (spaceline-toggle-buffer-encoding-abbrev-off)
  (spaceline-toggle-version-control-off)
  (spaceline-toggle-evil-state-off)
  (spaceline-toggle-workspace-number-on)
  (spaceline-toggle-projectile-root-on)
  )


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
  (define-prefix-command 'app-keys)
  (evil-leader/set-key "a" 'app-keys)
  (define-prefix-command 'theme-keys)
  (evil-leader/set-key "t" 'theme-keys)
  (define-key theme-keys "b" 'default-text-scale-increase)
  (define-key theme-keys "s" 'default-text-scale-decrease)
  )

(use-package evil
  :init
  (evil-mode t)
  :config

  (defun add-line-above ()
    (interactive)
    (setq last-command-event 109)
    (evil-set-marker 126)
    (evil-open-above 1)
    (setq last-command-event 'escape)
    (evil-normal-state)
    (setq last-command-event 96)
    (evil-goto-mark 126)
    )

  (defun add-line-below ()
    (interactive)
    (setq last-command-event 109)
    (evil-set-marker 126)
    (evil-open-below 1)
    (setq last-command-event 'escape)
    (evil-normal-state)
    (setq last-command-event 96)
    (evil-goto-mark 126)
    (setq last-command-event 'f4))

  (define-key evil-normal-state-map (kbd "C-i") 'evil-jump-forward)
  (define-key evil-normal-state-map "L" 'evil-end-of-line)
  (define-key evil-visual-state-map "L" 'evil-last-non-blank)
  (define-key evil-normal-state-map "H" 'beginning-of-line-text)
  (define-key evil-visual-state-map "H" 'beginning-of-line-text)
  (define-key evil-normal-state-map (kbd "[ SPC") 'add-line-above)
  (define-key evil-normal-state-map (kbd "] SPC") 'add-line-below)

  (define-prefix-command 'window-keys)
  (evil-leader/set-key "w" 'window-keys)
  (define-key window-keys "v" 'split-window-right)
  (define-key window-keys "s" 'split-window-below)
  (define-key window-keys "h" 'evil-window-left)
  (define-key window-keys "j" 'evil-window-down)
  (define-key window-keys "k" 'evil-window-up)
  (define-key window-keys "l" 'evil-window-right)
  (define-key window-keys "H" 'evil-window-move-far-left)
  (define-key window-keys "J" 'evil-window-move-very-bottom)
  (define-key window-keys "K" 'evil-window-move-very-top)
  (define-key window-keys "L" 'evil-window-move-far-right)
  (define-key window-keys "r" 'evil-window-rotate-downwards)
  (define-key window-keys "R" 'evil-window-rotate-upwards)
  (define-key window-keys "d" 'delete-window)

  (define-prefix-command 'buffer-keys)
  (evil-leader/set-key "b" 'buffer-keys)
  (define-key buffer-keys "d" 'evil-delete-buffer)
  (define-key buffer-keys "e" 'eval-buffer)
  (define-key buffer-keys "k" 'evil-prev-buffer)
  (define-key buffer-keys "j" 'evil-next-buffer)

  (define-prefix-command 'file-keys)
  (evil-leader/set-key "f" 'file-keys)
  (define-key file-keys "s" 'save-buffer)
  (define-key file-keys "f" 'counsel-find-file)
  (define-key file-keys "w" 'write-file)

  (defun agenda-remove-schedule ()
    (interactive)
    (org-agenda-schedule '(4))
    )

  (add-hook 'org-mode-hook
	    (lambda ()
	      (define-key evil-normal-state-map (kbd "TAB") 'org-cycle)))
  )

(use-package evil-surround
  :config
  (global-evil-surround-mode 1)
  )

;; keeps a list of recently visisted files
(use-package recentf
  :init
  (recentf-mode 1)
  :config
  (setq recentf-max-menu-items 25)
  )

;; ----------------------------------------------------------------------------
;; Which-Key - Shows potential followup keys after pressing a key
;; ----------------------------------------------------------------------------

(use-package which-key
  :diminish which-key-mode
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3)
  )


;; ----------------------------------------------------------------------------
;; Dired keys
;; ----------------------------------------------------------------------------

(define-key app-keys "d" 'dired)
(eval-after-load 'dired
  '(progn
     (evil-define-key 'normal dired-mode-map
       "G" 'evil-goto-line
       "gg" 'evil-goto-first-line
       "K" 'dired-kill-subdir
       "S" 'dired-sort-toggle-or-edit
       "s" 'avy-goto-char-timer
       ")" 'dired-next-subdir
       "(" 'dired-prev-subdir)))

;; ----------------------------------------------------------------------------
;; Eyebrowse
;; ----------------------------------------------------------------------------

(use-package eyebrowse
  :init
  (eyebrowse-mode 1)
  :config
  (define-prefix-command 'eyebrowse-keys)
  (evil-leader/set-key "s" 'eyebrowse-keys)
  (define-key eyebrowse-keys "s" 'eyebrowse-switch-to-window-config)
  (define-key eyebrowse-keys "l" 'eyebrowse-last-window-config)
  (define-key eyebrowse-keys "k" 'eyebrowse-prev-window-config)
  (define-key eyebrowse-keys "j" 'eyebrowse-next-window-config)
  (define-key eyebrowse-keys "a" 'eyebrowse-create-window-config)
  (define-key eyebrowse-keys "r" 'eyebrowse-rename-window-config)
  (define-key eyebrowse-keys "d" 'eyebrowse-close-window-config)

  (define-key evil-normal-state-map (kbd "M-1") 'eyebrowse-switch-to-window-config-1)
  (define-key evil-normal-state-map (kbd "M-2") 'eyebrowse-switch-to-window-config-2)
  (define-key evil-normal-state-map (kbd "M-3") 'eyebrowse-switch-to-window-config-3)
  (define-key evil-normal-state-map (kbd "M-4") 'eyebrowse-switch-to-window-config-4)
  (define-key evil-normal-state-map (kbd "M-5") 'eyebrowse-switch-to-window-config-5)
  (define-key evil-normal-state-map (kbd "M-6") 'eyebrowse-switch-to-window-config-6)
  (define-key evil-normal-state-map (kbd "M-7") 'eyebrowse-switch-to-window-config-7)
  (define-key evil-normal-state-map (kbd "M-8") 'eyebrowse-switch-to-window-config-8)
  (define-key evil-normal-state-map (kbd "M-9") 'eyebrowse-switch-to-window-config-9) ;
  (define-key evil-normal-state-map (kbd "M-0") 'eyebrowse-switch-to-window-config-0)
  )


;; ----------------------------------------------------------------------------
;; Desktop Save
;; ----------------------------------------------------------------------------

;;(use-package desktop
;;  :config
;;  (desktop-save-mode 1)
;;
;;  (setq desktop-path '("~/.emacs.d/"))
;;  (setq desktop-dirname "~/.emacs.d/")
;;  (setq desktop-base-file-name "emacs-desktop")

  ;;(setq desktop-buffers-not-to-save
       ;;(concat "\\("
               ;;"^nn\\.a[0-9]+\\|\\.log\\|(ftp)\\|^tags\\|^TAGS"
               ;;"\\.diary\\|\\.newsrc-dribble\\|\\.bbdb"
        ;;"\\)$"))
  ;;(add-to-list 'desktop-modes-not-to-save 'dired-mode)
  ;;(add-to-list 'desktop-modes-not-to-save 'Info-mode)
  ;;(add-to-list 'desktop-modes-not-to-save 'info-lookup-mode)
  ;;(add-to-list 'desktop-modes-not-to-save 'fundamental-mode)
  ;;(add-to-list 'desktop-modes-not-to-save 'magit-auto-revert-mode)
  ;)

;; ----------------------------------------------------------------------------
;; PERSPECTIVES
;; ----------------------------------------------------------------------------

;(use-package persp-mode
;  :diminish persp-mode
;  :config
;  (setq persp-nil-name "Default")
;  ;;(setq persp-autokill-buffer-on-remove 'kill-weak)
;  (setq persp-autokill-buffer-on-remove nil) ;; kill-weak was causing problems
;  (setq persp-autokill-persp-when-removed-last-buffer nil)
;  (add-hook 'after-init-hook #'(lambda () (persp-mode 1)))
;
;  (define-prefix-command 'persp-mode-map)
;  (evil-leader/set-key "s" 'persp-mode-map)
;  (define-key persp-mode-map "s" 'persp-switch)
;  (define-key persp-mode-map "a" 'persp-add-buffer)
;  (define-key persp-mode-map "k" 'persp-prev)
;  (define-key persp-mode-map "j" 'persp-next)
;
;  (with-eval-after-load "ivy"
;    (add-hook 'ivy-ignore-buffers
;              #'(lambda (b)
;                  (when persp-mode
;                    (let ((persp (get-current-persp)))
;                      (if persp
;                          (not (persp-contain-buffer-p b persp))
;                        nil)))))
;
;    (setq ivy-sort-functions-alist
;          (append ivy-sort-functions-alist
;                  '((persp-kill-buffer   . nil)
;                    (persp-remove-buffer . nil)
;                    (persp-add-buffer    . nil)
;                    (persp-switch        . nil)
;                    (persp-window-switch . nil)
;                    (persp-frame-switch  . nil))))
;
;  )
;  )

;; ----------------------------------------------------------------------------
;; Motion Enhancement
;; ----------------------------------------------------------------------------

(use-package avy
  :config
  (define-key evil-normal-state-map "s" 'avy-goto-char-timer)
  (setq avy-timeout-seconds 0.2)
  (setq avy-all-windows nil)
  (setq avy-keys '(?f ?d ?s ?a ?g ?k ?l ?\; ?h ?r ?e ?w ?q ?t ?u ?i ?o ?p ?y ?v
  ?c ?x ?z ?n ?m ?b ?, ?. ?/ ?j))
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
;; Autofill
;; ----------------------------------------------------------------------------

(add-hook 'emacs-lisp-mode-hook
	  'auto-fill-mode)

(add-hook 'haskell-mode-hook
	  'auto-fill-mode)

(add-hook 'python-mode-hook
	  'auto-fill-mode)

(diminish 'auto-fill-function)

(setq-default fill-column 79)

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
  (setq ivy-height 15)
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
  ;(defun recent-seven-files ()
  ;  (cl-loop for item in recentf-list
  ;           for i from 1 to 7
  ;           collect item))

  ;(ivy-set-sources
  ; 'counsel-find-file
  ; '((recent-seven-files)
  ;   (original-source)))

  (define-prefix-command 'ivy-keys)
  (evil-leader/set-key "i" 'ivy-keys)
  (define-key ivy-keys "i" 'counsel-imenu)
  (define-key ivy-keys "g" 'counsel-grep)

  ;alternate cycle keys, more vimy
  (define-key ivy-minibuffer-map (kbd "C-j") 'ivy-next-line)
  (define-key ivy-minibuffer-map (kbd "C-k") 'ivy-previous-line)

  ;; below works but slow
  (defconst modi/ag-arguments
  '("--nogroup" ; mandatory argument for ag.el as per https://github.com/Wilfred/ag.el/issues/41
      ;"--skip-vcs-ignores" ; Ignore files/dirs ONLY from `.agignore'
      "--numbers" ; line numbers
      "--smart-case"
      "--follow") ; follow symlinks
  "Default ag arguments used in the functions in `ag', `counsel' and `projectile'
      packages.")

  ;; Use `ag' all the time if available
  (defun modi/advice-projectile-use-ag ()
    "Always use `ag' for getting a list of all files in the project."
    (mapconcat 'identity
           (append '("\\ag") ; used unaliased version of `ag': \ag
               modi/ag-arguments
               '("-0" ; output null separated results
             "-g ''")) ; get file names matching the regex '' (all files)
           " "))
  (when (executable-find "ag")
    (advice-add 'projectile-get-ext-command :override
        #'modi/advice-projectile-use-ag))

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


;; ----------------------------------------------------------------------------
;; Icons
;; ----------------------------------------------------------------------------

(use-package all-the-icons
  :load-path "plugins/all-the-icons.el/"
  )

;; ----------------------------------------------------------------------------
;; Hydra
;; ----------------------------------------------------------------------------

(use-package hydra)

(defhydra hydra-window-size (evil-normal-state-map "SPC w")
  "change window size"
;;  "
;;^Mark^             ^Unmark^           ^Actions^          ^Search
;;^^^^^^^^-----------------------------------------------------------------
;;_m_: mark          _u_: unmark        _x_: execute       _R_: re-isearch
;;_s_: save          _U_: unmark up     _b_: bury          _I_: isearch
;;_d_: delete        ^ ^                _g_: refresh       _O_: multi-occur
;;_D_: delete up     ^ ^                _T_: files only: % -28`Buffer-menu-files-only
;;_~_: modified
;;"

  ("w" evil-window-increase-width)
  ("n" evil-window-decrease-width))

;; ----------------------------------------------------------------------------
;; File Tree (Neotree)
;; ----------------------------------------------------------------------------

(use-package neotree
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (global-set-key [f8] 'neotree-toggle)
  ;(setq projectile-switch-project-action 'neotree-projectile-action)
  (setq neo-smart-open t)
  (evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
  (evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
  (setq neo-window-width 36)
  )

;; ----------------------------------------------------------------------------
;; Magit
;; ----------------------------------------------------------------------------

(use-package magit
  :config
  (define-prefix-command 'magit-keys)
  (evil-leader/set-key "m" 'magit-keys)
  (define-key magit-keys "s" 'magit-status)
  (define-key magit-keys "b" 'magit-blame-toggle)
  (define-key magit-keys "B" 'magit-blame-quit)

  (defun magit-blame-toggle()
    "WORKAROUND https://github.com/magit/magit/issues/1987"
    (interactive)
    (let* ((active (--filter (and (boundp it) (symbol-value it)) minor-mode-list)))
      (if (member 'magit-blame-mode active)
          (magit-blame-quit)
        (magit-blame nil buffer-file-name))))

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
  (with-eval-after-load 'flycheck
    (flycheck-add-next-checker 'intero '(warning . haskell-hlint)))
  )

;; ----------------------------------------------------------------------------
;; python
;; ----------------------------------------------------------------------------

(use-package anaconda-mode
  :diminish "A"
  :config
  (add-hook 'python-mode-hook 'anaconda-mode)

  (add-hook 'python-mode-hook (lambda ()
  			      (flycheck-mode 1)
  			      (setq flycheck-checker 'python-pylint
  				    flycheck-checker-error-threshold 900)))

  (defun pyvenv-and-fly (directory)
    "open interactive menu to choose the virtualenv (choose venv root), then
     restart flycheck."
    (interactive "DActivate venv: ")
    (pyvenv-activate directory)
    (flycheck-mode 0)
    (flycheck-mode 1)
    )

  (define-prefix-command 'python-mode-keys)
  (evil-define-key 'normal python-mode-map (kbd ",") 'python-mode-keys)
  (define-key python-mode-keys "v" 'pyvenv-and-fly)
  (define-key python-mode-keys "d" 'dumb-jump-go)

  ;(require 'auto-virtualenv)
  ;(add-hook 'python-mode-hook 'auto-virtualenv-set-virtualenv)
  ;
  ;(declare-function python-shell-calculate-exec-path "python")
  ;
  ;(defun flycheck-virtualenv-executable-find (executable)
  ;  "Find an EXECUTABLE in the current virtualenv if any."
  ;  (if (bound-and-true-p python-shell-virtualenv-root)
  ;      (let ((exec-path (python-shell-calculate-exec-path)))
  ;        (executable-find executable))
  ;    (executable-find executable)))
  ;
  ;(defun flycheck-virtualenv-setup ()
  ;  "Setup Flycheck for the current virtualenv."
  ;  (setq-local flycheck-executable-find #'flycheck-virtualenv-executable-find))
  ;
  ;(add-hook 'python-mode-hook #'flycheck-virtualenv-setup)

  )

(use-package pyvenv)

;; ----------------------------------------------------------------------------
;; Lua
;; ----------------------------------------------------------------------------

;; linting appears a bit of a shit show, luacheck seems standard but spits
;; endless shit about ngx being an undefined variable. Maybe fix down the line.

(use-package lua-mode
  :config
  (autoload 'lua-mode "lua-mode" "Lua editing mode." t)
  (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
  (add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
  )

(use-package company-lua
  :config
  (add-to-list 'company-backends 'company-lua)
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
;; Markdown
;; ----------------------------------------------------------------------------


(use-package markdown-mode
  ;:ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))


;; ----------------------------------------------------------------------------
;; python
;; ----------------------------------------------------------------------------

;; ----------------------------------------------------------------------------
;; python
;; ----------------------------------------------------------------------------


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
  (setq flycheck-display-errors-delay 0.1)

  (define-prefix-command 'flycheck-keys)
  (evil-leader/set-key "e" 'flycheck-keys)
  (define-key flycheck-keys "p" 'flycheck-previous-error)
  (define-key flycheck-keys "n" 'flycheck-next-error)

  )

;; ############################################################################
;; Projects
;; ############################################################################

(use-package projectile
  :diminish projectile-mode
  :init
  (projectile-mode)
  :config
  (setq projectile-completion-system 'ivy) ;;requires ivy

  (define-prefix-command 'projectile-keys)
  (evil-leader/set-key "p" 'projectile-keys)
  (define-key projectile-keys "f" 'counsel-projectile-find-file)
  (define-key projectile-keys "b" 'counsel-projectile-switch-to-buffer)
  (define-key projectile-keys "p" 'counsel-projectile-switch-project)
  (define-key projectile-keys "a" 'counsel-projectile-ag)
  )

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

    ;; automatically save org buffers when agenda open
    ;;;(add-hook 'org-agenda-mode-hook
    ;;;      (lambda ()
    ;;;        (add-hook 'auto-save-hook 'org-save-all-org-buffers nil t)
    ;;;        (auto-save-mode)))
    ;;;
    ;;;;; apply CLOSED property on done
    ;;;(setq org-log-done 'time)

    (define-prefix-command 'org-keys)
    (evil-leader/set-key "o" 'org-keys)
    (define-key org-keys "c" 'org-capture)
    (define-key org-keys "a" 'org-agenda)
    (define-key org-keys "l" 'org-agenda-list)
    (define-key org-keys "t" (lambda () (interactive) (org-capture nil "t")))
    (define-key org-keys "w" (lambda () (interactive) (org-capture nil "w")))
    (define-key org-keys "W" 'ftzm/org-agenda-list-work)
    (define-key org-keys "T" 'org-todo-list)
    (define-key org-keys "m" 'create-meeting-file)

    ;;;; org-capture setting
    ;; Start capture mode in evil insert state

    ;; Map for my custom ',' prefix in capture mode
    (define-prefix-command 'capture-mode-map)
    (evil-define-key 'normal org-capture-mode-map "," 'capture-mode-map)
    (define-key capture-mode-map "k" 'org-capture-kill)
    (define-key capture-mode-map "r" 'org-capture-refile)
    (define-key capture-mode-map "c" 'org-capture-finalize)


    (add-hook 'org-capture-mode-hook 'evil-insert-state)

    (defun create-dated-file (path)
      (let ((name (read-string "Name: ")))
	(expand-file-name (format "%s-%s.org"
				  (format-time-string "%Y-%m-%d")
				  name) path)))

    (defun create-meeting-file ()
      (interactive)
      (find-file (replace-regexp-in-string " " "-" (create-dated-file "~/org/meetings")))
      )

    (setq org-capture-templates
	  (quote (("t" "todo" entry (file+headline "~/org/refile.org" "Tasks")
		   "* TODO %?\n  SCHEDULED: %t")
		  ("n" "note" entry (file+headline "~/org/refile.org" "Notes")
		   "* %?")
		  ("w" "work todo" entry (file+headline "~/org/work.org" "Tasks")
		   "* TODO %?\n  SCHEDULED: %t")
		  )))

    ;(setq org-default-notes-file "~/org/refile.org")
    (evil-leader/set-key "oc" 'org-capture)


    (defun ftzm/org-agenda-list-work ()
      (interactive)
      (let ((org-agenda-tag-filter-preset '("work")))
	(org-agenda-list)))


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


    (defun agenda-remove-schedule ()
      (interactive)
      (org-agenda-schedule '(4))
      )

    (define-prefix-command 'org-mode-keys)
    (evil-define-key 'normal org-mode-map (kbd ",") 'org-mode-keys)
    (define-key org-mode-keys "s" 'org-schedule)
    (define-key org-mode-keys "r" 'org-refile)

    ;; Map for my custom ',' prefix.
    (define-prefix-command 'agenda-mode-map)
    (define-key agenda-mode-map "w" 'org-agenda-week-view)
    (define-key agenda-mode-map "D" 'org-agenda-day-view)
    (define-key agenda-mode-map "d" 'org-agenda-deadline)
    (define-key agenda-mode-map "r" 'org-agenda-refile)
    (define-key agenda-mode-map "s" 'org-agenda-schedule)
    (define-key agenda-mode-map "p" 'org-agenda-priority)
    (define-key agenda-mode-map "f" 'org-agenda-filter-by-tag)
    (define-key agenda-mode-map "cs" 'agenda-remove-schedule)

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
      "," 'agenda-mode-map


      ))

;; ----------------------------------------------------------------------------
;; Custom Archive Function

  (defun days-ago (number)
    (time-subtract (current-time) (seconds-to-time (* number 86400)))
    )

  (defun archive-if-old ()
    (let*
	((props (org-entry-properties (point)))
         (closed-string (cdr (assoc "CLOSED" props)))
	 (title (cdr (assoc "ITEM" props)))
	 (closed (if closed-string (date-to-time closed-string) (days-ago 30)))
	 (cutoff (days-ago 6)))
         (when (time-less-p closed cutoff) ((lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (outline-previous-heading))
     (org-save-all-org-buffers))))
    ))

  (defun org-archive-done-tasks ()
    (interactive)
    (org-map-entries 'archive-if-old "/DONE" 'agenda))
    )

;; ----------------------------------------------------------------------------


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

(defun switch-to-previous-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer)))

 (evil-leader/set-key "TAB" 'switch-to-previous-buffer)


;; ############################################################################
;; Configure gui that may rely on plugins being intialized
;; ############################################################################

;; load syntax coloring theme. Applied also to some other gui.
(load-theme 'gruvbox t)

;; disable fringe
(set-fringe-mode 0)

;;try out loading here
(spaceline-compile)


;; ----------------------------------------------------------------------------
;; Fira Symbols
;; ----------------------------------------------------------------------------

;;;; Fira code
;;; This works when using emacs --daemon + emacsclient
;(add-hook 'after-make-frame-functions (lambda (frame) (set-fontset-font t '(#Xe100 . #Xe16f) "Fira Code Symbol")))
;;; This works when using emacs without server/client
;(set-fontset-font t '(#Xe100 . #Xe16f) "Fira Code Symbol")
;;; I haven't found one statement that makes both of the above situations work, so I use both for now
;
;(defconst fira-code-font-lock-keywords-alist
;  (mapcar (lambda (regex-char-pair)
;            `(,(car regex-char-pair)
;              (0 (prog1 ()
;                   (compose-region (match-beginning 1)
;                                   (match-end 1)
;                                   ;; The first argument to concat is a string containing a literal tab
;                                   ,(concat "	" (list (decode-char 'ucs (cadr regex-char-pair)))))))))
;          '(("\\(www\\)"                   #Xe100)
;            ("[^/]\\(\\*\\*\\)[^/]"        #Xe101)
;            ("\\(\\*\\*\\*\\)"             #Xe102)
;            ("\\(\\*\\*/\\)"               #Xe103)
;            ("\\(\\*>\\)"                  #Xe104)
;            ("[^*]\\(\\*/\\)"              #Xe105)
;            ("\\(\\\\\\\\\\)"              #Xe106)
;            ("\\(\\\\\\\\\\\\\\)"          #Xe107)
;            ("\\({-\\)"                    #Xe108)
;            ("\\(\\[\\]\\)"                #Xe109)
;            ("\\(::\\)"                    #Xe10a)
;            ("\\(:::\\)"                   #Xe10b)
;            ("[^=]\\(:=\\)"                #Xe10c)
;            ("\\(!!\\)"                    #Xe10d)
;            ("\\(!=\\)"                    #Xe10e)
;            ("\\(!==\\)"                   #Xe10f)
;            ("\\(-}\\)"                    #Xe110)
;            ("\\(--\\)"                    #Xe111)
;            ("\\(---\\)"                   #Xe112)
;            ("\\(-->\\)"                   #Xe113)
;            ("[^-]\\(->\\)"                #Xe114)
;            ("\\(->>\\)"                   #Xe115)
;            ("\\(-<\\)"                    #Xe116)
;            ("\\(-<<\\)"                   #Xe117)
;            ("\\(-~\\)"                    #Xe118)
;            ("\\(#{\\)"                    #Xe119)
;            ("\\(#\\[\\)"                  #Xe11a)
;            ("\\(##\\)"                    #Xe11b)
;            ("\\(###\\)"                   #Xe11c)
;            ("\\(####\\)"                  #Xe11d)
;            ("\\(#(\\)"                    #Xe11e)
;            ("\\(#\\?\\)"                  #Xe11f)
;            ("\\(#_\\)"                    #Xe120)
;            ("\\(#_(\\)"                   #Xe121)
;            ("\\(\\.-\\)"                  #Xe122)
;            ("\\(\\.=\\)"                  #Xe123)
;            ("\\(\\.\\.\\)"                #Xe124)
;            ("\\(\\.\\.<\\)"               #Xe125)
;            ("\\(\\.\\.\\.\\)"             #Xe126)
;            ("\\(\\?=\\)"                  #Xe127)
;            ("\\(\\?\\?\\)"                #Xe128)
;            ("\\(;;\\)"                    #Xe129)
;            ("\\(/\\*\\)"                  #Xe12a)
;            ("\\(/\\*\\*\\)"               #Xe12b)
;            ("\\(/=\\)"                    #Xe12c)
;            ("\\(/==\\)"                   #Xe12d)
;            ("\\(/>\\)"                    #Xe12e)
;            ("\\(//\\)"                    #Xe12f)
;            ("\\(///\\)"                   #Xe130)
;            ("\\(&&\\)"                    #Xe131)
;            ("\\(||\\)"                    #Xe132)
;            ("\\(||=\\)"                   #Xe133)
;            ("[^|]\\(|=\\)"                #Xe134)
;            ("\\(|>\\)"                    #Xe135)
;            ("\\(\\^=\\)"                  #Xe136)
;            ("\\(\\$>\\)"                  #Xe137)
;            ("\\(\\+\\+\\)"                #Xe138)
;            ("\\(\\+\\+\\+\\)"             #Xe139)
;            ("\\(\\+>\\)"                  #Xe13a)
;            ("\\(=:=\\)"                   #Xe13b)
;            ("[^!/]\\(==\\)[^>]"           #Xe13c)
;            ("\\(===\\)"                   #Xe13d)
;            ("\\(==>\\)"                   #Xe13e)
;            ("[^=]\\(=>\\)"                #Xe13f)
;            ("\\(=>>\\)"                   #Xe140)
;            ("\\(<=\\)"                    #Xe141)
;            ("\\(=<<\\)"                   #Xe142)
;            ("\\(=/=\\)"                   #Xe143)
;            ("\\(>-\\)"                    #Xe144)
;            ("\\(>=\\)"                    #Xe145)
;            ("\\(>=>\\)"                   #Xe146)
;            ("[^-=]\\(>>\\)"               #Xe147)
;            ("\\(>>-\\)"                   #Xe148)
;            ("\\(>>=\\)"                   #Xe149)
;            ("\\(>>>\\)"                   #Xe14a)
;            ("\\(<\\*\\)"                  #Xe14b)
;            ("\\(<\\*>\\)"                 #Xe14c)
;            ("\\(<|\\)"                    #Xe14d)
;            ("\\(<|>\\)"                   #Xe14e)
;            ("\\(<\\$\\)"                  #Xe14f)
;            ("\\(<\\$>\\)"                 #Xe150)
;            ("\\(<!--\\)"                  #Xe151)
;            ("\\(<-\\)"                    #Xe152)
;            ("\\(<--\\)"                   #Xe153)
;            ("\\(<->\\)"                   #Xe154)
;            ("\\(<\\+\\)"                  #Xe155)
;            ("\\(<\\+>\\)"                 #Xe156)
;            ("\\(<=\\)"                    #Xe157)
;            ("\\(<==\\)"                   #Xe158)
;            ("\\(<=>\\)"                   #Xe159)
;            ("\\(<=<\\)"                   #Xe15a)
;            ("\\(<>\\)"                    #Xe15b)
;            ("[^-=]\\(<<\\)"               #Xe15c)
;            ("\\(<<-\\)"                   #Xe15d)
;            ("\\(<<=\\)"                   #Xe15e)
;            ("\\(<<<\\)"                   #Xe15f)
;            ("\\(<~\\)"                    #Xe160)
;            ("\\(<~~\\)"                   #Xe161)
;            ("\\(</\\)"                    #Xe162)
;            ("\\(</>\\)"                   #Xe163)
;            ("\\(~@\\)"                    #Xe164)
;            ("\\(~-\\)"                    #Xe165)
;            ("\\(~=\\)"                    #Xe166)
;            ("\\(~>\\)"                    #Xe167)
;            ("[^<]\\(~~\\)"                #Xe168)
;            ("\\(~~>\\)"                   #Xe169)
;            ("\\(%%\\)"                    #Xe16a)
;            ;;("\\(x\\)"                     #Xe16b)
;            ("[^:=]\\(:\\)[^:=]"           #Xe16c)
;            ("[^\\+<>]\\(\\+\\)[^\\+<>]"   #Xe16d)
;            ("[^\\*/<>]\\(\\*\\)[^\\*/<>]" #Xe16f))))
;
;(defun add-fira-code-symbol-keywords ()
;  (font-lock-add-keywords nil fira-code-font-lock-keywords-alist))
;
;(add-hook 'prog-mode-hook
;          #'add-fira-code-symbol-keywords)

;; ############################################################################
;; Beware: here be dra--, err, custom-set-variables. Steer clear.
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
    ("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "10e231624707d46f7b2059cc9280c332f7c7a530ebc17dba7e506df34c5332c4" "227edf860687e6dfd079dc5c629cbfb5c37d0b42a3441f5c50873ba11ec8dfd2" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" default)))
 '(org-agenda-files
   (quote
    ("~/org/work.org" "~/org/refile.org" "~/org/tasks.org")))
 '(package-selected-packages
   (quote
    (evil-surround evil-snipe evil-quickscope hydra sudo-edit default-text-scale dumb-jump markdown-mode company-jedi auto-virtualenv company-lua flymake-lua avy ivy-rich intero olivetti counsel-projectile projectile counsel flycheck-mypy lua-mode magit-popup evil-magit magit ag all-the-icons neotree which-key darktooth-theme smart-mode-line elmacro elpy yaml-mode flymake-yaml workgroups2 company-anaconda dockerfile-mode spacemacs-theme persp-mode eyebrowse highlight-parentheses rainbow-delimiters company-ghc haskell-mode helm gruvbox-theme evil-visual-mark-mode evil-leader smex)))
 '(safe-local-variable-values (quote ((eval progn (pp-buffer) (indent-buffer))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ivy-current-match ((t (:foreground "#8ec07c" :underline nil :weight normal))))
 '(neo-banner-face ((t (:inherit default))))
 '(neo-button-face ((t (:inherit font-lock-comment-face :underline nil))))
 '(neo-dir-link-face ((t (:inherit font-lock-variable-name-face))))
 '(neo-file-link-face ((t (:inherit default))))
 '(neo-header-face ((t (:inherit default))))
 '(neo-root-dir-face ((t (:inherit font-lock-string-face))))
 '(neo-vc-default-face ((t (:inherit default))))
 '(powerline-active2 ((t (:inherit mode-line :background "grey22"))))
 '(spaceline-python-venv ((t (:inherit success))))
 '(success ((t (:foreground "#b8bb26" :weight normal))))
 '(warning ((t (:foreground "#fe8019" :weight normal)))))
 '(spaceline-python-venv ((t (:inherit success))))
