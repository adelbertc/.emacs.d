
;; Set file for customizations.
(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))

(require 'package)

;; Set the package sources.
(setq package-archives
      '(("elpa" . "http://tromey.com/elpa/")
        ("gnu" . "http://elpa.gnu.org/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")
        ;; ("melpa" . "http://melpa.milkbox.net/packages/")
        ))

;; The ELPA packages.
(setq elpa-packages
      '(ac-nrepl
        ace-jump-mode
        auctex
        auto-complete
        citrus-mode
        clojure-mode
        clojure-test-mode
        css-mode
        emms
        expand-region
        find-file-in-repository
        haml-mode
        haskell-mode
        hive
        json
        magit
        markdown-mode
        multi-term
        nrepl
        nrepl-ritz
        rainbow-delimiters
        ruby-test-mode
        rvm
        sass-mode
        scss-mode
        starter-kit
        starter-kit-bindings
        starter-kit-lisp
        starter-kit-ruby
        undo-tree
        vertica
        yaml-mode
        yasnippet-bundle))

;; The bleeding edge packages to fetch from MELPA.
;; (setq package-archive-enable-alist
;;       '(("melpa"
;;          ace-jump-mode
;;          magit
;;          melpa
;;          ruby-test-mode
;;          starter-kit
;;          starter-kit-bindings
;;          starter-kit-lisp
;;          starter-kit-ruby)
;;         ("marmalade"
;;          ac-nrepl
;;          nrepl
;;          clojure-mode
;;          clojure-test-mode)))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/emacs-color-theme-solarized"))

;; Enter debugger if an error is signaled?
(setq debug-on-error t)

;; Use cat as pager.
(setenv "PAGER" "cat")

;; Delete trailing whitespace when saving.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Toggle column number display in the mode line.
(column-number-mode)

;; Enable display of time, load level, and mail flag in mode lines.
(display-time)

;; If non-nil, `next-line' inserts newline to avoid `end of buffer' error.
(setq next-line-add-newlines nil)

;; Whether to add a newline automatically at the end of the file.
(setq require-final-newline t)

;; AMAZON WEB SERVICES
(let ((aws-credentials (expand-file-name "~/.aws.el")))
  (if (file-exists-p aws-credentials)
      (progn
        (load-file aws-credentials)
        (setenv "AWS_ACCOUNT_NUMBER" aws-account-number)
        (setenv "AWS_ACCESS_KEY" aws-access-key)
        (setenv "AWS_SECRET_KEY" aws-secret-key)
        (setenv "EC2_PRIVATE_KEY" (expand-file-name ec2-private-key))
        (setenv "EC2_CERT" (expand-file-name ec2-cert)))))

(defun compass-watch ()
  "Find the project root and run compass watch."
  (interactive)
  (let ((directory (locate-dominating-file (expand-file-name (directory-file-name ".")) "config.rb"))
        (compilation-ask-about-save nil)
        (compilation-buffer-name-function (lambda (mode) "*compass*")))
    (if directory
        (compile (message (format "cd %s; compass watch" directory)))
      (message "Can't find compass project root."))))

(defun swap-windows ()
  "Swap your windows."
  (interactive)
  (cond ((not (> (count-windows)1))
         (message "You can't rotate a single window!"))
        (t
         (setq i 1)
         (setq numWindows (count-windows))
         (while  (< i numWindows)
           (let* ((w1 (elt (window-list) i))
                  (w2 (elt (window-list) (+ (% i numWindows) 1)))
                  (b1 (window-buffer w1))
                  (b2 (window-buffer w2))
                  (s1 (window-start w1))
                  (s2 (window-start w2)))
             (set-window-buffer w1  b2)
             (set-window-buffer w2 b1)
             (set-window-start w1 s2)
             (set-window-start w2 s1)
             (setq i (1+ i)))))))

(defun rotate-windows ()
  "Rotate your windows."
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

;; This variable describes the behavior of the command key.
(setq mac-option-key-is-meta t)
(setq mac-right-option-modifier nil)

;; Highlight trailing whitespace
(setq show-trailing-whitespace t)

;; Enable cut-and-paste between Emacs and X clipboard.
(setq x-select-enable-clipboard t)

;; Controls the operation of the TAB key.
(setq tab-always-indent 'complete)

;; The maximum size in lines for term buffers.
(setq term-buffer-maximum-size (* 10 2048))

;; Do not add a final newline when saving.
(setq require-final-newline nil)

(defun reb-query-replace (to-string)
  "Replace current RE from point with `query-replace-regexp'."
  (interactive
   (progn (barf-if-buffer-read-only)
          (list (query-replace-read-to (reb-target-binding reb-regexp)
                                       "Query replace"  t))))
  (with-current-buffer reb-target-buffer
    (query-replace-regexp (reb-target-binding reb-regexp) to-string)))

;; Fixes inf-ruby until starter-kit changed.
(defalias 'inf-ruby-keys 'inf-ruby-setup-keybindings)

;; AC-NREPL
(add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'nrepl-mode))

;; ACE-JUMP-MODE
(setq ace-jump-mode-gray-background nil)

;; ABBREV MODE
(setq abbrev-file-name "~/.emacs.d/abbrev_defs")
(setq default-abbrev-mode t)
(setq save-abbrevs t)

;;; COMPILE-MODE
(setq compilation-scroll-output 't)

;; Show colors in compilation buffers.
;; http://stackoverflow.com/questions/3072648/cucumbers-ansi-colors-messing-up-emacs-compilation-buffer

(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))

(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; CLOJURE-MODE
(add-hook 'clojure-mode-hook
          (lambda ()
            (define-clojure-indent
              (defcontrol 2)
              (defrenderer 2)
              (ANY 2)
              (DELETE 2)
              (GET 2)
              (HEAD 2)
              (POST 2)
              (PUT 2)
              (domonad 1)
              (context 2)
              (api-test 1)
              (web-test 1)
              (database-test 1)
              (defroutes 'defun)
              ;; SQLingvo
              (copy 2)
              (create-table 1)
              (delete 1)
              (drop-table 1)
              (insert 2)
              (select 1)
              (truncate 1)
              (update 2))))

;; DATOMIC
(add-to-list 'auto-mode-alist '("\\.dtm$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.edn$" . clojure-mode))

;; CLOJURESCRIPT
(add-to-list 'auto-mode-alist '("\\.cljs$" . clojure-mode))
(setq inferior-lisp-program "lein trampoline cljsbuild repl-launch chromium")

(defun lein-cljsbuild ()
  (interactive)
  (compile "lein clean; lein cljsbuild auto"))

(defun lein-chrome-repl ()
  "Start a Chrome Browser repl via Leiningen."
  (interactive)
  (run-lisp "lein trampoline cljsbuild repl-launch chromium"))

(defun lein-rhino-repl ()
  "Start a Rhino repl via Leiningen."
  (interactive)
  (run-lisp "lein trampoline cljsbuild repl-rhino"))

(defun lein-node-repl ()
  "Start a NodeJS repl via Leiningen."
  (interactive)
  (run-lisp "lein trampoline noderepl"))

;; CSS-MODE
(setq css-indent-offset 2)

;; DIRED

;; Switches passed to `ls' for Dired. MUST contain the `l' option.
(setq dired-listing-switches "-alh")

(setq dired-dwim-target t)

(defun dired-do-shell-command-in-background (command)
  "In dired, do shell command in background on the file or directory named on
 this line."
  (interactive
   (list (dired-read-shell-command (concat "& on " "%s: ") nil (list (dired-get-filename)))))
  (call-process command nil 0 nil (dired-get-filename)))

;; DIRED-X
(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")
            (define-key dired-mode-map "&" 'dired-do-shell-command-in-background)))

;; User-defined alist of rules for suggested commands.
(setq dired-guess-shell-alist-user
      '(("\\.pdf$" "evince")
        ("\\.xlsx?$" "libreoffice")))

;; FIND-DIRED
(defun find-dired-clojure (dir)
  "Run find-dired on Clojure files."
  (interactive (list (read-directory-name "Run find (Clojure) in directory: " nil "" t)))
  (find-dired dir "-name \"*.clj\""))

(defun find-dired-ruby (dir)
  "Run find-dired on Ruby files."
  (interactive (list (read-directory-name "Run find (Ruby) in directory: " nil "" t)))
  (find-dired dir "-name \"*.rb\""))

;; FIND-FILE-IN-PROJECT
(setq ffip-patterns '("*.coffee" "*.clj" "*.cljs" "*.rb" "*.html" "*.el" "*.js" "*.rhtml" "*.java" "*.sql"))

;; GNUS
(require 'gnus)

;; Which information should be exposed in the User-Agent header.
(setq mail-user-agent 'gnus-user-agent)

;; Default method for selecting a newsgroup.
(setq gnus-select-method
      '(nnimap "gmail"
               (nnimap-address "imap.gmail.com")
               (nnimap-server-port 993)
               (nnimap-stream ssl)))

;; A regexp to match uninteresting newsgroups. Use blank string for Gmail.
(setq gnus-ignored-newsgroups "")

;; Add daemonic server disconnection to Gnus.
(gnus-demon-add-disconnection)

;; Add daemonic nntp server disconnection to Gnus.
(gnus-demon-add-nntp-close-connection)

;; Add daemonic scanning of mail from the mail backends.
(gnus-demon-add-scanmail)

;; Initialize the Gnus daemon.
(gnus-demon-init)

;; HASKELL-MODE
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

;; JAVA

;; Indent Java annotations.
;; http://lists.gnu.org/archive/html/help-gnu-emacs/2011-04/msg00262.html
(add-hook
 'java-mode-hook
 '(lambda ()
    (setq c-comment-start-regexp "\\(@\\|/\\(/\\|[*][*]?\\)\\)")
    (modify-syntax-entry ?@ "< b" java-mode-syntax-table)))

;; MULTI-TERM
(setq multi-term-dedicated-select-after-open-p t
      multi-term-dedicated-window-height 25
      multi-term-program "/bin/bash")

;; Enable compilation-shell-minor-mode in multi term.
;; http://www.masteringemacs.org/articles/2012/05/29/compiling-running-scripts-emacs/

;; TODO: WTF? Turns off colors in terminal.
;; (add-hook 'term-mode-hook 'compilation-shell-minor-mode)

(add-hook 'term-mode-hook
          (lambda ()
            (dolist
                (bind '(("<S-down>" . multi-term)
                        ("<S-left>" . multi-term-prev)
                        ("<S-right>" . multi-term-next)
                        ("C-<backspace>" . term-send-backward-kill-word)
                        ("C-<delete>" . term-send-forward-kill-word)
                        ("C-<left>" . term-send-backward-word)
                        ("C-<right>" . term-send-forward-word)
                        ("C-c C-j" . term-line-mode)
                        ("C-c C-k" . term-char-mode)
                        ("C-v" . scroll-up)
                        ("C-y" . term-paste)
                        ("C-z" . term-stop-subjob)
                        ("M-DEL" . term-send-backward-kill-word)
                        ("M-d" . term-send-forward-kill-word)))
              (add-to-list 'term-bind-key-alist bind))))

(defun last-term-mode-buffer (list-of-buffers)
  "Returns the most recently used term-mode buffer."
  (when list-of-buffers
    (if (eq 'term-mode (with-current-buffer (car list-of-buffers) major-mode))
        (car list-of-buffers) (last-term-mode-buffer (cdr list-of-buffers)))))

(defun switch-to-term-mode-buffer ()
  "Switch to the most recently used term-mode buffer, or create a
new one."
  (interactive)
  (let ((buffer (last-term-mode-buffer (buffer-list))))
    (if (not buffer)
        (multi-term)
      (switch-to-buffer buffer))))

;; NREPL
(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
(add-hook 'nrepl-mode-hook 'rainbow-delimiters-mode)
(add-hook 'nrepl-mode-hook 'subword-mode)

(add-hook 'nrepl-interaction-mode-hook
          (lambda () (define-key nrepl-interaction-mode-map (kbd "C-c C-s") 'clojure-jump-between-tests-and-code)))

(setq nrepl-port "5000")

;; NREPL-RITZ
(defun nrepl-setup-ritz ()
  (require 'nrepl-ritz))
(add-hook 'nrepl-interaction-mode-hook 'nrepl-setup-ritz)

;; OCTAVE
(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1))))

;; RCIRC
(if (file-exists-p "~/.rcirc.el") (load-file "~/.rcirc.el"))
(setq rcirc-default-nick "r0man"
      rcirc-default-user-name "r0man"
      rcirc-default-full-name "Roman Scherer"
      rcirc-server-alist '(("irc.freenode.net" :channels ("#clojure" "#pallet")))
      rcirc-private-chat t
      rcirc-debug-flag t)

(add-hook 'rcirc-mode-hook
          (lambda ()
            (set (make-local-variable 'scroll-conservatively) 8192)
            (rcirc-track-minor-mode 1)
            (flyspell-mode 1)))

;; SCSS-MODE
(setq scss-compile-at-save nil)

;; SMTPMAIL

;; Send mail via smtpmail.
(setq send-mail-function 'sendmail-send-it)

;; Whether to print info in buffer *trace of SMTP session to <somewhere>*.
(setq smtpmail-debug-info t)

;; Fuck the NSA.
(setq mail-signature
      '(progn
         (goto-char (point-max))
         (insert "\n\n--------------------------------------------------------------------------------")
         (spook)))

;; SQL-MODE
(eval-after-load "sql"
  '(progn
     (require 'hive)
     (require 'vertica)
     (let ((filename "~/.sql.el"))
       (when (file-exists-p filename)
         (load-file filename)))))

;; SQL-INDENT
(setq sql-indent-offset 2)

;; TRAMP
(eval-after-load "tramp"
  '(progn
     (tramp-set-completion-function
      "ssh"
      '((tramp-parse-shosts "~/.ssh/known_hosts")
        (tramp-parse-hosts "/etc/hosts")))))

;; RUBY-TEST MODE
(setq ruby-test-ruby-executables '("/usr/local/rvm/rubies/ruby-1.9.2-p180/bin/ruby")
      ruby-test-rspec-executables '("bundle exec rspec"))
(setq ruby-test-ruby-executables '("/usr/local/rvm/rubies/ruby-1.9.3-p194/bin/ruby")
      ruby-test-rspec-executables '("bundle exec rspec"))

(add-hook
 'after-init-hook
 (lambda ()

   ;; Hide scroll and tool bar, and show menu.
   (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
   (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
   (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

   ;; Refresh package archives when necessary.
   (unless (file-exists-p "~/.emacs.d/elpa/archives")
     (package-refresh-contents))

   ;; Install all packages.
   (package-initialize)
   (dolist (package elpa-packages)
     (when (not (package-installed-p package))
       (package-install package)))

   ;; SOLARIZED
   (let ((solarized (getenv "SOLARIZED")))
     (setq solarized-termtrans t
           ;; solarized-degrade t
           ;; solarized-termcolor 256
           )
     (require 'solarized-dark-theme)
     (require 'solarized-light-theme)
     (cond ((string-equal solarized "light")
            (load-theme 'solarized-light t))
           ((string-equal solarized "dark" )
            (load-theme 'solarized-dark t))))

   (load custom-file)

   ;; ;; Fix background/foreground colors in term-mode.
   ;; ;; (setq term-default-bg-color (face-attribute 'default :background))
   ;; ;; (setq term-default-fg-color (face-attribute 'default :foreground))

   ;; AUTO-COMPLETE
   (require 'auto-complete-config)
   (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
   (ac-config-default)

   ;; EMMS
   (emms-all)
   (emms-default-players)

   (add-to-list 'emms-player-list 'emms-player-mpd)
   (condition-case nil
       (emms-player-mpd-connect)
     (error (message "Can't connect to music player daemon.")))

   (setq emms-source-file-directory-tree-function 'emms-source-file-directory-tree-find)
   (setq emms-player-mpd-music-directory (expand-file-name "~/Music"))

   (let ((filename "~/.emms.el"))
     (when (file-exists-p filename)
       (load-file filename)))

   (add-to-list 'emms-stream-default-list
                '("SomaFM: Space Station" "http://www.somafm.com/spacestation.pls" 1 streamlist))

   ;; IDO-UBIQUITOUS
   (add-to-list 'ido-ubiquitous-command-exceptions 'sql-connect)

   ;; RVM
   (when (file-exists-p "/usr/local/rvm")
     (rvm-use-default))

   (require 'ruby-test-mode)

   ;; WINNER-MODE
   (winner-mode)

   ;; Start a terminal.
   (multi-term)

   ;; Turn off hl-line-mode
   (remove-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode)

   ;; Disable pretty lambda.
   (remove-hook 'prog-mode-hook 'esk-pretty-lambdas)

   ;; Load keyboard bindings.
   (global-set-key (kbd "C-c C-+") 'er/expand-region)
   (global-set-key (kbd "C-c C--") 'er/contract-region)
   (global-set-key (kbd "C-c C-.") 'clojure-test-run-test)
   (global-set-key (kbd "C-c SPC") 'ace-jump-mode)
   (global-set-key (kbd "C-x C-g b") 'mo-git-blame-current)
   (global-set-key (kbd "C-x C-g s") 'magit-status)
   (global-set-key (kbd "C-x C-o") 'delete-blank-lines)
   (global-set-key (kbd "C-x M") 'multi-term)
   (global-set-key (kbd "C-x TAB") 'indent-rigidly)
   (global-set-key (kbd "C-x ^") 'enlarge-window)
   (global-set-key (kbd "C-x f") 'find-file-in-repository)
   (global-set-key (kbd "C-x h") 'mark-whole-buffer)
   (global-set-key (kbd "C-x m") 'switch-to-term-mode-buffer)
   (global-set-key [f5] 'compile)

   (global-set-key (kbd "C-c ,") 'ruby-test-run)
   (global-set-key (kbd "C-c M-,") 'ruby-test-run-at-point)

   ;; Unload some keyboard bindings.
   (global-unset-key (kbd "C-x g"))

   ;; EOF
   ))
