{ pkgs, ... }:
let
  # tmux起動時にfishを使う。設定しないデフォルトシェル(zsh)が使われてしまう。
  extraConfigDefaultShell = ''
    set-option -g default-shell ${pkgs.fish}/bin/fish
  '';

  extraConfigReroadConfig = ''
    bind r source-file "$XDG_CONFIG_HOME/tmux/tmux.conf" \; display "Reloaded!"
    set -g status-position top
  '';

  extraConfigStatusLine = ''
    # 左側の長さ(デフォルトは10)
    set -g status-left-length 50
    # ウィンドウリストを中央配置
    set-option -g status-justify centre
  '';

  # フルカラーサポート
  # https://apribase.net/2025/05/28/term-terminfo/
  extraConfigTerminalFeatures = ''
    set -as terminal-features ",alacritty:RGB,xterm-ghostty:RGB,foot:RGB,wezterm:RGB"
  '';

  # Claude CodeでShift+Enterで改行できるようにする
  # https://blog.bobuhiro11.net/en/2026/02-27-shift-enter.html
  extraConfigClaudeCode = ''
    bind-key -n S-Enter send-keys -l "[13;2u"
  '';

in
{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    focusEvents = true;
    historyLimit = 10000;
    keyMode = "emacs";
    mouse = true;
    prefix = "C-t";
    terminal = "screen-256color";

    plugins = [
      pkgs.tmuxPlugins.pain-control
      {
        plugin = pkgs.tmuxPlugins.tmux-colors-solarized;
        extraConfig = ''
          set -g @colors-solarized 'dark'
        '';
      }
    ];
    extraConfig =
      extraConfigDefaultShell
      + extraConfigReroadConfig
      + extraConfigStatusLine
      + extraConfigTerminalFeatures
      + extraConfigClaudeCode;
  };

  # セッションをいい感じに扱える
  # https://github.com/joshmedeski/sesh
  programs.sesh = {
    enable = true;
    icons = true;
    tmuxKey = "S";
    enableTmuxIntegration = true;
  };
}
