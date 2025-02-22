# Disabling the greeting message
set fish_greeting

# Gloable Variables
set -gx EDITOR nvim

# Cargo Bin Directory
set -gx PATH /home/hamza/.cargo/bin $PATH

# Bun
set -gx BUN_INSTALL $HOME/.bun
set -gx PATH $BUN_INSTALL/bin $PATH

# LunarVim
set -gx PATH /home/hamza/.local/bin $PATH

# Pnpm
set -gx PATH /home/hamza/.local/share/pnpm $PATH
set -gx PNPM_HOME /home/hamza/.local/share/pnpm

# FlyCTL
set -gx FLYCTL_INSTALL /home/hamza/.fly
set -gx PATH $FLYCTL_INSTALL/bin $PATH

set -gx TERM xterm-256color

# Ocaml
source /home/hamza/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# Golang Bin Directory
set -gx PATH /home/hamza/go/bin $PATH

if status --is-interactive
    # Zoxide
    zoxide init fish | source
    # Starship Prompt
    starship init fish | source

    # KeyBinds
    bind \cz "zi; commandline -f repaint"
    bind -k nul "commandline -f accept-autosuggestion"
    bind \cf "fd -t file -E '.git|node_modules' . | fzf --preview 'bat --color always {}' --bind 'enter:become(nvim {})'"
    bind \eH "cd -; commandline -f repaint"
    bind \cb "btop"

    # Abbreviations
    abbr -a gg lazygit
    abbr -a yi yay -S
    abbr -a yq yay -Q
    abbr -a yr yay -R
    abbr -a pS yay -Ss
    abbr -a rm drash
    abbr -a ip ip --color=auto
    abbr -a cat bat
    abbr -a reload source ~/.config/fish/config.fish
    abbr -a gs git st
    abbr -a ga git add

    # Alias
    alias ls="eza -la --group-directories-first"
    alias vim="nvim"
    alias vi="nvim"

end

# opam configuration
source /home/hamza/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
