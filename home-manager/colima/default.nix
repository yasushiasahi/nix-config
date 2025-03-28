{ config, ... }:
{
  xdg.configFile."colima/default/colima.yaml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.nix-config}/home-manager/colima/default/colima.yaml";
}
