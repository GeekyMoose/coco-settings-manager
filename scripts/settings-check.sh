#!/bin/sh
#
# Check if packages are missing for my configuration

COUNT_TOTAL=0
COUNT_MISSING=0

# Constants
NORMAL="\033[0m"
RED="\033[31m"
GREEN="\033[32m"


# ------------------------------------------------------------------------------
# ASSET FUNCTIONS
# ------------------------------------------------------------------------------

# Check whether package exists
# Param 1 -> package name to test
check_package(){
    COUNT_TOTAL=$((COUNT_TOTAL + 1))
    which "$1" > '/dev/null' 2>&1
    if [ $? -eq 1 ]
    then
        echo -e "   $RED*[MISSING]$NORMAL $1"
        COUNT_MISSING=$((COUNT_MISSING + 1))
    else
        echo -e "    $GREEN[PRESENT]$NORMAL $1"
    fi
}

# Display one section separator
show_section(){
    echo '-' $1
}


# ------------------------------------------------------------------------------
# START SCRIPT
# ------------------------------------------------------------------------------
clear
echo "-----------------------------------"
echo " Setup checking"
echo "-----------------------------------"


# ------------------------------------------------------------------------------
# CHECK PACKAGES
# ------------------------------------------------------------------------------

# --- WORKSPACE ---
show_section 'Workspace'
check_package 'awesome'
check_package 'xinit'
check_package 'startx'
check_package 'i3'


# --- UTILITIES ---
show_section 'Utilities'
check_package 'urxvt'
check_package 'terminator'
check_package 'ranger'
check_package 'xrandr'
check_package 'xev'
check_package 'xclip'
check_package 'tar'
check_package 'unrar'
check_package 'unzip'
check_package 'ntfs-3g'
check_package 'tar'
check_package 'acpi'
check_package 'top'
check_package 'htop'
check_package 'minicom'
check_package 'screen'
check_package 'rsync'
check_package 'xfce4-screenshooter'


# --- PROGRAMMING ---
show_section 'Programming'
# Editors / Tools
check_package 'vim'
check_package 'nvim'
check_package 'emacs'
check_package 'git'
check_package 'svn'
check_package 'ctags'
check_package 'visual-paradigm'
# Lua
check_package 'lua'
# Python
check_package 'python2'
check_package 'python3'
check_package 'pip'
check_package 'pip2'
# OCaml
check_package 'opam'
check_package 'ocaml'
check_package 'ocamlbuild'
check_package 'ocamldebug'
# Java
check_package 'java'
check_package 'javac'
# C / C++
check_package 'gcc'
check_package 'g++'
check_package 'gdb'
check_package 'cmake'
check_package 'ccmake'
check_package 'clang'


# --- SECURITY ---
show_section 'Security'
check_package 'sflock'
check_package 'gpg'
check_package 'keepassx2'
check_package 'iptables'
check_package 'nslookup'
check_package 'ssh'
check_package 'strings'
check_package 'hexdump'
check_package 'objdump'
check_package 'md5sum'
check_package 'readelf'
check_package 'file'
check_package 'ltrace'
check_package 'strace'
check_package 'ldd'
check_package 'xxd'
check_package 'netstat'
check_package 'ldd'
check_package 'netcat'


# --- INTERNET ---
show_section 'Internet'
check_package 'nmcli'
check_package 'wpa_supplicant'
check_package 'dhcpcd'
check_package 'iw'
check_package 'wifi-menu'
check_package 'lynx'
check_package 'elinks'
check_package 'firefox'
check_package 'chromium'
check_package 'wget'
check_package 'docker'


# --- MULTIMEDIA ---
show_section 'Multimedia'
check_package 'imv'
check_package 'fbi'
check_package 'alsamixer'
check_package 'liferea'
check_package 'vlc'
check_package 'calibre'


# --- DOCUMENTS ---
show_section 'Documents'
check_package 'pdflatex'
check_package 'atril'
check_package 'libreoffice'
check_package 'pcmanfm'


# --- SCIENCE ---
show_section 'Science'


# --- OTHER ---
show_section 'Other'
check_package 'adb'


# ------------------------------------------------------------------------------
# SHOW ME THE RESULT!! :p
# ------------------------------------------------------------------------------
echo "-----------------------------------"
echo " $COUNT_MISSING missing packages ($(($COUNT_TOTAL - $COUNT_MISSING))/$COUNT_TOTAL)"
echo "-----------------------------------"

