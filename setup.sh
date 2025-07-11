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
/opt/homebrew/bin/stow -vv softlinks

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
* Run crontab -e and set:
    # Hourly from Monday through Friday
    0 * * * 1-5 ~FIXME/bin/sync-git
    # Daily at Midday
    0 12 * * * /opt/homebrew/sbin/logrotate -s ~FIXME/logrotate.status ~FIXME/dotfiles/config/logrotate.conf
* iTerm2
  * Install Rosé Pine https://github.com/rose-pine/iterm
  * Create profiles 'dark' from moon and 'light' from dawn
  * Set M+ 1mn medium font, light:medium, dark:regular https://css-tricks.com/dark-mode-and-variable-fonts/
  * Bump scrollback to 25k
  * Set Appearance > General > Theme to 'Minimal'
  * Set Profiles > * > Colors > Cursor Colors
  * Remap 'Close' to Cmd+Shift+W, System Settings > Keyboard Shortcuts > App Shortcuts
* Alacritty
  * Rice app icon https://github.com/dfl0/mac-icons/blob/main/alacritty/icons/faithful/alacritty_faithful_256.png
* Bump inotify limits for entr http://eradman.com/entrproject/limits.html
* Skim MacOS Security & Privacy Guide https://github.com/drduh/macOS-Security-and-Privacy-Guide
* Firefox
  * Set sync Device Name to '$hostname' about:preferences#sync
  * Firefox yellow theme -- https://color.firefox.com/?theme=XQAAAAIpAQAAAAAAAABBqYhm849SCia2CaaEGccwS-xMDPsqvXkIbAF6EJDWcx9sS_Bi3JZGE6ZZI2STfI2PTljloDe5nkXVU4eUt67pknPBTFda74qSLuzQZo_BsyuRKt4MYOwUA85nuFvk6_9a1n944vRDhYM8EitgmHsep4u5kxl92bvI79XVHwGNbLJ18lklnhQ90ILDJ7wyz2hU7HpqhejN3CtLUA_oHf2akJAkzdQmd5e_Hmpf_8pXCAA
  * Merriweather default serif font
  * Update ctrl tab to 'sort by recently used'
    about:config > browser.ctrlTab.sortByRecentlyUsed > true
    https://superuser.com/a/392376
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
  * https://github.com/asdf-vm/asdf-ruby
  * https://github.com/asdf-vm/asdf-nodejs
  * https://github.com/asdf-community/asdf-python
"
