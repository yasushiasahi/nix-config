{
  pkgs,
  home-manager,
}:
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  # Specify your home configuration modules here, for example,
  # the path to your home.nix.
  modules = [
    ./common.nix
    ./zsh
    ./eza
  ];

  # Optionally use extraSpecialArgs
  # to pass through arguments to home.nix
  # extraSpecialArgs = {};
}
