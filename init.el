(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("3784baeeadd1fefff034f2eeae697982a8de36702b74533917bac30400bc93f6" default))
 '(package-selected-packages
   '(smooth-scroll toml-mode key-chord rust-mode move-text vterm mood-one-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(global-display-line-numbers-mode)

(move-text-default-bindings)
(defun indent-region-advice (&rest ignored)
  (let ((deactivate deactivate-mark))
    (if (region-active-p)
        (indent-region (region-beginning) (region-end))
      (indent-region (line-beginning-position) (line-end-position)))
    (setq deactivate-mark deactivate)))

(advice-add 'move-text-up :after 'indent-region-advice)
(advice-add 'move-text-down :after 'indent-region-advice)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(windmove-default-keybindings)

(load-theme 'mood-one)

(require 'rust-mode)

(keymap-global-set "C-S-c" 'vterm-copy-mode)

(require 'smooth-scroll)
(smooth-scroll-mode t)

(global-set-key [(control  down)]  'scroll-up-1)
(global-set-key [(control  up)]    'scroll-down-1)
(global-set-key (kbd "C-z") "\C-g")
