(global-linum-mode t)

;; TODO Consider how this will impact any emacs-specific uses of TAB key. Also consider binding BS to backward-delete-char instead of backward-delete-char-untabify.


;; Credit to "bpalmer" at #emacs Freenode channel.
(define-minor-mode realtabs-minor-mode
  "Override the binding of the TAB key."
  :keymap '(([?\t] . self-insert-command))
  :global t)
(realtabs-minor-mode 1)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(add-to-list 'load-path "~/.emacs.d/elpa/")


(package-initialize)

(require 'dired+)

;; (define-key dired-mode-map [mouse-2] 'dired-mouse-find-file)

(require 'ecb)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(ecb-options-version "2.50")
 '(inhibit-startup-screen t)
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :height 101 :width normal)))))

(require 'realgud)

;; Makes *scratch* empty.
(setq initial-scratch-message "")

;; Creating a new menu pane in the menu bar to the right of “Tools” menu
(define-key-after
  global-map
  [menu-bar BashDB]
  (cons "BashDB" (make-sparse-keymap "hoot hoot"))
  'tools )

;; Creating a menu item, under the menu by the id “[menu-bar BashDB]”
(define-key
  global-map
  [menu-bar BashDB bashdb]
  '("Launch" . bashdb-large))

;; code to remove the whole menu panel
;; (global-unset-key [menu-bar BashDB])


;;Credit to "rocky".
;;https://github.com/realgud/realgud/issues/205#issuecomment-354851601
(defun bashdb-large (&optional opt-cmd-line no-reset)
  (interactive)
  (let ((cmd-buf
	 (realgud:run-debugger "bashdb"
			       'bashdb-query-cmdline
			       'bashdb-parse-cmd-args
			       'realgud:bashdb-minibuffer-history
			       opt-cmd-line no-reset)
	 ))
    (if cmd-buf
	(let ((process (get-buffer-process cmd-buf)))
	  (if (and process (eq 'run (process-status process)))
	      (with-current-buffer cmd-buf
		(sleep-for 1)
		(realgud-command "frame 0" nil nil nil)
		)))
      )
    ))
