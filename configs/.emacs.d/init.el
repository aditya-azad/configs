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

;;;;;;;;;;;;;;;;;;;;;;;;;;; Packages configs ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; install packages
(use-package evil :ensure t)
(use-package helm :ensure t)
(use-package dracula-theme :ensure t)
(use-package undo-tree :ensure t)

;; run evil mode at strtup
(require 'evil)
(evil-mode t)

;; enable undo tree mode
(global-undo-tree-mode)

;; enable helm mode
(helm-mode 1)

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
(setq defualt-tab-width 2)

;; scroll settings
(setq scroll-step            1
      scroll-conservatively  10000)

;; remove trailing whitespaces
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Filetype specific ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq two-tab-width 2)
(setq four-tab-width 4)

;; c/c++
(defvaralias 'c-basic-offset 'four-tab-width)

;; javascript
(defvaralias 'js-indent-level 'two-tab-width)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Visual configs ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; disable top bars and scroll bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

;; set theme
(load-theme 'dracula t)

;; line numbers
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;; Key bindings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; evaluate current buffer
(global-set-key (kbd "C-c C-r") 'eval-buffer)

;; rebind u to undo tree
(define-key evil-normal-state-map (kbd "u") (kbd "C-x u"))

;; use helm for M-x
(global-set-key (kbd "M-x") 'helm-M-x)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Cutom set ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; set font faces
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Hack" :foundry "outline" :slant normal :weight normal :height 98 :width normal)))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(undo-tree helm evil use-package)))
