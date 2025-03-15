{ pkgs, username, ... }:
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.preferXdgDirectories = true;
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.extraOutputsToInstall = [ "dev" ];

  home.packages = [
    # emacs
    pkgs.emacs-lsp-booster
    pkgs.tree-sitter
    pkgs.autoconf
    pkgs.libgccjit
    pkgs.gcc
    pkgs.pkgconf
    pkgs.texinfo
    pkgs.gnutls

    # general
    pkgs.ghq
    pkgs.difftastic
    pkgs.darwin.trash
    pkgs.fd
    pkgs.fzf
    pkgs.jq
    pkgs.sheldon
    pkgs.tmux
    pkgs.zoxide
    pkgs.zsh-completions
    pkgs.bat
    pkgs.eza
    pkgs.git
    pkgs.fzf
    pkgs.ripgrep
    pkgs.colima
    pkgs.docker-compose

    # nix tools
    pkgs.nil
    pkgs.nixfmt-rfc-style

    # node
    pkgs.nodejs_22
    pkgs.yarn
    pkgs.pnpm
    pkgs.nodePackages.prettier
    pkgs.nodePackages.npm-check-updates
    pkgs.nodePackages.typescript
    pkgs.nodePackages.typescript-language-server
    pkgs.astro-language-server
    pkgs.yaml-language-server
    pkgs.tailwindcss-language-server
    pkgs.dockerfile-language-server-nodejs
    pkgs.vscode-langservers-extracted
  ];

  home.file = { };
  home.sessionVariables = { };

  xdg.configFile = {
    "alacritty" = {
      source = ../../alacritty;
      recursive = true;
    };
    "colima" = {
      source = ../../colima;
      recursive = true;
    };
    "emacs" = {
      source = ../../emacs;
      recursive = true;
    };
    "eza" = {
      source = ../../eza;
      recursive = true;
    };
    "git" = {
      source = ../../git;
      recursive = true;
    };
    "karabiner" = {
      source = ../../karabiner;
      recursive = true;
    };
    "raycast" = {
      source = ../../raycast;
      recursive = true;
    };
    "sheldon" = {
      source = ../../sheldon;
      recursive = true;
    };
    "tmux" = {
      source = ../../tmux;
      recursive = true;
    };
    "zsh" = {
      source = ../../zsh;
      recursive = true;
    };
  };

  programs = {
    home-manager = {
      enable = true;
    };
    zsh = {
      enable = true;
      dotDir = " .config/zsh";
    };
  };
}
