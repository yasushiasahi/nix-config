{ mkAbbr, pkgs, ... }:
let
  abbr = mkAbbr {
    dgie = "echo '.dir-locals-2.el\\n.envrc\\nshell.nix' >> .git/info/exclude";
    # 現在のフォルダに devenv の Node.js 環境を展開し、関連ファイルを .git/info/exclude に追加する
    dvn = "nix flake init -t github:yasushiasahi/nix-config#devenv-node && printf '%s\\n' .envrc .direnv devenv.nix devenv.yaml devenv.lock .devenv .devenv.flake.nix >> .git/info/exclude";
  };
in
{
  programs = {
    direnv = {
      enable = true;
      # Go 1.26でMakefileの-linkmode=externalとCGO_ENABLED=0が衝突するため、
      # buildPhaseをオーバーライドして回避する
      package = pkgs.direnv.overrideAttrs (old: {
        buildPhase = ''
          go build -ldflags '-X main.bashPath=${pkgs.bash}/bin/bash' -o direnv
        '';
      });
      nix-direnv.enable = true;
      silent = true;
      enableZshIntegration = true;
      # enableFishIntegration = true;
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
