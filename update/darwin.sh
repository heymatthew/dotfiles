#!/usr/bin/env bash

echo "vim..."
vim -c "call execute('PlugUpdate') | call execute('GoInstallBinaries') | qa"

echo "npm..."
npm install -g npm # update npm itself
npm update -g      # update global packages

echo "julia..."
julia -e 'using Pkg; Pkg.update()'

echo "brew..."
brew upgrade
brew upgrade --cask
brew cleanup
brew doctor

echo "macOS..."
echo "This command appears to freeze:"
echo "> softwareupdate --install --all"
echo "...try updating manually instead"
# system('sudo softwareupdate --install --all')
