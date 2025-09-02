#!/usr/bin/env zsh

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
tee ~/.gitlocal >/dev/null <<EOF
[user]
  name = Matthew
  email = spamed@matthew.nz
EOF
vim ~/.gitlocal

echo "vim-rhubarb requires repo permissions"
echo "plugin: https://github.com/tpope/vim-rhubarb"
echo "tokens: https://github.com/settings/tokens"
echo "editing .netrc config in vim 🤔, press enter to continue..."
read -r
tee ~/.netrc >/dev/null <<EOF
machine api.github.com
  login heymatthew
  password <TOKEN from https://github.com/settings/tokens/new>
EOF
vim ~/.netrc

echo "installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "brew bundle..."
/opt/homebrew/bin/brew bundle

echo "removing .DS_Store files in softlinks"
find softlinks -name ".DS_Store" -depth -exec rm -f {} \;

echo "stowing dotfiles..."
mkdir ~/.config
/opt/homebrew/bin/stow -vv softlinks

echo "source updated zshrc..."
source ~/.zshrc

echo "creating log dir..."
mkdir "$HOME/log"

echo "templating gitmessage..."
cp templates/gitmessage ~/.gitmessage

echo "configuring exercism..."
echo "go here: https://exercism.org/settings/api_cli"
read -r -p  "what is your exercism token? " exercism_token
echo exercism configure --token="$exercism_token"

echo "installing julia packages..."
script_dir=$(dirname "${BASH_SOURCE[0]}")
/opt/homebrew/bin/julia "$script_dir/julia-setup.jl"

echo "Installing vale linters..."
vale sync

echo "installing vim/nvim plugins..."
/opt/homebrew/bin/nvim -c "call UpdateEverything() | qa"
/opt/homebrew/bin/vim -c "call UpdateEverything() | qa"

echo "removing 'Last login: $DATEETIME on ttys000' from new windows"
touch ~/.hushlogin

echo "Your public ssh key is stored in ~/.ssh/id_ed25519.pub"
cat ~/.ssh/id_ed25519.pub

echo "Starting background services"
brew services start syncthing

echo "TODO:
* Copy over ~/.ssh/config
* Add ssh key to https://github.com/settings/keys
* Add ssh key to https://gitlab.com/-/profile/keys
* Add ssh key to remote hosts ~/.ssh/authorized_keys
* Set FEATURE_PREFIX to feature if required
* Run crontab -e and set:
    # Hourly from Monday through Friday
    0 * * * 1-5 ~FIXME/bin/sync-git
    # Daily at Midday
    0 12 * * * /opt/homebrew/sbin/logrotate -s ~FIXME/logrotate.status ~FIXME/dotfiles/config/logrotate.conf
* Bump inotify limits for entr http://eradman.com/entrproject/limits.html
* Skim MacOS Security & Privacy Guide https://github.com/drduh/macOS-Security-and-Privacy-Guide
* Firefox
  * Set language to English (GB)
  * Set sync Device Name to '$hostname' about:preferences#sync
  * Update ctrl tab to 'sort by recently used'
    about:config > browser.ctrlTab.sortByRecentlyUsed > true
    about:config > browser.tabs.insertRelatedAfterCurrent true
* Set Syncthing Device Name to '$hostname' http://localhost:8384/
* Set hidden menu with minimalist menu bar
* Set API token in Exercism
  * https://exercism.io/my/settings
  * exercism configure --token=YOUR_TOKEN
* Finish setting up postgres from brew
  * brew link postgresql@15
  * brew services start postgresql@15
* Add repos with 'mr register XYZ'
* Setup github cli with 'gh auth login'
* Setup asdf
  * asdf plugin add nodejs
  * asdf plugin add yarn
  * asdf plugin add ruby
"
