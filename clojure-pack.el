;;; clojure-pack.el --- Clojure configuration

;;; Commentary:

;;; Code:

(require 'install-packages-pack)
(install-packages-pack/install-packs '(cider
                                       midje-mode
                                       clojure-mode
                                       smartscan
                                       clj-refactor
                                       yasnippet
                                       eval-sexp-fu
                                       company))

(require 'eval-sexp-fu)
(require 'cider)
(require 'clojure-mode)
(require 'clj-refactor)
(require 'yasnippet)
(require 'company)

;; datomic file open in clojure-mode
(add-to-list 'auto-mode-alist '("\.dtm$" . clojure-mode))

;; deal with camel case movement inside the clojure mode
(add-hook 'clojure-mode-hook 'subword-mode)

(require 'smartscan)
(add-hook 'clojure-mode-hook
          (lambda ()
            (smartscan-mode-turn-on)
            (clj-refactor-mode 1)
            (yas-minor-mode 1)
            (cljr-add-keybindings-with-prefix "C-c c")
            (eval-sexp-fu-flash-mode 1)))

(defun set-auto-complete-as-completion-at-point-function ()
  "Set auto-complete as completion at point function."
  (setq completion-at-point-functions '(company-complete)))

(add-hook 'cider-repl-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'cider-mode-hook 'set-auto-complete-as-completion-at-point-function)

(add-hook 'cider-repl-mode-hook
          (lambda ()
            (local-set-key (kbd "M-RET") 'cider-doc)))

(add-hook 'cider-repl-mode-hook 'enable-paredit-mode)

;; for cider, do add the following to your ~/.lein/profiles.clj
;; :plugins [[cider/cider-nrepl "0.6.0"]]

;; help in repl with :
;; (setq cider-repl-shortcut-dispatch-char ?\:)

(defun cider-perso-namespace-refresh ()
  "Add [org.clojure/tools.namespace \"0.2.4\"] to project.clj - Help to deal with clojure namespace."
  (interactive)
  (cider-interactive-eval
   "(require 'clojure.tools.namespace.repl)
    (clojure.tools.namespace.repl/refresh)"))

(defun cider-perso-run-expectations-tests ()
  "Add [expectations [org.clojure/tools.namespace \"0.2.4\"] to project.clj - Help to deal with clojure namespace."
  (interactive)
  (cider-interactive-eval
   "(require 'expectations)
    (expectations/run-all-tests)"))

;; (setq cider-mode-hook)
(add-hook 'cider-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c c e b") 'cider-eval-buffer)
            (local-set-key (kbd "C-c c n r") 'cider-perso-namespace-refresh)
            (local-set-key (kbd "C-c c t r") 'cider-perso-run-expectations-tests)
            (local-set-key (kbd "M-RET") 'cider-doc)))

;; Enable eldoc in Clojure buffers:
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)

;; You can hide the *nrepl-connection* and *nrepl-server* buffers from appearing in some buffer switching commands like switch-to-buffer(C-x b) like this:
;; (setq nrepl-hide-special-buffers t)

;; Prevent the auto-display of the REPL buffer in a separate window after connection is established:
;; (setq cider-repl-pop-to-buffer-on-connect nil)

;; Stop the error buffer from popping up while working in buffers other than the REPL:
;; (setq cider-popup-stacktraces nil)

;; Enable error buffer popping also in the REPL:
(setq cider-repl-popup-stacktraces t)

;; To auto-select the error buffer when it's displayed:
(setq cider-auto-select-error-buffer t)

;; The REPL buffer name has the format *cider-repl project-name*. Change the separator from space to something else by overriding nrepl-buffer-name-separator.
;; (setq nrepl-buffer-name-separator "-")

;; The REPL buffer name can also display the port on which the nREPL server is running. Buffer name will look like cider-repl project-name:port.
(setq nrepl-buffer-name-show-port t)

;; Make C-c C-z switch to the CIDER REPL buffer in the current window:
(setq cider-repl-display-in-current-window t)

;; Limit the number of items of each collection the printer will print to 100:
(setq cider-repl-print-length 100) ; the default is nil, no limit

;; Prevent C-c C-k from prompting to save the file corresponding to the buffer being loaded, if it's modified:
(setq cider-prompt-save-file-on-load t)

;; Change the result prefix for REPL evaluation (by default there's no prefix):
;; (setq cider-repl-result-prefix ";; ")

;; Change the result prefix for interactive evaluation (by default it's =>):
;; (set cider-interactive-eval-result-prefix ";; => ")

;; Normally code you input in the REPL is font-locked with cider-repl-input-face (after you press RET) and results are font-locked with cider-repl-output-face.
;; If you want them to be font-locked as in clojure-mode use the following:
(setq cider-repl-use-clojure-font-lock t)

;; You can control the C-c C-z key behavior of switching to the REPL buffer with the cider-switch-to-repl-command variable.
;; While the default command cider-switch-to-relevant-repl-buffer should be an adequate choice for most users, cider-switch-to-current-repl-buffer
;; offers a simpler alternative where CIDER will not attempt to match the correct REPL buffer based on underlying project directories:
;; (setq cider-switch-to-repl-command 'cider-switch-to-current-repl-buffer)

;; If using the wrap-stacktrace middleware from cider-nrepl, error buffer stacktraces may be filtered by default.
;; Valid filter types include java, clj, repl, tooling, and dup. Setting this to nil will show all stacktrace frames.
;; (setq cider-stacktrace-default-filters '(tooling dup))

(provide 'clojure-pack)
;;; clojure-pack.el ends here
