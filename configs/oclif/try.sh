#!/usr/bin/env bash 
function main() {
    config

    # root    
    root=$(cat .oclif.manifest.json | jq .)

    # [jq]>  .commands[] | select(.id | contains(":")).id   
    #filter=".commands[] | select(.id | contains(\":\")).id"

    #id="dad"
    #filter=".commands[] | select(.id==\"${id}\").id"

    result=$(echo ${root} | jq ".commands[].id")
    result+=("quit")

    while true; do
        clear
        # NOTE [@]
        menu ${result[@]}
        answer=$(0< "${dir_tmp}/${file_tmp}" )
        case "$answer" in 
            quit)
                exit ;;
            *)
                msg="$answer\n\n"
                msg+="syntax: eggs $answer"
                msg+="\nDescription:\n"
                msg+=$(echo ${root} | jq ".commands[] | select(.id=="\"$answer\"").description")
                message $msg

                examples=$(echo ${root} | jq ".commands[] | select(.id=="\"$answer\"").examples")
                msg="$answer\n\n"
                msg+=$examples
                message $msg;;
        esac
    done

    exit 0
}

# 
# filter=".commands[] | select(.id | contains(\":\")).id"
# filter=".commands[] | select(.id==\"${id}\").id"
function query() {
    local retval=$(echo ${root} | jq "${filter}")
    echo ${retval}    
}

################################
function config() {
    # configurations
    set -e

    # Disable unicode.
    LC_ALL=C
    LANG=C

    # easy-bash-gui
    MSP=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    source ${MSP}/includes/easybashgui
    source ${MSP}/includes/easybashgui.lib
    source ${MSP}/includes/common.sh

}

################################
function press_a_key_to_continue {
   read -rp "Press enter to continue"
}

main

# EOF()