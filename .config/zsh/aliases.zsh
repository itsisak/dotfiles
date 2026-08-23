# Navigating
alias ..="cd .."
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
alias zencss="vim /Users/isakbergendresen/Library/Application Support/zen/Profiles/6bo8pw0j.Default (alpha)/chrome/userCrome.css"

# Pass
alias wkpass="PASSWORD_STORE_DIR='$HOME/code/webkom/password-store' pass"
alias itpass="PASSWORD_STORE_DIR='$HOME/code/it/password-store' pass"

# Misc
alias yr="curl 'wttr.in/?F&lang=nb'"
alias ds='docker ps --format '\''table {{.ID}}\t{{.Names}}\t{{.Status}}'\'
alias dsa="docker_stop_all_parallel"
alias de="docker_enter"
alias gdt="git difftool"
alias ghwall="gh graph --pixel %EF%90%88%20 --scheme unicorn"
alias gitgraph="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
alias kvm="java -jar /Users/isakbergendresen/code/webkom/dotfiles/JavaClient.jar"
alias toggle_office_light_1='echo "Light is: " && curl "http://192.168.1.95/?m=1&o=1" | grep -oE "ON|OFF"'
alias toggle_office_light_2='echo "Light is: " && curl "http://192.168.0.107/?m=1&o=1" | grep -oE "ON|OFF"'
alias mpv-manage='~/.config/mpv/manage'
alias play='mpv-manage play'
alias df="df -h"
alias debug_zsh="time ZSH_DEBUGRC=1 zsh -i -c exit"



