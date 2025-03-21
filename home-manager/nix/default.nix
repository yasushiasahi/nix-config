{ mkAbbr, ... }:
{
  # zsh-abbr pluginを入れるのに必要
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs =
    {
      home-manager.enable = true;
    }
    // mkAbbr {
      drsw = "darwin-rebuild switch --flake ~/ghq/github.com/yasushiasahi/nix-config#darwin";
      hmsw = "home-manager switch --flake ~/ghq/github.com/yasushiasahi/nix-config#home";
      dilo = "nix flake init -t ~/ghq/github.com/yasushiasahi/nix-config#dir-locals";
    };
}
