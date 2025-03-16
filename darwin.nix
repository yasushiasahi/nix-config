{ pkgs, self, ... }:
{
  environment = {
    shells = [
      pkgs.zsh
      pkgs.fish
    ];
  };

  fonts.packages = [
    # notoを一通り
    pkgs.noto-fonts
    pkgs.noto-fonts-lgc-plus
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
    pkgs.noto-fonts-color-emoji
    pkgs.noto-fonts-emoji-blob-bin
    pkgs.noto-fonts-monochrome-emoji
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
    casks = [
      "1password"
      "arc"
      "datagrip"
      "google-chrome"
      "karabiner-elements"
      "logi-options+"
      "raycast"
      "tailscale"

      # nixpkgsに無い
      "font-cica"
    ];
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # environment.systemPackages = [
  #   pkgs.vim
  # ];

  nix = {
    optimise.automatic = true;
    settings = {
      # Necessary for using flakes on this system.
      experimental-features = "nix-command flakes";
      max-jobs = 8;
    };
  };

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  system.defaults = {
    NSGlobalDomain = {
      _HIHideMenuBar = true;
      InitialKeyRepeat = 11;
      KeyRepeat = 1;
      "com.apple.trackpad.forceClick" = false;
    };
    dock = {
      autohide = true;
      tilesize = 16;
      static-only = true;
      show-process-indicators = false;
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
    };
    finder = {
      ShowPathbar = true;
      ShowStatusBar = true;
      NewWindowTarget = "Home";
      FXPreferredViewStyle = "Nlsv";
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXDefaultSearchScope = "SCcf";
    };
    trackpad = {
      Clicking = true;
      Dragging = true;
    };
    controlcenter = {
      BatteryShowPercentage = true;
      Sound = true;
      Display = true;
    };
    CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # Disable 'Cmd + Space' for Spotlight Search
          "64" = {
            enabled = false;
          };
          # Disable 'Cmd + Alt + Space' for Finder search window
          "65" = {
            enabled = false;
          };
        };
      };
    };
    WindowManager.EnableStandardClickToShowDesktop = false;
  };

  security = {
    pam.services.sudo_local = {
      touchIdAuth = true;
      reattach = true;
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

}
