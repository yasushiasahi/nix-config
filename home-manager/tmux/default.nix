{ pkgs, ... }:
let
  tmux-mighty-scroll = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "mighty-scroll";
    rtpFilePath = "mighty-scroll.tmux";
    version = "unstable-2024-11-09";
    src = pkgs.fetchFromGitHub {
      owner = "noscript";
      repo = "tmux-mighty-scroll";
      rev = "c34808da912a6b4530d1c9dec8338757b6ec505a";
      sha256 = "sha256-Osg/TqNxnsVhDEm+i8scjAbevS0qSXaay57I9fwujAQ=";
    };
  };
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
      tmux-mighty-scroll
    ];
    extraConfig = ''
      bind r source-file "$XDG_CONFIG_HOME/tmux/tmux.conf" \; display "Reloaded!"
      set -g status-position top

      # nix storeに入れてしまうとなぜか動かないので、一時凌ぎ。
      run-shell $XDG_DATA_HOME/tmux/plugins/tmux-which-key/plugin.sh.tmux
    '';
  };
}
