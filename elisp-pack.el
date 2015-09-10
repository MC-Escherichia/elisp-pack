;;; elisp-pack.el --- Emacs-lisp

;;; Commentary:

;;; Code:

(require 'install-packages-pack)
(install-packages-pack/install-packs '(cl-lib
                                       dash
                                       page-break-lines
                                       goto-last-change
                                       ert
                                       ert-expectations
                                       el-mock
                                       smartscan
                                       emr
                                       repl-toggle
                                       aggressive-indent))

(require 'autoinsert)
(auto-insert-mode 1)

(require 'aggressive-indent)
(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)

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
(require 'page-break-lines)
;; activate the reading of line instead of ^L
(global-page-break-lines-mode t)

(require 'dash)

(add-to-list 'auto-mode-alist '("Cask$" . emacs-lisp-mode))
(add-to-list 'auto-mode-alist '("\\.feature$" . perl-mode))

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

(define-key lisp-mode-shared-map (kbd "C-c C-z") 'ielm)
(define-key global-map (kbd "C-x C-\\") 'goto-last-change)

(autoload 'emr-show-refactor-menu "emr")
(define-key prog-mode-map (kbd "M-RET") 'emr-show-refactor-menu)
(add-hook 'prog-mode-hook 'emr-initialize)

(require 'repl-toggle)
(add-to-list 'rtog/mode-repl-alist '(emacs-lisp-mode . ielm))

(defun trace-functions (fns)
  "Trace functions FNS."
  (mapc 'trace-function fns))

(defun untrace-functions (fns)
  "Trace functions FNS."
  (mapc 'untrace-function fns))

(provide 'elisp-pack)
;;; elisp-pack.el ends here
