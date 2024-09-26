
# Run commands in parallel with individual loading indicators
# This is not very efficient as it uses a lot of CPU
# and is not faster if the command itself can run in parallel
# but it looks cool ;)
function with_loading_parallel() {

    help() {
        h_print() { printf "  %-10s %-18s %-50s\n" "$@" }
        echo
        echo "Usage: with_loading_parallel [options] [command_as_string ...]" 
        echo
        echo "Run jobs in parallel with indidividual loading indicators"
        echo
        echo "Options"
        h_print "-d=<str>,"     "--done=<str>"      "String to be shown when job is done"
        h_print "-m=<str>,"     "--message=<str>"   "String to describe job"
        h_print "-f=<str>,"     "--format=<str>"    "Format of output"
        h_print ""              "--spin=<str>"      "Loading indicator string (requires --slen aswell)"
        h_print ""              "--slen=<str>"      "Length of loading indicator string"
        h_print ""              "--speed=<str>"     "Speed of loading indicator"
        h_print "-q,"           "--quiet"           "No loading output (antipattern, do not use this function)"
        h_print "-o,"           "--out"             "Override loading with job output when done"
        h_print "",             "--bind=<str>"      "Run function passed as string, with result of with_loading_parallel"
        h_print "-h"            "--help"            "Print this help and exit"
        h_print ""              "--"                "End of flags"
    }
    
    local spin_str="⏳⌛️"
    local spin_str_length=2
    local speed=0.2
    local done_str="DONE"
    local out_fmt="%-30s %-10s"
    local in_messages=

    # Parse options
    for i in "$@"; do
        case $i in
            -d=*|--done=*) # String to be shown when job is done
                done_str="${i#*=}"
                shift
                ;;
            -m=*|--messages=*) # String to describe job
                in_messages="${i#*=}"
                shift
                ;;
            -f=*|--format=*) # Format of output
                out_fmt="${i#*=}"
                shift
                ;;
            --spin=*) # Loading indicator string
                spin_str="${i#*=}"
                shift
                ;;
            --slen=*) # Length of loading indicator string
                spin_str_length="${i#*=}"
                shift
                ;;
            --speed=*) # Speed of loading indicator
                speed="${i#*=}"
                shift
                ;;
            -q|--quiet) # Do not print output (antipattern, do not use this function)
                local quiet=1
                shift
                ;;
            -o|--out) # Override loading with job output when done
                local out=1
                shift
                ;;
            --bind=*)
                local bind_func="${i#*=}"
                shift
                ;;
            -h|--help) # Prints help and exits
                help
                exit 1
                ;;
            --) # End of flags
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

    # Show help and exit if no commands is passed
    if [[ $# -eq 0 ]]; then
        help
        exit 1
    fi
    
    # Setup 
    local cmds=($argv)
    local cmds_size=$#
    local tmp_file="/tmp/with_loading_parallel_output_$$"
    local pids=()
    set +m
    tput civis

    if [[ -n $in_messages ]]; then
        IFS=':' read -r -A messages <<< "$in_messages"
    else
        messages=($argv)
    fi
    
    # Helper functions
    out() {
        [[ -z $quiet ]] && printf "$@"
    }
    outf() {
        out "\r$out_fmt\n" "$@"
    }
    move() {
        [[ -z $quiet ]] && tput "$@"
    }
    any_pid_is_active() {
        for pid in "${pids[@]}"; do
            if kill -0 "$pid" 2>/dev/null; then; return 0; fi
        done
        return 1
    }
    handle_interrupt() {
        trap SIGINT
        # Might override other output
        out "\nInterrupt received. Terminated jobs: "
        for pid in "${pids[@]}"; do
            if kill -0 $pid 2>/dev/null; then
                kill $pid
                out "$pid,"
            fi
        done
        out "\b \n"
        rm -f "$tmp_file"
        set -m
        tput cnorm
        exit
    }
    trap handle_interrupt INT
    
    # Start jobs
    for i in {1..$cmds_size}; do
        outf "${messages[i]}" "${spin_str:0:1}"
        eval "${cmds[i]}" >>"$tmp_file" 2>/dev/null &
        pids[$i]="$!"
    done
     
    # Show loading
    local i=0 
    while any_pid_is_active; do 
        i=$(( (i+1) % $spin_str_length ))
        move cuu $cmds_size
        for j in {1..$cmds_size}; do
            local pid="${pids[j]}"
            if kill -0 "$pid" 2>/dev/null
            then; outf "${messages[j]}" "${spin_str:$i:1}"
            else; outf "${messages[j]}" "$done_str"
            fi
        done
        sleep $speed
    done

    # Clean up loading output
    move cuu $cmds_size
    for j in {1..$cmds_size}; do
        if [[ -v $out ]]; then
            outf '\033[K'
        else
            outf "${messages[j]}" "$done_str"
        fi
    done
    
    # Print output of jobs
    if [[ -v $out ]]; then 
        move cuu $cmds_size
        cat $tmp_file
    fi
    
    if [[ -n $bind_func ]]; then
        local output=$(<$tmp_file)
        if [[ "$bind_func" == *"{}"* ]]; then
            bind_func="${bind_func//\{\}/\"$output\"}"
        fi
        # echo "$bind_func"
        eval "$bind_func"
    fi
    
    # Cleanup
    rm -f "$tmp_file"
    tput cnorm
    set -m
    trap SIGINT
}

# Run a command with a loading animation
# Get result from $WITH_LOADING_RESULT
# Outdated by with_loading_parallel
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
