
(server-start)
(require 'package)
;;(setq package-archives '())
;; (add-to-list 'package-archives
;;              '("marmalade" . "http://marmalade-repo.org/packages/") 'append)
(add-to-list 'package-archives
  '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)
(package-initialize)
(add-to-list 'custom-theme-load-path "/home/ybaumes/.emacs.d/elpa/ample-theme-0.12")
(load-theme 'tango-dark t)
(require 'color-theme)
(setq split-height-threshold nil)
(setq split-width-threshold 130)
(setq visible-bell t
      inhibit-startup-screen t
      set-mark-command-repeat-pop t)
(put 'scroll-left 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'global-visual-line-mode) (global-visual-line-mode 1))
(column-number-mode 1)
(global-hl-line-mode 1)
(make-variable-buffer-local 'global-hl-line-mode)
(show-paren-mode 1)
(blink-cursor-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)
(windmove-default-keybindings)
(setq confirm-kill-emacs (quote yes-or-no-p))
(setq calendar-week-start-day 1)
(setq-default indent-tabs-mode nil)
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))
(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 99
      scroll-preserve-screen-position 1)
(setq kill-ring-max 10000)
(setq mouse-wheel-follow-mouse 't)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(set-cursor-color "#ffa500")

(require 'whitespace)
(setq-default whitespace-style '(face trailing))
(setq-default whitespace-line-column 80)
(global-whitespace-mode 1)

(require 'ido)
(ido-mode t)
(setq ido-use-filename-at-point t)
(setq ido-auto-merge-work-directories-length -1)
(require 'recentf)
(setq recentf-max-saved-items 50)
(recentf-mode 1)

(defun add-elts-to-list (list-var &rest elt-list)
  (dolist (elt elt-list list-var)
    (add-to-list list-var elt)))
(when (window-system)
  (require 'git-gutter-fringe))
(global-git-gutter-mode +1)
(setq-default indicate-buffer-boundaries 'right)
(setq-default indicate-empty-lines +1)
(require 'smart-mode-line)
(if after-init-time
    (sml/setup)
  (add-hook 'after-init-hook 'sml/setup))
(add-elts-to-list
 'sml/replacer-regexp-list
 '("^~/.emacs.d/" ":ED:")
 '("^~/git/master/" ":MASTER:")
 '("^:PDK/GXAL:/src/modules/\\([^/]*\\)" ":PDK/GXAL/\\1:")
 '("^:PDK:GXALITE" ":PDK/GXAL:")
 '("^~/git/pdk-software/" ":PDK:"))
(setq sml/mode-width 'full)
(setq sml/hidden-modes (quote (" hl-p" " GitGutter" " ElDoc")))
(setq sml/show-client t)
;;(put 'upcase-region 'disabled nil)
;;(put 'downcase-region 'disabled nil)
(setq vc-make-backup-files t)
(global-set-key
 (kbd "<f5>")
 (lambda (&optional force-reverting)
   "Interactive call to revert-buffer. Ignoring the auto-save
file and not requesting for confirmation. When the current buffer
is modified, the command refuses to revert it, unless you specify
the optional argument: force-reverting to true."
   (interactive "P")
   ;;(message "force-reverting value is %s" force-reverting)
   (if (or force-reverting (not (buffer-modified-p)))
       (revert-buffer :ignore-auto :noconfirm)
     (error "The buffer has been modified"))))
(require 'uniquify)
(setq
 uniquify-buffer-name-style 'post-forward
 uniquify-separator ":")

(c-add-style "ub"
             '("bsd"
               (c-basic-offset . 4)     ; Guessed value
               (c-offsets-alist
                (block-close . 0)       ; Guessed value
                (case-label . +)        ; Guessed value
                (catch-clause . 0)      ; Guessed value
                (defun-block-intro . +) ; Guessed value
                (defun-close . 0)       ; Guessed value
                (defun-open . 0)        ; Guessed value
                (else-clause . 0)       ; Guessed value
                (member-init-intro . *) ; Guessed value
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
                (inclass . ++)
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
                (objc-method-call-cont
                 c-lineup-ObjC-method-call-colons
                 c-lineup-ObjC-method-call +)
                (objc-method-intro .
                                   [0])
                (statement-case-open . 0)
                (statement-cont . +)
                (stream-op . c-lineup-streamop)
                (string . -1000)
                (substatement-label . +)
                (template-args-cont c-lineup-template-args +)
                (topmost-intro-cont . c-lineup-topmost-intro-cont))))

(setq c-echo-syntactic-information-p t)
(defun remap-ret-key ()
  (define-key c-mode-base-map "\C-m" 'c-context-line-break))
(add-hook 'c-initialization-hook 'remap-ret-key)
(add-hook 'c-mode-hook (lambda () (c-set-style "ub")))
(add-hook 'c-mode-hook (lambda () (c-toggle-electric-state 1)))
(add-hook 'c-mode-hook (lambda () (c-toggle-auto-newline 1)))
(add-hook 'c-mode-hook (lambda () (c-toggle-hungry-state 1)))
(add-hook 'c-mode-hook (lambda () (subword-mode 1)))
(add-hook 'c-mode-hook (lambda () (hs-minor-mode 1)))
(add-hook 'c++-initialization-hook 'remap-ret-key)
(add-hook 'c++-mode-hook (lambda () (c-set-style "ub")))
(add-hook 'c++-mode-hook (lambda () (c-toggle-electric-state 1)))
(add-hook 'c++-mode-hook (lambda () (c-toggle-auto-newline 1)))
(add-hook 'c++-mode-hook (lambda () (c-toggle-hungry-state 1)))
(add-hook 'c++-mode-hook (lambda () (subword-mode 1)))
(add-hook 'c++-mode-hook (lambda () (hs-minor-mode 1)))
(defface yba/boolean-keywords-face '((t (:foreground "red" :background "cyan" :weight bold)))
  "Face for boolean keyword in c.")
(font-lock-add-keywords
 'c-mode
 '(("\\<\\(and\\|or\\|not\\)\\>" . 'yba/boolean-keywords-face)))
(font-lock-add-keywords
 'c++-mode
 '(("\\<\\(and\\|or\\|not\\)\\>" . 'yba/boolean-keywords-face)))
(global-set-key (kbd "C-c c") 'compile)
(setq hs-isearch-open t)
(add-to-list 'auto-mode-alist '("pdk-software.*\\.h\\'" . c++-mode))
(setq fci-rule-column 80)
(load-file (expand-file-name "~/fill-column-indicator.el"))
(require 'fill-column-indicator)
(add-hook 'c-mode-hook (lambda () (fci-mode)))
(add-hook 'c++-mode-hook (lambda () (fci-mode)))
(add-to-list 'load-path "~/yasnippet")
(require 'yasnippet)
(yas-reload-all)
(add-hook 'c-mode-hook (lambda () (yas-minor-mode)))
(add-hook 'c++-mode-hook (lambda () (yas-minor-mode)))
(global-set-key [f2] 'flymake-display-err-menu-for-current-line)
(global-set-key [f3] 'flymake-goto-prev-error)
(global-set-key [f4] 'flymake-goto-next-error)
(setq compilation-scroll-output t)
;;(setq compilation-auto-jump-to-first-error t)
;;(setq minimap-window-location 'left)


(load (expand-file-name "~/quicklisp/slime-helper.el") t)
(add-hook 'lisp-mode-hook
          (lambda () (slime-mode t)))
(add-hook 'inferior-lisp-mode-hook
          (lambda () (inferior-slime-mode t)))
(eval-after-load 'slime
  '(progn
     (setq slime-net-coding-system 'utf-8-unix)
     (setq inferior-lisp-program "clisp")
     (slime-setup '(slime-fancy))))
(defun yba/enable-hl-sexp-mode ()
  (setq global-hl-line-mode nil)
  (when (fboundp 'hl-sexp-mode)
    (hl-sexp-mode)))
(add-hook 'lisp-mode-hook 'yba/enable-hl-sexp-mode)
(add-hook 'emacs-lisp-mode-hook 'yba/enable-hl-sexp-mode)
(add-hook 'lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(autoload 'enable-paredit-mode "paredit"
  "Turn on pseudo-structural editing of Lisp code."
  t)
(add-hook 'prog-mode-hook '(lambda () (linum-mode)))
;; (add-hook 'prog-mode-hook
;;           (lambda () (setq show-trailing-whitespace t)))

(setq trash-directory (expand-file-name "~/trash/"))
(global-set-key (kbd "C-z") (lambda () (interactive) (message "Do nothing.")))
(global-set-key (kbd "<f11>") 'magit-status)
(global-set-key (kbd "<f12>") 'yba/compile)
(defun yba/deduce-compile-cmd (buffer-file-name)
  (if (string-match "\\(/home/ybaumes/git/[^/]+/\\).*" buffer-file-name)
      (concat "make -j 10  -C " (match-string 1 buffer-file-name) "/build/debug/ "
              "&& notify-send \"EMACS COMPILATION HAS JUST ENDED.\"")
    "make -k"))
(defun yba/compile (&optional arg)
  (interactive "P")
  (if arg
      (call-interactively 'compile)
    (compile (yba/deduce-compile-cmd (buffer-file-name)))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("244e7fdb99a627bfdca1a98860109f7c7f551d7cfb9eec201a65850fdeea34a6" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(defun yba/list-workplaces ()
  "List of currently open workplaces in the ~/git/ directory or on a remote machine accessed via /ssh:.../."
  (interactive)
  (remove-duplicates
   (remove
    nil
    (mapcar
     (lambda (file-name)
       (when (string-match "/\\(git/\\|ssh:\\)\\([^/:]+\\)" file-name)
         (match-string-no-properties 2 file-name)))
     (remove
      nil
      (mapcar #'buffer-file-name (buffer-list)))))
   :test #'string-equal))

(defun yba/revert-buffers ()
  "Revert buffers related to a file, whose filename match against the regexp."
  (interactive)
  (let ((workplace-name (ido-completing-read "Workplace? " (yba/list-workplaces))))
    (dolist (buf (buffer-list))
      (when (and (buffer-file-name buf)
                 (string-match workplace-name (buffer-file-name buf)))
        (with-current-buffer buf
          (revert-buffer :ignore-auto :no-confirm))))))

