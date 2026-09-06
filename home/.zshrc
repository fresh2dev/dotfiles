#!/usr/bin/env zsh

export DOTFILES_TARGET="${DOTFILES_TARGET:-${HOME:?}}"

export ZDOTDIR=${ZDOTDIR:-$DOTFILES_TARGET}
source ${ZDOTDIR}/.zprofile

setopt INTERACTIVE_COMMENTS

################################################################################
################################################################################
################################################################################

# Enables auto-loading of `config.<os>-<arch>.toml`
export MISE_AUTO_ENV=true
export MISE_SKILLS_AUTO_SYNC=true

export MISE_CONFIG_DIR="$DOTFILES_TARGET/.config/mise"

if ! command -v mise &>/dev/null; then
  echo "Installing mise..."
  curl -fsSL https://mise.run | MISE_INSTALL_PATH="$DOTFILES_TARGET/.local/bin/mise" sh
fi
eval "$($DOTFILES_TARGET/.local/bin/mise activate zsh)"

################################################################################
################################################################################
################################################################################

autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit

if command -v atuin &>/dev/null; then
  # "Replace native up arrow more seamlessly"
  # https://github.com/atuinsh/atuin/issues/798#issuecomment-3262253321
  unset HISTFILE
  eval "$(atuin init zsh --disable-up-arrow)"
  fc -R =(atuin search --cmd-only --limit 100)
else
  export HISTFILE="$DOTFILES_TARGET/.zsh_history"
  export SAVEHIST=1000
  export HISTSIZE=1000
  # setopt INC_APPEND_HISTORY
  setopt APPEND_HISTORY
  setopt HIST_FIND_NO_DUPS
  setopt HIST_IGNORE_SPACE
fi

export COLORTERM="truecolor"
export TERM_ORIGINAL="$TERM"
export TERM="xterm-256color"

export HOMEBREW_BREWFILE="$XDG_CONFIG_HOME/brewfile/Brewfile"
if command -v brew &>/dev/null; then
  brew_wrap_path="$(brew --prefix)/etc/brew-wrap"
  if [ -f "$brew_wrap_path" ]; then
    source "$brew_wrap_path"
  fi
fi

if [ -n "$NVIM" ]; then
  alias nvim='nvr -cc split --remote-wait \+"set bufhidden=wipe"'
fi

if ! command -v betterdisplaycli &>/dev/null; then
  x="/Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay"
  if [ -f "$x" ]; then
    alias betterdisplaycli="$x"
  fi
fi

install_yapx_zsh_completion() {
  $1 --print-shell-completion zsh | grep -v '\--print-shell-completion' | sudo tee /usr/local/share/zsh/site-functions/_$1
}

if [ -d "$DOTFILES_TARGET/.zsh/fzf-tab" ]; then
  # disable sort when completing `git checkout`
  zstyle ':completion:*:git-checkout:*' sort false
  # set descriptions format to enable group support
  # NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
  zstyle ':completion:*:descriptions' format '[%d]'
  # set list-colors to enable filename colorizing
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
  zstyle ':completion:*' menu no
  # preview directory's content with `lsd` when completing cd
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
  # custom fzf flags
  # NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
  zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --preview-window=right,66%,border-left
  # To make fzf-tab follow FZF_DEFAULT_OPTS.
  # NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
  zstyle ':fzf-tab:*' use-fzf-default-opts yes
  # switch group using `<` and `>`
  zstyle ':fzf-tab:*' switch-group '<' '>'
  zstyle ':fzf-tab:*' fzf-pad 4
  zstyle ':fzf-tab:*' fzf-min-height 4
  source "$DOTFILES_TARGET/.zsh/fzf-tab/fzf-tab.plugin.zsh"
fi

if command -v fzf &>/dev/null; then
  FZF_CTRL_T_COMMAND= FZF_ALT_C_COMMAND= eval "$(fzf --zsh)"
fi

if [ -d "$DOTFILES_TARGET/.zsh/zsh-autosuggestions" ]; then
  # export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  # export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
  export ZSH_AUTOSUGGEST_HISTORY_IGNORE=" *"
  export ZSH_AUTOSUGGEST_COMPLETION_IGNORE="$ZSH_AUTOSUGGEST_HISTORY_IGNORE"
  source "$DOTFILES_TARGET/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
  # unset ZSH_AUTOSUGGEST_USE_ASYNC
fi

if [ -d "$DOTFILES_TARGET/.zsh/zsh-syntax-highlighting" ]; then
  source "$DOTFILES_TARGET/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

if ! command -v ghostty &>/dev/null && [ -e "/Applications/Ghostty.app" ]; then
  # On MacOS, create an alias to open ghostty with `ghostty -e <command>` when
  # outside of a ghostty terminal.
  alias ghostty='open -na Ghostty.app --args '
fi

eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
# source <(kubectl completion zsh)

# if [ -z "$ZED_TERM" ] \
#     && [ -z "$ZELLIJ_SESSION_NAME" ] \
#     && [ -z "$NVIM" ]
# then
#   zellij -l welcome \
#     --config-dir "${ZELLIJ_CONFIG_DIR:?}" \
#     --data-dir "${ZELLIJ_CONFIG_DIR}/plugins" \
#     --config "${ZELLIJ_CONFIG_DIR}/config.kdl"
#   exit $?
# fi
