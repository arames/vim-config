#!/bin/sh

BASE_DIR=~
TARGET_DIR=$BASE_DIR

# Backup existing configuration.
BACKUP_DIR=backup.`date +%F-%R`
mkdir -p $BACKUP_DIR
BASE_VIMRC=$BASE_DIR/.vimrc
BASE_VIM_CONFIG=$BASE_DIR/.vim
echo "Backing up existing configuration to $BACKUP_DIR"
if [ -f $BASE_VIMRC ] ; then
	cp -R $BASE_VIMRC $BACKUP_DIR/
fi
if [ -d $BASE_VIM_CONFIG ] ; then
	cp -R $BASE_VIM_CONFIG $BACKUP_DIR/
fi


echo "Clearing existing config"
rm -rf $BASE_VIMRC
rm -rf $BASE_VIM_CONFIG


echo "Copying new files."
# Copy the new files.
cp -R .vim $BASE_DIR/
ln -s `pwd`/.vimrc $BASE_DIR/.vimrc
echo "Installing the plugin manager."
git clone https://github.com/gmarik/vundle.git $TARGET_DIR/.vim/bundle/vundle
echo "Installing plugins."
vim -c BundleInstall -c qall



echo "Done."
