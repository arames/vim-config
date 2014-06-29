#!/bin/sh

BASE_DIR=~
TARGET_DIR=$BASE_DIR

# Backup existing configuration.
BACKUP_DIR=backup.`date +%F-%R`
mkdir --parents $BACKUP_DIR
BASE_VIMRC=$BASE_DIR/.vimrc
BASE_VIM_CONFIG=$BASE_DIR/.vim
echo "Backing up existing configuration to $BACKUP_DIR"
if [ -f $BASE_VIMRC ] ; then
	cp --recursive --no-clobber $BASE_VIMRC $BACKUP_DIR/
fi
if [ -f $BASE_VIM_CONFIG ] ; then
	cp --recursive --no-clobber $BASE_VIM_CONFIG $BACKUP_DIR/
fi



echo "Copying new files."
# Copy the new files.
cp -R .vim $BASE_DIR/
cp -R .vimrc $BASE_DIR/
echo "Installing the plugin manager."
git clone https://github.com/gmarik/vundle.git $TARGET_DIR/.vim/bundle/vundle
echo "Installing plugins."
vim -c BundleInstall -c qall



echo "Done."
