#!/bin/bash

###############################################################################
# Personal Arch installer

###############################################################################
# Set variables
CWD="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LOG_FILE="/var/log/arch-install.log"

###############################################################################
# Greeting
logo() {
	echo -ne "
    ╭────────────────────────────────╮
    │🅐 🅡 🅒 🅗  ____  ____  _    _     │
    │        (  - \(_  _)( \/\/ )    │
    │         ) _ <  )(   )    (     │
    │        (____/ (__) (__/\__)    │
    ╰────────────────────────────────╯
"
}
echo -ne "
       Starting installation of
"
logo

###############################################################################
# Installation

(bash "$CWD/startup.sh") |& tee "$LOG_FILE"

###############################################################################
# Farewell
logo
echo -ne "
 Done - Please Eject Install Media and Reboot
"
