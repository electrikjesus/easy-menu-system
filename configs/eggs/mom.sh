#!/usr/bin/env bash
#
#####################################

MSP=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
#/home/artisan/easy-menu-system/configs/eggs
echo $MSP
source ${MSP}/../../includes/easybashgui
source ${MSP}/../../includes/easybashgui.lib
source ${MSP}/../../includes/common.sh


main() {
    title=$(jq .project ${MSP}/eggs.json)

    name=$(jq '.options.menuEntry[].name' ${MSP}/eggs.json )
    
    while true; do
        clear
        menu ${name}
        answer=$(0< "${dir_tmp}/${file_tmp}" )

        case "$answer" in 
            adapt)
                flags 0 ;;
            calamares)
                flags 1;;
            dad)
                flags 2;;
            help)
                flags 3;;
            kill)
                flags 4;;
            install)
                flags 5;;
            produce)
                flags 6;;
            syncfrom)
                flags 7;;
            syncto)
                flags 8;;
            status)
                flags 9;;
            update)
                flags 10;;
            export)
                submenu 11;;
            tools)
                submenu 12 ;;
            quit)
                theEnd ;;
        esac
    done

}


function tools() {
    echo "tools"

}

################################
function flags() {
    filter=".options.menuEntry[$1].flags"
    flags=$(jq ${filter} ${MSP}/eggs.json )
    echo "flags: ${flags}"
    press_a_key_to_continue
}

################################
function submenu() {
    _filter=".options.menuEntry[$1].submenu[].name"
    _name=$(jq ${_filter} ${MSP}/eggs.json )
    menu ${_name}
    _answer=$(0< "${dir_tmp}/${file_tmp}" )
    press_a_key_to_continue
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