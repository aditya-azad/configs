; load package manager
(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(package-initialize)

; custom-set-variables and custom-set-faces file in custom.el file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

; bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

; PACKAGES
; ========

; load evil
(use-package evil
    :ensure t
    :init
    (evil-mode))

; load gruvbox theme
(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox))

; load ranger
(use-package ranger
    :ensure t
    :config
    (ranger-override-dired-mode t))
(global-set-key (kbd "C-;") 'ranger)

; OTHER SETTINGS
; ==============

; maximize 
(add-to-list 'default-frame-alist '(fullscreen . maximized))

; setting very high limits for undo buffers
(setq undo-limit 20000000)
(setq undo-strong-limit 40000000)
