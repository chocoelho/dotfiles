;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "<NAME>"
      user-mail-address "<EMAIL>")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Define where projectile should look for projects
(setq projectile-project-search-path '(("<PROJECTS_PATH>" . 2)))

;; prospector linting
(flycheck-prospector-setup)

;; tabnine completion
(after! company
  (require 'company-tabnine)
  (setq +lsp-company-backend '(company-lsp :with company-tabnine :separate))
  (setq company-idle-delay 0)
  (setq company-show-numbers t))

(add-to-list 'company-backends #'company-tabnine)

; wsl-copy
(defun wsl-copy (start end)
  (interactive "r")
  (shell-command-on-region start end "clip.exe")
  (deactivate-mark))

; wsl-paste
(defun wsl-paste ()
  (interactive)
  (let ((clipboard
     (shell-command-to-string "powershell.exe -command 'Get-Clipboard' 2> /dev/null")))
    (setq clipboard (replace-regexp-in-string "\r" "" clipboard)) ; Remove Windows ^M characters
    (setq clipboard (substring clipboard 0 -1)) ; Remove newline added by Powershell
    (insert clipboard)))

; Bind wsl-copy to C-c C-v
(global-set-key
 (kbd "C-c f c")
 'wsl-copy)

; Bind wsl-paste to C-c C-v
(global-set-key
 (kbd "C-c f v")
 'wsl-paste)

(setq wakatime-cli-path "/usr/local/bin/wakatime")

(xterm-mouse-mode 1)
(unless (display-graphic-p)
  ;; activate mouse-based scrolling
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))

;; wakatime config
(use-package wakatime-mode
  :diminish 'wakatime-mode
  :init
  (add-hook 'prog-mode-hook 'wakatime-mode)
  :config (progn (setq wakatime-cli-path "/usr/local/bin/wakatime")
                 (setq wakatime-python-bin nil)
                 (global-wakatime-mode)))
(after! lsp-mode
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("/usr/local/bin/sourcery" "lsp"))
                    :initialization-options '((token . "<TOKEN>")
                                              (extension_version . "emacs-lsp")
                                              (editor_version . "emacs"))
                    :activation-fn (lsp-activate-on "python")
                    :server-id 'sourcery
                    :add-on? t
                    :priority 2)))
