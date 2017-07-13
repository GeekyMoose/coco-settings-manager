# Settings Manager
Coco settings manager generates your configuration and check if all your packages are installed.
This is useful to automatically set all your default GNU/Linux settings like terminals, editors, Window Managers etc
The script execution shows all its state so that you know if something went wrong.

> WARNING: WORK IN PROGRESS </br>
> This project is under work and is subject to changes.
> I also plan to rewrite this project in C++, however I will keep the last version of these bash scripts anyway.
> I will also add some better documentation as soon as possible.


# How I'm using this script
I use it to synchronize my settings across several computers.
I personally place all my settings on a git folder accessible from anywhere.
Just clone it on the new computer. (Usually, I place it in my data partition and create symlink on my home)
Then, I start this script with the right configuration. (The gen.conf file)
Note that, the gen.conf file itself is in my configuration folder.
The first time, I run `./settings-gen.sh -c /path/to/config/myGenConfig.gen.conf`.


# Install
You can run the `install.sh` script.
This is useful if you need to re-gen the configuration later.
It creates the require `~/.config/coco-settings-manager` directory.
It also place the scripts `settings-check.sh` and `settings-gen.sh` in `~/.local/bin`.
Don't forget to add `~/.local/bin` to your path.
(Currently, I doing a symlink so that you can git pull this folder to automatically update the scripts, but that implies if you move this project folder, links are broken).


# Scripts
- `settings-check.sh`
Check installation status of packages listed in configuration files (.check.conf).
> Use -h option to display help

- `settings-gen.sh`
Generate the configuration listed in gen files (.gen.conf).
> Use -h option to display help


# Example of configuration file

## Settings.gen.conf files
```
# Terminal (Terminator)
show_title "Terminals (Terminator, urxvt)"
crea_rep                                                            "~/.config/terminator"
crea_ln "~/settings-common/terminator/config"                       "~/.config/terminator/config"

# Terminal (urxvt)
crea_rep                                                            "~/.config/urxvt"
crea_ln "~/settings-common/urxvt/config"                            "~/.config/urxvt/config"

# Vim / NeoVim
show_title "NeoVim"
crea_rep                                                            "~/.config/nvim/autoload"
crea_rep                                                            "~/.config/nvim/components"
crea_rep_ln "~/settings-common/neovim/components"                   "~/.config/nvim/components"
crea_ln     "~/settings-common/neovim/autoload/plug.vim"            "~/.config/nvim/autoload/plug.vim"
crea_ln     "~/settings-common/neovim/init.vim"                     "~/.config/nvim/init.vim"

# Scripts
show_title "Scripts"
crea_rep                                                            "~/.local/bin"
crea_sh_ln "~/settings-common/scripts"                             "~/.local/bin"

# Arbitrary command
execute xrdb "~/.Xresources"

# Other
show_title "Other"
show_warning "Install fonts from 'https://github.com/powerline/fonts'"
show_warning "~/.local/bin must be added in the path"
```

## Settings.check.conf files
```
# WORKSPACE
awesome
i3

# UTILITIES
urxvt
terminator

# PROGRAMMING
gcc
g++
gdb
cmake
java
javac
ocaml
lua
vim
nvim
emacs

# SECURITY
nslookup
strace
hexdump
objdump
radare2
netstat
netcat
keepassx2

# INTERNET
firefox
wget

# MULTIMEDIA
liferea
calibre

# DOCUMENTS
pdflatex
atril
```

# Wait! Who is Coco???
Coco is a Rabbit! He's nice and likes carrot (Because he's not a stereotype).
I will probably do a draw of him to show you his face, though I'll have to go back on my (poor) illustrator skills.
