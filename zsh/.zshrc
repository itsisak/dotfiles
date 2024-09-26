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

HIST_STAMPS="mm/dd/yyyy"
HYPHEN_INSENSITIVE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
    z 
    git 
    brew 
    zsh-autosuggestions
    zsh-syntax-highlighting 
)
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
# Guide
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

source "$ZSH/oh-my-zsh.sh"
source "$HOME/dotfiles/zsh/aliases.zsh"
source "$HOME/dotfiles/zsh/keymap.zsh"
source "$HOME/dotfiles/zsh/functions.zsh"

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
[ -s "$HOME/.fzf.zsh" ] && \. "$HOME/.fzf.zsh"

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

export PATH="$PATH:$HOME/bin"

