{ nodePkgs, ... }:

{
  home = {
    packages = [ nodePkgs."@anthropic-ai/claude-code" ];

    file = {
      ".claude/settings.json".source = ./settings.json;
      ".claude/CLAUDE.md".source = ./CLAUDE.md;
    };
  };
}
