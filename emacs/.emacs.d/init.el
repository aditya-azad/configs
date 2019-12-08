;; BASIC SETTINGS
;; ==============

;; load package manager
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; custom-set-variables and custom-set-faces file in custom.el file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;; disable emacs splash screen
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;; use space instead of tabs
(setq-default indent-tabs-mode nil)

;; set font
(add-to-list 'default-frame-alist
             '(font . "DejaVu Sans Mono-12"))

;; maximize 
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; setting very high limits for undo buffers
(setq undo-limit 20000000)
(setq undo-strong-limit 40000000)

;; show line numbers
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))
	            
;; PACKAGES
;; ========

;; load evil
(use-package evil
    :ensure t
    :init
    (evil-mode))

;; load gruvbox theme
(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox))

;; load ranger
(use-package ranger
    :ensure t
    :config
    (ranger-override-dired-mode t))
(global-set-key (kbd "C-;") 'ranger)
