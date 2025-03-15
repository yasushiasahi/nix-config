{ pkgs, system, ... }:
{
  # environment.shells = [ pkgs.zsh ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-lgc-plus
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    noto-fonts-emoji-blob-bin
    noto-fonts-monochrome-emoji
    hackgen-font
    hackgen-nf-font
    nerd-fonts.fira-code
    emacs-all-the-icons-fonts
    font-awesome
    font-awesome_5
  ];

  homebrew = {
    enable = true;
    # onActivation = {
    #   autoUpdate = true;
    #   upgrade = true;
    #   cleanup = "uninstall";
    # };
    # taps = [ ];
    # brews = [ ];
    casks = [
      "1password"
      # "alacritty"
      # "arc"
      # "datagrip"
      # "font-cica"
      # "google-chrome"
      # "karabiner-elements"
      # "logi-options+"
      # "raycast"
      # "zed"
      # "sequel-ace"
    ];
    # masApps = {
    #   LINE = 539883307;
    #   Yoink = 457622435;
    # };
  };

  nix = {
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = 8;
    };
    extraOptions = ''
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;

  system = {
    stateVersion = 6;
    defaults = {
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
      LaunchServices.LSQuarantine = false;
      NSGlobalDomain = {
        _HIHideMenuBar = true;
        AppleShowAllExtensions = true;
      };
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        _FXShowPosixPathInTitle = true;
      };
      NSGlobalDomain = {
        InitialKeyRepeat = 11;
        KeyRepeat = 1;
      };
      dock = {
        autohide = true;
        show-recents = false;
        launchanim = false;
        orientation = "bottom";
      };
      trackpad = {
        Clicking = true;
        Dragging = true;
      };
    };

    # activationScripts.extraActivation.text = ''
    #   softwareupdate --all --install
    # '';
  };
}
