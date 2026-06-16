{ ... }:
{
  home.shell.enableFishIntegration = true;

  programs.fish = {
    enable = true;
    generateCompletions = true;
    interactiveShellInit = ''
      # 起動時の挨拶文を非表示にする
      set fish_greeting
    '';
    shellAliases = {
      rm = "trash";
    };
    binds = {
      "ctrl-t".command = "tv";
      "ctrl-j".command = "tv_smart_autocomplete";
    };
  };

  # trace: warning: programs.man.generateCaches has no effect when programs.man.package is null を抑制するため
  programs.man.generateCaches = false;

  xdg.configFile = {
    # completions
    "fish/completions/" = {
      source = ./completions;
      recursive = true;
    };
  };

}
