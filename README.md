# Vim configuration files

The .vimrc should be commented to give you some idea of what is included.
As usual `:help <topic>` is your friend.

## Installation

First backup you own configuration files. Then clone this repository and copy
the configuration files to your runtime path.

    $ git clone git@github.com:arames/vim-config.git && cd vim-config
    $ cp -r .vimrc .vim ~/

The .vimrc uses the Vundle plugin (https://github.com/gmarik/vundle) to manage
other plugins. You will need to clone the repo

    $ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

and install the plugins by launching `vim` and running `:BundleInstall`.
