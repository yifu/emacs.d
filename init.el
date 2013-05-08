
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yba ven. 03 mai 2013 11:58:40 CEST
(defun directory-p (attr)
  (let ((file-type (car attr)))
   (and
    (not (stringp file-type))
    (car attr))))

;; (defun yba-some (list)
;;   (defun yba-some-aux (acc list)
;;     (if list
;;         (yba-some-aux (or acc (car list)) (cdr list))
;;         acc))
;;   (yba-some-aux nil list))

(defun yba-some (list) (not (null (member t list))))
;;(member t '( nil nil nil))
;;(yba-some '(nil t nil))
;;(yba-some '(nil nil nil))
;;(yba-some nil)
;;(yba-some '(t))

(defun hidden-file-p (file-name)
  (string= "." (substring file-name 0 1)))
;;(hidden-file-p ".")
;;(hidden-file-p "..")
;;(hidden-file-p "toto.hpp")
;;(hidden-file-p ".toto.cpp")

(defun header-directory-p (dir)
  (yba-some
   (mapcar
    (lambda (file-name)
      (when (not (hidden-file-p file-name))
        (not (null (string-match "\\.hp?p?$" file-name)))))
    (directory-files dir))))
;; (length (directory-files "~/git/pdk-software/build/clang_debug/lib"))
;; (directory-files "~/git/pdk-software")
;; (string-match "\\.hp?p?$" "toto")
;; (string-match "\\.hp?p?$" "ouch")
;; (string-match "\\.hp?p?$" "bla.hpp")
;; (string-match "\\.hp?p?$" "bla.h")
;; (string-match "\\.hp?p?$" "bla.c")
;; (string-match "\\.hp?p?$" "bla.hpp.o")

(defun list-dir-child-of (dir)
  (delete
   nil
   (mapcar
    (lambda (file)
      (let ((file-name (car file))
            (file-attr (cdr file)))
       (when (and
              (directory-p file-attr)
              (not (hidden-file-p file-name)))
         (concat dir "/" file-name))))
    (directory-files-and-attributes dir))))
;; (car "toto")
;; (list-dir-of-child "~/git/pdk-software")
;; (list-dir-of-child "~/git/pdk-software/GXALITE/config")
;; (directory-p "~/git/pdk-software/GXALITE/config/config_cleanup.py")
;;(directory-files-and-attributes "~/git/pdk-software/GXALITE/config")

(defun get-header-directories (root)
  "return a list of string. Those string are path to directories containing cpp header files. The path takes the root parameter as the root for the path."
  (interactive "D")
  (setq header-directories '())
  ;; Check the root itself
  (when (header-directory-p root)
    (push root header-directories))

  ;; Make the BST:
  (setq queue (list-dir-child-of root))
  (while queue
    (setq dir (pop queue))
    (when (header-directory-p dir)
      (push dir header-directories))
    (nconc queue (list-dir-child-of dir)))

  ;; Prepare the result removing the root prefix.
  (mapcar
   (lambda (dir)
     (substring dir (length root)))
   header-directories))

;;(get-header-directories "~/git/pdk-software")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; YBA ven. 03 mai 2013 10:41:17 CEST

(message "CEDET HERE")
;; Load CEDET.
;; See cedet/common/cedet.info for configuration details.
;; IMPORTANT: Tou must place this *before* any CEDET component (including
;; EIEIO) gets activated by another package (Gnus, auth-source, ...).
;; (let ((cedet-path (expand-file-name "~/bzr/cedet/cedet-devel-load.el")))
;;   (if (not (file-exists-p cedet-path))
;;       (message "INIT.EL: No cedet found")
;;     (unwind-protect
;;         (progn
;;           (message "Loading cedet...")
;;           (unless (featurep 'cedet-devel-load)
;;             (load-file cedet-path))
;;           (message "Loading cedet done.")

;;           ;; Add further minor-modes to be enabled by semantic-mode.
;;           ;; See doc-string of `semantic-default-submodes' for other things
;;           ;; you can use here.
;;           (add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode t)
;;           (add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode t)
;;           (add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode t)
;;           (add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode t)

;;           (semantic-mode t)
;;           (semantic-load-enable-code-helpers)
;;           (global-ede-mode t)

;;           (require 'semantic/ia)
;;           (require 'semantic/bovine/gcc)
;;           ;; (when (file-exists-p "/usr/bin/clang")
;;           ;;   (require 'semantic/bovine/clang)
;;           ;;   (semantic-clang-activate))
;;           (semantic-add-system-include "/usr/local/include/boost/" 'c++-mode)

;;           (when
;;               (file-exists-p
;;                (expand-file-name "~/git/pdk-software/CMakeLists.txt"))
;;             (ede-cpp-root-project "pdk-software"
;;                                   :name "pdk software"
;;                                   :file
;;                                   (expand-file-name
;;                                    "~/git/pdk-software/CMakeLists.txt")
;;                                   :include-path
;;                                   (get-header-directories
;;                                    (expand-file-name
;;                                     "~/git/pdk-software"))
;;                                   :system-include-path nil
;;                                   :spp-table '(("LINUX" . "")
;;                                                ("_REENTRANT" . "")
;;                                                ("MULTISESSION_TOE" . "")
;;                                                ("_FORTIFY_SOURCE" . "")
;;                                                ("FORCE_INLINE" . "__attribute__((always_inline)) inline")))))
;;       (message "Loading cedet configuration is done"))))

(message "CEDET AFTER")    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq visible-bell t
      inhibit-startup-screen t)

(put 'scroll-left 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))
(when (fboundp 'global-visual-line-mode)
  (global-visual-line-mode 1))

(column-number-mode 1)
(global-hl-line-mode 1)

(show-paren-mode 1)
(blink-cursor-mode -1)
(defalias 'yes-or-no-p 'y-or-n-p)
(windmove-default-keybindings)
(ffap-bindings)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; YBA jeu. 18 avril 2013 10:33:45 CEST
(setq-default indent-tabs-mode nil)
(add-hook 'prog-mode-hook 'linum-mode)

(c-add-style "ub"
             '("bsd"
               (c-basic-offset . 4)     ; Guessed value
               (c-offsets-alist
                (block-close . 0)       ; Guessed value
                (case-label . 0)        ; Guessed value
                (catch-clause . 0)      ; Guessed value
                (defun-block-intro . +) ; Guessed value
                (defun-close . 0)       ; Guessed value
                (defun-open . 0)        ; Guessed value
                (else-clause . 0)       ; Guessed value
                (member-init-intro . 0) ; Guessed value
                (statement . 0)             ; Guessed value
                (statement-block-intro . +) ; Guessed value
                (statement-case-intro . +)  ; Guessed value
                (substatement . +)      ; Guessed value
                (substatement-open . 0) ; Guessed value
                (topmost-intro . 0)     ; Guessed value
                (access-label . -)
                (annotation-top-cont . 0)
                (annotation-var-cont . +)
                (arglist-close . c-lineup-close-paren)
                (arglist-cont c-lineup-gcc-asm-reg 0)
                (arglist-cont-nonempty . c-lineup-arglist)
                (arglist-intro . +)
                (block-open . 0)
                (brace-entry-open . 0)
                (brace-list-close . 0)
                (brace-list-entry . 0)
                (brace-list-intro . +)
                (brace-list-open . 0)
                (c . c-lineup-C-comments)
                (class-close . 0)
                (class-open . 0)
                (comment-intro . c-lineup-comment)
                (composition-close . 0)
                (composition-open . 0)
                (cpp-define-intro c-lineup-cpp-define +)
                (cpp-macro . -1000)
                (cpp-macro-cont . +)
                (do-while-closure . 0)
                (extern-lang-close . 0)
                (extern-lang-open . 0)
                (friend . 0)
                (func-decl-cont . +)
                (inclass . +)
                (incomposition . +)
                (inexpr-class . 0)
                (inexpr-statement . +)
                (inextern-lang . +)
                (inher-cont . c-lineup-multi-inher)
                (inher-intro . +)
                (inlambda . c-lineup-inexpr-block)
                (inline-close . 0)
                (inline-open . 0)
                (inmodule . +)
                (innamespace . +)
                (knr-argdecl . 0)
                (knr-argdecl-intro . +)
                (label . 0)
                (lambda-intro-cont . +)
                (member-init-cont . c-lineup-multi-inher)
                (module-close . 0)
                (module-open . 0)
                (namespace-close . 0)
                (namespace-open . 0)
                (objc-method-args-cont . c-lineup-ObjC-method-args)
                (objc-method-call-cont c-lineup-ObjC-method-call-colons c-lineup-ObjC-method-call +)
                (objc-method-intro .
                                   [0])
                (statement-case-open . 0)
                (statement-cont . +)
                (stream-op . c-lineup-streamop)
                (string . -1000)
                (substatement-label . 0)
                (template-args-cont c-lineup-template-args +)
                (topmost-intro-cont . c-lineup-topmost-intro-cont))))

(setq c-echo-syntactic-information-p t)

(add-hook 'c-mode-hook '(lambda () (c-set-style "ub")))
(add-hook 'c++-mode-hook '(lambda () (c-set-style "ub")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FLYMAKE
;; (custom-set-variables
;;  '(help-at-pt-timer-delay 0.9)
;;  '(help-at-pt-display-when-idle '(flymake-overlay)))
;; (when (fboundp 'flymake-find-file-hook)
;;   (add-hook 'find-file-hook 'flymake-find-file-hook))
;; (global-set-key [f2] 'flymake-display-err-menu-for-current-line)
;; (global-set-key [f3] 'flymake-goto-prev-error)
;; (global-set-key [f4] 'flymake-goto-next-error)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; COMPILE window
(setq compilation-scroll-output t)
(setq compilation-auto-jump-to-first-error t)

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
  (setq rcirc-bots
	'("fsbot" "birny" "lisppaste" "specbot" "clojurebot")
	rcirc-pals
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

(message "INIT.EL: RCIRC")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'tramp)

(setq tramp-debug-buffer t)
(setq tramp-verbose 10)

(setq tramp-default-method "ssh")
(add-to-list
 'tramp-default-method-alist
 '("\\`localhost\\'" "\\`root\\'" "su"))

(when (fboundp 'tramp-default-proxies-alist)
  (add-to-list
   'tramp-default-proxies-alist
   '((regexp-quote "vps20966.ovh.net") "\\`root\\'" "/ssh:%h:")))

;; Avoid Backup files when using sudo or su.
(setq backup-enable-predicate
      (lambda (name)
	(and (normal-backup-enable-predicate name)
	     (not
	      (let ((method (file-remote-p name 'method)))
		(when (stringp method)
		  (member method '("su" "sudo"))))))))

(message "INIT.EL: TRAMP")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (require 'package nil t)

  ;; (add-to-list
  ;;  'package-archives
  ;;  '("melpa" . "http://melpa.milkbox.net/packages/") 'append)
  (add-to-list
   'package-archives
   '("marmalade" . "http://marmalade-repo.org/packages/") 'append)
  (package-initialize)

  (defun upgrade-my-packages ()
    (message
     "Upgrade packages at %s."
     (format-time-string "%H:%M-%S"))
    (list-packages)
    (with-current-buffer "*Packages*"
      (package-menu-mark-upgrades)
      (package-menu-execute t)
      (kill-buffer))
    (message
     "Upgrade packages done at %s."
     (format-time-string "%H:%M-%S")))

  (defun my-packages-too-old-p ()
    (let ((iso-8601-time-format "%Y-%m-%dT%T%z"))
      (defun time-to-date (time)
        (format-time-string iso-8601-time-format time))
      (< 7
         (days-between
          (time-to-date (current-time))
          (time-to-date
           (nth 5 (file-attributes package-user-dir)))))))

  (add-hook 'after-init-hook
            (lambda ()
              (when (my-packages-too-old-p)
		(upgrade-my-packages)))))

(message "INIT.EL: PACKAGE")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (require 'color-theme nil t)
  (when (fboundp 'color-theme-molokai)
    (color-theme-molokai)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path (expand-file-name "~/powerline/"))
(if (require 'powerline nil t)
    (progn
      (if (fboundp 'powerline-default)
          (powerline-default)))
  (message "INIT.EL: No powerline found."))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (when (require 'icicles nil t)
;;   (icy-mode 1))
(require 'ido)
(ido-mode t)
(message "INIT.EL: ICICLES/IDO")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (and
       (load (expand-file-name "~/quicklisp/slime-helper.el") t)
       (require 'slime nil t))
    (progn
      (add-hook 'lisp-mode-hook
                (lambda () (slime-mode t)))
      (add-hook 'inferior-lisp-mode-hook
                (lambda () (inferior-slime-mode t)))
      (setq slime-net-coding-system 'utf-8-unix)
      (slime-setup '(slime-fancy))
      (setq inferior-lisp-program "clisp"))
  (message "INIT.EL: No slime helper found."))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload
  'enable-paredit-mode
  "paredit"
  "Turn on pseudo-structural editing of Lisp code."
  t)

(add-hook 'clojure-mode-hook '(lambda () (enable-paredit-mode)))
(add-hook 'emacs-lisp-mode-hook '(lambda () (enable-paredit-mode)))
(add-hook 'lisp-mode-hook '(lambda () (enable-paredit-mode)))

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

(setq my-packages-list-filename
      (expand-file-name "~/.emacs.d/my-packages.list"))

(defun save-my-installed-packages ()
  (interactive)
  (with-temp-buffer
    (insert
     (with-output-to-string
       (prin1 (list-my-installed-packages))))
    (write-file my-packages-list-filename)))

(defun load-my-packages-list ()
  (interactive)
  (let ((my-packages
	 (with-temp-buffer
	   (insert-file-contents-literally my-packages-list-filename)
	   (read (current-buffer)))))
    (package-refresh-contents)
    (message "Prepare for installing the package list: %s" my-packages)
    (dolist (p my-packages)
      (when (not (package-installed-p p))
        (message "Installing the package %s" (symbol-name p))
        (package-install p))))
      (message "Installing packages is done"))

(message "MY-PACKAGES")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; YBA ven. 19 avril 2013 17:22:43 CEST
(setq counter 0)
(defun inc-channels-indices ()
  (interactive)
  (while (search-forward-regexp "<channel> \\(0\\)")
    (replace-match (number-to-string counter) t t nil 1)
    (setq counter (+ 1 counter))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; YBA ven. 19 avril 2013 17:32:00 CEST
(defun kill-empty-line (beg end)
  (interactive "r")
  (save-excursion
    (goto-char beg)
    (while (and (search-forward-regexp "^$") (< (point) end))
      (kill-line))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; YBA jeu. 25 avril 2013 10:14:03 CEST
(defun kill-line-regexp (beg end regexp)
  "Kill lines in region containing a regular expression."
  (interactive "r\nsregexp: ")
  (save-excursion
    (goto-char beg)
    (while (and (re-search-forward regexp end t) (< (point) end))
      (forward-line 0)
      (let ((kill-whole-line t))
        (kill-line)))))

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
