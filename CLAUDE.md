# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 概要

これは個人のmacOSセットアップ用のNix設定リポジトリです。Nixを使用してmacOSの開発環境を宣言的に管理します。

## 主要なコマンド

### Home Manager更新
```bash
# 設定を適用
nix run home-manager/master -- switch --flake .#home

# ドライラン（実際には適用しない）
nix run home-manager/master -- build --flake .#home
```

### nix-darwin更新
```bash
# 設定を適用
nix run nix-darwin/master#darwin-rebuild -- switch --flake .#darwin

# ドライラン
nix run nix-darwin/master#darwin-rebuild -- build --flake .#darwin
```

### 依存関係の更新
```bash
# nvfetcherで_sources/配下のパッケージを更新
nvfetcher build

# flakeの入力を更新
nix flake update
```

## アーキテクチャ

### ディレクトリ構造

- `/flake.nix` - Flakeのエントリーポイント。nixpkgs、home-manager、nix-darwin等の入力を定義
- `/home-manager/` - Home Manager設定のルートディレクトリ
  - `default.nix` - Home Managerのメインエントリーポイント。全モジュールを統合
  - 各サブディレクトリ - 個別のツール/アプリケーション設定（emacs、git、tmux等）
- `/nix-darwin/` - macOSシステムレベル設定（フォント、Homebrew、システム設定）
- `/_sources/` - nvfetcherで管理される外部パッケージ
- `/nvfetcher.toml` - 外部リポジトリからフェッチするパッケージの定義

### 設計思想

1. **モジュール化**: 各ツールの設定は独立したディレクトリに分離
2. **宣言的設定**: 全ての設定をNixで宣言的に管理
3. **再利用性**: `mkAlias`、`mkAbbr`等のヘルパー関数でshell間の設定を共通化
4. **外部パッケージ管理**: nvfetcherで最新のemacsパッケージやfishプラグイン等を管理

### 主要な設定パターン

#### Home Managerモジュール
各ツールの設定は以下のパターンに従う：
```nix
{ pkgs, config, mkAlias, mkAbbr, ... }:
{
  programs.toolname = {
    enable = true;
    # 設定内容
  };
  
  # 必要に応じてdotfileをリンク
  xdg.configFile."toolname/config".source = ./config;
}
```

#### パッケージのインストール
- Nixパッケージ: `home.packages`または各programモジュール内で指定
- Homebrewアプリ: `/nix-darwin/default.nix`の`homebrew.casks`で管理
- Mac App Store: `homebrew.masApps`で管理

## 特記事項

- このリポジトリはmacOS専用（aarch64-darwin）
- 日本語環境向けの設定が含まれている（フォント、IME設定等）
- Emacsの設定は`org-babel`を使用してorg-modeからtangleして生成
- nvfetcherで管理されるパッケージは`_sources/generated.nix`経由で利用可能