#! /usr/bin/env bash
set -e
if [ ! $(which cabal) == "$HOME/.cabal/bin/cabal" ]; then
echo "# automatically adding cabal bin to front of PATH:" >> ~/.bashrc
echo "PATH=$HOME/.cabal/bin:\$PATH" >> ~/.bashrc
echo "export PATH" >> ~/.bashrc
if [ -f ~/.zsh/site-config ]; then
	echo "# automatically adding cabal bin to front of PATH:" >> ~/.zsh/site-config
	echo "PATH=$HOME/.cabal/bin:\$PATH" >> ~/.zsh/site-config
	echo "export PATH" >> ~/.zsh/site-config
fi
fi
