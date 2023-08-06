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

# linking .zshrc

linkZsh() {
  ln -s ../.config/zsh/.zshrc ~/.zshrc
  gum style --foreground=$greenColor --margin "1 2" "Linked the new zshrc config to ~/.zshrc"
  sleep 2
  clear
}

if [ -f "$HOME/.zshrc" ]; then
  gum style --foreground 215 --margin "1 2" --bold ".zshrc file exists" 
  gum confirm "Do you want to delete the existing zshrc and link the new zshrc config?" && rm ~/.zshrc && linkZsh || gum style --foreground=$redColor --margin "1 2" "Didn't link the new zshrc config!"
else
  linkZsh 
fi

# Installing Rofi-Themes
gum style --foreground=$greenColor --margin "1 2" "Installing Rofi-Themes"
gum spin --spinner line --title "Cloning Rofi-Themes" -- git clone https://github.com/lr-tech/rofi-themes-collection.git 
mkdir -p ~/.local/share/rofi/themes/
mv rofi-themes-collection/themes/* ~/.local/share/rofi/themes/
rm -rf rofi-themes-collection
