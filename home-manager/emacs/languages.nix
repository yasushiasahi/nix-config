{ pkgs, lib }:
let
  typescriptConfig = {
    name = "typescript-language-server";
    support-workspace = [ "package.json" ];
    except-features = [ "format" ];
  };

  eslintConfig = {
    name = "eslint";
    support-workspace = true;
    config-files = [
      ".eslintrc.js"
      ".eslintrc.cjs"
      ".eslintrc.yaml"
      ".eslintrc.yml"
      ".eslintrc"
      ".eslintrc.json"
      "eslint.config.js"
      "eslint.config.mjs"
      "eslint.config.cjs"
      "eslint.config.ts"
      "eslint.config.mts"
      "eslint.config.cts"
    ];
    except-features = [ "format" ];
  };

  biomeConfig = {
    name = "biome";
    support-workspace = true;
    config-files = [
      "biome.json"
      "biome.jsonc"
    ];
    except-features = [ "format" ];
  };

in
(pkgs.formats.toml { }).generate "lsp-proxy.toml" {
  language-server = {
    "tsgo-ls" = {
      command = lib.getExe' pkgs.typescript-go "tsgo";
      args = [
        "--lsp"
        "--stdio"
      ];
    };

    "astro-ls" = {
      command = lib.getExe pkgs.astro-language-server;
      args = [ "--stdio" ];
      config.typescript.tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib/";
    };

    "biome" = {
      command = "npx";
      args = [
        "biome"
        "lsp-proxy"
      ];
    };

    "terraform-ls" = {
      command = lib.getExe pkgs.terraform-ls;
      args = [ "serve" ];
    };

    "nixd" = {
      command = lib.getExe pkgs.nixd;
    };
  };

  language = [

    {
      name = "javascript";
      language-id = "javascript";
      file-types = [
        "js"
        "mjs"
        "cjs"
        "rules"
        "es6"
        "pac"
        "jakefile"
      ];
      roots = [ "package.json" ];
      language-servers = [
        typescriptConfig
        eslintConfig
        biomeConfig
      ];
    }

    {
      name = "jsx";
      language-id = "javascriptreact";
      file-types = [ "jsx" ];
      roots = [ "package.json" ];
      language-servers = [
        typescriptConfig
        eslintConfig
        biomeConfig
      ];
    }

    {
      name = "typescript";
      language-id = "typescript";
      file-types = [
        "ts"
        "mts"
        "cts"
      ];
      roots = [ "package.json" ];
      language-servers = [
        typescriptConfig
        eslintConfig
        biomeConfig
      ];
    }

    {
      name = "tsx";
      language-id = "typescriptreact";
      file-types = [ "tsx" ];
      roots = [ "package.json" ];
      language-servers = [
        typescriptConfig
        eslintConfig
        biomeConfig
        { name = "tailwindcss-ls"; }
      ];
    }

    {
      name = "astro";
      language-id = "astro";
      file-types = [ "astro" ];
      roots = [ "package.json" ];
      language-servers = [
        "astro-ls"
        eslintConfig
        biomeConfig
        { name = "tailwindcss-ls"; }
      ];
    }

    {
      name = "rust";
      file-types = [ "rs" ];
      roots = [
        "Cargo.toml"
        "Cargo.lock"
      ];
      language-servers = [
        {
          name = "rust-analyzer";
          except-features = [
            "format"
          ];
        }
      ];
    }

    {
      name = "hcl";
      language-id = "terraform";
      file-types = [
        "hcl"
        "tf"
        "nomad"
      ];
      roots = [
        "*.tf"
        "*.tfvars"
      ];
      language-servers = [
        {
          name = "terraform-ls";
          except-features = [
            "format"
            "diagnostics"
            "pull-diagnostics"
          ];
        }
      ];
    }

    {
      name = "nix";
      file-types = [ "nix" ];
      language-servers = [
        {
          name = "nixd";
          except-features = [
            "format"
          ];
        }
      ];
    }
  ];
}
