(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("456697e914823ee45365b843c89fbc79191fdbaff471b29aad9dcbe0ee1d5641" "6f1f6a1a3cff62cc860ad6e787151b9b8599f4471d40ed746ea2819fcd184e1a" "dccf4a8f1aaf5f24d2ab63af1aa75fd9d535c83377f8e26380162e888be0c6a9" "4ade6b630ba8cbab10703b27fd05bb43aaf8a3e5ba8c2dc1ea4a2de5f8d45882" "11819dd7a24f40a766c0b632d11f60aaf520cf96bd6d8f35bae3399880937970" "3784baeeadd1fefff034f2eeae697982a8de36702b74533917bac30400bc93f6" default))
 '(package-selected-packages
   '(modern-cpp-font-lock doom-themes dracula-theme multiple-cursors lsp-mode eglot magit smooth-scroll toml-mode key-chord rust-mode move-text vterm mood-one-theme)))
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
(column-number-mode)

(move-text-default-bindings)
(defun indent-region-advice (&rest ignored)
  (let ((deactivate deactivate-mark))
    (if (region-active-p)
        (indent-region (region-beginning) (region-end))
      (indent-region (line-beginning-position) (line-end-position)))
    (setq deactivate-mark deactivate)))

(advice-add 'move-text-up :after 'indent-region-advice)
(advice-add 'move-text-down :after 'indent-region-advice)

(require 'hi-lock)
(defun jpt-toggle-mark-word-at-point ()
  (interactive)
  (if hi-lock-interactive-patterns
      (unhighlight-regexp (car (car hi-lock-interactive-patterns)))
    (highlight-symbol-at-point)))

(global-set-key (kbd "M-z") 'jpt-toggle-mark-word-at-point)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(delete-selection-mode 1)

(windmove-default-keybindings)

(load-theme 'mood-one)

(require 'rust-mode)

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)


(keymap-global-set "C-S-s" 'vterm-copy-mode)
(keymap-global-set "C-t" 'vterm)
(setq vterm-max-scrollback 4000)

(require 'smooth-scroll)
(smooth-scroll-mode t)

(global-set-key [(control  down)]  'scroll-up-1)
(global-set-key [(control  up)]    'scroll-down-1)
(global-set-key (kbd "C-z") "\C-g")

(global-set-key (kbd "M-s s") 'rgrep)
(global-set-key (kbd "M-s g") 'grep)
(global-set-key (kbd "M-q") 'yank)
(global-set-key (kbd "M-a") 'yank-pop)

(eval-after-load 'isearch
  '(define-key isearch-mode-map (kbd "M-q") 'isearch-yank-kill))

(eval-after-load 'vterm
  '(define-key vterm-mode-map (kbd "M-q") 'vterm-yank))

(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq-default indent-tabs-mode nil)
(setq-default line-spacing 3)
;; (add-hook 'rust-mode-hook 'lsp-deferred)
(add-hook 'rust-mode-hook
          (lambda()
            (local-unset-key (kbd "C-c C-d"))
            (setq superword-mode 't)))

;; (add-hook 'after-init-hook 'global-company-mode)

(require 'tramp)
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)

;; (use-package lsp-mode
;;   :ensure t
;;   :commands lsp
;;   :config
;;   ;; Set rust-analyzer command (let Tramp resolve the path)
;;   (setq lsp-rust-analyzer-server-command '("/home/roman/.cargo/bin/rust-analyzer"))

;;   ;; Optional: Disable features that slow down Tramp
;;   (setq lsp-enable-file-watchers nil)
;;   (setq lsp-log-io nil))



(defun duplicate-line (arg)
  "Duplicate current line, leaving point in lower line."
  (interactive "*p")

  ;; save the point for undo
  (setq buffer-undo-list (cons (point) buffer-undo-list))

  ;; local variables for start and end of line
  (let ((bol (save-excursion (beginning-of-line) (point)))
        eol)
    (save-excursion

      ;; don't use forward-line for this, because you would have
      ;; to check whether you are at the end of the buffer
      (end-of-line)
      (setq eol (point))

      ;; store the line and disable the recording of undo information
      (let ((line (buffer-substring bol eol))
            (buffer-undo-list t)
            (count arg))
        ;; insert the line arg times
        (while (> count 0)
          (newline)         ;; because there is no newline in 'line'
          (insert line)
          (setq count (1- count)))
        )

      ;; create the undo information
      (setq buffer-undo-list (cons (cons eol (point)) buffer-undo-list)))
    ) ; end-of-let

  ;; put the point in the lowest line and return
  (next-line arg))

(global-set-key (kbd "M-d") 'duplicate-line)
(global-set-key (kbd "<M-right>") 'move-end-of-line)
(global-set-key (kbd "<M-left>") 'move-beginning-of-line)
(global-set-key (kbd "C-x v r") 'vc-revision-other-window)

(defun occur-at-point-or-region ()
  "Call `occur` with the word at point or the selected region as the search string.
Deactivates the region after execution if a region is used."
  (interactive)
  (let ((search-string (if (use-region-p)
                           (prog1
                               (buffer-substring-no-properties (region-beginning) (region-end))
                             (deactivate-mark))
                         (thing-at-point 'word))))
    (if search-string
        (occur search-string)
      (message "No word at point or region selected."))))


(global-set-key (kbd "C-x s") 'occur-at-point-or-region)
(global-set-key (kbd "C-c s") 'occur)

(defun dc/dired-mode-keys ()
   "User defined keys for dired mode."
   (interactive)
   (local-set-key (kbd "<M-up>") 'dired-up-directory))

(add-hook 'dired-mode-hook 'dc/dired-mode-keys)

(defun jetson-find-file ()
  "Open find-file in specific remote directory."
  (interactive)
  (find-file "/ssh:roman@10.123.123.222:~/"))

(setq font-lock-maximum-decoration t)

(defun isearch-add-char ()
  "Pull next character into search string."
  (interactive)
  (isearch-yank-string (string (char-after))))
(define-key isearch-mode-map (kbd "C-c") 'isearch-add-char)
