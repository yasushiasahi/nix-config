;;; early-init.el --- My early-init.el  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:


;;; 各種ツールの無効化。early-init.elでやるべき事の代表格１
(menu-bar-mode -1)			; メニューバーを表示しない
(tool-bar-mode -1)			; ツールバーを表示しない
(scroll-bar-mode -1)			; スクロールバーを表示しない

;;; default-frame（新規フレームの指定）。early-init.elでやるべき事の代表格２
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))  ; titlebar透過
(add-to-list 'default-frame-alist '(ns-appearance . dark))				 ; titlebarダークモード
(add-to-list 'default-frame-alist '(width . (text-pixels . 960)))	 ; フレームの横幅
(add-to-list 'default-frame-alist '(height . (text-pixels . 960))) ; フレームの縦幅
(add-to-list 'default-frame-alist '(font . "HackGen35-13"))				 ; フォント(フォント名-フォントサイズ)

;; solarized-themeを読み込むまで画面が白いのがカッコ悪いのであらかじめsolarized色を変える
;; 設定しなくてもちらつかなくなった。ちょっと様子見。
;; (add-to-list 'default-frame-alist '(background-color . "#002b3a")) ; 背景色

;;; .eln（ネイティブコンパイルのキャッシュ）を隅に追いやる。no-litteringのおすすめ設定そのまま
;;; https://github.com/emacscollective/no-littering?tab=readme-ov-file#native-compilation-cache
(when (and (fboundp 'startup-redirect-eln-cache)
           (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  (startup-redirect-eln-cache
   (convert-standard-filename
    (expand-file-name  "var/eln-cache/" user-emacs-directory))))

;;; lsp-modeの最適化設定
;;; https://emacs-lsp.github.io/lsp-mode/page/performance/#use-plists-for-deserialization
(setenv "LSP_USE_PLISTS" "true")


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



(provide 'early-init)

;;; early-init.el ends here
