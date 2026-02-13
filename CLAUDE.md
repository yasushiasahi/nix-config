# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

Personal Nix configuration for macOS (aarch64-darwin / Apple Silicon). It manages:
- **System-level settings** via nix-darwin (fonts, homebrew, keyboard, dock, finder, security)
- **User environment** via Home Manager (shell, editor, dev tools, dotfiles)

## Build / Apply Commands

```bash
# Apply nix-darwin (system-level) changes
sudo darwin-rebuild switch --flake .#darwin

# Apply Home Manager (user-level) changes
home-manager switch --flake .#home

# Update external sources before switching (required when nvfetcher.toml changes)
nix run nixpkgs#nvfetcher

# Full Home Manager update workflow
nix run nixpkgs#nvfetcher && home-manager switch --flake .#home

# Update all flake inputs
nix flake update

# Format Nix files
nixfmt <file.nix>
```

## Architecture

### Flake Structure (`flake.nix`)

Two main outputs:
- `darwinConfigurations.darwin` → loads `./nix-darwin/default.nix`
- `homeConfigurations.home` → loads `./home-manager/default.nix`

Key overlays: `emacs-overlay` for bleeding-edge Emacs, `tangleOrgBabel` for Org-mode → Elisp tangling.

### Home Manager Module Pattern

Each program lives in `home-manager/<program>/default.nix`. Modules receive shared helpers via `extraSpecialArgs`:
- `mkAlias { name = "cmd"; }` — sets shell aliases in **both** zsh and fish
- `mkAbbr { name = "cmd"; }` — sets shell abbreviations in **both** zsh and fish
- `sources` — nvfetcher-generated external package sources (accessed as `sources.<name>.src`, `sources.<name>.pname`)

A custom option `config.nix-config` provides the path to this repository for modules that need to reference source files.

### External Package Fetching (nvfetcher)

Packages not available in nixpkgs are declared in `nvfetcher.toml` and fetched into `_sources/`. Categories:
- `emacs-*` — Emacs packages built via `epkgs.melpaBuild`
- `fish-*` — Fish shell plugins
- `zsh-*` — Zsh plugins

After editing `nvfetcher.toml`, run `nix run nixpkgs#nvfetcher` to regenerate `_sources/generated.nix`.

### Emacs Configuration

Emacs config is written as **Org-mode literate files** (`home-manager/emacs/init.org`, `early-init.org`) and tangled to Elisp at Nix build time via `pkgs.tangleOrgBabel`. Custom packages are built from nvfetcher sources using `epkgs.melpaBuild`.

### Claude Code Configuration

`home-manager/claude-code/default.nix` manages the Claude Code setup declaratively via Home Manager, including:
- Global CLAUDE.md (deployed as `~/.claude/CLAUDE.md`)
- Custom agents (`agents/`), commands (`commands/`), hooks (`hooks/`)
- MCP servers (context7, serena) via `mcp-servers-nix`

### Templates

`templates/dir-locals/` — A flake template for project-local dev environments (shell.nix + .envrc + .dir-locals-2.el). Use with `nix flake init -t .#dir-locals`.

## Conventions

- Japanese comments are used throughout for documentation
- `nixfmt` is the Nix formatter
- `nixpkgs-unstable` channel is used (not stable)
- `home.stateVersion = "24.11"` — do not change without reading release notes
- Git default branch is `main`; `push.autoSetupRemote = true` is enabled
