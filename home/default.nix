{
  pkgs,
  home-manager,
}:
let
  makeAliasConfig = aliasSets: {
    zsh.shellAliases = aliasSets;
    fish.shellAliases = aliasSets;
  };
  makeAbbrConfig = aliasSets: {
    zsh.zsh-abbr.abbreviations = aliasSets;
  };

  miscModule = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = "asahi";
    home.homeDirectory = "/Users/asahi";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "24.11"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = [
      # general
      pkgs.ghq
      pkgs.darwin.trash
      pkgs.jq # programs.jq.enableでもいけるけど、設定することないのでこっち

      #nix
      pkgs.nixfmt-rfc-style

      # docker
      pkgs.colima
      pkgs.docker
      pkgs.docker-compose
      pkgs.docker-buildx

      # node tools
      pkgs.nodejs_22
      pkgs.yarn
      pkgs.pnpm
      pkgs.nodePackages.prettier
      pkgs.nodePackages.npm-check-updates
      # pkgs.nodePackages.typescript

    ];

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # zsh-abbr pluginを入れるのに必要
    nixpkgs.config.allowUnfree = true;

    # XDG_*の環境変数を設定する
    xdg.enable = true;
  };
in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  # Specify your home configuration modules here, for example,
  # the path to your home.nix.
  modules = [
    miscModule
    ./emacs
    ./zsh
    ./git
    ./alacritty
    # ./ghostty nixpkg版が壊れているよう
    ./tmux
    ./direnv
    ./eza
    ./fzf
    ./ripgrep
    ./fd
    ./bat
    ./zoxide
    ./aws
    ./starship
  ];

  # Optionally use extraSpecialArgs
  # to pass through arguments to home.nix
  extraSpecialArgs = {
    inherit makeAliasConfig;
    inherit makeAbbrConfig;
  };

}
