(setq split-height-threshold nil)
(setq split-width-threshold 130)
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yba jeu. 04 juil. 2013 14:47:58 CEST
(server-start)

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
  "return a list of string. Those string are path to directories
containing cpp header files. The path takes the root parameter as
the root for the path."
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
(setq-default indent-tabs-mode nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yba Sat Jul  6 15:15:11 2013
(defun find-org-filenames ()
  (let ((root-dir (expand-file-name "~/org/")))
    (mapcar
     (lambda (file-name) (concat root-dir file-name))
     (remove
      nil
      (mapcar
       (lambda (file-name)
         (when (string-match ".org$" file-name)
           file-name))
       (directory-files root-dir))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yba Sat Jul  6 16:02:25 2013
(when (file-readable-p "~/org-mode")
 (add-to-list 'load-path (expand-file-name "~/org-mode/lisp"))
 (add-to-list 'load-path (expand-file-name "~/org-mode/contrib/lisp")))

;; yba jeu. 13 juin 2013 15:51:56 CEST
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(add-hook 'org-mode-hook (lambda () (set-input-method 'latin-1-prefix)))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-agenda-files (find-org-filenames))

;; yba Sun Jul  7 19:22:51 2013
;(require 'auto-complete-config)
;; (add-hook 'after-init-hook ;eval-after-load "auto-complete"
;;   (lambda ()
;;     (when (require 'auto-complete-config nil :no-error)
;;      (require 'find-func)
;;      (add-to-list
;;       'ac-dictionary-directories
;;       (expand-file-name
;;        (concat
;;         (file-name-directory (find-library-name "auto-complete"))
;;         "dict/")))
;;      (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
;;      (setq ac-quick-help-delay 0.5)
;;      (ac-config-default))))

;; yba Sun Jul  7 23:43:44 2013
;(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
;; (eval-after-load "auto-complete"
;;   '(progn
;;      (add-to-list 'ac-modes 'slime-repl-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yba lun. 08 juil. 2013 11:43:29 CEST
(global-set-key
 (kbd "<f5>")
 (lambda ()
   (interactive)
   (revert-buffer :ignore-auto :noconfirm)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; YBA jeu. 18 avril 2013 10:33:45 CEST
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
(custom-set-variables
 '(help-at-pt-timer-delay 0.9)
 '(help-at-pt-display-when-idle '(flymake-overlay)))
(when (fboundp 'flymake-find-file-hook)
  (add-hook 'find-file-hook 'flymake-find-file-hook))
(global-set-key [f2] 'flymake-display-err-menu-for-current-line)
(global-set-key [f3] 'flymake-goto-prev-error)
(global-set-key [f4] 'flymake-goto-next-error)

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
;(setq browse-url-browser-function 'w3m-browse-url)
(setq browse-url-browser-function 'browse-url-default-browser)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IRC
(let ((irc-init-file  (expand-file-name "./irc.el")))
  (when (file-readable-p irc-init-file)
    (load irc-init-file)))

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

  ;; yba lun. 08 juil. 2013 13:21:17 BST 
  ;; Calling 'package-initialize is necessary for being able to call
  ;; any 'package-* functions.
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

  (defun touch-dir (dir-name)
    (shell-command (concat "touch " (expand-file-name dir-name))))

  (add-hook 'after-init-hook
            (lambda ()
              (when (my-packages-too-old-p)
		(upgrade-my-packages))
              (touch-dir package-user-dir))))

(message "INIT.EL: PACKAGE")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'after-init-hook
  (lambda ()
     (message "INIT.EL AFTER LOADING COLOR THEME")
     (if (require 'color-theme nil :no-error)
	 (if (require 'color-theme-molokai nil :no-error)
	     (progn
	       (message "TRIGGER color-theme molokai")
	       (when (fboundp 'color-theme-initialize)
		 (color-theme-initialize))
	       ;;(color-theme-molokai)
               )
	   (message "Color theme molokai not found"))
       (message "Color theme package not found"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path (expand-file-name "~/powerline/"))
(eval-after-load 'powerline
  '(if (fboundp 'powerline-default)
      (powerline-default)))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (when (require 'icicles nil t)
;;   (icy-mode 1))
(require 'ido)
(ido-mode t)
(message "INIT.EL: ICICLES/IDO")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load (expand-file-name "~/quicklisp/slime-helper.el") t)
(add-hook 'lisp-mode-hook
          (lambda () (slime-mode t)))
(add-hook 'inferior-lisp-mode-hook
          (lambda () (inferior-slime-mode t)))
(setq slime-net-coding-system 'utf-8-unix)
(setq inferior-lisp-program "clisp")
(eval-after-load 'slime '(slime-setup '(slime-fancy)))

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
;; yba Wed May  8 18:03:32 2013
(add-to-list 'load-path (expand-file-name "~/.emacs.d/el-get/el-get"))

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-install-skip-emacswiki-recipes)
      (goto-char (point-max))
      (eval-print-last-sexp))))

(add-to-list 'el-get-recipe-path (expand-file-name "~/.emacs.d/el-get-user/recipes"))
(el-get 'sync)

(setq el-get-user-package-directory
      (expand-file-name "~/.emacs.d/el-get-init-files/"))

;; * smartparens - for moving about and making lists and stuff
;; * litable - for the funky eval stuff you see going on
;; * auto-complete - for the completion stuff you see happening
;; * hl-sexp
;; * lexbind - for making a lexscratch buffer and for indicating the lexical status

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

(defadvice package-menu-execute (after save-package-list activate)
  (save-my-installed-packages))

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
;; yba Mon May 20 16:43:00 2013
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/vendor/"))
;(require 'cmake-mode)
(add-to-list
 'auto-mode-alist
 '("CMakeLists\\.txt\\'" . cmake-mode))
(add-to-list
 'auto-mode-alist
 '("\\.cmake\\'" . cmake-mode))

(message "INIT.EL CMAKE mode")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (fset 'comment-channel
;;    (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([0 5 134217848 99 111 109 109 101 110 116 45 114 101 103 105 111 110 13 1 21 52 55 14 0 27 79 66 27 79 65 5 27 120 27 112 13 1 21 52 55 14 14 14 14 14 0 5 134217848 99 111 109 109 101 110 116 45 114 101 103 105 111 110 13 24 19] 0 "%d")) arg)))

(defun yba/comment-channel ()
  (re-search-forward "20140611\\(_[0-9]+\\)" )
  (let ((name (match-string 1)))
    (comment-region (line-beginning-position) (line-end-position))
    (search-forward (concat name "NA.pcap"))
    (comment-region (line-beginning-position) (line-end-position))
    (search-forward (concat name "SA.pcap"))
    (comment-region (line-beginning-position) (line-end-position))))

(defun yba/uncomment-channel ()
  (re-search-forward "20140611\\(_[0-9]+\\)" )
  (let ((name (match-string 1)))
    (uncomment-region (line-beginning-position) (line-end-position))
    (search-forward (concat name "NA.pcap"))
    (uncomment-region (line-beginning-position) (line-end-position))
    (search-forward (concat name "SA.pcap"))
    (uncomment-region (line-beginning-position) (line-end-position))))

;; (fset 'uncomment-channel
;;    (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote (" xuncomment-region47 OBOAxp47 xp" 0 "%d")) arg)))

(defun yba/next-channel ()
  (interactive)
  (let ((save-point (point)))
    (save-excursion
      (save-excursion
        (yba/comment-channel))
      (next-line)
      (yba/uncomment-channel))
    (goto-char save-point)
    (next-line)))

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
