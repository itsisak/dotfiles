###############################################################################
#
#               _███████╗███████╗██╗  ██╗██████╗  ██████╗
#               ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#                 ███╔╝ ███████╗███████║██████╔╝██║     
#                ███╔╝  ╚════██║██╔══██║██╔══██╗██║     
#               ███████╗███████║██║  ██║██║  ██║╚██████╗
#               ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
#                                       
##############################################################################

export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
export ZSH="$HOME/.oh-my-zsh"

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 14

ZSH_THEME="miloshadzic" 
HIST_STAMPS="mm/dd/yyyy"
HYPHEN_INSENSITIVE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Enable vim bindings
# bindkey -v

# PLUGINS


plugins=(git brew zsh-syntax-highlighting z)
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/oh-my-zsh.sh

# https://github.com/zsh-users
# https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins


# USER CONFIGURATION


alias dotfiles="/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias dss="dotfiles status --short"
alias ..="cd .."
alias l="ls -a"
alias t="tree -a"
alias c="clear"
alias wk="~/code/webkom"
alias lego="~/code/webkom/lego"
alias webapp="~/code/webkom/lego-webapp"
alias subjects="~/code/subjects"
alias yr="curl 'wttr.in/?F&lang=nb'"
alias zshconfig="vim ~/.zshrc"
alias ds='docker ps --format '\''table {{.ID}}\t{{.Names}}\t{{.Status}}'\'

# https://man.freebsd.org/cgi/man.cgi?query=stat&sektion=1
alias f="fzf --preview 'stat -f \"%n--> %N%n%nType: %HT%nSize: %z (bytes)%nLast modified: %Sm%n%n--------------------[ PREVIEW ]--------------------%n%n\"  {}  && less {}' --preview-label='[ FILE INFO ]' --bind shift-up:preview-page-up,shift-down:preview-page-down --height=40 --border=top --info=inline --pointer='→'"
[ -s "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" ] && \. "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
[ -s "/opt/homebrew/opt/fzf/shell/completion.zsh" ] && \. "/opt/homebrew/opt/fzf/shell/completion.zsh"

function fif() {
    if [ ! "$#" -gt 0 ]; then f; return 1; fi
#    rg --files-with-matches --no-messages "$1" | f \
#        --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
    rg --files-with-matches --no-messages "$1" | fzf \
        --preview "stat -f \"%n--> %N%n%nType: %HT%nSize: %z (bytes)%nLast modified: %Sm%n%n--------------------[ PREVIEW ]--------------------%n%n\" {} && \
            rg --ignore-case --pretty --context 5 '$1' {} || \
            rg --ignore-case --pretty --context 5 '$1'" \
        --preview-label='[ FILE INFO ]' \
        --bind shift-up:preview-page-up,shift-down:preview-page-down \
        --height=40 --border=top --info=inline --pointer='→'
}
        #--preview "highlight -O ansi -l {} 2> /dev/null | \

function v() { if [ "$1" ]; then vim $1; else vim .; fi }

export PASSWORD_STORE_DIR="$HOME/code/webkom/password-store" 

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun" # bun completions

export TEXCELLENT_DIR="$HOME/.texcellent"
[ -s "$TEXCELLENT_DIR/texcellent" ] && \. "$TEXCELLENT_DIR/texcellent"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="$PATH:$HOME/bin"

