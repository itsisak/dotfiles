local FZF_FILE_PREVIEW="\"%N  ~  Last modified: %Sm%n\""
# https://man.freebsd.org/cgi/man.cgi?query=stat&sektion=1

function v() { 
    if [ "$1" ]; then 
        vim $1
    else 
        fzf --bind 'enter:become(vim {})' \
            --preview "stat -f $FZF_FILE_PREVIEW {}  && bat --color=always --style=numbers --line-range=:500 {}"
    fi 
}

function f() {
    if [ "$#" -gt 0 ]; then 
         rg --ignore-case \
            --files-with-matches  \
            --no-messages "$1" \
            | fzf --preview "batgrep --color=always --ignore-case --context=5 '$1' {} || \
                             batgrep --color=always --ignore-case --context=5 '$1'"
        return 1
    fi
    fzf --preview "stat -f $FZF_FILE_PREVIEW {} && bat --color=always --style=numbers --line-range=:500 {}" 
    # bat for coloring - https://github.com/sharkdp/bat?tab=readme-ov-file
    # ripgrep coloring - https://github.com/BurntSushi/ripgrep/blob/master/FAQ.md
}

