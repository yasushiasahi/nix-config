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

  xdg.configFile = {
    # completions
    "fish/completions/" = {
      source = ./completions;
      recursive = true;
    };
  };

}
