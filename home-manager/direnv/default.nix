{ mkAbbr, ... }:
let
  abbr = mkAbbr {
    dgie = "echo '.dir-locals-2.el\n.envrc\nshell.nix' >> .git/info/exclude";
  };
in
{
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      # direnvが作るキャッシュ(.direnv/)をプロジェクトフォルダに作らないようにする
      # https://github.com/direnv/direnv/wiki/Customizing-cache-location
      stdlib = ''
        : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            local hash path
            echo "''${direnv_layout_dirs[$PWD]:=$(
                hash="$(sha1sum - <<< "$PWD" | head -c40)"
                path="''${PWD//[^a-zA-Z0-9]/-}"
                echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
            )}"
        }
      '';
    };
  } // abbr;
}
