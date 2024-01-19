#!/usr/bin/env bash

if which aws-vault > /dev/null && [ -n "$AWS_PROFILE" ]; then
  echo "rotating aws keys..."
  aws-vault rotate "$AWS_PROFILE"
fi

echo "vim..."
vim -c 'call execute("PlugUpdate") | echo "Go Update..." | call execute("GoUpdateBinaries") | qa'

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
