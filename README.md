# My Nix Configuration for Mac OS

## Initial set up
### install xcode tools(git, etc)
```
xcode-select --install
```
### install homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
### install nix
```
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```
### clone this repository
```
git clone https://github.com/yasushiasahi/nix-config.git
```
### update home-manager
```
nix run nixpkgs#nvfetcher
nix run home-manager/master -- switch --flake .#home
```
### update nix-darwin
```
nix run nix-darwin/master#darwin-rebuild -- switch --flake .#darwin
```



