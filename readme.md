# Easy Menu System

An easy to impliment menu system that supports a variety of different options:

  Usage: bash core-menu.sh (-h | --help) (-l | --legacy type) (-c | --config config_location)
    {-l|--legacy} type    -- launch for legacy menu control (possible values: yad, gtkdialog, kdialog, zenity, Xdialog, dialog, none. default: auto select)
    {-h|--help}                     -- print this help message and exit
    {-c|--config} config_location   -- set custom config location (default: ./options/options.json)
