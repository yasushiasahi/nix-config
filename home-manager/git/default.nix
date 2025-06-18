{ mkAbbr, ... }:
let
  abbr = mkAbbr {
    gst = "git status";
    gsw = "git switch";
    gswc = "git switch -c";
    gchd = "git checkout -- .";
    gpu = "git pull";
    gloo = "git log --oneline | head";
    gcl = "git clean -fd";
  };
in
{
  programs = {
    git = {
      enable = true;
      ignores = [
        ".DS_Store"
        ".claude/settings.local.json"
        "CLAUDE.local.md"
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
