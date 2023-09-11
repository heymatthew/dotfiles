def describe(action)
  puts "#{action}..."
end

describe "nvim/vim"
system(%{nvim -c "call execute('PlugUpdate') | call execute('GoInstallBinaries') | qa"})
system(%{vim -c "call execute('PlugUpdate') | call execute('GoInstallBinaries') | qa"})

describe "npm"
system('npm install -g npm') # update npm itself
system('npm update -g')      # update global packages

describe "julia"
system('julia', '-e', 'using Pkg; Pkg.update()')

describe "brew"
system('brew upgrade')
system('brew upgrade --cask')
system('brew cleanup')
system('brew doctor')

describe "osx"
system('mas upgrade') # https://apple.stackexchange.com/a/72148

puts "This command appears to freeze:"
puts "> softwareupdate --install --all"
puts "...try updating manually instead"
# system('sudo softwareupdate --install --all')

puts <<~END.strip
  WARNING:
  This version of ruby is included in macOS for compatibility with legacy software.
  In future versions of macOS the ruby runtime will not be available by
  default, and may require you to install an additional package.
END
