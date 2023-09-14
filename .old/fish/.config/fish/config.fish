cat ~/.cache/wal/sequences

### ADDING TO THE PATH
# First line removes the path; second line sets it.  Without the first line,
# your path gets massive and fish becomes very slow.

set GEM_PATH '/home/yann/.local/share/gem/ruby/3.0.0:/usr/lib/ruby/gems/3.0.0'
set -e fish_user_paths
set -U fish_user_paths $HOME/.bin $HOME/.emacs.d/bin $HOME/.local/bin $HOME/.go/bin $GEM_PATH $fish_user_paths

### EXPORT ###
set fish_greeting                                 # Supresses fish's intro message
set TERM "xterm-256color"                         # Sets the terminal type
set EDITOR "emacsclient -t -a ''"                 # $EDITOR use Emacs in terminal
set VISUAL "emacsclient -c -a emacs"              # $VISUAL use Emacs in GUI mode
set HISTORY_IGNORE "(ls|cd|pwd|exit|sudo reboot|doas reboot|history|cd -|cd ..)"

### "bat" as manpager
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

if status is-interactive
    # Commands to run in interactive sessions can go here
end
# starship init fish | source


### SET EITHER DEFAULT EMACS MODE OR VI MODE ###
function fish_user_key_bindings
  # fish_default_key_bindings
  fish_vi_key_bindings
end
### END OF VI MODE ###

# Functions needed for !! and !$
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end
# The bindings for !! and !$
if [ "$fish_key_bindings" = "fish_vi_key_bindings" ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Function for creating a backup file
# ex: backup file.txt
# result: copies file as file.txt.bak
function backup --argument filename
    cp $filename $(date +"%Y%m%d%H%M%S")-$filename.bak
end

# Function for copying files and directories, even recursively.
# ex: copy DIRNAME LOCATIONS
# result: copies the directory and all of its contents.
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
	set from (echo $argv[1] | trim-right /)
	set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

alias grep='rg'

alias em="emacsclient -c -a 'emacs'"
alias doomsync="~/.emacs.d/bin/doom sync"
alias doomdoctor="~/.emacs.d/bin/doom doctor"
alias doomupgrade="~/.emacs.d/bin/doom upgrade"
alias doompurge="~/.emacs.d/bin/doom purge"

alias l='exa -al --color=always'
alias ls='exa --color=always'
alias la='exa -a --color=always'
alias ll='exa -l --color=always'
alias lt='exa -aT --color=always'
alias l.='exa -a | grep "^\."'

# confirm before overwriting something
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'


# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

### RANDOM COLOR SCRIPT ###
# Get this script from my GitLab: gitlab.com/dwt1/shell-color-scripts
# Or install it from the Arch User Repository: shell-color-scripts
colorscript random

### SETTING THE STARSHIP PROMPT ###
starship init fish | source
