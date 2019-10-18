;; load package manager
(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
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
