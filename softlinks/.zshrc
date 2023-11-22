# Locale
export LANG=en_US
export LC_CTYPE=$LANG.UTF-8

# CD from anywhere
cdpath=(~ ~/Desktop ~/src)

setopt CORRECT MULTIOS NO_HUP NO_CHECK_JOBS EXTENDED_GLOB

# History
export HISTSIZE=1000000
export HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE

# Statistics for long running procs
export REPORTTIME=1 # seconds
export REPORTMEMORY=10240 # kb, ~10mb
export TIMEFMT='mem:%Mk time:%E (user:%U/kernel:%S)'

# man zshoptions
setopt hist_ignore_all_dups # when running a command again, removes previous refs to it
setopt hist_save_no_dups    # kill duplicates on save
setopt hist_ignore_space    # prefixed with space doesn't store command
setopt hist_no_store        # don't store the command history in history
setopt hist_verify          # when using history expansion, reload history
setopt hist_reduce_blanks   # blanks from each command line added to the history list

setopt extended_history     # save time stamp and runtime information
setopt inc_append_history   # write after exec rather than waiting till shell exit
setopt no_hist_beep         # no terminal bell please
setopt interactivecomments  # Don't execute comments in interactive shell
# setopt share_history      # all open shells see history

## Completion
setopt NO_BEEP AUTO_LIST AUTO_MENU
autoload -U compinit
compinit

# Setup zsh git integration
# And https://zsh-manual.netlify.app/user-contributions#2651-quickstart
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats 'β %b'

# \e]0;<stuff>\a will set window title
# See https://zsh-manual.netlify.app/prompt-expansion#Prompt-Expansion
set_context() {
  print -Pn "\e]0;$1\a" # window title
  print -Pn "\e]1;$1\a" # window pane
}
directory_context() {
  vcs_info && set_context "%m:%~ $vcs_info_msg_0_"
}
running_context() {
  if [[ "$1" =~ "^vim" || "$1" =~ "^fg" ]]; then
    # Vim and fg don't help add context
  else
    set_context "%m Σ $1"
  fi
}

# setopt prompt_subst # allow vcs_info_msg_0_ to be used in PS1
precmd_functions+=(directory_context)
preexec_functions+=(running_context)

# Prompt reflects exit codes
PS1='%(?.%F{green}.%F{red})λ%f '

export LS_COLORS="exfxcxdxbxegedabagacad"
ZLS_COLORS=$LS_COLORS

# Aliases
alias ls='ls -G'                               # technicolor list
alias cdg='cd $(git rev-parse --show-cdup)'    # cd to root of repo
alias update="~/dotfiles/update.sh"
alias g="git"

# Configure unix tooling
export LESS='--RAW-CONTROL-CHARS'
export GREP_COLOR='1;33'

# Changing habits
alias t='(git changes || git ls-files) | entr -c'
alias isodate="echo 'deprecated: today, or now?'"

# Checkout github pull requests locally
# https://gist.github.com/piscisaureus/3342247
function pullify() {
  git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
}

# Default working directories per-box
alias pin="pwd > ~/.pindir"                   # pin cwd as pin dir
alias cdd='cd $(cat ~/.pindir 2&> /dev/null)' # cdd nav to pin dir
if [[ $(pwd) == $HOME ]]; then                # open pin dir on term open
  cdd
fi

# Conditionally load files
[ -e ~/.config/local/env ] && source ~/.config/local/env
[ -e ~/.zshrc.local ]      && source ~/.zshrc.local
[ -f ~/.fzf.zsh ]          && source ~/.fzf.zsh

function rehash() {
  source ~/.zshrc && stty sane
}

# Hide go dependencies, prefer go mod for projects
export GOPATH="$HOME/.go"

# Personal programs
export PATH="$HOME/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/Applications/Xcode.app/Contents/Developer/usr/bin/:$PATH"

export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt:$PATH"

# Make ^Z toggle between ^Z and fg
# https://github.com/Julian/dotfiles/blob/master/.config/zsh/keybindings.zsh
function foreground() {
  if [[ $#BUFFER == 0 ]]; then
    fg >/dev/null 2>&1 && zle redisplay
  else
    zle push-input
  fi
}
zle -N foreground
bindkey -M viins '^z' foreground

# Solarized cucumber workaround
export CUCUMBER_COLORS=comment=cyan

# Vim mode, god help me
# https://dougblack.io/words/zsh-vi-mode.html
bindkey -v
export KEYTIMEOUT=1
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word

if which fzf-history-widget > /dev/null; then
  bindkey '^r' fzf-history-widget
else
  bindkey '^r' history-incremental-search-backward
fi

# zle -N zle-line-init
# zle -N zle-keymap-select
export KEYTIMEOUT=1

# Setting default editor
if which vim > /dev/null; then
  export EDITOR=vim
else
  export EDITOR=vi
fi

# Kludges follow
if [[ `uname` == "Darwin" ]]; then # OSX
  # Fix GPG agent detection
  # see https://github.com/pstadler/keybase-gpg-github/issues/11
  GPG_TTY=$(tty)
  export GPG_TTY

  # Delete key fixup
  bindkey "^[[3~"  delete-char
  bindkey "^[3;5~" delete-char

  # Local IP as env variable
  export LOCAL_IP=$(ipconfig getifaddr en0)
fi

# hose things that match string
# e.g. nerf ruby
alias nerf='pkill -if'
alias fuck='echo "deprecated: nerf"'

# .envrc files contain secrets, if direnv exists export them on directory traversal
if which direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi

# If asdf exists, init shims and autocompletion
if which asdf > /dev/null; then
  source $(brew --prefix asdf)/libexec/asdf.sh
fi

# Advice from
# brew cask install google-cloud-sdk
if which gcloud > /dev/null; then
  echo "gcloud..."
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi

# Credit: https://coderwall.com/p/s-2_nw/change-iterm2-color-profile-from-the-cli
terminal_profile() { echo -e "\033]1337;SetProfile=$1\a" }

# Set iterm colours
# n.b. LC_APPEARANCE is a hack. SSH accepts LC_* by default so hosts can be dark mode aware
# n.b. iterm themes MUST be lowercase 'light' and 'dark' for reuse in vimrc's background setup
# see https://iterm2.com/documentation-escape-codes.html
alias dark='export LC_APPEARANCE=dark && terminal_profile dark'
alias light='export LC_APPEARANCE=light && terminal_profile light'
if [ -z "$SSH_CLIENT" ]; then
  # Detect OSX dark mode
  appearance=$(defaults read -g AppleInterfaceStyle 2> /dev/null || echo "Light")
  if [ $appearance = 'Dark' ]; then
    # Dark mode isn't as good for your eyes as you believe
    # https://www.wired.co.uk/article/dark-mode-chrome-android-ios-science
    dark
  else
    light
  fi
fi
