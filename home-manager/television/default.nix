{ ... }:
{
  programs.television = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      default_channel = "ghq";
      shell = "fish";
      ui = {
        ui_scale = 95;
        theme = "solarized-dark";
      };
      keybindings = {
        ctrl-g = "quit";
        ctrl-q = "toggle_remote_control";
        ctrl-h = "delete_prev_char";
        backspace = "toggle_help";
      };
      shell_integration.keybindings = {
        "smart_autocomplete" = "ctrl-j";
      };
    };
    channels = {
      ghq = {
        metadata = {
          description = "A channel to select git repository directories";
          name = "ghq";
          requirements = [
            "ghq"
            "bat"
            "eza"
            "sesh"
          ];
        };
        source = {
          command = "ghq list --full-path";
          # なんか設定しても効かない
          # output = "{upper}";
          # output = "{split://:0..2|join: and }";
        };
        preview = {
          command = [
            "eza --tree --sort=type --reverse --git-ignore --level 2 --color always --icons always {}"
            "[ -f {}/README.md ] && bat -n --color=always --theme \"Solarized (dark)\" {}/README.md || echo \"No README.md File!!\""
          ];
        };
        keybindings = {
          enter = "actions:new_session";
        };
        actions = {
          new_session = {
            description = "Start new tmux session";
            command = "sesh connect '{}'";
            mode = "execute";
          };
          cd = {
            description = "cd to dir";
            command = "cd '{}'";
            mode = "execute";
          };
        };
      };
    };
  };
}
