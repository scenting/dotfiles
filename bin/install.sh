#!/bin/bash
set -e

# install.sh
#	This script installs my basic setup for a debian laptop

# get the user that is not root
# TODO: makes a pretty bad assumption that there is only one other user
USERNAME=$(find /home/* -maxdepth 0 -printf "%f" -type d)
export DEBIAN_FRONTEND=noninteractive

check_is_sudo() {
	if [ "$EUID" -ne 0 ]; then
		echo "Please run as root."
		exit
	fi
}

# installs base packages
base() {
	apt-get update
	apt-get -y upgrade

	apt-get install -y \
		adduser \
		alsa-utils \
		apparmor \
		apt-transport-https \
		automake \
		bash-completion \
		bc \
		bridge-utils \
		bzip2 \
		ca-certificates \
		cgroupfs-mount \
		coreutils \
		curl \
		dnsutils \
		file \
		findutils \
		gcc \
		git \
		gnupg \
		grep \
		gzip \
		hostname \
		indent \
		iptables \
		jq \
		less \
		libc6-dev \
		libltdl-dev \
		locales \
		lsof \
		make \
		mount \
		net-tools \
		network-manager \
		openvpn \
		rxvt-unicode-256color \
		s3cmd \
		scdaemon \
		ssh \
		strace \
		sudo \
		tar \
		tree \
		tzdata \
		unzip \
		xclip \
		xcompmgr \
		xz-utils \
		zip \
		--no-install-recommends

	# install tlp with recommends
	apt-get install -y tlp tlp-rdw

	setup_sudo

	apt-get autoremove
	apt-get autoclean
	apt-get clean
}

# install stuff for i3 window manager
install_wmapps() {
	local pkgs="feh i3 i3lock i3status scrot slim"

	apt-get install -y $pkgs --no-install-recommends
}

get_dotfiles() {
	# create subshell
	(
	cd "/home/$USERNAME"

	# install dotfiles from repo
	git clone git@github.com:scenting/dotfiles.git "/home/$USERNAME/dotfiles"
	cd "/home/$USERNAME/dotfiles"

	# installs all the things
	make

	# enable dbus for the user session
	# systemctl --user enable dbus.socket

	sudo systemctl enable i3lock
	sudo systemctl enable suspend-sedation.service

	cd "/home/$USERNAME"

	# install .vim files
	git clone --recursive git@github.com:scenting/.vim.git "/home/$USERNAME/.vim"
	ln -snf "/home/$USERNAME/.vim/vimrc" "/home/$USERNAME/.vimrc"
	sudo ln -snf "/home/$USERNAME/.vim" /root/.vim
	sudo ln -snf "/home/$USERNAME/.vimrc" /root/.vimrc
	)
}

# setup sudo for a user
# because fuck typing that shit all the time
# just have a decent password
# and lock your computer when you aren't using it
# if they have your password they can sudo anyways
# so its pointless
# i know what the fuck im doing ;)
setup_sudo() {
	# add user to sudoers
	adduser "$USERNAME" sudo

	# add user to systemd groups
	# then you wont need sudo to view logs and shit
	gpasswd -a "$USERNAME" systemd-journal
	gpasswd -a "$USERNAME" systemd-network
}

usage() {
	echo -e "install.sh\n\tThis script installs my basic setup for a debian laptop\n"
	echo "Usage:"
	echo "  sources                     - setup sources & install base pkgs"
	echo "  wm                          - install window manager/desktop pkgs"
	echo "  dotfiles                    - get dotfiles"
}

main() {
	local cmd=$1

	if [[ -z "$cmd" ]]; then
		usage
		exit 1
	fi

	if [[ $cmd == "sources" ]]; then
		check_is_sudo

		base
	elif [[ $cmd == "wm" ]]; then
		check_is_sudo

		install_wmapps
	elif [[ $cmd == "dotfiles" ]]; then
		get_dotfiles
	else
		usage
	fi
}

main "$@"
