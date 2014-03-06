;;; elisp-pack.el --- Emacs-lisp

;;; Commentary:

;;; Code:

(install-packs '(cl-lib
                 dash
                 package-store
                 page-break-lines
                 goto-last-change
                 ert
                 ert-expectations
                 el-mock
                 smartscan))

(require 'smartscan)

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c m s") 'eval-and-replace)
            (local-set-key (kbd "C-c m b") 'eval-buffer)
            (local-set-key (kbd "C-c m e") 'eval-last-sexp)
            (local-set-key (kbd "C-c m i") 'eval-expression)
            (local-set-key (kbd "C-c m d") 'eval-defun)
            (local-set-key (kbd "C-c m n") 'eval-print-last-sexp)
            (local-set-key (kbd "C-c m r") 'eval-region)

            (smartscan-mode)))

(add-hook 'ielm-mode-hook 'paredit-mode)

;; to display a beautiful line instead of the ugly ^L
(require 'page-break-lines)
;; activate the reading of line instead of ^L
(global-page-break-lines-mode t)

;; indentation rule they use bother me
(require 'dash)

(put 'if 'lisp-indent-function 0)
(put 'when 'lisp-indent-function 0)
(put 'unless 'lisp-indent-function 0)
(put '-> 'lisp-indent-function 0)
(put '->> 'lisp-indent-function 0)
(put '--> 'lisp-indent-function 0)
(put '-when-let 'lisp-indent-function 0)
(put '-when-let* 'lisp-indent-function 0)
(put '--when-let 'lisp-indent-function 0)
(put '-if-let 'lisp-indent-function 0)
(put '-if-let* 'lisp-indent-function 0)
(put '--if-let 'lisp-indent-function 0)

(add-to-list 'auto-mode-alist '("Cask$" . emacs-lisp-mode))
(add-to-list 'auto-mode-alist '("\\.feature$" . perl-mode))

;; Try and look for the electric highlight
(defun copy-form ()
  "To copy a form inside the kill ring."
  (interactive)
  (kill-sexp)
  (undo)
  (message "Form in kill-ring! "))

(define-key lisp-mode-shared-map (kbd "C-c C-z") 'ielm)
(define-key global-map (kbd "C-x C-\\") 'goto-last-change)

;;; elisp-pack.el ends here
