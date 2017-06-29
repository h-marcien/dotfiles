;; package.el setup (comes with emacs >= 24)

(require 'package)
(setq package-enable-at-startup nil) ;; prevents second package init
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; Bootstrap `use-package'

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Config 3rd party packages

(use-package use-package-chords
  :ensure t
  :config
  (key-chord-mode 1))

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package projectile
  :ensure t
  :config
  (projectile-mode))

(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)
	 ("C-x b" . helm-buffers-list)
	 ("C-x C-f" . helm-find-files))
  :config
  (use-package helm-ag
    :ensure t)

  (use-package helm-swoop
    :ensure t
    :bind (("M-i" . helm-swoop)
	   ("M-I" . helm-swoop-back-to-last-point)))

  (use-package helm-projectile
    :ensure t
    :config
    (helm-projectile-on)))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package avy
  :ensure t
  :chords (("jj" . avy-goto-word-1)
	   ("jl" . avy-goto-line))
  :bind ("C-;" . avy-goto-word-1))

(use-package smartparens
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'smartparens-mode))

;; (use-package evil
;;   :ensure t
;;   :config
;;   (use-package evil-leader
;;     :ensure t
;;     :config
;;     (global-evil-leader-mode)
;;     (evil-leader/set-leader "<SPC>")
;;     (evil-leader/set-key "s" 'save-buffer)
;;     (evil-leader/set-key "b" 'helm-buffers-list)
;;     (evil-leader/set-key "SPC" 'avy-goto-word-1)))
 
(defun my/use-eslint-from-node-modules ()
  "Set local eslint if available."
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))

(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-flycheck-mode)
  (add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules))

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode)

  (use-package company-go
    :ensure t
    :config
    (add-to-list 'company-backends 'company-go))

  (use-package company-anaconda
    :ensure t
    :config
    (add-to-list 'company-backends 'company-anaconda)))

(use-package yasnippet
  :ensure t
  :config
  ;; https://github.com/AndreaCrotti/yasnippet-snippets
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet-snippets")
  ;; custom
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets")
  (yas-global-mode)
  (global-set-key (kbd "M-/") 'company-yasnippet))

(use-package helm-dash
  :ensure t)

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package rainbow-identifiers
  :ensure t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package go-mode
  :ensure t
  :config
  (add-hook 'before-save-hook 'gofmt-before-save)
  
  (use-package godoctor
    :ensure t)

  (use-package go-guru
    :ensure t))

(use-package js2-mode
  :ensure t
  :mode "\\.js\\'")

(use-package rjsx-mode
  :ensure t)

(use-package prettier-js
  :ensure t
  :config
  (setq prettier-js-args '(
			"--trailing-comma" "es5"
			"--single-quote" "true"
			"--print-width" "100"
			))
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'rjsx-mode-hook 'prettier-js-mode))

(use-package haskell-mode
  :ensure t)

;; Python

(use-package anaconda-mode
  :ensure t
  :config
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode))

(use-package smooth-scrolling
  :ensure t
  :config
  (smooth-scrolling-mode 1))

(use-package all-the-icons
  :ensure t)

(use-package neotree
  :ensure t
  :config
  (global-set-key (kbd "C-c t") 'neotree-toggle)
  (setq neo-smart-open t)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

(use-package which-key
  :ensure t
  :config
  (add-hook 'after-init-hook 'which-key-mode))

(use-package aggressive-indent
  :ensure t)

(use-package beacon
  :ensure t
  :config
  (beacon-mode 1))

(use-package ace-window
  :ensure t
  :bind ("C-'" . ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package nyan-mode
  :ensure t)

(use-package zenburn-theme
  :ensure t)

(use-package dracula-theme
  :ensure t)

(use-package dashboard
  :ensure t
  :config
  (setq dashboard-items '((recents . 5)
			  (bookmarks . 5)
			  (projects . 5)
			  (agenda . 5)))
  (dashboard-setup-startup-hook))

;; Non-package config

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

(load-theme 'dracula t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq ring-bell-function 'ignore) ;; Disable bell

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
  )

(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(key-chord-define-global "JJ" 'switch-to-previous-buffer)

;; Emacs sets the below - leave it alone!

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(asana-selected-workspace
   (quote
    ((id . 20585633191816)
     (name . "cambridge-software.com"))) t)
 '(custom-safe-themes
   (quote
    ("ff7625ad8aa2615eae96d6b4469fcc7d3d20b2e1ebc63b761a349bebbb9d23cb" "67e998c3c23fe24ed0fb92b9de75011b92f35d3e89344157ae0d544d50a63a72" default)))
 '(js-indent-level 2)
 '(package-selected-packages
   (quote
    (go-guru godoctor pyenv-mode elpy company-anaconda anaconda-mode use-package-chords dashboard helm-ag helm-grep evil-mode-line evil magit intero haskell-mode zenburn-theme which-key use-package telephone-line spaceline smooth-scrolling smartparens smart-mode-line rjsx-mode rainbow-identifiers rainbow-delimiters nyan-mode neotree markdown-mode helm-swoop helm-projectile helm-dash flycheck exec-path-from-shell dracula-theme company-quickhelp company-go beacon all-the-icons aggressive-indent ace-window))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
