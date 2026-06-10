{ pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
    lspServers = {
      astro = {
        # command = "astro-ls";
        # args = [ "--stdio" ];
        command = "npx";
        args = [
          "@astrojs/language-server"
          "--stdio"
        ];
        extensionToLanguage = {
          ".astro" = "astro";
        };
        initializationOptions = {
          typescript = {
            tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib/";
          };
        };
      };

      nix = {
        command = "nixd";
        args = [ "--stdio" ];
        extensionToLanguage = {
          ".nix" = "nix";
        };
      };
    };
  };
}
