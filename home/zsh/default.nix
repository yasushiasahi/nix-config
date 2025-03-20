{ pkgs, ... }:
let
  initExtra = builtins.readFile ./init-extra.sh;
in
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      rm = "trash";
    };
    autocd = true;
    autosuggestion.enable = true;
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";
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
    initExtra = initExtra;
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
      abbreviations = {
        di = "nix flake init -t github:nix-community/nix-direnv";
        ds = "darwin-rebuild switch --flake ~/ghq/github.com/yasushiasahi/nix-config#darwin";
        hs = "home-manager switch --flake ~/ghq/github.com/yasushiasahi/nix-config#home";
      };
    };
  };
}
