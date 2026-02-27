#!/bin/zsh

# Required for nushell and zellij to exist in PATH
# export PATH=$HOME/.nix-profile/bin:$PATH
# export PATH=$HOME/.cargo/bin:$PATH

export XDG_CONFIG_HOME=$HOME/.config

# If nu exists, set the shell to that
if which nu >/dev/null 2>&1; then
	export SHELL=nu
fi

if [ -z "${NO_ZELLIJ_PLZ}" ]; then
	zellij && exit
else
	$SHELL && exit
fi
