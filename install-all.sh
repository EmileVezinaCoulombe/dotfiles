#!/bin/bash
# Guide for calendar with icloud https://ar.al/2018/08/05/using-icloud-calendars-on-gnu-linux/
sudo apt update
sudo apt upgrade

PACKAGER_INSTALL="sudo apt install"
INSTALL_OPTIONS=()
SECOND_PACKAGER_INSTALL="sudo apt-get install"
SECOND_INSTALL_OPTIONS=()

FONT_RED="\033[1;31m"
FONT_GREEN="\033[0;32m"
FONT_YELLOW="\033[1;33m"
COLOR_END="\033[0m"

# Functions
default_install() {
	echo -e "\nDo you want to install ${FONT_GREEN}$1${COLOR_END}\n"
	echo -en "[y|n]${FONT_YELLOW} >>> ${COLOR_END}"
	read -r -k 1 IS_INSTALLING
	echo $'\n'
	if [ "$IS_INSTALLING" = "y" ] || [ "$IS_INSTALLING" = "Y" ]; then
		INSTALL_CMD="$PACKAGER_INSTALL ${INSTALL_OPTIONS[@]} $1"
		echo -e "${FONT_YELLOW}Installing $1${COLOR_END} with $INSTALL_CMD\n"
		eval "$INSTALL_CMD"
	fi
}

second_install() {
	DEFAULT_INSTALL_CMD=$PACKAGER_INSTALL
	DEFAULT_INSTALL_OPTIONS=$INSTALL_CMD
	PACKAGER_INSTALL=$SECOND_PACKAGER_INSTALL
	INSTALL_OPTIONS=$SECOND_INSTALL_OPTIONS
	default_install "$1"
	PACKAGER_INSTALL=$DEFAULT_INSTALL_CMD
	INSTALL_OPTIONS=$DEFAULT_INSTALL_OPTIONS
}

cmd_exist() {
	if type "$1" &>/dev/null; then
		return 0
	else
		return 1
	fi
}

install_cmd() {
	cmd_exist "$1"
	is_cmd_exist=$?
	if [ $is_cmd_exist != 0 ]; then
		default_install "$1"
	fi
	cmd_exist "$1"
	is_cmd_exist=$?
	if [ $is_cmd_exist != 0 ]; then
		second_install "$1"
	fi
	cmd_exist "$1"
	is_cmd_exist=$?
	if [ $is_cmd_exist != 0 ]; then
		echo -e "${FONT_RED}Cant install $1${COLOR_END}"
	fi

}

install_flatpak() {
	if [[ ! $(flatpak list | grep -q "$1") ]]; then
		INSTALL_CMD="flatpak install $1"
		echo -e "\n${FONT_YELLOW}Installing $1${COLOR_END} with $INSTALL_CMD\n"
		eval "$INSTALL_CMD"
	fi
}

# Installation
cd ~

install_cmd zsh
install_cmd stow
install_cmd xsel
install_cmd direnv
install_cmd tmux
install_cmd graphviz
install_cmd xsel
install_cmd wl-clipboard
install_cmd sshfs
install_cmd lolcat
install_cmd exa
second_install ripgrep
second_install fd-find
second_install fonts-powerline

# NVM
cmd_exist nvm
is_cmd_exist=$?
if [ $is_cmd_exist != 0 ]; then
	echo -e "\n${FONT_YELLOW}Installing nvm${COLOR_END}\n"
	wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi

nvm install 18
nvm use 18
nvm alias default 18

# git
cmd_exist git
is_cmd_exist=$?
if [ $is_cmd_exist != 0 ]; then
	echo -e "\n${FONT_YELLOW}Installing git${COLOR_END}\n"
	install_cmd git-all
fi
npm install --location=global git-stats
npm install --location=global git-stats-importer
pip install --user git-fame
npm install --location=global spaceship-prompt

cmd_exist lazygit
is_cmd_exist=$?
if [ $is_cmd_exist != 0 ]; then
	echo -e "\n${FONT_YELLOW}Installing lazygit${COLOR_END}\n"
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit
fi

# fzf
cmd_exist fzf
is_cmd_exist=$?
if [ $is_cmd_exist != 0 ]; then
	echo -e "\n${FONT_YELLOW}Installing fzf${COLOR_END}\n"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
fi

# Nvim
cmd_exist neovim
is_cmd_exist=$?
if [ $is_cmd_exist != 0 ]; then
	echo -e "\n${FONT_YELLOW}Installing nvim${COLOR_END}\n"
	pip install --user cmake
	sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
    cd ~/Applications || return
	gh repo clone neovim/neovim
	cd neovim || return
	git checkout nightly
    make CMAKE_BUILD_TYPE=RelWithDebInfo
	sudo make install
    cd ~ || return
fi

# Micro

cmd_exist micro
is_cmd_exist=$?
if [ $is_cmd_exist != 0 ]; then
	echo -e "\n${FONT_YELLOW}Installing micro${COLOR_END}\n"
    cd ~/Applications || return
    gh clone https://github.com/zyedidia/micro
    cd micro  || return
    make build
    sudo mv micro /usr/local/bin
    cd ~ || return
fi

# gh
cmd_exist gh
is_cmd_exist=$?
if [ $is_cmd_exist != 0 ]; then
	echo -e "\n${FONT_YELLOW}Installing gh${COLOR_END}\n"
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
	default_install gh
fi

gh extension install mislav/gh-branch
gh extension install dlvhdr/gh-dash
gh extension install maximousblk/gh-fire
gh extension install kawarimidoll/gh-graph
gh extension install meiji163/gh-notify
gh extension install seachicken/gh-poi
gh extension install vilmibm/gh-screensaver
gh extension install korosuke613/gh-user-stars
gh extension install sheepla/gh-userfetch

# pyenv
cmd_exist pyenv
is_cmd_exist=$?
if [ $is_cmd_exist != 0 ]; then
	echo -e "\n${FONT_YELLOW}Installing pyenv${COLOR_END}\n"
	curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
fi

# shfmt
cmd_exist shfmt
is_cmd_exist=$?
if [ $is_cmd_exist != 0 ]; then
	echo -e "\n${FONT_YELLOW}Installing shfmt${COLOR_END}\n"
	curl -sS https://webinstall.dev/shfmt | bash
fi

# nnn
cmd_exist nnn
is_cmd_exist=$?
if [ $is_cmd_exist != 0 ]; then
    touch "install.sh"
	echo -e "\n${FONT_YELLOW}Installing nnn${COLOR_END}\n"
    {
        echo "#\!/bin/bash"
        printf "\n"
        echo "sudo make O_NERD=1"
        echo "sudo cp nnn /bin/"
        echo "mkdir -p ~/.config/nnn/plugins"
        echo "cd ~/.config/nnn/plugins"
        echo "curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh"
    } >> install.sh
    . ./install.sh
fi

# Flatpak
install_cmd flatpak
install_flatpak com.getpostman.Postman
install_flatpak com.github.IsmaelMartinez.teams_for_linux
install_flatpak com.github.jeromerobert.pdfarranger
install_flatpak com.github.maoschanz.drawing
install_flatpak com.nextcloud.desktopclient.nextcloud
install_flatpak com.slack.Slack
install_flatpak com.spotify.Client
install_flatpak com.uploadedlobster.peek
install_flatpak com.github.xournalpp.xournalpp
install_flatpak io.dbeaver.DBeaverCommunity
install_flatpak io.gitlab.librewolf-community
install_flatpak md.obsidian.Obsidian
install_flatpak net.ankiweb.Anki
install_flatpak org.gnome.Boxes
install_flatpak org.gnome.Devhelp
install_flatpak org.kde.okular
install_flatpak org.kicad.KiCad
install_flatpak org.mozilla.Thunderbird
install_flatpak org.onlyoffice.desktopeditors
install_flatpak org.qownnotes.QOwnNotes
install_flatpak org.raspberrypi.rpi-imager
install_flatpak org.signal.Signal

# Python
pip install --user magic-wormhole
pip install --user pynvim
pip install --user pipenv
pip install --user rope
pip install --user ropevim
pip install --user pipx
pipx install rich-cli

mkdir .virtualenvs
cd .virtualenvs
python -m venv debugpy
debugpy/bin/python -m pip install debugpy
cd ~

# npm
npm install --location=global diff-so-fancy
npm install --save-dev --save-exact prettier
npm install eslint --save-dev
npm i --location=global neovim

# Rust
cmd_exist rustup
is_cmd_exist=$?
if [ $is_cmd_exist != 0 ]; then
	echo -e "\n${FONT_YELLOW}Installing rustup${COLOR_END}\n"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	rustup component add rustfmt            # For code formatting
	rustup component add rls                # lsp
	rustup component add clippy             # linting
	rustup component add llvm-tools-preview # Preview
fi

cargo install gitui
cargo install onefetch
cargo install --locked bat
cargo install bottom
cargo install du-dust

# Lua

cmd_exist luaver
is_cmd_exist=$?
if [ $is_cmd_exist != 0 ]; then
	echo -e "\n${FONT_YELLOW}Installing luaver${COLOR_END}\n"
	install_cmd libreadline-dev
	curl -fsSL https://raw.githubusercontent.com/dhavalkapil/luaver/master/install.sh | sh -s - -r v1.1.0
	cargo install stylua
fi

luaver install 5.4.4
luaver set-default 5.4.4

# Ricing

install_cmd cava
install_cmd tty-clock

cmd_exist pipes
is_cmd_exist=$?
if [ $is_cmd_exist != 0 ]; then
	echo -e "\n${FONT_YELLOW}Installing pipes${COLOR_END}\n"
    cd ~/Applications || return
    gh repo clone pipeseroni/pipes.sh
    cd pipes.sh || return
    sudo make install
fi
# install config files and reload
. ~/.dotfiles/install.sh
source ~/.config/zsh/.zshrc
