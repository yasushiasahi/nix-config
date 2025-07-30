{ pkgs, ... }:
let
  tmuxPath = "${pkgs.tmux}/bin/tmux";
in
{
  programs.alacritty = {
    enable = true;
    package = (pkgs.writeShellScriptBin "alacritty-mock" "true");
    settings = {
      window = {
        decorations = "Transparent";
        padding = {
          x = 8;
          y = 24;
        };
        option_as_alt = "Both";
        dynamic_padding = true;
        resize_increments = true;
      };
      scrolling.history = 100000;
      font = {
        normal.family = "HackGen Console NF";
        size = 13;
      };
      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
        vi_mode_style = {
          shape = "Block";
          blinking = "Off";
        };
        unfocused_hollow = true;
      };
      terminal.shell = {
        program = "${pkgs.fish}/bin/fish";
        args = [
          "-l"
          "-c"
          "${tmuxPath} a -t scratch || ${tmuxPath} new -s scratch"
        ];
      };
      colors = {
        primary = {
          background = "#002b36";
          foreground = "#839496";
        };
        normal = {
          black = "#073642";
          red = "#dc322f";
          green = "#859900";
          yellow = "#b58900";
          blue = "#268bd2";
          magenta = "#d33682";
          cyan = "#2aa198";
          white = "#eee8d5";
        };
        bright = {
          black = "#002b36";
          red = "#cb4b16";
          green = "#586e75";
          yellow = "#657b83";
          blue = "#839496";
          magenta = "#6c71c4";
          cyan = "#93a1a1";
          white = "#fdf6e3";
        };
        search = {
          matches = {
            foreground = "#002b36";
            background = "#859900";
          };
          focused_match = {
            foreground = "#002b36";
            background = "#b58900";
          };
        };
      };

      keyboard.bindings = [
        {
          key = "Plus";
          mods = "Command";
          action = "IncreaseFontSize";
        }
        {
          key = "Minus";
          mods = "Command";
          action = "DecreaseFontSize";
        }
        {
          key = "Key0";
          mods = "Command";
          action = "ResetFontSize";
        }
        {
          key = "Return";
          mods = "Command";
          action = "ToggleFullscreen";
        }
      ];

      selection = {
        save_to_clipboard = true;
        semantic_escape_chars = ",│`|:\"' ()[]{}<>\t";
      };

      # hints = {
      #   enabled = [
      #     {
      #       regex = "(ipfs:|ipns:|magnet:|mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)[^\\u0000-\\u001F\\u007F-\\u009F<>\"\\s{-}\\^⟨⟩`]+";
      #       command = "open";
      #       post_processing = true;
      #       mouse = {
      #         enabled = true;
      #         mods = "Command";
      #       };
      #     }
      #   ];
      # };

      bell = {
        animation = "EaseOutExpo";
        duration = 100;
        color = "#ffffff";
        command = "None";
      };

      mouse = {
        bindings = [
          {
            mouse = "Middle";
            action = "PasteSelection";
          }
        ];
      };
    };
  };
}
