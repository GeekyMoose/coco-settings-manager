#!/bin/sh
#
# DESCRIPTION
# This script checks whether all packages are installed and displays result
# List of required packages is read from config file
# Usual config file is ~.config/linux-settings-manager
#


# ------------------------------------------------------------------------------
# Constants / Vars
# ------------------------------------------------------------------------------
CONFIG_DIR="${HOME}/.config/coco-settings-manager"
CONFIG_EXT="check.conf"

# Internal use
COUNT_TOTAL=0
COUNT_MISSING=0
COLOR_NORMAL="\033[0m"
COLOR_RED="\033[31m"
COLOR_GREEN="\033[32m"


# ------------------------------------------------------------------------------
# ASSET FUNCTIONS
# ------------------------------------------------------------------------------

# Check whether package exists.
# \param 1 Package name to test.
check_package() {
    COUNT_TOTAL=$((COUNT_TOTAL + 1))
    which "$1" > '/dev/null' 2>&1
    if [ $? -ne 0 ]; then
        echo -e "   ${COLOR_RED}*[MISSING]${COLOR_NORMAL} $1"
        COUNT_MISSING=$((COUNT_MISSING + 1))
    else
        echo -e "    ${COLOR_GREEN}[PRESENT]${COLOR_NORMAL} $1"
    fi
}

# Display one section separator.
show_section() {
    echo '-' "$1"
}

# Parse the given file.
# \param 1 The file to parse.
parse_file() {
    # Config file must exist
    if [ ! -f "$1" ];then
        echo -e "${COLOR_RED}[ERROR] '$1' doesn't exists...${COLOR_NORMAL}"
        return 42
    fi
    while read -r line; do
        prefix=$(echo "$line" | cut -c 1)
        word=$(echo "$line" | cut -c 2-)
        if [ -z "$line" ] ; then
            continue
        elif [ $prefix = '#' ]; then
            show_section $word
        else
            check_package "$line"
        fi
    done < "$1"
    return 0
}

# Parse all files in given dir that have given extension
# \param 1 Path where to search
# \param 2 Extension of files to parse
parse_all_files() {
    list_files=$(find ${CONFIG_DIR} -name "*.${CONFIG_EXT}")
    if [ -z "$list_files" ]; then
        echo -e "${COLOR_RED}[ERROR] ${CONFIG_DIR} does not contains any config files (*.${CONFIG_EXT})${COLOR_NORMAL}"
        return 42
    fi
    for file in $list_files ;do
        parse_file "$file"
    done
    return 0
}


# ------------------------------------------------------------------------------
# SCRIPT EXECUTION
# ------------------------------------------------------------------------------
echo "-----------------------------------"
echo " Check Linux Packages"
echo "-----------------------------------"

parse_all_files "$CONFIG_DIR" "$CONFIG_EXT"

# Show me the result!! :p
echo "-----------------------------------"
echo " $COUNT_MISSING missing packages ($(($COUNT_TOTAL - $COUNT_MISSING))/$COUNT_TOTAL)"
echo "-----------------------------------"
