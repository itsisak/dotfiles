source ./with_loading.zsh

function _exec() {
    echo "$@"
    ("$@")
}

function fzf_with_preview() {
    local FZF_PREVIEW_COMMAND='
        if [[ ! -e {} ]]; then echo "File does not exist."; return; fi; 
        if [[ ! -s {} ]]; then echo "File is empty :/"; return; fi; 
        bat --color=always --style=numbers --line-range=:500 {}'
    fzf --preview="$FZF_PREVIEW_COMMAND" "$@"
}

function open_vim() { 
    if [ "$1" ]; then 
        vim $1
        return
    fi
    fzf_with_preview --bind 'enter:become(vim {})'
}

function find_all() {
    if [ "$#" -gt 0 ]; then 
         rg --ignore-case --files-with-matches  --no-messages "$1" \
            | fzf --preview "batgrep --color=always --ignore-case --context=5 '$1' {} || \
                             batgrep --color=always --ignore-case --context=5 '$1'"
        return
    fi
    fzf_with_preview
}

function docker_stop_all() {
    printf "%-30s %-15s STATUS\n" "NAME" "ID"
    while IFS=':' read -r id name; do
        local out_str=$(printf "%-30s %-15s" $name $id)
        with_loading                    \
            --message="$out_str    "    \
            --done="\b\b\bSTOPPED"      \
            --                          \
            docker stop $id
    done <<< $(docker ps -a --format "{{.ID}}:{{.Names}}")
    wait
}

function docker_stop_all_parallel() {
    printf "%-30s %-15s %-6s\n" "NAME" "ID" "STATUS"
    local cmds=()
    local msgs=""
    for container in $(docker ps -a --format "{{.ID}}:{{.Names}}"); do
        local id="${container%%:*}"
        local name="${container#*:}"
        cmds+=("docker stop $id")
        msgs+=$(printf "%-30s %-15s:" $name $id)
    done
    with_loading_parallel       \
        --done="DONE"           \
        --messages="$msgs"      \
        --format="%-45s %-6s"   \
        --                      \
        $cmds
}

docker_exec_with_bash() {
    local id=$(docker ps --format '{{.ID}} {{.Names}}' | grep $1 | cut -d ' ' -f 1)  
    echo "Entering $1 ($id)"
    docker exec -it $id bash
}


# TODO: Handle error from brew
# Currently buggy behaviour if no matches for a search
function brew_search_and_install() {
    if [[ "$1" == -* ]]; then
        local flag="$1"
        shift
    fi
    local query="$1"
    local cask_prefix="<CASK> "
    
    with_loading -- brew search --formulae "$query"
    local formulae="$WITH_LOADING_RESULT"
    
    with_loading -- brew search --casks "$query"
    local casks="$WITH_LOADING_RESULT"

    # Buggy behaviour here
    #echo casks: $casks
    #echo formula: $formulae
    #return
    local modified_casks="${casks//$'\n'/\n$cask_prefix}"
    local packages="$formulae\n$cask_prefix$modified_casks"
    
    preview_command="brew info --json=v1 {1} | jq -r '.[0].desc'"
    local package=$(echo "$packages" | fzf --preview="echo '{1}\n' && $preview_command" --preview-window="40%" --padding="0")
    if [[ -z "$package" ]]; then 
        printf "Aborting.."
        return
    fi
    
    if [[ $package == $cask_prefix* ]]; then 
        local cask=${package//$cask_prefix/}
        cask=${cask// /}
        brew_install=("brew" "install" "--cask" "$cask")
    else 
        local formula=${package// /}
        brew_install=("brew" "install" "--formula" "$formula")
    fi
    [[ $flag == "-v" ]] && _exec "${brew_install[@]}" || with_loading --done "${brew_install[@]}"
    printf "Installation was successfull! ✅\n"
} 
# Prompt before install
# read "install?Install cask $cask? (y/n) " # clear prompt: printf "\r\033[A\033[K"
# [[ $install =~ ^[yY]$ ]] && brew install --cask $cask -n

function brew_search_and_uninstall() {

    with_loading -n -- brew list --formulae
    local formulae="$WITH_LOADING_RESULT"
    printf "\n"
    
    with_loading -n -- brew list --casks
    local casks="$WITH_LOADING_RESULT"

    local packages=$(echo "$formulae\n$casks" | fzf -m --padding="0")

    # Does not work....
    SAVEIFS=$IFS  
    IFS=$'\n'      
    pkg_arr=($packages)
    IFS=$SAVEIFS 

    echo "${#pkg_arr}"

    for pkg in $pkg_arr; do
        echo "Deleting $pkg"
    done
}

function brew_list() {

    with_loading -- brew list -1 --formulae
    local formulae="$WITH_LOADING_RESULT"

    with_loading -- brew list -1 --casks
    local casks="$WITH_LOADING_RESULT"

    #echo "Formulae:"
    #echo $formulae
    #echo "Casks: "
    #echo $casks

    preview_command="brew info --json=v1 {1} | jq -r '.[0].desc'"
    local package=$(echo "$formulae\n$casks" | fzf --preview="echo '{1}\n' && $preview_command" --preview-window="40%" --padding="0")
}
