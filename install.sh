#!/bin/bash
#
# This script 'install' the beautifully ugly coco manager.
# Basically, all it does is the following:
# - Creates the config folder
# - Places the scripts in bin folder


# -----------------------------------------------------------------------------
# Constants
# -----------------------------------------------------------------------------
COLOR_NORMAL="\033[0m"
COLOR_GRAY="\033[30m"
COLOR_RED="\033[31m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_BLUE="\033[34m"

CONFIG_DIR="${HOME}/.config/coco/"
BIN_DIR="${HOME}/.local/bin/"


# ------------------------------------------------------------------------------
# Print methods
# ------------------------------------------------------------------------------
print_error() {
    echo -e "${COLOR_RED}[Error] ${1}${COLOR_NORMAL}"
}
print_warning() {
    echo -e "${COLOR_YELLOW}[Warning] ${1}${COLOR_NORMAL}"
}
print_success() {
    echo -e "${COLOR_GREEN}[OK]${COLOR_NORMAL} $1"
}
print_info() {
    echo -e "${COLOR_GRAY}[Info]${COLOR_NORMAL} $1"
}


# ------------------------------------------------------------------------------
# Internal use methods
# ------------------------------------------------------------------------------

ERROR_COUNTER=0 # Internal use variable

check_last_method() {
    if [ $? -ne 0 ]; then
        ERROR_COUNTER=$((ERROR_COUNTER + 1))
        print_error "$1"
    else
        print_success "$1"
    fi
}


# ------------------------------------------------------------------------------
# Script main execution
# ------------------------------------------------------------------------------
echo "---> Installing coco-settings-manager..."

# Creates config directory
if [ -e "$CONFIG_DIR" ] && [ -d "$CONFIG_DIR" ]; then
    print_info "Folder $CONFIG_DIR already exists"
else
    msg=$(mkdir -pv "$CONFIG_DIR" 2>&1)
    check_last_method "$msg"
fi

# Places scripts in bin folder
msg=$(cp -v "${PWD}/scripts/settings-check.sh" \
            "${BIN_DIR}/coco-settings-check" 2>&1)
check_last_method "$msg"

msg=$(cp -v "${PWD}/scripts/settings-gen.sh" \
            "${BIN_DIR}/coco-settings-gen" 2>&1)
check_last_method "$msg"

# Installation overview
if [ $ERROR_COUNTER -eq 0 ]; then
    print_success "coco-settings-manager successfully installed"
else
    print_error "$ERROR_COUNTER errors occurred"
fi


