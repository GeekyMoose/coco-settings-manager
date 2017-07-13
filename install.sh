#!/bin/sh
#
# Since:    June 2017
# Author:   Constantin Masson
#
# DESCRIPTION
# 'install' this beautiful and ugly coco manager.
#
# Basically, this is what it does:
# - Create the config folder ($CONFIG_DIR value)
# - Place scripts in bin folder ($BIN_DIR value)


# -----------------------------------------------------------------------------
# Constants
# -----------------------------------------------------------------------------
COLOR_NORMAL="\033[0m"
COLOR_RED="\033[31m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_GRAY="\033[30m"

CONFIG_DIR="${HOME}/.config/coco-settings-manager"
BIN_DIR="${HOME}/.local/bin"

# Variables
ERROR_COUNTER=0


# ------------------------------------------------------------------------------
# Print Functions
# ------------------------------------------------------------------------------
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
show_err_status() {
    if [ $? -ne 0 ]; then
        ERROR_COUNTER=$((ERROR_COUNTER + 1))
        print_error "$1"
    else
        print_success "$1"
    fi
}


# ------------------------------------------------------------------------------
# Execution
# ------------------------------------------------------------------------------
echo "-------------------------------------------------------------------------"
echo "Install coco-settings-manager"
echo "-------------------------------------------------------------------------"

# Create config directory
if [ -e "$CONFIG_DIR" ] && [ -d "$CONFIG_DIR" ]; then
    print_success "Folder $CONFIG_DIR already exists"
else
    msg=$(mkdir -pv "$CONFIG_DIR" 2>&1)
    show_err_status "$msg"
fi

# Place scripts in bin folder
msg=$(cp -v "${PWD}/scripts/settings-check.sh"  "${BIN_DIR}/coco-settings-check" 2>&1)
show_err_status "$msg"
msg=$(cp -v "${PWD}/scripts/settings-gen.sh"    "${BIN_DIR}/coco-settings-gen" 2>&1)
show_err_status "$msg"

# Installation overview
echo "-------------------------------------------------------------------------"
if [ $ERROR_COUNTER -eq 0 ];then
    echo "coco-settings-manager successfully installed!"
else
    echo "$ERROR_COUNTER errors occured during coco-settings-manager install."
fi
echo "-------------------------------------------------------------------------"

