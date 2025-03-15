{
  description = "nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
    }:

    let
      username = "asahi";
      system = "aarch64-darwin";
      configuration =
        { ... }:
        {
          users.users.${username}.home = "/Users/${username}";
        };
    in
    {
      # nix run nix-darwin -- switch --flake .#LP202405MAC120
      darwinConfigurations."LP202405MAC120" = nix-darwin.lib.darwinSystem {
        inherit system;
        inherit (inputs.nixpkgs) lib;
        specialArgs = {
          inherit inputs;
          inherit system;
        };

        modules = [
          configuration
          ./nix/nix-darwin/default.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.backupFileExtension = "nix-bk";
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit username; };
            home-manager.users."${username}" = import ./nix/home-manager/default.nix;
          }
        ];

      };
    };
}
