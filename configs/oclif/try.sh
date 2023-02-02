#!/bin/env bash

function getIdFlagsNames() {
    #[jq]>  .commands[] | select(.id=="calamares").flags[] | .name
    filter='.commands[] | select(.id=="'"$1"'").flags[] | | .name'
    jq ${filter} ./.oclif.manifest.json
    echo $1
}

function getId() {
    #[jq]>  .commands[] | select(.id=="calamares")
    filter='.commands[] | select(.id=="'"$1"'")'
    jq ${filter} ./.oclif.manifest.json
    echo ${filter}
}

# Disable unicode.
LC_ALL=C
LANG=C

id="calamares"
getId ${id}
#getIdFlagsNames ${id}


