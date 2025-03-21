{ ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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

  programs.git.ignores = [
    ".envrc"
    ".dir-locals.nix"
  ];
}
