#!/usr/bin/env bash

script_dir=$(dirname "$0")
cd "$script_dir" || exit 1

if which aws-vault > /dev/null && [ -n "$AWS_PROFILE" ]; then
  echo "rotating aws keys..."
  aws-vault rotate "$AWS_PROFILE"
fi

echo "neovim plugins..."
nvim -c 'call execute("PlugUpdate") | echo "Go Update..." | call execute("GoUpdateBinaries") | qa'

echo "restowing dotfiles..."
/opt/homebrew/bin/stow -v softlinks

echo "update prose linter..."
vale sync

echo "julia..."
julia -e 'using Pkg; Pkg.update()'

echo "brew..."
brew bundle
brew upgrade
brew upgrade --cask
brew cleanup
brew doctor

echo "macOS..."
echo "This command appears to freeze:"
echo "> softwareupdate --install --all"
echo "...try updating manually instead"
# system('sudo softwareupdate --install --all')
