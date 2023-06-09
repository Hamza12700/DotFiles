
# StarShip
eval "$(starship init zsh)"

setopt autocd
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^ ' autosuggest-accept

# Completions
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# You need this if you're using vscode to authentic
# See https://code.visualstudio.com/docs/editor/settings-sync#_linux
export $(dbus-launch)

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it

# Aliases
alias ll='exa -la --icons --group-directories-first'
alias ls='exa -la --icons --group-directories-first'
alias cat='bat'
alias ip='ip --color=auto'
alias spi='sudo pacman -S'
alias yi='yay -S'
alias gst='git status'
alias gpl='git pull'
alias gph='git push'
alias rm='trash'
alias reload='source ~/.zshrc'
alias lg='lazygit'

# Useful function
take() {
  mkdir -p $1
  cd $1
}

# LunarVim
export PATH=/home/hamza/.local/bin:$PATH

# Pnpm
export PNPM_HOME="/home/hamza/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Zoxide
eval "$(zoxide init zsh)"
# Atuin
eval "$(atuin init zsh)"

# Zplug
source $HOME/.zplug/init.zsh

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
  echo
fi

zplug "zsh-users/zsh-autosuggestions"
zplug "b4b4r07/zplug-cd"
zplug "b4b4r07/zplug-rm"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"

zplug load
