{ pkgs, mkAlias, ... }:
let
  shellAlias = mkAlias {
    emacs = "${pkgs.emacs}/Applications/Emacs.app/Contents/MacOS/Emacs";
  };
in
{
  programs = {
    emacs = {
      enable = true;
      # TODO emacs ns-inline-patchを当てたい
      # https://apribase.net/2024/06/21/emacs-as-daemon-for-mac/
      # package = pkgs.emacs.overrideAttrs (old: {
      #   patches = (old.patches or [ ]) ++ [
      #     (pkgs.fetchpatch {
      #       url = "https://raw.githubusercontent.com/takaxp/ns-inline-patch/master/emacs-29.1-inline.patch";
      #       sha256 = "sha256-UQsYJ9+6XgB7NSCmup4RzDn3NlR8vMKsQGJPYYqsgmU=";
      #     })
      #   ];
      # });
    };

    git.ignores = [
      ".dir-locals.el"
    ];
  } // shellAlias;

  home.packages = [
    pkgs.emacs-lsp-booster

    # lsp
    pkgs.nodePackages.typescript
    pkgs.nodePackages.typescript-language-server
    pkgs.astro-language-server
    pkgs.yaml-language-server
    pkgs.tailwindcss-language-server
    pkgs.dockerfile-language-server-nodejs
    pkgs.vscode-langservers-extracted
    pkgs.nil
  ];

  xdg.configFile = {
    "emacs/init.el".source = ./init.el;
    "emacs/early-init.el".source = ./early-init.el;
    "emacs/etc/templates".source = ./etc/templates;
    "emacs/etc/transient/values.el".source = ./etc/transient/values.el;
  };

  # home.file = {
  #   ".config/emacs/init.el".source = ./init.el;
  #   ".config/emacs/early-init.el".source = ./early-init.el;
  #   ".config/emacs/etc/templates".source = ./etc/templates;
  #   ".config/emacs/etc/transient/values.el".source = ./etc/templates;
  # };

  # home.file = {
  #   ".emacs.d/init.el".source = ./init.el;
  #   ".emacs.d/early-init.el".source = ./early-init.el;
  #   ".emacs.d/etc/templates".source = ./etc/templates;
  #   ".emacs.d/etc/transient/values.el".source = ./etc/templates;
  # };

  # xdg = {
  #   configFile = {
  #     "emacs/init.el".source = ./init.el;
  #     "emacs/early-init.el".source = ./early-init.el;
  #     "emacs/etc/templates".source = ./etc/templates;
  #     "emacs/etc/transient/values.el".source = ./etc/templates;
  #   };
  # };

  # TODO emacs demon? client? service
  # 設定するべきなのか？するとして何を設定するべきなのか不明。
  # https://apribase.net/2024/06/21/emacs-as-daemon-for-mac/ Mac に正しくフレーム管理される Emacs as Daemon を起動する
  # https://github.com/takeokunn/nixos-configuration/blob/main/home-manager/services/emacs/default.nix takeokunn/nixos-configuration
}
