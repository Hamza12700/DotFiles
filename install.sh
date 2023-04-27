#!/bin/sh

nvimInstaller () {
  version=$(nvim --version | awk '/NVIM/ {print $2}')
  if [[ $version == *"-dev"* ]]; then
    echo "Development version of neovim $version is installed!"
    read -p "Do you want to install latest version LunarVim [Y/n]" vyn
    if [ "$vyn" == "n" ]; then
      echo "Skipping..."
    else
      echo "Installing Lastest Version of LunarVim\n"
      bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
    fi
  else
    echo "Stable version of neovim $version is installed!"
    read -p "Do you want to install stable version of LunarVim [Y/n]" vyn
    if [ "$vyn" == "n" ]; then
      echo "Skipping..."
    else
      echo "Installing Stable Version of LunarVim\n"
      LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
    fi
  fi
}

installer ()
{
  echo "---"
  echo "Updating"
  echo "---\n"

  # Updating
  yay -Syu --noconfirm
  clear

  # Installing Packages
  echo "Installing Packages\n"
  yay -S nitch alacritty atuin ttf-hack-nerd ttf-meslo-nerd httpie atuin zoxide exa bat starship --noconfirm --needed
  clear
  
  # Neovim/LunarVim
  if command -v nvim &> /dev/null; then
    nvimInstaller 
  else
    echo "Neovim is not installed!"
    echo "Do you want to install nightly version of nvim OR stable version?"
    echo "[1] Nightly Version"
    echo "[2] Stable Version"
    read -p "Installation process [1/2]" vyn

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
  read -p "Installation process [1/2] " pnyn

  case "$pnyn" in
    1) yay -S pnpm --noconfirm
    ;;
    *) 
      echo "Installing pnpm"
      echo "Please note that you need to follow some steps before you using it!\n"
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

  # Installing Zplug
  echo "Installing Zplug\n"
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
  echo "\nInstalling plugins\n"
  exec zsh
  echo "Note: if the powerlevel10k doesn't activate when reopen the terminal try running manually: p10k\n"
  zplug inatall
}

# Checking if yay is install
if which yay >/dev/null; then
  installer
else
  echo "yay not found!"
  read -p "Do you want to build yay from source? [y/N] " yn
  case "$yn" in
    y* ) 
      if which git >/dev/null; then
        git clone https://aur.archlinux.org/yay.git
        pushd yay/
        makepkg -si --noconfirm
        popd
        installer
      else
        echo "git not found!"
        echo "Installing git\n"
        sudo pacman -S git
        git clone https://aur.archlinux.org/yay.git
        pushd yay/
        makepkg -si --noconfirm
        popd
        installer
      fi
    ;;
    *) 
      sudo pacman -S yay
      installer
    ;;
  esac
fi
