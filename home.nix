{
  config,
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "asahi";
  home.homeDirectory = "/Users/asahi";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.

    #nix
    pkgs.nil
    pkgs.nixfmt-rfc-style

    #emacs
    pkgs.emacs-lsp-booster

    # general
    pkgs.ghq
    pkgs.darwin.trash
    pkgs.colima
    pkgs.docker
    pkgs.docker-compose
    pkgs.docker-buildx

    # node
    pkgs.nodejs_22
    pkgs.yarn
    pkgs.pnpm
    pkgs.nodePackages.prettier
    pkgs.nodePackages.npm-check-updates
    pkgs.nodePackages.typescript
    pkgs.nodePackages.typescript-language-server
    pkgs.astro-language-server
    pkgs.yaml-language-server
    pkgs.tailwindcss-language-server
    pkgs.dockerfile-language-server-nodejs
    pkgs.vscode-langservers-extracted

    # aws
    pkgs.git-remote-codecommit

    # (pkgs.brewCasks.karabiner-elements.overrideAttrs (o: {
    #   nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.gnutar ];
    #   unpackPhase = "tar -xvzf $src";
    # }))

    # (pkgs.brewCasks.chromium.overrideAttrs (oldAttrs: {
    #   src = pkgs.fetchurl {
    #     url = builtins.head oldAttrs.src.urls;
    #     hash = "sha256-zZHAB7TozshPfoVRfAllYFl4kXrXAok2KqHPa3gSu/c=";
    #   };
    # }))

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/asahi/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.emacs = {
    enable = true;
    # package = pkgs.emacs.overrideAttrs (old: {
    #   patches = (old.patches or [ ]) ++ [
    #     (pkgs.fetchpatch {
    #       url = "https://raw.githubusercontent.com/takaxp/ns-inline-patch/master/emacs-29.1-inline.patch";
    #       sha256 = "sha256-UQsYJ9+6XgB7NSCmup4RzDn3NlR8vMKsQGJPYYqsgmU=";
    #     })
    #   ];
    # });
  };

  programs.awscli.enable = true;
  programs.jq.enable = true;
  programs.fd.enable = true;
  programs.bat.enable = true;
  programs.ripgrep.enable = true;
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    fileWidgetCommand = "fd --type f";
    changeDirWidgetCommand = "fd --type d";
    # changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };
  # https://github.com/junegunn/fzf/wiki/Color-schemes#solarized-dark
  home.sessionVariables.FZF_DEFAULT_OPTS = ''
    --color dark,hl:33,hl+:37,fg+:235,bg+:136,fg+:254
    --color info:254,prompt:37,spinner:108,pointer:235,marker:235
  '';

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    mouse = true;
    baseIndex = 1;
    prefix = "C-t";
    terminal = "screen-256color";
    # plugins = [ ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      emacs = "${pkgs.emacs}/Applications/Emacs.app/Contents/MacOS/Emacs";
      rm = "trash";
    };
    autocd = true;
    autosuggestion.enable = true;
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    # envExtra = ".zshenvに加えたい何か加えたい時に書く"
    history = {
      # expireDuplicatesFirst = true;
      # extended = true;
      # findNoDups = true;
      # ignoreAllDups = true;
      path = ".config/zsh/.zsh_history";
      save = 10000;
      # saveNoDups = true;
      share = true;
      size = 10000;
    };
    historySubstringSearch.enable = true;
    # 本当ならprofileExtraに書くものだけど、
    # login時意外にbrewは使わないはず。
    # exec-shell-from-pathを早くするため。
    initExtraFirst = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
    initExtraBeforeCompInit = ''
      autoload bashcompinit && bashcompinit
    '';
    initExtra = ''
      complete -C '${pkgs.awscli2}/bin/aws_completer' aws
    '';
    # loginExtra = .zlogin
    plugins = [
      {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "24.09.04";
          sha256 = "sha256-o8IQszQ4/PLX1FlUvJpowR2Tev59N8lI20VymZ+Hp4w=";
        };
      }
      {
        name = "zsh-npm-scripts-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "grigorii-zander";
          repo = "zsh-npm-scripts-autocomplete";
          rev = "5d145e13150acf5dbb01dac6e57e57c357a47a4b";
          sha256 = "sha256-Y34VXOU7b5z+R2SssCmbooVwrlmSxUxkObTV0YtsS50=";
        };
      }
    ];
    # profileExtra = .zprofile
    # sessionVariables  = [ HOGE = 'fuga' ]
    syntaxHighlighting.enable = true;
    zsh-abbr = {
      enable = true;
      abbreviations = {
        ll = "eza -alh --icons always --color always --git";
        lt = "eza --tree --sort=type --reverse --git-ignore";
        di = "nix flake init -t github:nix-community/nix-direnv ";
        ds = "darwin-rebuild switch --flake .#darwin";
        hs = "home-manager switch --flake .#home";
      };
    };
  };
  # environment.pathsToLink = [ "/share/zsh" ];

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      ".dir-locals.el"
    ];
    userEmail = "asahi1600@gmail.com";
    userName = "yasushiasahi";
    # extraConfig =
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "Transparent";
        padding = {
          x = 8;
          y = 6;
        };
      };
      scrolling.history = 100000;
      font = {
        normal.family = "Cica";
        size = 14;
      };
      cursor.style = {
        shape = "Beam";
        blinking = "On";
      };
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
        # args = [
        #   "-l"
        #   "-c"
        #   "/opt/homebrew/bin/tmux a -t scratch || /opt/homebrew/bin/tmux new -s scratch"
        # ];
      };
      colors = {
        primary = {
          background = "#002b36";
          foreground = "#839496";
        };
        normal = {
          black = "#073642";
          red = "#dc322f";
          green = "#859900";
          yellow = "#b58900";
          blue = "#268bd2";
          magenta = "#d33682";
          cyan = "#2aa198";
          white = "#eee8d5";
        };
        bright = {
          black = "#002b36";
          red = "#cb4b16";
          green = "#586e75";
          yellow = "#657b83";
          blue = "#839496";
          magenta = "#6c71c4";
          cyan = "#93a1a1";
          white = "#fdf6e3";
        };
      };
    };
  };

  xdg = {
    enable = true;
    configFile = {
      eza = {
        source = ./eza;
        recursive = true;
      };
    };

  };

}
