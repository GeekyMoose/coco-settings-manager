# Settings Manager
Coco settings manager generates your configuration and checks if all your packages are installed.
This is useful to automatically set all your default GNU/Linux settings like terminals, editors, Window Managers etc.
The script print all its execution status so that you know if something went wrong (Bad path, missing file...).
Special configuration files are used to define your settings. (See config files section)

> WARNING: WORK IN PROGRESS </br>
> This project is under work and is subject to changes.
> I also plan to rewrite it in C++.
> I keep these bash scripts anyway.
> Also, I will add some better documentation as soon as possible.


# How I'm using this script
I use it to synchronize my settings across several computers.
I personally place all my settings on a git folder accessible from anywhere.
Just clone it on the new computer. (Usually, I place it in my data partition and create symlink on my home)
Then, I start this script with the configuration file I need. (The gen.conf file).
Note that, this gen.conf file itself is in my configuration folder.
</br>
The first time, I run `./settings-gen.sh -c /path/to/config/myGenConfig.gen.conf`.
(After that, I usually install this manager for next uses)


# Install
> Installation is not required.
> You can still start the scripts with `-c` option and a config file.
> </br>
> Example: `./settings-gen.sh -c /path/to/config/myGenConfig.gen.conf`

- Run `install.sh`
- This creates the config directory `~/.config/coco-settings-manager`
- This also places the scripts in your bin:
    - `settings-check.sh` copied in `~/.local/bin/coco-settings-check`
    - `settings-gen.sh` copied in `~/.local/bin/coco-settings-gen`

> Don't forget to add `~/.local/bin` to your path in not already.
> </br>
> Note the 'coco' prefix so that you can enter coco and use tab for completion.


# Scripts
- `settings-gen.sh`
    </br>
    Generate the configuration listed in gen files (.gen.conf).
    </br>
    Without options, executes all valid gen files placed in `~/.config/coco-settings-manager`.
    > Use -h option to display help

- `settings-check.sh`
    </br>
    Check installation status of packages listed in configuration files (.check.conf).
    </br>
    Without options, executes all valid check files placed in `~/.config/coco-settings-manager`.
    > Use -h option to display help


# Configuration files

## Setting-gen configuration file
> Used by `settings-gen.sh` script.

### Syntax
- `# This is a comment`     -> A comment
- `crea_ln src dest`        -> create a symlink from src to dest.
- `crea_rep dest`           -> Create the 'dest' repertory (Can be ~/a/b/c).
- `crea_rep_ln src dest`    -> Create a symlink of each file inside src and place 
                                in dest folder.
- `crea_sh_ln src dest`     -> Like crea_rep_ln but add a prefix before link.
                                I use this for scripts, so that I enter zozo 
                                and just tabulation to have completion.
                                (I'll had possibility to set your how prefix).
- `print_title title`       -> Simply print the title during execution.
- `print_warning msg`       -> Print a warning (I use this for manual action to
                                do after the execution).
- `exec_cmd command`        -> Arbitrary execute the given command. (See example)

> If you find something ambiguous, check the script source code. Might help.

### Example (Gen config file)
> File `myGenConfig.gen.conf`

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

# Arbitrary command (Execute xrdb with parameter ~.Xresources)
execute xrdb "~/.Xresources"

# Other
show_title "Other"
show_warning "Install fonts from 'https://github.com/powerline/fonts'"
show_warning "~/.local/bin must be added in the path"
```


## Setting-check configuration file
> Used by `settings-check.sh` script.

### Syntax
- `# Title` -> Simply print the title.
- `pkgX`    -> Check whether pkgX is installed and print result.

> There is no way to comment yet, but I will probably set # as a comment
> and add a command to print title.

### Example (check config file)
> File `myCheckConfig.check.conf`

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


# Author
- Constantin Masson ([Geekymoose](https://github.com/GeekyMoose) / [constantinmasson.com](http://constantinmasson.com))

