# emacs eatで使用する。
{ ... }:
{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && source "$EAT_SHELL_INTEGRATION_DIR/bash"
    '';
  };
}
