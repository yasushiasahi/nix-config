{ pkgs, config, ... }:
let
  gen-authinfo = pkgs.writeShellScriptBin "gen-authinfo" ''
    op inject -i ${config.nix-config}/home-manager/authinfo/template -o ~/.authinfo
  '';
in
{
  home.packages = [
    pkgs._1password-cli
    gen-authinfo
  ];
}
