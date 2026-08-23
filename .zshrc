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
if [[ -n "$ZSH_DEBUGRC" ]]; then
    zmodload zsh/zprof
fi

local ZSH_CACHE_DIR="$HOME/.cache/zsh"
mkdir -p $ZSH_CACHE_DIR

autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump-$HOST-$ZSH_VERSION
#export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump-$HOST"

local ZSH_PLUGIN_DIR="$HOME/.zsh/plugins"
source "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

local BREW_DIR=$(brew --prefix)

HIST_STAMPS="mm/dd/yyyy"
HYPHEN_INSENSITIVE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

source "$HOME/.config/zsh/aliases.zsh"
source "$HOME/.config/zsh/keymap.zsh"
source "$HOME/.config/zsh/functions.zsh"

eval "$(zoxide init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$BREW_DIR/opt/nvm/nvm.sh" ] && \. "$BREW_DIR/opt/nvm/nvm.sh"
[ -s "$BREW_DIR/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$BREW_DIR/opt/nvm/etc/bash_completion.d/nvm"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

export TEXCELLENT_DIR="$HOME/.texcellent"
[ -s "$TEXCELLENT_DIR/texcellent" ] && \. "$TEXCELLENT_DIR/texcellent"

source <(fzf --zsh)
export FZF_DEFAULT_OPTS='
    --color=fg:#dddddd,fg+:#ffffff,bg:-1,bg+:-1
    --color=hl:#5f87af,hl+:#5fd7ff,info:#5f87af,marker:#87ff00
    --color=prompt:#d7005f,spinner:#af5fff,pointer:#af5fff,header:#87afaf
    --color=border:#262626,label:#aeaeae,query:#d9d9d9
    --layout="reverse" 
    --info="right"
    --height="60%"
    --padding="1,0,0,0"
    --preview-window="60%"
    --prompt="> " 
    --marker="*" 
    --pointer="→"
    --separator="-" 
    --scrollbar="│" 
'

export PATH="$PATH:$HOME/bin"
export PATH="/opt/homebrew/opt/bison/bin:$PATH"
export PATH="$HOME/.spin/bin:$PATH"

if [[ -n "$ZSH_DEBUGRC" ]]; then
    zprof
fi
