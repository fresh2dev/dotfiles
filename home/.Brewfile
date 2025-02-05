# Create a brewfile with:
# brew bundle dump [--file ...]

# Install apps with:
# brew bundle install --upgrade --file ~/.Brewfile

# Sync apps with:
# brew bundle check --file ~/.Brewfile

# Sync apps with:
# brew bundle cleanup [--force] --file ~/.Brewfile

# Manually reinstall with:
# brew reinstall -f [--cask --appdir '~/Applications'] <app-name>

tap "buo/cask-upgrade"

# Set arguments for all 'brew install --cask' commands.
cask_args appdir: "~/Applications" if OS.mac?

brew "go@1.23"

brew "rustup"
# `rustup default stable`
# `ln -s $(dirname $(rustup which cargo))/* "${CARGO_HOME:-~/.cargo}/bin/"`

brew "curl"
brew "wget"
brew "zsh"
brew "vim"
brew "neovim"

brew "kubernetes-cli"
brew "helm"
brew "skopeo"
# TODO: vault-cli

brew "renovate"

brew "ffmpeg"
brew "pandoc"
brew "sshpass"
brew "openssl@3"

brew "figlet"
brew "boxes"
brew "lolcat"

brew "lua-language-server"
brew "universal-ctags"

cask "angry-ip-scanner"
cask "db-browser-for-sqlite"
cask "pinta"
cask "obs"
cask "obsidian"
cask "ticktick"
cask "transmission"
cask "vlc"
cask "cool-retro-term"
cask "mullvadvpn"

cask "font-im-writing-nerd-font"

cask "lm-studio"
cask "jan"

# cask "ollama"
# Expose server with:
# (On Mac)
# `launchctl setenv OLLAMA_HOST "0.0.0.0:11434"`
# (On Linux)
# `systemctl edit ollama.service`
# [Service]
# Environment="OLLAMA_HOST=0.0.0.0:11434"

if OS.linux?
    brew "xclip"

    brew "podman" unless system "podman", "--version"
    cask "podman-desktop"

elsif OS.mac?
    brew "mas"

    brew "coreutils"

    cask "orbstack"
    cask "boltai"
    # cask "ollamac"

    cask "vmware-fusion"
    # cask "karabiner-elements"  # Removed in favor of `SuperKey`
    cask "keycastr"
    cask "pearcleaner"

    cask "scroll-reverser"

    cask "orion"

    # https://librewolf.net/docs/faq/#why-is-librewolf-marked-as-broken
    # cask "librewolf", args: {'no-quarantine': true} if OS.mac?

    cask "amethyst"
    cask "alt-tab"
    cask "stats"

    # Licensed MacOS apps:
    cask "airbuddy"
    cask "bartender"
    cask "cleanshot"
    cask "clop"
    cask "daisydisk"
    cask "dropshare"
    cask "keyboard-maestro"
    cask "keycue"
    cask "macwhisper"
    cask "mountain-duck"
    cask "recut"
    cask "superkey"
    # cask "hyperkey"
    # cask "little-snitch"
    # cask "lunar"
    # cask "paletro"

    mas "Amphetamine", id: 937984704
    mas "Bitwarden", id: 1352778147
    # mas "GarageBand", id: 682658836
    # mas "HazeOver", id: 430798174
    mas "iMovie", id: 408981434
    mas "Keynote", id: 409183694
    mas "MySudo", id: 1237892621
    # mas "Noir", id: 1592917505
    # mas "Numbers", id: 409203825
    # mas "Pages", id: 409201541
    mas "PhotoMill", id: 778590574
    mas "PhotoSweeper", id: 463362050
    # mas "Playlisty for Apple Music", id: 1459275972
    mas "Presentify", id: 1507246666
    mas "Prodrafts", id: 1545810067
    mas "WireGuard", id: 1451685025
end
