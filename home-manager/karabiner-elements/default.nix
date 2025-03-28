{ config, ... }:
{
  xdg.configFile."karabiner/karabiner.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.nix-config}/home-manager/karabiner-elements/karabiner.json";
}
