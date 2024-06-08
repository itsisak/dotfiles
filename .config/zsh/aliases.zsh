# dotfiles
alias dotfiles="/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias dss="dotfiles status --short"

# Navigating
alias ..="cd .."
alias z-="cd - &>/dev/null"
alias l="eza -a --icons=always --group-directories-first --sort=extension"
alias ll="l -l --no-time --no-user --git-repos --git -h"
alias t="eza -T --level=2"
alias c="clear"

alias wk="~/code/webkom"
alias lego="~/code/webkom/lego"
alias webapp="~/code/webkom/lego-webapp"
alias it="~/code/itdagene"
alias subjects="~/code/subjects"

alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias yabairc="vim ~/.config/yabai/yabairc"
alias skhdrc="vim ~/.config/skhd/skhdrc"
alias config="cd ~/.config"

# Pass
alias wkpass="PASSWORD_STORE_DIR='$HOME/code/webkom/password-store' pass"
alias itpass="PASSWORD_STORE_DIR='$HOME/code/it/password-store' pass"

# Div
alias yr="curl 'wttr.in/?F&lang=nb'"
alias ds='docker ps --format '\''table {{.ID}}\t{{.Names}}\t{{.Status}}'\'
alias gdt="git difftool"
alias ghwall="gh graph --pixel %EF%90%88%20 --scheme unicorn"

# Custom tools
alias v="open_vim"
alias f="find_all"
alias get="brew_search_and_install"
