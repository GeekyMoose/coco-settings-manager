#!/bin/bash
#
# Generates all symlinks for your setting according to the config file.
# See help for the behaviors


# -----------------------------------------------------------------------------
# Constants
# -----------------------------------------------------------------------------
COLOR_NORMAL="\033[0m"
COLOR_GRAY="\033[30m"
COLOR_RED="\033[31m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_BLUE="\033[34m"

# Settings location
CONFIG_DIR="${HOME}/.config/coco/" # Where to search
CONFIG_EXT="gen.conf" # File ext to process

# Intermal vars
ERROR_COUNTER=0
SCRIPT_NAME=${0##*/} # Removes ./ before script name
FLAGS_LN=


# ------------------------------------------------------------------------------
# Args and options
# ------------------------------------------------------------------------------
show_usage_and_exit() {
    echo "Usage: $SCRIPT_NAME [OPTION]..."
    echo "Generates the configuration decribed by the configuration files."
    echo "Looks for all config files under $CONFIG_DIR directory."
    echo "Config file is any file that end with extension $CONFIG_EXT."
    echo "  -h  Show this help."
    echo "  -c  Use a specific file instead of default one."
    echo "  -f  Force create link if already exists (WARNING: delete existing file)."
    echo ""
    echo "The default behavior is not to force symlinks creation."
    echo "If a file already exists, it won't be altered."
    echo "Use -f to force link creation (Warning: totally delete the old one)"
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
            h) show_usage_and_exit ;;   # Help
            f) FLAGS_LN='-f' ;;         # Force
            c) config_file=$OPTARG ;;   # Use config file
            ?) show_usage_and_exit ;;   # Unknown option
            :) show_usage_and_exit ;;   # Argument missing for option
            *) show_usage_and_exit ;;   # Should never occur anyway
        esac
    done
    return $OPTIND
}


# ------------------------------------------------------------------------------
# Print methods
# ------------------------------------------------------------------------------

print_title() {
    echo -e "---> $1"
}
print_error() {
    echo -e "${COLOR_RED}[ERROR] ${1}${COLOR_NORMAL}"
}
print_warning() {
    echo -e "${COLOR_YELLOW}[WARNING] ${1}${COLOR_NORMAL}"
}
print_success() {
    echo -e "${COLOR_GREEN}[SUCCESS]${COLOR_NORMAL} $1"
}
print_info() {
    echo -e "${COLOR_GRAY}[INFO]${COLOR_NORMAL} $1"
}

# Print a message according to given error code.
#
# Will display in red if error, or in green if ok.
# \param 1 Message to display.
show_err_status() {
    if [ $? -ne 0 ]; then
        ERROR_COUNTER=$((ERROR_COUNTER + 1))
        print_error "$1"
    else
        print_success "$1"
    fi
}


# ------------------------------------------------------------------------------
# Commands
# ------------------------------------------------------------------------------

# Creates a symlink.
#
# \param 1 Source file (absolute path).
# \param 2 Symlink file (absolute path).
crea_ln() {
    # File to link must exists
    if [ ! -e "$1" ]; then
        ERROR_COUNTER=$((ERROR_COUNTER + 1))
        print_error "$1 doesn't exists"
        return 42
    fi
    # Only link to file allowed (not folder)
    if [ ! -f "$1" ]; then
        ERROR_COUNTER=$((ERROR_COUNTER + 1))
        print_error "$1 is not a file (only files allowed for symlinks)"
        return 42
    fi
    msg=$(ln -sv $FLAGS_LN "$1" "$2" 2>&1)
    show_err_status "$msg"
    return 0
}

# Creates a repertory.
# Does nothing if it already exists.
#
# \params 1 Folder to create (full path).
crea_rep() {
    if [ -e "$1" ] && [ ! -d "$1" ]; then
        ERROR_COUNTER=$((ERROR_COUNTER + 1))
        print_error "$1 already exists but is a file"
        return 1
    fi
    if [ -e "$1" ] && [ -d "$1" ]; then
        print_info "$1 already exists"
        return 1
    fi
    msg=$(mkdir -pv "$1" 2>&1)
    show_err_status "$msg"
}

# Browses a folder and creates the link to each files inside.
# This is meant to be used for folder with only scripts inside.
# Removes .sh file extension and add the given prefix.
# (e.g., Prefix 'perso-' on file 'testX.sh' gives 'perso-testX')
#
# \param 1 Source folder.
# \param 2 Destination folder.
# \param 3 Prefix to add on file symlinks
crea_sh_ln() {
    # Script folder must exists
    if ! [ -e "$1" ]; then
        ERROR_COUNTER=$((ERROR_COUNTER + 1))
        print_error "$1 doesn't exists"
        return 42
    fi
    scripts=$(ls "$1")
    for f in $scripts; do
        name=${f%.sh} # Removes sh extension
        name="${3}$name"
        crea_ln "$1/$f" "$2/$name" # Folder case handled in crea_ln
    done
}

# Browses the current folder and links each files inside.
# This does not link the folder itself but its content only.
#
# \param 1 Source folder.
# \param 2 Destination folder.
crea_rep_ln() {
    # Folder must exists
    if ! [ -e "$1" ]; then
        ERROR_COUNTER=$((ERROR_COUNTER + 1))
        print_error "$1 doesn't exists"
        return 42
    fi
    file=$(ls "$1")
    for f in $file; do
        if [ -f "$1/$f" ]; then
            crea_ln "$1/$f" "$2/$f"
        fi
    done
}

# Executes a shell command.
#
# \param 1 The shell command to execute.
exec_cmd() {
    msg=$(eval "$1")
    show_err_status "Executing '$1' ${msg}..."
}


# ------------------------------------------------------------------------------
# Parse functions
# ------------------------------------------------------------------------------

# Parses one line from the config file.
#
# \param 1 The line to parse.
parse_line() {
    line="$1"
    if [ -z "$line" ]; then
        return 1
    fi
    # Chars " are removed in case user writes path in config like "the/path"
    # The " would create unexpected behavior (element created at $PWD)
    command=$(echo "$line"  | tr -d '"' | tr -s ' ' | cut -d ' ' -f 1)
    params=$(echo "$line"   | tr -d '"' | tr -s ' ' | cut -d ' ' -f 2-)
    param1=$(echo "$line"   | tr -d '"' | tr -s ' ' | cut -d ' ' -f 2)
    param2=$(echo "$line"   | tr -d '"' | tr -s ' ' | cut -d ' ' -f 3)
    param3=$(echo "$line"   | tr -d '"' | tr -s ' ' | cut -d ' ' -f 4)

    # Eval required to re-evaluate vars to its actual value (i.e., $HOME).
    source=$(eval echo $param1)
    dest=$(eval echo $param2)

    # Exec command
    case "$command" in
        'crea_ln')      crea_ln "$source" "$dest" ;;
        'crea_rep')     crea_rep "$source" ;;
        'crea_rep_ln')  crea_rep_ln "$source" "$dest" ;;
        'crea_sh_ln')   crea_sh_ln "$source" "$dest" "$param3" ;;
        'show_title')   print_title "$params" ;;
        'show_warning') print_warning "$params" ;;
        'execute')      exec_cmd "$params" ;;
    esac
}

# Parses an entire file.
#
# \param 1 File to parse.
parse_file() {
    while read -r line ;do
        parse_line "$line"
    done < "$1"
}

# Parses all files with the given extension and located in the path given.
#
# \param 1 Path where to search.
# \param 2 File extension.
parse_all_files() {
    list_files=$(find "$1" -name "*.$2" 2>&1)
    if [ -z "$list_files" ]; then
        ERROR_COUNTER=$((ERROR_COUNTER + 1))
        print_error "$1 does not contain any config files (*.${2})"
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

echo "---> Generating coco-settings configuration..."

# If file given in parameter, process it instead of default behavior
if [ ! -z $config_file ]; then
    # Config file must exists
    if [ ! -f "$config_file" ];then
        print_error "${config_file} does exists or is not a file"
        exit 42
    fi
    parse_file "$config_file"
else
    # Config folder must exists
    if [ ! -d "$CONFIG_DIR" ];then
        print_error "${CONFIG_DIR} does exists or is not a folder"
        exit 42
    fi
    parse_all_files "$CONFIG_DIR" "$CONFIG_EXT"
fi


if [ $ERROR_COUNTER -ne 0 ]; then
    print_error "$ERROR_COUNTER errors"
else
    print_success "Script finished successfully"
fi


