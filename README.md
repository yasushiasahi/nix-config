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
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```
### clone this repository
```
git clone https://github.com/yasushiasahi/nix-config.git
```
### update home-manager
```
nix run home-manager/master -- switch --flake .#home
```
### update nix-darwin
```
nix run nix-darwin/master#darwin-rebuild -- switch --flake .#darwin
```



