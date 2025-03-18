{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      emacs = "${pkgs.emacs}/Applications/Emacs.app/Contents/MacOS/Emacs";
      rm = "trash";
    };
    autocd = true;
    autosuggestion.enable = true;
    completionInit = ''
      # aws cliの補完を効かせる。
      # https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html#cli-command-completion-enable
      autoload bashcompinit && bashcompinit
      # デフォルトの設定
      autoload -U compinit && compinit
    '';
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    # envExtra = ".zshenvに加えたい何か加えたい時に書く"
    history = {
      ignoreAllDups = true;
      save = 10000;
      share = true;
      size = 10000;
    };
    historySubstringSearch.enable = true;
    initExtraFirst = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
    initExtra = ''
      complete -C '${pkgs.awscli2}/bin/aws_completer' aws
    '';
    # loginExtra = .zlogin
    plugins = [
      {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "24.09.04";
          sha256 = "sha256-o8IQszQ4/PLX1FlUvJpowR2Tev59N8lI20VymZ+Hp4w=";
        };
      }
      {
        name = "zsh-npm-scripts-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "grigorii-zander";
          repo = "zsh-npm-scripts-autocomplete";
          rev = "5d145e13150acf5dbb01dac6e57e57c357a47a4b";
          sha256 = "sha256-Y34VXOU7b5z+R2SssCmbooVwrlmSxUxkObTV0YtsS50=";
        };
      }

    ];
    syntaxHighlighting.enable = true;
    zsh-abbr = {
      enable = true;
      abbreviations = {
        ll = "eza -alh --icons always --color always --git";
        lt = "eza --tree --sort=type --reverse --git-ignore";
        di = "nix flake init -t github:nix-community/nix-direnv ";
        ds = "darwin-rebuild switch --flake .#darwin";
        hs = "home-manager switch --flake .#home";
      };
    };
  };
}
