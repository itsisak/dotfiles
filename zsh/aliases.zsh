# Navigating
alias ..="cd .."
alias z-="cd - &>/dev/null"
alias l="eza -a --icons=always --group-directories-first --sort=extension"
alias ll="l -l --no-time --no-user --git-repos --git -h"
alias t="tt --level=2"
alias tt="l -T --ignore-glob='.git'"
alias c="clear"

# Custom tools
alias v="open_vim"
alias f="find_all"
alias get="brew_search_and_install"

# Open config
alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias yabairc="vim ~/.config/yabai/yabairc"
alias skhdrc="vim ~/.config/skhd/skhdrc"
alias wezconfig="vim ~/.config/wezterm/wezterm.lua"

# Pass
alias wkpass="PASSWORD_STORE_DIR='$HOME/code/webkom/password-store' pass"
alias itpass="PASSWORD_STORE_DIR='$HOME/code/it/password-store' pass"

# Div
alias yr="curl 'wttr.in/?F&lang=nb'"
alias ds='docker ps --format '\''table {{.ID}}\t{{.Names}}\t{{.Status}}'\'
alias gdt="git difftool"
alias ghwall="gh graph --pixel %EF%90%88%20 --scheme unicorn"

