#!/usr/bin/env bash

# vertical split, 20% height
tmux split-window -v -l 10
# horizontal split, 50% width
tmux split-window -h
# switch back to the top pane
tmux select-pane -U

# execute the desired command in the original pane
exec "$@"
