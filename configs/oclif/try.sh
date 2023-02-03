#!/usr/bin/env bash
MSP=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo $MSP
source ${MSP}/includes/easybashgui
source ${MSP}/includes/easybashgui.lib
source ${MSP}/includes/common.sh

function query() {
    # working 
    # - echo ${root} | jq ".commands[] | select(.id=="'"calamares"'") | .flags[].name"
    # - echo ${root} | jq "${filter}"
    # - result=`echo ${root} | jq "${filter}"`
    #
    result=`echo ${root} | jq "${filter}"`
}

function initMenu() {
    # Disable unicode.
    LC_ALL=C
    LANG=C

    # working 
    # - root=$(cat .oclif.manifest.json | jq .)
    # - filter=".commands[] | select(.id=="'"calamares"'") | .flags[].name"
    # - filter=".commands[] | select(.id==\"${id}\") | .flags[].name"
    # - query "${filter}"
    root=$(cat .oclif.manifest.json | jq .)
  
}

initMenu

id="dad"
filter=".commands[] | select(.id==\"${id}\") | .flags[].name"
query "${filter}"
echo "filter: ${filter}"
echo "result: ${result}"
exit 0

