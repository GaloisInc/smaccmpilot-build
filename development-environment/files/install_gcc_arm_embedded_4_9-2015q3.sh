#! /usr/bin/env bash
set -e
GCC_DIR=gcc-arm-none-eabi-4_9-2015q3
GCC_TAR=${GCC_DIR}-20150921-linux.tar.bz2
if [ ! -d $GCC_DIR ]; then
if [ ! -f $GCC_TAR ]; then
    wget https://launchpad.net/gcc-arm-embedded/4.9/4.9-2015-q3-update/+download/$GCC_TAR
fi
tar xf $GCC_TAR
fi
GCC_PATH=$HOME/$GCC_DIR/bin
if [[ ! ":$PATH:" == *":$GCC_PATH:"* ]]; then
	echo "# automatically adding gcc-arm-embedded to PATH:" >> ~/.bashrc
	echo "PATH=\$PATH:$GCC_PATH" >> ~/.bashrc
	echo "export PATH" >> ~/.bashrc
	if [ -d ~/.zsh ]; then
		echo "# AUTOMATICALLY ADDING TO PATH:" >> ~/.zsh/site-config
		echo "PATH=\$PATH:$GCC_PATH" >> ~/.zsh/site-config
		echo "export PATH" >> ~/.zsh/site-config
	fi
fi
