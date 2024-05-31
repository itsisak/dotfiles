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
local BREW_DIR=$(brew --prefix)

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 14

ZSH_THEME="miloshadzic" 
HIST_STAMPS="mm/dd/yyyy"
HYPHEN_INSENSITIVE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

bindkey "^@" autosuggest-accept
bindkey "^N" forward-word # partially accept autosuggestion
bindkey "^H" backward-char
bindkey "^J" down-line-or-beginning-search
bindkey "^K" up-line-or-beginning-search
bindkey "^L" forward-char
bindkey "^[i" beginning-of-line
bindkey "^[a" end-of-line
bindkey "^D" kill-line
bindkey "^Xd" kill-whole-line
bindkey "^U" undo

function _sudo {
    [[ ! $BUFFER =~ '^sudo.*' ]] && BUFFER="sudo $BUFFER" && zle end-of-line
}

zle -N _sudo
bindkey '^Xv' _sudo

plugins=(
    z 
    git 
    brew 
    zsh-autosuggestions
    zsh-syntax-highlighting 
)
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source "$ZSH/oh-my-zsh.sh"
source "$HOME/.config/zsh/aliases.zsh"
source "$HOME/.config/zsh/functions.zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$BREW_DIR/opt/nvm/nvm.sh" ] && \. "$BREW_DIR/opt/nvm/nvm.sh"
[ -s "$BREW_DIR/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$BREW_DIR/opt/nvm/etc/bash_completion.d/nvm"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export TEXCELLENT_DIR="$HOME/.texcellent"
[ -s "$TEXCELLENT_DIR/texcellent" ] && \. "$TEXCELLENT_DIR/texcellent"

export FZF_DEFAULT_OPTS="\
    --layout=reverse \
    --inline-info \
    --height 60% \
    --pointer='→'"
[ -s "$HOME/.fzf.zsh" ] && \. "$HOME/.fzf.zsh"

#export PASSWORD_STORE_DIR="$HOME/code/webkom/password-store" 
export PATH="$PATH:$HOME/bin"

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

