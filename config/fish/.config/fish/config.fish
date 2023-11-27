# Abbreviations
abbr -a gg lazygit
abbr -a yi yay -S
abbr -a ys yay -Ss
abbr -a rm trash
abbr -a ip ip --color=auto
abbr -a cat bat
abbr -a gprod go build -ldflags "-w -s"
abbr -a reload source ~/.config/fish/config.fish

# Alias
alias ls="eza -la --icons --group-directories-first"

# Disabling the greeting message
set fish_greeting

# Gloable Variables
set -U EDITOR nvim

# Cargo Bin Directory
set -gx PATH /home/hamza/.cargo/bin $PATH

# Bun
set -gx BUN_INSTALL $HOME/.bun
set -gx PATH $BUN_INSTALL/bin $PATH

# LunarVim
set -gx PATH /home/hamza/.local/bin/lvim $PATH

# Pnpm
set -gx PATH /home/hamza/.local/share/pnpm $PATH

# Golang Bin Directory
set -gx PATH /home/hamza/go/bin $PATH

# KeyBinds
bind \cz "zi; commandline -f repaint" # [Ctrl + z] - zoxide fizzy finder
bind -k nul "commandline -f accept-autosuggestion" # [Ctrl + space] - accept-autosuggestion

if status --is-interactive
    # Zoxide
    zoxide init fish | source

    # Starship Prompt
    starship init fish | source
end