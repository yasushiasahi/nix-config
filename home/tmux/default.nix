{ pkgs, ... }:
let
  tmux-mighty-scroll = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "mighty-scroll";
    version = "unstable-2024-11-09";
    src = pkgs.fetchFromGitHub {
      owner = "noscript";
      repo = "tmux-mighty-scroll";
      rev = "c34808da912a6b4530d1c9dec8338757b6ec505a";
      sha256 = "sha256-Osg/TqNxnsVhDEm+i8scjAbevS0qSXaay57I9fwujAQ=";
    };
  };
  tmux-prefix-highlight = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "prefix-highlight";
    version = "unstable-2025-3-01";
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-prefix-highlight";
      rev = "06cbb4ecd3a0a918ce355c70dc56d79debd455c7";
      sha256 = "sha256-wkMm2Myxau24E0fbXINPuL2dc8E4ZYe5Pa6A0fWhiw4=";
    };
  };
  tmux-autoreload = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "autoreload";
    version = "unstable-2022-1-13";
    src = pkgs.fetchFromGitHub {
      owner = "b0o";
      repo = "tmux-autoreload";
      rev = "e98aa3b74cfd5f2df2be2b5d4aa4ddcc843b2eba";
      sha256 = "sha256-9Rk+VJuDqgsjc+gwlhvX6uxUqpxVD1XJdQcsc5s4pU4=";
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

    # # プラグイン？
    # # tmuxinator.enable
    # # tmuxp.enable

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
      tmux-mighty-scroll
      tmux-autoreload
      {
        plugin = tmux-prefix-highlight;
        extraConfig = ''
          set -g status-right '#{prefix_highlight} | %a %Y-%m-%d %H:%M'
        '';
      }
    ];
    extraConfig = ''
      bind r source-file "$XDG_CONFIG_HOME/tmux/tmux.conf" \; display "Reloaded!"
      set -g status-position top      
    '';
  };
}
