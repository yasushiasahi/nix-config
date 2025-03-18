{ ... }:
{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg = {
    configFile = {
      "eza/theme.yml" = {
        source = ./theme.yml;
      };
    };
  };

  home.sessionVariables = {
    EZA_CONFIG_DIR = "~/.config/eza";
  };
}
