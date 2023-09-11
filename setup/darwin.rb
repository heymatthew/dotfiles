def describe(action)
  puts "\n#{action}..."
end

def run(cmd)
  puts "λ #{cmd}"
  system(cmd)
end

describe "testing superuser (password required)"
run("sudo echo 'make me a Sandwich! https://xkcd.com/149'") || exit(1)

describe "setting hostname"
print "what do you want your hostname to be?\n🤔 "
hostname = gets.chomp
run("sudo hostname -s #{hostname}")                   # ...for the cli tool "hostname"
run("sudo scutil --set LocalHostName '#{hostname}'")  # ...for System Settings > Sharing > Hostname
run("sudo scutil --set ComputerName '#{hostname}'")
run("sudo scutil --set HostName '#{hostname}.matthew.nz'")

describe "creating ssh keys"
run("ssh-keygen -t ed25519")
puts "editing public key in vim 🤔, press enter to continue..."
gets
run("vim ~/.ssh/id_ed25519.pub")

# n.b. Put here to avoid awkward user interaction later.
# Not used till we stow dotfiles.
describe 'templating git config'
puts "editing git config in vim 🤔, press enter to continue..."
gets
git_template = File.new("#{Dir.home}/.gitconfig.local", 'w')
git_template.puts <<~EOF.strip
  [user]
    name = Matthew B. Gray
    email = spamed@matthew.nz
EOF
git_template.close
run('vim ~/.gitconfig.local')

# From https://brew.sh/
describe "installing homebrew"
run('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')

describe "brew bundle"
run('/opt/homebrew/bin/brew bundle')

describe 'stowing dotfiles'
run('/opt/homebrew/bin/stow softlinks')

describe 'installing npm packages'
%w(write-good).each do |package|
  run("/opt/homebrew/bin/npm install -g #{package}")
end

describe 'installing julia packages'
script_dir = File.dirname(__FILE__)
run "#{script_dir}/julia-packages.jl"

describe "install neovim plugins"
run('/opt/homebrew/bin/nvim -c "call UpdateEverything() | qa"')

describe "Your public ssh key is stored in ~/.ssh/id_ed25519.pub"
puts File.open("#{Dir.home}/.ssh/id_ed25519.pub").read.chomp
puts "\nTODO"
puts "* Copy over ~/.ssh/config"
puts "* Add ssh key to https://github.com/settings/keys"
puts "* Add ssh key to https://gitlab.com/-/profile/keys"
puts "* Add ssh key to remote hosts ~/.ssh/authorized_keys"
puts "* iTerm2"
puts "  * Install Rosé Pine https://github.com/rose-pine/iterm"
puts "  * Create profiles 'dark' from moon and 'light' from dawn"
puts "  * Set M+ 1mn medium font, light:medium, dark:regular https://css-tricks.com/dark-mode-and-variable-fonts/"
puts "  * Bump scrollback to 25k"
puts "  * Set Appearance > General > Theme to 'Minimal'"
puts "* Bump inotify limits for entr http://eradman.com/entrproject/limits.html"
puts "* Skim MacOS Security & Privacy Guide https://github.com/drduh/macOS-Security-and-Privacy-Guide"
puts "* Set Firefox sync Device Name to #{hostname} about:preferences#sync"
puts "* Set Syncthing Device Name to #{hostname} http://localhost:8384/"
puts "* Set API token in Exercism"
puts "  * https://exercism.io/my/settings"
puts "  * exercism configure --token=YOUR_TOKEN"
puts "* Finish setting up brew applications"
puts "  * brew link postgresql@15"
puts "  * brew services start postgresql@15"
puts "  * brew services start syncthing"
