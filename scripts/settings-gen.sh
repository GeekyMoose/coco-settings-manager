#!/bin/bash
#
# Since:    June 2017
# Author:   Constantin Masson
#
#
# DESCRIPTION
# Generate all symlinks for your setting according to confi file content.
#
# CONFIG FILE
# Located at CONFIG_DIR and must have extension CONFIG_EXT
# Script with process each of them
#
# NOTE ABOUT SYMLINKS CREATION
# Default behavior is not to force symlinks creation.
# If a file already exists, it won't be altered.
# Use -f to force link creation (Warning: totally delete the old one)


# -----------------------------------------------------------------------------
# Constants
# -----------------------------------------------------------------------------
COLOR_NORMAL="\033[0m"
COLOR_RED="\033[31m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_GRAY="\033[30m"
# Global vars
ERRORS_COUNTER=0
SCRIPT_NAME=${0##*/} # Removes ./ before script name
FLAGS_LN=

# Settings location
CONFIG_DIR="${HOME}/.config/coco-settings-manager"
CONFIG_EXT="gen.conf"


# ------------------------------------------------------------------------------
# Args and Options
# ------------------------------------------------------------------------------
show_usage_and_exit() {
    echo "Usage: $SCRIPT_NAME [OPTION]..."
    echo "  -h  Show this help"
    echo "  -c  Use given file instead of default config files"
    echo "  -f  Force create link even if already exists (WARNING: delete existing file)"
    exit 0
}

# Process the arguments to look for options and apply them.
# Use getops (See bash reference manual).
#
# \param 1 List of all parameters to parse and process.
# \return Index of the first element following the last option.
process_options() {
    while getopts ":hc:f" optname; do
        case $optname in
            h) show_usage_and_exit ;; # Help
            f) FLAGS_LN='-f' ;; # Force
            c) config_file=$OPTARG ;; # Use config file
            ?) show_usage_and_exit ;; # Unknown option
            :) show_usage_and_exit ;; # Argument missing for option
            *) show_usage_and_exit ;; # Should never occur anyway
        esac
    done
    return $OPTIND
}


# ------------------------------------------------------------------------------
# Print Functions
# ------------------------------------------------------------------------------

print_title() {
    echo -e "*** $1 ***"
}
print_error() {
    echo -e "   ${COLOR_RED}*[ERROR] ${1}${COLOR_NORMAL}"
}
print_warning() {
    echo -e "    ${COLOR_YELLOW}[Warning] ${1}${COLOR_NORMAL}"
}
print_success() {
    echo -e "    ${COLOR_GREEN}[SUCCESS]${COLOR_NORMAL} $1"
}
print_info() {
    echo -e "    ${COLOR_GRAY}[INFO]${COLOR_NORMAL} $1"
}

# Print a message according to given error code.
#
# Will display in red if error, or in green if ok.
# \param 1 Message to display.
show_err_status() {
    if [ $? -ne 0 ]; then
        ERRORS_COUNTER=$((ERRORS_COUNTER + 1))
        print_error "$1"
    else
        print_success "$1"
    fi
}


# ------------------------------------------------------------------------------
# Assets Functions
# ------------------------------------------------------------------------------

# Create a symlink.
#
# \param 1 Source file (Absolute path).
# \param 2 Symlink file (Absolute path).
crea_ln() {
    # File to link must exists
    if [ ! -e "$1" ]; then
        ERRORS_COUNTER=$((ERRORS_COUNTER + 1))
        print_error "$1 doesn't exists..."
        return 42
    fi
    # Only link to file allowed (Not folder)
    if [ ! -f "$1" ];then
        ERRORS_COUNTER=$((ERRORS_COUNTER + 1))
        print_error "$1 is not a file type (Only files allowed for symlinks)"
        return 42
    fi
    msg=$(ln -sv $FLAGS_LN "$1" "$2" 2>&1)
    show_err_status "$msg"
    return 0
}

# Create a repertory if doesn't exists.
#
# \params 1 Folder to create (Full path).
crea_rep() {
    if [ -e "$1" ] && [ ! -d "$1" ]; then
        ERRORS_COUNTER=$((ERRORS_COUNTER + 1))
        print_error "$1 already exists and is a file"
        return 1
    fi
    if [ -e "$1" ] && [ -d "$1" ]; then
        print_info "folder $1 already exists"
        return 1
    fi
    msg=$(mkdir -pv "$1" 2>&1)
    show_err_status "$msg"
}

# Browser scripts folder and create the link with specific renaming rule.
#
# \param 1 Source folder.
# \param 2 Destination folder.
crea_sh_ln() {
    # Script folder must exists
    if ! [ -e "$1" ]; then
        ERRORS_COUNTER=$((ERRORS_COUNTER + 1))
        print_error "$1 doesn't exists..."
        return 42
    fi
    scripts=$(ls "$1")
    for f in $scripts; do
        name=${f%.sh} # Removes sh extension
        name="zozo-$name"
        crea_ln "$1/$f" "$2/$name" # Folder case handled in crea_ln
    done
}

# Browser the current folder and link each files inside.
# This does not link the folder itself (But its content only).
#
# \param 1 Source folder.
# \param 2 Destination folder.
crea_rep_ln() {
    # Folder must exists
    if ! [ -e "$1" ]; then
        ERRORS_COUNTER=$((ERRORS_COUNTER + 1))
        print_error "$1 doesn't exists..."
        return 42
    fi
    file=$(ls "$1")
    for f in $file; do
        if [ -f "$1/$f" ]; then
            crea_ln "$1/$f" "$2/$f"
        fi
    done
}

# Execute a shell command.
#
# \param 1 The shell command to execute.
exec_cmd() {
    msg=$(eval "$1")
    show_err_status "Execute '$1' $msg"
}


# ------------------------------------------------------------------------------
# Parse functions
# ------------------------------------------------------------------------------

# Parse one line of the config file.
#
# \param 1 The line to parse.
parse_line() {
    line="$1"
    if [ -z "$line" ]; then
        return 1
    fi
    # " are removed in case of user write path in config as "the/path"
    # The " would create strange behavior (Element created at $PWD)
    command=$(echo "$line"  | tr -d '"' | tr -s ' ' | cut -d ' ' -f 1)
    params=$(echo "$line"   | tr -d '"' | tr -s ' ' | cut -d ' ' -f 2-)
    param1=$(echo "$line"   | tr -d '"' | tr -s ' ' | cut -d ' ' -f 2)
    param2=$(echo "$line"   | tr -d '"' | tr -s ' ' | cut -d ' ' -f 3)

    # Eval required to reevaluate var (like $HOME) to its actual value
    source=$(eval echo $param1)
    dest=$(eval echo $param2)

    # Action according to command value
    case "$command" in
        'crea_ln')      crea_ln "$source" "$dest" ;;
        'crea_rep')     crea_rep "$source" ;;
        'crea_rep_ln')  crea_rep_ln "$source" "$dest" ;;
        'crea_sh_ln')   crea_sh_ln "$source" "$dest" ;;
        'show_title')   print_title "$params" ;;
        'show_warning') print_warning "$params" ;;
        'execute')      exec_cmd "$params" ;;
    esac
}

# Parse the entire file.
#
# \param 1 File to parse.
parse_file() {
    while read -r line ;do
        parse_line "$line"
    done < "$1"
}

# Parse all files with given extension in the path given.
#
# \param 1 Path where to search.
# \param 2 File extension.
parse_all_files() {
    list_files=$(find "$1" -name "*.$2" 2>&1)
    if [ -z "$list_files" ]; then
        echo -e "${COLOR_RED}[ERROR] $1 does not contains any config files (*.${2})${COLOR_NORMAL}"
        return 42
    fi
    for file in $list_files ;do
        parse_file "$file"
    done
    return 0
}


# ------------------------------------------------------------------------------
# Script execution
# ------------------------------------------------------------------------------
process_options "$@"

echo "-------------------------------------------------------------------------"
echo "Settings configuration"
echo "-------------------------------------------------------------------------"

# If file given in parameter, process it instead of default behavior
if [ ! -z $config_file ]; then
    # Config file must exists and be a file
    if [ ! -f "$config_file" ];then
        echo -e "${COLOR_RED}[ERROR] ${config_file} does exists or is not a file...${COLOR_NORMAL}"
        exit 42
    fi
    parse_file "$config_file"
else
    # Config dir must exists
    if [ ! -d "$CONFIG_DIR" ];then
        echo -e "${COLOR_RED}[ERROR] ${CONFIG_DIR} does exists or is not a folder...${COLOR_NORMAL}"
        exit 42
    fi
    parse_all_files "$CONFIG_DIR" "$CONFIG_EXT"
fi


echo "-------------------------------------------------------------------------"
if [ $ERRORS_COUNTER -ne 0 ]; then
    echo -e " $ERRORS_COUNTER Errors"
else
    echo -e " Finished successfully"
fi
echo "-------------------------------------------------------------------------"
