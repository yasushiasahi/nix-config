{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    focusEvents = true;
    historyLimit = 10000;
    keyMode = "emacs";
    mouse = true;
    prefix = "C-t";
    plugins = [
      pkgs.tmuxPlugins.pain-control
      {
        plugin = pkgs.tmuxPlugins.tmux-colors-solarized;
        extraConfig = ''
          set -g @colors-solarized 'dark'
        '';
      }
    ];
    extraConfig = ''
      # tmux起動時にfishを使う。設定しないとデフォルトシェル(zsh)が使われてしまう。
      set-option -g default-shell ${pkgs.fish}/bin/fish

      # C-t rでコンフィグを再読み込みする
      bind r source-file "$XDG_CONFIG_HOME/tmux/tmux.conf" \; display "Reloaded!"

      # ステータスラインの設定
      set -g status-position top           # 上部に表示      
      set -g status-left-length 50         # 左側の長さ(デフォルトは10)      
      set-option -g status-justify centre  # ウィンドウリストを中央配置

      # フルカラーサポート。Alacritty + tmux情報がありすぎて決定版がわからない。暇があれば色々試す。
      # https://apribase.net/2025/05/28/term-terminfo/
      # https://zenn.dev/a24k/articles/20221027-alacritty-tmux
      set -g default-terminal "screen-256color"
      set -as terminal-features ",alacritty:RGB,xterm-ghostty:RGB"
      set -ag terminal-overrides ",alacritty:RGB,xterm-ghostty:RGB"
    '';
  };

  home.packages = [
    pkgs.sesh
  ];
}
