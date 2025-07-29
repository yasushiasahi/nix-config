{ sources, config, ... }:
let
  initExtraFirstHomebrew = ''
    eval "$(/opt/homebrew/bin/brew shellenv)"
  '';

  # emacs misttyの設定
  # https://mistty.readthedocs.io/en/latest/shells.html#directory-tracking-in-zsh
  initExtraMistty = ''
    function osc7_precmd() {
      printf "\e]7;file://%s%s\e\\\\" "$HOSTNAME" "$PWD"
    }
    precmd_functions+=(osc7_precmd)
  '';

  # fzfでabbrを選択する
  initExtraPickAbbr = ''
    function my_pick_abbr() {
      BUFFER=$(abbr list | sed -E 's/"(.*)"="(.*)"/\1 -> \2/' | fzf-tmux -p 60%,60% --border-label ' abbr ' | sed -E 's/.*-> (.*)/\1 /')
      CURSOR=$((''${#BUFFER} / 1))
    }
    zle -N my_pick_abbr
    bindkey "^j" my_pick_abbr
  '';
in
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      rm = "trash";
    };
    autocd = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=#585858";
    };
    defaultKeymap = "emacs";
    dotDir = config.xdg.configHome + "/zsh";
    history = {
      ignoreAllDups = true;
      save = 10000;
      share = true;
      size = 10000;
    };
    historySubstringSearch.enable = true;
    initContent = initExtraFirstHomebrew + initExtraMistty + initExtraPickAbbr;
    oh-my-zsh = {
      enable = true;
      plugins = [ "aws" ];
      theme = "robbyrussell";
    };
    plugins = [
      {
        name = "zsh-autocomplete";
        src = sources.zsh-autocomplete.src;
      }
      {
        name = "zsh-npm-scripts-autocomplete";
        src = sources.zsh-npm-scripts-autocomplete.src;
      }
      {
        name = "enhancd";
        src = sources.zsh-enhancd.src;
        file = "init.sh";
      }
    ];
    syntaxHighlighting.enable = true;
    zsh-abbr = {
      enable = true;
    };
  };
}
