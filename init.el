;; setup the package manager
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
	     '("gnu" . "https://elpa.gnu.org/packages/") t)
(package-initialize)

;; automatically install the use-package package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;; disable recent files
(recentf-mode -1)

;; disable the annoying bell beep
(setq visibile-bell t)
(setq ring-bell-function 'ignore)

;; no title bar
(setq default-frame-alist '((undecorated . t)))

;; full screen on launch
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; don't clutter init.el - gui configuration gets saved to custom file
(setq custom-file "~/.emacs.d/emacs-custom.el")
(load custom-file)

;; all backups go to ~/.emacs.d/.saves
(setq backup-directory-alist '(("." . "~/.emacs.d/.saves")))
(setq delete-old-versions t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/.saves" t)))

;; disable splash screen and startup message
(setq inhibit-startup-message t)
(setq inhibit-scratch-message nil)

;; y for yes, and n for no
(setopt use-short-answers t)

;; remove gui clutter
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

;; enable relative line numbers
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)
(add-hook 'conf-mode-hook 'display-line-numbers-mode)

;; only display important warnings on startup
(setq warning-minimum-level :emergency)

;; set font
(set-face-attribute 'default nil :font "JetBrains Mono" :height 100)

;; auto complete brackets
(electric-pair-mode 1)
(setq electric-pair-pairs
      '(
	(?\" . ?\")
	(?\{ . ?\})
	(?\' . ?\')
	(?\[ . ?\])
	))

;; which-key is now builtin - also who can remember all these fucking commands
(setq which-key-show-early-on-C-h t)
(setq which-key-idle-delay 0.2)
(setq which-key-idle-secondary-delay 0.05)
(which-key-mode)

;; get shell env variables automatically
(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))
  )
;; manually add path for NVM node
(add-to-list 'exec-path "~/.nvm/versions/node/v24.4.0/bin/")
(add-to-list 'exec-path "~/.local/bin/")

;; flx - needed by ivy for fuzzy scoring
(use-package flx
  :ensure t
  )

;; ivy - enhanced modeline
(use-package counsel
  :ensure t
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-re-builders-alist
	'((read-file-name-internal . ivy--regex-fuzzy)
	  (swiper-isearch . ivy--regex-plus)
          (t . ivy--regex-fuzzy)))
  ;; ivy-based interface to standard commands
  (keymap-global-set "C-s" #'swiper-isearch)
  (keymap-global-set "M-x" #'counsel-M-x)
  (keymap-global-set "C-x C-f" #'counsel-find-file)
  (keymap-global-set "M-y" #'counsel-yank-pop)
  (keymap-global-set "<f1> f" #'counsel-describe-function)
  (keymap-global-set "<f1> v" #'counsel-describe-variable)
  (keymap-global-set "<f1> o" #'counsel-describe-symbol)
  (keymap-global-set "<f1> l" #'counsel-find-library)
  (keymap-global-set "<f2> i" #'counsel-info-lookup-symbol)
  (keymap-global-set "<f2> u" #'counsel-unicode-char)
  (keymap-global-set "<f2> j" #'counsel-set-variable)
  (keymap-global-set "C-x b" #'ivy-switch-buffer)
  (keymap-global-set "C-c v" #'ivy-push-view)
  (keymap-global-set "C-c V" #'ivy-pop-view)
  
  ;; ivy-based interface to shell and system tools
  (keymap-global-set "C-c c" #'counsel-compile)
  (keymap-global-set "C-c g" #'counsel-git)
  (keymap-global-set "C-c j" #'counsel-git-grep)
  (keymap-global-set "C-c L" #'counsel-git-log)
  (keymap-global-set "C-c k" #'counsel-rg)
  (keymap-global-set "C-c m" #'counsel-linux-app)
  (keymap-global-set "C-c n" #'counsel-fzf)
  (keymap-global-set "C-x l" #'counsel-locate)
  (keymap-global-set "C-c J" #'counsel-file-jump)
  (keymap-global-set "C-S-o" #'counsel-rhythmbox)
  (keymap-global-set "C-c w" #'counsel-wmctrl)

  ;; ivy-resume and other commands
  (keymap-global-set "C-c C-r" #'ivy-resume)
  (keymap-global-set "C-c b" #'counsel-bookmark)
  (keymap-global-set "C-c d" #'counsel-descbinds)
  (keymap-global-set "C-c o" #'counsel-outline)
  (keymap-global-set "C-c t" #'counsel-load-theme)
  (keymap-global-set "C-c F" #'counsel-org-file)

  ;; enable ivy
  (ivy-mode 1)
  )

;; rainbow-delimiters - no more confusing parens
(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'text-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'conf-mode-hook #'rainbow-delimiters-mode)
  )

;; nerd-icons - dependency for a lot of stuff
(use-package nerd-icons
  :ensure t
  )

;; avy - jump anywhere fast (goto word)
(use-package avy
  :ensure t
  :config
  (global-set-key (kbd "C-:") 'avy-goto-char)
  (global-set-key (kbd "M-g w") 'avy-goto-word-1)
  )

;; yasnippet-snippets - snippets for yasnippet snippets engine
(use-package yasnippet-snippets
  :ensure t
  )

;; yasnippet - snippets engine
(use-package yasnippet
  :ensure t
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook #'yas-minor-mode)
  (add-hook 'conf-mode-hook #'yas-minor-mode)
  )

;; Flycheck - modern syntax checking
(use-package flycheck
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'flycheck-mode)
  (add-hook 'conf-mode-hook 'flycheck-mode)
  )

;; treesit - automatically installs the treesitter grammars
(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode)
  (setq c-ts-mode-indent-offset 4)
  (setq c-ts-mode-indent-style 'linux)
  )

;; some GC configuration - lsp generate a lot of garbage
(setq gc-cons-threshold 1000000)
;; 4k is too low for lsps - lsp usually generate 800k to 3MB garbage per request
(setq read-process-output-max (* 1024 1024 30)) ;; 30 MB

;; themes
(use-package doom-themes
  :ensure t
  )

;; markdown-mode is needed for lsp-bridge
(use-package markdown-mode
  :ensure t
  )

;; "smartly" go up the code structures
(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region)
  )

;; disable touchpad / mouse permanently
(use-package disable-mouse
  :ensure t
  :config
  (global-disable-mouse-mode)
  )

;; lsp features ootb
(add-to-list 'load-path "/home/syedkhs/.local/lsp-bridge")
(require 'lsp-bridge)
(global-lsp-bridge-mode)
(setq lsp-bridge-enable-inlay-hint t)
(setq acm-enable-capf t)
(setq acm-backend-lsp-enable-auto-import f)
(setq acm-enable-lsp-workspace-symbol t)
(setq acm-doc-frame-max-lines 30)
(setq acm-backend-yas-candidates-number 10)

(with-eval-after-load 'lsp-bridge
  (define-key lsp-bridge-mode-map (kbd "C-l f") 'lsp-bridge-code-format)
  (define-key lsp-bridge-mode-map (kbd "C-l d") 'lsp-bridge-find-def)
  (define-key lsp-bridge-mode-map (kbd "C-l D") 'lsp-bridge-find-def-return)
  (define-key lsp-bridge-mode-map (kbd "C-l p") 'lsp-bridge-peek)
  (define-key lsp-bridge-mode-map (kbd "C-l r") 'lsp-bridge-rename)
  (define-key lsp-bridge-mode-map (kbd "C-l k") 'lsp-bridge-popup-documentation)
  (define-key lsp-bridge-mode-map (kbd "C-l K") 'lsp-bridge-show-documentation)
  (define-key lsp-bridge-mode-map (kbd "C-l a") 'lsp-bridge-code-action)
  (define-key lsp-bridge-mode-map (kbd "C-l S") 'lsp-bridge-workspace-list-symbols)
  (define-key lsp-bridge-mode-map (kbd "C-l s") 'lsp-bridge-workspace-list-symbol-at-point)
  (define-key lsp-bridge-mode-map (kbd "C-l [") 'lsp-bridge-diagnostic-jump-prev)
  (define-key lsp-bridge-mode-map (kbd "C-l ]") 'lsp-bridge-diagnostic-jump-next)
  )

;;; init.el ends here
