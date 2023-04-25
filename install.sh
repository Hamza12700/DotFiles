installer ()
{
  cat << EOL

    ---
    Updating...
    ---

    EOL

  # Updating
  yay -Syu --noconfirm
  clear

  # Installing Packages
  echo "Installing Packages\n"
  yay -S nitch alacritty atuin httpie neovim atuin zoxide exa bat --noconfirm --needed
  clear
  
  # Checking if the font directory exist
  if [ -e ~/.local/share/fonts/ ]; then
    cp -r ./MesloLGS/* ~/.local/share/fonts/
    fc-cache -vf
    clear
  else
    echo "Fonts directory don't exist"
    echo "Creating fonts directory in ~/.local/share/fonts\n"
    mkdir ~/.local/share/fonts
    cp -r ./MesloLGS/* ~/.local/share/fonts/
    fc-cache -vf
    clear
  fi

  # LunarVim
  read -p "Do you want to install LunarVim [y/N] " lv
  case "$lv" in
    y) 
      LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
    ;;
    *) echo "\nSkipping...\n"
    ;;
  esac

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
