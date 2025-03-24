{
  description = "My Nix config for Mac OS";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    org-babel.url = "github:emacs-twist/org-babel";
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      emacs-overlay,
      org-babel,
      self,
    }:
    let
      system = "aarch64-darwin";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          emacs-overlay.overlay
          (_: _: {
            org-babel.tangleOrgBabel = org-babel.lib.tangleOrgBabel;
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
        inherit pkgs home-manager;
      };

      templates = {
        dir-locals = {
          path = ./templates/dir-locals;
          description = "開発環境セットアップファイルのテンプレート";
        };
      };

    };
}
