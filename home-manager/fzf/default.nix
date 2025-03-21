{ ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    defaultCommand = "fd --type f";
    fileWidgetCommand = "fd --type f";
    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [
      "--preview 'eza --tree --sort=type --reverse --git-ignore  {} | head -200'"
    ];
    tmux.enableShellIntegration = true;
  };

  # 色の設定
  # https://github.com/junegunn/fzf/wiki/Color-schemes#solarized-dark
  home.sessionVariables.FZF_DEFAULT_OPTS = ''
    --color dark,hl:33,hl+:37,fg+:235,bg+:136,fg+:254
    --color info:254,prompt:37,spinner:108,pointer:235,marker:235
  '';
}
