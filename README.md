# Coco Settings Manager

> Disclaimer: don't use this. I did this during my studies to sync my dotfiles. Turns out there are better ways to do this, such as using stow or git tricks (see link).

- <https://news.ycombinator.com/item?id=11070797>
- <https://www.atlassian.com/git/tutorials/dotfiles>
- <https://www.reddit.com/r/linux/comments/afund1/manage_your_dotfiles_with_style_gnu_stow/>
- <https://www.gnu.org/software/stow/>

## Description

Coco settings manager generates symlinks according to your configuration.
The script prints its execution status so that you know if something went wrong (e.g., wrong path, missing file, missing file).

## How I use this script

I use this script it to synchronize my settings across several computers.
I place all my settings in a git folder accessible from anywhere.
Just clone it on the new computer, then, I start this script with the configuration file I need (the `gen.conf` file).
Note that, this `gen.conf` file itself is in my configuration folder.

The first time, I run `./settings-gen.sh -c /path/to/config/myGenConfig.gen.conf`
(then, I install this manager for next uses)

## Usage

> Installation is not required.
> You can still start the scripts with `-c` option and a config file.

```bash
# Getting started without installation
`./settings-gen.sh -c /path/to/config/myGenConfig.gen.conf`
```

- Run `install.sh`
- This creates the config directory `~/.config/coco-settings-manager`
- This also places the scripts in your `bin` directory
  - `settings-check.sh` copied in `~/.local/bin/coco-settings-check`
  - `settings-gen.sh` copied in `~/.local/bin/coco-settings-gen`
- Note the 'coco' prefix added for easy tab completion.
- Don't forget to have `~/.local/bin` in your path.

## Scripts

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

## Configuration files

### File setting-gen

> Used by `settings-gen.sh` script.

#### Syntax

- `# This is a comment`
- `crea_ln src dest`        -> create a symlink from src to dest.
- `crea_rep dest`           -> Create the 'dest' repertory (can be `~/a/b/c`).
- `crea_rep_ln src dest`    -> Create a symlink of each file inside src and place in dest folder.
- `crea_sh_ln src dest`     -> Like crea_rep_ln but add a prefix before the link. (I use this for scripts for easy tab auto completion).
- `print_title title`       -> Print the title during execution.
- `print_warning msg`       -> Print a warning (I use this for manual action to do after the execution).
- `exec_cmd command`        -> Arbitrary execute the given command. (See example)

#### Example (Gen config file)

> File `myGenConfig.gen.conf`

```bash
# Terminal (terminator)
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

# Arbitrary command (execute xrdb with parameter ~.Xresources)
execute xrdb "~/.Xresources"

# Other
show_title "Other"
show_warning "Install fonts from 'https://github.com/powerline/fonts'"
show_warning "~/.local/bin must be added in the path"
```

### File setting-check

> Used by `settings-check.sh` script.

#### Check Syntax

- `# Title` -> Print the title.
- `pkgX`    -> Check whether pkgX is installed and print result.

> There is no way to comment.

#### Example (check config file)

> File `myCheckConfig.check.conf`

```bash
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

## Wait! Who is Coco

Coco is a Rabbit! He's nice and likes carrot (because he's not a stereotype).
