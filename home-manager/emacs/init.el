;;; init --- My init.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Yasushi Asahi

;; Author: Yasushi Asahi <asahi1600@gmail.com>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; My init.el.

;;; Code:
(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
  (package-initialize))

(use-package leaf :ensure t)

(leaf *primitives
  :config
  (leaf exec-path-from-shell
	  :doc "Get environment variables such as $PATH from the shell"
	  :url "https://github.com/purcell/exec-path-from-shell"
	  :ensure t
    :custom ((exec-path-from-shell-arguments . nil)
             (exec-path-from-shell-variables . '("PATH")))
    :config
    (exec-path-from-shell-initialize))

  (leaf no-littering
    :doc "組み込みor外部に関わらず、パッケージが作り出す設定ファイルを整頓して、.config/emacs配下を綺麗に保つ"
    :url "https://github.com/emacscollective/no-littering"
    :ensure t
    :defvar (no-littering-var-directory no-littering-etc-directory)
    :config
    ;; Lock files
    (let ((dir (no-littering-expand-var-file-name "lock-files/")))
      (make-directory dir t)
      (setq lock-file-name-transforms `((".*" ,dir t))))

    ;; Saved customizations
    (setq custom-file (no-littering-expand-var-file-name "custom.el"))

    (leaf recentf
      :doc "開いたファイルの履歴を保存しておく機能"
      :tag "builtin"
      :custom ((recentf-max-saved-items . 100))
      :hook ((emacs-startup-hook . recentf-mode))
      :defvar (recentf-exclude)
      :defun (recentf-expand-file-name)
      :config
      ;; no-littering配下ファイルは除外
      ;; https://github.com/emacscollective/no-littering?tab=readme-ov-file#recent-files
      (add-to-list 'recentf-exclude
                   (recentf-expand-file-name no-littering-var-directory))
      (add-to-list 'recentf-exclude
                   (recentf-expand-file-name no-littering-etc-directory))
      )

    (leaf files
      :doc "file input and output commands for Emacs"
      :custom ((version-control . t)
               (delete-old-versions . t))
      :config
      ;; Auto-save, backup and undo-tree files
      (no-littering-theme-backups)
      ;; .dir-locals.el読み込み時の警告を抑制する
      (add-to-list 'safe-local-variable-values '(eval . (eglot-ensure)))
      (add-to-list 'safe-local-variable-values '(eval . (lsp-deferred)))
      (add-to-list 'safe-local-variable-values '(eval . (apheleia-mode))))
    )

  (leaf cus-start
    :doc "define customization properties of builtins"
    :custom ((tab-width . 2))
    :config
    (defalias 'yes-or-no-p 'y-or-n-p)
    (indent-tabs-mode -1))

  (leaf autorevert
    :doc "revert buffers when files on disk change"
    :tag "builtin"
    :global-minor-mode global-auto-revert-mode)

  (leaf delsel
    :doc "delete selection if you insert"
    :tag "builtin"
    :global-minor-mode delete-selection-mode)

  (leaf undo-fu
    :doc "Undo helper with redo"
    :url "https://codeberg.org/ideasman42/emacs-undo-fu"
    :ensure t
    :custom ((undo-limit . 67108864)
             (undo-strong-limit . 100663296)
             (undo-outer-limit . 1006632960))
    :bind* (("C-/" . undo-fu-only-undo)
            ("C-?" . undo-fu-only-redo)))

  (leaf vundo
    :doc "Visual undo tree"
    :url "https://github.com/casouri/vundo"
    :ensure t
    :custom ((vundo-roll-back-on-quit . nil)
             (vundo-glyph-alist . vundo-unicode-symbols))
    :bind* ("C-M-/" . vundo))

  (leaf *font
    :config
    (set-language-environment "Japanese")
    (prefer-coding-system 'utf-8-unix)
    (add-to-list 'default-frame-alist
                 '(font . "HackGen35-13")))

  nixpkgs.emacsにoverrideでns-inline-patchを当ててもうまいこと行かない
  (leaf *mac-input-source
    :defun (my-set-cursor-japanese-style my-set-cursor-abc-style)
    :config
    ;; https://github.com/takaxp/ns-inline-patch?tab=readme-ov-file#how-to-us
    (when (and (memq window-system '(ns nil))
               (fboundp 'mac-get-current-input-source))
      (when (version< "27.0" emacs-version)
        ;; Required for some cases when auto detection is failed or the locale is "en".
        (custom-set-variables
         '(mac-default-input-source "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese")))
      (mac-input-method-mode 1))

    (defun my-set-cursor-japanese-style ()
      "カーソルを日本語入力時の見た目に変更する."
      ;; (setf (alist-get 'cursor-type default-frame-alist) 'hbar)
      (set-frame-parameter (window-frame) 'cursor-type 'hbar)
      (setf (alist-get 'cursor-color default-frame-alist) "#CE7667"))

    (defun my-set-cursor-abc-style ()
      "カーソルを英語の見た目に変更する."
      ;; (setf (alist-get 'cursor-type default-frame-alist) 'box)
      (set-frame-parameter (window-frame) 'cursor-type 'box)
      (setf (alist-get 'cursor-color default-frame-alist) "#888dbc"))

    (add-hook 'input-method-deactivate-hook 'my-set-cursor-abc-style)
    (add-hook 'input-method-activate-hook 'my-set-cursor-japanese-style)

    (if (mac-ime-active-p)
        (my-set-cursor-japanese-style)
      (my-set-cursor-abc-style))
    )
  )

(leaf *looks
  :config
  (leaf solarized-theme
    :doc "The Solarized color theme"
    :url "https://github.com/bbatsov/solarized-emacs"
    :ensure t
    :custom ((solarized-emphasize-indicators . nil)
             (solarized-use-less-bold . t))
    :config
    (load-theme 'solarized-dark t))

  (leaf nerd-icons
    :doc "nerdアイコンをいろんなところに表示できるようになる"
    :ensure t
    :require
    :config
    ; (nerd-icons-install-fonts t)
    (leaf nerd-icons-dired
      :doc "Shows icons for each file in dired mode"
      :url "https://github.com/rainstormstudio/nerd-icons-dired"
      :ensure t
      :hook (dired-mode-mode))
    )

  (leaf pulsar
    :doc "Pulse highlight on demand or after select functions"
    :url "https://github.com/protesilaos/pulsar"
    :ensure t
    :global-minor-mode pulsar-global-mode)

  (leaf mini-echo
    :doc "Echo buffer status in minibuffer window"
    :url "https://github.com/liuyinz/mini-echo.el"
    :ensure t
    :defvar (mini-echo-persistent-rule)
    :defun (eglot-current-server jsonrpc--process)
    :global-minor-mode t
    :custom ((mini-echo-persistent-rule . '(:long ("major-mode" "shrink-path" "vcs" "buffer-position" "eglot" "flymake")
                                                  :short ("buffer-name" "buffer-position" "flymake"))))
    :config
    (mini-echo-define-segment "eglot"
      "eglotのcurrent serverを表示する"
      :fetch
      (when-let ((_  (fboundp 'jsonrpc--process))
	               (_  (fboundp 'eglot-current-server))
	               (current-server (eglot-current-server)))
        (nth 4 (process-command (jsonrpc--process current-server)))))
    ;; (if (and (fboundp 'jsonrpc--process)
    ;;          (fboundp 'eglot-current-server))
    ;;     (let ((current-server (eglot-current-server)))
    ;;       (if current-server
    ;;           (nth 4 (process-command (jsonrpc--process current-server))))))
    )

  (leaf *meigen
    :config
    (leaf request
      :doc "Compatible layer for URL request"
      :url "https://github.com/tkf/emacs-request"
      :ensure t
      :config
      (defun display-startup-echo-area-message ()
        (request "https://meigen.doodlenote.net/api/json.php"
          :parser 'json-read
          :success (cl-function
                    (lambda (&key data &allow-other-keys)
		                  (let* ((item (aref data 0))
                             (meigen (alist-get 'meigen item))
                             (auther (alist-get 'auther item)))
                        (message "%s\nby %s" meigen auther))))))
      )
    )
  )

(leaf *key-binding
  :defun (my/beginning-of-line-text-or-line my/keyboard-quit-dwim)
  :config
  ;; C-hはバックスペースにする https://www.emacswiki.org/emacs/BackspaceKey
  (define-key key-translation-map [?\C-?] [?\C-h])
  (define-key key-translation-map [?\M-\d] [?\M-h])
  (define-key key-translation-map [?\C-h] [?\C-?])
  (define-key key-translation-map [?\M-h] [?\M-\d])

  (leaf simple
    :doc "basic editing commands for Emacs"
    :custom ((kill-read-only-ok . t)
             (kill-whole-line . t)))

  ;; TODO これがEMPようの設定
  (leaf *mac
    :custom ((mac-option-modifier . 'meta)     ; optionキーをmetaとして扱う
             (mac-command-modifier . 'super))  ; commandキーをsuperとして扱う
    :bind (("s-v" . yank)
	         ("s-c" . kill-ring-save)
	         ("s-x" . kill-region)))

  (defun my/beginning-of-line-text-or-line ()
    "行の最初の文字の位置に移動。すでに最初の文字だったら行頭に移動。"
    (interactive)
    (let ((curr-point (point))		        ; コマンド実行前のカーソル位置
	        (curr-column (current-column))) ; コマンド実行前の行番号
      (back-to-indentation)		            ; 一旦行の最初の文字の位置に移動
      (when (and (/= curr-column 0)	      ; 元々行頭にいなかった
	               (<= curr-point (point))) ; 最初の文字の位置よりも前にいた
        (beginning-of-line))))            ; その場合は行頭に移動
  (define-key global-map (kbd "C-a") #'my/beginning-of-line-text-or-line)

  ;; https://protesilaos.com/codelog/2024-11-28-basic-emacs-configuration/#h:83c8afc4-2359-4ebe-8b5c-f2e5257bdda3
  (defun my/keyboard-quit-dwim ()
    "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
    (interactive)
    (cond
     ((region-active-p)
      (keyboard-quit))
     ((derived-mode-p 'completion-list-mode)
      (delete-completion-window))
     ((> (minibuffer-depth) 0)
      (abort-recursive-edit))
     (t
      (keyboard-quit))))
  (define-key global-map (kbd "C-g") #'my/keyboard-quit-dwim)

  (leaf transient
    :doc "Transient commands."
    :url "https://github.com/magit/transient"
    :ensure t
    :require t
    :defvar (my/transient-window-operation)
    :defun (transient-define-prefix my/transient-window-operation)
    :bind (("C-t" . my/transient-window-operation-with-pulse)
           ("M-i" . my/transient-string-inflection))
    :config
    (transient-define-prefix my/transient-window-operation ()
      "Window Operation"
      :transient-suffix     'transient--do-stay
      :transient-non-suffix 'transient--do-exit
      [:class transient-columns
	            ["Move"
               ("p" "↑" windmove-up)
	             ("n" "↓" windmove-down)
	             ("b" "←" windmove-left)
	             ("f" "→" windmove-right)]
	            ["Ajust"
               ("<up>" "↑" shrink-window)
	             ("<down>" "↓" enlarge-window)
               ("<left>" "←" shrink-window-horizontally)
	             ("<right>" "→" enlarge-window-horizontally)]
	            ["Split"
	             ("\\" "vertical" split-window-right)
	             ("-" "horizontal" split-window-below)
               ("s" "swap" window-swap-states)
	             ("e" "balance" balance-windows)]
	            ["Ohter"
	             ("0" "delete" delete-window)
               ("q" "delete" delete-window)
	             ("1" "only" delete-other-windows)
	             ("t" "maxmaiz" toggle-frame-maximized)]])
    (put 'my/transient-window-operation 'interactive-only nil)

    (defun my/transient-window-operation-with-pulse ()
      (interactive)
      (pulsar-highlight-line)
      (my/transient-window-operation))

    (leaf string-inflection
      :doc "Underscore>UPCASE>CamelCase>lowerCamelCase conversion"
      :url "https://github.com/akicho8/string-inflection"
      :ensure t
      :defvar (my/transient-string-inflection)
      :defun (string-inflection-underscore-function
              string-inflection-pascal-case-function
              string-inflection-camelcase-function
              string-inflection-camelcase-function
              string-inflection-upcase-function
              string-inflection-upcase-function
              string-inflection-kebab-case-function
              string-inflection-capital-underscore-function
              string-inflection-all-cycle)
      :config
      (transient-define-prefix my/transient-string-inflection ()
        "Window Operation"
        :transient-suffix     'transient--do-exit
        [:class transient-columns
	              ["Single word"
	               ("u" "EMACS" upcase-word)
                 ("d" "emacs" downcase-word)
                 ("c" "Emacs" capitalize-word)]
                ["Mulchple Words"
                 ("m" "FooBar" string-inflection-camelcase)
                 ("l" "fooBar" string-inflection-lower-camelcase)
                 ("u" "foo_bar" string-inflection-underscore)
                 ("p" "Foo_Bar" string-inflection-capital-underscore)
                 ("s" "FOO_BAR" string-inflection-upcase)
                 ("k" "foo-bar" string-inflection-kebab-case)]
	              ["Cycle"
                 ("a" "cycle" string-inflection-all-cycle)]])
      )
    )

  (leaf which-key
    :doc "Display available keybindings in popup"
    :url "https://github.com/justbur/emacs-which-key"
    :ensure t
    :global-minor-mode t)
  )

(leaf *utility-functions
  :config
  ;;; visual-replaceを試してみる
  ;; (leaf visual-regexp
  ;;   :doc "A regexp/replace command for Emacs with interactive visual feedback"
  ;;   :url "https://github.com/benma/visual-regexp.el/"
  ;;   :ensure t)

  (leaf visual-replace
    :doc "A prompt for replace-string and query-replace"
    :url "http://github.com/szermatt/visual-replace"
    :ensure t
    :global-minor-mode visual-replace-global-mode)

  (leaf restart-emacs
    :doc "Restart emacs from within emacs"
    :tag "convenience"
    :url "https://github.com/iqbalansari/restart-emacs"
    :ensure t
    :custom (restart-emacs-restore-frames . t))

  (leaf open-junk-file
    :doc "Open a junk (memo) file to try-and-error"
    :url "http://www.emacswiki.org/cgi-bin/wiki/download/open-junk-file.el"
    :ensure t
    :custom ((open-junk-file-format . "~/ghq/github.com/yasushiasahi/junkfiles/%Y/%m/%d-%H%M%S.")))

  (leaf go-translate
    :doc "Translation framework, configurable and scalable"
    :url "https://github.com/lorniu/go-translate"
    :ensure t
    :defvar (gt-langs gt-default-translator my/deepl-api-key)
    :defun (gt-translator gt-google-engine gt-deepl-engine gt-buffer-render)
    :commands gt-do-translate
    :config
    (setq gt-langs '(ja en))
    (setq gt-default-translator (gt-translator
                                 :engines (list (gt-google-engine) (gt-deepl-engine :key my/deepl-api-key))
                                 :render (gt-buffer-render)))
    )

  (leaf avy
	  :doc "Jump to arbitrary positions in visible text and select text quickly"
	  :url "https://github.com/abo-abo/avy"
	  :ensure t
    :bind (("C-s" . avy-goto-char-timer)))
  )

(leaf *git
  :config
  (leaf magit
    :doc "A Git porcelain inside Emacs"
    :url "https://github.com/magit/magit"
    :ensure t)

  (leaf diff-hl
    :doc "Highlight uncommitted changes using VC"
    :url "https://github.com/dgutov/diff-hl"
    :ensure t
    :global-minor-mode (global-diff-hl-mode
                        diff-hl-flydiff-mode
                        global-diff-hl-show-hunk-mouse-mode)
    :hook ((magit-post-refresh-hook . diff-hl-magit-post-refresh)
           (dired-mode-hook . diff-hl-dired-mode)))

  ;;; 使いたいけど。よくわからん。
  ;; (leaf difftastic
  ;;   :doc "Wrapper for difftastic"
  ;;   :url "https://github.com/pkryger/difftastic.el"
  ;;   :ensure t
  ;;   :global-minor-mode difftastic-bindings-mode)
  )

(leaf *programing-minar-modes
  :config
  (leaf apheleia
    :doc "Reformat buffer stably"
    :url "https://github.com/radian-software/apheleia"
    :ensure t
    :hook (nix-ts-mode-hook . apheleia-mode)
    :commands apheleia-mode
    :defvar (apheleia-formatters apheleia-mode-alist)
    :custom ((apheleia-formatters-respect-indent-level . nil))
    :config
    (push '(prettier-astro . ("apheleia-npx" "prettier" "--stdin-filepath" filepath
                              "--plugin=prettier-plugin-astro" "--parser=astro"))
          apheleia-formatters)
    (setf (alist-get 'astro-ts-mode apheleia-mode-alist)
	        'prettier-astro)
    )

  (leaf orderless
    :doc "Completion style for matching regexps in any order"
    :url "https://github.com/oantolin/orderless"
    :defun (orderless--highlight orderless-compile)
    :ensure t
    :custom ((completion-styles . '(orderless basic))
             (completion-category-defaults . nil)
             (completion-category-overrides . '((file (styles partial-completion))))))

  (leaf tempel
    :doc "Tempo templates/snippets with in-buffer field editing"
    :url "https://github.com/minad/tempel"
    :ensure t
    :custom `((tempel-path . ,(no-littering-expand-etc-file-name "templates")))
    :bind (("M-+" . tempel-complete)
           ("M-*" . tempel-insert))
    :hook ((conf-mode-hook prog-mode-hook text-mode-hook) . tempel-setup-capf)
    :init
    (defun tempel-setup-capf ()
      (setq-local completion-at-point-functions
                  (cons #'tempel-expand
                        completion-at-point-functions)))
    :config
    (leaf tempel-collection
      :doc "Collection of templates for Tempel"
      :url "https://github.com/Crandel/tempel-collection"
      :ensure t
      :require t)
    )

  (leaf corfu
    :doc "コード補完機能"
    :ensure t
    :require corfu-popupinfo
    :defvar (corfu-margin-formatters)
    :global-minor-mode global-corfu-mode corfu-popupinfo-mode
    :custom ((corfu-auto . t)
             (corfu-auto-delay . 0)
             (corfu-auto-prefix . 1)
             (corfu-popupinfo-delay . 0))
    :bind ((corfu-map
            ("C-s" . corfu-insert-separator)))
    :config
    (leaf nerd-icons-corfu
      :doc "Corfuにアイコンを表示する"
      :ensure t
      :config
      (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))
    )

  (leaf marginalia
    :doc "Enrich existing commands with completion annotations"
    :url "https://github.com/minad/marginalia"
    :ensure t
    :global-minor-mode t
    :config
    (leaf nerd-icons-completion
      :doc "Add icons to completion candidates"
      :url "https://github.com/rainstormstudio/nerd-icons-completion"
      :ensure t
      :global-minor-mode t
      :hook (marginalia-mode-hook . nerd-icons-completion-marginalia-setup))
    )

  (leaf vertico
    :doc "言わずと知れたミニバッファ補完インターフェイス"
    :url "https://github.com/minad/vertico"
    :ensure t
    :defvar (crm-separator)
    :defun (crm-indicator vertico--candidate)
    :global-minor-mode t
    :custom ((enable-recursive-minibuffers . t)
             (read-extended-command-predicate . #'command-completion-default-include-p)
             (vertico-count . 30))
    :init
    (defun crm-indicator (args)
      (cons (format "[CRM%s] %s"
                    (replace-regexp-in-string
                     "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                     crm-separator)
                    (car args))
            (cdr args)))
    (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

    ;; Do not allow the cursor in the minibuffer prompt
    (setq minibuffer-prompt-properties
          '(read-only t cursor-intangible t face minibuffer-prompt))
    (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

    :config
    (leaf vertico-directory
      :doc "Ido-like directory navigation for Vertico"
      :url "https://github.com/minad/vertico"
      :require t
      :bind (vertico-map
             ("RET" . vertico-directory-enter)
             ("DEL" . vertico-directory-delete-char)
             ("M-DEL" . vertico-directory-delete-word))
      :hook ((rfn-eshadow-update-overlay-hook . vertico-directory-tidy)))

    (leaf savehist
      :doc "Save minibuffer history"
      :tag "builtin"
      :global-minor-mode t)
    )

  (leaf consult
    :doc "Consulting completing-read"
    :url "https://github.com/minad/consult"
    :ensure t
    :defun (consult-customize consult--read)
    :bind* (;; C-c bindings in `mode-specific-map'
            ("C-c M-x" . consult-mode-command)
            ;; C-x bindings in `ctl-x-map'
            ("C-x b" . consult-buffer)
            ;; Other custom bindings
            ("M-y" . consult-yank-pop)
            ;; M-g bindings in `goto-map'
            ("M-g f" . consult-flymake)
            ("M-g g" . consult-goto-line)
            ("M-g m" . consult-mark)
            ("M-g k" . consult-global-mark)
            ("M-g i" . consult-imenu)
            ("M-g I" . consult-imenu-multi)
            ;; M-s bindings in `search-map'
            ("M-s d" . consult-fd)
            ("M-s g d" . my-consult-ghq-fd)
            ("M-s c" . consult-locate)
            ("M-s r" . consult-ripgrep)
            ("M-s g r" . my-consult-ghq-ripgrep)
            ("M-s l" . consult-line)
            ("M-s L" . consult-line-multi))
    :hook (completion-list-mode-hook . consult-preview-at-point-mode)
    :custom ((xref-show-xrefs-function . #'consult-xref)
             (xref-show-definitions-function . #'consult-xref))
    :config
    (leaf *consult-ghq
      :defun (buffer-substring-no-propertie my-consult-ghq--list-candidates my-consult-ghq--read consult--file-preview)
      :config
      (defun my-consult-ghq--list-candidates ()
        "ghq listの結果をリストで返す"
        (with-temp-buffer
          (unless (zerop (apply #'call-process "ghq" nil t nil '("list" "--full-path")))
	          (error "Failed: Cannot get ghq list candidates"))
          (let ((paths))
	          (goto-char (point-min))
	          (while (not (eobp))
	            (push (buffer-substring-no-properties
		                 (line-beginning-position)
		                 (line-end-position))
		                paths)
	            (forward-line 1))
	          (nreverse paths))))
      (defun my-consult-ghq--read ()
        "ghq管理のリポジトリ一覧から選ぶ"
        (consult--read (my-consult-ghq--list-candidates)
                       :state (consult--file-preview)
		                   :prompt "ghq: "
		                   :category 'file))
      (defun my-consult-ghq-fd ()
        "ghq管理のリポジトリ一覧から選び、プロジェクト内ファイル検索"
        (interactive)
        (consult-fd (my-consult-ghq--read)))
      (defun my-consult-ghq-ripgrep ()
        "ghq管理のリポジトリ一覧から選び、プロジェクト内でripgrep"
        (interactive)
        (consult-ripgrep (my-consult-ghq--read))))

    (defun my-consult-switch-buffer-kill ()
      "Kill candidate buffer at point within the minibuffer completion."
      (interactive)
      ;; The vertico--candidate has a irregular char at the end.
      (let ((name  (substring (vertico--candidate) 0 -1)))
        (when (bufferp (get-buffer name))
	        (kill-buffer name))))
    )

  (leaf embark
    :doc "Conveniently act on minibuffer completions"
    :url "https://github.com/oantolin/embark"
    :ensure t
    :bind (("C-." . embark-act)         ;; pick some comfortable binding
           ("C-;" . embark-dwim)        ;; good alternative: M-.
           ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
    :init
    (setq prefix-help-command #'embark-prefix-help-command)
    ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
    (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly))

  (leaf embark-consult
    :doc "Consult integration for Embark"
    :url "https://github.com/oantolin/embark"
    :ensure t
    :hook (embark-collect-mode-hook . consult-preview-at-point-mode))

  (leaf wgrep
    :doc "Writable grep buffer"
    :url "https://github.com/mhayashi1120/Emacs-wgrep"
    :ensure t)

  (leaf rainbow-delimiters
    :doc "Highlight brackets according to their depth"
    :url "https://github.com/Fanael/rainbow-delimiters"
    :ensure t
    :hook prog-mode-hook)

  (leaf puni
    :doc "Parentheses Universalistic"
    :url "https://github.com/AmaiKinono/puni"
    :ensure t
    :global-minor-mode puni-global-mode
    :bind (;:puni-mode-map
           ("C-)" . puni-slurp-forward)
           ("C-}" . puni-barf-forward)
           ("M-(" . puni-wrap-round)
           ("M-s" . puni-splice)
           ("M-r" . puni-raise)
           ("M-U" . puni-splice-killing-backward)
           ("M-z" . puni-squeeze)
           ("C-=" . puni-expand-region))
    :config
    (leaf elec-pair
      :doc "Automatic parenthesis pairing"
      :tag "builtin"
      :global-minor-mode electric-pair-mode)
    )

  (leaf flymake
    :doc "A universal on-the-fly syntax checker"
    :tag "builtin"
    :hook (prog-mode-hook conf-mode-hook))

  ;; (leaf flycheck
  ;;   :url "https://www.flycheck.org"
  ;;   :ensure t
  ;;   :global-minor-mode global-flycheck-mode)

  )

(leaf *lsp
  :config
  (leaf eglot
    :doc "The Emacs Client for LSP servers"
    :tag "builtin"
    :defvar eglot-server-programs
    :hook (((yaml-ts-mode-hook nix-ts-mode-hook html-ts-mode-hook css-ts-mode-map) . eglot-ensure))
    :bind (:eglot-mode-map
           ("C-c d" . eldoc-box-help-at-point)
           ("M-g e" . consult-eglot-symbols))
    :push ((eglot-server-programs . '(nix-ts-mode . ("nil"))))
    :setq-default ((eglot-workspace-configuration
                    . '(:yaml ( :format (:enable t)
                                :validate t
                                :hover t
                                :completion t
                                ;; ここに一覧がある
                                ;; https://github.com/SchemaStore/schemastore/blob/master/src/api/json/catalog.json
                                :schemas (
                                          https://json.schemastore.org/github-workflow.json ["/.github/workflows/*.{yml,yaml}"]
                                          https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json ["/cloudformation.{yml,yaml}"
                                                                                                                                          "/*.cf.{yml,yaml}"]
                                          https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json ["/docker-compose.yml"
                                                                                                                                       "/docker-compose.yaml"
                                                                                                                                       "/docker-compose.*.yml"
                                                                                                                                       "/docker-compose.*.yaml"
                                                                                                                                       "/compose.yml"
                                                                                                                                       "/compose.yaml"
                                                                                                                                       "/compose.*.yml"
                                                                                                                                       "/compose.*.yaml"]
                                          https://json.schemastore.org/yamllint.json ["/*.yml"]
                                          )
                                :schemaStore (:enable t)))))
    :config
    (leaf eglot-booster
	    :doc "No description available."
	    :url "https://github.com/jdtsmith/eglot-booster"
	    :ensure t
      :custom ((eglot-booster-io-only . t))
      :global-minor-mode t)

    (leaf consult-eglot
      :doc "A consulting-read interface for eglot"
      :url "https://github.com/mohkale/consult-eglot"
      :ensure t)

    (leaf eglot-signature-eldoc-talkative
      :doc "Make Eglot make ElDoc echo docs."
      :url "https://codeberg.org/mekeor/eglot-signature-eldoc-talkative"
      :ensure t
      :defun (eglot-signature-eldoc-function eglot-signature-eldoc-talkative)
      :commands eglot-signature-eldoc-talkative
      :config
      (advice-add #'eglot-signature-eldoc-function
                  :override #'eglot-signature-eldoc-talkative))

    (leaf eldoc-box
      :doc "Display documentation in childframe"
      :url "https://github.com/casouri/eldoc-box"
      :ensure t
      :defun (eldoc-box-prettify-ts-errors)
      :custom ((eldoc-box-clear-with-C-g . t))
      :config
      ;; TODO typescript以外のプロジェクトの時にこれ有効にしちゃダメよね
      (add-hook 'eldoc-box-buffer-setup-hook #'eldoc-box-prettify-ts-errors 0 t))
    )

  (leaf lsp-mode
    :doc "LSP mode"
    :url "https://github.com/emacs-lsp/lsp-mode"
    :ensure t
    :defvar (lsp-use-plists)
    :hook ((lsp-mode-hook . lsp-enable-which-key-integration)
           (lsp-completion-mode-hook . my/lsp-mode-setup-completion))
    :custom ((lsp-keymap-prefix . "C-c l")
             (lsp-diagnostics-provider . :flymake)
             (lsp-completion-provider . :none)
             (lsp-headerline-breadcrumb-enable . nil)
             (lsp-enable-dap-auto-configure . nil)
             (lsp-enable-folding . nil)
             (lsp-enable-indentation . nil)
             (lsp-enable-suggest-server-download . nil)
             (textDocument/documentColor . nil)
             (lsp-before-save-edits . nil)
             (lsp-lens-enable . nil) ; rustのときはtにしたい
             (lsp-modeline-code-actions-enable . nil)
             (lsp-apply-edits-after-file-operations . nil) ; https://www.reddit.com/r/emacs/comments/1b0ppls/anyone_using_lspmode_with_tsls_having_trouble/
             (lsp-disabled-clients . (tailwindcss))
             ;; eslint
             (lsp-eslint-server-command . '("vscode-eslint-language-server" "--stdio"))
             )
    :init
    (defun my/lsp-mode-setup-completion ()
      (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
            '(orderless)))
    :config
    (leaf lsp-tailwindcss
      :doc "A lsp-mode client for tailwindcss"
      :url "https://github.com/merrickluo/lsp-tailwindcss"
      :ensure t
      :custom ((lsp-tailwindcss-server-version . "0.14.4")
               (lsp-tailwindcss-major-modes . '(jtsx-jsx-mode jtsx-tsx-mode astro-ts-mode html-ts-mode))
               (lsp-tailwindcss-skip-config-check . t))
      :defun (lsp-workspace-root
              lsp-tailwindcss--has-config-file
              lsp-register-client
              make-lsp-client
              lsp-stdio-connection
              lsp-tailwindcss--activate-p
              lsp-tailwindcss--initialization-options)
      :config
      ;; nixで入れたtailwindcss-language-serverを適用できるオプションがないので、本体を参考に自分で定義する。
      (lsp-register-client (make-lsp-client
                            :new-connection (lsp-stdio-connection
                                             (lambda ()
                                               `("tailwindcss-language-server" "--stdio")))
                            :activation-fn #'lsp-tailwindcss--activate-p
                            :server-id 'my/tailwindcss
                            :priority -1
                            :add-on? t
                            :initialization-options #'lsp-tailwindcss--initialization-options)))

    (leaf lsp-snippet
      :doc "lsp-modeとtempelのインテグレーション"
      :vc (:url "https://github.com/svaante/lsp-snippet")
      :defun (lsp-snippet-tempel-lsp-mode-init)
      :config
      (when (featurep 'lsp-mode)
        (lsp-snippet-tempel-lsp-mode-init)))

    (leaf *emacs-lsp-booster
      :defun (lsp-booster--advice-json-parse lsp-booster--advice-final-command)
      :config
      (defun lsp-booster--advice-json-parse (old-fn &rest args)
        "Try to parse bytecode instead of json."
        (or
         (when (equal (following-char) ?#)
           (let ((bytecode (read (current-buffer))))
             (when (byte-code-function-p bytecode)
               (funcall bytecode))))
         (apply old-fn args)))
      (advice-add (if (progn (require 'json)
                             (fboundp 'json-parse-buffer))
                      'json-parse-buffer
                    'json-read)
                  :around
                  #'lsp-booster--advice-json-parse)

      (defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
        "Prepend emacs-lsp-booster command to lsp CMD."
        (let ((orig-result (funcall old-fn cmd test?)))
          (if (and (not test?)                             ;; for check lsp-server-present?
                   (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
                   lsp-use-plists
                   (not (functionp 'json-rpc-connection))  ;; native json-rpc
                   (executable-find "emacs-lsp-booster"))
              (progn
                (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
                  (setcar orig-result command-from-exec-path))
                (message "Using emacs-lsp-booster for %s!" orig-result)
                (cons "emacs-lsp-booster" orig-result))
            orig-result)))
      (advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command))
    )
  )

(leaf *major-modes
  :config
  (leaf treesit
    :doc "tree-sitter utilities"
    :tag "builtin"
    :defvar (treesit-language-source-alist)
    :mode (("\\.html\\'" . html-ts-mode)
           ("\\.s?css\\'" . css-ts-mode)
           ("\\.ya?ml\\'" . yaml-ts-mode)
           ("\\.toml\\'" . toml-ts-mode)
           ("\\.json\\'" . json-ts-mode)
           ("\\.php\\'" . php-ts-mode)
           ("\\Dockerfile\\'" . dockerfile-ts-mode)
           ("\\make\\'" . cmake-ts-mode))
    :custom (treesit-font-lock-level . 4)
    :config
    ;; astro意外nixで入れている
    (let ((treesit-language-source-alist  '((astro "https://github.com/virchau13/tree-sitter-astro"))))
      (mapc (lambda (lang)
              (unless (treesit-language-available-p lang nil)
                (treesit-install-language-grammar lang)))
            (mapcar #'car treesit-language-source-alist)))
    )


  (leaf macrostep
    :doc "マクロを展開する。leafがどう実行されるのか確認できる。"
    :ensure t)

  (leaf leaf-convert
    :doc "Convert many format to leaf format"
    :commands leaf-convert-insert-template
    :ensure t)

  (leaf leaf-tree
    :ensure t
    :custom (imenu-list-sizeleaf-tree-click-group-to-hide . t))

  (leaf aggressive-indent
    :doc "Minor mode to aggressively keep your code always indented."
    :url "https://github.com/Malabarba/aggressive-indent-mode"
    :ensure t
    :hook (emacs-lisp-mode-hook))

  (leaf elisp-mode
    :doc "Emacs Lisp mode"
    :hook ((emacs-lisp-mode-hook . my/setup-emacs-lisp-mode))
    :config

    (defun my/setup-emacs-lisp-mode ()
      "保存前に行末のスペースを削除"
      (add-hook 'before-save-hook 'delete-trailing-whitespace nil 'make-it-local))
    )

  (leaf jtsx
    :doc "Extends JSX/TSX built-in support"
    :url "https://github.com/llemaitre19/jtsx"
    :ensure t
    :defvar (jtsx-jsx-mode-map jtsx-tsx-mode-map)
    :defun (my-jtsx-bind-keys-to-mode-map)
    :mode (("\\.jsx?\\'" . jtsx-jsx-mode)
           ("\\.tsx\\'" . jtsx-tsx-mode)
           ("\\.ts\\'" . jtsx-typescript-mode))
    :hook ((jtsx-jsx-mode-hook . my-jtsx-bind-keys-to-jtsx-jsx-mode-map)
           (jtsx-tsx-mode-hook . my-jtsx-bind-keys-to-jtsx-tsx-mode-map))
    :custom ((js-indent-level . 2)
             (typescript-ts-mode-indent-offset . 2)
             (jtsx-switch-indent-offset . 0)
             (jtsx-indent-statement-block-regarding-standalone-parent . nil)
             (jtsx-jsx-element-move-allow-step-out . t)
             (jtsx-enable-jsx-electric-closing-element . t)
             (jtsx-enable-electric-open-newline-between-jsx-element-tags . t)
             ;; (jtsx-enable-jsx-element-tags-auto-sync . nil)
             (jtsx-enable-all-syntax-highlighting-features . t))
    :config
    (defun my-jtsx-bind-keys-to-mode-map (mode-map)
      "Bind keys to MODE-MAP."
      (define-key mode-map (kbd "C-c C-j") 'jtsx-jump-jsx-element-tag-dwim)
      (define-key mode-map (kbd "C-c j o") 'jtsx-jump-jsx-opening-tag)
      (define-key mode-map (kbd "C-c j c") 'jtsx-jump-jsx-closing-tag)
      (define-key mode-map (kbd "C-c j r") 'jtsx-rename-jsx-element)
      (define-key mode-map (kbd "C-c <down>") 'jtsx-move-jsx-element-tag-forward)
      (define-key mode-map (kbd "C-c <up>") 'jtsx-move-jsx-element-tag-backward)
      (define-key mode-map (kbd "C-c C-<down>") 'jtsx-move-jsx-element-forward)
      (define-key mode-map (kbd "C-c C-<up>") 'jtsx-move-jsx-element-backward)
      (define-key mode-map (kbd "C-c C-S-<down>") 'jtsx-move-jsx-element-step-in-forward)
      (define-key mode-map (kbd "C-c C-S-<up>") 'jtsx-move-jsx-element-step-in-backward)
      (define-key mode-map (kbd "C-c j w") 'jtsx-wrap-in-jsx-element)
      (define-key mode-map (kbd "C-c j u") 'jtsx-unwrap-jsx)
      (define-key mode-map (kbd "C-c j d n") 'jtsx-delete-jsx-node)
      (define-key mode-map (kbd "C-c j d a") 'jtsx-delete-jsx-attribute)
      (define-key mode-map (kbd "C-c j t") 'jtsx-toggle-jsx-attributes-orientation)
      (define-key mode-map (kbd "C-c j h") 'jtsx-rearrange-jsx-attributes-horizontally)
      (define-key mode-map (kbd "C-c j v") 'jtsx-rearrange-jsx-attributes-vertically))

    (defun my-jtsx-bind-keys-to-jtsx-jsx-mode-map ()
      (my-jtsx-bind-keys-to-mode-map jtsx-jsx-mode-map))

    (defun my-jtsx-bind-keys-to-jtsx-tsx-mode-map ()
      (my-jtsx-bind-keys-to-mode-map jtsx-tsx-mode-map))
    )

  (leaf css-mode
	  :doc "Major mode to edit CSS files"
	  :custom ((css-indent-offset . 2)))

  (leaf astro-ts-mode
    :doc "No description available."
    :url "https://github.com/Sorixelle/astro-ts-mode"
    :ensure t
    :mode "\\.astro\\'")

  (leaf nix-ts-mode
	  :doc "Major mode for Nix expressions, powered by tree-sitter"
	  :url "https://github.com/nix-community/nix-ts-mode"
	  :ensure t
    :mode ("\\.nix\\'"))

  )





(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
