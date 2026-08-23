# Zoxide
eval "$(zoxide init zsh)"

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# Nvm
local BREW_DIR=$(brew --prefix)
export NVM_DIR="$HOME/.nvm"
[ -s "$BREW_DIR/opt/nvm/nvm.sh" ] && \. "$BREW_DIR/opt/nvm/nvm.sh"
[ -s "$BREW_DIR/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$BREW_DIR/opt/nvm/etc/bash_completion.d/nvm"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Texcellent
export TEXCELLENT_DIR="$HOME/.texcellent"
[ -s "$TEXCELLENT_DIR/texcellent" ] && \. "$TEXCELLENT_DIR/texcellent"

# FZF
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
