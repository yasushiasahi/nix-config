{ pkgs, mkAlias, ... }:
let
  shellAlias = mkAlias {
    emacs = "${pkgs.emacs}/Applications/Emacs.app/Contents/MacOS/Emacs";
  };

  eglot-booster =
    {
      melpaBuild,
      fetchFromGitHub,
      emacs-lsp-booster,
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
      packageRequires = [ emacs-lsp-booster ];
    };
in
{
  programs = {
    emacs = {
      enable = true;
      # TODO emacs ns-inline-patchを当てたい
      # https://apribase.net/2024/06/21/emacs-as-daemon-for-mac/
      # package = pkgs.emacs.overrideAttrs (old: {
      #   patches = (old.patches or [ ]) ++ [
      #     (pkgs.fetchpatch {
      #       url = "https://raw.githubusercontent.com/takaxp/ns-inline-patch/master/emacs-29.1-inline.patch";
      #       sha256 = "sha256-UQsYJ9+6XgB7NSCmup4RzDn3NlR8vMKsQGJPYYqsgmU=";
      #     })
      #   ];
      # });
      package = pkgs.emacsWithPackagesFromUsePackage {
        package = pkgs.emacs.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ./ns-inline-patch/emacs-29.1-inline.patch ];
        });
        config = ./init.el;
        override =
          epkgs:
          epkgs
          // {
            eglot-booster = pkgs.callPackage eglot-booster {
              inherit (pkgs) fetchFromGitHub;
              inherit (epkgs) melpaBuild;
            };
          };
        extraEmacsPackages = epkgs: [
          epkgs.treesit-grammars.with-all-grammars
          # TODO astroのgrammarsも入れたいけど、grammarsのbuild方法がわからない。
        ];
      };
    };

    git.ignores = [
      ".dir-locals.el"
    ];
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

  xdg.configFile = {
    "emacs/init.el".source = ./init.el;
    "emacs/early-init.el".source = ./early-init.el;
    "emacs/etc/templates".source = ./etc/templates;
    "emacs/etc/transient/values.el".source = ./etc/transient/values.el;
  };

  # TODO emacs demon? client? service
  # 設定するべきなのか？するとして何を設定するべきなのか不明。
  # https://apribase.net/2024/06/21/emacs-as-daemon-for-mac/ Mac に正しくフレーム管理される Emacs as Daemon を起動する
  # https://github.com/takeokunn/nixos-configuration/blob/main/home-manager/services/emacs/default.nix takeokunn/nixos-configuration
}
