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
    # NOTE: programs.fish.binds は home-manager 側の型定義が
    # `type // { check = ...; }` を使っており、nixpkgs の module system v2 merge
    # と非互換でエラーになるため、生成結果と同等の関数を直接定義している
    functions.fish_user_key_bindings = ''
      bind ctrl-t 'tv'
      bind ctrl-j 'tv_smart_autocomplete'
    '';
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
