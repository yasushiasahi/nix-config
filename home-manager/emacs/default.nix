{
  pkgs,
  mkAlias,
  sources,
  lib,
  emacs-ghostel,
  ...
}:
let
  emacs-with-epkgs = pkgs.emacsWithPackagesFromUsePackage {
    config = ./init.org;
    override =
      epkgs:
      epkgs
      // {
        astro-ts-mode = epkgs.melpaBuild {
          pname = "astro-ts-mode";
          version = "0.0.0-unstable-${sources.emacs-astro-ts-mode.date}";
          src = sources.emacs-astro-ts-mode.src;
          # このautoloadがtreesitのロード前に呼ばれてしまってemacsが立ち上がる前に落ちてしまうため
          # https://git.isincredibly.gay/srxl/astro-ts-mode/src/commit/1d24c9d399dee4cfea6ed9b49d8e08891665e16c/astro-ts-mode.el#L184
          preBuild = ''
            sed -i '/;;;###autoload/d' astro-ts-mode.el
          '';
        };
        org-modern-indent = epkgs.melpaBuild {
          pname = "org-modern-indent";
          version = "0.0.0-unstable-${sources.emacs-org-modern-indent.date}";
          src = sources.emacs-org-modern-indent.src;
        };
        lsp-proxy = epkgs.melpaBuild {
          pname = "lsp-proxy";
          version = "0.0.0-unstable-${sources.emacs-lsp-proxy.date}";
          src = sources.emacs-lsp-proxy.src;
          files = ''("*.el")'';
          packageRequires = [
            epkgs.s
            epkgs.f
            epkgs.ht
            epkgs.dash
            epkgs.yasnippet
          ];
        };
        ghostel = pkgs.emacsPackages.melpaBuild {
          pname = "ghostel";
          version = "0.0.0-unstable-${sources.emacs-ghostel.date}";
          src = sources.emacs-ghostel.src;
          files = ''(:defaults "etc" "ghostel-module.dylib")'';
          preBuild = ''
            install ${sources.emacs-ghostel-module.src} ghostel-module.dylib
          '';
        };
      };
    extraEmacsPackages = epkgs: [
      epkgs.treesit-grammars.with-all-grammars
      pkgs.tree-sitter-grammars.tree-sitter-astro
      # TODO astroのgrammarsも入れたいけど、grammarsのbuild方法がわからない。
    ];
  };

  tangle = pkgs.tangleOrgBabel { languages = [ "emacs-lisp" ]; };

  shellAlias = mkAlias {
    emacs = "${emacs-with-epkgs}/Applications/Emacs.app/Contents/MacOS/Emacs";
  };

in
{
  programs = {
    emacs = {
      enable = true;
      package = emacs-with-epkgs;
    };
  }
  // shellAlias;

  home.packages = [
    # lsp-proxy-cli

    # gnuのlsを入れないと以下の警告が出る
    # ls does not support --dired; see ‘dired-use-ls-dired’ for more details.
    pkgs.coreutils

    # org-web-toolsで使う。orgからmarkdownに変換する。
    # TODO: もしかするとpakagesに同梱されてるかも。調べる。
    pkgs.pandoc

    # lsp
    pkgs.typescript
    pkgs.typescript-language-server
    pkgs.typescript-go
    pkgs.astro-language-server
    pkgs.yaml-language-server
    pkgs.tailwindcss-language-server
    pkgs.dockerfile-language-server
    pkgs.vscode-langservers-extracted # html css json
    pkgs.nixd # nix
    pkgs.vale-ls # markdown
    pkgs.taplo # toml
    pkgs.terraform-ls
    pkgs.pyright # python

    #formatter & linter
    pkgs.nixfmt
    pkgs.eslint
    pkgs.biome

    # shell-script-mode
    pkgs.shellcheck
  ];

  # cliからemacsを起動した時にLANGがないと警告が出る。
  # https://apribase.net/2024/07/26/emacs-language-environment-mac/#langen_jputf-8-cannot-be-used-using-en_usutf-8-instead
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    EDITOR = lib.mkForce "emacs -nw";
    VISUAL = lib.mkForce "emacs -nw";
  };

  xdg.configFile = {
    "emacs/init.el".text = tangle (builtins.readFile ./init.org);
    "emacs/early-init.el".text = tangle (builtins.readFile ./early-init.org);
    "emacs/lsp-proxy/languages.toml".source = ./languages.toml;
    "emacs/lsp-proxy/emacs-lsp-proxy".source = "${sources.emacs-lsp-proxy-bin.src}/emacs-lsp-proxy";
  };

  # TODO emacs demon? client? service
  # 設定するべきなのか？するとして何を設定するべきなのか不明。
  # https://apribase.net/2024/06/21/emacs-as-daemon-for-mac/ Mac に正しくフレーム管理される Emacs as Daemon を起動する
  # https://github.com/takeokunn/nixos-configuration/blob/main/home-manager/services/emacs/default.nix takeokunn/nixos-configuration
}
