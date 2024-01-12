#!/usr/bin/env bash

echo "testing superuser (password required)..."
sudo echo 'make me a Sandwich! https://xkcd.com/149' || exit 1

echo "setting hostname..."
read -r -p "what do you want your hostname to be? " hostname
read -r -p "what about the domain? " domain
sudo hostname -s "$hostname"
sudo scutil --set LocalHostName "$hostname"
sudo scutil --set ComputerName "$hostname"
sudo scutil --set HostName "$hostname.$domain"

echo "configuring ssh..."
ssh-keygen -t ed25519 -a 100 # See https://security.stackexchange.com/a/144044
echo "editing public key in vim 🤔, press enter to continue..."
read -r
vim ~/.ssh/id_ed25519.pub
echo "editing .ssh config.local in vim 🤔, press enter to continue..."
read -r
tee ~/.ssh/config.local >/dev/null <<EOF
# Local configuration
# https://linux.die.net/man/5/ssh_config
# Host xxx
#   User xxx
#   Port xxx
EOF
vim ~/.ssh/config.local

echo "templating git config..."
echo "editing git config in vim 🤔, press enter to continue..."
read -r
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
$julia_cmd "$script_dir/julia-setup.jl"

echo "installing vim/nvim plugins..."
/opt/homebrew/bin/nvim -c "call UpdateEverything() | qa"
/opt/homebrew/bin/vim -c "call UpdateEverything() | qa"

echo "removing 'Last login: $DATEETIME on ttys000' from new windows"
touch ~/.hushlogin

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
  * Set Profiles > * > Colors > Cursor Colors
  * Remap 'Close' to Cmd+Shift+W, System Settings > Keyboard Shortcuts > App Shortcuts
* Bump inotify limits for entr http://eradman.com/entrproject/limits.html
* Skim MacOS Security & Privacy Guide https://github.com/drduh/macOS-Security-and-Privacy-Guide
* Set Firefox sync Device Name to '$hostname' about:preferences#sync
* Set Syncthing Device Name to '$hostname' http://localhost:8384/
* Set hidden menu with minimalist menu bar
* Set API token in Exercism
  * https://exercism.io/my/settings
  * exercism configure --token=YOUR_TOKEN
* Finish setting up brew applications
  * brew link postgresql@15
  * brew services start postgresql@15
  * brew services start syncthing
* Add repos with 'mr register XYZ'
* Setup github cli with 'gh auth login'
* Setup asdf
  * https://github.com/asdf-vm/asdf-ruby
  * https://github.com/asdf-vm/asdf-nodejs
  * https://github.com/asdf-community/asdf-python
* Set github creds for Rhubarb
  - Create token https://github.com/settings/tokens/new
  - Update ~/.netrc with:
    machine api.github.com
      login heymatthew
      password <TOKEN>
"
