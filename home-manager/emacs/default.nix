{
  pkgs,
  mkAlias,
  sources,
  ...
}:
let
  emacs-with-epkgs = pkgs.emacsWithPackagesFromUsePackage {
    config = ./init.org;
    override =
      epkgs:
      epkgs
      // {
        org-modern-indent = epkgs.melpaBuild {
          pname = "org-modern-indent";
          version = "0.0.1";
          src = sources.emacs-org-modern-indent.src;
        };
        lsp-biome = epkgs.melpaBuild {
          pname = "lsp-biome";
          version = "0.0.1";
          src = sources.emacs-lsp-biome.src;
          packageRequires = [ epkgs.lsp-mode ];
        };
        fzf-native = epkgs.melpaBuild {
          pname = "fzf-native";
          version = "0.0.1";
          src = sources.emacs-fzf-native.src;
          files = ''(:defaults "bin")'';
        };
        # lsp-modeのplists解析を有効にする。そのままだと、hash-tableになる。
        # https://emacs-lsp.github.io/lsp-mode/page/performance/#use-plists-for-deserialization
        lsp-mode = epkgs.lsp-mode.overrideAttrs (
          _: p: {
            buildPhase = ''
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
    pkgs.dockerfile-language-server
    pkgs.vscode-langservers-extracted # html css json
    pkgs.nil # nix
    pkgs.vale-ls # markdown
    pkgs.taplo # toml
    pkgs.terraform-ls

    #formatter & linter
    pkgs.nodePackages.prettier
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
    LSP_USE_PLISTS = "true";
  };

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
