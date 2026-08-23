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

HIST_STAMPS="mm/dd/yyyy"
HYPHEN_INSENSITIVE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

local ZSH_CACHE_DIR="$HOME/.cache/zsh"
mkdir -p $ZSH_CACHE_DIR
autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/zcompdump-$HOST-$ZSH_VERSION"

# Load local plugins
for plugin in "$HOME/.zsh/plugins"/*; do 
    source "$plugin/$(basename $plugin).zsh"
done
# Load local configs
for config in "$HOME/.config/zsh"/*.zsh; do 
    source $config
done

if [[ -n "$ZSH_DEBUGRC" ]]; then zprof; fi
