# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# XDG Base Directory Spec
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"
export GIMP2_DIRECTORY="${XDG_CONFIG_HOME}/gimp"
export PIP_CONFIG_FILE="${XDG_CONFIG_HOME}/pip/pip.conf"
export PIP_LOG_FILE="${XDG_CONFIG_HOME}/pip/log"
export LESSHISTFILE="${XDG_CONFIG_HOME}/less/history"
export ICEAUTHORITY="${XDG_CACHE_HOME}/ICEauthority"
export HISTFILE="${XDG_CACHE_HOME}/bash_history"
export GNUPGHOME="${XDG_CONFIG_HOME}/gnupg"

ERRFILE="$HOME/.xsession-errors"
if [[ -e "$ERRFILE" ]]; then mv "$ERRFILE" "${XDG_CACHE_HOME}/"; fi
