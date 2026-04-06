{ ... }:
{
  programs.television = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      ui = {
        theme = "solarized-dark";
      };
    };
  };
}
