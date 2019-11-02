#!/bin/bash

platform='unknown'

function detect_os() {
    unamestr=`uname`
    if [[ "$unamestr" == 'Linux' ]]; then
        platform='linux'
    elif [[ "$unamestr" == 'Darwin' ]]; then
        platform='darwin'
    fi
}

function bear() {
    printf "
     (()__(()
     /       \         
    ( /    \  \\        Welcome to config bear(er)
     \ o o    /        
     (_()_)__/ \\       This script will configure the system
    / _,==.____ \\      based on my configuration.
   (   |--|      )
   /\_.|__|'-.__/\_    Source: https://github.com/pniedzwiedzinski/config-bear
  / (        /     \           https://github.com/pniedzwiedzinski/dotfiles
  \  \      (      /
   )  '._____)    /    
(((____.--(((____/mrf
    \n\n"
}

function setup_dotfiles() {
    echo "Getting dotfiles"
    curl -sfL https://git.io/chezmoi | sh
    chezmoi init https://github.com/pniedzwiedzinski/dotfiles
    chezmoi apply
    echo "Dotfiles applied"
}

function darwin_install() {
    echo "Installing Homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /dev/null
    for APP in $(cat ~/.config/config-bear/default.apps); do
        brew install $APP
    done
}

main() {
    detect_os
    if [[ "$platform" == "unknown" ]]; then
        echo "Unknown platform"
    else
        bear
        setup_dotfiles
        if [[ "$platform" == "darwin" ]]; then
            darwin_install
        elif [[ "$platform" == "linux" ]]; then
            linux_install
        fi
    fi
}

main