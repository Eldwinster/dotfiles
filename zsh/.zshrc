export ZSH="/home/yann/.oh-my-zsh"

export TERM="xterm-256color"                      # getting proper colors
export TERMINFO="/bin/zsh"
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
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

export MANPAGER="sh -c 'col -bx | bat -l man -p'"

bindkey -v
# if not running interactively, don't do anything
[[ $- != *i* ]] && return

ZSH_THEME="gallois"

HIST_STAMPS="dd/mm/yyyy"

plugins=(git)

export ARCHFLAGS="-arch x86_64"

source $ZSH/oh-my-zsh.sh

(cat ~/.cache/wal/sequences &)

source ~/.cache/wal/colors-tty.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

case ${TERM} in
  xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|alacritty|st|konsole*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
        ;;
  screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
    ;;
esac

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

alias doas="doas --"
alias pacman='doas pacman'
alias mount='doas mount'
alias umount='doas umount'

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

alias vim="vim"
alias em="/usr/bin/emacs -nw"
alias emacs="emacsclient -c -a 'emacs'"
alias doomsync="~/.emacs.d/bin/doom sync"
alias doomdoctor="~/.emacs.d/bin/doom doctor"
alias doomupgrade="~/.emacs.d/bin/doom upgrade"
alias doompurge="~/.emacs.d/bin/doom purge"

alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'

# alias pacup='yes | pacman -Syu'
alias pacsyu='doas pacman -Syu'                     # update only standard pkgs
alias pacsyyu='doas pacman -Syyu'                   # Refresh pkglist & update standard pkgs
alias paclog='vim /var/log/pacman.log'              # look for pacman logs
alias yaysua='yay -Sua --noconfirm'                 # update only AUR pkgs (yay)
alias yaysyu='yay -Syu --noconfirm'                 # update standard pkgs and AUR pkgs (yay)
alias parsua='paru -Sua --noconfirm'                # update only AUR pkgs (paru)
alias parsyu='paru -Syu --noconfirm'                # update standard pkgs and AUR pkgs (paru)
alias piksua='pikaur -Sua --noconfirm'              # update only AUR pkgs (pikaur)
alias piksyu='pikaur -Syu --noconfirm'              # update standard pkgs and AUR pkgs (pikaur)
alias unlock='doas rm /var/lib/pacman/db.lck'       # remove pacman lock
alias cleanup='doas pacman -Rns (pacman -Qtdq)'     # remove orphaned packages

alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias cp="cp -iv"
alias mv='mv -iv'
alias rm='rm -iv'

alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias lynx='lynx -cfg=~/.lynx/lynx.cfg -lss=~/.lynx/lynx.lss -vikeys'
alias vifm='./.config/vifm/scripts/vifmrun'
alias ncmpcpp='ncmpcpp ncmpcpp_directory=$HOME/.config/ncmpcpp/'
alias mocp='mocp -M "$XDG_CONFIG_HOME"/moc -O MOCDir="$XDG_CONFIG_HOME"/moc'

alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

alias jctl="journalctl -p 3 -xb"

alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"

alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-opus="youtube-dl --extract-audio --audio-format opus "
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "
alias ytv-best="youtube-dl -f bestvideo+bestaudio "

alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"

# alias config="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"

alias getpath="PATH=$(/usr/bin/getconf PATH)"

# eval "$(starship init zsh)"

colorscript random
