{ mkAbbr, ... }:
let
  abbr = mkAbbr {
    gst = "git status";
    gsw = "git switch";
    gswc = "git switch -c";
    gchd = "git checkout -- .";
  };
in
{
  programs = {
    git = {
      enable = true;
      ignores = [
        ".DS_Store"
      ];
      userEmail = "asahi1600@gmail.com";
      userName = "Yasushi Asahi";
      extraConfig = {
        github = {
          user = "yasushiasahi";
        };
        init = {
          defaultBranch = "main";
        };
        push = {
          autoSetupRemote = true;
        };
      };
    };

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };

  } // abbr;
}
