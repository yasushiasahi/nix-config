{
  pkgs,
  mkAlias,
  sources,
  ...
}:
let
  emacs-mac = pkgs.emacs.overrideAttrs (old: {
    configureFlags = (old.configureFlags or [ ]) ++ [ "--with-xwidgets" ];
    # patches = (old.patches or [ ]) ++ [ ./emacs-29.1-inline.patch ];
  });

  lsp-proxy =
    let
      cli = pkgs.rustPlatform.buildRustPackage {
        pname = "lsp-proxy";
        version = "0.0.1";
        src = sources.lsp-proxy.src;
        cargoLock = sources.lsp-proxy.cargoLock."Cargo.lock";
      };
    in
    {
      melpaBuild,
      s,
      f,
      ht,
      dash,
      yasnippet,
    }:
    melpaBuild {
      pname = "lsp-proxy";
      version = "0.0.1";
      nativeBuildInputs = [ cli ];
      src = sources.lsp-proxy.src;
      # lsp-proxy.elと同じディレクトリにビルドした実行ファイルをおかないといけない
      postInstall = ''
        ls $out/share/emacs/site-lisp/elpa/lsp-proxy-0.0.1
        cp ${cli}/bin/lsp-proxy $out/share/emacs/site-lisp/elpa/lsp-proxy-0.0.1/lsp-proxy
      '';
      packageRequires = [
        s
        f
        ht
        dash
        yasnippet
      ];
    };

  emacs-mac-with-epkgs = pkgs.emacsWithPackagesFromUsePackage {
    package = emacs-mac;
    config = ./init.org;
    override =
      epkgs:
      epkgs
      // {
        eglot-booster = epkgs.melpaBuild {
          pname = "eglot-booster";
          version = "0.0.1";
          src = sources.emacs-eglot-booster.src;
        };
        consult-omni = epkgs.melpaBuild {
          pname = "consult-omni";
          version = "0.0.1";
          src = sources.emacs-consult-omni.src;
          files = ''
            ("*.el"
             "sources/consult-omni-google-autosuggest.el"
             "sources/consult-omni-google.el"
             "sources/consult-omni-sources.el"
             "sources/consult-omni-ripgrep-all.el"
             "sources/consult-omni-grep.el"
             "sources/consult-omni-fd.el"
             "sources/consult-omni-gptel.el"
             "sources/consult-omni-gh.el"
             "sources/consult-omni-brave-autosuggest.el"
             "sources/consult-omni-brave.el"
             "sources/consult-omni-wikipedia.el"
             "sources/consult-omni-apps.el")
          '';
          packageRequires = [
            epkgs.consult
            epkgs.embark-consult
            epkgs.gptel
            epkgs.consult-gh
            epkgs.yaml
          ];
        };
        org-modern-indent = epkgs.melpaBuild {
          pname = "org-modern-indent";
          version = "0.0.1";
          src = sources.emacs-org-modern-indent.src;
        };
        claude-code = epkgs.melpaBuild {
          pname = "claude-code";
          version = "0.0.1";
          src = sources.emacs-claude-code.src;
          files = ''("*.el" (:exclude "images/*"))'';
        };
        claudemacs = epkgs.melpaBuild {
          pname = "claudemacs";
          version = "0.0.1";
          src = sources.emacs-claudemacs.src;
        };
        eat = epkgs.melpaBuild {
          pname = "eat";
          version = "0.0.2";
          src = sources.emacs-eat.src;
          files = ''
            ("*.el" ("term" "term/*.el") "*.texi"
               "*.ti" ("terminfo/e" "terminfo/e/*")
               ("terminfo/65" "terminfo/65/*")
               ("integration" "integration/*")
               (:exclude ".dir-locals.el" "*-tests.el"))
          '';
        };
        lsp-proxy = pkgs.callPackage lsp-proxy {
          inherit (epkgs)
            melpaBuild
            s
            f
            ht
            dash
            yasnippet
            ;
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
    emacs = "${emacs-mac-with-epkgs}/Applications/Emacs.app/Contents/MacOS/Emacs";
  };

in
{
  programs = {
    emacs = {
      enable = true;
      package = emacs-mac-with-epkgs;
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

    # shell-script-mode
    pkgs.shellcheck

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
