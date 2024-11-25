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

# Start Zellij
if [ -z "$ZELLIJ" ] && [ -z "$ZELLIJ_PROMPTED" ]; then
  read "resp?Start ZelliJ? (Y/n) "
  resp=${resp:-Y}
  export ZELLIJ_PROMPTED=1

  if [[ $resp =~ ^[Yy]$ ]]; then
    zellij list-sessions || true
    read "resp?Session Name: "
    if [[ $resp =~ ^[0-9]+$ ]]; then
      zellij attach --index "${resp}"
    else
      zellij attach -c "${resp:-unnamed}"
    fi
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

if ! command -v pbcopy &>/dev/null; then
  alias pbcopy="xclip -selection clipboard"
fi

export VISUAL="nvim"
export EDITOR=$VISUAL
alias e='$EDITOR'
alias v='$VISUAL'
alias nv="nvim"

alias g=git
alias G=git
alias vg='$EDITOR -c "normal 1 go"'
alias vf='$EDITOR -c "normal 1 fR"'

alias q=exit
alias x=exit
alias so=source

alias currentmillis='date +%s%3N'

alias tolower="tr '[:upper:]' '[:lower:]'"
alias toupper="tr '[:lower:]' '[:upper:]'"
alias randint='echo $((RANDOM % 10))'

if command -v eza &>/dev/null; then
  alias ls='eza --classify --group-directories-first --git --git-repos'
fi
alias ll='ls -lA'
alias lt='ls --tree'

if command -v bat &>/dev/null; then
  alias cat=bat
  alias less=bat
fi

command -v code &>/dev/null || alias code='codium'

install_yapx_zsh_completion() {
  $1 --print-shell-completion zsh | grep -v '\--print-shell-completion' | sudo tee /usr/local/share/zsh/site-functions/_$1
}

export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='--bind alt-a:select-all,alt-d:deselect-all,tab:toggle+down,shift-tab:toggle --layout=reverse --preview-window=bottom,40%,border-top --highlight-line'
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --border=none --preview-window=hidden"
export _ZO_EXCLUDE_DIRS="$HOME:/tmp:/var/*:/mnt/*"
export _ZO_MAXAGE=1000

export STARSHIP_CONFIG="$HOME/.config/starship.toml"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgreprc"
export GIT_CLIFF_CONFIG="$HOME/.config/git-cliff/cliff.toml"
export EGET_CONFIG="$HOME/.config/eget/config.toml"
export YAMLFIX_CONFIG_PATH="$HOME/.config/yamlfix"

alias act-up='DOCKER_HOST="unix:///var/run/user/$(id -u)/podman/podman.sock" act --workflows .gitea/workflows --defaultbranch $(git config --global --get init.defaultBranch) --container-daemon-socket "unix:///var/run/user/$(id -u)/podman/podman.sock" --container-options="--pid=host --privileged" --bind'

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

if [ -d "$HOME/.zsh/forgit" ]; then
  export FORGIT_NO_ALIASES=1 FORGIT_FZF_DEFAULT_OPTS='--preview-window=bottom,60%,border-top'
  source ~/.zsh/forgit/forgit.plugin.sh
  export PATH="$PATH:$FORGIT_INSTALL_DIR/bin"
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

  if [ ! -z "$ZELLIJ" ]; then
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

# starship
eval "$(starship init zsh)"
# zoxide
eval "$(zoxide init zsh)"
# direnv
eval "$(direnv hook zsh)"
# # pipx
# eval "$(register-python-argcomplete pipx)"

if command -v kubectl &>/dev/null; then
  alias kc='kubectl'
  source <(kubectl completion zsh)
fi

if [ -n "$ZELLIJ" ]; then
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
fi

## Custom stuff
curl-ping() {
  while true; do
    printf "%s " $(date +%T)
    curl -sIL -m 1 ${1:?} | grep '^HTTP'
    sleep ${2:-1s}
  done
}

touch-all() {
  find $(pwd) -exec touch -a -m -t "$(date '+%Y%m%d')0500.00" "{}" +
}

alias md2html="pandoc --from=gfm --to=html --standalone --self-contained"

webm2gif() {
  ffmpeg -y -i "$1" -vf palettegen _tmp_palette.png
  ffmpeg -y -i "$1" -i _tmp_palette.png -filter_complex paletteuse -r 10 "${1%.webm}.gif"
  rm _tmp_palette.png
}

cam-ls() {
  gphoto2 --auto-detect && v4l2-ctl --list-devices
}

cam-init() {
  (sudo modprobe --first-time v4l2loopback exclusive_caps=1 max_buffers=2 || true) &&
    (pkill -f gphoto2 || true) &&
    gphoto2 --stdout autofocusdrive=1 --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 ${1:-/dev/video2}
}

cam-view() {
  vlc v4l2://${1:-/dev/video2}
}

dns-restart() {
  sudo sed -i "s/^#*\s*DNSStubListener=.*/DNSStubListener=no/g" '/etc/systemd/resolved.conf' &&
    sudo systemctl restart systemd-resolved &&
    resolvectl flush-caches
}

dns-ls() {
  grep -i '^[a-z]\+=' '/etc/systemd/resolved.conf'
}

dns-set() {
  ping -c1 $1 >/dev/null &&
    sudo sed -i "s/^#*\s*DNS=.*/DNS=${1}/g" '/etc/systemd/resolved.conf' &&
    dnsrestart
}

dns-rm() {
  sudo sed -i "s/^#*\s*DNS=/#DNS=/g" '/etc/systemd/resolved.conf' &&
    dnsrestart
}

new-secret() {
  # https://www.authelia.com/docs/configuration/secrets.html
  LENGTH="${1:-64}"
  CHAR_CLASS="${2:-[:alnum:][:punct:]}"

  tr -cd "$CHAR_CLASS" </dev/urandom |
    fold -w "${LENGTH}" |
    head -n 1 |
    tr -d '\n'
}

new-secret-alnum() {
  newsecret "$1" "[:alnum:]"
}

new-secret-alnum-lower() {
  newsecret "$1" "[:digit:][:lower:]"
}

tsname() {
  # Prepend the current timestamp to a base name.
  # Optionally, the 1st argument is the base name, else it is a random UUID.
  NAME="${1:-$(uuidgen | tail -c 12)}"
  echo "$(currentmillis)_${NAME}"
}

alias pbtype="xclip -selection clipboard -t TARGETS -o"

cbpaste() {
  OUT_FILE="${1:?}"
  shift
  xclip -selection clipboard $@ -o >"$OUT_FILE"
}

cbpastetype() {
  F_EXT="${1:-tmp}"
  F_TYPE="${2:-text/plain}"
  OUT_PATH="${3}"

  if [ -z "$OUT_PATH" ]; then
    OUT_PATH="$(tsname).${F_EXT}"
  fi

  F_NAME="$OUT_PATH"

  if [ -d "$CBPASTE_DIR" ]; then
    OUT_PATH="${CBPASTE_DIR}/${OUT_PATH}"
  fi

  xclip -selection clipboard -t "$F_TYPE" -o >"$OUT_PATH"

  echo "$OUT_PATH"
}

cbpastepng() {
  cbpastetype 'png' 'image/png' "$1"
}

cbpastebmp() {
  output="$(cbpastetype 'bmp' 'image/bmp' "$1")"
  mogrify -format png "$output" && rm "$output"
  echo "${output%.bmp}.png"
}

cbpastesvg() {
  cbpastetype 'svg' 'text/plain' "$1"
}

b2ls() {
  # List files in bucket.
  b2 ls "$@" "${B2_BUCKET_NAME}"
}

b2lsid() {
  # Given filename, list file id.
  b2ls --long --recursive --version |
    awk -v filename="$1" '{ if ($6 == filename) { print $1 } }'
}

b2rm() {
  # Given filename, remove file.
  b2lsid $@ | xargs b2 delete-file-version
}

b2push() {
  # Upload file to bucket.
  # Optionally, 2nd argument becomes the remote file name.
  b2 file upload "${B2_BUCKET_NAME}" "$1" "${2:-$(basename $1)}"
}

b2pushts() {
  # Upload file to bucket with current timestamp as the filename.
  # Optionally, 2nd argument becomes the suffix of the remote file name.
  b2 file upload "${B2_BUCKET_NAME}" "$1" "$(tsname "${2:-$(basename $1)}")"
}

b2pull() {
  # Given filename, download file.
  b2 file download "b2://${B2_BUCKET_NAME}/$1" "$1"
}

b2cp() {
  # Given filename, download a file, then re-upload it with a new name.
  # The 2nd argument becomes the new remote file name.
  pushd /tmp
  b2pull ${1:?}
  b2push $1 ${2:?}
  rm $1
  popd
}

b2mvts() {
  # Given filename, download a file, then re-upload it with a new name,
  # prefixed with the current timestamp.
  # Optionally, the 2nd argument becomes the suffix of the new remote file name.
  pushd /tmp
  b2pull ${1:?}
  b2pushts $1 $2
  rm $1
  popd
}

b2pushimg() {
  # Assumes the clipboard contains an image (bmp or png),
  # and uploads this image.
  FILE=""
  if pbtype | grep -q 'image/bmp'; then
    FILE="$(cbpastebmp $@)"
  else
    FILE="$(cbpastepng $@)"
  fi
  b2push "$FILE"
}

b2pushsvg() {
  # Assumes the clipboard contains an image (svg),
  # and uploads this image.
  FILE="$(cbpastesvg $@)"
  b2push "$FILE"
}

b2pushall() {
  # Push all files from current directory to remote bucket.
  # Requires that the current directory name be the same as the remote bucket.
  PWD_NAME="$(basename $PWD)"
  B2_BUCKET="${1:-$B2_BUCKET_NAME}"
  [ -z "${1}" ] || shift
  if [ "$PWD_NAME" != "${B2_BUCKET:?}" ]; then
    echo "Current dir name '$PWD_NAME' != '${B2_BUCKET}'; aborting."
  else
    b2 sync "${PWD}" "b2://${B2_BUCKET}" $@
  fi
}
b2pullall() {
  # Pull all files from current directory to remote bucket.
  # Requires that the current directory name be the same as the remote bucket.
  PWD_NAME="$(basename $PWD)"
  B2_BUCKET="${1:-$B2_BUCKET_NAME}"
  [ -z "${1}" ] || shift
  if [ "$PWD_NAME" != "${B2_BUCKET:?}" ]; then
    echo "Current dir name '$PWD_NAME' != '${B2_BUCKET}'; aborting."
  else
    b2 sync "b2://${B2_BUCKET}" "${PWD}" $@
  fi
}
b2mirrorup() {
  # Mirror a local directory to a remote bucket (push, replace newer, and delete extra).
  # Requires that the current directory name be the same as the remote bucket.
  b2pushall "${1}" --replaceNewer --delete $@
}
b2mirrordown() {
  # Mirror a remote bucket to a local directory (push, replace newer, and delete extra).
  # Requires that the current directory name be the same as the remote bucket.
  b2pullall "${1}" --replaceNewer --delete $@
}

##

# if [ -f '.envrc' ]; then
#   direnv allow .
# fi

# # START PROFILING
# zmodload zsh/zprof
# # END PROFILING
# zprof
