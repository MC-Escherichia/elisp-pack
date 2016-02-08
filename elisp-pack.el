;;; elisp-pack.el --- Emacs-lisp

;;; Commentary:

;;; Code:
(require 'use-package)

(use-package bug-hunter)
(use-package ert)
(use-package ert-expectations)
(use-package el-mock)
(use-package goto-last-change)
(use-package cl-lib)
(use-package dash)
(use-package dash-functional)
(use-package overseer)


(use-package autoinsert
  :config (auto-insert-mode 1))

(use-package aggressive-indent
  :config (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode))

(use-package smartscan)

(use-package lisp-mode
  :config
  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (local-set-key (kbd "C-c m s") 'eval-and-replace)
              (local-set-key (kbd "C-c m b") 'eval-buffer)
              (local-set-key (kbd "C-c m e") 'eval-last-sexp)
              (local-set-key (kbd "C-c m i") 'eval-expression)
              (local-set-key (kbd "C-c m d") 'eval-defun)
              (local-set-key (kbd "C-c m n") 'eval-print-last-sexp)
              (local-set-key (kbd "C-c m r") 'eval-region)))
  (add-hook 'emacs-lisp-mode-hook 'smartscan-mode)
  (add-hook 'emacs-lisp-mode-hook 'overseer-mode)
  (define-key lisp-mode-shared-map (kbd "C-c C-z") 'ielm))

(use-package ielm
  :config (add-hook 'ielm-mode-hook 'paredit-mode))

(defun remove-elc-when-visit ()
  "When visit, remove <filename>.elc"
  (make-local-variable 'find-file-hook)
  (add-hook 'find-file-hook
            (lambda ()
              (if (file-exists-p (concat buffer-file-name "c"))
                  (delete-file (concat buffer-file-name "c"))))))
(add-hook 'emacs-lisp-mode-hook 'remove-elc-when-visit)

(defun byte-compile-when-save()
  "When save, recompile it"
  (make-local-variable 'after-save-hook)
  (add-hook 'after-save-hook
	    (lambda ()
	      (if (string-match ".*\.el" (buffer-file-name))
                  (byte-compile-file buffer-file-name)))))

(add-hook 'emacs-lisp-mode-hook 'byte-compile-when-save)

;; to display a beautiful line instead of the ugly ^L
(use-package page-break-lines
  :config
  ;; activate the reading of line instead of ^L
  (global-page-break-lines-mode t))

(use-package files
  :config
  (add-to-list 'auto-mode-alist '("Cask$" . emacs-lisp-mode))
  (add-to-list 'auto-mode-alist '("\\.feature$" . perl-mode)))

;; Try and look for the electric highlight
(defun copy-sexp (&optional arg)
  "Kill the sexp (balanced expression) following point.
With ARG, kill that many sexps after point.
Negative arg -N means kill N sexps before point.
This command assumes point is not in a string or comment."
  (interactive "p")
  (save-excursion
    (let ((opoint (point)))
      (forward-sexp (or arg 1))
      (copy-region-as-kill opoint (point)))))

(use-package emr
  :config
  (autoload 'emr-show-refactor-menu "emr"))

(use-package prog-mode
  :config
  (define-key prog-mode-map (kbd "M-RET") 'emr-show-refactor-menu)
  (add-hook 'prog-mode-hook 'emr-initialize))

(use-package repl-toggle
  :config
  (add-to-list 'rtog/mode-repl-alist '(emacs-lisp-mode . ielm)))

(defun trace-functions (fns)
  "Trace functions FNS."
  (mapc 'trace-function fns))

(defun untrace-functions (fns)
  "Trace functions FNS."
  (mapc 'untrace-function fns))

(global-set-key (kbd "C-x X e") 'edebug-defun)

(provide 'elisp-pack)
;;; elisp-pack.el ends here
