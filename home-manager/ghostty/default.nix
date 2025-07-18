{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.brewCasks.ghostty;
    enableZshIntegration = true;
    enableFishIntegration = true;
    installBatSyntax = false;
    settings = {
      theme = "Builtin Solarized Dark";
      font-family = "HackGen35 Console NF";
      font-size = 13;
      # boldほどではないけど、文字を太くする。見やすい。
      # font-thicken = true;
      adjust-cell-width = "-8%";
      adjust-cell-height = "-8%";
      cursor-style = "bar";
      command = "${pkgs.zsh}/bin/zsh -l -c ${pkgs.tmux}/bin/tmux a -t scratch || ${pkgs.tmux}/bin/tmux new -s scratch";
      keybind = [ "ctrl+m=text:\\n" ];
    };
  };
}
