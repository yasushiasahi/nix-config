{
  pkgs,
  mkAlias,
  ...
}:
let
  emacs-mac = pkgs.emacs.overrideAttrs (old: {
    configureFlags = (old.configureFlags or [ ]) ++ [ "--with-xwidgets" ];
    patches = (old.patches or [ ]) ++ [ ./emacs-29.1-inline.patch ];
  });

  eglot-booster =
    { melpaBuild }:
    melpaBuild {
      pname = "eglot-booster";
      version = "0-unstable-2024-10-29";
      src = pkgs.fetchFromGitHub {
        owner = "jdtsmith";
        repo = "eglot-booster";
        rev = "e6daa6bcaf4aceee29c8a5a949b43eb1b89900ed";
        hash = "sha256-PLfaXELkdX5NZcSmR1s/kgmU16ODF8bn56nfTh9g6bs=";
      };
    };

  consult-omni =
    { melpaBuild }:
    melpaBuild {
      pname = "consult-omni";
      version = "0-unstable-2025-02-19";
      files = ''("*.el" "sources/*.el")'';
      src = pkgs.fetchFromGitHub {
        owner = "armindarvish";
        repo = "consult-omni";
        rev = "d0a24058bf0dda823e5f1efcae5da7dc0efe6bda";
        hash = "sha256-dzKkJ+3lMRkHRuwe43wpzqnFvF8Tl6j+6XHUsDhMX4o=";
      };
    };

  org-modern-indent =
    { melpaBuild }:
    melpaBuild {
      pname = "org-modern-indent";
      version = "0-unstable-2025-04-13";
      src = pkgs.fetchFromGitHub {
        owner = "jdtsmith";
        repo = "org-modern-indent";
        rev = "9973bd3b91e4733a3edd1fca232208c837c05473";
        hash = "sha256-st3338Jk9kZ5BLEPRJZhjqdncMpLoWNwp60ZwKEObyU=";
      };
    };

  lsp-proxy =
    let
      version = "0.4.3";
      src = pkgs.fetchFromGitHub {
        owner = "jadestrong";
        repo = "lsp-proxy";
        rev = "v${version}";
        hash = "sha256-kPTVWvd/c0Z49h82hDpgE5siXq7ERmPZyheV7hQpr5o=";
      };
      cli = pkgs.rustPlatform.buildRustPackage {
        pname = "lsp-proxy";
        version = version;
        src = src;
        cargoHash = "sha256-9yHCvYTYtLLpAzE5QHomvnYRFZDY0NoyQGL+PaJ7Izw=";
      };
    in
    { melpaBuild }:
    melpaBuild {
      pname = "lsp-proxy";
      version = version;
      nativeBuildInputs = [ cli ];
      src = src;
      # lsp-proxy.elと同じディレクトリにビルドした実行ファイルをおかないといけない
      postInstall = ''
        ls $out/share/emacs/site-lisp/elpa/lsp-proxy-${version}
        cp ${cli}/bin/lsp-proxy $out/share/emacs/site-lisp/elpa/lsp-proxy-${version}/lsp-proxy
      '';

    };

  emacs-mac-with-epkgs = pkgs.emacsWithPackagesFromUsePackage {
    package = emacs-mac;
    config = ./init.org;
    override =
      epkgs:
      epkgs
      // {
        eglot-booster = pkgs.callPackage eglot-booster {
          inherit (epkgs) melpaBuild;
        };
        consult-omni = pkgs.callPackage consult-omni {
          inherit (epkgs) melpaBuild;
        };
        org-modern-indent = pkgs.callPackage org-modern-indent {
          inherit (epkgs) melpaBuild;
        };
        lsp-proxy = pkgs.callPackage lsp-proxy {
          inherit (epkgs) melpaBuild;
        };

        # lsp-modeのplists解析を有効にする。そのままだと、hash-tableになる。
        # https://emacs-lsp.github.io/lsp-mode/page/performance/#use-plists-for-deserialization
        lsp-mode = epkgs.lsp-mode.overrideAttrs (
          _: p: {
            buildPhase =
              ''
                export LSP_USE_PLISTS=true
              ''
              + p.buildPhase;
          }
        );
      };

    extraEmacsPackages = epkgs: [
      epkgs.treesit-grammars.with-all-grammars
      # TODO astroのgrammarsも入れたいけど、grammarsのbuild方法がわからない。
    ];
  };

  tangle = pkgs.tangleOrgBabel { languages = [ "emacs-lisp" ]; };

  shellAlias = mkAlias {
    emacs = "${emacs-mac-with-epkgs}/Applications/Emacs.app/Contents/MacOS/Emacs";
  };

in
{
  programs = {
    emacs = {
      enable = true;
      package = emacs-mac-with-epkgs;
    };
  } // shellAlias;

  home.packages = [
    pkgs.emacs-lsp-booster

    # gnuのlsを入れないと以下の警告が出る
    # ls does not support --dired; see ‘dired-use-ls-dired’ for more details.
    pkgs.coreutils

    # org-web-toolsで使う。orgからmarkdownに変換する。
    # TODO: もしかするとpakagesに同梱されてるかも。調べる。
    pkgs.pandoc

    # lsp
    pkgs.typescript
    pkgs.typescript-language-server
    pkgs.astro-language-server
    pkgs.yaml-language-server
    pkgs.tailwindcss-language-server
    pkgs.dockerfile-language-server-nodejs
    pkgs.vscode-langservers-extracted # html css json
    pkgs.nil # nix
    pkgs.copilot-language-server
    pkgs.vale-ls # markdown
    pkgs.taplo # toml

    #formatter & linter
    pkgs.nodePackages.prettier
    pkgs.nixfmt-rfc-style
    pkgs.eslint

  ];

  # cliからemacsを起動した時にLANGがないと警告が出る。
  # https://apribase.net/2024/07/26/emacs-language-environment-mac/#langen_jputf-8-cannot-be-used-using-en_usutf-8-instead
  home.sessionVariables.LANG = "en_US.UTF-8";

  xdg.configFile = {
    "emacs/init.el".text = tangle (builtins.readFile ./init.org);
    "emacs/early-init.el".text = tangle (builtins.readFile ./early-init.org);
    "emacs/etc/transient/values.el".source = ./etc/transient/values.el;
    "emacs/etc/languages.toml".source = ./etc/languages.toml;
  };

  # TODO emacs demon? client? service
  # 設定するべきなのか？するとして何を設定するべきなのか不明。
  # https://apribase.net/2024/06/21/emacs-as-daemon-for-mac/ Mac に正しくフレーム管理される Emacs as Daemon を起動する
  # https://github.com/takeokunn/nixos-configuration/blob/main/home-manager/services/emacs/default.nix takeokunn/nixos-configuration
}
