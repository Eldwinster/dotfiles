# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/yann/.oh-my-zsh"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.go/bin:$PATH"
export PATH="$HOME/.scripts/uni:$PATH"

export TZ="Europe/Paris"
# export LANG=C
export LANG=en_US.utf8
export LC_CTYPE=en_US.utf8

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="gallois"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git dotbare)

source $ZSH/oh-my-zsh.sh

# keychain keeps track of ssh-agents
# [ -f $HOME/.keychain/$HOSTNAME-sh ] \
#     && . $HOME/.keychain/$HOSTNAME-sh

### pywal applying the theme to the new terminals
# Import colorscheme from 'wal' asynchronously
# & # Run the process in the background.
# () # Hide shell job control messages.
(cat ~/.cache/wal/sequences &)
# To add support for TTs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"
 export MANPAGER="/bin/sh -c \"col -b | vim --not-a-term -c 'set ft=man ts=8 nomod nolist noma' -\""
 export TERMINFO="/bin/zsh"
 export VISUAL="vim"
 export EDITOR="vim"
 export SETH="192.168.1.75"
 export DOTBARE_DIR="$HOME/.dotfiles/.git"
 export DOTBARE_TREE="$HOME/.dotfiles"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases

### config alias
 alias vz="vim ~/.zshrc"
 alias ohmyzsh="vim ~/.oh-my-zsh"
 alias vv='vim ~/.vimrc'
 # alias vim='vim'
 alias v='vim'
 alias e='emacs'

### alias shortcut
 alias awm='awman'

### ssh

### doas
 alias pacman='doas pacman'
 alias mount='doas mount'
 alias umount='doas umount'
 alias sz='source ~/.zshrc'
 alias pacup='yes | pacman -Syu'
 alias pikup='pikaur -Syua'

 alias paclog='vim /var/log/pacman.log'
 alias vifm='./.config/vifm/scripts/vifmrun'

### pacman
alias pacorphan='pacman -Rns $(pacman -Qtdq)'

### taskbook
 alias tb='taskbook'
 alias tbcreate='tb --task'
 alias tbnote='tb --note'
 alias tbcheck='tb --check'
 alias tbbegin='tb --begin'
 alias tbstar='tb --star'
 alias tbcopy='tb --copy'
 alias tbtime='tb --timeline'
 alias tbpriority='tb --priority'
 alias tbmove='tb --move'
 alias tbdelete='tb --delete'
 alias tbclear='tb --clear'
 alias tbarchive='tb --archive'
 alias tbrestore='tb --restore'
 alias tblist='tb --list'
 alias tbfind='tb --find'

 alias ctb='clear && tb'
 alias cctime='clear && tbtime'
 alias ccarchive='clear && tbarchive'

### git bare alias
# alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

### Function

# start an ssh and if no tmux session exist create a session called ssh_tmux if a session already exist exist it attach it
 sshtmux()
 {
    # A name for the session
    local session_name="$(whoami)_sess"

    if [ ! -z $1 ]; then
        ssh -t "$1" "tmux attach -t $session_name || tmux new -s $session_name"
    else
        echo "Usage: sshtmux HOSTNAME"
        echo "You must specify a hostname"
    fi
} 

# ex - archive extractor
# usage: ex <file>
 ex()
 {
   if [ -f $1 ] ; then
     case $1 in
       *.tar.bz2)   tar xjf $1   ;;
       *.tar.gz)    tar xzf $1   ;;
       *.bz2)       bunzip2 $1   ;;
       *.rar)       unrar x $1   ;;
       *.gz)        gunzip $1    ;;
       *.tar)       tar xf $1    ;;
       *.tbz2)      tar xjf $1   ;;
       *.tgz)       tar xzf $1   ;;
       *.zip)       unzip $1     ;;
       *.Z)         uncompress $1;;
       *.7z)        7z x $1      ;;
       *)           echo "'$1' cannot be extracted via ex()" ;;
     esac
   else
     echo "'$1' is not a valid file"
   fi
}

sshtmux()
{
    if [[ ! -z $1 && $2 ]]; then
        ssh -t "$1" "tmux attach -t $2 || tmux new -s $2"
    else
        echo "Usage: sshtmux HOSTNAME SESSION_NAME"
        echo "You must specify a hostname and a session name"
    fi
}

tmuxattach()
{
    if [ ! -z $1 ]; then
        tmux attach-session -t $1 || tmux new-session -s $1
    else
        echo "Usage: tmuxattach SESSION_NAME"
        echo "You must specify a session name"
    fi
}
