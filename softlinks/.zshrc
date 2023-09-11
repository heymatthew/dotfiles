# Locale
export LANG=en_US
export LC_CTYPE=$LANG.UTF-8

# CD from anywhere
cdpath=(~ ~/Desktop ~/code/centrapay ~/code ~/code/go/src ~/.config/nvim ~/code/exercism/go)

setopt CORRECT MULTIOS NO_HUP NO_CHECK_JOBS EXTENDED_GLOB

# History
export HISTSIZE=1000000
export HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE

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
# setopt share_history      # all open shells see history

setopt interactivecomments # Don't execute comments in interactive shell

## Completion
setopt NO_BEEP AUTO_LIST AUTO_MENU
autoload -U compinit
compinit

# Bash-like navigation, http://stackoverflow.com/questions/10847255
autoload -U select-word-style
select-word-style bash

##############################################################################
# Misc tricks from
# http://chneukirchen.org/blog/archive/2013/03/10-fresh-zsh-tricks-you-may-not-know.html
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey "^[m" copy-earlier-word

function _recover_line_or_else() {
  if [[ -z $BUFFER && $CONTEXT = start && $zsh_eval_context = shfunc
      && -n $ZLE_LINE_ABORTED
      && $ZLE_LINE_ABORTED != $history[$((HISTCMD-1))] ]]; then
    LBUFFER+=$ZLE_LINE_ABORTED
    unset ZLE_LINE_ABORTED
  else
    zle .$WIDGET
  fi
}
zle -N up-line-or-history _recover_line_or_else
function _zle_line_finish() {
  ZLE_LINE_ABORTED=$BUFFER
}
zle -N zle-line-finish _zle_line_finish

# End tricks
##############################################################################

## Prompt
cur_git_branch() {
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -n "$branch" ]] && echo "[$branch]"
}

setopt PROMPT_SUBST

case $TERM in
  xterm*|rxvt*|screen|Apple_Terminal)
    # Remotes look different
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
      PROMPT=$(echo "%{\e]0;%n@%m: %~\a\e[%(?.32.31)m%}β %{\e[m%}")
    else
      PROMPT=$(echo "%{\e]0;%n@%m: %~\a\e[%(?.32.31)m%}λ %{\e[m%}")
    fi

    # Echo current process name in the xterm title bar
    preexec () {
      print -Pn "\e]0;$1\a"
    }
    ;;
  *)
    PROMPT="[%n@%m] %# "
    ;;
esac

# RPROMPT=$(echo '$(cur_git_branch) %{\e[32m%}%3~ %{\e[m%}%U%T%u')

# Echo current process name in the xterm title bar
preexec () {
  print -Pn "\e]0;$1\a"
}

export LS_COLORS="exfxcxdxbxegedabagacad"
ZLS_COLORS=$LS_COLORS

# Aliases
alias ls='ls -G'                               # technicolor list
alias cdg='cd $(git rev-parse --show-cdup)'    # cd to root of repo
alias update="~/dotfiles/update.sh"
alias g="git"

# Configure unix tooling
export LESS='-R'
export GREP_COLOR='1;33'

# Changing habits
alias t='git changes | entr -r -c'
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

# Personal programs
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/code/go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/Applications/Xcode.app/Contents/Developer/usr/bin/:$PATH"

export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

export GOPATH="$HOME/code/go"
export GO111MODULE="on"

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
  echo "vim..."
  export EDITOR=vim
else
  export EDITOR=vi
fi

if which nvm > /dev/null; then
  echo "node version manager..."
  export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
fi

# Cludges follow
if [[ `uname` == "Darwin" ]]; then # OSX
  echo "OSX cludges..."
  # Fix GPG agent detection
  # see https://github.com/pstadler/keybase-gpg-github/issues/11
  GPG_TTY=$(tty)
  export GPG_TTY

  # Delete key fixup
  bindkey "^[[3~"  delete-char
  bindkey "^[3;5~" delete-char

  # Local IP as env variable
  export LOCAL_IP=$(ipconfig getifaddr en0)
else # Linux
  # Turn off capslock
  setxkbmap -option caps:escape
fi

# hose things that match string
# e.g. fuck ruby
alias fuck='pkill -if'

# .envrc files contain secrets, if direnv exists export them on directory traversal
if which direnv > /dev/null; then
  echo "direnv..."
  eval "$(direnv hook zsh)"
fi

# If rbenv exists, init shims autocompletion
if which rbenv > /dev/null; then
  echo "rbenv..."
  eval "$(rbenv init -)";
  export PATH="~/.rbenv/bin:$PATH"
fi

# if which asdf > /dev/null; then
#   echo "asdf..."
#   $(brew --prefix asdf)/asdf.sh
# fi

# If chruby exists, init shims and hook cd
if [ -f /usr/local/share/chruby/chruby.sh ]; then
  echo "chruby..."
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
fi

# If pyenv exists, init shims and autocompletion
if which pyenv > /dev/null; then
  echo "pyenv..."
  eval "$(pyenv init -)"
  pyenv rehash
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

# https://coderwall.com/p/s-2_nw/change-iterm2-color-profile-from-the-cli
it2prof() { echo -e "\033]1337;SetProfile=$1\a" }

# Set and remember iterm colours
# n.b. themes MUST be lowercase 'light' and 'dark' for reuse in vimrc's background setup
# see https://iterm2.com/documentation-escape-codes.html
# [ -e ~/.config/iterm_theme ] && it2prof $(cat ~/.config/iterm_theme)"
alias dark='echo "dark mode..." && echo dark > ~/.config/iterm_theme && it2prof dark'
alias light='echo "light mode..." && echo light > ~/.config/iterm_theme && it2prof light'
appearance=$(defaults read -g AppleInterfaceStyle 2> /dev/null || echo "Light")
if [ $appearance = 'Dark' ]; then
  dark
else
  light
fi

func cwd() {
  pwd | sed "s#$HOME#~#g"
}
echo "$(whoami)@$(hostname):$(cwd)"
