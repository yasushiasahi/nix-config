#!/bin/bash

echo "install xcode tools ..."
xcode-select --install
echo "xcode tools installed"

echo "install homebrew ..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "homebrew installed"

echo "install nix ..."
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
echo "nix installed"

echo "update home-manager ..."
nix run home-manager/master -- switch --flake .#home
echo "home-manager updated"

echo "update nix-darwin ..."
nix run nix-darwin/master#darwin-rebuild -- switch --flake .#darwin
echo "nix-darwin updated"

