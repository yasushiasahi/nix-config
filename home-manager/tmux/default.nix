{ pkgs, ... }:
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
    extraConfig = ''
      bind r source-file "$XDG_CONFIG_HOME/tmux/tmux.conf" \; display "Reloaded!"
      set -g status-position top

      # nix storeに入れてしまうとなぜか動かないので、一時凌ぎ。
      run-shell $XDG_DATA_HOME/tmux/plugins/tmux-which-key/plugin.sh.tmux
    '';
  };
}
