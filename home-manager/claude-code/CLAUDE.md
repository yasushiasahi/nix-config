# Global instructions

## 開発ツールが PATH にない場合

`node` / `npm` / `pnpm` / `python` などの開発ツールが見つからない (`command not found` など) ときは、グローバルにインストールしようとせず、まずプロジェクトの devenv を確認する。

- プロジェクトルート (またはその親) に `devenv.nix` / `devenv.yaml` / `.envrc` (`use devenv`) があるか確認する。
- devenv があれば、そのツールは devenv が提供している。Bash ツールでは direnv が効かないため、`devenv shell <cmd> [args...]` で実行する (例: `devenv shell npm run build`)。
- 必要なツールが `devenv.nix` に定義されていない場合は、勝手に追加せずユーザーに確認する。
