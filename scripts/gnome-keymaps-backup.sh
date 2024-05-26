#!/usr/bin/env bash

action="$1"
out_dir="${2:-./gnome-keymaps}"

if [ "$action" = "backup" ]; then
  rm -rf $out_dir
  mkdir -p $out_dir
  dirs=(
    "/org/gnome/shell/keybindings/"
    "/org/gnome/desktop/wm/keybindings/"
    "/org/gnome/mutter/keybindings/"
    "/org/gnome/mutter/wayland/keybindings/"
    "/org/gnome/settings-daemon/plugins/media-keys/"
    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/"
  )

  for dir in "${dirs[@]}"; do
    # out_file=$(basename "$dir")
    out_file=${dir#/}         # Remove leading slash
    out_file=${out_file%/}    # Remove trailing slash
    out_file=${out_file////_} # Replace inner slash with dash
    out_file="$out_dir/${out_file}.dconf"
    echo dconf dump "$dir" \> "$out_file"
    dconf dump "$dir" >"$out_file"
  done
  dconf read '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings' >"$out_dir/.org_gnome_settings-daemon_plugins_media-keys_custom-keybindings_keys.dconf"

elif [ "$action" = "restore" ]; then
  mkdir -p $out_dir
  for file in "$out_dir/"*.dconf; do
    original_dir="$(basename "$file")"
    # Replace dashes with slashes in the filename
    # Assumes no leading/trailing slashes
    original_dir="${original_dir//_/\/}"
    # Remove the extension
    original_dir="${original_dir%.*}"
    # Load the key mappings from the file
    echo dconf load "/$original_dir/" \< "$file"
    dconf reset -f "/$original_dir/"
    dconf load "/$original_dir/" <"$file"
  done
  dconf write '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings' "$(cat "$out_dir/.org_gnome_settings-daemon_plugins_media-keys_custom-keybindings_keys.dconf")"

  # Install these gnome extensions
  command -v gext &>/dev/null || pipx install -f gnome-extensions-cli
  LC_ALL=C.UTF-8 gext install 'stopwatch@aliakseiz.github.com' 'tactile@lundal.io'
else
  echo "usage: backup|restore [dir]"
fi
