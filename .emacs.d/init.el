;; General Config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Increase garbage collection threshhold
(setq gc-cons-threshold (* 50 1000 1000))

;; Backup and emacs files settings
(setq user-emacs-directory "~/.cache/emacs/"
      backup-directory-alist `(("." . ,(expand-file-name "backups" user-emacs-directory)))
      url-history-file (expand-file-name "url/history" user-emacs-directory)
      auto-save-list-file-prefix (expand-file-name "auto-save-list/.saves-" user-emacs-directory)
      projectile-known-projects-file (expand-file-name "projectile-bookmarks.eld" user-emacs-directory)
			delete-old-versions t
			kept-new-versions 6
			kept-old-versions 2
			version-control t)

;; Maximize on startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Prefer UTF-8 everywehere
(set-charset-priority 'unicode)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;; Set line number width limit to avoid bugs
(setq line-number-display-limit-width 10000)

;; Remove trailing whitespaces
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Use y and n instead of yes and no in confirmation dialogues
(defalias 'yes-or-no-p 'y-or-n-p)

;; Default tabs
(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)

;; Enable syntax highlighting everywhere
(global-font-lock-mode t)
;; Allow font-lock-mode to do background parsing
(setq jit-lock-defer-time nil
      ;; jit-lock-stealth-nice 0.1
      jit-lock-stealth-time 1
      jit-lock-stealth-verbose nil)

;; Initial Package Setup ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Setup package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
												 ("org" . "https://orgmode.org/elpa/")
												 ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Setup use-package
(unless (package-installed-p 'use-package)
	(package-refresh-contents)
	(package-install 'use-package))
(eval-when-compile
	(require 'use-package)
	(setq use-package-always-ensure t))

;; Packages Setup ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package evil
	:init
	(setq evil-want-integration t)
	(setq evil-want-keybinding nil)
	(setq evil-want-C-u-scroll t)
	(setq evil-respect-visual-line-mode t)
	:config
	(evil-mode 1)
	(define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
	;; Use visual line motions even outside of visual-line-mode buffers
	(evil-global-set-key 'motion "j" 'evil-next-visual-line)
	(evil-global-set-key 'motion "k" 'evil-previous-visual-line))

(use-package evil-collection
	:after (evil)
	:custom
	(evil-collection-outline-bind-tab-p nil)
	:config
	(evil-collection-init))

(use-package counsel
	:bind (("M-x" . counsel-M-x)
				 ("C-x b" . counsel-ibuffer)
				 ("C-x C-f" . counsel-find-file)
				 ("C-M-l" . counsel-imenu)
				 :map minibuffer-local-map
				 ("C-r" . 'counsel-minibuffer-history))
	:custom
	(counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only))

(use-package ivy
	:after (counsel)
	:diminish
	:bind (("C-s" . swiper)
				 :map ivy-minibuffer-map
				 ("TAB" . ivy-alt-done)
				 ("C-l" . ivy-alt-done)
				 ("C-j" . ivy-next-line)
				 ("C-k" . ivy-previous-line)
				 :map ivy-switch-buffer-map
				 ("C-k" . ivy-previous-line)
				 ("C-l" . ivy-done)
				 ("C-d" . ivy-switch-buffer-kill)
				 :map ivy-reverse-i-search-map
				 ("C-k" . ivy-previous-line)
				 ("C-d" . ivy-reverse-i-search-kill))
	:init
	(ivy-mode 1))

(use-package ivy-rich
	:init
	(ivy-rich-mode 1))

(use-package which-key
	:diminish which-key-mode
	:init
	(which-key-mode)
	:config
	(which-key-setup-side-window-bottom)
	(setq which-key-idle-delay 1))

(use-package rainbow-delimiters
	:diminish
	:hook (prog-mode . rainbow-delimiters-mode))

(use-package helpful
	:after (counsel)
	:custom
	(counsel-describe-function-function #'helpful-callable)
	(counsel-describe-variable-function #'helpful-variable)
	:bind
	([remap describe-function] . counsel-describe-function)
	([remap describe-command] . helpful-command)
	([remap describe-variable] . counsel-describe-variable)
	([remap describe-key] . helpful-key))

;; M-x all-the-icons-install-fonts to setup fonts if not done already
(use-package all-the-icons)

(use-package doom-themes)

(use-package doom-modeline
	:init
	(doom-modeline-mode 1))

(use-package projectile
	:diminish (projectile-mode)
	:config (projectile-mode)
	:custom ((projectile-completion-system 'ivy))
	:init
	(when (file-directory-p "C:/Users/azada/Documents")
		(setq projectile-project-search-path '("C:/Users/azada/Documents")))
	(setq projectile-switch-project-action #'projectile-dired))

;; Use M-o to open more actions on the file when using find file in projectile
(use-package counsel-projectile
	:after (projectile))

;; Use ? to bring up all the commands that can be run
(use-package magit)

(use-package general
	:config
	(general-evil-setup t)
	(general-create-definer adi/ctrl-c-keys
		:prefix "C-c")
	(general-create-definer adi/leader-keys
		:keymaps '(normal visual emacs)
		:prefix "SPC"
		:global-prefix "C-SPC"))

(use-package forge
	:disabled)

(defun adi/org-mode-setup ()
	(org-indent-mode)
	(auto-fill-mode 0)
	(visual-line-mode 1)
	(setq evil-auto-indent nil)
	(diminish org-indent-mode))

(use-package org
	:hook (org-mode . adi/org-mode-setup)
	:config
	(setq org-ellipsis " ▾"
				org-hide-block-startup nil
				org-agenda-block-separator ""
				org-startup-folded 'content
				org-cycle-separator-lines 2)
	(setq org-agenda-files
				'("C:/Users/azada/Documents/notes/org/current/"))
	(advice-add 'org-refile :after 'org-save-all-org-buffers)
	(setq org-modules
				'(org-habit)))

(use-package org-superstar
	:after org
	:hook (org-mode . org-superstar-mode)
	:custom
	(org-superstar-remove-leading-stars t)
	(org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●"))
	:config
	(dolist (face '((org-level-1 . 1.2)
									(org-level-2 . 1.1)
									(org-level-3 . 1.05)
									(org-level-4 . 1.0)
									(org-level-5 . 1.1)
									(org-level-6 . 1.1)
									(org-level-7 . 1.1)
									(org-level-8 . 1.1)))
		(set-face-attribute (car face) nil :font "Hack" :weight 'regular :height (cdr face))))

(defun adi/org-mode-visual-fill ()
	(setq visual-fill-column-width 100
				visual-fill-column-center-text t)
	(visual-fill-column-mode t))

(use-package visual-fill-column
	:hook (org-mode . adi/org-mode-visual-fill))

(use-package undo-tree
	:config
	(global-undo-tree-mode))

(use-package hydra
  :defer 1)

(use-package markdown-mode)

;; Key Bindings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(general-define-key
 "<escape>" 'keyboard-escape-quit
 ;; counsel
 "C-M-j" 'counsel-switch-buffer)

(adi/ctrl-c-keys
	;; projectile
	"p"   'projectile-command-map)

(adi/leader-keys
	;; default commands
	"o"   'find-file
	"j"   'windmove-down
	"k"   'windmove-up
	"l"   'windmove-right
	"h"   'windmove-left
	;; org
	"aa"  'org-agenda
	;; magit
	"g"   '(:ignore t :which-key "git")
	"gs"  'magit-status
	"gd"  'magit-diff-unstaged
	"gc"  'magit-branch-or-checkout
	"gl"   '(:ignore t :which-key "log")
	"glc" 'magit-log-current
	"glf" 'magit-log-buffer-file
	"gb"  'magit-branch
	"gP"  'magit-push-current
	"gp"  'magit-pull-branch
	"gf"  'magit-fetch
	"gF"  'magit-fetch-all
	"gr"  'magit-rebase
	;; projectile
	"pf"  'counsel-projectile-find-file
	"ps"  'counsel-projectile-switch-project
	"pF"  'counsel-projectile-rg
	"pp"  'counsel-projectile
	"pc"  'projectile-compile-project
	"pd"  'projectile-dired)

;; Visual Settings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Disable bars
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

;; Add a small border
(set-fringe-mode 10)

;; Disable startup message
(setq inhibit-startup-message t)

;; Set default face
(set-face-attribute 'default nil :font "Hack" :height 110)

;; Theme settings
(load-theme 'doom-challenger-deep t)

;; Disable bells
(setq visible-bell nil)
(setq ring-bell-function 'ignore)

;; Column number on mode line
(column-number-mode)

;; Override some modes which derive from the above
(dolist (mode '(org-mode-hook))
	(add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Scroll settings
(setq scroll-step            1
			scroll-conservatively  10000)

;; Register files ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; .emacs file
;; C-x r j <register>
(set-register ?e (cons 'file "~/.emacs.d/init.el"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
	 '("a3b6a3708c6692674196266aad1cb19188a6da7b4f961e1369a68f06577afa16" default))
 '(package-selected-packages '(hydra visual-fill-column visual-fill use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
