{ pkgs, mkAlias, ... }:
let
  shellAlias = mkAlias {
    emacs = "${pkgs.emacs}/Applications/Emacs.app/Contents/MacOS/Emacs";
  };

  emacs-mac = pkgs.emacs.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./emacs-29.1-inline.patch ];
    # LANG=en_JP.UTF-8 cannot be used, using en_US.UTF-8 instead.を抑制する。問題ないらしいけど。
    env = (old.env or { }) // {
      LANG = "en_US.UTF-8";
    };
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
in
{
  programs = {
    emacs = {
      enable = true;
      package = emacs-mac-with-epkgs;
    };

    git.ignores = [ ".dir-locals.el" ];
  } // shellAlias;

  home.packages = [
    pkgs.emacs-lsp-booster

    # lsp
    pkgs.nodePackages.typescript
    pkgs.nodePackages.typescript-language-server
    pkgs.astro-language-server
    pkgs.yaml-language-server
    pkgs.tailwindcss-language-server
    pkgs.dockerfile-language-server-nodejs
    pkgs.vscode-langservers-extracted
    pkgs.nil
  ];

  # cliからemacsを起動した時にLANGがないと警告が出る。
  # https://apribase.net/2024/07/26/emacs-language-environment-mac/#langen_jputf-8-cannot-be-used-using-en_usutf-8-instead
  home.sessionVariables.LANG = "en_US.UTF-8";

  xdg.configFile = {
    "emacs/init.el".text = tangle (builtins.readFile ./init.org);
    "emacs/early-init.el".source = ./early-init.el;
    "emacs/etc/templates".source = ./etc/templates;
    "emacs/etc/transient/values.el".source = ./etc/transient/values.el;
  };

  # TODO emacs demon? client? service
  # 設定するべきなのか？するとして何を設定するべきなのか不明。
  # https://apribase.net/2024/06/21/emacs-as-daemon-for-mac/ Mac に正しくフレーム管理される Emacs as Daemon を起動する
  # https://github.com/takeokunn/nixos-configuration/blob/main/home-manager/services/emacs/default.nix takeokunn/nixos-configuration
}
