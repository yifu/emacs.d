(setq visible-bell t
      inhibit-startup-screen t)

(put 'scroll-left 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(global-hl-line-mode 1)
(global-visual-line-mode 1)
(show-paren-mode 1)
(blink-cursor-mode -1)
(defalias 'yes-or-no-p 'y-or-n-p)
(windmove-default-keybindings)
(ffap-bindings)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SMTP configuration:
(setq
 user-full-name "Yves Baumes"
 smtpmail-local-domain "gmail.com"
 user-mail-address "ybaumes@gmail.com"
 mail-user-agent 'message-user-agent
 message-send-mail-function 'smtpmail-send-it
 send-mail-function 'smtpmail-send-it
 smtpmail-default-smtp-server "smtp.gmail.com"
 smtpmail-smtp-server "smtp.gmail.com"
 smtpmail-smtp-service 465 ;; 587 doesn't work in my experiments.
 smtpmail-stream-type 'ssl ;; starttls doesn't work in my experiments.
 smtpmail-local-domain "localhost"
 smtpmail-debug-info t
 smtpmail-debug-verb t
 )

(when (eq system-type 'darwin);(string-match "apple" url-os-type)
  (set-language-environment 'utf-8)
;;  (set-terminal-coding-system 'utf-8)
;; (set-keyboard-coding-system 'utf-8-emacs)
;; (prefer-coding-system 'utf-8)
;; mac-function-modifier
;; mac-control-modifier
;; mac-command-modifier
;; mac-option-modifier
;; mac-right-command-modifier
;; mac-right-control-modifier
;; mac-right-option-modifier

;;  (setq mac-command-modifier 'super)
;;  (setq mac-control-modifier 'control)
  (setq ns-function-modifier (quote hyper)
	ns-right-alternate-modifier (quote super)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; w3m conifguration
(setq browse-url-browser-function 'w3m-browse-url)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun irc-init ()
  (add-to-list 'rcirc-server-alist
               '("irc.freenode.net"
                 :channels ("#clojure" "#emacs" "#leiningen")))
  (setq rcirc-default-user-name (setq rcirc-default-nick "keugaerg"))
  (setq rcirc-authinfo
        '(("freenode" nickserv "keugaerg" "lemonsin")))
  (add-hook 'rcirc-mode-hook 'rcirc-omit-mode)

  ;; This code is by Trent Buck <trentbuck@gmail.com>
  ;; It is in the Public Domain.
  (setq rcirc-bots '("fsbot" "birny" "lisppaste" "specbot" "clojurebot"))
  (setq rcirc-pals
        '("nicferrier" "ivan-kanis" "technomancy" "`fogus" "Raynes"
          "rhickey" "cemerick" "amalloy"))

  (defface rcirc-pal-nick-face
    '((((class color) (background dark))  :foreground "PaleGreen")
      (((class color) (background light)) :foreground "PaleGreen3"))
    "Face used for nicks in `rcirc-pals' list.")
  (defface rcirc-bot-nick-face
    '((((class color) (background dark))  :foreground "tomato")
      (((class color) (background light)) :foreground "tomato3"))
    "Face used for nicks in `rcirc-bots' list.")

  (defadvice rcirc-facify (before rcirc-facify-pals)
    (when (eq face 'rcirc-other-nick)
      (when (member string rcirc-pals)
        (setq face 'rcirc-pal-nick-face))
      (when (member string rcirc-bots)
        (setq face 'rcirc-bot-nick-face))))
  (ad-activate 'rcirc-facify))

(eval-after-load 'rcirc '(irc-init))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'tramp)

(setq tramp-debug-buffer t)
(setq tramp-verbose 10)

(setq tramp-default-method "ssh")
(add-to-list
 'tramp-default-method-alist
 '("\\`localhost\\'" "\\`root\\'" "su"))

(add-to-list 'tramp-default-proxies-alist
	     '((regexp-quote "vps20966.ovh.net") "\\`root\\'" "/ssh:%h:"))

;; Avoid Backup files when using sudo or su.
(setq backup-enable-predicate
      (lambda (name)
	(and (normal-backup-enable-predicate name)
	     (not
	      (let ((method (file-remote-p name 'method)))
		(when (stringp method)
		  (member method '("su" "sudo"))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") 'append)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") 'append)
(package-initialize)

(defun upgrade-my-packages ()
  (message "Upgrade packages at %s." (format-time-string "%H:%M-%S"))
  (list-packages)
  (with-current-buffer "*Packages*"
    (package-menu-mark-upgrades)
    (package-menu-execute t)
    (kill-buffer))
  (message "Upgrade packages done at %s." (format-time-string "%H:%M-%S")))

(defun my-packages-too-old-p ()
  (cl-labels ((time-to-date (time) (format-time-string "%c" time)))
    (< 7
       (days-between
	(time-to-date (current-time))
	(time-to-date
	 (nth 5 (file-attributes package-user-dir)))))))

(add-hook 'after-init-hook
	  (lambda ()
	    (when (my-packages-too-old-p)
		(upgrade-my-packages))))

;; (days-between
;;  (format-time-string "%c" (current-time))
;;  (format-time-string "%c" (nth 5 (file-attributes "~/"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'color-theme)
(color-theme-molokai)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/powerline/")
(require 'powerline)
(powerline-default)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'icicles)
(icy-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(require 'slime)
(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))
(setq slime-net-coding-system 'utf-8-unix)

;;(slime-setup '(slime-fancy slime-asdf))
;;(slime-setup '(slime-repl))
(slime-setup '(slime-fancy))
;;(slime-setup)

;;(add-hook 'slime-connected-hook 'slime-redirect-inferior-output)

;; Optionally, specify the lisp program you are using. Default is "lisp"
(setq inferior-lisp-program "clisp")
;;(add-hook 'slime-mode-hook 'slime)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'clojure-mode-hook '(lambda () (paredit-mode)))
(add-hook 'emacs-lisp-mode-hook '(lambda () (paredit-mode)))
(add-hook 'lisp-mode-hook '(lambda () (paredit-mode)))

(add-hook 'prog-mode-hook '(lambda () (linum-mode)))
(add-hook 'clojure-mode-hook '(lambda () (linum-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-x t") 'eshell)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun yba-insert-date ()
  "Insert date time at point."
  (interactive)
  (insert (format-time-string "%c" (current-time))))

;; Thu Feb 14 13:01:11 2013
(defun plist-to-alist (plist)
  (defun get-tuple-from-plist (plist)
    (when plist
      (cons (car plist) (cadr plist))))

  (let ((alist '()))
    (while plist
      (add-to-list 'alist (get-tuple-from-plist plist))
      (setq plist (cddr plist)))
    alist))

;; Fri Feb 22 23:54:24 2013
(defun normalize-semicolon ()
  (interactive)
  (save-excursion
    (while (search-forward-regexp ";\\{70,\\}")
      (replace-match (make-string 70 ?;
				  )))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mon Apr 15 23:16:45 2013
(defun list-my-installed-packages ()
  (remove-if-not
   (lambda (x)
     (and	;(not (memq x jpk-packages))
      (not (package-built-in-p x))
      (package-installed-p x)))
   (mapcar 'car package-archive-contents)))

(setq my-packages-list-filename "~/.emacs.d/my-packages.list")

(defun save-my-installed-packages ()
  (interactive)
  (with-temp-buffer
    (insert
     (with-output-to-string
       (prin1 (list-my-installed-packages))))
    (write-file my-packages-list-filename)))

(defun load-my-packages-list ()
  (interactive)
  (setq my-packages
	(with-temp-buffer
	  (insert-file-contents-literally my-packages-list-filename)
	  (read (current-buffer)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
