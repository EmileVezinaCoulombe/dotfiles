################################################################################
set -U EDITOR nvim

################################################################################
set -g fish_key_bindings fish_vi_key_bindings

set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore
set fish_cursor_external line
set fish_cursor_visual block

################################################################################
function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr -a dotdot --regex '^\.\.+$' --function multicd

################################################################################
# Fzf
set fzf_fd_opts --hidden

fzf_configure_bindings --directory=\cF --git_log=\cL --git_status=\cS --history=\cH --processes=\cP --variables=\cV

################################################################################
# Sponge
set sponge_delay 5

################################################################################
# Zoxide

zoxide init fish | source
abbr -a cd z

################################################################################
# Done

#set -U __done_sway_ignore_visible 1
set -U __done_notify_sound 1
set -U __done_min_cmd_duration 5000
set -U --append __done_exclude '^git'
set -U __done_notification_command "notify-send --urgency=low --expire-time=3000 \$title \$message"

################################################################################
abbr -a neo "clear && neofetch"
