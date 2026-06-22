{ pkgs, lib }:
let
  deepMerge =
    lhs: rhs:
    lhs
    // builtins.mapAttrs (
      key: rhsVal:
      if builtins.hasAttr key lhs then
        let
          lhsVal = lhs.${key};
        in
        if builtins.isAttrs lhsVal && builtins.isAttrs rhsVal then
          deepMerge lhsVal rhsVal
        else if builtins.isList lhsVal && builtins.isList rhsVal then
          lhsVal ++ rhsVal
        else
          rhsVal
      else
        rhsVal
    ) rhs;

  # 任意個のリストを畳み込む版
  deepMergeAll = builtins.foldl' deepMerge { };

  frontend =
    let
      typescriptLs = {
        name = "typescript-language-server";
        support-workspace = [ "package.json" ];
        except-features = [ "format" ];
      };

      eslintLs = {
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

      biomeLs = {
        name = "biome";
        support-workspace = true;
        config-files = [
          "biome.json"
          "biome.jsonc"
        ];
        except-features = [ "format" ];
      };

      tailwindLs = {
        name = "tailwindcss-ls";
        except-features = [ "format" ];
      };
    in
    {
      language-server.astro-ls = {
        command = lib.getExe pkgs.astro-language-server;
        args = [ "--stdio" ];
        config.typescript.tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib/";
      };

      language-server.typescript-go = {
        command = lib.getExe' pkgs.typescript-go "tsgo";
        args = [
          "--lsp"
          "--stdio"
        ];
      };

      language-server.biome = {
        command = "npx";
        args = [
          "biome"
          "lsp-proxy"
        ];
      };

      language = [
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
            typescriptLs
            eslintLs
            biomeLs
          ];
        }
        {
          name = "tsx";
          language-id = "typescriptreact";
          file-types = [ "tsx" ];
          roots = [ "package.json" ];
          language-servers = [
            typescriptLs
            eslintLs
            biomeLs
            tailwindLs
          ];
        }
        {
          name = "astro";
          language-id = "astro";
          file-types = [ "astro" ];
          roots = [ "package.json" ];
          language-servers = [
            "astro-ls"
            eslintLs
            biomeLs
            tailwindLs
          ];
        }
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
            typescriptLs
            eslintLs
            biomeLs
          ];
        }
        {
          name = "jsx";
          language-id = "javascriptreact";
          file-types = [ "jsx" ];
          roots = [ "package.json" ];
          language-servers = [
            typescriptLs
            eslintLs
            biomeLs
            tailwindLs
          ];
        }
      ];
    };

  rust = {
    language = [
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
            except-features = [ "format" ];
          }
        ];
      }
    ];
  };

  terraform = {
    language-server.terraform-ls = {
      command = lib.getExe pkgs.terraform-ls;
      args = [ "serve" ];
    };
    language = [
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
            except-features = [ "format" ];
          }
        ];
      }
    ];
  };

  nix = {
    language-server.nixd = {
      command = lib.getExe pkgs.nixd;
    };
    language = [
      {
        name = "nix";
        file-types = [ "nix" ];
        language-servers = [
          {
            name = "nixd";
            except-features = [ "format" ];
          }
        ];
      }
    ];
  };

  docker = {
    language-server.docker-language-server = {
      command = lib.getExe pkgs.docker-language-server;
      args = [
        "start"
        "--stdio"
      ];
    };

    language-server.docker-compose-langserver = {
      command = lib.getExe' pkgs.docker-compose-language-service "docker-compose-langserver";
      args = [ "--stdio" ];
    };

    language = [
      {
        name = "dockerfile";
        roots = [
          "Dockerfile"
          "Containerfile"
        ];
        file-types = [
          "Dockerfile"
          { glob = "Dockerfile"; }
          { glob = "Dockerfile.*"; }
          "dockerfile"
          { glob = "dockerfile"; }
          { glob = "dockerfile.*"; }
          "Containerfile"
          { glob = "Containerfile"; }
          { glob = "Containerfile.*"; }
          "containerfile"
          { glob = "containerfile"; }
          { glob = "containerfile.*"; }
        ];
        language-servers = [
          {
            name = "docker-language-server";
            except-features = [ "format" ];
          }
        ];
      }
      {
        name = "docker-compose";
        language-id = "dockercompose";
        roots = [
          "docker-compose.yaml"
          "docker-compose.yml"
          "compose.yaml"
          "compose.yml"
        ];
        file-types = [
          { glob = "docker-compose.yaml"; }
          { glob = "docker-compose.yml"; }
          { glob = "compose.yaml"; }
          { glob = "compose.yml"; }
        ];
        language-servers = [
          {
            name = "docker-language-server";
            except-features = [ "format" ];
          }
          {
            name = "docker-compose-langserver";
            except-features = [ "format" ];
          }
          {
            name = "yaml-language-server";
            except-features = [ "format" ];
          }
        ];
      }
    ];
  };

  yaml = {
    language-server.yaml-language-server = {
      command = lib.getExe pkgs.yaml-language-server;
      args = [ "--stdio" ];
    };
    language = [
      {
        name = "yaml";
        file-types = [
          "yml"
          "yaml"
        ];
        language-servers = [
          {
            name = "yaml-language-server";
            except-features = [ "format" ];
          }
        ];
      }
    ];
  };

  json = {
    language-server.vscode-json-languageserver = {
      command = "npx";
      args = [
        "vscode-json-languageserver"
        "--stdio"
      ];
    };
    language = [
      {
        name = "json";
        file-types = [ "json" ];
        language-servers = [
          {
            name = "vscode-json-languageserver";
            support-workspace = true;
            except-features = [ "format" ];
          }
        ];
      }
      {
        name = "jsonc";
        file-types = [ "jsonc" ];
        language-servers = [
          {
            name = "vscode-json-languageserver";
            support-workspace = true;
            except-features = [ "format" ];
          }
        ];
      }
    ];
  };
in

(pkgs.formats.toml { }).generate "languages.toml" (deepMergeAll [
  rust
  frontend
  terraform
  docker
  nix
  json
  yaml
])
