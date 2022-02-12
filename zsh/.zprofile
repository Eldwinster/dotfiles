# if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
#   exec startx
# fi
# keychain manages ssh-agents
# type keychain >&/dev/null \
#     && keychain --agents ssh
eval `keychain --eval --agents ssh github`
