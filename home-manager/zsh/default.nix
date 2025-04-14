{ pkgs, ... }:
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
    dotDir = ".config/zsh";
    history = {
      ignoreAllDups = true;
      save = 10000;
      share = true;
      size = 10000;
    };
    historySubstringSearch.enable = true;
    initExtraFirst = initExtraFirstHomebrew;
    initExtra = initExtraMistty + initExtraPickAbbr;
    oh-my-zsh = {
      enable = true;
      plugins = [ "aws" ];
      theme = "robbyrussell";
    };
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
      {
        name = "enhancd";
        file = "init.sh";
        src = pkgs.fetchFromGitHub {
          owner = "babarot";
          repo = "enhancd";
          rev = "5afb4eb6ba36c15821de6e39c0a7bb9d6b0ba415";
          sha256 = "sha256-pKQbwiqE0KdmRDbHQcW18WfxyJSsKfymWt/TboY2iic=";
        };
      }
    ];
    syntaxHighlighting.enable = true;
    zsh-abbr = {
      enable = true;
    };
  };
}
