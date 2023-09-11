#!/usr/bin/env bash

set -euo pipefail

echo "testing superuser (password required)..."
sudo echo 'make me a Sandwich! https://xkcd.com/149' || exit 1

echo "setting hostname..."
read -p "what do you want your hostname to be? " hostname
sudo hostname -s $hostname
sudo scutil --set LocalHostName $hostname
sudo scutil --set ComputerName $hostname
sudo scutil --set HostName $hostname.matthew.nz

echo "creating ssh keys..."
ssh-keygen -t ed25519
echo "editing public key in vim 🤔, press enter to continue..."
read
vim ~/.ssh/id_ed25519.pub

echo "templating git config..."
echo "editing git config in vim 🤔, press enter to continue..."
read
tee ~/.gitconfig.local >/dev/null <<EOF
[user]
  name = Matthew B. Gray
  email = spamed@matthew.nz
EOF
vim ~/.gitconfig.local

echo "installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "brew bundle..."
/opt/homebrew/bin/brew bundle

echo "stowing dotfiles..."
/opt/homebrew/bin/stow softlinks

echo "installing npm packages..."
/opt/homebrew/bin/npm install -g write-good

echo "installing julia packages..."
script_dir=$(dirname $BASH_SOURCE)
$julia_cmd "$script_dir/julia-packages.jl"

echo "installing vim/nvim plugins..."
/opt/homebrew/bin/nvim -c "call UpdateEverything() | qa"
/opt/homebrew/bin/vim -c "call UpdateEverything() | qa"

echo "Your public ssh key is stored in ~/.ssh/id_ed25519.pub"
cat ~/.ssh/id_ed25519.pub

echo "TODO:
* Copy over ~/.ssh/config
* Add ssh key to https://github.com/settings/keys
* Add ssh key to https://gitlab.com/-/profile/keys
* Add ssh key to remote hosts ~/.ssh/authorized_keys
* iTerm2
  * Install Rosé Pine https://github.com/rose-pine/iterm
  * Create profiles 'dark' from moon and 'light' from dawn
  * Set M+ 1mn medium font, light:medium, dark:regular https://css-tricks.com/dark-mode-and-variable-fonts/
  * Bump scrollback to 25k
  * Set Appearance > General > Theme to 'Minimal'
  * Remap 'Close' to Cmd+Shift+W, System Settings > Keyboard Shortcuts > App Shortcuts
* Bump inotify limits for entr http://eradman.com/entrproject/limits.html
* Skim MacOS Security & Privacy Guide https://github.com/drduh/macOS-Security-and-Privacy-Guide
* Set Firefox sync Device Name to '$hostname' about:preferences#sync
* Set Syncthing Device Name to '$hostname' http://localhost:8384/
* Set API token in Exercism
  * https://exercism.io/my/settings
  * exercism configure --token=YOUR_TOKEN
* Finish setting up brew applications
  * brew link postgresql@15
  * brew services start postgresql@15
  * brew services start syncthing
* Add repos with 'mr register XYZ'"
