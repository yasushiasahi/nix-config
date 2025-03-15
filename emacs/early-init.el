;;; early-init.el --- My early-init.el  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; タイトルバーの設定
(push '(ns-transparent-titlebar . t) default-frame-alist) ; 透過
(push '(ns-appearance . dark) default-frame-alist)        ; ダークモード
(setq ns-use-proxy-icon nil)                              ; アイコンを表示しない
(setq frame-title-format nil)                             ; 文字を表示しない

;; フレームサイズ
(push '(width . (text-pixels . 960)) default-frame-alist)
(push '(height . (text-pixels . 960)) default-frame-alist)

;;; solarized-themeを見込むまで画面が白いのがカッコ悪いのでいきなりsolarized色を変える
(push '(background-color . "#002b3a") default-frame-alist)
(set-face-attribute 'mode-line t
		    :foreground "#002b3a"
		    :background "#002b3a"
		    :underline "#002b3a"
		    :overline "#002b3a")

(menu-bar-mode -1)			; メニューバーを表示しない
(tool-bar-mode -1)			; ツールバーを表示しない
(scroll-bar-mode -1)			; スクロールバーを表示しない


(custom-set-variables
 '(use-file-dialog nil)                   ; ファイル選択ウィンドウを使用しない
 '(inhibit-x-resources t)                 ; Xリソースを使用しない
 '(inhibit-startup-buffer-menu t)         ; バッファメニューの使用を抑制
 '(inhibit-startup-echo-area-message t)	  ; 起動時にエコーエリアに挨拶文を表示しない
 '(inhibit-startup-screen t)		  ; 起動時のデフォルト画面を表示しない
 '(initial-scratch-message nil)		  ; *scratch*バッファのデフォルト文章を表示しない
 '(scroll-preserve-screen-position t)	  ; 画面がスクロールする時にカーソルを画面上の位置で固定する
 '(scroll-conservatively 1)		  ; 1行ずつスクロールする
					; '(create-lockfiles nil)		  ; 編集中のファイルのロックファイル(.#~~)を作らない
 '(delete-old-versions t)		  ; 古いバックアップファイルを確認なしで消す
 '(truncate-lines t)			  ; 行を折り返さない
 '(x-underline-at-descent-line t)	  ; アンダーラインの位置をいい感じにする。solarized-emacsで推奨されている https://github.com/bbatsov/solarized-emacs#underline-position-setting-for-x
 '(native-comp-async-report-warnings-errors 'silent) ; ネイティブコンパイルのwarningsをbufferに記録するがポップアップはさせない。
 '(gc-cons-threshold 100000000)			     ; ガベージコレクションが発火するメモリの閾値 https://emacs-lsp.github.io/lsp-mode/page/performance/#adjust-gc-cons-threshold
 '(read-process-output-max (* 1024 1024))	     ; https://emacs-lsp.github.io/lsp-mode/page/performance/#increase-the-amount-of-data-which-emacs-reads-from-the-process
 '(frame-title-format "")                      ; titlebarを""にする（何も表示しない）
 '(ring-bell-function 'ignore)                 ; 警告音（ピープ音）をならさい
					; '(make-backup-files nil)                      ; オープン時(編集前)のファイルをバックアップを作成しない
 )


;; no-littering配下にネイティブコンパイルのキャッシュを配置する
;; https://github.com/emacscollective/no-littering?tab=readme-ov-file#native-compilation-cache
(when (and (fboundp 'startup-redirect-eln-cache)
           (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  (startup-redirect-eln-cache
   (convert-standard-filename
    (expand-file-name  "var/eln-cache/" user-emacs-directory))))

;; https://emacs-lsp.github.io/lsp-mode/page/performance/#use-plists-for-deserialization
(setenv "LSP_USE_PLISTS" "true")

(provide 'early-init)

;;; early-init.el ends here
