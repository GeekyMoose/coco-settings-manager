#!/bin/sh
#
# DESCRIPTION
# Generate all symlinks for settings
#
# SETTINGS LOCATION
# Find settings in SRC folder
# Currently, SRC is located using hostname and is an adhock temporary solution
#

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


# ------------------------------------------------------------------------------
# Assets Functions
# ------------------------------------------------------------------------------

# Create a symlink.
# \param 1 Source file (Absolute path).
# \param 2 Symlink file (Absolute path).
crea_ln(){
    # File to link must exists
    if ! [ -e "$1" ]; then
        ERRORS_COUNTER=$((ERRORS_COUNTER + 1))
        print_error "'$1' doesn't exists..."
        return -1
    fi
    # Only link to file allowed (Not folder)
    if ! [ -f "$1" ];then
        ERRORS_COUNTER=$((ERRORS_COUNTER + 1))
        print_error "'$1' is not a file type (Only files allowed for symlinks)"
        return -1
    fi
    msg=$(ln -vfs "$1" "$2" 2> '/dev/null') # Warn: Err is not catched by msg..
    print_exit_msg "$msg"
    return 0
}

# Create a repertory if doesn't exists.
# \params 1 Folder to create (Full path).
crea_rep(){
    if [ -e "$1" ] && [ ! -d "$1" ]; then
        ERRORS_COUNTER=$((ERRORS_COUNTER + 1))
        print_error "'$1' is already exists and is a file"
        return 1
    fi
    if [ -e "$1" ] && [ -d "$1" ]; then
        print_info "folder '$1' is already exists"
        return 1
    fi
    msg=$(mkdir -pv "$1")
    print_exit_msg "$msg"
}

# Browser scripts folder and create the link with specific renaming rule.
# \param 1 Source folder.
# \param 2 Destination folder.
crea_script_links(){
    # Script folder must exists
    if ! [ -e "$1" ]; then
        ERRORS_COUNTER=$((ERRORS_COUNTER + 1))
        print_error "'$1' doesn't exists..."
        return -1
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
# \param 1 Source folder
# \param 2 Destination folder
crea_rep_ln(){
    # Folder must exists
    if ! [ -e "$1" ]; then
        ERRORS_COUNTER=$((ERRORS_COUNTER + 1))
        print_error "'$1' doesn't exists..."
        return -1
    fi
    file=$(ls "$1")
    for f in $file; do
        if [ -f "$1/$f" ]; then
            crea_ln "$1/$f" "$2/$f"
        fi
    done
}


# ------------------------------------------------------------------------------
# Print Functions
# ------------------------------------------------------------------------------

print_title(){
    echo -e "*** $1 ***"
}
print_error(){
    echo -e "   ${COLOR_RED}*[ERROR]$COLOR_NORMAL $1"
}
print_warning(){
    echo -e "    ${COLOR_YELLOW}[Warning]$COLOR_YELLOW $1"
}
print_success(){
    echo -e "    ${COLOR_GREEN}[SUCCESS]$COLOR_NORMAL $1"
}
print_info(){
    echo -e "    ${COLOR_GRAY}[INFO]$COLOR_NORMAL $1"
}

# Print a message according to given error code
# Will display in red if error, or in green if ok
# \param 1 Message to display
print_exit_msg(){
    if [ $? -ne 0 ]; then
        ERRORS_COUNTER=$((ERRORS_COUNTER + 1))
        print_error "$1"
    else
        print_success "$1"
    fi
}


# ------------------------------------------------------------------------------
# Welcome prompt
# ------------------------------------------------------------------------------
# Welcome text
clear
echo "-------------------------------------------------------------------------"
echo "Settings configuration"
echo "-------------------------------------------------------------------------"

# Detect PC used
# If found, use predefined path values
SRC_DISK='/mnt/diskdata' #Default
echo -n " * Detect config for hostname... "
name=$(hostname)
echo -n "$name. "
if [ $name = 'nellie' ];then
    SRC_DISK='/mnt/diskdata'
    echo "config found!"
elif [ $name = 'kiki' ];then
    SRC_DISK='/mnt/diskdata'
    echo "config found!"
elif [ $name = 'lanikai' ];then
    SRC_DISK="/part/01/Tmp"
    echo "config found"
else
    echo "No config for $name, use default $SRC_DISK."
fi

# Settings
SRC="$SRC_DISK/version/settings/settings-common"
TARGET_CONFIG="$HOME/.config"

# Check sources are valid folders
if [ ! -e $SRC_DISK ];then
    echo "[ERROR]: source $SRC_DISK doesn't exist..."
    exit -1
elif [ ! -e $SRC ];then
    echo "[ERROR]: source $SRC doesn't exist..."
    exit -1
fi

# Show selected configuration
echo "Sources from: '$SRC'"
echo "Config target: $TARGET_CONFIG"


# ------------------------------------------------------------------------------
# Gen config
# ------------------------------------------------------------------------------

# Terminator
print_title "Terminals (Terminator, urxvt)"
crea_rep                                            "$TARGET_CONFIG/terminator"
crea_rep                                            "$TARGET_CONFIG/urxvt"
crea_ln "$SRC/terminal/terminator/config"           "$TARGET_CONFIG/terminator/config"
crea_ln "$SRC/terminal/urxvt/config"                "$TARGET_CONFIG/urxvt/config"

# Awesome WM
print_title "Awesome window manager"
crea_rep                                            "$TARGET_CONFIG/awesome"
crea_ln "$SRC/awesome/rc.lua"                       "$TARGET_CONFIG/awesome/rc.lua"
crea_ln "$SRC/awesome/perso-theme.lua"              "$TARGET_CONFIG/awesome/perso-theme.lua"
crea_ln "$TARGET_CONFIG/awesome/perso-theme.lua"    "$TARGET_CONFIG/awesome/current-theme.lua"

# Shell
print_title "Shell components"
crea_rep                                            "$TARGET_CONFIG/terminal/components"
crea_ln "$SRC/terminal/components/text-caribou.txt" "$TARGET_CONFIG/terminal/components/text-caribou.txt"
crea_ln "$SRC/terminal/bash/bash_profile.sh"        "$HOME/.bash_profile"
crea_ln "$SRC/terminal/bash/bashrc.sh"              "$HOME/.bashrc"
crea_ln "$SRC/terminal/zsh/zprofile.sh"             "$HOME/.zprofile"
crea_ln "$SRC/terminal/zsh/zshrc.sh"                "$HOME/.zshrc"
crea_ln "$SRC/terminal/xinit/xinitrc.sh"            "$HOME/.xinitrc"
crea_ln "$SRC/terminal/xinit/xserverrc.sh"          "$HOME/.xserverrc"
crea_ln "$SRC/terminal/xinit/xresources"            "$HOME/.Xresources"
crea_rep_ln "$SRC/terminal/components"              "$TARGET_CONFIG/terminal/components"

# Vim / NeoVim
print_title "Vim / NeoVim"
crea_rep                                            "$TARGET_CONFIG/nvim/autoload"
crea_rep                                            "$TARGET_CONFIG/nvim/components"
crea_rep                                            "$HOME/.vim/autoload"
crea_rep                                            "$HOME/.vim/components"
crea_rep_ln "$SRC/vim/vimrc/components"             "$TARGET_CONFIG/nvim/components"
crea_rep_ln "$SRC/vim/vimrc/components"             "$HOME/.vim/components"
crea_ln "$SRC/vim/autoload/plug.vim"                "$HOME/.vim/autoload/plug.vim"
crea_ln "$SRC/vim/vimrc/perso.vim"                  "$HOME/.vimrc"
crea_ln "$SRC/vim/vimrc/perso.vim"                  "$HOME/.config/nvim/init.vim"
crea_ln "$SRC/vim/autoload/plug.vim"                "$HOME/.config/nvim/autoload/plug.vim"

# Emacs
print_title "Emacs"
crea_rep                                            "$HOME/.emacs.d"
crea_ln "$SRC/emacs/init.el"                        "$HOME/.emacs.d/init.el"
crea_ln "$SRC/emacs/gnus.el"                        "$HOME/.gnus.el"
crea_ln "$SRC/emacs/authinfo.gpg"                   "$HOME/.authinfo.gpg"
crea_ln "$SRC/emacs/bbdb"                           "$HOME/.emacs.d/bbdb"
crea_ln "$SRC/emacs/bbdb-conf.el"                   "$HOME/.emacs.d/bbdb-conf.el"
crea_ln "$SRC/emacs/rcirc.el"                       "$HOME/.emacs.d/rcirc.el"
echo -e "    $COLOR_YELLOW[Warning] bbdb must be installed manually (From emacs)$COLOR_NORMAL"

# Git
print_title "Versioning"
crea_ln "$SRC/git/gitconfig.txt"                    "$HOME/.gitconfig"

# Python / Pip
print_title "Python / Pip"
crea_rep                                            "$TARGET_CONFIG/pip"
crea_ln "$SRC/pip/pip.conf"                         "$TARGET_CONFIG/pip/pip.conf"

# Scripts
print_title "Scripts"
crea_rep                                            "$HOME/.local/bin"
crea_script_links "$SRC/scripts"                    "$HOME/.local/bin"

# RSS
print_title "Rss"
crea_rep                                            "$TARGET_CONFIG/liferea"
echo -e "    $COLOR_YELLOW[Warning] Currently not working$COLOR_NORMAL"
#crea_ln "$SRC/rss/feedlist.opml"                    "$TARGET_CONFIG/liferea/feedlist.opml"

# Fonts
print_title "Fonts"
echo -e "    $COLOR_YELLOW[Warning] Use 'https://github.com/powerline/fonts' instead$COLOR_NORMAL"

# Other
print_title "Other"
echo -e "    $COLOR_YELLOW[Warning] Manually add sflock$COLOR_NORMAL"



# ------------------------------------------------------------------------------
# End script
# ------------------------------------------------------------------------------

# Reload things that need to be updated
xrdb "$HOME/.Xresources" # Manual Reload needed

echo "-----------------------------------"
if [ $ERRORS_COUNTER -ne 0 ]; then
    echo -e " $ERRORS_COUNTER Errors"
else
    echo -e " Finished successfully"
fi
echo "-----------------------------------"
