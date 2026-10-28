{ pkgs, ... }:
{
  programs.awscli.enable = true;

  home.packages = [
    # awscli(v1)はテスト時にしか使われないが、nixpkgs側でbotocoreとの
    # バージョン不整合によりビルドが壊れているためテストを無効化する
    (pkgs.git-remote-codecommit.overridePythonAttrs { doCheck = false; })
    pkgs.tenv
    pkgs.ssm-session-manager-plugin
  ];
}
