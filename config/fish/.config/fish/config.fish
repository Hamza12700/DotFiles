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

# Ocaml
source /home/hamza/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# Golang Bin Directory
set -gx PATH /home/hamza/go/bin $PATH

if status --is-interactive
    # Zoxide
    zoxide init fish | source
    # Starship Prompt
    starship init fish | source
    # Atuin
    atuin init fish | source

    # KeyBinds
    bind \cz "zi; commandline -f repaint"
    bind -k nul "commandline -f accept-autosuggestion"
    bind \cf "fd -t file -E '.git|node_modules' . | fzf --preview 'bat --color always {}' --bind 'enter:become(nvim {})'"
    bind \eH "cd -; commandline -f repaint"

    # Abbreviations
    abbr -a gg lazygit
    abbr -a yi yay -S
    abbr -a yq yay -Q
    abbr -a yr yay -R
    abbr -a ys yay -Ss
    abbr -a rm trash
    abbr -a ip ip --color=auto
    abbr -a cat bat
    abbr -a gprod "go build -ldflags '-w -s'"
    abbr -a reload source ~/.config/fish/config.fish

    # Alias
    alias ls="eza -la --group-directories-first"
    alias vim="nvim"

end

# opam configuration
source /home/hamza/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
