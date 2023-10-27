# DotFiles

My Hyprland dotfiles.

![HomeScreen](./screenshots/screenshot.png)

## Tools

- [Zplug](https://github.com/zplug/zplug) Zsh Plugins Manager

- [MesloLGS NF Fonts](https://github.com/romkatv/powerlevel10k-media/tree/master) Iconic font aggregator, collection, 3,600+ icons

- [Rofi](https://github.com/davatorium/rofi) App Launcher

- [Alacritty](https://github.com/alacritty/alacritty) A cross-platform, OpenGL terminal emulator

- [Atuin](https://github.com/ellie/atuin) Magical shell history

- [Zoxide](https://github.com/ajeetdsouza/zoxide) A smarter cd command. Supports all major shells

- [EZA](https://github.com/eza-community/eza) A modern replacement for `ls`

## Installation

You will need to install `git` and `stow`
Clone the repo and `cd` into the `config` directory
```bash
git clone https://github.com/hamza12700/DotFiles && \
cd DotFiles/config
```

Run `stow` to symlink everything or just select what you want
```bash
stow */ -t ~/
```

## Packages

```bash
yay -Syu neofetch jq hyprpicker swaylock-effects waybar xdg-desktop-portal-hyprland unclutter brightnessctl btop dunst fd fzf github-cli network-manager-applet \
  networkmanager-dmenu-git nm-connection-editor npm noto-fonts-emoji noto-fonts noto-fonts-extra picom tree-sitter \
  ttf-droid ttf-hack ttf-jetbrains-mono ttf-meslo-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common \
  ttf-nerd-fonts-symbols-mono wireplumber zsh go arc-gtk-theme git papirus-icon-theme thunar bluez bluez-utils ripgrep cliphist feh swaybg ranger \
  alacritty lazygit atuin ttf-hack-nerd pacman-contrib trash-cli httpie zoxide eza bat starship nodejs rofi unzip \
  neovim-nightly-bin polkit-kde-agent thorium-browser-bin diskonaut dust base-devel tldr --noconfirm --needed
```

### AMD Drivers | Optional

```bash
yay -S mesa amd-ucode xf86-video-amdgpu xf86-video-ati mesa-vdpau libva-vdpau-driver libvdpau-va-gl libva-mesa-driver vulkan-radeon --noconfirm --needed
```

### Audio Packages | Optional

```bash
yay -S pavucontrol wireplumber pipewire pipewire-pulse gst-plugin-pipewire pipewire-jack libpulse pulseaudio pipewire-alsa alsa-utils \
 alsa-firmware pipewire-audio alsamixer pulseaudio-bluetooth pulseaudio-equalizer --noconfirm --needed
```
