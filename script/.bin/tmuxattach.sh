#!/bin/sh
tmuxattach()
{
    if [ ! -z $1 ]; then
        tmux attach-session -t $1 || tmux new-session -s $1
    else
        echo "Usage: tmuxattach SESSION_NAME"
        echo "You must specify a session name"
    fi
}

(cat ~/.cache/wal/sequences &)
tmuxattach task
