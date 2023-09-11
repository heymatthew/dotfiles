def describe(action)
  puts "#{action}..."
end

# From https://brew.sh/
describe "installing homebrew"
system('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')

describe "brew bundle"
system('/opt/homebrew/bin/brew bundle')

describe 'stowing dotfiles'
system('/opt/homebrew/bin/stow links')

describe 'installing npm packages'
%w(write-good).each do |package|
  system("/opt/homebrew/bin/npm install -g #{package}")
end

describe "install neovim plugins"
system('/opt/homebrew/bin/nvim -c "call UpdateEverything() | qa"')

describe 'templating git config'
puts "editing git config, press enter to continue..."
gets
git_template = File.new("#{Dir.home}/.gitconfig.local", 'w')
git_template.puts <<~EOF.strip
  [user]
    name = Matthew B. Gray
    email = fixme@github.io
EOF
git_template.close
system('vim ~/.gitconfig.local')
