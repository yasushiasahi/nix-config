{ mkAbbr, ... }:
let
  abbrConfig = mkAbbr {
    ll = "eza -alh";
    lt = "eza --tree --sort=type --reverse --git-ignore";
  };
in
{
  programs = {
    eza = {
      enable = true;
      git = true;
      colors = "always";
      icons = "always";
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
  } // abbrConfig;

  xdg.configFile = {
    "eza/theme.yml" = {
      source = ./theme.yml;
    };
  };

  home.sessionVariables.EZA_CONFIG_DIR = "$HOME/.config/eza";
}
