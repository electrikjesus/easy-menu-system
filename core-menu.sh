#!/bin/bash
set -e

# Start heading
EASYLEGACY="false"
OCONFIG=""

arg0=$(basename "$0" .sh)
blnk=$(echo "$arg0" | sed 's/./ /g')

usage_info()
{
    echo "Usage: $arg0 [-l|--legacy] type"
    echo "       $blnk [{-c|--config} config_location] "
    echo "       $blnk [-d|--debug]"
    echo "       $blnk [-h|--help]"
}

usage()
{
    exec 1>2   # Send standard output to standard error
    usage_info
    continue 2
}

error()
{
    echo "$arg0: $*" >&2
    exit 1
}

help()
{
    usage_info
    echo
    echo "  {-l|--legacy} type              -- launch for legacy menu control (possible values: yad, gtkdialog, kdialog, zenity, Xdialog, dialog, none. default: auto select)"
    echo "  {-h|--help}                     -- print this help message and exit"
    echo "  {-d|--debug}                     -- prints verbose info for debugging"
    echo "  {-c|--config} config_location   -- set custom config location (default: ./options/options.json)"
    [[ $_ != $0 ]] && exit 0 2>/dev/null || return 0 2>/dev/null;

}

flags()
{
    while test $# -gt 0
    do
        case "$1" in
        (-l|--legacy)
            shift
            [ $# = 0 ] && OCTYPE="" || OCTYPE="$1"
            EASYLEGACY="true"
            shift;;
        (-c|--config)
            shift
            [ $# = 0 ] && error "No config specified"
            OCONFIG="$1"
            shift;;
        (-d|--debug)
            echo "Debug Mode Enabled"
            EZ_DEBUG_MODE="true"
            shift;;
        (-h|--help)
            help ;;
        (*) usage;;
        esac
    done
}

flags "$@"

# End heading

SCRIPT_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
MAIN_SCRIPT_PATH=$SCRIPT_PATH
INCLDIR=$MAIN_SCRIPT_PATH/includes
optionspath=$MAIN_SCRIPT_PATH/options
temp_path="$MAIN_SCRIPT_PATH/tmp/"

export SCRIPT_PATH="$SCRIPT_PATH"
export supertitle="Start Menu"
export supericon=""
source $INCLDIR/common.sh

# if debug or tty, set "supermode" var to "none"
# export supermode="none" && source easybashgui
if [[ "$EASYLEGACY" == "true" ]]; then
  export supermode="$OCTYPE" && source $MAIN_SCRIPT_PATH/includes/easybashgui
else
  export supermode="" && source $MAIN_SCRIPT_PATH/includes/easybashgui
  source $MAIN_SCRIPT_PATH/includes/easybashgui.lib
fi

if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
  export EZ_DEBUG_MODE="true"
else
  export EZ_DEBUG_MODE="false"
fi

# If OCONFIG is not "" then set the options file to the passed location
if [[ "$OCONFIG" != "" ]]; then
  options_path=$OCONFIG
else
# Otherwise, set the options file to the default location
  options_path=$optionspath/options.json
fi

# Detect 32/64 bit host

HOST_ARCH=$(uname -m)
chmod +x $INCLDIR/jq-linux*
if [[ "$HOST_ARCH" == "x86_64" ]]; then
	alias jq=$INCLDIR/jq-linux64
else
	alias jq=$INCLDIR/jq-linux32
fi

# use jq to grab the following variables for the menu options:
#   - option name (string)
#   - if it is a suboption (bool)
#   - command (string)
#   - dependencies (array)

MENUOPTIONS=()
while IFS= read -r entry; do
    MENUOPTIONS+=("$entry")
    if [[ "$EZ_DEBUG_MODE" == "true" ]]; then 
      echo "Menuoptions Entry: $entry"
    fi
done < <(jq -r '.options.menuEntry[]?.name' $options_path)

while :
	do
  menu "${MENUOPTIONS[@]}"
	answer=$(0< "${dir_tmp}/${file_tmp}")
	
	for i in "${MENUOPTIONS[@]}" ; do
    i="$(echo ${i} |  tr -d '\n' | tr -d '\r' | tr -d \")"
		if [[ "$(echo ${answer} |  tr -d '\n' | tr -d '\r')" == "${i}" ]]; then
      if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
			  echo "Starting \"${i}\" ..."
      fi
			j=${i}
      if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
        echo -e ${reset}""${reset}
        echo -e ${teal}"${i}"${reset}
        echo -e ${reset}""${reset}
      fi
      SUBMENUOPTIONS=()
      while IFS= read -r subentry; do
          SUBMENUOPTIONS+=("$subentry")
      done < <(jq -r '.options.menuEntry[]? | select(.name == "'"$i"'") | .subMenuEntry[]?.name' $options_path)
      if [[ "${SUBMENUOPTIONS[@]}" != "" ]]; then
        while :
        do
          menu ".." "${SUBMENUOPTIONS[@]}"
          answer=$(0< "${dir_tmp}/${file_tmp}" )
          
          for s in "${SUBMENUOPTIONS[@]}" ; do
            s="$(echo ${s} |  tr -d '\n' | tr -d '\r' | tr -d \")"
            if [[ "$(echo ${answer} |  tr -d '\n' | tr -d '\r')" == "${s}" ]]; then
              notify_message "Starting \"${s}\" ..."
              if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
                echo -e ${reset}""${reset}
                echo -e ${ltgreen}"${s}"${reset}
                echo -e ${reset}""${reset}
              fi
              # Check Dependencies

              SUBMENUITEMDEPS=()
              while IFS= read -r menuitem; do
                  SUBMENUITEMDEPS+=("$menuitem")
              done < <(jq -r '.options.menuEntry[]? | select(.name == "'"$i"'") | .dependencies[]?.dep' $options_path)
              smconfigerror="false"
              if [ "${SUBMENUITEMDEPS[@]}" ]; then
                for sm in "${SUBMENUITEMDEPS[@]}" ; do
                  $sm # 2>/dev/null;
                  if [ $? -eq 0 ]; then
                    if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
                      echo OK
                    fi
                  else
                    if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
                      echo FAIL
                    fi
                    smconfigerror="true";
                  fi
                done
              fi
              if [[ "$smconfigerror" != "true" ]]; then
                # Execute Option
                if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
                  echo "executing command for: ${s}"
                fi
                execSubCommand=()
                while IFS= read -r subentry; do
                    execSubCommand+=("$subentry")
                done < <(jq -r '.options.menuEntry[]? | select(.name == "'"$i"'") | .subMenuEntry[]? | select(.name == "'"$s"'") | .command' $options_path)
                if [[ "$EZ_DEBUG_MODE" == "true" ]]; then 
                  echo "Ececuting SubCommand Entry: $execSubCommand"
                fi
                $execSubCommand # 2>/dev/null;
                if [ $? -eq 0 ]; then
                  if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
                    echo OK
                  fi
                else
                  if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
                    echo "The script failed" >&2
                  fi
                fi
              else
                if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
                  echo "Dependencies not met for: $s"
                fi
              fi
              continue 2
            fi
            
          done
          if [[ "$(echo ${answer} |  tr -d '\n' | tr -d '\r')" == "" ]]; then
            continue 2
          fi
          if [[ "${answer}" == ".." ]]; then
            continue 2
          fi
        done
      fi

      # Check Dependencies

      MENUITEMDEPS=()
      while IFS= read -r menuitem; do
          MENUITEMDEPS+=("$menuitem")
      done < <(jq -r '.options.menuEntry[]? | select(.name == "'"$i"'") | .dependencies[]?.dep' $options_path)
      mconfigerror="false"
      if [ "${MENUITEMDEPS[@]}" ]; then
        for m in "${MENUITEMDEPS[@]}" ; do
          if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
            echo $m
          fi
          $m # 2>/dev/null;
          if [ $? -eq 0 ]; then
            if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
              echo OK
            fi
          else
            if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
              echo FAIL
            fi
             mconfigerror="true";
          fi
        done
      fi
      if [[ "$mconfigerror" != "true" ]]; then
        # Execute Option
        if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
          echo "executing command for: ${i}"
        fi      
        execCommand=()
        while IFS= read -r cmdentry; do
            execCommand+=("$cmdentry")
        done < <(jq -r '.options.menuEntry[]? | select(.name == "'"$i"'") | .command' $options_path)
        if [[ "$EZ_DEBUG_MODE" == "true" ]]; then 
          echo "Executing Command Entry: $execCommand"
        fi
        $execCommand # 2>/dev/null;
        if [ $? -eq 0 ]; then
          if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
            echo OK
          fi
        else
          if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
            echo "The script failed" >&2;
          fi
        fi
      else
        if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
          echo "Dependencies not met for: $i"
        fi
      fi

		fi
		
	done
	if [[ "$(echo ${answer} |  tr -d '\n' | tr -d '\r')" == "" ]]; then
    if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
		  echo "exiting..."
    fi
    [[ $_ != $0 ]] && exit 0 2>/dev/null || return 0 2>/dev/null;
	fi
	
done

clean_temp #(since v.6.X.X this function is no more required if easybashlib is present and then successfully loaded by easybashgui)
