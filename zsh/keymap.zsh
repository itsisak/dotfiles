bindkey -d # reset to defaults

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

