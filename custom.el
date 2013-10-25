;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

(defun yba-expand-class ()
  (interactive)
  (let ((case-fold-search nil))
    (save-excursion
            (setq line
                  (replace-regexp-in-string
                   "A" "%c"
                   (replace-regexp-in-string
                    "%" "%%"
                    (thing-at-point 'line) t)
                   t))
            (forward-line)
            (dotimes (i 26)
              (insert
               (format
                line
                (+ i 65)
                (+ i 65)))))))

(global-set-key (kbd "<f6>") 'yba-expand-class)

