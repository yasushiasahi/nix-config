{ pkgs, mkAlias, ... }:
let
  emacs-mac = pkgs.emacs.overrideAttrs (old: {
    configureFlags = (old.configureFlags or [ ]) ++ [ "--with-xwidgets" ];
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.darwin.apple_sdk.frameworks.WebKit ];
    patches = (old.patches or [ ]) ++ [ ./emacs-29.1-inline.patch ];
  });

  eglot-booster =
    {
      melpaBuild,
      fetchFromGitHub,
    }:
    melpaBuild {
      pname = "eglot-booster";
      version = "0-unstable-2024-10-29";
      src = fetchFromGitHub {
        owner = "jdtsmith";
        repo = "eglot-booster";
        rev = "e6daa6bcaf4aceee29c8a5a949b43eb1b89900ed";
        hash = "sha256-PLfaXELkdX5NZcSmR1s/kgmU16ODF8bn56nfTh9g6bs=";
      };
    };

  lsp-proxy-version = "0.4.2";
  lsp-proxy-src = pkgs.fetchFromGitHub {
    owner = "jadestrong";
    repo = "lsp-proxy";
    rev = "v${lsp-proxy-version}";
    hash = "sha256-f/UVutoPlYZSioOV0OHTzQMBMf7Llqd9/FWhmZednns=";
  };
  lsp-proxy-cli = pkgs.rustPlatform.buildRustPackage {
    pname = "lsp-proxy";
    version = lsp-proxy-version;
    src = lsp-proxy-src;
    cargoHash = "sha256-9yHCvYTYtLLpAzE5QHomvnYRFZDY0NoyQGL+PaJ7Izw=";
  };
  lsp-proxy-pkg =
    { melpaBuild }:
    melpaBuild {
      pname = "lsp-proxy";
      version = lsp-proxy-version;
      nativeBuildInputs = [ lsp-proxy-cli ];
      src = lsp-proxy-src;
      # lsp-proxy.elと同じディレクトリにビルドした実行ファイルをおかないといけない
      postInstall = ''
        ls $out/share/emacs/site-lisp/elpa/lsp-proxy-${lsp-proxy-version}
        cp ${lsp-proxy-cli}/bin/lsp-proxy $out/share/emacs/site-lisp/elpa/lsp-proxy-${lsp-proxy-version}/lsp-proxy
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
          inherit (pkgs) fetchFromGitHub;
          inherit (epkgs) melpaBuild;
        };
        lsp-proxy = pkgs.callPackage lsp-proxy-pkg {
          inherit (epkgs) melpaBuild;
        };
        # lsp-modeのplists解析を有効にする。そのままだと、hash-tableになる。
        # https://emacs-lsp.github.io/lsp-mode/page/performance/#use-plists-for-deserialization
        lsp-mode = epkgs.lsp-mode.overrideAttrs (
          f: p: {
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

    # lsp
    pkgs.nodePackages.typescript
    pkgs.nodePackages.typescript-language-server
    pkgs.astro-language-server
    pkgs.yaml-language-server
    pkgs.tailwindcss-language-server
    pkgs.dockerfile-language-server-nodejs
    pkgs.vscode-langservers-extracted
    pkgs.nil
    pkgs.copilot-language-server

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
    "emacs/etc/templates".source = ./etc/templates;
    "emacs/etc/transient/values.el".source = ./etc/transient/values.el;
    "emacs/etc/languages.toml".source = ./etc/languages.toml;
  };

  # TODO emacs demon? client? service
  # 設定するべきなのか？するとして何を設定するべきなのか不明。
  # https://apribase.net/2024/06/21/emacs-as-daemon-for-mac/ Mac に正しくフレーム管理される Emacs as Daemon を起動する
  # https://github.com/takeokunn/nixos-configuration/blob/main/home-manager/services/emacs/default.nix takeokunn/nixos-configuration
}
