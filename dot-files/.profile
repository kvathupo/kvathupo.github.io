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

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set paths so cuda-11.8 is included if it exists
# @TODO: If using a separate version of CUDA, replace with that version number.
# Do NOT install CUDA via a Linux package manager, just grab the version off 
# NVIDIA's site.
if [ -d "/usr/local/cuda-11.8/" ] ; then
    PATH="/usr/local/cuda-11.8/bin:$PATH"
    LD_LIBRARY_PATH="/usr/local/cuda-11.8/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
fi

# >>> set pytorch variables >>>
if [ -d "/usr/local/cuda-11.8" ] ; then
    CUDA_HOME="/usr/local/cuda-11.8"
fi

if [ -f "/usr/local/cuda-11.8/bin/nvcc" ] ; then
    CUDA_NVCC_EXECUTABLE="/usr/local/cuda-11.8/bin/nvcc"
fi
# <<< set pytorch variables <<<
