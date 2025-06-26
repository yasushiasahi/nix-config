{ sources, ... }:
{
  home.shell.enableFishIntegration = true;

  programs.fish = {
    enable = true;
    generateCompletions = true;
    shellInit = ''
      # 起動時の挨拶文を非表示にする
      set fish_greeting
    '';

    plugins = [
      {
        name = sources.fish-bd.pname;
        src = sources.fish-bd.src;
      }
      {
        name = sources.fish-ghq.pname;
        src = sources.fish-ghq.src;
      }
      {
        name = sources.fish-fzf.pname;
        src = sources.fish-fzf.src;
      }
      {
        name = sources.fish-enhancd.pname;
        src = sources.fish-enhancd.src;
      }
      {
        name = sources.fish-done.pname;
        src = sources.fish-done.src;
      }
      {
        name = sources.fish-autopair.pname;
        src = sources.fish-autopair.src;
      }
    ];
  };

}
