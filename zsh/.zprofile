# [[file:zprofile.org::*auto startx][auto startx:1]]
# if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
#   exec startx
# fi
# auto startx:1 ends here

# [[file:zprofile.org::*keychain][keychain:1]]
# keychain manages ssh-agents
# type keychain >&/dev/null \
#     && keychain --agents ssh

eval `keychain --eval --agents ssh github`
# keychain:1 ends here

# [[file:zprofile.org::*PATH][PATH:1]]
GEM_PATH=/home/yann/.local/share/gem/ruby/3.0.0:/usr/lib/ruby/gems/3.0.0
export PATH="$PATH:/usr/local/bin:/usr/local/sbin:$HOME/.bin:$HOME/.emacs.d/bin:$HOME/.local/bin:$HOME/.go/bin:$HOME/tools:$GEM_PATH"
# PATH:1 ends here
