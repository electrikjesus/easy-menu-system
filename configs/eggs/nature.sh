#!/usr/bin/env bash
#
#####################################

source ../includes/easybashgui
source ../includes/easybashgui.lib

main() {
    title=$(jq .project mom.json)

    name=$(jq '.options.menuEntry[].name' mom.json )

    while true; do
        clear
        answer=$(menu ${name})
        answer=$(0< "${dir_tmp}/${file_tmp}" )

        case "$answer" in 
            adapt)
                adapt ;;
            calamares)
                ;;
            dad)
                ;;
            help)
                ;;
            kill)
                ;;
            install)
                ;;
            produce)
                ;;
            syncfrom)
                ;;
            syncto)
                ;;
            status)
                ;;
            update)
                ;;
            export)
                ;;
            tools)
                tools ;;
            quit)
                theEnd ;;
        esac
    done

}


function tools() {
    echo "tools"

}

################################
function adapt() {
    flags=$(jq '.options.menuEntry[0].flags' mom.json )
    echo "flags: ${flags}"
    press_a_key_to_continue
}


################################
function press_a_key_to_continue {
   read -rp "Press enter to continue"
}

################################
function theEnd {
   clear
   echo "regular exit"
   exit 0
}


main