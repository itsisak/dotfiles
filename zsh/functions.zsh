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
        # with_loading -m="$out_str    " -d="\b\b\bSTOPPED" -- docker stop $id
        docker stop $id &
    done <<< $(docker ps -a --format "{{.ID}}:{{.Names}}")
    wait
}

test_parallell() {
    set +m
    # Function to simulate a job (can replace with actual job)
    job() {
        sleep $1  # Simulate the job taking $1 seconds
    }

    # Array to store PIDs
    pids=()

    # Start background jobs
    for i in {1..3}; do
        job $((i + 2)) &  # Run job in background with different durations
        pids+=($!)        # Store the background job PID
    done

    # Display loading indicator for each job
    for pid in "${pids[@]}"; do
        (
            # Spinner animation
            spinner="/|\\-/|\\-"
            i=0
            while kill -0 "$pid" 2>/dev/null; do
                i=$(( (i+1) % 8 ))
                printf "\r[Job $pid] ${spinner:$i:1}"
                sleep 0.1
            done
            printf "\r[Job $pid] Done!\n"
        ) &
    done

    wait  # Wait for all jobs to finish
    echo "All jobs completed!"
    set -m
}

# Run a command with a loading animation
# Get result from $WITH_LOADING_RESULT
with_loading() {
    # Customizable options
    local spin_str="⏳⌛️" # Other options: '🤔🙂🤔🙂' '-\|/'
    local spin_str_length=2
    local speed=0.2
    local done_str="🎉"
   
    # Parse flags 
    for i in "$@"; do
        case $i in
            -d=*|--done=*)
                local done_str="${i#*=}"
                shift
                ;;
            -m=*|--message=*)
                local msg="${i#*=}"
                shift
                ;;
            --)
                shift
                break
                ;;
            -*|--*)
                echo "Unknown option $i"
                exit 1
                ;;
            *)
                ;;
        esac
    done

    local i=0
    local cmd="$@"
    local temp_file="/tmp/${cmd// /_}.$$"
   
    # Hide cursor during loading 
    trap 'tput cnorm' EXIT
    tput civis

    pid=$( ("$@") > "$temp_file" & echo $! )

    #printf "\n"
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % $spin_str_length ))
        #printf "\r\033[A"
        if [ -n "${msg+x}" ]; then
            printf "$msg"
        else
            printf "\033[30;1m\$${cmd:-""}" 
        fi
        printf "${spin_str:$i:1} \033[0m\033[s\r\033[B"
        sleep $speed
    done
    
    [[ -n $done_str ]] && printf "\033[u\b\b\b$done_str\n" || printf "%-30s %-15s" $name $id
    
    WITH_LOADING_RESULT=$(< "$temp_file")
    rm -f "$temp_file"
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
