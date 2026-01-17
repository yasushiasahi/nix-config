{ pkgs, ... }:
let
  gapSize = 0;
in
{
  programs.aerospace = {
    enable = true;
    package = (pkgs.writeShellScriptBin "aerospace-mock" "true");
    settings = {
      config-version = 2;
      # 運用が固まってから設定する
      # persistent-workspaces = [
      #   "1"
      #   "2"
      #   "3"
      #   "4"
      #   "5"
      #   "6"
      #   "7"
      #   "8"
      #   "9"
      # ];

      gaps = {
        inner.horizontal = gapSize;
        inner.vertical = gapSize;
        outer.left = gapSize;
        outer.bottom = gapSize;
        outer.top = gapSize;
        outer.right = gapSize;
      };

      mode.main.binding = {
        # See: https://nikitabobko.github.io/AeroSpace/commands#layout
        cmd-alt-ctrl-backspace = "layout tiles horizontal vertical";
        cmd-alt-ctrl-slash = "layout accordion horizontal vertical";

        # See: https://nikitabobko.github.io/AeroSpace/commands#focus
        cmd-alt-ctrl-h = "focus left";
        cmd-alt-ctrl-j = "focus down";
        cmd-alt-ctrl-k = "focus up";
        cmd-alt-ctrl-l = "focus right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move
        cmd-alt-ctrl-shift-h = "move left";
        cmd-alt-ctrl-shift-j = "move down";
        cmd-alt-ctrl-shift-k = "move up";
        cmd-alt-ctrl-shift-l = "move right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#resize
        cmd-alt-ctrl-minus = "resize smart -100";
        cmd-alt-ctrl-equal = "resize smart +100";

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
        cmd-alt-ctrl-1 = "workspace 1";
        cmd-alt-ctrl-2 = "workspace 2";
        cmd-alt-ctrl-3 = "workspace 3";
        cmd-alt-ctrl-4 = "workspace 4";
        cmd-alt-ctrl-5 = "workspace 5";
        cmd-alt-ctrl-6 = "workspace 6";
        cmd-alt-ctrl-7 = "workspace 7";
        cmd-alt-ctrl-8 = "workspace 8";
        cmd-alt-ctrl-9 = "workspace 9";

        cmd-alt-ctrl-rightSquareBracket = "workspace next";
        cmd-alt-ctrl-leftSquareBracket = "workspace prev";
        cmd-alt-ctrl-comma = "focus-monitor left";
        cmd-alt-ctrl-period = "focus-monitor right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
        cmd-alt-ctrl-shift-1 = "move-node-to-workspace 1";
        cmd-alt-ctrl-shift-2 = "move-node-to-workspace 2";
        cmd-alt-ctrl-shift-3 = "move-node-to-workspace 3";
        cmd-alt-ctrl-shift-4 = "move-node-to-workspace 4";
        cmd-alt-ctrl-shift-5 = "move-node-to-workspace 5";
        cmd-alt-ctrl-shift-6 = "move-node-to-workspace 6";
        cmd-alt-ctrl-shift-7 = "move-node-to-workspace 7";
        cmd-alt-ctrl-shift-8 = "move-node-to-workspace 8";
        cmd-alt-ctrl-shift-9 = "move-node-to-workspace 9";

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
        cmd-alt-ctrl-tab = "workspace-back-and-forth";
        # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
        cmd-alt-ctrl-shift-tab = "move-workspace-to-monitor --wrap-around next";
      };
    };
  };
}
