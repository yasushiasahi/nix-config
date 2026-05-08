{ pkgs, ... }:
{
  programs.awscli.enable = true;

  home.packages = [
    pkgs.git-remote-codecommit
    pkgs.tenv
    pkgs.ssm-session-manager-plugin
  ];
}
