# DotFiles

My Hyprland dotfiles.

![HomeScreen](./screenshots/screenshot.png)

## Setup

- **Window Manager:** [Hyprland](https://hyprland.org/)

- **Shell:** [Fish](https://github.com/fish-shell/fish-shell)

- **Terminal:** [Foot](https://codeberg.org/dnkl/foot)

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
