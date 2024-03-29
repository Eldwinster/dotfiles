# [[file:zshrc.org::*EXPORT][EXPORT:1]]
export PATH="$PATH:$HOME/tools"
export TERM="xterm-256color"                      # getting proper colors
export TERMINFO="/usr/bin/env zsh"
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|doas reboot|history|cd -|cd ..)"
export EDITOR="emacsclient -nw"              # $EDITOR use Emacs in terminal
export VISUAL="emacsclient -c -a emacs"           # $VISUAL use Emacs in GUI mode
# export VISUAL="/usr/bin/vim"
# export EDITOR="/usr/bin/vim"
export ZSH="$HOME/.oh-my-zsh"

export TZ="Europe/Paris"
# EXPORT:1 ends here

# [[file:zshrc.org::*Umatrix][Umatrix:1]]
export LANG=en_US.utf8
export LC_CTYPE=en_US.utf8
# Umatrix:1 ends here

# [[file:zshrc.org::*Dotbare variable][Dotbare variable:1]]
# export DOTBARE_DIR="~/.dotfiles/.git"
# export DOTBARE_TREE="~/.dotfiles"
# Dotbare variable:1 ends here

# [[file:zshrc.org::*HISTORY TIMESTAMPS][HISTORY TIMESTAMPS:1]]
HIST_STAMPS="Executed the $(date +'%Y/%m/%d at %H:%mm%Ss')"
# HISTORY TIMESTAMPS:1 ends here

# [[file:zshrc.org::*SET MANPAGER][SET MANPAGER:1]]
# broken
# export MANPAGER="sh -c 'col -b | bat -l man -p'"
# default
export MANPAGER="less"
# SET MANPAGER:1 ends here

# [[file:zshrc.org::*SET MANPAGER][SET MANPAGER:2]]
bindkey -v
# # if not running interactively, don't do anything
[[ $- != *i* ]] && return

autoload -U run-help
# SET MANPAGER:2 ends here

# [[file:zshrc.org::*ZSH THEME][ZSH THEME:1]]
ZSH_THEME="gallois"
# ZSH THEME:1 ends here

# [[file:zshrc.org::*COMPLETION][COMPLETION:1]]
CASE_SENSITIVE="false"
# COMPLETION:1 ends here

# [[file:zshrc.org::*COMPLETION][COMPLETION:2]]
HYPHEN_INSENSITIVE="false"
# COMPLETION:2 ends here

# [[file:zshrc.org::*COMPLETION][COMPLETION:3]]
COMPLETION_WAITING_DOTS="true"
# COMPLETION:3 ends here

# [[file:zshrc.org::*UPDATE][UPDATE:1]]
DISABLE_AUTO_UPDATE="false"
# UPDATE:1 ends here

# [[file:zshrc.org::*UPDATE][UPDATE:2]]
DISABLE_UPDATE_PROMPT="true"
# UPDATE:2 ends here

# [[file:zshrc.org::*UPDATE][UPDATE:3]]
export UPDATE_ZSH_DAYS=15
# UPDATE:3 ends here

# [[file:zshrc.org::*Oh my zsh][Oh my zsh:1]]
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins
source $ZSH/oh-my-zsh.sh
# Oh my zsh:1 ends here

# [[file:zshrc.org::*Obsolete][Obsolete:1]]
# source ~/.cache/wal/colors-tty.sh
# Obsolete:1 ends here

# [[file:zshrc.org::*SSH-AGENT][SSH-AGENT:1]]
[ -f $HOME/.keychain/$HOSTNAME-sh ] \
    && . $HOME/.keychain/$HOSTNAME-sh
# SSH-AGENT:1 ends here

# [[file:zshrc.org::*EDITOR LOCAL AND REMOTE][EDITOR LOCAL AND REMOTE:1]]
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi
# EDITOR LOCAL AND REMOTE:1 ends here

# [[file:zshrc.org::*Get keyboard input][Get keyboard input:1]]
describe-key ()
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

# [[file:zshrc.org::*Convert][Convert:1]]
png2ico () {
    local i="${1}" o="${2:-${1:r}.ico}" s="${png2ico_size:-256}"
    convert -resize x${s} -gravity center -crop ${s}x${s}+0+0 "$i" -flatten -colors 256 -background transparent "$o"
}
# Convert:1 ends here

# [[file:zshrc.org::*root privileges][root privileges:1]]
alias pacman='sudo pacman'
alias mount='sudo mount'
alias umount='sudo umount'
# root privileges:1 ends here

# [[file:zshrc.org::*source file][source file:1]]
alias sz="source ~/.zshrc"
alias sv="source ~/.vimrc"
# source file:1 ends here

# [[file:zshrc.org::*dotfiles gitbare][dotfiles gitbare:1]]
alias dotfiles="git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME/.dotfiles"
# dotfiles gitbare:1 ends here

# [[file:zshrc.org::*hack][hack:1]]
alias listener="rlwrap nc -lnvp"
alias htpd="python -m http.server 7777"
alias nping="nmap -sn -n --disable-arp-ping"
# I need to investigate this or maybe write a plugin for zellij
# alias logger="script -a $HOME/.sessions/$(date +"%Y-%m-%dT%H:%M:%S")-typescript.out"
alias zz="zellij"
# hack:1 ends here

# [[file:zshrc.org::*vim and emacs][vim and emacs:1]]
alias v="vim"
alias vi="vim"
alias m='ee --eval "(progn (magit-status) (delete-other-windows))"'
alias mt="m -t"
alias et="ee -t"
alias e="emacsclient -nw"
alias em="emacsclient -nw"
# vim and emacs:1 ends here

# [[file:zshrc.org::*Changing "cat" to "bat"][Changing "cat" to "bat":1]]
alias cat='bat'
# Changing "cat" to "bat":1 ends here

# [[file:zshrc.org::*Changing "ls" to "exa"][Changing "ls" to "exa":1]]
alias ls='eza' # my preferred listing
alias la='eza -a --color=always --group-directories-first'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first'  # long format
alias lt='eza -aT --color=always --group-directories-first' # tree listing
alias l.='eza -a | rg "^\."'
# Changing "ls" to "exa":1 ends here

# [[file:zshrc.org::*pacman, pikaur][pacman, pikaur:1]]
# alias pacup='yes | pacman -Syu'
alias pacsyu='pacman -Syu'                     # update only standard pkgs
alias pacsyyu='pacman -Syyu'                   # Refresh pkglist & update standard pkgs
alias paclog='vim /var/log/pacman.log'              # look for pacman logs
alias piksua='pikaur -Sua --noconfirm'              # update only AUR pkgs (pikaur)
alias piksyu='pikaur -Syu --noconfirm'              # update standard pkgs and AUR pkgs (pikaur)
alias unlock='rm /var/lib/pacman/db.lck'       # remove pacman lock
alias cleanup='pacman -Rns $(pacman -Qtdq)'     # remove orphaned packages
# pacman, pikaur:1 ends here

# [[file:zshrc.org::*get fastest mirrors][get fastest mirrors:1]]
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"
# get fastest mirrors:1 ends here

# [[file:zshrc.org::*Changing grep for ripgrep][Changing grep for ripgrep:1]]
# alias grep='rg'
# Changing grep for ripgrep:1 ends here

# [[file:zshrc.org::*adding flags][adding flags:1]]
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
# alias vifm='./.config/vifm/scripts/vifmrun'
# adding flags:1 ends here

# [[file:zshrc.org::*adding flags][adding flags:2]]
alias ncmpcpp='ncmpcpp ncmpcpp_directory=$HOME/.config/ncmpcpp/'
alias mocp='mocp -M "$XDG_CONFIG_HOME"/moc -O MOCDir="$XDG_CONFIG_HOME"/moc'
# adding flags:2 ends here

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
# colorscript random
# COLORSCRIPT:1 ends here

# [[file:zshrc.org::*zellij (multiplexer)][zellij (multiplexer):1]]
# export ZELLIJ_AUTO_ATTACH=true
# export ZELLIJ_AUTO_EXIT=true
# eval "$(zellij setup --generate-auto-start zsh)"
# eval "$(zellij.sh)"
# zellij (multiplexer):1 ends here
