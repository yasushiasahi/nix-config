{ mkAbbr, ... }:
let
  abbrConfig = mkAbbr {
    ll = "eza -alh --icons always --color always --git";
    lt = "eza --tree --sort=type --reverse --git-ignore";
  };
in
{
  programs = {
    eza = {
      enable = true;
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
