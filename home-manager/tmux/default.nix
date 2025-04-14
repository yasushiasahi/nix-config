{ pkgs, ... }:
let
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

  # ghqから選択してtmuxのsessionを作る
  extraConfigSeshFromGhq = ''
    bind-key "P" run-shell "sesh connect \"$(ghq list | fzf-tmux -p 60%,60% --border-label ' select project ' --prompt='Create new session from > ' --preview='eza --icons always --color always --git-ignore --tree --level=2 $(ghq root)/{1}')\"";
  '';

  # tmux-which-key
  # nix storeに入れてしまうとなぜか動かないので、一時凌ぎ。
  extraConfigTmuxWhichKey = ''
    run-shell $XDG_DATA_HOME/tmux/plugins/tmux-which-key/plugin.sh.tmux
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
      pkgs.tmuxPlugins.tmux-fzf
      pkgs.tmuxPlugins.extrakto
      {
        plugin = pkgs.tmuxPlugins.tmux-colors-solarized;
        extraConfig = ''
          set -g @colors-solarized 'dark'
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.prefix-highlight;
        extraConfig = ''
          set -g status-right '#{prefix_highlight} | %a %Y-%m-%d %H:%M'
        '';
      }
    ];
    extraConfig =
      extraConfigReroadConfig + extraConfigStatusLine + extraConfigSeshFromGhq + extraConfigTmuxWhichKey;
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
