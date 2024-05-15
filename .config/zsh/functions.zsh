function v() { if [ "$1" ]; then vim $1; else vim .; fi }

function f() {
    if [ ! "$#" -gt 0 ]; then 
        fzf --preview 'stat -f \"%n--> %N%n%nType: %HT%nSize: %z (bytes)%nLast modified: %Sm%n%n--------------------[ PREVIEW ]--------------------%n%n\"  {}  && less {}' \
            --preview-label='[ FILE INFO ]' \
            --bind shift-up:preview-page-up,shift-down:preview-page-down \
            --height=40 \
            --border=top \
            --info=inline \
            --pointer='→'
        return 1
    fi
    rg --ignore-case --files-with-matches --no-messages "$1" | fzf \
        --preview "stat -f \"%n--> %N%n%nType: %HT%nSize: %z (bytes)%nLast modified: %Sm%n%n--------------------[ PREVIEW ]--------------------%n%n\" {} && \
            rg --ignore-case --pretty --context 5 '$1' {} || \
            rg --ignore-case --pretty --context 5 '$1'" \
        --preview-label='[ FILE INFO ]' \
        --bind shift-up:preview-page-up,shift-down:preview-page-down \
        --height=40 \
        --border=top \
        --info=inline \
        --pointer='→'
    # https://man.freebsd.org/cgi/man.cgi?query=stat&sektion=1
    # bat for coloring - https://github.com/sharkdp/bat?tab=readme-ov-file
    # ripgrep coloring - https://github.com/BurntSushi/ripgrep/blob/master/FAQ.md
}

