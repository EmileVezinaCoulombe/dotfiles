# /etc/zsh/zshenv
# Used for setting environment variables for all users;
# This cannot be overridden.

# $ZDOTDIR/.zshenv.
# Used for setting user's environment variables;
# When this file exists it will always be read.
# It's sourced on all invocations of the shell, unless the -f option is set.
# It should contain commands to set the command search path, plus other important environment variables.
# Contains exported variables that should be available to other programs : $PATH, $EDITOR, $PAGER
# It should not contain commands that produce output or assume the shell is attached to a TTY.
################################################################################
# Shell
export ZDOTDIR=$HOME/.config/zsh
export ZALIASES="$ZDOTDIR/zsh-aliases"
export ZFUNCTIONS="$ZDOTDIR/zsh-functions"
export ZSECRETS="$ZDOTDIR/.secrets"

################################################################################
# Default programs
export EDITOR="nvim"

################################################################################
# XDG Paths
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

################################################################################
# User variable
export GITHUB_USERNAME=EmileVezinaCoulombe
export GITHUB_EMAIL=emilevezinacoulombe@icloud.com

################################################################################
# Software
export PYENV_ROOT="$HOME/.pyenv"
. "$HOME/.cargo/env"
