;; User pack init file
;;
;; Use this file to initiate the pack configuration.
;; See README for more information.

;; Load bindings config
(live-load-config-file "bindings.el")

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
             '("gnu" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(package-refresh-contents)

(defun git-grep-dired (repo wildcards regexp)
  "Find Git-controlled files in DIR with a name like WILDCARDS containing a regexp REGEXP and start Dired on output."
  (interactive "DGit-grep (directory): \nsGit-grep (filename wildcard(s), e.g. *.xml): \nsGit-grep (grep regexp): ")
  (setq repo (file-name-as-directory (expand-file-name repo)))
  (switch-to-buffer (concat "*Git Grep " repo "*"))
  (fundamental-mode)
  (setq buffer-read-only nil)
  (erase-buffer)
  (setq default-directory repo)
  (let ((cmd (format "git --git-dir %s/.git ls-files -z%s | xargs -0 grep -lZ -- %s | xargs -0 ls -l"
                     repo
                     (apply 'concat (mapcar (lambda (s) (concat " " (shell-quote-argument s))) (split-string wildcards)))
                     (shell-quote-argument regexp))))
    (insert " " cmd "\n " repo ":\n")
    (call-process-shell-command (concat cmd " | sed -e 's/^/ /g'") nil t))
  (dired-mode)

  ;; (dired-build-subdir-alist)
  ;; From find-dired:
  ;; Set subdir-alist so that Tree Dired will work:
  (if (fboundp 'dired-simple-subdir-alist)
      ;; will work even with nested dired format (dired-nstd.el,v 1.15
      ;; and later)
      (dired-simple-subdir-alist)
    ;; else we have an ancient tree dired (or classic dired, where
    ;; this does no harm)
    (set (make-local-variable 'dired-subdir-alist)
         (list (cons default-directory (point-min-marker)))))
(goto-line 2))

(setq smerge-command-prefix "C-cv")

(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)

;; set up org mode
(setq org-startup-indented t)
(setq org-startup-folded "showall")
(setq org-directory "~/org")

(defun magit-push-to-gerrit ()
  (interactive)
  (magit-git-command "git push-for-review -b origin/master --silent"))

(magit-define-popup-switch 'magit-push-popup
  ?t
  "lda switch"
  "-t lda")

(magit-define-popup-action 'magit-push-popup
  ?g
  "Push to gerrit"
  'magit-push-to-gerrit)

(server-start)

(add-hook 'term-mode-hook 'yas-minor-mode)

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)


;; org mode stuff
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-default-notes-file "~/org/index.org")
(setq org-agenda-files (list "~/org/index.org"))

(define-key term-mode-map (kbd "C-j") 'term-char-mode)
(define-key term-raw-map (kbd "C-j") 'term-line-mode)
