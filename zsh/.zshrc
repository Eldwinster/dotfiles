# [[file:zshrc.org::*EXPORT][EXPORT:1]]
export TERM="xterm-256color"                      # getting proper colors
export TERMINFO="/usr/bin/env zsh"
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|doas reboot|history|cd -|cd ..)"
# export EDITOR="emacsclient -t -a ''"              # $EDITOR use Emacs in terminal
# export VISUAL="emacsclient -c -a emacs"           # $VISUAL use Emacs in GUI mode
export VISUAL="vim"
export EDITOR="vim"
export ZSH="$HOME/.oh-my-zsh"

export TZ="Europe/Paris"

# You may need to manually set your language environment
# export LANG=C
export LANG=en_US.utf8
export LC_CTYPE=en_US.utf8
export JORMUNGANDR="192.168.1.75"
export EPSILON="172.29.252.202"

# export DOTBARE_DIR="~/.dotfiles/.git"
# export DOTBARE_TREE="~/.dotfiles"
# EXPORT:1 ends here

# [[file:zshrc.org::*SET MANPAGER][SET MANPAGER:1]]
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

bindkey -v
# if not running interactively, don't do anything
[[ $- != *i* ]] && return
# SET MANPAGER:1 ends here

# [[file:zshrc.org::*ZSH THEME][ZSH THEME:1]]
ZSH_THEME="gallois"
# ZSH THEME:1 ends here

# [[file:zshrc.org::*EXAMPLES][EXAMPLES:1]]
HIST_STAMPS="$(date +'%Y%m%d$H$M$S')"
# EXAMPLES:1 ends here

# [[file:zshrc.org::*EXAMPLES][EXAMPLES:2]]
plugins=(git)
# EXAMPLES:2 ends here

# [[file:zshrc.org::*EXAMPLES][EXAMPLES:3]]
export ARCHFLAGS="-arch x86_64"
# EXAMPLES:3 ends here

# [[file:zshrc.org::*Oh my zsh][Oh my zsh:1]]
source $ZSH/oh-my-zsh.sh
# Oh my zsh:1 ends here

# [[file:zshrc.org::*Pywal][Pywal:1]]
# (cat ~/.cache/wal/sequences &)
# Pywal:1 ends here

# [[file:zshrc.org::*Pywal][Pywal:2]]
source ~/.cache/wal/colors-tty.sh
# Pywal:2 ends here

# [[file:zshrc.org::*EDITOR LOCAL AND REMOTE][EDITOR LOCAL AND REMOTE:1]]
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi
# EDITOR LOCAL AND REMOTE:1 ends here

# [[file:zshrc.org::*Get keyboard input][Get keyboard input:1]]
keyinput ()
{
xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
}
# Get keyboard input:1 ends here

# [[file:zshrc.org::*Get wm_class][Get wm_class:1]]
wmclass () {
xprop | rg -ie "wm_class" | awk '{print $4}'
}
# Get wm_class:1 ends here

# [[file:zshrc.org::*Function extract for common file formats][Function extract for common file formats:1]]
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace)      unace x ./"$n"      ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

IFS=$SAVEIFS
# Function extract for common file formats:1 ends here

# [[file:zshrc.org::*SSH][SSH:2]]
sshtmux()
{
    if [[ ! -z $1 && $2 ]]; then
        ssh -t "$1" "tmux attach -t $2 || tmux new -s $2"
    else
        echo "Usage: sshtmux HOSTNAME SESSION_NAME"
        echo "You must specify a hostname and a session name"
    fi
}
# SSH:2 ends here

# [[file:zshrc.org::*root privileges][root privileges:1]]
alias pacman='sudo pacman'
alias mount='sudo mount'
alias umount='sudo umount'
# root privileges:1 ends here

# [[file:zshrc.org::*hack][hack:1]]
alias listener="rlwrap nc -lnvp"
alias htpd="python -m http.server 7777"
alias nping="nmap -sn -n --disable-arp-ping"
alias logger="script -a $HOME/.sessions/$(date +"%Y-%m-%dT%H:%M:%S")-typescript.out"
# hack:1 ends here

# [[file:zshrc.org::*navigation][navigation:1]]
up () {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
  fi
}
# navigation:1 ends here

# [[file:zshrc.org::*vim and emacs][vim and emacs:1]]
alias vim="vim"
alias v="vim"
alias vi="vim"
# vim and emacs:1 ends here

# [[file:zshrc.org::*Changing "cat" to "bat"][Changing "cat" to "bat":1]]
alias cat='bat --style=plain'
# Changing "cat" to "bat":1 ends here

# [[file:zshrc.org::*Changing "ls" to "exa"][Changing "ls" to "exa":1]]
alias ls='exa --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | rg "^\."'
# Changing "ls" to "exa":1 ends here

# [[file:zshrc.org::*pacman, yay, paru and pikaur][pacman, yay, paru and pikaur:1]]
# alias pacup='yes | pacman -Syu'
alias pacsyu='pacman -Syu'                     # update only standard pkgs
alias pacsyyu='pacman -Syyu'                   # Refresh pkglist & update standard pkgs
alias paclog='vim /var/log/pacman.log'              # look for pacman logs
alias piksua='pikaur -Sua --noconfirm'              # update only AUR pkgs (pikaur)
alias piksyu='pikaur -Syu --noconfirm'              # update standard pkgs and AUR pkgs (pikaur)
alias unlock='rm /var/lib/pacman/db.lck'       # remove pacman lock
alias cleanup='pacman -Rns (pacman -Qtdq)'     # remove orphaned packages
# pacman, yay, paru and pikaur:1 ends here

# [[file:zshrc.org::*get fastest mirrors][get fastest mirrors:1]]
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"
# get fastest mirrors:1 ends here

# [[file:zshrc.org::*Colorize grep output (good for log files)][Colorize grep output (good for log files):1]]
alias grep='rg'
# Colorize grep output (good for log files):1 ends here

# [[file:zshrc.org::*confirm before overwriting something][confirm before overwriting something:1]]
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"
# confirm before overwriting something:1 ends here

# [[file:zshrc.org::*adding flags][adding flags:1]]
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias vifm='./.config/vifm/scripts/vifmrun'
alias ncmpcpp='ncmpcpp ncmpcpp_directory=$HOME/.config/ncmpcpp/'
alias mocp='mocp -M "$XDG_CONFIG_HOME"/moc -O MOCDir="$XDG_CONFIG_HOME"/moc'
# adding flags:1 ends here

# [[file:zshrc.org::*ps][ps:1]]
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'
# ps:1 ends here

# [[file:zshrc.org::*get error messages from journalctl][get error messages from journalctl:1]]
alias jctl="journalctl -p 3 -xb"
# get error messages from journalctl:1 ends here

# [[file:zshrc.org::*gpg encryption][gpg encryption:1]]
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
# gpg encryption:1 ends here

# [[file:zshrc.org::*gpg encryption][gpg encryption:2]]
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
# gpg encryption:2 ends here

# [[file:zshrc.org::*switch between shells][switch between shells:1]]
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
# switch between shells:1 ends here

# [[file:zshrc.org::*reset $PATH][reset $PATH:1]]
alias getpath="PATH=$(/usr/bin/getconf PATH)"
# reset $PATH:1 ends here

# [[file:zshrc.org::*COLORSCRIPT][COLORSCRIPT:1]]
colorscript random
# COLORSCRIPT:1 ends here
