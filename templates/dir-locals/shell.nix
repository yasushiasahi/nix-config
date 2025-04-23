{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = [
    # pkgs.nodejs_18
    # pkgs.nodejs_20
    # pkgs.nodejs_22
    # pkgs.yarn
    # pkgs.pnpm
  ];
  # shellHook = ''
  # 	echo "hello dir-local development!!"
  # '';
}
