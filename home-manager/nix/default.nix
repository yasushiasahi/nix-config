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
      dasw = "darwin-rebuild switch --flake ~/ghq/github.com/yasushiasahi/nix-config#darwin";
      hmsw = "home-manager switch --flake ~/ghq/github.com/yasushiasahi/nix-config#home";
      dilo = "nix flake init -t ~/ghq/github.com/yasushiasahi/nix-config#dir-locals";
      gtexdr = "echo \".dir-locals.el\\n.dir-locals.nix\\n.envrc\" >> .git/info/exclude && git update-index --assume-unchanged .dir-locals.el .dir-locals.nix .envrc";
    };
}
