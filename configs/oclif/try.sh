#!/usr/bin/env bash 
function main() {
    config

    # root    
    root=$(cat .oclif.manifest.json | jq .)

    # [jq]>  .commands[] | select(.id | contains(":")).id   
    #filter=".commands[] | select(.id | contains(\":\")).id"

    #id="dad"
    #filter=".commands[] | select(.id==\"${id}\").id"

    filter=".commands[].id"
    result=$(query)
    result+=("quit")


    while true; do
        clear
        # NOTE [@]
        menu ${result[@]}
        answer=$(0< "${dir_tmp}/${file_tmp}" )

        case "$answer" in 
            adapt)
                ;;
            analyze)
                ;;
            calamares)
                ;;
            config)
                ;;
            cuckoo)
                ;;
            dad)
                ;;
            install)
                ;;
            kill)
                ;;
            mom)
                ;;
            produce)
                ;;
            status)
                ;;
            syncfrom)
                ;;
            syncto)
                ;;
            update) 
                ;;
            export) # submenu
                submenu ${answer};;
            tools) # submenu
                submenu ${answer};;
            wardrobe) # submenu
                submenu ${answer};;
            *) # quit and others
                theEnd
                ;;
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

################################
function theEnd {
   echo "regular exit"
   exit 0
}

main

# EOF()