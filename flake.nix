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
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      self,
    }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
        modules = [ ./darwin.nix ];
        specialArgs = { inherit self; };
      };

      homeConfigurations.home = import ./home {
        inherit home-manager;
        inherit pkgs;
      };

      templates = {
        dir-locals = {
          path = ./templates/dir-locals;
          description = "開発環境セットアップファイルのテンプレート";
        };
      };

    };
}
