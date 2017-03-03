#!/bin/bash

error() {
	echo -e "${CRED}ERROR: $*${CNC}" >&2
	exit 1
}


safe() {
	echo -e "${CGREEN}$@${CNC}"
	"$@" || error "FAILED command:\n$*";
}


echo "Note that this script now only installs the configuration for neovim."

VIMDIR=~/.config/nvim

# Backup existing configuration.
BACKUP_DIR=backup.`date +%F-%R`

if [ -d $BACKUP_DIR ]; then
	error "The backup directory $BACKUP_DIR already exists."
fi

mkdir -p $BACKUP_DIR

if [ -e $VIMDIR ]; then
	echo "Saving existing configuration."
	safe mv $VIMDIR $BACKUP_DIR
fi

echo "Copying new files."
safe cp -R .vim $VIMDIR
safe ln -s `pwd`/.vimrc $VIMDIR/init.vim

echo "Installing the plugin manager (vim-plug)."
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Installing plugins."
safe nvim -c PlugInstall

echo "Done."
