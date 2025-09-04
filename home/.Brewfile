# Create a brewfile with:
# brew bundle dump [--file ...]

# Install apps with:
# brew bundle install --upgrade --file ~/.Brewfile

# Sync apps with:
# brew bundle cleanup [--force] --file ~/.Brewfile

# Manually reinstall with:
# brew reinstall -f [--cask --appdir '~/Applications'] <app-name>

tap "buo/cask-upgrade"

# Set arguments for all 'brew install --cask' commands.
cask_args appdir: "~/Applications" if OS.mac?

brew "go@1.25"
brew "dotnet@9"
brew "node@24"

brew "rustup"
# `rustup default stable`
# rustup component add rust-analyzer
# rustup component add rustfmt
# `ln -sf $(dirname $(rustup which cargo))/* "${CARGO_HOME:-~/.cargo}/bin/"`
# `rustup update`

brew "curl"
brew "wget"
brew "zsh"
brew "vim"
brew "neovim"

cask "vscodium"

cask "alacritty"
# cask "ghostty"
cask "neovide-app"

brew "kubernetes-cli"
brew "helm"
brew "skopeo"

# brew "renovate"

brew "mpv"
cask "vlc"
brew "ffmpeg"
cask "losslesscut"
cask "obs"

brew "exiftool"
brew "pandoc"
brew "sshpass"
brew "openssl@3"

brew "zola"
brew "cloudflare-wrangler"

brew "figlet"
brew "boxes"
brew "lolcat"

# brew "marp-cli"

# brew "gemini-cli"

brew "lua-language-server"
brew "universal-ctags"

cask "angry-ip-scanner"
cask "db-browser-for-sqlite"
cask "pinta"

cask "obsidian"
cask "ticktick"
cask "cool-retro-term"
cask "mullvadvpn"
cask "mullvad-browser"

cask "transmission"
cask "mediaelch"
# cask "filebot", args: {'no-quarantine': true}
# cask "musicbrainz-picard"
# brew "czkawka"

# brew "mkcert"
# brew "nss"

# cask "ollama"
# Expose server with:
# (On Mac)
# `launchctl setenv OLLAMA_HOST "0.0.0.0:11434"`
# (On Linux)
# `systemctl edit ollama.service`
# [Service]
# Environment="OLLAMA_HOST=0.0.0.0:11434"

cask "font-fira-code-nerd-font"
cask "font-fira-mono-nerd-font"
cask "font-meslo-lg-nerd-font"
cask "font-go-mono-nerd-font"
cask "font-hack-nerd-font"
cask "font-im-writing-nerd-font"
cask "font-jetbrains-mono-nerd-font"
cask "font-roboto-mono-nerd-font"
cask "font-sauce-code-pro-nerd-font"
cask "font-ubuntu-mono-nerd-font"
cask "font-ubuntu-nerd-font"
cask "font-ubuntu-sans-nerd-font"

if OS.linux?
    brew "xclip"

    brew "podman" unless system "podman", "--version"
    # cask "podman-desktop"

elsif OS.mac?

    brew "mas"

    brew "coreutils"

    brew "duti"
    # ```sh
    # // Video formats
    # duti -s com.colliderli.iina public.mpeg all
    # duti -s com.colliderli.iina public.avi all
    # duti -s com.colliderli.iina public.mov all
    # duti -s com.colliderli.iina com.apple.quicktime-movie all
    # duti -s com.colliderli.iina public.mpeg-4 all

    # // Audio formats
    # duti -s com.colliderli.iina public.mp3 all
    # duti -s com.colliderli.iina public.wav all
    # duti -s com.colliderli.iina public.aiff all
    # duti -s com.colliderli.iina public.m4a all
    # duti -s com.colliderli.iina com.apple.m4a-audio all
    # duti -s com.colliderli.iina public.audio all
    #
    # // Text formats
    # duti -s com.neovide.neovide public.plain-text all
    # duti -s com.neovide.neovide public.text all
    # duti -s com.neovide.neovide public.xml all
    # duti -s com.neovide.neovide public.json all
    # duti -s com.neovide.neovide public.markdown all
    # duti -s com.neovide.neovide public.python-script all
    # duti -s com.neovide.neovide public.javascript-source all
    # duti -s com.neovide.neovide public.ruby-script all
    # duti -s com.neovide.neovide public.go-source all
    # duti -s com.neovide.neovide public.rust-source all
    # duti -s com.neovide.neovide public.c-source all
    # duti -s com.neovide.neovide public.c-plus-plus-source all
    # duti -s com.neovide.neovide public.swift-source all
    # duti -s com.neovide.neovide public.java-source all
    # duti -s com.neovide.neovide public.shell-script all
    # ```

    cask "iina"

    cask "balenaetcher"

    # cask "openinterminal"
    # cask "openinterminal-lite"
    # defaults write wang.jianing.app.OpenInTerminal-Lite LiteDefaultTerminal Alacritty

    # cask "macfuse"
    # brew "pkg-config"

    cask "orbstack"
    # `ln -s ~/.orbstack/bin/* ~/.local/bin/`

    # cask "lm-studio"
    cask "msty"

    cask "leader-key"

    # cask "macsyzones"

    # cask "transnomino"

    # cask "TheBoredTeam/boring-notch/boring-notch", args: {'no-quarantine': true}

    cask "vmware-fusion"
    # cask "karabiner-elements"  # Removed in favor of `SuperKey`
    cask "keycastr"
    cask "pearcleaner"

    cask "scroll-reverser"

    # https://librewolf.net/docs/faq/#why-is-librewolf-marked-as-broken
    # cask "librewolf", args: {'no-quarantine': true}
    # cask "floorp", args: {'no-quarantine': true}
    cask "vivaldi"
    # cask "zen-browser"
    # cask "orion"

    # cask "amethyst"
    # cask "alt-tab"
    # cask "stats"

    # brew "kopia"

    # cask "deskpad"
    # cask "monitorcontrol"

    cask "raycast"

    # cask "brilliant"

    # cask "dropbox"

    # Licensed MacOS apps:
    cask "quakenotch"
    cask "cloudmounter"
    cask "netspot"
    # cask "betterdisplay"
    cask "airbuddy"
    cask "bitwarden"
    # cask "bartender"
    cask "cleanshot"
    # cask "commander-one"
    cask "clop"
    cask "daisydisk"
    cask "dropshare"
    # cask "keyboard-maestro"
    # cask "keycue"
    # cask "mission-control-plus"
    cask "macwhisper"
    # cask "mountain-duck"
    cask "recut"
    cask "superkey"
    cask "swish"
    cask "unite"
    # cask "qspace-pro"
    # cask "hyperkey"
    # cask "little-snitch"
    # cask "lunar"
    # cask "paletro"
    # cask "forklift"
    # ```sh
    # Replace Finder with Forklift:
    # ref: https://binarynights.com/manual#fileviewer
    # defaults write -g NSFileViewer -string com.binarynights.ForkLift;
    # defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add '{LSHandlerContentType="public.folder";LSHandlerRoleAll="com.binarynights.ForkLift";}'
    # Quit finder:
    # defaults write com.apple.finder "QuitMenuItem" -bool "true" && killall Finder
    # ```

    # mas "Amphetamine", id: 937984704
    # mas "Bitwarden", id: 1352778147
    # # mas "GarageBand", id: 682658836
    # # mas "HazeOver", id: 430798174
    # # mas "iMovie", id: 408981434
    # # mas "Keynote", id: 409183694
    # mas "MySudo", id: 1237892621
    # # mas "Noir", id: 1592917505
    # # mas "Numbers", id: 409203825
    # # mas "Pages", id: 409201541
    # mas "PhotoMill", id: 778590574
    # mas "PhotoSweeper", id: 463362050
    # # mas "Playlisty for Apple Music", id: 1459275972
    # mas "Presentify", id: 1507246666
    # mas "Prodrafts", id: 1545810067
    # mas "WireGuard", id: 1451685025
end
