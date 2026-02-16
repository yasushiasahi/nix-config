{
  description = "My Nix config for Mac OS";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util.url = "github:hraban/mac-app-util";

    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    org-babel.url = "github:emacs-twist/org-babel";

    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    cloudflare-skills = {
      url = "github:cloudflare/skills";
      flake = false;
    };
    hashicorp-agent-skills = {
      url = "github:hashicorp/agent-skills";
      flake = false;
    };
    deno-skills = {
      url = "github:denoland/skills";
      flake = false;
    };
    aws-agent-skills = {
      url = "github:itsmostafa/aws-agent-skills";
      flake = false;
    };
    microsoft-skills = {
      url = "github:microsoft/skills";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      mac-app-util,
      emacs-overlay,
      org-babel,
      mcp-servers-nix,
      agent-skills,
      anthropic-skills,
      cloudflare-skills,
      hashicorp-agent-skills,
      deno-skills,
      aws-agent-skills,
      microsoft-skills,
      self,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          emacs-overlay.overlay
          (_: _: {
            tangleOrgBabel = org-babel.lib.tangleOrgBabel;
          })
        ];
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
        modules = [ ./nix-darwin ];
        specialArgs = { inherit self; };
      };

      homeConfigurations.home = import ./home-manager {
        inherit
          pkgs
          home-manager
          mac-app-util
          mcp-servers-nix
          agent-skills
          anthropic-skills
          cloudflare-skills
          hashicorp-agent-skills
          deno-skills
          aws-agent-skills
          microsoft-skills
          ;
      };

      templates = {
        dir-locals = {
          path = ./templates/dir-locals;
          description = "開発環境セットアップファイルのテンプレート";
        };
      };

    };
}
