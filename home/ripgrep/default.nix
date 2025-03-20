{ ... }:
{
  programs.ripgrep = {
    enable = true;
    arguments = [
      # Don't let ripgrep vomit really long lines to my terminal, and show a preview.
      "--max-columns-preview"

      # Add my 'web' type.
      "--type-add=web:*.{html,css,js}*"

      # Search hidden files / directories (e.g. dotfiles) by default
      "--hidden"

      # Using glob patterns to include/exclude files or folders
      "--glob=!.git/*"

      # Set the colors.
      "--colors=line:none"
      "--colors=line:style:bold"

      # Because who cares about case!?
      "--smart-case"
    ];
  };
}
