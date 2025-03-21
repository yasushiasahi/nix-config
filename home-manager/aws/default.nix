{ pkgs, ... }:
{
  programs.awscli.enable = true;

  home.packages = [
    pkgs.git-remote-codecommit
  ];
}
