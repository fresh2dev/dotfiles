# Apply with `brew bundle --file ~/.Brewfile`

# Set arguments for all 'brew install --cask' commands.
cask_args appdir: "~/Applications", require_sha: true

brew "curl"
brew "wget"
brew "eget"
brew "zsh"
brew "vim"
brew "eza"
brew "btop"
brew "neovim"

brew "kubernetes-cli"
brew "helm"
brew "skopeo"

brew "renovate"

brew "ffmpeg"
brew "pandoc"
brew "lychee"
brew "sshpass"
brew "openssl@3"
brew "yt-dlp"

brew "figlet"
brew "boxes"
brew "lolcat"

brew "lua-language-server"
brew "universal-ctags"

brew "podman" unless system "podman", "--version"

cask "alacritty"
cask "podman-desktop"
cask "neovide"
cask "gitup"

cask "angry-ip-scanner"
cask "db-browser-for-sqlite"
cask "pinta"
cask "obs"
cask "ticktick"
cask "vlc"
# cask "upscayl"
cask "cool-retro-term"

brew "xclip" if OS.linux?
brew "coreutils" if OS.mac?

cask "vmware-fusion" if OS.mac?
cask "hyperkey" if OS.mac?
cask "little-snitch" if OS.mac?
cask "paletro" if OS.mac?
cask "keycastr" if OS.mac?
cask "pearcleaner" if OS.mac?
cask "alfred" if OS.mac?
cask "scroll-reverser" if OS.mac?
cask "lunar" if OS.mac?
# https://librewolf.net/docs/faq/#why-is-librewolf-marked-as-broken
cask "librewolf", args: {'no-quarantine': true} if OS.mac?
