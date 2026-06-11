{ ... }:

{
  programs.claude-code = {
    enable = true;
  };

  # home.file.".claude/plugins/.lsp.json" = {
  #   text = builtins.toJSON {
  #     astro = {
  #       command = "npx";
  #       args = [
  #         "@astrojs/language-server"
  #         "--stdio"
  #       ];
  #       extensionToLanguage = {
  #         ".astro" = "astro";
  #       };
  #       initializationOptions = {
  #         typescript = {
  #           tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib/";
  #         };
  #       };
  #     };

  #     terraform = {
  #       command = "terraform-ls";
  #       args = [ "serve" ];
  #       extensionToLanguage = {
  #         ".tf" = "tf";
  #         ".hcl" = "hcl";
  #       };
  #     };

  #     nix = {
  #       command = "nixd";
  #       args = [ "--stdio" ];
  #       extensionToLanguage = {
  #         ".nix" = "nix";
  #       };
  #     };
  #   };
  # };
}
