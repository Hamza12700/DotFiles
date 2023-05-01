#!/bin/bash

nvimInstaller () {
  version=$(nvim --version | awk '/NVIM/ {print $2}')
  if [[ $version == *"-dev"* ]]; then
    echo "Development version of neovim $version is installed!"
    read -pr "Do you want to install latest version LunarVim [Y/n]" vyn
    if [ "$vyn" == "n" ]; then
      echo "Skipping..."
    else
      printf "Installing Lastest Version of LunarVim\n"
      bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
    fi
  else
    echo "Stable version of neovim $version is installed!"
    read -pr "Do you want to install stable version of LunarVim [Y/n]" vyn
    if [ "$vyn" == "n" ]; then
      echo "Skipping..."
    else
      printf "Installing Stable Version of LunarVim\n"
      LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
    fi
  fi
}

# Rofi Installer
rofiInstaller() {
  printf "Cloning rofi themes\n"
  git clone https://github.com/lr-tech/rofi-themes-collection.git
  mkdir -p ~/.local/share/rofi/themes/
  cp -r ./rofi-themes-collection/themes/* ~/.local/share/rofi/themes
  printf "\nYou can choose the rofi theme by running: rofi -show run, and then type rofi-theme-selector"
  printf "Then choose what theme you like!"
  cp ./config/rofi/config.rasi ~/.config/rofi/
}

installer ()
{
  echo "---"
  echo "Updating"
  printf "---\n"

  # Updating
  yay -Syu --noconfirm
  clear

  # Installing Packages
  printf "Installing Packages\n"
  yay -S nitch copyq unclutter ksnip brightnessctl btop dunst fd fzf github-cli network-manager-applet networkmanager-dmenu-git nm-connection-editor npm noto-fonts-emoji noto-fonts noto-fonts-extra picom spotify-launcher tree-sitter ttf-droid ttf-hack ttf-hack-nerd ttf-jetbrains-mono ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols-mono zsh lxappearance arc-gtk-theme git papirus-icon-theme thunar alsa-utils alsa-firmware pipewire-audio pipewire-alsa pipewire-pulse bluez xclip feh nitrogen ranger alacritty lazygit pacman-contrib trash-cli ttf-meslo-nerd httpie atuin zoxide exa bat starship nodejs rofi unzip --noconfirm --needed
  clearq
  
  # Neovim/LunarVim
  if command -v nvim &> /dev/null; then
    nvimInstaller 
  else
    echo "Neovim is not installed!"
    echo "Do you want to install nightly version of nvim OR stable version?"
    echo "[1] Nightly Version"
    echo "[2] Stable Version"
    read -pr "Installation process [1/2]" vyn

    if [[ "$vyn" -eq 2 ]]; then
      echo "Installation Stable Version of Neovim"
      sudo pacman -S neovim --noconfirm
      nvimInstaller
    else
      echo "Installation Nightly Version of Neovim"
      yay -S neovim-nightly
      nvimInstaller
    fi
  fi

  # Pnpm
  echo "Do you want to install pnpm throught the AUR helper or the official install script?"
  echo "1: AUR Helper"
  echo "2: Official Installation script"
  read -pr "Installation process [1/2] " pnyn

  case "$pnyn" in
    1) yay -S pnpm --noconfirm
    ;;
    *) 
      echo "Installing pnpm"
      printf "Please note that you need to follow some steps before you using it!\n"
      curl -fsSL https://get.pnpm.io/install.sh | sh -
    ;;
  esac

  # Zsh config
  if [ -e ~/.zshrc ]; then
    echo ".zshrc file exist"
    echo "Moving .zshrc to .zshrc.bak"
    mv ~/.zshrc ~/.zshrc.bak
    cp ./.config/zsh/.zshrc ~/
    if [ -e ~/.zshenv ]; then
      mv ~/.zshenv ~/.zshenv.bak
      cp ./.config/zsh/.zshenv ~/
    else
      cp ./.config/zsh/.zshenv ~/
    fi
  else
    mv ~/.zshrc ~/.zshrc.bak
    cp ./.config/zsh/.zshrc ~/
  fi

  # Rofi Installation
  printf "Coping rofi config\n"
  if [ -e ~/.config/rofi/config.rasi ]; then
    echo "Rofi config found"
    echo "Moving config.rasi to config.rasi.bak"
    mv ~/.config/rofi/config.rasi ~/.config/rofi/config.rasi.bak
    rofiInstaller
  else
    mkdir -p ~/.config/rofi
    rofiInstaller
  fi

  # Installing Zplug
  printf "Installing Zplug\n"
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
  printf "\nInstalling plugins\n"
  exec zsh
  zplug inatall
}

# Checking if yay is install
if which yay >/dev/null; then
  installer
else
  echo "yay not found!"
  read -pr "Do you want to build yay from source? [y/N] " yn
  case "$yn" in
    y* ) 
      git clone https://aur.archlinux.org/yay.git
      pushd yay/
      makepkg -si --noconfirm
      popd
      installer
    ;;
    *) 
      echo "Yay is not installed!"
      echo "Existing"
      exit
    ;;
  esac
fi
