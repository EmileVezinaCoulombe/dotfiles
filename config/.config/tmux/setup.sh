#!/usr/bin/env bash
# TODO: in tmux.conf: run-shell ~/.config/tmux/setup.sh

# Function to check if session exists
session_exists() {
    tmux has-session -t "$1" 2>/dev/null
}

# Function to create a session if it doesn't exist
create_session_if_needed() {
    local session_name="$1"
    local window_name="$2"

    if ! session_exists "$session_name"; then
        # Create session with first window
        tmux new-session -d -s "$session_name" -n "$window_name"
        return 0
    fi
    return 1
}

# Development session setup
if ! create_session_if_needed "dev" "editor"; then
    # Main editor window
    tmux send-keys -t dev:editor 'cd ~/projects' C-m 'nvim .' C-m

    # Create additional windows
    tmux new-window -t dev -n "terminal"
    tmux send-keys -t dev:terminal 'cd ~/projects' C-m

    # Split terminal window into panes
    tmux split-window -t dev:terminal -h
    tmux send-keys -t dev:terminal.2 'cd ~/projects' C-m

    # Create server window
    tmux new-window -t dev -n "server"
    tmux send-keys -t dev:server 'cd ~/projects' C-m
fi

# System monitoring session setup

if ! create_session_if_needed "monitor" "system"; then
    # System monitoring window
    tmux send-keys -t monitor:system 'htop' C-m

    # Create logs window
    tmux new-window -t monitor -n "logs"
    tmux send-keys -t monitor:logs 'tail -f /var/log/syslog' C-m

    # Create network window
    tmux new-window -t monitor -n "network"
    tmux send-keys -t monitor:network 'iftop' C-m
fi

# Notes session setup
if ! create_session_if_needed "notes" "wiki"; then
    tmux send-keys -t notes:wiki 'cd ~/notes' C-m 'nvim index.md' C-m

    # Create scratch window
    tmux new-window -t notes -n "scratch"
    tmux send-keys -t notes:scratch 'cd ~/notes/scratch' C-m
fi

# Select first session if we're not already in tmux
if [ -z "$TMUX" ]; then
    tmux attach-session -t dev
fi
