{
  pkgs,
  # home-manager/default.nix の extraSpecialArgs で定義(emacsと共用)
  typescript-tsdk,
  ...
}:

{
  programs.claude-code = {
    enable = true;
    # ~/.claude/CLAUDE.md として配置される
    context = ./CLAUDE.md;
  };

  home.file = {
    # 自作プラグイン用のローカルマーケットプレイス。
    # ~/.claude/settings.json の extraKnownMarketplaces に登録済みで、
    # プラグインは `claude plugin install astro-lsp@my-marketplace` で有効化する。
    ".claude/my-marketplace/.claude-plugin/marketplace.json" = {
      text = builtins.toJSON {
        name = "my-marketplace";
        description = "Self defined plugins";
        owner = {
          name = "zero_asahi";
        };
        plugins = [
          {
            name = "astro-lsp";
            description = "Astro language server for enhanced code intelligence";
            version = "1.0.0";
            author = {
              name = "yasushiasahi";
              email = "zero.asahi@karabiner.tech";
            };
            source = "./plugins/astro-lsp";
            category = "development";
            # plugin.json を置かず、プラグイン定義をこのエントリだけで完結させる
            strict = false;
            lspServers = {
              astro = {
                # GUIから起動されてもPATHに依存しないよう絶対パスで書く
                command = "${pkgs.astro-language-server}/bin/astro-ls";
                args = [ "--stdio" ];
                extensionToLanguage = {
                  ".astro" = "astro";
                };
                initializationOptions = {
                  typescript = {
                    tsdk = "${typescript-tsdk}/lib";
                  };
                };
              };
            };
          }
        ];
      };
    };

    # source の参照先ディレクトリ(中身はこのREADMEのみ)
    ".claude/my-marketplace/plugins/astro-lsp/README.md" = {
      text = ''
        # astro-lsp

        Astro language server for Claude Code, providing code intelligence features like go-to-definition, find references, and error checking.

        ## Supported Extensions
        `.astro`
      '';
    };
  };

  home.packages = [
    pkgs.typescript-language-server
    pkgs.astro-language-server
  ];

  home.sessionVariables = {
    ENABLE_LSP_TOOL = "1";
  };
}
