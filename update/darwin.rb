def describe(action)
  puts "#{action}..."
end

describe "vim"
system('nvim -c "call UpdateEverything() | qa"')

describe "npm"
system('npm install -g npm') # update npm itself
system('npm update -g')      # update global packages

describe "brew"
system('brew upgrade')
system('brew upgrade --cask')
system('brew cleanup')
system('brew doctor')

describe "osx"
system('sudo softwareupdate --install --all')
