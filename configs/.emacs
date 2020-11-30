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

(use-package evil
  :ensure t
  :config
  (evil-mode t)
  ;; evil mode leader key
  (evil-set-leader 'normal (kbd "SPC") nil)
  ;; rebind u to undo tree
  (define-key evil-normal-state-map (kbd "C-r") (kbd "C-x u"))
  ;; panes
  (define-key evil-normal-state-map (kbd "<leader>l") (kbd "C-w l"))
  (define-key evil-normal-state-map (kbd "<leader>j") (kbd "C-w j"))
  (define-key evil-normal-state-map (kbd "<leader>k") (kbd "C-w k"))
  (define-key evil-normal-state-map (kbd "<leader>h") (kbd "C-w h"))
  (evil-define-key 'normal 'global (kbd "<leader>o") (lambda() (interactive)(dired "."))))

(use-package helm
  :ensure t
  :config
  (helm-mode 1)
  (global-set-key (kbd "M-x") 'helm-M-x))

(use-package ample-theme :ensure t)

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

(use-package web-mode :ensure t)

(use-package all-the-icons :ensure t)

(use-package doom-themes :ensure t)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;; General config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; backup files settings
(setq version-control t   ;; Use version numbers for backups.
    kept-new-versions 10  ;; Number of newest versions to keep.
    kept-old-versions 0   ;; Number of oldest versions to keep.
    delete-old-versions t ;; Don't ask to delete excess backup versions.
    backup-by-copying t)  ;; Copy all files, don't rename them.
(setq vc-make-backup-files t) ;; backup versioned files
(setq backup-directory-alist '(("" . "~/.tmp/emacs/backup/per-save"))) ;; Default and per-save backups go here
(defun force-backup-of-buffer ()
  ;; Make a special "per session" backup at the first save of each
  ;; emacs session.
  (when (not buffer-backed-up)
    ;; Override the default parameters for per-session backups.
    (let ((backup-directory-alist '(("" . "~/.tmp/emacs/backup/per-session")))
          (kept-new-versions 3))
      (backup-buffer)))
  ;; Make a "per save" backup on each save.  The first save results in
  ;; both a per-session and a per-save backup, to keep the numbering
  ;; of per-save backups consistent.
  (let ((buffer-backed-up nil))
    (backup-buffer)))
(add-hook 'before-save-hook  'force-backup-of-buffer)

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

;; show corresponding bracket
(show-paren-mode)

;; disable bells
(setq visible-bell nil)
(setq ring-bell-function 'ignore)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Filetype specific ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; c/c++
(setq-default c-basic-offset 4)

;; javascript
(setq-default js-indent-level 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Visual configs ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; disable top bars and scroll bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

;; theme
(load-theme 'doom-one t)

;; font
(set-frame-font "Hack NF 11" nil t)

;; disable startup message
(setq inhibit-startup-message t)

;;;;;;;;;;;;;;;;;;;;;;;;;;; Key bindings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; evaluate current buffer
(global-set-key (kbd "C-c C-r") 'eval-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Register files ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; .emacs file
;; C-x r j <register>
(set-register ?e (cons 'file "~/.emacs"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(dired-toggle doom-modeline doom-themes all-the-icons web-mode flycheck helm-projectile projectile undo-tree ample-theme helm evil-collection use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
