{ pkgs, self, ... }:
{
  environment = {
    shells = [
      pkgs.zsh
      pkgs.fish
    ];
  };

  # fishにnix関連のpathを通す
  programs.fish.enable = true;

  fonts.packages = [
    # 日本語対応プログラミングフォント
    pkgs.maple-mono.NF-CN-unhinted

    # nerdfontを入れたい nerd-icons.elでお勧めされているもの
    # https://github.com/rainstormstudio/nerd-icons.el?tab=readme-ov-file#installing-fonts
    pkgs.nerd-fonts.symbols-only
    pkgs.emacs-all-the-icons-fonts
    pkgs.font-awesome
    pkgs.font-awesome_5
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    brews = [
      # プロジェクトで一時的に必要
      { name = "unixodbc"; }
    ];
    casks = [
      # システム系
      "logi-options+"
      "1password"
      "cleanmymac"
      # ブラウザ
      "arc"
      "brave-browser"
      "google-chrome"
      # ターミナル
      "alacritty"
      "ghostty"
      # エディタ
      "visual-studio-code"
      "coteditor"
      # ターミナル
      "postman"
    ];
    masApps = {
      LINE = 539883307;
      amazon-kindle = 302584613;
      tailscale = 1475387142;
      yoink = 457622435;
      Xcode = 497799835;
    };
  };

  nix = {
    optimise.automatic = true;
    settings = {
      # これを設定しないとflakeが使えない
      experimental-features = "nix-command flakes";
      max-jobs = 8;
    };
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  system.primaryUser = "asahi";

  system.defaults = {
    NSGlobalDomain = {
      # メニューバーオートはいど
      _HIHideMenuBar = true;
      # キーを押してから長押しと判断するまでの閾値
      InitialKeyRepeat = 11;
      # キー長押し時の速さ（最小に）
      KeyRepeat = 1;
      # トラックパッドのフォースクリック無効化
      "com.apple.trackpad.forceClick" = false;
    };
    dock = {
      # 自動非表示
      autohide = true;
      # アプリアイコンのサイズ
      tilesize = 16;
      # 起動中のアプリのみを表示
      static-only = true;
      # 最近開いたアプリ非表示
      show-recents = false;
      # 起動中アプリアイコンの下の白い点非表示
      show-process-indicators = false;
      # ホットコーナー無効化
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
    };
    finder = {
      # ウィンドウ下部のパスバー表示
      ShowPathbar = true;
      # ウィンドウ下部のステータス(アイテム数、ディスクサイズとか)表示
      ShowStatusBar = true;
      # 新しくfinderを開いた時に表示するフォルダをホームディレクトリにする
      NewWindowTarget = "Home";
      # リスト表示をデフォルトに
      FXPreferredViewStyle = "Nlsv";
      # 全てのファイル拡張子表示
      AppleShowAllExtensions = true;
      # 隠しファイル(.*)を表示
      AppleShowAllFiles = true;
      # 検索対象のフォルダを今開いているフォルダ配下にする
      FXDefaultSearchScope = "SCcf";
    };
    trackpad = {
      # タップでクリック
      Clicking = true;
      # Tap To Drag(ダブルタップでドラッグ)
      Dragging = true;
    };
    controlcenter = {
      # メニューバーにバッテリー残量の%を表示する
      BatteryShowPercentage = true;
      # メニューバーにオーディオ設定を常に表示
      Sound = true;
      # メニューバーにブルートゥース設定を常に表示
      Bluetooth = true;
      # メニューバーに再生中のメディア情報を常に表示
      NowPlaying = true;
    };
    WindowManager = {
      # デスクトップクリックでデスクトップ表示
      EnableStandardClickToShowDesktop = false;
      # アプリを画面端にドラッグすると左右半分にスナップする
      # EnableTilingByEdgeDrag = false;
      # アプリを画面上橋にドラッグするとフススクリーンにする
      EnableTopTilingByEdgeDrag = false;
    };
  };

  security = {
    pam.services.sudo_local = {
      # sudo実行の許可をタッチIDで行う
      touchIdAuth = true;
      # 複数セッション間でsudoの実行の権限を共有する
      reattach = true;
    };
  };

  system.keyboard = {
    # キーマップ変更を有効化
    enableKeyMapping = true;
    # CapsをCtrlに変更
    remapCapsLockToControl = true;
  };

}
