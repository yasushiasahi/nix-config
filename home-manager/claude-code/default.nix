{ pkgs, ... }:

{
  programs.claude-code = {
    enable = true;
  };

  home.file = {
    # ".claude/my-marketplace/.claude-plugin/marketplace.json" = {
    #   text = builtins.toJSON {
    #     name = "astro-marketplace";
    #     owner = {
    #       name = "zero_asahi";
    #     };
    #     plugins = [
    #       {
    #         name = "astro-lsp";
    #         source = "./plugins/astro-lsp";
    #         version = "1.0.0";
    #         description = "Astro language server for enhanced code intelligence";
    #         category = "development";
    #       }
    #     ];
    #   };
    # };
    # ".claude/my-marketplace/plugins/astro-lsp/.lsp.json" = {
    #   text = builtins.toJSON {
    #     astro = {
    #       command = lib.getExe pkgs.astro-language-server;
    #       args = [ "--stdio" ];
    #       transport = "stdio";
    #       extensionToLanguage = {
    #         ".astro" = "astro";
    #       };
    #       initializationOptions = {
    #         typescript = {
    #           tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib/";
    #         };
    #       };
    #     };
    #   };
    # };
    # ".claude/my-marketplace/plugins/astro-lsp/.claude-plugin/plugin.json" = {
    #   text = builtins.toJSON {
    #     name = "astro-lsp";
    #     description = "Astro language server for enhanced code intelligence";
    #     version = "1.0.0";
    #     author = {
    #       name = "zero_asahi";
    #     };
    #     license = "MIT";
    #     keywords = [
    #       "astro"
    #       "lsp"
    #       "language-server"
    #     ];
    #   };
    # };

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
            source = "./plugins/astro-lsp";
            version = "1.0.0";
            description = "Astro language server for enhanced code intelligence";
            category = "development";
          }
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
            strict = false;
            lspServers = {
              astro = {
                command = "astro-ls";
                args = [ "--stdio" ];
                extensionToLanguage = {
                  ".astro" = "astro";
                };
                initializationOptions = {
                  typescript = {
                    tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib/";
                  };
                };
              };
            };
          }
        ];
      };
    };

    ".claude/self-marketplace/plugins/astro-lsp/README.md" = {
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
