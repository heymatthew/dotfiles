def describe(action)
  puts "\n#{action}..."
end

def run(cmd)
  puts "λ #{cmd}"
  system(cmd)
end

# From https://brew.sh/
describe "installing homebrew"
run('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')

describe "brew bundle"
run('/opt/homebrew/bin/brew bundle')

describe 'stowing dotfiles'
run('/opt/homebrew/bin/stow links')

describe 'installing npm packages'
%w(write-good).each do |package|
  run("/opt/homebrew/bin/npm install -g #{package}")
end

describe "install neovim plugins"
run('/opt/homebrew/bin/nvim -c "call UpdateEverything() | qa"')

describe 'templating git config'
puts "editing git config, press enter to continue..."
gets
git_template = File.new("#{Dir.home}/.gitconfig.local", 'w')
git_template.puts <<~EOF.strip
  [user]
    name = Matthew B. Gray
    email = spamed@matthew.nz
EOF
git_template.close
run('vim ~/.gitconfig.local')

puts "\nTODO"
puts "* Install Rosé Pine for iTerm2 https://github.com/rose-pine/iterm"
puts "* Create iTerm2 profiles 'dark' from moon and 'light' from dawn"
puts "* Set m+ 1mn fonts"
