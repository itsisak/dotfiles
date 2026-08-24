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
if [[ -n "$ZSH_DEBUGRC" ]]; then zmodload zsh/zprof; fi

# Temporary prompt until modules are loaded
setopt PROMPT_SUBST
PROMPT=$'\n%~\n❯ '

HISTSIZE=10000
SAVEHIST=10000
HIST_STAMPS="mm/dd/yyyy"
HYPHEN_INSENSITIVE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
ZVM_CURSOR_STYLE_ENABLED=false
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS

autoload -Uz compinit
if [ "$(find ~/.zcompdump -mtime +0)" ] ; then
    compinit
fi
compinit -C

local ZSH_CONFIG_DIR="$HOME/.config/zsh"
local ZSH_PLUGINS_DIR="$ZSH_CONFIG_DIR/plugins"

__source_plugin() { source "$ZSH_PLUGINS_DIR/$1/$1.plugin.zsh" }
__source_config() { source "$ZSH_CONFIG_DIR/$1.zsh" }
    
__source_plugin zsh-defer

zsh-defer +s __source_plugin zsh-autosuggestions
zsh-defer +z __source_plugin zsh-syntax-highlighting
zsh-defer    __source_plugin zsh-nvm-lazy-load
zsh-defer    __source_plugin zsh-vi-mode

zsh-defer __source_config modules
zsh-defer __source_config with_loading
zsh-defer __source_config functions
zsh-defer __source_config keymap
zsh-defer __source_config aliases

if [[ -n "$ZSH_DEBUGRC" ]]; then zprof; fi
