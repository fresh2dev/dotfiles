#!/usr/bin/env zsh

# export HISTFILE= HISTSIZE=0 SAVEHIST=0
export HISTFILE=~/.zsh_history
export SAVEHIST=1000
export HISTSIZE=1000
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE

# Disable C-S freezing
# https://unix.stackexchange.com/a/12108
stty -ixon
# stty erase '^?'

# Fixes "Delete" key action in Alacritty.
# ref: https://github.com/alacritty/alacritty/issues/3494#issuecomment-601664944
bindkey "^[[3~" delete-char

export TERM="xterm-256color"

if [ -n "$NVIM" ]; then
  alias nvim='nvr -cc split --remote-wait \+"set bufhidden=wipe"'
fi
export VISUAL=nvim
export EDITOR=nvim

if [ -z "$ZELLIJ_SESSION_NAME" ] \
  && [ -z "$ZELLIJ_PROMPTED" ] \
  && [ -z "$NVIM" ] \
  && [ -z "$VSCODE_INJECTION" ] \
  && [ "$TERM_PROGRAM" != "QuakeNotch" ]
then
  export ZELLIJ_PROMPTED=1

  local choice
  local sessions
  sessions=$(zellij list-sessions --no-formatting 2>/dev/null || true)

  local create_default="unnamed"
  local create_none="<None>"
  local create_new="<New>"

  choice=$( (echo "$create_default"; echo "$create_none"; echo "$create_new"; echo "$sessions") | gum choose --header="Zellij Session" )

  if [ "$choice" = "$create_none" ]; then
    choice=""
  elif [ "$choice" = "$create_new" ]; then
    choice=$(gum input --placeholder "New Session Name")
    choice="${choice:-$create_default}"
  fi

  if [ -n "$choice" ]; then
    zellij attach -c "$choice"
    exit
  fi
fi

# if command -v devbox &>/dev/null; then
#   eval "$(devbox global shellenv --init-hook)"
# fi
#

alias devbox-recompute='eval "$(devbox global shellenv --recompute)"'
alias devbox-edit='$EDITOR $(devbox global path)'
alias devbox-cleanup='devbox run -- nix store gc --extra-experimental-features nix-command'

alias e=$EDITOR
alias v=$VISUAL
alias vq='$VISUAL -c "cbuffer | copen | wincmd p | bdelete! | cc"'

alias vg='$EDITOR -c "normal 1 go"'
alias v0='$EDITOR -c "normal 1 0"'
alias fs='$EDITOR -c "normal 1 fs"'
alias ff='$EDITOR -c "normal 1 ff"'
alias fr='$EDITOR -c "normal 1 fr"'

alias g=git
alias G=git
alias q=exit
alias x=exit
alias so=source

alias zj=zellij
alias lg=lazygit

alias currentmillis='echo $(($(date +%s) * 1000))'

alias tolower="tr '[:upper:]' '[:lower:]'"
alias toupper="tr '[:lower:]' '[:upper:]'"
alias randint='echo $((RANDOM % 10))'

if command -v eza &>/dev/null; then
  alias ls='eza --classify --group-directories-first --git --git-repos'
fi
alias l='ls -a1'
alias ll='ls -lA'
alias lt='ls --tree'

if command -v bat &>/dev/null; then
  alias cat=bat
fi

if command -v gum &>/dev/null; then
  alias pause='gum confirm "Continue?"'
  alias less='gum pager'
  export PAGER='less'
fi

if ! command -v pbcopy &>/dev/null; then
  alias pbcopy="xclip -selection clipboard"
fi

if command -v viddy &>/dev/null; then
  alias watch="viddy"
fi

if ! command -v code &>/dev/null; then
  if command -v cursor &>/dev/null; then
    alias code='cursor'
  elif command -v codium &>/dev/null; then
    alias code='codium'
  fi
fi

if ! command -v betterdisplaycli &>/dev/null; then
  for prefix in "$HOME" ""; do
    x="${prefix}/Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay"
    if [ -f "$x" ]; then
      alias betterdisplaycli="$x"
      break
    fi
  done
fi

# # enter an interactive chat conversation using mods
# if command -v mods &>/dev/null; then
#   alias ai='mods --ask-model --editor'
#
#   alias ai-roles='mods --list-roles'
#   alias ai-config='mods --settings'
#
#   ai-models() {
#     yq -r ".apis[].models[].aliases[0]" "$(mods --dirs | grep 'Configuration:' | cut -d' ' -f2-)/mods.yml"
#   }
#
#   ai-chat() {
#     # pick a model alias from your config
#     model=$(ai-models | gum choose --header "Select a model:")
#
#     if [ -n "$model" ]; then
#       # Continue conversation.
#       while mods --model "$model" --prompt-args --editor --continue-last && gum confirm 'Continue chat?'; do :; done
#     fi
#   }
# fi

alias ai='aider --model $(aider --list-models "openrouter" | grep "/" | cut -d" " -f2- | fzf) --watch'

install_yapx_zsh_completion() {
  $1 --print-shell-completion zsh | grep -v '\--print-shell-completion' | sudo tee /usr/local/share/zsh/site-functions/_$1
}

export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='--bind alt-a:select-all,alt-d:deselect-all,ctrl-n:down,ctrl-p:up,ctrl-y:toggle-down,ctrl-space:toggle-down --layout=reverse'
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --border=none"
export _ZO_EXCLUDE_DIRS="$HOME:/tmp:/var/*:/mnt/*"
export _ZO_MAXAGE=1000

export STARSHIP_CONFIG="$HOME/.config/starship.toml"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgreprc"
export GIT_CLIFF_CONFIG="$HOME/.config/git-cliff/cliff.toml"
export EGET_CONFIG="$HOME/.config/eget/config.toml"
export YAMLFIX_CONFIG_PATH="$HOME/.config/yamlfix"
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/theme.yml"

if command -v podman &>/dev/null; then
  alias act-up='DOCKER_HOST="unix:///var/run/user/$(id -u)/podman/podman.sock" act --workflows .gitea/workflows --defaultbranch $(git config --global --get init.defaultBranch) --container-daemon-socket "unix:///var/run/user/$(id -u)/podman/podman.sock" --container-options="--pid=host --privileged" --bind --container-architecture linux/amd64'
else
  alias act-up='act --workflows .gitea/workflows --defaultbranch $(git config --global --get init.defaultBranch) --container-options="--pid=host --privileged" --container-architecture linux/amd64'
fi

# add devbox bits to zsh
fpath+=($DEVBOX_GLOBAL_PREFIX/share/zsh/site-functions $DEVBOX_GLOBAL_PREFIX/share/zsh/$ZSH_VERSION/functions $DEVBOX_GLOBAL_PREFIX/share/zsh/vendor-completions)
autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit

if [ -d "$HOME/.zsh/fzf-tab" ]; then
  # disable sort when completing `git checkout`
  zstyle ':completion:*:git-checkout:*' sort false
  # set descriptions format to enable group support
  # NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
  zstyle ':completion:*:descriptions' format '[%d]'
  # set list-colors to enable filename colorizing
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
  zstyle ':completion:*' menu no
  # preview directory's content with eza when completing cd
  if command -v eza &>/dev/null; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
  fi
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
  source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
fi

FZF_CTRL_T_COMMAND= FZF_ALT_C_COMMAND= eval "$(fzf --zsh)"

if [ -d "$HOME/.zsh/zsh-autosuggestions" ]; then
  # export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  # export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
  export ZSH_AUTOSUGGEST_HISTORY_IGNORE=" *"
  export ZSH_AUTOSUGGEST_COMPLETION_IGNORE="$ZSH_AUTOSUGGEST_HISTORY_IGNORE"
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
  # unset ZSH_AUTOSUGGEST_USE_ASYNC
fi

if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

if [ -d "$HOME/.zsh/zsh-vi-mode" ]; then
  # Change to Zsh's default readkey engine
  ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
  ZVM_VI_SURROUND_BINDKEY=classic
  ZVM_LAZY_KEYBINDINGS=false
  source "$HOME/.zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

  function zsh_exit() {
    exit
  }
  function zsh_zellij_focus_up() {
    zellij action move-focus up
  }
  function zsh_zellij_focus_down() {
    zellij action move-focus down
  }
  function zsh_zellij_focus_left() {
    zellij action move-focus left
  }
  function zsh_zellij_focus_right() {
    zellij action move-focus right
  }

  zvm_define_widget zsh_exit
  zvm_define_widget zsh_zellij_focus_up
  zvm_define_widget zsh_zellij_focus_down
  zvm_define_widget zsh_zellij_focus_left
  zvm_define_widget zsh_zellij_focus_right
  zvm_define_widget _atuin_search

  zvm_after_init_commands+=('zvm_bindkey vicmd "q^M" zsh_exit')

  zvm_after_init_commands+=('zvm_bindkey vicmd "^R" _atuin_search')
  zvm_after_init_commands+=('zvm_bindkey viins "^R" _atuin_search')

  if [ -n "$ZELLIJ_SESSION_NAME" ]; then
    zvm_after_init_commands+=('zvm_bindkey vicmd "^K" zsh_zellij_focus_up')
    zvm_after_init_commands+=('zvm_bindkey vicmd "^J" zsh_zellij_focus_down')
    zvm_after_init_commands+=('zvm_bindkey vicmd "^H" zsh_zellij_focus_left')
    zvm_after_init_commands+=('zvm_bindkey vicmd "^L" zsh_zellij_focus_right')
    zvm_after_init_commands+=('zvm_bindkey viins "^K" zsh_zellij_focus_up')
    zvm_after_init_commands+=('zvm_bindkey viins "^J" zsh_zellij_focus_down')
    zvm_after_init_commands+=('zvm_bindkey viins "^H" zsh_zellij_focus_left')
    zvm_after_init_commands+=('zvm_bindkey viins "^L" zsh_zellij_focus_right')
  fi
fi

if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"

  function zo() {
    result="$(zoxide query --interactive -- "$@")" \
      && pushd $result \
      && (zellij action new-tab --layout default --name "$(basename "$result")" || true) \
      && popd
  }
fi


if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
  if [ -f '.envrc' ]; then
    direnv allow .
  fi
fi

if command -v kubectl &>/dev/null; then
  alias kc='kubectl'
  source <(kubectl completion zsh)
fi

if [ -n "$ZELLIJ_SESSION_NAME" ]; then
  # If in a Zellij instance...
  # On `cd`, set the Zellij tab name to the name of the git root or `pwd`.
  set_zellij_tab_name() {
    THIS_REPO="$(basename $(git rev-parse --show-toplevel 2>/dev/null || pwd))"
    if [ "$THIS_REPO" != "$LATEST_REPO" ] || [ "$1" = "-f" ]; then
      zellij action rename-tab "$THIS_REPO"
      LATEST_REPO="$THIS_REPO"
    fi
  }
  add-zsh-hook chpwd set_zellij_tab_name
  # Also, run it now.
  set_zellij_tab_name
fi

##

# # START PROFILING
# zmodload zsh/zprof
# # END PROFILING
# zprof
