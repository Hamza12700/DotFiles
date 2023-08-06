#!/bin/bash

greenColor="#32a852"
redColor="#eb344f"

clear
gum style --foreground="#4293f5" --margin "1 2" --bold "Welcome to the installer"

# Installing zplug
gum spin --spinner line --title "Installing zplug" -- curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

zshInstaller() {
  gum style --foreground=$greenColor --margin "1 2" "Installing zsh plugins"
  zplug install
  gum style --foreground=$greenColor --margin "1 2" --bold "Done!"
  sleep 1
  clear
}

if ps -p $$ -ocomm= | grep -q "zsh"; then
  gum style --foreground=$greenColor --margin "1 2" "Already using zsh"
  zshInstaller 
else
  gum style --foreground=$redColor --margin "Not using zsh"
  exec zsh
  zshInstaller
fi
