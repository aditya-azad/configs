;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Repo setup ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; setup package repos
(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(setq package-enable-at-startup nil)
(package-initialize)

;; setup use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;;;;;;;;;;;;;;;;;;;;;;;;;;; Packages ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package evil-collection
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (setq evil-collection-mode-list '(dired))
  (evil-collection-init))

(use-package evil :ensure t
  :config
  (evil-mode t)
  ;; evil mode leader key
  (evil-set-leader 'normal (kbd "SPC") nil)
  ;; rebind u to undo tree
  (define-key evil-normal-state-map (kbd "C-r") (kbd "C-x u"))
  ;; window commands
  (define-key evil-normal-state-map (kbd "<leader>l") (kbd "C-w l"))
  (define-key evil-normal-state-map (kbd "<leader>j") (kbd "C-w j"))
  (define-key evil-normal-state-map (kbd "<leader>k") (kbd "C-w k"))
  (define-key evil-normal-state-map (kbd "<leader>h") (kbd "C-w h"))
  (define-key evil-normal-state-map (kbd "L") 'enlarge-window-horizontally)
  (define-key evil-normal-state-map (kbd "J") 'enlarge-window)
  (define-key evil-normal-state-map (kbd "K") 'shrink-window)
  (define-key evil-normal-state-map (kbd "H") 'shrink-window-horizontally)
  (evil-define-key 'normal 'global (kbd "<leader>o") (lambda() (interactive)(dired "."))))

(use-package helm
  :ensure t
  :config
  (helm-mode 1)
  (global-set-key (kbd "M-x") 'helm-M-x))

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode))

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (add-to-list 'projectile-globally-ignored-directories "node_modules")
  (setq projectile-indexing-method 'alien)
  (setq projectile-enable-caching t)
  (setq projectile-completion-system 'helm)
  (setq projectile-sort-order 'recently-active)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

(use-package web-mode
  :ensure t
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))


(use-package all-the-icons :ensure t)

(use-package doom-themes :ensure t)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;; General config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; prefer UTF-8 everywehere
(set-charset-priority 'unicode)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;; default directory
(if (string-equal system-type "windows-nt")
    (setq default-directory "C:/Users/azada/Documents/" ))

;; garbage collection threshold is 50 mbs
(setq gc-cons-threshold (* 50 1024 1024))

;; set line number width limit to avoid bugs
(setq line-number-display-limit-width 10000)

;; enable syntax highlighting everywhere
(global-font-lock-mode t)
;; Allow font-lock-mode to do background parsing
(setq jit-lock-defer-time nil
      ;; jit-lock-stealth-nice 0.1
      jit-lock-stealth-time 1
      jit-lock-stealth-verbose nil)

;; raise max number of logs in message buffer
(setq message-log-max 16384)

;; backup files settings
;; delete-auto-save-files
(setq delete-auto-save-files t)
;; Create the directory for backups if it doesn't exist
(when (not (file-exists-p "~/.emacs_backups"))
  (make-directory "~/.emacs_backups"))
;; set backup directory
(setq-default backup-directory-alist
              '((".*" . "~/.emacs_backups")))
(setq auto-save-file-name-transforms
      '((".*" "~/.emacs_backups/" t)))
;; delete old backups silently
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; use spaces instead of tabs (unless the file is already using one over the other)
(setq-default indent-tabs-mode t)
(defun infer-indentation-style ()
  ;; if our source file uses tabs, we use tabs, if spaces spaces, and if
  ;; neither, we use the current indent-tabs-mode
  (let ((space-count (how-many "^  " (point-min) (point-max)))
        (tab-count (how-many "^\t" (point-min) (point-max))))
    (if (> space-count tab-count) (setq indent-tabs-mode nil))
    (if (> tab-count space-count) (setq indent-tabs-mode t))))
(add-hook 'find-file-hook 'infer-indentation-style)

;; set default tab width
(setq-default tab-width 2)

;; scroll settings
(setq scroll-step            1
      scroll-conservatively  10000)

;; remove trailing whitespaces
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; maximize on startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; disable bells
(setq visible-bell nil)
(setq ring-bell-function 'ignore)

;; use y and n instead of yes and no in confirmation dialogues
(defalias 'yes-or-no-p 'y-or-n-p)

;;;;;;;;;;;;;;;;;;;;;;;;;;; Key bindings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; evaluate current buffer
(global-set-key (kbd "C-x C-r") 'eval-buffer)
;; open agenda
(global-set-key (kbd "C-x C-a") 'org-agenda)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Register files ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; .emacs file
;; C-x r j <register>
(set-register ?e (cons 'file "~/.emacs"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Filetype specific ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; c/c++
(setq-default c-basic-offset 4)

;; javascript
(setq-default js-indent-level 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Visual configs ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; disable top bars and scroll bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(set-scroll-bar-mode 'nil)

;; show corresponding bracket
(show-paren-mode)

;; display line numbers and columns numbers on mode-line
(line-number-mode 1)
(column-number-mode 1)

;; theme
(load-theme 'doom-challenger-deep t)

;; font
(if (string-equal system-type "windows-nt")
    (set-frame-font "-outline-Hack-normal-normal-normal-mono-15-*-*-*-c-*-iso8859")
  (set-frame-font "Hack Nerd Font 12"))


;; disable startup message
(setq inhibit-startup-message t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Org Mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; enable some modules
(setq org-modules (quote (org-habit)))

;; Default agenda directory
(setq org-agenda-files (quote ("C:/Users/azada/Documents/org/current/")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
