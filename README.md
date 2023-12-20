# DotFiles

My Hyprland dotfiles.

![HomeScreen](./screenshots/screenshot.png)

## Setup

- **Window Manager:** [Hyprland](https://hyprland.org/)

- **Shell:** [Fish](https://github.com/fish-shell/fish-shell)

- **App Launcher:** [Rofi](https://github.com/davatorium/rofi)

- **Terminal:** [Alacritty](https://github.com/alacritty/alacritty)

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
yay -Syu neofetch firefox yt-dlp grim slurp hyprland-git copyq mpv gnome-keyring fish wf-recorder luarocks xclip gdu cpufetch gpg-tui jq jless difftastic zellij hyprpicker swaylock-effects \
  waybar xdg-desktop-portal-hyprland unclutter brightnessctl btop dunst fd fzf github-cli network-manager-applet \
  networkmanager-dmenu-git xidlehook nm-connection-editor npm noto-fonts-emoji noto-fonts noto-fonts-extra picom tree-sitter \
  ttf-droid ttf-hack ttf-jetbrains-mono ttf-meslo-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common \
  ttf-nerd-fonts-symbols-mono wireplumber zsh go arc-gtk-theme git papirus-icon-theme thunar bluez bluez-utils ripgrep cliphist feh swaybg ranger \
  alacritty lazygit atuin ttf-hack-nerd pacman-contrib trash-cli httpie zoxide eza bat starship nodejs rofi unzip \
  neovim-nightly-bin polkit-kde-agent diskonaut dust base-devel tldr --noconfirm --needed
```

### AMD Drivers | Optional

```bash
yay -S mesa amd-ucode xf86-video-amdgpu xf86-video-ati mesa-vdpau libva-vdpau-driver libvdpau-va-gl libva-mesa-driver vulkan-radeon --noconfirm --needed
```

### Audio Packages | Optional

```bash
yay -S pavucontrol pulsemixer wireplumber pipewire jack2 pulseaudio pipewire-alsa alsa-utils \
 alsa-firmware pipewire-audio pulseaudio-bluetooth pulseaudio-equalizer pulseaudio-jack --noconfirm --needed
```
