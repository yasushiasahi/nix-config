{ pkgs, ... }:
{
  # Node.js を有効化（バージョンを固定したい場合は package を指定）
  languages.javascript = {
    enable = true;
    package = pkgs.nodejs-slim_24;
    npm.enable = true;
    # pnpm.enable = true;
  };
}
