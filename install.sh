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

echo "Saving existing configuration."
safe mv $VIMDIR $BACKUP_DIR

echo "Copying new files."
safe cp -R .vim $VIMDIR
safe ln -s `pwd`/.vimrc $VIMDIR/init.vim

echo "Installing the plugin manager."
safe git clone https://github.com/gmarik/vundle.git $VIMDIR/bundle/vundle

echo "Installing plugins."
safe nvim -c PluginInstall -c qall

echo "Minor fixes to the config."
# Use the diffgofile plugin for git diffs.
safe mkdir -p $VIMDIR/ftplugin/
safe ln -s $VIMDIR/bundle/vim-diffgofile/ftplugin/diff_gofile.vim $VIMDIR/ftplugin/git_diffgofile.vim

echo "Done."
