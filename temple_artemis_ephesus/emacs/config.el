(defun custom-tangle-func ()
  (cond
   ((not (boundp 'custom-tangle))
    (error "custom-tangle is unbound"))
   ((string= custom-tangle "normal")
    "config.el")
   ((string= custom-tangle "test")
    (if (member "notest" (org-get-tags))
        "no"
      "config_test.el"))
   (t
    (error "Unknown value for custom-tangle. No action specified."))))

(load (expand-file-name "~/projects/elisp/custom_functions.el"))

(setq org-hide-emphasis-markers t)

(setq org-directory "~/ecosystems/capture")
(setq org-default-notes-file "~/ecosystems/task_management/refile.org")

(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/ecosystems/task_management/refile.org")
               "* TODO %U\n %i\n  %?")
              ("n" "note" entry (file "~/ecosystems/task_management/refile.org")
               "* %U\n  %i\n  %?"))))

(setq org-roam-capture-templates
      '(("p" "note particule" plain
         "INSERT_INDEX_NOTE_HERE %?"
         :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
         :unnarrowed t)
        ("n" "default" plain
         "%?"
         :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
         :unnarrowed t)))

(setq org-refile-targets `(
                           (,(directory-files-recursively "~/ecosystems/" "^[a-z0-9_-]*.org$") :maxlevel . 4)))

(setq org-tag-alist '((:startgrouptag)
                      ("task")
                      (:grouptags)
                      ("sysm" . nil) ;;system maintenance
                      ("sysi" . nil) ;;system improvement
                      ("prog" . nil) ;;programming
                      ("p_prog_ecosys" . nil) ;;project: programming ecosystem
                      ("irlm" . nil) ;;irl maintenance
                      ("p_ag" . nil) ;;project: algebraic geometry
                      ("p_anl") ;; project: analog system
                      ("p_emacs")
                      (:endgrouptag)
                      (:startgrouptag)
                      ("linux")
                      (:grouptags)
                      ("lin_server")
                      ("lin_nonserv")
                      (:endgrouptag)
                      (:startgrouptag)
                      ("emacs")
                      (:grouptags)
                      (:endgrouptag)
                      (:startgrouptag)
                      ("roam")
                      (:grouptags)
                      ("index")
                      ("n_particule")))

(setq org-todo-keywords
 '((sequence
    "APPOINTMENT(a)"
    "TODO(t)"
    "NEXT(n)"
     "ONGOING(o)"
     "WAITING(w)"
     "|"
     "DONE(d)"
     "CANCELLED(c)"
     "IDEA(i)")))

(setq which-key-use-C-h-commands 1)

(use-package org-roam
  :custom
  (org-roam-directory "~/ecosystems")
  (when (daemonp)
    (org-roam-db-sync)))

(keymap-global-set "M-q" 'avy-goto-char)
(keymap-global-set "M-g M-g" 'avy-goto-char-2)

(global-unset-key (kbd "C-z"))

(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

;;(setq org-agenda-files (directory-files-recursively "~/ecosystems/task_management/" "\\.org$"))

(defun replace-last-sexp ()
  (interactive)
  (let ((value (eval (preceding-sexp))))
    (kill-sexp -1)
    (insert (format "%S" value))))

(frames-only-mode)

(setq pop-up-frames 'graphic-only)

(setq inferior-lisp-program "/usr/bin/sbcl")

(require 'lsp)
(require 'lsp-haskell)

;; Hooks so haskell and literate haskell major modes trigger LSP setup
(add-hook 'haskell-mode-hook #'lsp)
(add-hook 'haskell-literate-mode-hook #'lsp)

(define-key local-function-key-map "\033[32;16~" (kbd "C-s-x"))
(define-key local-function-key-map "\033[32;17~" (kbd "M-s-x"))

(require 'org-download)

(add-hook 'org-mode-hook 'org-fragtog-mode)

(defun org-latex-preview-entire-document ()
  "Selects the entire document, runs org-latex-preview, then deselects the window."
  (interactive)
  ;; Save the current point
  (let ((original-point (point)))
    ;; Select the entire buffer
    (mark-whole-buffer)
    ;; Run org-latex-preview
    (org-latex-preview)
    ;; Deselect the buffer
    (deactivate-mark)
    ;; Move back to the original point
    (goto-char original-point)))

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
   '("k" . "H-k")
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)
   '("=" . consult-mark)
   '("\\" . org-mark-ring-push)
    '("'" . org-latex-preview-entire-document)
    '("\"" .  delete-other-windows)
    '("/" . avy-goto-char)))

(require 'meow)
(meow-setup)
(meow-global-mode 1)

;; Use jk to escape from insert state to normal state
(defvar meow-two-char-escape-sequence "jk")
(defvar meow-two-char-escape-delay 0.5)
(defun meow--two-char-exit-insert-state (s)
  "Exit meow insert state when pressing consecutive two keys.

S is string of the two-key sequence."
  (when (meow-insert-mode-p)
    (let ((modified (buffer-modified-p))
          (undo-list buffer-undo-list))
      (insert (elt s 0))
      (let* ((second-char (elt s 1))
             (event
              (if defining-kbd-macro
                  (read-event nil nil)
              (read-event nil nil meow-two-char-escape-delay))))
        (when event
          (if (and (characterp event) (= event second-char))
              (progn
                (backward-delete-char 1)
                (set-buffer-modified-p modified)
                (setq buffer-undo-list undo-list)
                (meow-insert-exit))
            (push event unread-command-events)))))))
(defun meow-two-char-exit-insert-state ()
  "Exit meow insert state when pressing consecutive two keys."
  (interactive)
  (meow--two-char-exit-insert-state meow-two-char-escape-sequence))
(define-key meow-insert-state-keymap (substring meow-two-char-escape-sequence 0 1)
  #'meow-two-char-exit-insert-state)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (shell . t)
   (python . t)
   (jupyter . t))) ;;always ensure jupyter is last as mentioned in README

;; Clean up ob-jupyter source block output
;; From Henrik Lissner
(defun my/org-babel-jupyter-strip-ansi-escapes-block ()
  (when (string-match-p "^jupyter-"
                        (nth 0 (org-babel-get-src-block-info)))
    (unless (or
             ;; ...but not while Emacs is exporting an org buffer (where
             ;; `org-display-inline-images' can be awfully slow).
             (bound-and-true-p org-export-current-backend)
             ;; ...and not while tangling org buffers (which happens in a temp
             ;; buffer where `buffer-file-name' is nil).
             (string-match-p "^ \\*temp" (buffer-name)))
      (save-excursion
        (when-let* ((beg (org-babel-where-is-src-block-result))
                    (end (progn (goto-char beg)
                                (forward-line)
                                (org-babel-result-end))))
          (ansi-color-apply-on-region (min beg end) (max beg end)))))))

(add-hook 'org-babel-after-execute-hook
          #'my/org-babel-jupyter-strip-ansi-escapes-block)

(defun org-babel-execute-region (beg end &optional arg)
   (interactive "r")
   (narrow-to-region beg end)
   (org-babel-execute-buffer arg)
   (widen))
