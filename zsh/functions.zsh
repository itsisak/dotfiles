source $HOME/dotfiles/zsh/with_loading.zsh

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

# Stop all docker containers
# Cool code, but outdated by docker_stop_all_parallel
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

# Stop all docker containers in parallel with loading indicators
# Options passed to this function is passed on to with_loading_parallel
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
        "$@"                    \
        --                      \
        $cmds
}

# Enter a docker container by name of container
docker_exec_with_bash() {
    local id=$(docker ps --format '{{.ID}} {{.Names}}' | grep $1 | cut -d ' ' -f 1)  
    echo "Entering $1 ($id)"
    docker exec -it $id bash
}

function docker_enter() {
    local containers=$(docker ps --format '{{.Names}}')
    local container_name=

    if [[ $# -eq 0 ]]; then
        container_name=$(echo "$containers" | fzf)
    else
        container_name=$(echo "$containers" | grep $1)
        local number_of_results=${$(echo "$container_name" | wc -w)//[[:space:]]/}
        if [[ $number_of_results -gt 1 ]]; then
            echo "Multiple matches found, please select one"
            container_name=$(echo "$container_name" | fzf)
        fi
    fi
    if [[ -z $container_name ]]; then 
        echo "No container found"
        return
    fi
    local container_id=$(docker ps -qaf "name=$container_name")
    echo "Entering: $container_name ($container_id)"
    docker exec -it $container_id sh
}


# TODO: Handle error from brew
# Currently buggy behaviour if no matches for a search
# Handle casks better - maybe just brew search "$query" and seperate after
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


function brew_search_and_install_parallel() {

    bind_function() {
        local package=$(echo {} | fzf)
        echo "brew install $package"
    }
    local fun=$(typeset -f bind_function | sed '1d;$d')

    local query=$1
    local cmds=(
        "brew search --formulae $query"
        "brew search --casks $query"
    )

    local msgs="Fetching formulae   :Fetching casks      "

    printf "%-20s %-6s\n" "TASK" "STATUS"
    with_loading_parallel           \
        --messages="$msgs"          \
        --format="%-20s %-6s"       \
        --bind="
            local package=\$(echo {} | fzf)
            echo Installing \$package
            brew install \$package --quiet -n
        "                           \
        --                          \
        $cmds
}

function custom_brew() {
    local package=$1
    local t=$2
    echo "Installing $package"
    brew install $package --quiet -n
}

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


function fuzzy_git_log() {
    local commit=$(git log --oneline | \
        fzf --preview 'git show --no-patch --format="%ad%n%an <%ae>" $(echo {} | awk "{print \$1}")')
    printf "\033[0;36mCheckout\033[0m - $commit\n"
    git checkout $(echo $commit | awk "{print \$1}")
}

