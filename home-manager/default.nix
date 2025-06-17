{
  pkgs,
  home-manager,
}:
let
  mkAlias = sets: {
    zsh.shellAliases = sets;
    fish.shellAliases = sets;
  };
  mkAbbr = sets: {
    zsh.zsh-abbr.abbreviations = sets;
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
      pkgs.gnused

      pkgs.ripgrep-all

      # docker
      pkgs.colima
      pkgs.docker
      pkgs.docker-compose
      pkgs.docker-buildx

      # node tools
      pkgs.nodejs_22

      # ai & llm
      pkgs.ollama
      pkgs.aider-chat
      pkgs.claude-code
    ];

    # XDG_*の環境変数を設定する
    xdg.enable = true;

    services.ollama.enable = true;
  };

  optionModule =
    { config, ... }:
    {
      # このリポジトリへのpathを各モジュールで共有できるようにする。
      options = {
        nix-config = pkgs.lib.mkOption {
          type = pkgs.lib.types.path;
          apply = toString;
          default = "${config.home.homeDirectory}/ghq/github.com/yasushiasahi/nix-config";
          example = "${config.home.homeDirectory}/ghq/github.com/yasushiasahi/nix-config";
          description = "このリポジトリ自身のソースファイルの場所";
        };
      };
    };

in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  # Specify your home configuration modules here, for example,
  # the path to your home.nix.
  modules = [
    miscModule
    optionModule
    ./emacs
    ./zsh
    ./git
    ./nix
    ./alacritty
    ./ghostty
    ./tmux
    ./direnv
    ./eza
    ./fzf
    ./ripgrep
    ./fd
    ./bat
    ./zoxide
    ./aws
    ./authinfo
    ./vscode
    ./starship
    ./karabiner-elements
    ./colima
  ];

  # Optionally use extraSpecialArgs
  # to pass through arguments to home.nix
  extraSpecialArgs = {
    inherit mkAlias;
    inherit mkAbbr;
  };

}
